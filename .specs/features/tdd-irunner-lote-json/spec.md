# IRunner por lote com contexto implicito e JSON

**Status:** Implementacao incremental local autorizada. Gates funcionais no ERP pendentes.
**Metodo:** TLC Spec Driven, complexidade Complex: ciclo multiunit, estado compartilhado, UI financeira e persistencia parcial.

## Problem Statement

A casca executa um caso escolhido pela descricao. STARTED recarrega o conjunto e o piloto recarrega um caso fixo, duplicando o ciclo. Um loop simples pode perder o cursor, reutilizar historico e aplicar dados do caso errado. Precisamos centralizar o lote e limitar a fixture ao comportamento financeiro, reutilizando os helpers JSON existentes.

## Goals

- [ ] Uma chamada a Interpretar e uma carga de casos por par modulo/area.
- [ ] Uma tentativa identificada por ID para cada caso elegivel, em ordem crescente de ID.
- [ ] Fixture consome JSON do caso e não depende de configuração padrão ou datasets duplicados.
- [ ] Historico e ticks separados por tentativa, com limpeza sob falhas.
- [ ] Validacoes JSON operacionais sem implementar asserts.

## Out of Scope

| Feature | Reason |
| --- | --- |
| Asserts, comparacao esperada/obtida e METRICAS_ASSERTS | Outro desenvolvedor e responsavel |
| Aprovacao funcional a partir de SUCESSO | Sem asserts, somente execucao operacional e observavel |
| Multiplas fixtures selecionadas pelos registros | Nao existe contrato de dispatch nos seis arquivos; uma fixture atende ao par |
| Paralelismo e transporte de objetos entre interpretacoes | O objetivo exige um fluxo compartilhado sequencial |
| Retry e rollback de operacoes financeiras | Repeticao pode duplicar ou baixar titulos novamente |
| Publicacao no ERP e mudancas de schema além da renomeação autorizada do campo de logs | Migration de renomeação preparada localmente; execução externa não realizada |
| Novos metodos ou remocao de outros metodos | Usuario exige aceite previo; autorizou ExecutarLote na casca, renomear AddUsesUnit para SetTDDUnit, remover AddMetodo e remover Setup/ExecutarFluxoCompletoFinanceiro do piloto |
| Novo seletor de etapas no JSON | O usuario autorizou remover todas as constantes de etapa; o plano nao recria esse seletor |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Universo de casos | Somente ATIVO_CT = 'S' no modulo/area exatos | Usuario escolheu a opcao recomendada | Sim |
| Falha individual | Continuar apos finalizacao e restauracao bem-sucedidas; abortar se o estado essencial ficar inseguro | Usuario escolheu a opcao recomendada | Sim |
| Dispatch | Uma unit definida por SetTDDUnit; Teste fixo para cada JSON | Usuario aprovou contrato de unit unica com entrada automatica | Sim |
| Entrada | Dois literais Pascal em AddParamsRun: modulo e area | Elimina filtro por descricao mantendo a convencao do chamador atual | Sim |
| Metodos de fixture | Somente Teste, sem parametros; preparacao comum permanece em STARTED | Usuario autorizou retirar Setup do piloto e exige reaproveitamento implicito | Sim, correcao do usuario |
| Novos metodos | Somente ExecutarLote(modulo, area) na casca; demais ajustes nos metodos existentes | Usuario autorizou expressamente um unico metodo para deixar Main com uma chamada | Sim |
| Constantes do piloto | Remover modulo/area/caso, tipos 0/1 e todas as etapas/cEtapaAtual listadas pelo usuario | Contexto generico vem do fluxo; nao recriar dependencia por aliases locais | Sim |
| Sequencia financeira | Teste executa as quatro operacoes em ordem; sem selecao local de etapas | Remocao de cEtapaAtual elimina o seletor; refatoracao autorizada com fluxo completo | Sim |
| Duplicidade de nomes de area | Resolver por modulo e descricao da area; erro em ambiguidade no mesmo modulo | AREA possui MODULO_AREA no modelo | Nao, proposta |
| Parametros do sistema | Capturar baseline, aplicar overrides por caso e restaurar ao termina-lo | Liberacao de CDS nao desfaz UPDATE no ERP | Nao, proposta |
| Sem casos | Lote vazio com resumo ZERO_CASOS, sem historico ficticio | Nao existe FK para uma tentativa de caso inexistente | Nao, proposta |
| Persistencia | Manter schema; uma insercao de historico por tentativa; sem retry | Evita duplicacao quando ticks falham depois do historico | Nao, proposta |
| Status de historico | Reusar SUCESSO/FALHA e validar spelling de incompatibilidade antes de implementar | Codigo usa VERSAO_INCOMPATIVEL; MER cita INCOMPATIVEL_VERSAO | Nao, contrato real a provar em T1 |
| Helpers JSON | Manter assinaturas publicas; provar tipos/conversoes; normalizar somente por parser aceito no host | Wrappers escondem falhas, Currency e comportamento do host exigem prova | Nao, condicao tecnica em T1/T5 |
| Memoria | Objetos do lote nascem na interpretacao gerada e sao consumidos nela | Pedido confirma contexto implicito; nao comprova identidade entre invocacoes | Parcial: conceito confirmado, prova em T1 |
| Free e nil | Nao impor semantica Delphi comum; usar Assigned e rotinas existentes sem novos flags de vida | Documento historico afirma customizacao, mas nao ha prova atual | Nao, prova em T1 |
| EMPRESA_DUP | Exigir inteiro positivo e igual a Codigo_Empresa_Atual; nao trocar empresa automaticamente | Piloto valida tag mas nao a aplica; evitar executar em empresa diferente | Nao, proposta conservadora |
| TIPODOC_DUP | Exigir inteiro positivo, como ValidarCasoTeste atual | Preserva a regra atual; fallback TIPO_FINCONFIG nao substitui requisito obrigatorio | Nao, proposta |
| Titulos financeiros | Validar em massa dedicada por caso; nao ampliar filtros nem baixar titulos alheios | Borderos atuais selecionam todos os titulos encontrados da pessoa | Nao, condicao de homologacao |

**Open questions:** none - cada ambiguidade tem default, justificativa e estado acima. Defaults nao sao aprovacoes; provas tecnicas pendentes bloqueiam o gate funcional correspondente.

## User Stories

### P1: Executar o conjunto completo

**User Story:** Como executor, quero executar o conjunto de casos do modulo/area na mesma interpretacao, com identificacao de cada tentativa.

**Acceptance Criteria**:
1. WHEN Executar recebe configuracao valida THEN the IRunner SHALL chamar Interpretar exatamente uma vez. (LOTE-01)
2. WHEN a interpretacao inicia o lote THEN the runner SHALL carregar exatamente uma vez os casos ativos do par resolvido. (LOTE-02)
3. WHILE o estado essencial permanece seguro, WHEN o lote possui N casos elegiveis THEN the casca SHALL iniciar uma tentativa por ID, em ordem crescente, sem repetir ID. (LOTE-03)
4. WHILE um caso esta em execucao the fixture SHALL manter inalterados conteudo, indice e posicao de CDSCasosTestes. (LOTE-04)
5. WHEN STARTED prepara uma tentativa THEN the STARTED SHALL obter ID, descricao, JSON e requisito do registro corrente sem buscar por descricao ou recarregar casos. (LOTE-05)
6. IF uma area nao pertence ao modulo informado THEN the runner SHALL rejeitar o par antes de executar qualquer fixture. (LOTE-06)
7. IF o par valido nao possui casos ativos THEN the runner SHALL emitir resumo ZERO_CASOS sem criar historico de caso. (LOTE-07)

**Independent Test:** Prova nativa com tres IDs, duas descricoes iguais e JSONs distintos; observar um Interpretar, uma carga e sequencia dos tres IDs.

### P1: Reutilizar o fluxo na fixture

**User Story:** Como autor de uma fixture, quero receber o contexto pronto e executar somente preparacao especifica e Teste.

**Acceptance Criteria**:
1. WHEN o caso e apto THEN the casca SHALL chamar STARTED antes de Teste obrigatorio. (LOTE-08)
2. IF STARTED falha THEN the casca SHALL impedir Teste naquele caso. (LOTE-09)
3. WHEN Teste financeiro inicia THEN the piloto SHALL usar FCasoTesteAtualJson sem depender de CDSConfiguracao, criar CDS de caso/configuracao ou chamar CarregarCasoTeste. (LOTE-10)
4. WHEN Teste financeiro executa THEN the piloto SHALL executar duplicata receber, duplicata pagar, bordero receber e bordero pagar nesta ordem. (LOTE-11)
5. WHEN a refatoracao do piloto e aplicada THEN the piloto SHALL remover exatamente os uses, constantes e metodos autorizados e preservar os demais metodos, sem adicionar novos. (LOTE-12)
6. IF a validacao financeira falha THEN the piloto SHALL sinalizar excecao operacional antes de qualquer gravacao financeira. (LOTE-13)
7. WHEN o caso financeiro encerra THEN the piloto SHALL tentar cancelar edicoes e fechar telas que utilizou sem liberar forms, DMs ou CDS pertencentes ao ERP. (LOTE-14)

**Independent Test:** Configurar a unit com SetTDDUnit, sem AddMetodo ou Setup; observar contexto correto. Comparar inventario de metodos antes/depois: somente Setup e ExecutarFluxoCompletoFinanceiro podem desaparecer. Provar sequencia financeira e falha obrigatoria sem gravacao.

### P1: Consumir JSON com contrato conhecido

**User Story:** Como mantenedor do piloto, quero reutilizar FUNCOES_JSON sem confundir dado ausente com erro de leitura.

**Acceptance Criteria**:
1. WHEN uma leitura tipada opcional ocorre THEN the piloto SHALL usar ValorInteiroTag ou ValorCurrencyTag com JSON, tag e default, sem parser Pos/Copy local. (LOTE-15)
2. IF o JSON raiz e vazio, malformado ou nao e objeto THEN the STARTED SHALL rejeitar o caso antes de aplicar parametros ou executar a fixture. (LOTE-16)
3. WHEN EMPRESA_DUP e TIPODOC_DUP sao lidos THEN the piloto SHALL exigir inteiros positivos, sem default capaz de transformar ausente ou invalido em valor valido. (LOTE-17)
4. IF EMPRESA_DUP difere de Codigo_Empresa_Atual THEN the piloto SHALL impedir a execucao financeira desse caso. (LOTE-18)
5. IF PESSOA_DUP, VALOR_DUP, GRUPORESULTADO_DUPGR ou CONTA_BORD estão ausentes, inválidos ou zerados THEN the piloto SHALL levantar exception antes das operações financeiras, sem fallback de configuração. (LOTE-19)
6. IF parametros esta presente e nao e objeto THEN the STARTED SHALL rejeitar o caso antes de alterar parametros do ERP. (LOTE-20)
7. WHEN parametros possui pares validos THEN the STARTED SHALL reutilizar VerificarParametros e os helpers GetPairName/GetPairValue existentes. (LOTE-21)

**Independent Test:** Prova com JSON compacto e formatado equivalentes, valores 1234.56 e 0, tag ausente, string invalida, false e objeto parametros invalido. Esperados numericos sao definidos no design.

### P1: Isolar e finalizar tentativas

**User Story:** Como executor, quero historico e diagnostico por caso e continuidade somente com contexto restaurado.

**Acceptance Criteria**:
1. WHEN uma tentativa comeca THEN the runner SHALL zerar historico, requisito, erro, metodo, etapa e metricas da tentativa anterior. (LOTE-22)
2. WHEN o requisito de versao esta vazio THEN the STARTED SHALL retornar True. (LOTE-23)
3. WHEN existe requisito de versao THEN the STARTED SHALL copiar o requisito normalizado para o historico atual. (LOTE-24)
4. IF a versao e incompativel THEN the runner SHALL finalizar a tentativa como incompatibilidade sem chamar a fixture. (LOTE-25)
5. WHEN uma tentativa possui ID valido THEN the FINISHED SHALL capturar FLogsCasoTeste.Text em LogsProcessamento antes de inserir exatamente um histórico vinculado a esse ID usando LOGS_PROCESSAMENTO_HE. (LOTE-26)
6. IF a persistencia falha apos criar historico THEN the FINISHED SHALL informar ID conhecido e fase da falha sem repetir a insercao. (LOTE-27)
7. IF a finalizacao falha THEN the runner SHALL propagar a exception para interromper o lote, sem acumuladores de erros secundarios. (LOTE-28)
8. WHEN uma tentativa termina THEN the runner SHALL restaurar os parametros modificados ao baseline do lote antes de iniciar a seguinte. (LOTE-29)
9. IF um caso falha e a restauracao/limpeza essencial termina com sucesso THEN the casca SHALL tentar o proximo ID. (LOTE-30)
10. IF nao e possivel restaurar o contexto essencial THEN the casca SHALL encerrar o lote com IDs restantes explicitamente nao tentados. (LOTE-31)
11. WHEN o lote termina THEN the runner SHALL chamar os métodos de limpeza existentes em sequência com try/except único, propagando a primeira falha e interrompendo as chamadas seguintes. (LOTE-32)
12. WHEN o lote encerra THEN the runner SHALL emitir totais carregados, tentados e nao tentados no log de processamento. (LOTE-33)

**Independent Test:** Caso B falha entre A/C; C recebe seu proprio JSON, erro vazio e parametros baseline. Injetar falha de restauracao em B: C consta como nao tentado. Falha de persistencia interrompe antes de C no fluxo simplificado aprovado.

### P1: Gerar codigo repetivel

**User Story:** Como chamador, quero configurar a fixture e iniciar uma geracao valida, inclusive na segunda execucao.

**Acceptance Criteria**:
1. IF a lista de parametros nao esta disponivel ou nao possui dois itens THEN the IRunner SHALL rejeitar a configuracao antes de Interpretar. (LOTE-34)
2. WHEN uma unit valida e configurada por SetTDDUnit THEN the IRunner SHALL gerar exatamente uma chamada fixa a Teste dentro de Run, sem registro de metodos. (LOTE-35)
3. WHEN Executar monta a casca THEN the IRunner SHALL substituir os marcadores de unit, parametros e chamada usando o fluxo original de TStringList e Troca. (LOTE-36)
4. WHEN a geracao termina ou falha THEN the IRunner SHALL liberar todas as suas listas inclusive parametros, permitindo configuracao nova sem residuos. (LOTE-37)
5. WHEN Executar monta os argumentos THEN the IRunner SHALL usar FParamsCasosTeste.CommaText e a substituicao original de virgulas por virgula e espaco. (LOTE-38)

**Independent Test:** Gerar duas vezes com pares distintos; entradas invalidas produzem zero chamadas a Interpretar e nao contaminam a configuracao seguinte.

## Edge Cases

Descricoes duplicadas nao identificam tentativas: ID e a chave. Nao fazer recarga durante o loop. Caso sem ID valido gera diagnostico de infraestrutura, sem historico com FK inventada. Falha de finalizacao, incluindo tick final, propaga exception e interrompe o lote. Callback que falha nao impede outras liberacoes. Alteracoes de cadastro depois da carga ficam para o proximo lote. Reexecucao financeira nao e idempotente; nao executar automaticamente como recuperacao.

## Implicit Requirement Dimensions

| Dimension | Resolution |
| --- | --- |
| Input validation & bounds | LOTE-06, 16 a 20, 34 a 36; uma fixture, dois parametros e Teste unico |
| Failure / partial-failure states | LOTE-09, 13, 25 a 28, 30 a 33 |
| Idempotency / retry / duplicate handling | LOTE-03, 27, 37; retry financeiro N/A porque nao pertence ao escopo |
| Auth boundaries & rate limits | N/A porque nao ha nova autenticacao, endpoint ou permissao; permanece a sessao do BI |
| Concurrency / ordering | LOTE-01, 03, 04, 08, 29; sequencial e mesma interpretacao |
| Data lifecycle / expiry | LOTE-14, 22, 29, 32, 37; retencao historica N/A porque schema nao muda |
| Observability | LOTE-24 a 28 e 33; ID/metodo/fase em logs por tentativa |
| External-dependency failure | LOTE-27 a 32; ODBC, parametros, callbacks e UI |
| State-transition integrity | LOTE-08, 09, 16, 20, 25, 29 a 31 |

## Requirement Traceability

| Requirement ID | Story | Phase | Status | Tasks |
| --- | --- | --- | --- | --- |
| LOTE-01 | Lote | Tasks | Pending | T11, T12 |
| LOTE-02 | Lote | Tasks | Pending | T2, T3, T9 |
| LOTE-03 | Lote | Tasks | Pending | T9 |
| LOTE-04 | Lote | Tasks | Pending | T7, T9, T10 |
| LOTE-05 | Lote | Tasks | Pending | T7 |
| LOTE-06 | Lote | Tasks | Pending | T2 |
| LOTE-07 | Lote | Tasks | Pending | T3, T9 |
| LOTE-08 | Fixture | Tasks | Pending | T9, T11 |
| LOTE-09 | Fixture | Tasks | Pending | T9 |
| LOTE-10 | Fixture | Tasks | Pending | T10 |
| LOTE-11 | Fixture | Tasks | Pending | T10 |
| LOTE-12 | Fixture | Tasks | Pending | T10 |
| LOTE-13 | Fixture | Tasks | Pending | T10 |
| LOTE-14 | Fixture | Tasks | Pending | T10 |
| LOTE-15 | JSON | Tasks | Pending | T5, T10 |
| LOTE-16 | JSON | Tasks | Pending | T5, T7 |
| LOTE-17 | JSON | Tasks | Pending | T10 |
| LOTE-18 | JSON | Tasks | Pending | T10 |
| LOTE-19 | JSON | Tasks | Pending | T10 |
| LOTE-20 | JSON | Tasks | Pending | T7 |
| LOTE-21 | JSON | Tasks | Pending | T4, T7 |
| LOTE-22 | Estado | Tasks | Pending | T6 |
| LOTE-23 | Estado | Tasks | Pending | T7 |
| LOTE-24 | Estado | Tasks | Pending | T7 |
| LOTE-25 | Estado | Tasks | Pending | T7, T9 |
| LOTE-26 | Estado | Tasks | Pending | T8 |
| LOTE-27 | Estado | Tasks | Pending | T8 |
| LOTE-28 | Estado | Tasks | Pending | T6, T9 |
| LOTE-29 | Estado | Tasks | Pending | T4, T9 |
| LOTE-30 | Estado | Tasks | Pending | T9 |
| LOTE-31 | Estado | Tasks | Pending | T9 |
| LOTE-32 | Estado | Tasks | Pending | T3, T6, T9 |
| LOTE-33 | Estado | Tasks | Pending | T9 |
| LOTE-34 | Geracao | Tasks | Pending | T11, T12 |
| LOTE-35 | Geracao | Tasks | Pending | T11 |
| LOTE-36 | Geracao | Tasks | Pending | T11 |
| LOTE-37 | Geracao | Tasks | Pending | T11 |
| LOTE-38 | Geracao | Tasks | Pending | T11 |

**Coverage:** 38 requisitos, 38 mapeados, zero sem tarefa. T1 prova premissas de todos; T13 documenta o contrato. Nenhum requisito esta Verified.

## Success Criteria

- [ ] Tres IDs elegiveis produzem tres tentativas distintas, uma carga e um Interpretar.
- [ ] Falha no segundo caso nao reutiliza seus dados no terceiro; falha de restauracao impede terceiro e o identifica.
- [ ] Historicos/ticks pertencem aos IDs corretos e persistencia parcial fica visivel.
- [ ] JSON valido equivalente produz mesmos valores compactado ou formatado; invalido nao executa financeiro.
- [ ] Piloto nao duplica carregamento/ciclo e nao implementa asserts.
- [ ] Evidencias nativas cobrem todos os requisitos e casos de falha antes da conclusao funcional.
