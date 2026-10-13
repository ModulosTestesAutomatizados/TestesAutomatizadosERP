# Da medição à persistência

Documentação: Estrutura e fluxo de IRunner.Executar. Este arquivo é a fonte do diagrama exibido pelo portal.

```mermaid
flowchart TD
  Inicio["RegistrarTick 0: início e etapa"] --> CDS["FCDSMetricasTickDiff"]
  Fim["RegistrarTick 1: fim e TickDiff"] --> CDS
  CDS --> Fechar["Run fecha todos os tempos abertos"]
  Logs["FLogsCasoTeste"] --> Snapshot["FHistoricoExecucao.LogsProcessamento"]
  Fechar --> Finished["RegistrarMetricas"]
  Snapshot --> Finished
  Finished --> Historico["INSERT HISTORICO_EXECUCAO"]
  Historico --> ID["RETURNING AUTOINC_HISTORICO_HE"]
  ID --> Tempos["INSERT METRICAS_TICK_DIFF por linha"]
  Pendente["METRICAS_ASSERTS: pendente"]
  style Pendente fill:#fef3c7,stroke:#b45309,color:#78350f
```
