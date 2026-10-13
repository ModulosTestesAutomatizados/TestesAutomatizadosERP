# Inventário e lote com IRunner

Fontes: `P39_PROCESSAMENTO_TDD_FINANCEIRO.pas`, `TDD_IRUNNER.pas` e `TDD_BASE_UNIT_IRUNNER.pas` em `docs/assets/emDesenvolvimento/Runner/`.

```mermaid
flowchart TD
  Entrada[P39_PROCESSAMENTO_TDD_FINANCEIRO] --> Config[TDD_IRUNNER: unit e módulo/área]
  Config --> Molde[TDD_BASE_UNIT_IRUNNER]
  Molde --> Setup[TDD_RUNNER: SetupCasosTestes]
  Setup --> Casos[P39_TDD_CASOS_DE_TESTE: CDSCasosTestes.First]
  Casos --> Cursor{Eof?}
  Cursor -->|Não| Run[Run: reiniciar contexto e métricas]
  Run --> Started[TDD_STARTED: JSON, versão e parâmetros]
  Started --> Teste[REFACTOR_TDD_FINANCEIRO_PILOTO.Teste]
  Teste --> Finished[TDD_FINISHED: histórico e tempos]
  Finished --> Next[CDSCasosTestes.Next]
  Next --> Cursor
  Cursor -->|Sim| Limpeza[Liberar recursos do lote]
```

Este diagrama descreve o caminho normal. As decisões de falha e continuidade estão nos diagramas canônicos do Runner.
