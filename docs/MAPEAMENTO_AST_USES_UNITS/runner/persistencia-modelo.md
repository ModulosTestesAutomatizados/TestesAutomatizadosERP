# Vínculo das métricas

```mermaid
erDiagram
  CASO_TESTE ||--o{ HISTORICO_EXECUCAO : tentativas
  HISTORICO_EXECUCAO ||--o{ METRICAS_TICK_DIFF : tempos
  HISTORICO_EXECUCAO ||--o{ METRICAS_ASSERTS : verificacoes
```

O identificador retornado pelo INSERT do histórico é usado nos INSERTs das métricas. O diagrama descreve os vínculos usados pelo fluxo, não substitui uma inspeção das constraints do banco instalado.
