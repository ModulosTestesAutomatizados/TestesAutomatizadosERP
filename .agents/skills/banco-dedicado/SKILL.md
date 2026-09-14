---
name: banco-dedicado
description: Utilize essas habilidades sempre que precisar montar consultas SQL para lidar com o banco de dados dedicado de testes automatizados (TESTEAUTOMATIZADOMC.FDB).
---

# Banco de dados dedicado

Os testes automatizados do ERP não operam diretamente no banco vinculado ao
aplicativo. Eles utilizam um **banco de dados dedicado** de testes, hospedado
em Firebird 5, que é acessado exclusivamente por conexão **ODBC de 32 bits**
no cliente.

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

## Separação de migrations e scripts

- Experimentos, migrations em validação local e SQLs gerados durante a tarefa devem ficar em `sql/temp-local/`.
- O diretório `sql/` contém somente scripts aprovados para execução no banco de produção.
- Nunca promover um script de `sql/temp-local/` para `sql/` sem validação e aprovação explícita do usuário.
- Ao criar ou alterar tabelas do banco dedicado, atualizar `docs/MER.md` na mesma tarefa.
