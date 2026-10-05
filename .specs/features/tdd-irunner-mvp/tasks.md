# TDD IRunner MVP Tasks

## Execution Protocol

Aplicar tlc-spec-driven. Escopo autorizado: MVP nas units locais, para revisao posterior pelo usuario. Nao publicar no ERP. Nenhuma tarefa e funcionalmente verificada sem execucao no interpretador nativo.

**Status:** In Progress - codigo local implementado, gate funcional pendente.

## Test Coverage Matrix

| Code Layer | Required Test Type | Coverage Expectation | Location Pattern | Run Command |
| --- | --- | --- | --- | --- |
| Gerador e ciclo interpretado | integration | Entradas invalidas, loop por modulo/area, falhas por caso e limpeza global | docs/assets/emDesenvolvimento | Execucao nativa no BI do ERP; comando automatizado nao localizado |
| Piloto financeiro | integration | Caso unico, oito defaults, quatro etapas, falha parcial e fechamento | docs/assets/emDesenvolvimento | Execucao nativa no BI do ERP em ambiente de testes |

## Gate Check Commands

| Gate Level | When to Use | Command |
| --- | --- | --- |
| Structural | Revisao local | git diff --check -- docs/assets/emDesenvolvimento/TDD_IRUNNER.pas docs/assets/emDesenvolvimento/TDD_BASE_UNIT_IRUNNER.pas docs/assets/emDesenvolvimento/TDD_RUNNER.pas docs/assets/emDesenvolvimento/TDD_STARTED.pas docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas docs/assets/emDesenvolvimento/P39_PROCESSAMENTO_TDD_FINANCEIRO.pas |
| Full | Validacao funcional | Pendente: executar cenarios no interpretador nativo; nenhum comando de CLI comprovado |

## Execution Plan

### Phase 1: Integracao local

```text
T1 -> T2 -> T3 -> T4 -> T5 -> T6 -> T7 -> T8
```

## Task Breakdown

### T1: Restringir a geracao ao contrato do MVP
**What**: Validar uma fixture, um unico Teste, dois literais (modulo/area) e marcadores; gerar a chamada e liberar listas.
**Where**: `docs/assets/emDesenvolvimento/TDD_IRUNNER.pas`
**Depends on**: None
**Requirement**: IRUN-01 a IRUN-07, IRUN-25. STARTED prepara o caso; o processamento registra somente Teste.
**Tests**: integration - entradas invalidas e fonte gerado no ERP, pendente; montagem estrutural conferida localmente.
**Gate**: Full pendente; Structural aprovado.
- [x] Codigo local implementado.
- [ ] Executar contrato valido, substring indevida, ordem invertida, duplicata, parametro invalido e casca incompleta no ERP.

### T2: Encerrar ticks preservando diagnostico
**What**: Centralizar coleta de erros de encerramento e fechar ticks abertos, com TOTAL por ultimo.
**Where**: `docs/assets/emDesenvolvimento/TDD_RUNNER.pas`
**Depends on**: T1
**Requirement**: IRUN-15, IRUN-16, IRUN-20, IRUN-28
**Tests**: integration - tick aberto e falha de encerramento no ERP, pendente.
**Gate**: Full pendente; Structural aprovado.
- [x] Codigo local implementado.
- [ ] Conferir metricas de operacao com excecao e reexecucao na mesma sessao.

### T3: Garantir tentativas independentes de finalizacao
**What**: Capturar erro original, finalizar ticks, fechar callbacks, persistir quando houver ID e liberar metricas.
**Where**: `docs/assets/emDesenvolvimento/TDD_BASE_UNIT_IRUNNER.pas`
**Depends on**: T2
**Requirement**: IRUN-17 a IRUN-21, IRUN-24, IRUN-26, IRUN-27
**Tests**: integration - falha de inicializacao, teste, persistencia e callbacks no ERP, pendente.
**Gate**: Full pendente; Structural aprovado.
- [x] Codigo local implementado.
- [ ] Usar fixture sem operacoes financeiras para provocar cada falha e verificar mensagens e limpeza.

### T4: Expor o caso selecionado por STARTED
**What**: Disponibilizar JSON/resultado esperado do caso atual e completar requisito de versao.
**Where**: `docs/assets/emDesenvolvimento/TDD_STARTED.pas`
**Depends on**: T3
**Requirement**: IRUN-08, IRUN-22, IRUN-23
**Tests**: integration - caso selecionado, requisito ausente e versao incompativel no ERP, pendente.
**Gate**: Full pendente; Structural aprovado.
- [x] Codigo local implementado.
- [ ] Conferir ID/JSON e resultado esperado entre units na mesma interpretacao.

### T5: Enxugar a preparacao do piloto
**What**: Usar os CDS globais de caso/configuracao e manter as operacoes com fechamento protegido; nao criar Setup financeiro da fixture.
**Where**: `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas`
**Depends on**: T4
**Requirement**: IRUN-09 a IRUN-14
**Tests**: integration - lote por modulo/area, configuracao vazia, tags invalidas, etapas e falha parcial no ERP, pendente.
**Gate**: Full pendente; Structural aprovado.
- [x] Codigo local implementado.
- [ ] Confirmar que STARTED/fluxo geral carrega CDSConfiguracao antes de Teste; conferir defaults e quatro operacoes em ambiente financeiro de testes.

### T6: Registrar somente Teste no processamento
**What**: Registrar apenas Teste; STARTED ja prepara o caso e o fluxo geral executa TearDown.
**Where**: `docs/assets/emDesenvolvimento/P39_PROCESSAMENTO_TDD_FINANCEIRO.pas`
**Depends on**: T5
**Requirement**: IRUN-01, IRUN-12, IRUN-28
**Tests**: integration - processamento financeiro integrado no ERP, pendente.
**Gate**: Full pendente; Structural aprovado.
- [x] Codigo local implementado.
- [ ] Executar o processamento e conferir STARTED -> Teste e o TearDown geral.

### T7: Iterar casos ativos por modulo e area
**What**: Receber somente modulo e area, carregar o CDS compartilhado uma vez e executar Teste para cada registro, persistindo e acumulando falhas sem interromper o lote.
**Where**: `TDD_IRUNNER.pas`, `TDD_BASE_UNIT_IRUNNER.pas`, `TDD_STARTED.pas`, `P39_PROCESSAMENTO_TDD_FINANCEIRO.pas`
**Requirement**: IRUN-29, IRUN-30, IRUN-32
**Gate**: Runtime pendente no ERP.
- [x] Implementar loop e ajustar parametros do processamento para modulo/area.
- [ ] Conferir os tres casos ativos de FATURAMENTO / PEDIDO DE VENDA no runtime.

### T8: Limpar todos os recursos do lote
**What**: Adicionar TearDown do fluxo que libera CDS de casos/resultados/campos/configuracao, parametros, cache e metricas, tentando cada recurso mesmo se outro falhar.
**Where**: `TDD_BASE_UNIT_IRUNNER.pas`, `TDD_RUNNER.pas`, `TDD_STARTED.pas`, units de casos/cache/parametros
**Requirement**: IRUN-31
**Gate**: Runtime pendente no ERP.
- [x] Executar TearDown no finally externo ao loop, inclusive em falha de inicializacao.
- [x] Implementar tentativas independentes por recurso; provocar falha em runtime ainda pendente.

## Diagram-Definition Cross-Check

| Task | Depends On | Diagram Shows | Status |
| --- | --- | --- | --- |
| T1 | None | None | Match |
| T2 | T1 | T1 | Match |
| T3 | T2 | T2 | Match |
| T4 | T3 | T3 | Match |
| T5 | T4 | T4 | Match |
| T6 | T5 | T5 | Match |
| T7 | T6 | T6 | Match |
| T8 | T7 | T7 | Match |

## Test Co-location Validation

T1 a T6 exigem integration no runtime nativo. Nenhuma verificacao estrutural substitui esse gate; todas as caixas de runtime permanecem abertas.
