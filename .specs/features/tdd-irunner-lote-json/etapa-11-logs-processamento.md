# Etapa 11: LogsProcessamento no histórico

## Realização

Renomeados o campo do record e parâmetro Pascal para LogsProcessamento e a coluna do INSERT para LOGS_PROCESSAMENTO_HE. Finished captura FLogsCasoTeste.Text após registrar o SQL do histórico, imediatamente antes da chamada TDDScalarODBCP. Base deixa de fazer a cópia antecipada. SetarCasoTeste reinicia o campo renomeado por tentativa.

Migration local renomeia a coluna existente por ALTER COLUMN TO, conforme [referência oficial do Firebird 5](https://firebirdsql.org/file/documentation/chunk/en/refdocs/fblangref50/fblangref50-ddl-table.html). Context7 não retornou trecho correspondente e foi usado esse fallback oficial. Não há criação/substituição do BLOB ou aplicação no banco. DDL histórica aprovada foi preservada. MER descreve o novo nome como alteração prevista, pendente da migration.

Uma cópia antes do INSERT não inclui mensagens geradas depois dele. Não foi introduzido UPDATE adicional sem decisão do usuário; mensagens de ID/métricas e erros posteriores continuam fora desse snapshot. FModoDebug permanece controlando o registro. Nenhum método novo e nenhum assert implementado.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas
- sql/temp-local/migracao_historico_logs_processamento.sql
- docs/MER.md
- Registros TLC da etapa.

## p/ teste

Auditoria estrutural confirmou captura após log SQL e antes do INSERT, parâmetro final correto, ausência do nome antigo nas três units ativas e migration somente com rename. git diff --check e validadores TLC passaram. Migration e scripts Pascal não foram executados no banco/ERP.

Na futura validação autorizada, aplicar a migration antes de usar as units com o nome novo; conferir preservação dos logs existentes e tipo BLOB texto. Executar caso com debug ativo e conferir LOGS_PROCESSAMENTO_HE contendo as mensagens acumuladas, inclusive o diagnóstico do SQL do histórico. Com debug desligado, o texto permanece vazio. Confirmar registros distintos por tentativa. Se optar por salvar mensagens posteriores, será necessário integrar e validar a atualização do mesmo histórico.

EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas do usuário e migrations históricas não foram reescritos. Nenhum dado financeiro ou schema externo foi alterado pelo agente; sem commit ou publicação.

## O que há de novo

Histórico passa a receber logs de processamento no ponto do INSERT, com nomenclatura que contempla mensagens além de falhas.
