---
name: banco-erp-unidades
description: Utilize essas habilidades sempre que precisar consultar o banco de dados do ERP (DADOSMC_1032-TESTES-ERP.FDB) para ler, analisar ou estudar as unidades de codificação do módulo BI (tabela GR_UNIDADE_CODIFICACAO).
---

# Banco de dados do ERP - Unidades de Codificação

O módulo BI armazena as unidades de codificação (Pascal Script interpretado) na
tabela **`GR_UNIDADE_CODIFICACAO`**, dentro do banco de dados do próprio ERP.
Consultar essas codificações é a melhor forma de descobrir padrões reais,
métodos nativos disponíveis e a estrutura das units de teste (ver skill
`interpretador-delphi-erp`).

> **Importante**: este banco é o **banco do ERP** (somente leitura para estudo).
> Os testes automatizados **nunca** operam neste banco; eles usam o banco
> dedicado via ODBC (skill `banco-dedicado`).

## Banco de dados

| Propriedade      | Valor                                                        |
| ---------------- | ------------------------------------------------------------ |
| Arquivo `.FDB`   | Solicitar ao usuário o caminho para o arquivo.               |
| Conexão          | Solicitar conexão via servidor ao usuário com ip e porta     |
| SGBD             | Firebird 5.x                                                 |
| Charset          | `WIN1252`                                                    |
| Credencial local | `SYSDBA` / `masterkey`                                       |
| Tabela principal | `GR_UNIDADE_CODIFICACAO`                                     |

## Conexão de exemplo (isql)

```powershell
& "C:\Program Files\Firebird\Firebird_5_0\isql.exe" -user SYSDBA -password masterkey "F:\Databases\Firebird5\DADOSMC_1032-TESTES-ERP.FDB" -ch "WIN1252" -q
```

- Enviar o SQL via pipeline, ou abrir interativo.
- Para leitura de BLOBs de texto, executar **`SET BLOB ALL;`** antes da consulta.
- Não usar `cast(CODIFICACAO_UNIT as varchar(...))`: o Firebird retorna
  SQLSTATE 22003 / erro `-842 Short integer expected` para BLOBs textuais.
  Usar `SET BLOB ALL` no isql.

## ⚠️ REGRA CRÍTICA: Inserção de novas units (Auto-incremento MANUAL)

O ERP **NÃO possui triggers** para auto-incremento. O ID é controlado manualmente pela tabela **`AUTOINCREMENTOS`**.

### Tabela de controle: `AUTOINCREMENTOS`

| Coluna             | Tipo        | Descrição                                    |
| ------------------ | ----------- | -------------------------------------------- |
| `TABELA_AUTOINC`   | VARCHAR     | Nome da tabela (ex.: `GR_UNIDADE_CODIFICACAO`) |
| `QUEBRA_AUTOINC`   | INTEGER     | Partição/quebra (geralmente `0`)             |
| `CODIGO_AUTOINC`   | INTEGER     | **Próximo ID disponível**                    |

### Processo OBRIGATÓRIO para inserir nova unit:

```sql
-- 1. Consultar próximo ID
SELECT CODIGO_AUTOINC FROM AUTOINCREMENTOS 
WHERE TABELA_AUTOINC = 'GR_UNIDADE_CODIFICACAO' AND QUEBRA_AUTOINC = 0;

-- 2. Inserir na GR_UNIDADE_CODIFICACAO com o ID obtido
INSERT INTO GR_UNIDADE_CODIFICACAO (
    CODIGO_UNIT, NOME_UNIT, CODIFICACAO_UNIT, AUTOR_UNIT,
    GRUPO_UNIT, TIPO_UNIT, ARMAZENAMENTO_UNIT, ORIGEM_UNIT,
    PADRAOTEKSYSTEM_UNIT, DATAHORAINCLUSAO_UNIT, USUARIOINCLUSAO_UNIT
) VALUES (
    <proximo_id>, 'P39_TDD_NOVA_UNIT', <blob_codigo>, 'GersonTekSystem',
    1371, 0, 0, 20, 'N', CURRENT_TIMESTAMP, 'GersonTekSystem'
);

-- 3. Atualizar o auto-incremento
UPDATE AUTOINCREMENTOS 
SET CODIGO_AUTOINC = CODIGO_AUTOINC + 1
WHERE TABELA_AUTOINC = 'GR_UNIDADE_CODIFICACAO' AND QUEBRA_AUTOINC = 0;
```

> **NUNCA** insira com `CODIGO_UNIT = 0` — o ERP não consegue consultar esse registro!
> **SEMPRE** use o autor real do ERP (ex.: `GersonTekSystem`), não `OPENCODE_AGENT`.

### Exemplo atual (estado atual):
```sql
SELECT CODIGO_AUTOINC FROM AUTOINCREMENTOS 
WHERE TABELA_AUTOINC = 'GR_UNIDADE_CODIFICACAO' AND QUEBRA_AUTOINC = 0;
-- Retorna: 40 (próximo ID disponível)
```

## Outros bancos de estudo (mesma pasta, via servidor)

Os demais bancos ficam em `F:\Databases\Firebird5\` (`DADOSMC_1032-TESTES-167.FDB`,
`DADOSMC_1045.FDB`, `DADOSMC_1032-DASH.FDB`, `DADOSMC_k6.FDB`). A conexão **direta
local falha** (SQLSTATE 08001) — acessar **via servidor de aplicação**:

```powershell
& "C:\Program Files\Firebird\Firebird_5_0\isql.exe" -user SYSDBA -password masterkey "192.168.254.84/3056:F:/Databases/Firebird5/DADOSMC_k6.FDB" -ch "WIN1252" -q
```

- Cada banco tem sua própria `GR_UNIDADE_CODIFICACAO` com units de produção reais —
  excelente fonte de padrões (ex.: `API_INTEGRACAO` no k6 demonstra o uso correto de
  `GetValueJson(pJson, pTag)`).
- Em scripts bash, usar `${var}` com chaves e forward slashes no caminho do banco para
  evitar expansão incorreta do `$`.

## Estrutura de GR_UNIDADE_CODIFICACAO

| Campo                          | Tipo Firebird  | Descrição                                                        |
| ------------------------------ | -------------- | ---------------------------------------------------------------- |
| `CODIGO_UNIT`                  | LONG (Integer) | Código sequencial da unit.                                       |
| `PADRAOTEKSYSTEM_UNIT`         | TEXT (1)       | Marca a unit como padrão do sistema: `S` ou `N`.                 |
| `NOME_UNIT`                    | VARYING (60)   | Nome da unit (referenciado no `uses`).                           |
| `AUTOR_UNIT`                   | VARYING (40)   | Autor da unit.                                                   |
| `GRUPO_UNIT`                   | LONG (Integer) | Grupo funcional da unit (ver domínios abaixo).                   |
| `TIPO_UNIT`                    | SHORT          | Tipo de conteúdo da unit (ver domínios abaixo).                  |
| `ARMAZENAMENTO_UNIT`           | SHORT          | Forma de armazenamento (0 = no banco).                           |
| `URL_REPOSITORIO_PUBLICO_UNIT` | VARYING (255)  | URL do repositório público da unit (se houver).                  |
| `ORIGEM_UNIT`                  | SHORT          | Origem/canal de criação da unit (ver domínios abaixo).           |
| `CODIFICACAO_UNIT`             | BLOB           | **Código Pascal** da unit (interpretador).                       |
| `STRINGCONEXAOODBC_UNIT`       | BLOB           | String de conexão ODBC associada à unit (se houver).             |
| `OBSERVACAO_UNIT`              | BLOB           | Observações da unit.                                             |
| `DATAHORAINCLUSAO_UNIT`        | TIMESTAMP      | Data/hora de inclusão.                                           |
| `DATAHORAALTERACAO_UNIT`       | TIMESTAMP      | Data/hora de alteração.                                          |
| `USUARIOINCLUSAO_UNIT`         | VARYING (20)   | Usuário que incluiu.                                             |
| `USUARIOALTERACAO_UNIT`        | VARYING (20)   | Usuário que alterou.                                             |

## Domínios de valores observados

### GRUPO_UNIT (grupos funcionais)

| Valor | Significado                                                                                                                                      |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `0`   | Sem grupo (units diversas/padrão do sistema).                                                                                                    |
| `997` | Aniversários (`DATAANIVERSARIODIA`, `DATAANIVERSARIOMES`).                                                                                       |
| `1367`| TDD Financeiro (Config Financeiro, Duplicatas SQL, Bordero, Mapeamento de Componentes).                                                          |
| `1369`| TDD JSON base (`TDD_JSON_BASE_CADASTRO_DUPLICATAS_RECEBER`).                                                                                     |
| `1371`| Núcleo TDD (`TDD_ODBC`, `TDD_REGISTRAR_CASO_TESTE`, `TDD_CARREGAR_CASO_TESTE`, `TDD_CASOS_DE_TESTE`, `TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS`). |

### TIPO_UNIT

| Valor | Significado                                                          |
| ----- | -------------------------------------------------------------------- |
| `0`   | Pascal Script (codificação do interpretador).                        |
| `3`   | CSS (estilos web, ex.: `TEK_CSS_INDICADORES_NUMERICOS_FORMATO_WEB`). |
| `4`   | SQL puro (ex.: `TEK_SQL_MONITOR_*`, `TEK_SQL_CONFIG_FIREBIRD_4`).    |
| `5`   | JSON (ex.: `TDD_JSON_BASE_CADASTRO_DUPLICATAS_RECEBER`).             |

### ORIGEM_UNIT

| Valor | Significado                                                                                     |
| ----- | ----------------------------------------------------------------------------------------------- |
| `0`   | Units padrão do sistema.                                                                        |
| `9`   | Importada de repositório público (ex.: `TEK_CONFERE_RESERVA_COMPOSICAO`).                       |
| `20`  | Criada via módulo BI do ERP (maioria, incluindo TDD).                                           |
| `23`  | Configuração/integração (ex.: `MADEIRA_MADEIRA_CONFIGURACAO_TESTE`, `TEK_COMERCIO_INTEGRACAO`). |

### PADRAOTEKSYSTEM_UNIT

| Valor | Significado                                          |
| ----- | ---------------------------------------------------- |
| `S`   | Unit padrão do sistema TEK.                          |
| `N`   | Unit personalizada/criada no ERP.                    |

## Consultas úteis

### Listar todas as units

```sql
SELECT CODIGO_UNIT, NOME_UNIT, GRUPO_UNIT, TIPO_UNIT, ORIGEM_UNIT,
       PADRAOTEKSYSTEM_UNIT, AUTOR_UNIT
FROM GR_UNIDADE_CODIFICACAO
ORDER BY NOME_UNIT;
```

### Ler o código completo de uma unit (via isql)

```powershell
$sql = "SET BLOB ALL; SELECT CODIGO_UNIT FROM GR_UNIDADE_CODIFICACAO WHERE NOME_UNIT = 'TDD_ODBC';"
$sql | & "C:\Program Files\Firebird\Firebird_5_0\isql.exe" -user SYSDBA -password masterkey "F:\Databases\Firebird5\DADOSMC_1032-TESTES-ERP.FDB" -ch "WIN1252" -q
```

> Para salvar em arquivo e ler depois, adicionar `| Out-File -FilePath "$env:TEMP\unit.txt" -Encoding utf8`.

### Listar units por grupo (TDD)

```sql
SELECT NOME_UNIT FROM GR_UNIDADE_CODIFICACAO
WHERE GRUPO_UNIT IN (1367, 1369, 1371)
ORDER BY GRUPO_UNIT, NOME_UNIT;
```

### Units com string de conexão ODBC

```sql
SET BLOB ALL;
SELECT NOME_UNIT, STRINGCONEXAOODBC_UNIT FROM GR_UNIDADE_CODIFICACAO
WHERE STRINGCONEXAOODBC_UNIT IS NOT NULL;
```

## Boas práticas

1. **Ler as codificações antes de escrever código novo**: o código real em
   `GR_UNIDADE_CODIFICACAO` é a fonte mais confiável de métodos nativos e padrões
   (skill `interpretador-delphi-erp`).
2. Units globais do ERP têm prefixo `P39_TDD_*`; units locais em desenvolvimento
   usam `TDD_*` — ao referenciar no `uses`, usar o nome exato.
3. Consultas neste banco são **somente leitura** para estudo. Dados de teste vão
   para o banco dedicado via ODBC (`P39_TDD_ODBC`).
4. Metadados de tabelas do ERP podem ser consultados via `RDB$RELATIONS`,
   `RDB$RELATION_FIELDS` e `RDB$FIELDS` (Firebird), quando necessário.
