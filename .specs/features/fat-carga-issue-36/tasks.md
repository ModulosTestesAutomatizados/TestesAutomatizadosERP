# Carga de faturamento - tarefas

## Execution Protocol

Usar `tlc-spec-driven`. A validacao nativa permanece pendente ate o ERP interpretar as novas units.

**Design**: `.specs/features/fat-carga-issue-36/design.md`
**Status**: In Progress

## Test Coverage Matrix

> Diretrizes: `.agents/skills/estrutura-testes-erp/SKILL.md`, `.agents/skills/dunitx-erp/SKILL.md` e `.agents/skills/interpretador-delphi-erp/SKILL.md`. Nao ha runner Pascal/JvInterpreter local. A sonda Python verifica contratos estaticos e nao substitui o teste nativo.

| Code Layer | Required Test Type | Coverage Expectation | Location Pattern | Run Command |
| --- | --- | --- | --- | --- |
| JSON e sincronizacao | none | fonte unica, identidade e tags | `docs/assets/emDesenvolvimento/carga/*.json` e sincronizacao existente | sonda estatica; sincronizar no ERP |
| Mapeamento de tela | integration | cinco controles, 28 abas e componentes | `docs/assets/emDesenvolvimento/carga/*MAPEAMENTO*.pas` | mapear no ERP |
| Caso de teste | integration | pedido apto, inclusao, falhas e persistencia | `docs/assets/emDesenvolvimento/carga/TDD_FAT_CARGA.pas` | executar no ERP |
| Processamento | none | chamada unica do IRunner | `docs/assets/emDesenvolvimento/carga/*PROCESSAMENTO*.pas` | sonda estatica |

## Gate Check Commands

| Gate Level | When to Use | Command |
| --- | --- | --- |
| Quick | Contratos locais | `python .specs/features/fat-carga-issue-36/evidencias/verificar_mvp.py` |
| Full | Tela e caso no ERP | Sonda Quick, executar `TDD_FAT_PROCESSAMENTO_CARGA` no BI e conferir historico, `CARGA` e `CARGA_DOCUMENTOS` |
| Build | Fim da fase local | Sonda Quick e `git diff --check` |

## Execution Plan

### Phase 1: Artefatos locais

```text
T1 -> T2 -> T3 -> T4 -> T5
```

### Phase 2: Validacao nativa

```text
T5 -> T6
```

## Task Breakdown

### T1: Criar fonte JSON

**What**: Definir pedido `843172`, descricao e resultado esperado.
**Where**: `docs/assets/emDesenvolvimento/carga/TDD_FAT_CARGA_JSON.json`
**Depends on**: None
**Requirement**: CARGA-03, CARGA-04, CARGA-07, CARGA-08
**Tests**: none
**Gate**: build
**Done when**: JSON compacto valido e codigo de Carga positivo no resultado esperado; gate Build aprovado.

### T2: Registrar Carga na sincronizacao

**What**: Acrescentar `FATURAMENTO/CARGA/TDD_FAT_CARGA` com fonte `TDD_FAT_CARGA_JSON`.
**Where**: `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas`
**Depends on**: T1
**Requirement**: CARGA-01, CARGA-02, CARGA-03, CARGA-04
**Tests**: none
**Gate**: build
**Done when**: Registro unico e sincronizacao nativa sem duplicata; gate Build aprovado.

### T3: Mapear tela de Carga

**What**: Localizar formulario, DataModule, cinco controles, 28 abas e componentes do cenario.
**Where**: `docs/assets/emDesenvolvimento/carga/TDD_FAT_MAPEAMENTO_COMPONENTES_CARGA.pas`
**Depends on**: T2
**Requirement**: CARGA-05, CARGA-09
**Tests**: integration
**Gate**: full
**Done when**: Nomes conferidos com DFM e mapeamento executado na tela real; gate Full aprovado.

### T4: Incluir e verificar Carga

**What**: Validar pedido, incluir cabecalho/documento, gravar, reabrir e conferir vinculo.
**Where**: `docs/assets/emDesenvolvimento/carga/TDD_FAT_CARGA.pas`
**Depends on**: T3
**Requirement**: CARGA-07, CARGA-08, CARGA-09, CARGA-10, CARGA-11, CARGA-12
**Tests**: integration
**Gate**: full
**Done when**: Pedido `843172` produz `CODIGO_CARGA` persistido e par carga/pedido em `CARGA_DOCUMENTOS`; falhas de pre-condicao nao gravam; gate Full aprovado.

### T5: Criar entrada IRunner

**What**: Executar `TDD_FAT_CARGA` no lote `FATURAMENTO/CARGA`.
**Where**: `docs/assets/emDesenvolvimento/carga/TDD_FAT_PROCESSAMENTO_CARGA.pas`
**Depends on**: T4
**Requirement**: CARGA-06, CARGA-10
**Tests**: none
**Gate**: build
**Done when**: Parametros exatos e uma chamada a `Executar`; gate Build aprovado.

### T6: Registrar validacao nativa

**What**: Documentar interpretacao, sincronizacao, execucao, historico e persistencia.
**Where**: `.specs/features/fat-carga-issue-36/validation.md`
**Depends on**: T5
**Requirement**: CARGA-01 a CARGA-12
**Tests**: integration
**Gate**: full
**Done when**: Evidencia nativa de cada criterio e PASS no gate Full.

## Phase Execution Map

```text
Phase 1: T1 -> T2 -> T3 -> T4 -> T5
Phase 2: T5 -> T6
```

## Diagram-Definition Cross-Check

| Task | Depends On | Diagram Shows | Status |
| --- | --- | --- | --- |
| T1 | None | None | OK |
| T2 | T1 | T1 -> T2 | OK |
| T3 | T2 | T2 -> T3 | OK |
| T4 | T3 | T3 -> T4 | OK |
| T5 | T4 | T4 -> T5 | OK |
| T6 | T5 | T5 -> T6 | OK |

## Test Co-location Validation

| Task | Code Layer | Matrix Requires | Task Says | Status |
| --- | --- | --- | --- | --- |
| T1 | JSON | none | none | OK |
| T2 | sincronizacao | none | none | OK |
| T3 | mapeamento | integration | integration | OK |
| T4 | caso | integration | integration | OK |
| T5 | processamento | none | none | OK |
| T6 | validacao | integration | integration | OK |
