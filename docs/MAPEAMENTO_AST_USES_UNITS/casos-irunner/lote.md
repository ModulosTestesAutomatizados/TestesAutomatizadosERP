# Inventário e lote com IRunner

Fontes: `P39_TDD_FIN_PROCESSAMENTO.pas`, `P39_TDD_IRUNNER.pas` e `P39_TDD_BASE_UNIT_IRUNNER.pas` em `docs/assets/emDesenvolvimento/Runner/`.

```mermaid
flowchart TD
  Entrada[P39_TDD_FIN_PROCESSAMENTO] --> Config[P39_TDD_IRUNNER: unit e módulo/área]
  Config --> Molde[P39_TDD_BASE_UNIT_IRUNNER]
  Molde --> Setup[P39_TDD_RUNNER: SetupCasosTestes]
  Setup --> Casos[P39_TDD_CASOS_DE_TESTE: CDSCasosTestes.First]
  Casos --> Cursor{Eof?}
  Cursor -->|Não| Run[Run: reiniciar contexto e métricas]
  Run --> Started[P39_TDD_STARTED: JSON, versão e parâmetros]
  Started --> Teste[P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.Teste]
  Teste --> Finished[P39_TDD_FINISHED: histórico e tempos]
  Finished --> Next[CDSCasosTestes.Next]
  Next --> Cursor
  Cursor -->|Sim| Limpeza[Liberar recursos do lote]
```

Este diagrama descreve o caminho normal. As decisões de falha e continuidade estão nos diagramas canônicos do Runner.
