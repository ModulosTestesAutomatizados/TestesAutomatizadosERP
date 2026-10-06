# Modelo Entidade-Relacionamento — TESTEAUTOMATIZADOMC.FDB

Diagrama do banco de dados dedicado de testes automatizados (Firebird 5).

## Diagrama

```mermaid
erDiagram
    MODULO {
        bigint CODIGO_MODULO PK "NOT NULL"
        varchar(40) DESCRICAO_MODULO UK "NOT NULL"
    }
    AREA {
        bigint AUTOINC_AREA PK "NOT NULL"
        varchar(50) DESCRICAO_AREA
        bigint MODULO_AREA FK
    }
    CASO_TESTE {
        bigint AUTOINC_CT PK "NOT NULL"
        bigint MODULO_CT FK "NOT NULL"
        bigint AREA_CT FK
        varchar(255) DESCRICAO_CASO_TESTE_CT "NOT NULL"
        blob CASO_TESTE_CT "TEXT ISO8859_1 - JSON"
        char(1) ATIVO_CT "DEFAULT 'S' CHECK (S/N)"
        blob CAMPOS_DISPONIVEIS_CT "TEXT ISO8859_1 - JSON"
        blob RESULTADO_ESPERADO_CT "TEXT ISO8859_1 - JSON"
        blob JSON_CASO_TESTE "TEXT ISO8859_1 - JSON"
        varchar(10) REQUISITO_VERSAO_CT "Versao minima opcional"
    }
    HISTORICO_EXECUCAO {
        integer AUTOINC_HISTORICO_HE PK "IDENTITY NOT NULL"
        bigint AUTOINC_CASO_TESTE_HE FK "NOT NULL"
        varchar(10) VERSAO_EXECUCAO_HE
        varchar(10) REQUISITO_VERSAO_HE
        varchar(20) STATUS_EXECUCAO_HE "SUCESSO/FALHA/ERROS/INCOMPATIVEL_VERSAO"
        integer ETAPA_FALHA_HE
        blob MENSAGEM_ERRO_HE "TEXT UTF8"
        blob LOGS_FALHAS_HE "TEXT UTF8"
        timestamp DATA_HORA_EXECUCAO_HE "DEFAULT CURRENT_TIMESTAMP"
    }
    METRICAS_TICK_DIFF {
        integer AUTOINC_METRICA_TICK_DIFF_TD PK "IDENTITY NOT NULL"
        integer AUTOINC_HISTORICO_HE FK "NOT NULL"
        varchar(120) NOME_METODO_TD "UTF8"
        integer ETAPA_CASO_TESTE_TD
        integer TEMPO_INICIO_TD "ms"
        integer TEMPO_FIM_TD "ms"
        integer TEMPO_TOTAL_TD "ms"
        varchar(20) TEMPO_TOTAL_FORMATADO_TD "UTF8 - HH:MM:SS:MS"
    }
    METRICAS_ASSERTS {
        integer AUTOINC_METRICA_ASSERTS_AT PK "IDENTITY NOT NULL"
        integer AUTOINC_HISTORICO_HE FK "NOT NULL"
        integer ETAPA_CASO_TESTE_AT
        integer TEMPO_TOTAL_AT "ms"
        integer ASSERTS_TOTAL_AT
        integer ASSERTS_APROVADOS_AT
        integer ASSERTS_FALHOS_AT
        blob RESULTADO_ESPERADO_AT "TEXT UTF8"
        blob RESULTADO_OBTIDO_AT "TEXT UTF8"
    }
    UNIT {
        bigint CODIGO_UNIT PK "NOT NULL"
        varchar(60) NOME_UNIT UK
        blob CODIFICACAO_UNIT
        blob OBSERVACAO_UNIT
        bigint MODULO_UNIT FK "DEFAULT 0"
    }
    PROCESSAMENTO {
        integer CODIGO_PROCESSAMENTO PK "NOT NULL"
        varchar(60) DESCRICAO_PROCESSAMENTO UK
        blob CODIFICACAO_PROCESSAMENTO "NOT NULL"
        blob OBSERVACAO_PROCESSAMENTO
        bigint MODULO_PROCESSAMENTO "FK implícita"
    }
    SCRIPT {
        bigint CODIGO_SCRIPT PK "NOT NULL"
        varchar(40) DESCRICAO_SCRIPT "NOT NULL"
        integer MODULO_SCRIPT "FK implícita"
        varchar(255) COMANDOS_SCRIPT
    }
    CAMINHO_EXECUTAVEIS {
        bigint CODIGO_CAMINHO_EXE PK "NOT NULL"
        varchar(40) DESCRICAO_CAMINHO_EXE
        varchar(255) CAMINHOCOMPLETO_CAMINHO_EXE
        varchar(255) BASEDADOS_CAMINHO_EXE
        varchar(50) USUARIO
        varchar(50) SENHA
    }
    VERSAO {
        bigint CODIGO_VERSAO PK "NOT NULL"
        varchar(40) DESCRICAO_VERSAO "NOT NULL"
        blob OBS_VERSAO
    }
    FATURAMENTO_CONFIGURACAO {
        blob DADOS_FATCONFIG "resumo: 22 campos de configuração"
    }
    FINANCEIRO_CONFIGURACAO {
        blob DADOS_FINCONFIG "resumo: 14 campos de configuração"
    }

    MODULO ||--o{ AREA : "possui"
    MODULO ||--o{ CASO_TESTE : "possui"
    AREA ||--o{ CASO_TESTE : "possui"
    CASO_TESTE ||--o{ HISTORICO_EXECUCAO : "gera"
    HISTORICO_EXECUCAO ||--o{ METRICAS_TICK_DIFF : "mede"
    HISTORICO_EXECUCAO ||--o{ METRICAS_ASSERTS : "consolida"
    MODULO ||--o{ UNIT : "possui"
    MODULO ||--o{ PROCESSAMENTO : "possui (FK implícita)"
    MODULO ||--o{ SCRIPT : "possui (FK implícita)"
```

## Notas

### Blobs de `CASO_TESTE`

Todas as colunas de JSON — `CASO_TESTE_CT`, `CAMPOS_DISPONIVEIS_CT`,
`RESULTADO_ESPERADO_CT` e `JSON_CASO_TESTE` — são **blob texto** (`SUB_TYPE 1`,
`ISO8859_1`).

O Firebird não permite alterar o tipo de uma coluna existente com `ALTER
TABLE`. A conversão foi feita pela técnica das 4 fases: criar a coluna nova no
tipo alvo → `UPDATE` movendo os dados → `DROP` da coluna antiga →
`ALTER COLUMN ... TO` renomeando a nova para o nome original. Por isso a
conversão roda em **duas transações**: a Fase 1 precisa de `COMMIT` para o DML
enxergar a coluna nova, e as Fases 2–4 ficam num único bloco atômico.

Scripts: `sql/migracao_blob_binario_para_texto_caso_teste.sql` (2 primeiras
colunas + criação de `JSON_CASO_TESTE`) e
`sql/temp-local/migracao_blob_binario_para_texto_caso_teste_ct.sql`
(`CASO_TESTE_CT`).

A conversão de `CASO_TESTE_CT` o moveu para a última posição da tabela, já que o
Firebird não permite reordenar colunas. O código não é afetado: usa listas
explícitas de colunas e `FieldByName`.

### Tabelas de métricas do TDD_RUNNER

`HISTORICO_EXECUCAO`, `METRICAS_TICK_DIFF` e `METRICAS_ASSERTS` foram criadas por
`sql/migracao_tdd_runner_metricas.sql`. São gravadas por `P39_TDD_FINISHED.pas`
(`INSERT ... RETURNING AUTOINC_HISTORICO_HE`) e lidas pelo `TDD_RUNNER`.
`STATUS_EXECUCAO_HE` é validado por `CK_HISTORICO_EXECUCAO_STATUS`.

### FKs implícitas

`PROCESSAMENTO.MODULO_PROCESSAMENTO` e `SCRIPT.MODULO_SCRIPT` referenciam
semanticamente `MODULO.CODIGO_MODULO`, mas **não existe constraint FOREIGN KEY
no schema**. O diagrama mantém essas relações destacadas como "FK implícita"
para documentar a intenção.

### Tabelas de configuração sem PK

`FATURAMENTO_CONFIGURACAO` e `FINANCEIRO_CONFIGURACAO` **não possuem chave
primária** de forma proposital: armazenam apenas **um único registro** de
configuração global, sem necessidade de identificação individual.
