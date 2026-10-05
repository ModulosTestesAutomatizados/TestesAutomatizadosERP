# TDD IRunner MVP Specification

**Status:** Implementacao local autorizada pelo usuario e realizada. Validacao de runtime pendente para revisao no ERP.
**Metodo:** TLC Spec Driven. Escopo multiunit com contrato, estado, concorrencia e persistencia.

## Problem Statement

O IRunner gera uma casca interpretada para centralizar o ciclo dos testes. O piloto financeiro ainda repete carregamento do caso e controle de fluxo e deixa caminhos de falha interromperem a limpeza. O MVP deve consumir o caso ja preparado por STARTED e executar apenas a implementacao financeira variavel, com diagnostico e encerramento verificaveis.

## Goals

- [ ] Executar STARTED uma vez antes da preparacao e do teste financeiro.
- [ ] Executar todos os casos ativos encontrados para o modulo e a area informados.
- [ ] Restringir o registro de metodos ao contrato Setup/Teste.
- [ ] Remover o segundo carregamento do caso no piloto.
- [ ] Tentar toda a limpeza prevista mesmo quando o teste ou a finalizacao falhar.
- [ ] Limpar os CDS globais, o cache e os parametros uma vez ao final do lote.
- [ ] Conservar a causa original da falha e identificar a operacao correspondente.
- [ ] Manter as quatro operacoes financeiras e o seletor de etapas existente.

## Out of Scope

| Feature | Reason |
| --- | --- |
| Implementar ASSERTS ou sua persistencia | Responsabilidade de outro desenvolvedor, conforme usuario |
| Afirmar aprovacao funcional sem ASSERTS | O escopo verifica o ciclo operacional; sucesso funcional depende da integracao externa |
| Compartilhar objetos com a thread principal | Interpretar executa em outra thread, conforme usuario |
| Acrescentar atribuicoes := nil | Dispensadas pelo interpretador do ERP, conforme usuario |
| Substituir a convencao de literais com aspas simples por QuotedStr | Convencao atual mantida |
| Retry automatico ou rollback de operacoes financeiras | A limpeza de objetos nao desfaz duplicatas e borderos gravados |
| Novas tabelas, migracoes ou publicacao no ERP | Planejamento local; implementacao e publicacao sao etapas posteriores |
| Executor de multiplas fixtures, classes ou callbacks novos | Desnecessarios para integrar o piloto |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Thread de Interpretar | Estado de STARTED, runner e piloto pertence a interpretacao gerada | Usuario informou isolamento da thread principal | Sim |
| Liberacao de referencias | Free sem atribuicao posterior de nil | Particularidade explicitada pelo usuario | Sim |
| Literais dos parametros | AddParamsRun recebe texto com aspas Pascal, como '''FINANCEIRO''' | Preserva a entrada corrigida pelo usuario | Sim |
| Sintaxe de metodos aceitos | O IRunner aceita somente Setup ou Teste; para esta fixture registra-se apenas Teste; prefixo documental {UNIT.} permitido | STARTED ja carrega o caso antes de invocar a fixture | Sim |
| Cardinalidade do piloto | Um metodo Teste aplicado a cada caso ativo da mesma area | Os dados do banco mostram casos distintos por modulo/area, que devem passar pela mesma casca | Sim |
| Preparacao financeira | Teste chama CarregarConfiguracoes e usa CDSConfiguracao compartilhado | A unit P39_TDD_CASOS_DE_TESTE fornece esse CDS e o carregador por modulo | Sim |
| Vida dos recursos financeiros | Reutilizar CDS globais; nao criar ou clonar CDS de caso/configuracao no piloto; limpeza geral pertence ao runner | Mantem acoplamento intencional do fluxo | Sim, conforme correcao do usuario |
| Fronteira de units do teste | Sem `uses` explicito de TDD_RUNNER ou TDD_STARTED no piloto; a unit base fornece o contexto por heranca do `uses` fixo de TDD_RUNNER | Particularidade do ambiente de interpretacao compartilhado | Sim |
| Politica do lote | Tentar todos os casos; registrar falhas individualmente; limpar o estado compartilhado depois do ultimo caso | Um caso com falha nao deve impedir os seguintes nem liberar CDS ainda em uso | Sim |
| Operacao inicial incompleta | Sem ID valido de caso, nao tentar inserir historico vinculado; expor erro e liberar recursos | Evita nova falha de persistencia mascarando a falha de carregamento | Nao: proposta para manter esquema atual |
| Persistencia parcial | Sem retry automatico; informar falha e ID do historico se ja criado | Evita duplicar historicos ou repetir operacoes financeiras | Nao: proposta conservadora |
| Interface futura de ASSERTS | Preservar os pontos de resultado existente ate alinhar consumo com o responsavel | Remover o CDS local nao autoriza eliminar o contrato de resultado | Nao: coordenacao externa pendente, registrada como limite |
| Validacao de runtime | Executar cenarios no interpretador nativo antes de declarar implementacao verificada | Nao foi localizado comando de testes automatizado dessas units no workspace | Nao: definir acesso/comando antes de Execute |

**Open questions:** none - todas as ambiguidades possuem default e justificativa na tabela acima. As linhas marcadas Nao continuam propostas a confirmar, nao decisoes aprovadas.

## User Stories

### P1: Registrar e executar um caso com contrato limitado

**User Story:** Como autor do piloto financeiro, quero registrar somente Teste e consumir o estado global preparado pelo fluxo para que apenas a implementacao do caso varie.

**Why P1:** Define a fronteira do MVP e impede continuar usando ExecutarFluxoCompletoFinanceiro como entrada registrada.

**Acceptance Criteria**:

1. WHEN Executar recebe uma fixture que registra Teste THEN the IRunner SHALL gerar chamadas na ordem STARTED, Teste, ponto existente de ASSERTS e finalizacao. (IRUN-01)
2. IF um registro de metodo nao corresponde a Setup ou Teste THEN the IRunner SHALL rejeitar o registro antes de chamar Interpretar. (IRUN-02)
3. IF um registro contem apenas Setup/Teste como substring de outro identificador THEN the IRunner SHALL rejeitar o registro. (IRUN-03)
4. IF a lista contem zero ou mais de um metodo THEN the IRunner SHALL rejeitar a configuracao antes de Interpretar. (IRUN-04)
5. IF a lista de parametros nao contem exatamente dois literais nao vazios (modulo e area) THEN the IRunner SHALL rejeitar a configuracao antes de Interpretar. (IRUN-05)
6. IF CodificacaoUnit retorna casca vazia ou a geracao conserva um dos tres marcadores conhecidos THEN the IRunner SHALL rejeitar o codigo antes de Interpretar. (IRUN-06)
7. WHEN a geracao termina ou falha THEN the IRunner SHALL liberar as listas de units, metodos, parametros, montagem e codigo criadas nessa geracao. (IRUN-07)

**Independent Test:** Fixture de prova sem operacoes financeiras registra a sequencia em log; entradas invalidas nao alcancam o marcador de Interpretar.

### P1: Preparar o financeiro sem duplicar STARTED

**User Story:** Como mantenedor do piloto, quero reutilizar o caso carregado para reduzir responsabilidades repetidas sem perder a configuracao financeira.

**Why P1:** O piloto deve funcionar depois da substituicao da entrada monolitica por uma chamada Teste, preservando o ciclo geral existente.

**Acceptance Criteria**:

1. WHEN STARTED seleciona o caso THEN the piloto SHALL consumir o JSON desse mesmo caso na mesma interpretacao, sem chamar CarregarCasoTeste novamente. (IRUN-08)
2. WHEN Teste financeiro comeca THEN the piloto SHALL carregar FINANCEIRO_CONFIGURACAO em CDSConfiguracao e usar esse CDS global para os valores de fallback. (IRUN-09)
3. IF a configuracao financeira esta vazia ou as tags obrigatorias EMPRESA_DUP e TIPODOC_DUP sao invalidas THEN the piloto SHALL sinalizar falha e impedir as operacoes financeiras. (IRUN-10)
4. WHEN o fluxo geral executa TearDown THEN the fluxo SHALL liberar os CDS globais de caso e configuracao. (IRUN-11)
5. WHEN Teste executa o fluxo completo THEN the piloto SHALL manter a ordem duplicata a receber, duplicata a pagar, bordero de recebimento, bordero de pagamento. (IRUN-12)
6. WHEN Teste usa uma das quatro etapas individuais existentes THEN the piloto SHALL executar somente a operacao escolhida, preservando as precondicoes atuais dessa etapa. (IRUN-13)
7. WHEN uma operacao financeira termina ou falha THEN the piloto SHALL tentar fechar a tela usada pela operacao sem liberar forms, DMs ou datasets pertencentes ao ERP. (IRUN-14)
8. WHEN o modulo e a area possuem casos ativos THEN the runner SHALL executar o metodo Teste uma vez por registro de CDSCasosTestes. (IRUN-29)
9. IF um caso falha THEN the runner SHALL persistir seu resultado, registrar a falha e continuar os casos restantes. (IRUN-30)
10. WHEN o lote termina ou a carga falha parcialmente THEN the runner SHALL tentar liberar CDS de casos/resultados/configuracao, parametros e cache, acumulando falhas de limpeza. (IRUN-31)

**Independent Test:** Comparar ID/JSON selecionados por STARTED com os consumidos pelo piloto e contar um carregamento de caso. Verificar os oito campos de fallback descritos na revisao do piloto.

### P1: Encerrar com diagnostico mesmo sob falhas

**User Story:** Como executor, quero conhecer a causa do teste e ter os recursos encerrados mesmo quando metricas ou callbacks falham.

**Why P1:** Evita perder o erro original e deixar recursos abertos.

**Acceptance Criteria**:

1. IF um metodo registrado falha THEN the runner SHALL conservar seu nome e sua etapa no diagnostico de falha. (IRUN-15)
2. IF uma operacao cronometrada falha depois do tick inicial THEN the runner SHALL tentar registrar seu tick final. (IRUN-16)
3. IF iniciar metricas, TOTAL ou abrir callback falha THEN the runner SHALL finalizar somente os recursos cujo inicio foi confirmado. (IRUN-17)
4. IF RegistrarTick de encerramento falha THEN the runner SHALL tentar persistir o historico com as metricas disponiveis quando existir ID valido do caso. (IRUN-18)
5. IF persistir metricas ou fechar um callback falha THEN the runner SHALL tentar as demais chamadas de fechamento e a liberacao das metricas. (IRUN-19)
6. IF o teste e a finalizacao falham THEN the runner SHALL expor a mensagem original do teste primeiro e as mensagens de finalizacao depois. (IRUN-20)
7. IF o teste termina e somente a finalizacao falha THEN the runner SHALL expor falha de infraestrutura sem comunicar conclusao operacional limpa. (IRUN-21)
8. WHEN a validacao de versao nao encontra requisito minimo THEN the STARTED SHALL retornar True. (IRUN-22)
9. WHEN existe requisito de versao THEN the STARTED SHALL copiar seu valor normalizado para FHistoricoExecucao.RequisitoVersao. (IRUN-23)
10. IF a versao e incompativel THEN the runner SHALL manter VERSAO_INCOMPATIVEL e impedir a execucao do Teste. (IRUN-24)

**Independent Test:** Fixture de prova falha em Teste, tick final, persistencia e cada fechamento; logs demonstram tentativas de limpeza restantes e ordem das mensagens.

## Edge Cases

- IF os parametros possuem a virgula de um literal THEN the gerador SHALL preservar esse literal sem aplicar substituicao global de virgulas no codigo inteiro. (IRUN-25)
- IF uma execucao falha antes de obter ID valido do caso THEN the runner SHALL emitir o diagnostico sem tentar gravar historico com FK ausente. (IRUN-26)
- IF a persistencia ja criou o historico e falha em uma metrica THEN the runner SHALL informar a persistencia parcial e o ID conhecido sem repetir automaticamente a insercao. (IRUN-27)
- WHEN uma nova execucao e iniciada na mesma sessao THEN the sistema SHALL usar somente os registros e o contexto dessa execucao. (IRUN-28)
- WHEN o lote percorre CDSCasosTestes THEN the runner SHALL preservar o registro corrente enquanto cada caso executa e avancar sem clonar o dataset. (IRUN-32)

## Implicit Requirement Dimensions

| Dimension | Resolution |
| --- | --- |
| Input validation & bounds | IRUN-02 a IRUN-06; nomes exatos e dois parametros; sem interpretacao de expressao arbitraria em AddMetodo |
| Failure / partial-failure states | IRUN-10, IRUN-14 a IRUN-21, IRUN-26 e IRUN-27 |
| Idempotency / retry / duplicate handling | IRUN-04 e IRUN-27; retry e rollback financeiros fora do escopo |
| Auth boundaries & rate limits | N/A porque nao se cria API, autenticacao ou endpoint; permissao atual do BI permanece |
| Concurrency / ordering | IRUN-01 e IRUN-28; contexto criado na thread interpretada; sem transporte de objetos entre threads |
| Data lifecycle / expiry | IRUN-07, IRUN-11, IRUN-14 e IRUN-19; retencao historica N/A porque esquema e politica nao mudam |
| Observability | IRUN-15 a IRUN-24 e IRUN-27; diferenciar falha do teste e da infraestrutura |
| External-dependency failure | Configuracao, persistencia e callbacks cobertos em IRUN-10, IRUN-17 a IRUN-21 e IRUN-27 |
| State-transition integrity | STARTED precede Teste; caso nao selecionado ou VERSAO_INCOMPATIVEL impede Teste |

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| IRUN-01 | Contrato | Specify | Pending |
| IRUN-02 | Contrato | Specify | Pending |
| IRUN-03 | Contrato | Specify | Pending |
| IRUN-04 | Contrato | Specify | Pending |
| IRUN-05 | Contrato | Specify | Pending |
| IRUN-06 | Contrato | Specify | Pending |
| IRUN-07 | Contrato | Specify | Pending |
| IRUN-08 | Financeiro | Specify | Pending |
| IRUN-09 | Financeiro | Specify | Pending |
| IRUN-10 | Financeiro | Specify | Pending |
| IRUN-11 | Financeiro | Specify | Pending |
| IRUN-12 | Financeiro | Specify | Pending |
| IRUN-13 | Financeiro | Specify | Pending |
| IRUN-14 | Financeiro | Specify | Pending |
| IRUN-15 | Encerramento | Specify | Pending |
| IRUN-16 | Encerramento | Specify | Pending |
| IRUN-17 | Encerramento | Specify | Pending |
| IRUN-18 | Encerramento | Specify | Pending |
| IRUN-19 | Encerramento | Specify | Pending |
| IRUN-20 | Encerramento | Specify | Pending |
| IRUN-21 | Encerramento | Specify | Pending |
| IRUN-22 | Encerramento | Specify | Pending |
| IRUN-23 | Encerramento | Specify | Pending |
| IRUN-24 | Encerramento | Specify | Pending |
| IRUN-25 | Geracao | Specify | Pending |
| IRUN-26 | Encerramento | Specify | Pending |
| IRUN-27 | Encerramento | Specify | Pending |
| IRUN-28 | Reexecucao | Specify | Pending |

**Coverage:** Implementacao local registrada em tasks.md. Nenhum requisito declarado Verified sem evidencia de runtime do ERP. A verificacao estrutural e a revisao independente constam em validation.md.

## Success Criteria

- [ ] Validacao estrutural da spec passa.
- [ ] Escolha de nomes exatos ou familias Setup_/Teste_ confirmada.
- [ ] Um carregamento de caso por execucao financeira integrada.
- [ ] Nenhuma entrada fora do contrato chega a Interpretar.
- [ ] Falha de Setup impede Teste.
- [ ] Falhas de finalizacao nao impedem tentativas restantes de limpeza.
- [ ] Falha original permanece identificavel quando existe falha secundaria.
- [ ] Cenarios executados no ERP possuem evidencias de runtime; analise estatica nao substitui essas evidencias.

## Implementation Roadmap

Esta ordem orienta o proximo planejamento; nao substitui tarefas atomicas aprovadas.

1. Fixar contrato Teste unico e geracao em TDD_IRUNNER, incluindo listas e substituicoes.
2. Ajustar contexto de falha e finalizacao de metricas em TDD_RUNNER.
3. Ajustar captura de erros, inicializacao parcial e limpeza na casca TDD_BASE_UNIT_IRUNNER.
4. Consolidar consumo do caso e requisito de versao em TDD_STARTED.
5. Enxugar o piloto conforme revisao-piloto.md, usando CDS globais de caso e configuracao.
6. Alterar o processamento para registrar somente Teste; verificar integracao e TearDown geral no ERP.

O usuario autorizou implementar somente o MVP nos arquivos locais para revisao posterior. As seis units foram ajustadas, sem publicacao ou alteracao de banco. Sem acesso ao runtime ou comando de testes comprovado, o gate funcional permanece pendente. Nao foram criados commits de tarefas sem gate funcional aprovado.
