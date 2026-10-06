/*
  Migration em validacao local; nao executada automaticamente.
  Banco dedicado de testes, Firebird 5.
  Executar uma vez, antes de usar as units com LogsProcessamento.
  A criacao original de HISTORICO_EXECUCAO permanece na migration historica.
  Referencia: https://firebirdsql.org/file/documentation/chunk/en/refdocs/fblangref50/fblangref50-ddl-table.html#fblangref50-ddl-tbl-altrnaming
*/

SET NAMES UTF8;
SET AUTODDL OFF;
SET BAIL ON;

ALTER TABLE HISTORICO_EXECUCAO
  ALTER COLUMN LOGS_FALHAS_HE TO LOGS_PROCESSAMENTO_HE;

COMMIT WORK;
