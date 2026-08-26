/*
=====================================================================================
 MIGRACAO DE BLOBS BINARIOS PARA BLOBS TEXTO - Tabela CASO_TESTE
=====================================================================================

 Finalidade:
   Converte as colunas blob binario (SUB_TYPE 0) CAMPOS_DISPONIVEIS_CT e
   RESULTADO_ESPERADO_CT da tabela CASO_TESTE para blob texto (SUB_TYPE 1),
   seguindo a mesma tecnica aplicada a coluna JSON_CASO_TESTE.

   A conversao e feita sem perda de informacao, em 4 fases:

     Fase 1 - Criacao de colunas temporarias ja com o tipo correto;
     Fase 2 - Persistencia do valor das colunas blob binario equivalentes;
     Fase 3 - Drop das colunas blob binario originais;
     Fase 4 - Rename das colunas temporarias para os nomes originais.

 POR QUE 2 TRANSACOES (e nao 1 so)?
   O Firebird NAO permite usar em um mesmo DML uma coluna criada por DDL ainda
   nao commitado ("column unknown"). Por isso a Fase 1 precisa ser confirmada
   antes da Fase 2. Ja o nucleo do servico (Fase 2 + 3 + 4) roda inteiro em UM
   UNICO bloco de transacao com COMMIT WORK no fim: ou tudo acontece, ou nada.
   Em caso de falha em qualquer ponto, restaurar o fbk de origem.

 Como executar (isql do Firebird 5):
   ATENCAO: usar sempre -bail para ABORTAR o script no primeiro erro.
   Sem essa flag o isql continua executando as proximas fases mesmo apos falha,
   o que pode descartar colunas sem a copia dos dados em bancos com conteudo!

   "C:\Program Files\Firebird\Firebird_5_0\isql.exe" -bail ^
      -i migracao_blob_binario_para_texto_caso_teste.sql ^
      -user SYSDBA -password <SENHA> "<CAMINHO_DO_BANCO.FDB>"

 Observacoes:
   - A definicao do tipo alvo replica exatamente a coluna JSON_CASO_TESTE do banco
     de desenvolvimento: BLOB SUB_TYPE 1 SEGMENT SIZE 100 CHARACTER SET ISO8859_1.
   - A sessao usa SET NAMES ISO8859_1 para nao transliterar bytes na copia dos blobs.
   - Em bancos que JA possuem dados gravados nos blobs binarios como UTF-8, revise o
     charset antes de aplicar (o cast interpreta os bytes no charset da coluna alvo).
   - A secao FINAL trata a criacao de JSON_CASO_TESTE para modelos que ainda nao a
     possuem. Se o banco alvo ja tiver a coluna, remova aquela linha antes de rodar.
=====================================================================================
*/

SET NAMES ISO8859_1;

SET AUTODDL OFF;

/* =================================================================================
   BLOCO DE SERVICO 1 - Fase 1 (precisa ser commitada para o DML enxergar as colunas)
================================================================================= */
ALTER TABLE CASO_TESTE ADD TMP_CAMPOS_DISPONIVEIS_CT BLOB SUB_TYPE 1 SEGMENT SIZE 100 CHARACTER SET ISO8859_1;

ALTER TABLE CASO_TESTE ADD TMP_RESULTADO_ESPERADO_CT BLOB SUB_TYPE 1 SEGMENT SIZE 100 CHARACTER SET ISO8859_1;

COMMIT WORK;

/* =================================================================================
   BLOCO DE SERVICO 2 - Fase 2 + 3 + 4 (atomicas: um unico COMMIT WORK no fim)
================================================================================= */

/* Fase 2 - Persistencia do valor das colunas blob binario nas temporarias */
UPDATE CASO_TESTE SET
  TMP_CAMPOS_DISPONIVEIS_CT = CAMPOS_DISPONIVEIS_CT,
  TMP_RESULTADO_ESPERADO_CT = RESULTADO_ESPERADO_CT;

/* Fase 3 - Drop das colunas blob binario originais */
ALTER TABLE CASO_TESTE DROP CAMPOS_DISPONIVEIS_CT;

ALTER TABLE CASO_TESTE DROP RESULTADO_ESPERADO_CT;

/* Fase 4 - Rename das colunas temporarias para os nomes originais
            (os valores persistidos sao mantidos e o tipo fica correto) */
ALTER TABLE CASO_TESTE ALTER COLUMN TMP_CAMPOS_DISPONIVEIS_CT TO CAMPOS_DISPONIVEIS_CT;

ALTER TABLE CASO_TESTE ALTER COLUMN TMP_RESULTADO_ESPERADO_CT TO RESULTADO_ESPERADO_CT;

COMMIT WORK;

/* =================================================================================
   FINAL - Coluna JSON_CASO_TESTE para modelos que ainda nao a possuem.
           REMOVER esta linha se o banco alvo ja possuir a coluna.
================================================================================= */
ALTER TABLE CASO_TESTE ADD JSON_CASO_TESTE BLOB SUB_TYPE 1 SEGMENT SIZE 100 CHARACTER SET ISO8859_1;

COMMIT WORK;
