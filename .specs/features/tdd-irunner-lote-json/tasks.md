# Tarefas do lote IRunner e JSON

## Execution Protocol

Ativar `tlc-spec-driven` por nome e seguir o fluxo Execute antes de implementar. Se a skill nao puder ser ativada, informar a limitacao e nao executar sem ela. Implementacao incremental local autorizada; tarefas amplas permanecem pendentes dos gates nativos.

Nao criar metodos alem de ExecutarLote(modulo, area), expressamente autorizado pelo usuario para enxugar Main da casca. AddUsesUnit pode ser renomeado para SetTDDUnit e AddMetodo pode sair conforme nova autorizacao; no piloto, somente Setup e ExecutarFluxoCompletoFinanceiro podem sair. Qualquer outra excecao exige pergunta justificada e aceite expresso antes da alteracao. Testes de prova usam ajustes temporarios em copias dos metodos existentes, sem novo metodo de fixture.

Cada tarefa implementada deve carregar seus cenarios de verificacao, passar o gate funcional e incluir rastreabilidade no mesmo commit atomico. Sem runtime do ERP, registrar Pendencia de validacao e nao marcar Verified. Nao publicar scripts, executar operacoes financeiras ou modificar bancos externos por inferencia a partir deste plano. A permissao de consulta ao banco fornecida pelo usuario e somente usada para estudo de metadados/dados nesta etapa.

**Design:** `.specs/features/tdd-irunner-lote-json/design.md`
**Status:** Implementacao incremental iniciada conforme sequencia posterior definida pelo usuario; gates nativos pendentes. Propostas tecnicas e decisoes do usuario registradas em context.md.

**Etapa incremental 02:** desenho Main do lote/Run individual aprovado e aplicado localmente; SetupCasosTestes movido para TDD_RUNNER. Ver etapa-02-orquestracao-lote.md. A etapa cobre parte das responsabilidades T6/T7/T9/T12, sem concluir essas tarefas amplas ou alterar seus gates nativos. Piloto e restauracao de parametros nao integrados ainda.

**Etapa incremental 03:** usuario autorizou ExecutarLote como unico metodo novo; Main agora contem somente essa chamada, o molde conserva duas linhas vazias no topo, RecordCount e usado diretamente no log antes da liberacao e FLotePodeContinuar foi removido. Falhas recuperaveis ficam tratadas em Run; exceptions de estado interrompem ExecutarLote. Testes nativos aguardam instrucao expressa do usuario. Ver etapa-03-main-enxuta.md.

**Sequencia incremental autorizada:** o usuario escolheu iniciar pela separacao de carga/preparacao, em vez de executar imediatamente as 13 tarefas do roteiro amplo. SetupCasoTeste foi renomeado para SetupCasosTestes (modulo/area), Started passou a preparar o registro corrente e a casca recebeu somente a chamada de carga e a selecao transitoria do caso. Ver [etapa-01-carga-preparacao.md](etapa-01-carga-preparacao.md). Esta alteracao atende parte da responsabilidade T7, mas nao conclui T7: normalizacao/validacao JSON completa e provas nativas continuam pendentes. Nenhuma tarefa ampla esta marcada como funcionalmente completa.

**Etapa incremental 06 autorizada:** contrato unit unica (SetTDDUnit/Teste automatico), chamador e piloto. Ordem local T11 -> T12 -> T10. A autorizacao substitui a manutencao anterior de AddMetodo/AddUsesUnit. Gates funcionais permanecem pendentes; nenhum status Verified por inspe??o textual.

## Test Coverage Matrix

Gerada da inspeção das units, de `.agents/AGENTS.md`, da skill interpretador-delphi-erp e de `docs/MER.md`. Nao foi encontrado runner CLI destas units nem testes executaveis de regressao para elas. A validacao prevista e integracao no JvInterpreter nativo, por logs, contagem de chamadas e consulta de historico. Nenhum assert de negocio sera implementado.

| Code Layer | Required Test Type | Coverage Expectation | Location Pattern | Run Command |
| --- | --- | --- | --- | --- |
| Contrato do host | integracao nativa | Seis provas de compatibilidade antes do ciclo | Copias locais dos metodos existentes; evidencias na feature | Execucao manual no BI, sem comando CLI descoberto |
| Cache/casos/parametros | integracao nativa | Todos os cenarios indicados por tarefa, incluindo inicializacao parcial e segunda execucao | Units compartilhadas existentes | Execucao no BI; SELECT de verificacao quando aplicavel |
| Helpers JSON | integracao nativa | Seis grupos de valores/formatos e assinaturas reais | FUNCOES_JSON existente | Execucao no BI de copias de rotinas existentes |
| Runner/STARTED/FINISHED/casca/gerador | integracao nativa | Requisitos mapeados e todos os caminhos de falha listados | Units em Runner existentes | Interpretar via chamador existente no BI |
| Piloto | integracao nativa e revisao de inventario | Remocoes exatas, sequencia financeira e memoria herdada | Piloto existente | Execucao no ERP de homologacao com massa dedicada |
| Documentacao de uses | revisao documental | Grafo coincide com uses e visibilidade provada | `docs/mapeamentoUses/` | Revisao textual e `git diff --check` |

## Gate Check Commands

| Gate Level | When to Use | Command |
| --- | --- | --- |
| Planejamento | Antes de apresentar spec/tarefas | `python <skill-dir>/scripts/validate_spec.py .specs/features/tdd-irunner-lote-json/spec.md --strict` e `python <skill-dir>/scripts/validate_tasks.py .specs/features/tdd-irunner-lote-json/tasks.md --strict` |
| Estrutural | Toda tarefa | `git diff --check` e inventario de metodos/assinaturas com `rg`; nao substitui runtime |
| Nativo | Cada tarefa que altera Pascal | Executar no BI os cenarios definidos na propria tarefa; anexar ID, entrada, sequencia, resultado esperado/observado e log; nenhum comando CLI comprovado |
| Documental | T13 | `git diff --check` e confronto do grafo com uses reais |
| Final funcional | Apos tarefas implementadas | Verificador independente TLC, requisitos por evidencia nativa e sensor em copias isoladas; `validate_state.py` somente quando existir validation.md funcional com evidencias |

`<skill-dir>` e o diretorio retornado por prepare_skill_files da TLC, nao uma pasta scripts deste repositorio. Publicacao ou acesso ao ERP de homologacao deve ser concretizado no inicio da implementacao. Falta de acesso nao permite substituir gate nativo por busca textual.

## Execution Plan

Execucao sequencial; primeiro confirmar contratos tecnicos, depois adaptar infraestrutura existente, integrar ciclo e migrar piloto/chamador. As dependencias abaixo sao obrigatorias. A prova de cada alteracao usa o metodo existente em copia isolada antes de integrar o pacote.

```text
T1 -> T2 -> T3 -> T4 -> T5 -> T6 -> T7 -> T8 -> T9 -> T11 -> T12 -> T10 -> T13
```

13 tarefas, tres fases. Antes de Execute, TLC oferece execucao por agentes para mais de um lote de tarefas; so usar trabalhadores se o usuario aceitar. O verificador independente e etapa final da implementacao, nao deste planejamento. Nao foram criados agentes durante o estudo.

## Task Breakdown

### Phase 1: Contratos e infraestrutura compartilhada

### T1: Registrar provas de compatibilidade do host

**What**: Registrar seis grupos de provas nativas e inventario de consumidores antes de alterar contratos.
**Where**: `.specs/features/tdd-irunner-lote-json/contrato-runtime.md`
**Depends on**: None
**Reuses**: Metodos existentes e fontes do JvInterpreter consultadas por Context7.
**Requirement**: LOTE-01, LOTE-04, LOTE-05, LOTE-12, LOTE-15, LOTE-22, LOTE-29, LOTE-34.
**Tools**: TLC, interpretador-delphi-erp; consulta ao banco dedicado e banco de units com skills correspondentes quando necessaria e autorizada; Context7 para referencias externas.
**Done when**:

- [ ] Seis grupos documentados: (1) mesma identidade de globais nas units irmas sem uses no piloto; (2) nomes reais/local-remoto e qualificacao de Teste; (3) Currency, parse/ToJSON e verificacao de tipo de objeto; (4) Free/Assigned e falha de criacao parcial; (5) baseline/restore de parametros e Relogar; (6) comportamento sincrono/assincrono e contexto de Interpretar.
- [ ] Inventario cobre consumidores locais/remotos de Run, AreaPeloNome, SetupCasoTeste e metodos autorizados a sair; registrar consumidores nao inspecionaveis como limitacao antes de mudar assinatura compartilhada.
- [ ] Conferir no banco o spelling aceito de status de incompatibilidade e os campos de historico/ticks; nao repetir credenciais nos documentos.
- [ ] Registrar evidencia real ou incompatibilidade explicita, sem PASS presumido. Se houver necessidade incontornavel de metodo novo, apresentar pergunta justificada antes da proxima tarefa.

**Tests**: integracao nativa, seis grupos; nenhuma operacao financeira.
**Gate**: Nativo e Estrutural; todos os contratos usados na fase seguinte demonstrados.
**Commit**: `docs(irunner): registrar contratos do interpretador`

### T2: Resolver area dentro do modulo nos metodos existentes

**What**: Ajustar AreaPeloNome e ModuloPeloNome existentes para resolucao inequivoca do cruzamento, preservando assinaturas.
**Where**: `docs/assets/configuracoesGerais/P39_TDD_CACHE.pas`
**Depends on**: T1
**Reuses**: CDSModulos, CDSAreas, MODULO_AREA, AreaPeloNome e Cache_TearDown_LimparInformacoes.
**Requirement**: LOTE-06, LOTE-32.
**Tools**: interpretador-delphi-erp, banco-dedicado; consultas somente de leitura em estudo.
**Done when**:

- [ ] Quatro cenarios: par valido; area pertencente a outro modulo; mesma descricao em modulos diferentes; cache parcialmente inicializado.
- [ ] ModuloPeloNome conserva ID em escalar do cache e AreaPeloNome usa esse escopo, com assinaturas atuais. Consumo legado sem escopo aceita somente descricao globalmente unica; ambiguidade e erro. Nao criar helper ou overload.
- [ ] Limpeza tenta os recursos criados independentemente, conforme prova de vida do host.

**Tests**: integracao nativa, quatro cenarios.
**Gate**: Nativo e Estrutural; cada resultado identifica o ID de area correto ou erro antes da fixture.
**Commit**: `fix(irunner): resolver area pelo modulo no cache existente`

### T3: Reiniciar carga e recursos de casos por lote

**What**: Ajustar inicializacao/carga existentes para evitar dados antigos e permitir lote vazio distinguivel.
**Where**: `docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas`
**Depends on**: T2
**Reuses**: SetModulo/SetArea, CarregarCasosTeste, PreencheInformacoesDataSets e TearDown_Finalizar_CasosTeste.
**Requirement**: LOTE-02, LOTE-07, LOTE-32.
**Tools**: interpretador-delphi-erp, banco-dedicado, tdd-odbc quando houver ajustes de acesso a dados.
**Done when**:

- [ ] Cinco cenarios: tres ativos e um inativo; nova carga de outro par; par vazio; falha ODBC; falha de setup apos criacao de parte dos CDS.
- [ ] Uma carga por lote; CDS de casos/resultados sem residuos; modulo resolvido antes da area; config de modulo sem suporte nao usa SQL antigo.
- [ ] Recursos criados sao identificados e todas as liberacoes elegiveis tentadas.

**Tests**: integracao nativa, cinco cenarios.
**Gate**: Nativo e Estrutural; par vazio nao se confunde com falha ODBC e nao mantem casos antigos.
**Commit**: `fix(irunner): reiniciar datasets na carga do lote`

### T4: Restaurar parametros usando as rotinas existentes

**What**: Ajustar captura do baseline e registro de chaves alteradas para restauracao por AtualizarParametros existente.
**Where**: `docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO.pas`
**Depends on**: T3
**Reuses**: Setup_Inicializar_Parametros, VerificarParametros, CriarEstruturaParametrosAtualizar, AtualizarParametros e TearDown_FinalizarParametros.
**Requirement**: LOTE-21, LOTE-29, LOTE-31, LOTE-32.
**Tools**: interpretador-delphi-erp e tdd-odbc; usar ambiente de homologacao para verificacao futura.
**Done when**:

- [ ] Quatro cenarios: caso A altera booleano/string/numero e B omite; falha parcial durante UPDATE; restauracao falha; nenhum override.
- [ ] Baseline anterior ao primeiro caso e preservado; chaves/valores originais sao guardados antes de escrever.
- [ ] Restore via metodo existente comprova valores reais apos Relogar; falha fica exposta e recursos de apoio sao limpos sem perder pendencias.

**Tests**: integracao nativa, quatro cenarios, verificacao por leitura real do estado.
**Gate**: Nativo e Estrutural; nao considerar Free do dataset equivalente a restore.
**Commit**: `fix(irunner): restaurar parametros entre tentativas`

### T5: Confirmar e ajustar o contrato dos helpers JSON existentes

**What**: Documentar assinaturas em Main e ajustar corpos existentes somente se as provas mostrarem incompatibilidade de leitura/conversao.
**Where**: `docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas`
**Depends on**: T4
**Reuses**: TagExiste, ValorStringTag, ValorInteiroTag, ValorCurrencyTag, ValorLogicoTag, GetPairName e GetPairValue.
**Requirement**: LOTE-15, LOTE-16, LOTE-17, LOTE-19, LOTE-21.
**Tools**: interpretador-delphi-erp e Context7; API do host comprovada em T1.
**Done when**:

- [ ] Seis grupos: inteiro 30; decimal 1234.56 e zero; ausente/invalido com default; false e true; compacto versus formatado; pares de parametros com strings/numeros/booleanos.
- [ ] Documentar que TagExiste nao e validacao estrutural. Se necessario, mudar implementacao existente preservando assinaturas; nenhum novo normalizador.
- [ ] JSON valido nao fica dependente do parser Pos/Copy do piloto. Incompatibilidade comprovada bloqueia migracao ate solucao ajustada ou pergunta aceita.

**Tests**: integracao nativa, seis grupos; repetir consumidores afetados caso o corpo compartilhado mude.
**Gate**: Nativo e Estrutural; numero decimal observado deve ser 1234.56 e obrigatorios nao podem ganhar defaults positivos.
**Commit**: `refactor(json): consolidar contrato dos helpers existentes`

### Phase 2: Preparacao, persistencia e ciclo

### T6: Reiniciar contexto e metricas no runner existente

**What**: Ajustar SetarCasoTeste e rotinas de ticks para vida por tentativa e controle de recursos parciais.
**Where**: `docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas`
**Depends on**: T5
**Reuses**: FHistoricoExecucao, FContextoCasoTeste, InicializarMetricasTickDiff, LiberarMetricasTickDiff e RegistrarTick.
**Requirement**: LOTE-22, LOTE-28, LOTE-32.
**Tools**: interpretador-delphi-erp.
**Done when**:

- [ ] Quatro cenarios: dois casos com TOTAL/STARTED/Teste; segundo sem requisito/erro anterior; tick inicial falha; falha de liberacao/criacao parcial.
- [ ] Historico, ID retornado, requisito, erro, metodo e etapa resetados por caso; ticks nao colidem entre tentativas.
- [ ] Nenhum metodo de reset/limpeza novo; preservar suporte de vida comprovado em T1.

**Tests**: integracao nativa, quatro cenarios.
**Gate**: Nativo e Estrutural; comparar valores e ticks dos dois casos.
**Commit**: `fix(irunner): isolar contexto e ticks por caso`

### T7: Preparar o registro corrente no STARTED existente

**What**: Ajustar SetupCasoTeste/Started para consumir cursor atual e validar JSON/versao antes de parametros.
**Where**: `docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas`
**Depends on**: T6
**Reuses**: SetupCasoTeste, Started, AplicarParametrosDoCasoTeste, ValidarVersaoRequisito e FCasoTesteAtualJson.
**Requirement**: LOTE-04, LOTE-05, LOTE-09, LOTE-16, LOTE-20, LOTE-21, LOTE-23, LOTE-24, LOTE-25.
**Tools**: interpretador-delphi-erp; contratos T1/T5.
**Done when**:

- [ ] Seis cenarios: descricoes repetidas com IDs/JSONs distintos; raiz invalida; raiz array/string; parametros presente nao objeto; sem requisito; requisito incompativel.
- [ ] Sem CarregarCasosTeste/First/Next/busca por descricao no caminho do lote; normalizacao dentro de SetupCasoTeste existente.
- [ ] Copiar ID antes de falhas de preparo; versao validada antes de aplicar parametros; retorno True sem requisito e spelling de incompatibilidade conforme T1.

**Tests**: integracao nativa, seis cenarios.
**Gate**: Nativo e Estrutural; cursor permanece no mesmo ID e nenhum invalido aplica parametros.
**Commit**: `refactor(irunner): preparar registro corrente no started`

### T8: Persistir historico e ticks por tentativa

**What**: Ajustar RegistrarMetricas para ID do caso atual e diagnostico de persistencia parcial.
**Where**: `docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas`
**Depends on**: T7
**Reuses**: SQLs existentes e TDDScalarODBCP/TDDCommandODBCP.
**Requirement**: LOTE-26, LOTE-27, LOTE-28.
**Tools**: banco-dedicado, tdd-odbc e interpretador-delphi-erp.
**Done when**:

- [ ] Quatro cenarios: gravacao completa; falha no INSERT; falha de tick apos historico criado; ID de caso invalido.
- [ ] Historico anterior nunca reutilizado; exatamente uma tentativa de INSERT por caso valido; ID conhecido/operacao presentes no diagnostico parcial.
- [ ] Nao mover CDSCasosTestes; nao alterar METRICAS_ASSERTS nem inserir historico ficticio.

**Tests**: integracao nativa, quatro cenarios, consulta dos historicos e ticks em homologacao.
**Gate**: Nativo e Estrutural; IDs de casos e historicos conferidos; sem retry.
**Commit**: `fix(irunner): separar persistencia de cada tentativa`

### T9: Iterar lote em ExecutarLote e executar registro em Run

**What**: Ajustar a casca para carga unica, ciclo por ID, recuperacao e resumo do lote.
**Where**: `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas`
**Depends on**: T8
**Reuses**: ExecutarLote autorizado, Run, SetarCasoTeste, Started, RegistrarMetricas e teardowns existentes.
**Requirement**: LOTE-02, LOTE-03, LOTE-04, LOTE-07, LOTE-08, LOTE-09, LOTE-25, LOTE-28, LOTE-29, LOTE-30, LOTE-31, LOTE-32, LOTE-33.
**Tools**: interpretador-delphi-erp; sem metodos novos.
**Done when**:

- [ ] Oito cenarios: tres ativos; falha de Teste em B com C executado; Started falha; persistencia falha com C nao tentado; restauracao falha com C nao tentado; callback/limpeza secundaria falha; lote vazio; cursor alterado indevidamente.
- [ ] Next exclusivamente na casca, uma vez por tentativa; ticks abertos encerrados antes da persistencia; callbacks e limpeza por finally sem flags adicionais.
- [ ] Resumo usa carregados = tentados + nao tentados, sem novos contadores.
- [ ] Ponto reservado a asserts nao implementado; nenhuma aprovacao funcional anunciada.

**Tests**: integracao nativa, oito cenarios em copias do Teste existente sem efeitos financeiros.
**Gate**: Nativo e Estrutural; prova do fluxo completo com codigo temporariamente montado a partir da casca, sem novo metodo de geracao.
**Commit**: `feat(irunner): executar lote no fluxo compartilhado`

### Phase 3: Piloto, geracao e entrada

### T10: Enxugar o piloto com as remocoes autorizadas

**What**: Aplicar somente remocoes autorizadas e ajustar os metodos preservados para contexto herdado e JSON compartilhado.
**Where**: `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas`
**Depends on**: T12
**Reuses**: Teste, Setup_InicializarObjetos, TearDown_DestruirObjetos, ValidarCasoTeste, FUNCOES_JSON e quatro operacoes existentes.
**Requirement**: LOTE-04, LOTE-10, LOTE-11, LOTE-12, LOTE-13, LOTE-14, LOTE-15, LOTE-17, LOTE-18, LOTE-19.
**Tools**: interpretador-delphi-erp; ERP de homologacao com massa dedicada na implementacao futura.
**Done when**:

- [ ] Cinco grupos: (1) inventario antes/depois; (2) contexto e JSON de dois IDs distintos; (3) obrigatorios ausentes/invalidos e empresa diferente impedem gravacao; (4) tags antes atendidas por configuração geram erro e quatro operacoes em ordem; (5) falha em operacao seguida de fechamento/cancelamento e acumuladores reiniciados.
- [ ] Removidos somente os tres uses, onze constantes e dois metodos listados em context.md. Na revisão posterior, wrappers JSON e métodos de configuração listados em context.md também saem; demais métodos preservados, sem novo método.
- [ ] Sem CDS duplicados, CarregarCasoTeste, recarga do lote ou parser Pos/Copy nos corpos; wrappers removidos conforme autorização posterior; chamadas diretas a FUNCOES_JSON.
- [ ] Teste usa memoria preparada por STARTED; Setup_InicializarObjetos deixa de inicializar infraestrutura duplicada; TearDown_DestruirObjetos nao libera recursos herdados.
- [ ] Codigos receber/pagar 0/1 mantem semantica sem aliases novos; sem cEtapaAtual/novo seletor; resultado constante nao vira assert.

**Tests**: integracao nativa e revisao de inventario, cinco grupos.
**Gate**: Nativo e Estrutural; nao executar borderos reais sem massa dedicada e validacao dos filtros atuais.
**Commit**: `refactor(financeiro): reaproveitar contexto implicito no piloto`

### T11: Limitar a geracao a entrada do lote e Teste

**What**: Ajustar Executar para validar configuracao, gerar chamadas corretas e liberar todas as listas.
**Where**: `docs/assets/emDesenvolvimento/Runner/TDD_IRUNNER.pas`
**Depends on**: T9
**Reuses**: Executar, AddItemToList, AddUsesUnit renomeado para SetTDDUnit e AddParamsRun.
**Requirement**: LOTE-01, LOTE-08, LOTE-34, LOTE-35, LOTE-36, LOTE-37, LOTE-38.
**Tools**: interpretador-delphi-erp.
**Done when**:

- [ ] Seis grupos: valido com Teste; unit vazia; parametros nil ou diferentes de dois; Teste fixo sem registro; substituicao dos marcadores; CommaText/Troca originais e segunda execucao.
- [ ] Validos chamam Interpretar uma vez; invalidos zero; fechamento de tick preserva nome correto da fase.
- [ ] Somente AddMetodo removido e AddUsesUnit renomeado para SetTDDUnit; nenhum metodo adicional. FParamsCasosTeste liberada e configuracao reiniciada.

**Tests**: integracao nativa, seis grupos; log do codigo gerado e contagem de Interpretar.
**Gate**: Nativo e Estrutural; geracao verificada no host, nao apenas igualdade textual.
**Commit**: `fix(irunner): validar e gerar entrada do lote`

### T12: Migrar o processamento financeiro existente

**What**: Ajustar ExecutarIRunner para SetTDDUnit e dois parametros, sem AddMetodo.
**Where**: `docs/assets/emDesenvolvimento/Runner/P39_PROCESSAMENTO_TDD_FINANCEIRO.pas`
**Depends on**: T11
**Reuses**: Main e ExecutarIRunner existentes.
**Requirement**: LOTE-01, LOTE-10, LOTE-12, LOTE-34, LOTE-35.
**Tools**: interpretador-delphi-erp.
**Done when**:

- [ ] Tres cenarios: chamada integrada com tres IDs; segunda execucao com outro par em copia do mesmo chamador; falha do segundo caso com resumo e terceiro executado.
- [ ] Nao referenciar ExecutarFluxoCompletoFinanceiro nem terceiro parametro; nomes runtime conforme T1; nenhum metodo novo.
- [ ] Gate integrado confirma uma Interpretar/uma carga por lote e historicos por ID.

**Tests**: integracao nativa, tres cenarios, sem execucao financeira real nos cenarios de prova do loop.
**Gate**: Nativo e Estrutural; resumo, logs e historico anexados.
**Commit**: `refactor(financeiro): registrar teste na entrada do lote`

### T13: Documentar os uses e a fronteira de memoria

**What**: Registrar grafo final das dependencias diretas, transitivas e da memoria implicita comprovada.
**Where**: `docs/mapeamentoUses/REFACTOR_TDD_FINANCEIRO_PILOTO.md`
**Depends on**: T10
**Reuses**: Padrao de `.agents/AGENTS.md` e evidencias T1/T12.
**Requirement**: LOTE-04, LOTE-10, LOTE-12.
**Tools**: Revisao textual, Mermaid e TLC.
**Done when**:

- [ ] Grafo diferencia uses diretos de visibilidade customizada entre units irmas; identifica units locais e externas.
- [ ] Um confronto documental comprova ausencia dos tres uses removidos e origem de cada global consumido pelo piloto.
- [ ] Todos os requisitos permanecem com evidencia ou pendencia explicita; encaminhar pacote ao verificador independente antes de conclusao funcional.

**Tests**: revisao documental, um confronto de grafo/uses/contexto.
**Gate**: Documental; nao representa validacao funcional do ERP.
**Commit**: `docs(financeiro): mapear dependencias do piloto compartilhado`

## Diagram-Definition Cross-Check

| Task | Depends on | Diagram shows | Status |
| --- | --- | --- | --- |
| T1 | None | Inicio | Confere |
| T2 | T1 | T1 -> T2 | Confere |
| T3 | T2 | T2 -> T3 | Confere |
| T4 | T3 | T3 -> T4 | Confere |
| T5 | T4 | T4 -> T5 | Confere |
| T6 | T5 | T5 -> T6 | Confere |
| T7 | T6 | T6 -> T7 | Confere |
| T8 | T7 | T7 -> T8 | Confere |
| T9 | T8 | T8 -> T9 | Confere |
| T10 | T12 | T12 -> T10 | Confere |
| T11 | T9 | T9 -> T11 | Confere |
| T12 | T11 | T11 -> T12 | Confere |
| T13 | T10 | T10 -> T13 | Confere |

## Test Co-location Validation

| Task | Code layer | Matrix requires | Task says | Status |
| --- | --- | --- | --- | --- |
| T1 | Host | Integracao nativa | Seis grupos | Confere |
| T2 | Cache | Integracao nativa | Quatro cenarios | Confere |
| T3 | Casos | Integracao nativa | Cinco cenarios | Confere |
| T4 | Parametros | Integracao nativa | Quatro cenarios | Confere |
| T5 | JSON | Integracao nativa | Seis grupos | Confere |
| T6 | Runner | Integracao nativa | Quatro cenarios | Confere |
| T7 | STARTED | Integracao nativa | Seis cenarios | Confere |
| T8 | FINISHED | Integracao nativa | Quatro cenarios | Confere |
| T9 | Casca | Integracao nativa | Oito cenarios | Confere |
| T10 | Piloto | Integracao nativa e inventario | Cinco grupos | Confere |
| T11 | Gerador | Integracao nativa | Seis grupos | Confere |
| T12 | Processamento | Integracao nativa | Tres cenarios | Confere |
| T13 | Uses/documentacao | Revisao documental | Um confronto | Confere |

## Revisao final prevista

Antes de marcar implementacao completa, verificador independente rederiva os 38 requisitos a partir da spec e confere evidencias nativas. Sensor em copias isoladas deve detectar: pular B no loop, reaproveitar JSON de A em C, conservar erro/historico anterior, deixar parametro alterado, registrar SUCESSO apos validacao financeira invalida e mudar decimal 1234.56 para default. Logs e consultas sao evidencia operacional; nenhuma comparacao de negocio/assert sera adicionada. Uma falha sobrevivente gera tarefa de ajuste e nova verificacao, nao PASS por inspecao textual.

O planejamento original foi entregue sem implementacao. Posteriormente, a etapa incremental de carga/preparacao foi aplicada localmente, conforme registro da etapa 01. Nenhuma tarefa ampla acima esta funcionalmente validada ou marcada como concluida.

## Correcao incremental 07

Usuario pediu restaurar a forma original de Executar com TStringList/lMetodo e adicionar somente o necessario para Teste fixo. Scanner de nome/literais e validacoes de molde/marcadores foram retirados. CommaText e Troca global de virgulas restaurados; criterios LOTE-34/36/38 revisados conforme essa orientacao, sem mudar testes executaveis (nao existem neste fluxo). Evidencia da etapa 06 e historica para a montagem anterior; evidencia de codigo gerado atualizada para a etapa 07. Gate nativo continua pendente.


## Etapa incremental 08

Após commit local 84eb26b do usuário, acabamento autorizado: retirada de wrappers/fallbacks de configuração do piloto, campos anteriormente opcionais preservados, integração do log por tentativa e instruções padronizadas das oito units locais. Quatro métodos de exibição de TDD_LOGS removidos após busca sem consumidores locais. Logs são capturados somente com debug e snapshot anterior ao INSERT; etapas usam DelimitadorLog. Regras de versão, cálculos de tempo, queries, ordem financeira e critérios STARTED/TEARDOWN permanecem. Gates nativos continuam pendentes; nenhuma tarefa ampla marcada Verified.


## Etapa incremental 09

Usuário autorizou retirar métodos redundantes/resultados do piloto e substituir as duas entradas de borderô por _IncluirBordero(pTipo), com seleção inline no caminho de pagamento. Arquivo de entrada já chamava ValidarCasoTeste diretamente e já tinha teardown no final; essas edições do usuário foram preservadas. Inventário final de seis procedures. Instruções alinhadas com 116 caracteres de =. Verificação compara estaticamente os corpos financeiros com o caminho anterior, além da ordem e seleção; não substitui o gate nativo pendente.

## Etapa incremental 11

Captura de logs movida da Base para Finished imediatamente antes do INSERT; record/parâmetro/coluna renomeados para processamento. Migration somente preparada em sql/temp-local, não aplicada. ALTER COLUMN TO conferido na documentação oficial do Firebird 5 após Context7 sem resultado correspondente. MER descreve alteração prevista. Snapshot não inclui mensagens posteriores ao INSERT; alternativa de UPDATE permanece sem decisão. Gate nativo continua pendente.
