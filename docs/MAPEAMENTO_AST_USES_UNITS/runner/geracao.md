# Geração e interpretação única

```mermaid
flowchart LR
 P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO --> TDD_RUN_IRUNNER
 P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO --> TDD_FILTROS
 TDD_FAT_PROCESSAMENTO_CARGA --> TDD_RUN_IRUNNER
 TDD_FAT_PROCESSAMENTO_CARGA --> TDD_FILTROS
 TDD_FILTROS --> P39_TDD_RUN_LOGS
 TDD_RUN_LOGS --> TDD_FILTROS
 TDD_RUN_IRUNNER -. "CodificacaoUnit" .-> TDD_RUN_UNIT_BASE_IRUNNER
 TDD_RUN_IRUNNER --> M["5 marcadores: uses, parâmetros, chamada, debug e logs de preparação"]
 M --> I["Interpretar uma vez"]
 I --> L["Main → ExecutarLote"]
 TDD_RUN_IRUNNER -. "snapshot por texto; literais sem cadeia de somas" .-> P["FLogsPreparacao"]
 P --> L
 TDD_RUN_IRUNNER -. "SetTDDUnit / Teste" .-> TDD_FIN_FINANCEIRO
```

Setas tracejadas representam seleção/carga dinâmica; não são cláusulas uses extraídas do AST.

Executar possui e libera seu buffer de montagem. Main cria a lista do lote e cada Run copia o texto de FLogsPreparacao antes de acrescentar as mensagens do caso. O diagnóstico exibido deixa o marcador de preparação vazio para evitar autorreferência; o código interpretado recebe o snapshot completo.
