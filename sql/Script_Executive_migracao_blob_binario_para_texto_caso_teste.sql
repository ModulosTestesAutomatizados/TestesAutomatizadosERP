SET NAMES ISO8859_1;

SET AUTODDL OFF;

/* =================================================================================
   BLOCO DE SERVICO 1 - Fase 1 (precisa ser commitada para o DML enxergar as colunas)
================================================================================= */
ALTER TABLE CASO_TESTE ADD TMP_CASO_TESTE_CT BLOB SUB_TYPE 1 SEGMENT SIZE 100 CHARACTER SET ISO8859_1;

ALTER TABLE CASO_TESTE ADD TMP_CAMPOS_DISPONIVEIS_CT BLOB SUB_TYPE 1 SEGMENT SIZE 100 CHARACTER SET ISO8859_1;

ALTER TABLE CASO_TESTE ADD TMP_RESULTADO_ESPERADO_CT BLOB SUB_TYPE 1 SEGMENT SIZE 100 CHARACTER SET ISO8859_1;

COMMIT WORK;

/* =================================================================================
   BLOCO DE SERVICO 2 - Fase 2 + 3 + 4 (atômicas: um único COMMIT WORK no fim)
================================================================================= */

/* Fase 2 - Persistência do valor das colunas blob binário nas temporárias */
UPDATE CASO_TESTE SET
  TMP_CASO_TESTE_CT         = CASO_TESTE_CT,
  TMP_CAMPOS_DISPONIVEIS_CT = CAMPOS_DISPONIVEIS_CT,
  TMP_RESULTADO_ESPERADO_CT = RESULTADO_ESPERADO_CT;

/* Fase 3 - Drop das colunas blob binário originais */
ALTER TABLE CASO_TESTE DROP CASO_TESTE_CT;

ALTER TABLE CASO_TESTE DROP CAMPOS_DISPONIVEIS_CT;

ALTER TABLE CASO_TESTE DROP RESULTADO_ESPERADO_CT;

/* Fase 4 - Rename das colunas temporárias para os nomes originais
            (os valores persistidos são mantidos e o tipo fica correto) */
ALTER TABLE CASO_TESTE ALTER COLUMN TMP_CASO_TESTE_CT TO CASO_TESTE_CT;

ALTER TABLE CASO_TESTE ALTER COLUMN TMP_CAMPOS_DISPONIVEIS_CT TO CAMPOS_DISPONIVEIS_CT;

ALTER TABLE CASO_TESTE ALTER COLUMN TMP_RESULTADO_ESPERADO_CT TO RESULTADO_ESPERADO_CT;

COMMIT WORK;

/* =================================================================================
   FINAL - Coluna JSON_CASO_TESTE removida agora que a coluna original está correta
================================================================================= */
ALTER TABLE CASO_TESTE DROP JSON_CASO_TESTE;

COMMIT WORK;


