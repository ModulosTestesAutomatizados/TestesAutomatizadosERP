# Ciclo dos estados compartilhados

```mermaid
flowchart LR
 P39_TDD_CASOS_DE_TESTE --> C["Datasets e cursor do lote"]
 C --> P39_TDD_RUN_RUNNER
 P39_TDD_RUN_RUNNER --> R["Reset por caso: records, contexto e ticks"]
 R --> P39_TDD_RUN_ASSERTS
 P39_TDD_RUN_ASSERTS --> A["Contadores, resultados e clones"]
 A --> P39_TDD_RUN_VALIDAR_RESULTADO
 A --> P39_TDD_RUN_FINISHED
 I["Executar: buffer local de montagem"] -. "cópia textual" .-> P["FLogsPreparacao do molde"]
 P --> R0["Run: limpar e copiar preparação"]
 P39_TDD_RUN_LOGS --> L["FLogsCasoTeste do lote"]
 R0 --> L
 L --> P39_TDD_RUN_FINISHED
 P39_TDD_RUN_FINISHED --> P["Persistir antes de limpar"]
```

Executar restaura a referência anterior de logs e libera somente seu buffer. Main cria a lista do lote, liberada pelo próprio lote. FINISHED captura antes de Run limpar a tentativa; a preparação é copiada novamente para o próximo caso.
