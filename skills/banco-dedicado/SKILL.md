---
name: banco-dedicado
description: Utilize essas habilidades sempre que precisar montar consultas SQL para lidar com o banco de dados dedicado de testes automatizados (TESTEAUTOMATIZADOMC.FDB).
---

# Banco de dados dedicado

Os testes automatizados do ERP não operam diretamente no banco vinculado ao
aplicativo. Eles utilizam um **banco de dados dedicado** de testes, hospedado
em Firebird 5, que é acessado exclusivamente por conexão **ODBC de 32 bits**
no cliente.

> **Nota:** a referência central dos bancos (qual conectar para executar vs.
> para registrar, e **como gerar o código ao inserir registros**) está em
> **[databases.md](databases.md)**. Sempre que a tarefa envolver "banco que
> executa os testes" ou "banco que registra os testes", ou a **inclusão de
> registros**, consultar `databases.md` antes de montar a conexão.
>
> - **Executa** os casos de teste → `DADOSMC.FDB`
> - **Registra** os casos de teste (casos/config) → `TESTEAUTOMATIZADOMC.FDB`
>
> ## Regra de inclusão de registros (crítica)
>
> Ao **inserir registros em qualquer tabela dos bancos dedicados**, o código da
> chave jamais deve ser gerado manualmente/aleatoriamente. A regra (detalhada em
> `databases.md`) é:
>
> - **Banco que EXECUTA** (`DADOSMC.FDB`): por tabela, usar `NEXT VALUE FOR
>   <GEN_*>` **ou** somar 1 ao `CODIGO_AUTOINC` da tabela `AUTOINCREMENTOS`.
> - **Banco que REGISTRA** (`TESTEAUTOMATIZADOMC.FDB`): usar `NEXT VALUE FOR
>   <GEN_*>`.
>
> ## Inclusão de units (regra padrão)
>
> A inclusão de units TDD de codificação (ex.: `TDD_*`) deve ser feita **por padrão**
> no banco que **EXECUTA** os casos de teste (`DADOSMC.FDB`), na tabela
> **`GR_UNIDADE_CODIFICACAO`**.
>
> Quando o usuário solicitar explicitamente a inclusão no banco que **REGISTRA**
> (`TESTEAUTOMATIZADOMC.FDB`), aí sim usar a tabela `UNIT` deste banco.

## Conexão ODBC

A conexão é centralizada e padronizada. **Nunca** deve ser criada uma nova
string de conexão na codificação de teste — sempre use a abstração existente:

| Artefato                       | Responsabilidade                                                        |
| ------------------------------ | ----------------------------------------------------------------------- |
| `P39_TDD_CONSTANTES`           | Declara a constante `cConexaoODBCPadrao` com a string de conexão.       |
| `P39_TDD_ODBC`                 | Centraliza os métodos ODBC e mantém a conexão em 32 bits (cliente).     |

## Métodos disponíveis (P39_TDD_ODBC)

| Método                          | Finalidade                                              |
| ------------------------------- | ------------------------------------------------------- |
| `TDDCommandODBC(pSql, pParametros)` | Operações de escrita, como INSERT e UPDATE.            |
| `TDDReaderODBC(pSql, pParametros)`  | Operações de leitura com retorno de múltiplos registros. |
| `TDDScalarODBC(pSql, pParametros)`  | Operações de leitura com retorno de um único valor.     |

## Regras para montar consultas

1. Utilizar exclusivamente os métodos `TDD*ODBC` da unit `P39_TDD_ODBC`.
2. Passar `pParametros := null` ao usar `Format(sql, [parâmetros])`.
3. Não declarar strings de conexão locais; depender sempre de
   `cConexaoODBCPadrao`.
4. O banco dedicado é um Firebird 5; consultas devem respeitar a sintaxe
   Firebird (ex.: `SELECT FIRST n`, `RDB$` apenas para metadados).
5. Antes de escrever consultas sobre tabelas desconhecidas, consultar o
   diagrama do modelo de dados em `docs/MER.md`.

## Modelo de dados

O esquema do banco dedicado (tabelas, colunas, PKs e relacionamentos) está
documentado em `docs/MER.md`, no formato Mermaid ER.

## Operações de escrita e testes

Toda manipulação de dados usada como massa de teste deve ser executada
através dos métodos ODBC. Os testes devem operar apenas no banco dedicado,
nunca no banco de produção/ERP.
