---
name: firebird-language-reference
description: Utilize essas habilidades sempre que precisar escrever, revisar ou validar SQL/PSQL para Firebird 5.x (DDL, DML, funções embutidas, transações, tipos de dados), evitando sintaxes inválidas ou de outros bancos.
---

# Firebird 5.0 Language Reference (referência condensada)

Fonte oficial: [Firebird 5.0 Language Reference](https://www.firebirdsql.org/file/documentation/html/en/refdocs/fblangref50/firebird-50-language-reference.html)

Esta skill é um guia rápido destilado da documentação oficial. Para detalhes finos,
consultar a fonte. Regra de ouro: Firebird **não** aceita sintaxe de outros SGBDs
(ex.: `LIMIT`, `TOP`, `ON DUPLICATE KEY`, `AUTO_INCREMENT`, `IF EXISTS` em todas as versões antigas).

---

## 1. Tipos de dados

| Tipo | Tamanho | Limites/Observações |
| ---- | ------- | ------------------- |
| `SMALLINT` | 16 bits | -32.768 a 32.767 |
| `INTEGER` | 32 bits | -2.147.483.648 a 2.147.483.647 |
| `BIGINT` | 64 bits | ±9,2 * 10^18; somente dialect 3 |
| `INT128` | 128 bits | FB 4.0+ |
| `FLOAT` | 32 bits | IEEE binary32, ~7 dígitos |
| `DOUBLE PRECISION` | 64 bits | IEEE binary64, ~15 dígitos |
| `NUMERIC(p,s)` / `DECIMAL(p,s)` | variável | p = 1..38, s = 0..38 (s <= p) |
| `DECFLOAT[(16\|34)]` | 64/128 bits | ponto flutuante decimal IEEE-754; padrão 34 |
| `DATE` | 4 bytes | só data, 0001-01-01 a 9999-12-31 |
| `TIME [WITHOUT TIME ZONE]` | 4 bytes | 0:00 a 23:59:59.9999 |
| `TIMESTAMP [WITHOUT TIME ZONE]` | 8 bytes | data + hora |
| `TIME/TIMESTAMP WITH TIME ZONE` | 6/10 bytes | com fuso (FB 4.0+) |
| `CHAR(n)` | fixo | completa com espaços; até 32.767 bytes |
| `VARCHAR(n)` | variável | até 32.765 bytes; `n` obrigatório |
| `BINARY(n)` / `VARBINARY(n)` | bytes | sinônimos de CHAR/VARCHAR `CHARACTER SET OCTETS` |
| `BOOLEAN` | 1 byte | `TRUE`, `FALSE`, `UNKNOWN` |
| `BLOB` | variável | subtipo define conteúdo (`SUBTYPE TEXT` = 1); segmento máx. 64K |

Notas:
- Literais hexadecimais inteiros: `0x1F`, `0x7FFF`.
- Conversões: explícitas com `CAST(expr AS tipo)`; implícitas seguem regras do FB 5.
- Domains: `CREATE DOMAIN nome AS <tipo> [DEFAULT val] [NOT NULL] [CHECK (...)]`; colunas/variáveis podem herdar de domain.

---

## 2. Elementos comuns

- Comentários: `-- linha única` e `/* bloco */`.
- Concatenação: `||` (não existe `CONCAT()` nativa).
- Predicados: `= <> != > < >= <=`, `IS [NOT] NULL`, `IS [NOT] DISTINCT FROM`, `[NOT] BETWEEN`, `[NOT] LIKE`, `SIMILAR TO`, `[NOT] IN (<lista>|<subquery>)`, `[NOT] EXISTS (<subquery>)`, `{ALL | SOME | ANY} (<subquery>)`.
- Condicional completo: `CASE WHEN ... THEN ... ELSE ... END` (além das funções `IIF`, `DECODE`, `COALESCE`, `NULLIF`).
- Subquery escalar no SELECT/WHERE retorna no máximo 1 linha/coluna.

---

## 3. DDL essencial

```sql
CREATE TABLE cliente (
    codigo     INTEGER NOT NULL,
    nome       VARCHAR(60) NOT NULL,
    ativo      BOOLEAN DEFAULT TRUE,
    saldo      NUMERIC(12,2) DEFAULT 0,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (codigo)
);

CREATE SEQUENCE seq_cliente;             -- GENERATOR é sinônimo
ALTER SEQUENCE seq_cliente RESTART WITH 100;

NEXT VALUE FOR seq_cliente               -- uso em INSERT/SELECT
GEN_ID(seq_cliente, 1)                   -- alternativa clássica (PSQL/DSQL)

CREATE EXCEPTION EX_REGISTRO_DUPLICADO 'Registro já cadastrado.';
COMMENT ON TABLE cliente IS 'Clientes do sistema';

-- Objetos: TABLE, VIEW, TRIGGER, PROCEDURE, FUNCTION, PACKAGE, SEQUENCE,
-- EXCEPTION, DOMAIN, INDEX, COLLATION suportam CREATE/ALTER/DROP;
-- maioria aceita CREATE OR ALTER e RECREATE.
```

---

## 4. DML — SELECT

```sql
SELECT [FIRST n] [SKIP m] [DISTINCT] <cols>
FROM <tabela | join | derived table>
[WHERE <condicao>]
[GROUP BY <exprs> [HAVING <condicao>]]
[WINDOW ...] | [OVER (...)]
[UNION [DISTINCT | ALL] <select>]
[ORDER BY <exprs> [ASC | DESC] [NULLS FIRST | LAST]]
[ROWS m [TO n]]                    -- não padrão
| [OFFSET n ROWS] [FETCH FIRST m ROWS ONLY]   -- padrão SQL
[FOR UPDATE [OF cols]] [WITH LOCK]
[INTO :var1, :var2]                -- somente PSQL
```

- Paginação (3 formas equivalentes):
  - `FIRST 10 SKIP 20` (Firebird legado, antes do ORDER BY/DISTINCT);
  - `OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY` (padrão SQL, preferível);
  - `ROWS 21 TO 30` (após ORDER BY).
- Joins: `[INNER | LEFT [OUTER] | RIGHT [OUTER] | FULL [OUTER]] JOIN ... ON <cond>` e join natural/nomeado (`NATURAL JOIN`, `JOIN ... USING (col)`).
- CTE: `WITH [RECURSIVE] cte [(cols)] AS (SELECT ...) SELECT ...`.

### RETURNING (INSERT/UPDATE/DELETE/MERGE/UPDATE OR INSERT)

```sql
INSERT INTO cliente (codigo, nome)
VALUES (NEXT VALUE FOR seq_cliente, 'TekSystem')
RETURNING codigo;                  -- devolve valores da linha afetada (DSQL/PSQL)
```

### UPDATE OR INSERT (upsert idiomático do Firebird)

```sql
UPDATE OR INSERT INTO cliente (codigo, nome, ativo)
VALUES (:codigo, :nome, TRUE)
MATCHING (codigo)                  -- sem MATCHING usa-se a PK
RETURNING OLD.codigo, NEW.codigo;
```

### MERGE

```sql
MERGE INTO destino d
USING (SELECT codigo, nome FROM origem) o
ON d.codigo = o.codigo
WHEN MATCHED [AND <cond>] THEN UPDATE SET d.nome = o.nome
WHEN NOT MATCHED [BY TARGET] THEN INSERT (codigo, nome) VALUES (o.codigo, o.nome)
WHEN NOT MATCHED BY SOURCE [AND <cond>] THEN DELETE;
```

Outros: `UPDATE ... SET ... [SKIP LOCKED]`, `DELETE FROM ... [SKIP LOCKED]`,
`UPDATE CURRENT OF cursor` / `DELETE WHERE CURRENT OF cursor` (em PSQL).

---

## 5. EXECUTE BLOCK (PSQL anônimo via DSQL)

```sql
EXECUTE BLOCK (p_codigo INTEGER = ?)
RETURNS (nome VARCHAR(60))
AS
DECLARE i INTEGER = 0;
BEGIN
  FOR SELECT nome FROM cliente WHERE codigo = :p_codigo INTO :nome DO
    SUSPEND;
END
```

- Entrada: `(param tipo = ?)` — `?` é placeholder para driver (ODBC).
- Saída: exige `SUSPEND` por linha retornada (como procedure selecionável).

---

## 6. PSQL (procedures, functions, triggers, blocos)

```sql
CREATE PROCEDURE MINHA_PROC (p_in INTEGER)
RETURNS (o_total NUMERIC(12,2))
AS
DECLARE v_aux INTEGER DEFAULT 0;
BEGIN
  -- atribuição
  v_aux = v_aux + 1;

  IF (v_aux > 10) THEN
    v_aux = 0;
  ELSE
    v_aux = 10;

  WHILE (v_aux < 100) DO
  BEGIN
    v_aux = v_aux + 1;
    IF (v_aux = 50) THEN CONTINUE;   -- BREAK, LEAVE, EXIT também existem
  END

  FOR SELECT valor FROM lancamentos INTO :v_valor DO
    o_total = o_total + :v_valor;

  SUSPEND;                           -- procedures selecionáveis (SELECT ... FROM proc)
END
```

- Declaração de variável: `DECLARE [VARIABLE] nome <tipo> [= default];`
- Cursores declarados: `DECLARE cur CURSOR FOR (SELECT ...);` + `OPEN/FETCH/CLOSE`.
- SQL dinâmico: `EXECUTE STATEMENT :sql [:param := valor] [INTO :var]` (e `FOR EXECUTE STATEMENT`).
- Transação autônoma: `IN AUTONOMOUS TRANSACTION DO BEGIN ... END`.
- Eventos: `POST_EVENT 'nome_evento';`
- Tratamento de erros:

```sql
BEGIN
  ...
  WHEN ANY DO                 -- captura tudo
    BEGIN END;
  WHEN GDSCODE key_violation DO
    EXCEPTION EX_REGISTRO_DUPLICADO;
  WHEN SQLSTATE '23000' DO
    v_erro = 1;
END
```

- Contextos de trigger: `NEW.coluna`, `OLD.coluna`, `INSERTING`, `UPDATING`, `DELETING`;
  triggers DML (`BEFORE/AFTER INSERT|UPDATE|DELETE`), de banco (`ON CONNECT/DISCONNECT/TRANSACTION ...`) e DDL.
- Em trigger, colunas recebidas em `NEW.x` NÃO usam dois-pontos.

---

## 7. Funções embutidas mais usadas

### String/Binário
| Função | Assinatura |
| ------ | ---------- |
| `LEFT`/`RIGHT` | `(string, length)` |
| `SUBSTRING` | `(str FROM pos [FOR len])` ou `SUBSTRING(str SIMILAR '<padrão>' ESCAPE '#')` |
| `POSITION` | `(substr IN string [, start])` ou `(substr, string [, start])`; 0 se não achar |
| `REPLACE` | `(str, find, repl)` — qualquer argumento `NULL` → resultado `NULL` |
| `TRIM` | `([LEADING \| TRAILING \| BOTH] [chars FROM] str)` |
| `LPAD`/`RPAD` | `(str, endlen [, padstr])` |
| `UPPER`/`LOWER` | `(str)` |
| `OVERLAY` | `(str PLACING substituto FROM pos [FOR len])` |
| `REVERSE` | `(str)` |
| `CHAR_LENGTH` / `OCTET_LENGTH` / `BIT_LENGTH` | `(string)` |
| `ASCII_CHAR`/`ASCII_VAL`, `UNICODE_CHAR`/`UNICODE_VAL` | conversão código↔caractere |
| `HEX_ENCODE`/`HEX_DECODE`, `BASE64_ENCODE`/`BASE64_DECODE` | codificação binária |
| `HASH`, `CRYPT_HASH` | hashing |
| `BLOB_APPEND` | `(expr1, expr2 [, exprN])` — concatenação eficiente de BLOB |

### Data/Hora
| Função | Exemplo |
| ------ | ------- |
| `CURRENT_DATE`, `CURRENT_TIME`, `CURRENT_TIMESTAMP`, `LOCALTIME`, `LOCALTIMESTAMP` | contexto |
| `'NOW'`, `'TODAY'`, `'TOMORROW'`, `'YESTERDAY'` | literais especiais de data/hora |
| `DATEADD` | `dateadd(28 day to current_date)`, `dateadd(month, 9, dt)`, `dateadd(-6 hour to t)` |
| `DATEDIFF` | `datediff(day from d1 to d2)`, `datediff(year, d1, d2)` |
| `EXTRACT` | `extract(year from ts)`, `extract(millisecond from ts)` |
| `FIRST_DAY`/`LAST_DAY` | `first_day(of month from current_date)`, `last_day(of year from ts)` — períodos: week, month, quarter, year |

### Condicionais / Misc
`COALESCE(e1, e2, ...)`, `NULLIF(e1, e2)`, `IIF(cond, rT, rF)`,
`DECODE(teste, v1, r1, v2, r2, ..., default)`, `MAXVALUE(...)/MINVALUE(...)`,
`CAST(expr AS tipo)`, `GEN_ID(gen, passo)`,
bitwise: `BIN_AND/BIN_OR/BIN_XOR(n1, n2)`, `BIN_NOT(n)`, `BIN_SHL/BIN_SHR(n, shift)`,
UUID: `GEN_UUID()`, `CHAR_TO_UUID()`, `UUID_TO_CHAR()`.

---

## 8. Funções agregadas

```sql
AVG([ALL | DISTINCT] expr)
COUNT(* | [ALL | DISTINCT] expr)
LIST([ALL | DISTINCT] expr [, separator])   -- junta valores em string (separador padrão ", ")
MAX([ALL | DISTINCT] expr) / MIN(...)
SUM([ALL | DISTINCT] expr)

COUNT(*) FILTER (WHERE status = 'E')        -- cláusula FILTER vale para qualquer agregada
STDDEV_POP/STDDEV_SAMP(expr), VAR_POP/VAR_SAMP(expr),
CORR(y, x), COVAR_POP/COVAR_SAMP(y, x), REGR_* (regressão linear)
```

---

## 9. Window (analytical) functions

```sql
ROW_NUMBER() OVER (PARTITION BY dep ORDER BY salario DESC)
RANK(), DENSE_RANK(), PERCENT_RANK(), CUME_DIST(), NTILE(n)
LAG(expr [, offset [, default]]), LEAD(...),
FIRST_VALUE(expr), LAST_VALUE(expr), NTH_VALUE(expr, offset)

-- qualquer agregada pode virar window function:
SUM(valor) OVER (PARTITION BY cliente ORDER BY data
                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
```

Frames: `ROWS | RANGE { UNBOUNDED PRECEDING | n PRECEDING | CURRENT ROW } ...
{ AND ... }`; janela nomeável via cláusula `WINDOW w AS (...)`.

---

## 10. Variáveis de contexto

| Grupo | Variáveis |
| ----- | --------- |
| Sessão/conexão | `CURRENT_CONNECTION`, `CURRENT_TRANSACTION`, `CURRENT_USER`, `CURRENT_ROLE` |
| Data/hora | `CURRENT_DATE`, `CURRENT_TIME`, `CURRENT_TIMESTAMP`, `LOCALTIME`, `LOCALTIMESTAMP`, `'NOW'`, `'TODAY'`, `'TOMORROW'`, `'YESTERDAY'` |
| Triggers | `NEW.*`, `OLD.*`, `INSERTING`, `UPDATING`, `DELETING`, `RESETTING` |
| Erros (PSQL) | `GDSCODE`, `SQLCODE`, `SQLSTATE`, `ROW_COUNT` |

Contexto arbitrário: `RDB$SET_CONTEXT('USER_SESSION', 'chave', valor)` /
`RDB$GET_CONTEXT('USER_SESSION', 'chave')`.

---

## 11. Transações

```sql
SET TRANSACTION [READ WRITE | READ ONLY]
               [WAIT | NO WAIT]
               [ISOLATION LEVEL {SNAPSHOT | SNAPSHOT TABLE STABILITY
                                 | READ COMMITTED [[NO] RECORD_VERSION]}]
               [LOCK RESOLUTION {WAIT | NO WAIT [TO timeout]}];

SAVEPOINT nome; RELEASE SAVEPOINT nome;
COMMIT [WORK] [RETAING]; ROLLBACK [WORK] [RETAING];
COMMIT [WORK] RELEASE;   -- encerra conexão
```

---

## 12. Referências rápidas do servidor

- **Monitoring tables** (`MON$`): `MON$DATABASE`, `MON$ATTACHMENTS` (derrubar conexão:
  `DELETE FROM MON$ATTACHMENTS WHERE MON$ATTACHMENT_ID = ?`), `MON$STATEMENTS`
  (cancelar query: `DELETE FROM MON$STATEMENTS WHERE MON$STATEMENT_ID = ?`),
  `MON$TRANSACTIONS`, `MON$IO_STATS`, `MON$MEMORY_USAGE`, `MON$RECORD_STATS`.
- **System tables** (`RDB$`): `RDB$RELATIONS`, `RDB$RELATION_FIELDS`, `RDB$FIELDS`,
  `RDB$GENERATORS`, `RDB$EXCEPTIONS`, `RDB$TYPES` (tradução de enums internos),
  `RDB$CHECK_CONSTRAINTS`, `RDB$REF_CONSTRAINTS`.
- **Profiler**: package `RDB$PROFILER` (`START_SESSION`, `FINISH_SESSION`, `FLUSH`).
- **Appendix B** da fonte: tabela completa de códigos SQLSTATE/GDSCODE e mensagens.
- **Appendix C**: lista de reserved words e keywords.

---

## 13. Observações para o ambiente TekStore/ERP

- O banco dedicado de testes roda **Firebird 5.0.2, dialect 3, charset ISO8859_1**
  (detalhes de conexão na skill `banco-dedicado`).
- Via ODBC usar placeholders `?` (DSQL). Em PSQL, parâmetros são `:variavel`.
- Evitar sintaxes de outros bancos: `LIMIT`/`OFFSET n,m` (MySQL), `TOP` (SQL Server),
  `NVARCHAR`/`DATETIME`/`GETDATE()` (use `TIMESTAMP`/`CURRENT_TIMESTAMP`),
  `IFNULL` (use `COALESCE`), `CONCAT` (use `||`), `NOW()` (use `CURRENT_TIMESTAMP`).
