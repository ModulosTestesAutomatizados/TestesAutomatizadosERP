# Etapa 12: Finished sem logs de persistência

## Realização

Retiradas as mensagens de SQL, ID retornado, contagem e falha de persistência de Finished, conforme pedido. Copiar LogsProcessamento antes do INSERT e persistir histórico/métricas permanecem. Não foi acrescentado UPDATE. Clear já existe no finally externo de Run e na entrada; Base preservada nesta etapa.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas
- Registros TLC.

## p/ teste

Checks estruturais passaram: Finished sem RegistrarLogEmModoDebug, SQL e captura preservados, Clear no finally externo após RegistrarMetricas. git diff --check passou. Nenhuma execução no ERP ou no banco; migration ainda pendente.

## O que há de novo

Histórico contém logs da execução sem mensagens da gravação de métricas; lista é limpa após a tentativa, inclusive quando uma exception sobe.
