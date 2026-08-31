# Banco de dados — Referência de conexão

Este arquivo define, de forma centralizada, **quais bancos de dados** usar conforme
o propósito do teste. Use-o para saber sempre a qual banco conectar, evitando
ambiguidade entre "banco que executa os testes" e "banco que registra os testes".

> Regra de ouro: os testes automatizados **nunca** operam diretamente no banco do
> ERP/produção. Eles usam os bancos dedicados abaixo, conforme o papel de cada um.

---

## 1. Banco que EXECUTA os casos de teste

| Propriedade      | Valor                                                      |
| ---------------- | ---------------------------------------------------------- |
| Papel            | Banco onde os testes são **executados** (dados/datas-base de processamento). |
| Arquivo `.FDB`   | `DADOSMC.FDB`                                              |
| Conexão          | `192.168.254.167/3055:D:\DataBases\TesteAutomatizado\DADOSMC.FDB` |
| SGBD             | Firebird                                                   |
| Observação       | É o "banco padrão que executa os casos de teste".          |

> Sempre que a tarefa falar em **executar** casos de teste / processamento, conectar
> neste banco.

### 1.1. Como gerar o código ao inserir registros (banco que EXECUTA)

Ao **incluir um registro** em qualquer tabela deste banco (`DADOSMC.FDB`), a regra
para gerar o código da chave é: **verificar, por tabela**, se ela usa **Generator**
ou se está contida na tabela de **`AUTOINCREMENTOS`**.

1. **Se a tabela possui Generator** (`GEN_*` — existem vários, ex.: `GEN_ACAO`,
   `GEN_BORDERO`, `GEN_MOVIMENTO_ESTOQUE`, `GEN_PCP_ORDEMPRODUCAO_ITEM`, etc.):
   usar `NEXT VALUE FOR <GEN_...>` para gerar o código.

   - Para descobrir os generators deste banco:

     ```sql
     SELECT RDB$GENERATOR_NAME
       FROM RDB$GENERATORS
      WHERE RDB$SYSTEM_FLAG = 0
      ORDER BY RDB$GENERATOR_NAME;
     ```

2. **Se a tabela está contida na tabela `AUTOINCREMENTOS`** (colunas
   `TABELA_AUTOINC`, `QUEBRA_AUTOINC`, `CODIGO_AUTOINC`): ler o valor atual de
   `CODIGO_AUTOINC` para a tabela e **somar 1** para obter o próximo código
   (assim como o próprio ERP faz).

   ```sql
   -- Ler o último código usado para a tabela
   SELECT TABELA_AUTOINC, QUEBRA_AUTOINC, CODIGO_AUTOINC
     FROM AUTOINCREMENTOS
    WHERE TABELA_AUTOINC = '<NOME_DA_TABELA>';
   ```

   Exemplo de padrão já populado: `PCP_ENTSAI_ESTOQUE` → `CODIGO_AUTOINC` 5310.

> **Resumo:** há tabelas com `GEN_*` e tabelas na `AUTOINCREMENTOS`. Antes de
> inserir, verifique qual dos dois mecanismos a tabela usa.
>
> ⚠️ Em qualquer banco, ao incluir registro, **nunca** gerar o código manualmente
> de forma arbitrária/aleatória — o próximo código deve vir do Generator ou da
> `AUTOINCREMENTOS` + 1, exatamente como o ERP faz.

---

## 2. Banco que REGISTRA os casos de teste

| Propriedade      | Valor                                                      |
| ---------------- | ---------------------------------------------------------- |
| Papel            | Banco onde ficam os **registros dos casos de teste** (tabelas `CASO_TESTE`, etc.) e a configuração de unidades de codificação. |
| Arquivo `.FDB`   | `TESTEAUTOMATIZADOMC.FDB`                                  |
| Conexão          | `192.168.254.167/3055:D:\DataBases\TesteAutomatizado\TESTEAUTOMATIZADOMC.FDB` |
| SGBD             | Firebird 5                                                 |
| Observação       | É o "banco padrão que registra os casos de teste".         |

> Sempre que a tarefa envolver **registrar casos de teste**, **inserir/atualizar
> a configuração** dos testes ou **ler a configuração** dos testes, conectar neste
> banco.

### 2.1. Como gerar o código ao inserir registros (banco que REGISTRA)

Este banco usa **generators** para gerar códigos. Ao incluir um registro em tabelas
como `UNIT`, `CASO_TESTE`, `VERSAO`, `MODULO`, etc., usar `NEXT VALUE FOR <GEN_...>`.

Generators existentes neste banco (exemplo): `GEN_AREA`, `GEN_CAM_EXECUTAVEIS`,
`GEN_CASO_TESTE`, `GEN_CASO_TESTE_EXECUCAO_ID`, `GEN_MODULO`, `GEN_UNIT`,
`GEN_VERSAO`.

Exemplo para gerar o próximo código da tabela `UNIT`:

```sql
SELECT NEXT VALUE FOR GEN_UNIT FROM RDB$DATABASE;
```

> Para descobrir todos os generators deste banco, use a mesma consulta da
> seção 1.1 (item 1) sobre `RDB$GENERATORS`.

---

## 3. Resumo de decisão rápida

| Pergunta / cenário                                   | Banco a conectar        |
| ---------------------------------------------------- | ----------------------- |
| Executar caso de teste / processamento               | `DADOSMC.FDB`           |
| Inserir dados/massa de teste no banco que executa    | `DADOSMC.FDB` (regra de generator/AUTOINCREMENTOS §1.1) |
| Registrar / buscar casos de teste, config            | `TESTEAUTOMATIZADOMC.FDB` |
| Operar banco do ERP para estudo de codificações      | ver skill `banco-erp-unidades` |

> **Geração de código ao inserir:** banco que executa → `GEN_*` ou `AUTOINCREMENTOS`
> + 1; banco que registra → `GEN_*` (`NEXT VALUE FOR`). Nunca gerar código manual/aleatório.

---

## 4. Inclusão de units — regra padrão

> ⚠️ **Regra atualizada:** a inclusão de units TDD de codificação (ex.: `TDD_*`)
> deve ser feita **por padrão** no banco que **EXECUTA** os casos de teste
> (`DADOSMC.FDB`), na tabela **`GR_UNIDADE_CODIFICACAO`**.
>
> Quando o usuário solicitar **explicitamente** a inclusão no banco que **REGISTRA**
> (`TESTEAUTOMATIZADOMC.FDB`), aí sim usar a tabela `UNIT` deste banco.

| Banco | Tabela para units |
|-------|-------------------|
| `DADOSMC.FDB` (executa) | `GR_UNIDADE_CODIFICACAO` |
| `TESTEAUTOMATIZADOMC.FDB` (registra) | `UNIT` |

Histórico: a prática anterior de incluir units no banco que REGISTRA foi
considerada incorreta. A regra agora é: units vão para o banco que EXECUTA
(tabela `GR_UNIDADE_CODIFICACAO`), a menos que o usuário instrua o contrário.
