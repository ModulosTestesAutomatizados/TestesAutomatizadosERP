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
        bigint MODULO_AREA FK "NOT NULL"
    }
    CASO_TESTE {
        bigint AUTOINC_CT PK "NOT NULL"
        bigint MODULO_CT FK "NOT NULL"
        bigint AREA_CT FK "NOT NULL"
        varchar(255) DESCRICAO_CASO_TESTE_CT "NOT NULL"
        blob CASO_TESTE_CT "JSON"
        blob CAMPOS_DISPONIVEIS_CT "JSON"
        blob RESULTADO_ESPERADO_CT "JSON"
        varchar(40) REQUISITO_VERSAO "Versao minima opcional"
        char(1) ATIVO_CT "DEFAULT 'S' CHECK (S/N)"
        blob JSON_CASO_TESTE
    }
    HISTORICO_EXECUCAO_TESTE {
        integer AUTOINC_HISTORICO PK "NOT NULL"
        bigint AUTOINC_CASO_TESTE FK "NOT NULL"
        varchar(40) VERSAO_EXECUCAO
        varchar(40) REQUISITO_VERSAO
        varchar(20) STATUS_EXECUCAO
        integer ETAPA_FALHA
        blob MENSAGEM_ERRO "TEXT UTF8"
        blob LOGS_FALHAS "TEXT UTF8"
        timestamp DATA_HORA_EXECUCAO "DEFAULT CURRENT_TIMESTAMP"
    }
    METRICAS_TICK_DIFF {
        integer AUTOINC_METRICA_TICK_DIFF PK "NOT NULL"
        integer AUTOINC_HISTORICO FK "NOT NULL"
        varchar(120) NOME_METODO "UTF8"
        integer ETAPA_CASO_TESTE
        integer TEMPO_INICIO "ms"
        integer TEMPO_FIM "ms"
        integer TEMPO_TOTAL "ms"
        varchar(20) TEMPO_TOTAL_FORMATADO "UTF8 - HH:MM:SS:MS"
    }
    METRICAS_ASSERTS {
        integer AUTOINC_METRICA_ASSERTS PK "NOT NULL"
        integer AUTOINC_HISTORICO FK "NOT NULL"
        integer ETAPA_CASO_TESTE
        integer TEMPO_TOTAL "ms"
        integer ASSERTS_TOTAL
        integer ASSERTS_APROVADOS
        integer ASSERTS_FALHOS
        blob RESULTADO_ESPERADO "TEXT UTF8"
        blob RESULTADO_OBTIDO "TEXT UTF8"
    }
    UNIT {
        bigint CODIGO_UNIT PK "NOT NULL"
        varchar(60) NOME_UNIT UK "NOT NULL"
        blob CODIFICACAO_UNIT
        blob OBSERVACAO_UNIT
        bigint MODULO_UNIT FK "NOT NULL DEFAULT 0"
    }
    PROCESSAMENTO {
        integer CODIGO_PROCESSAMENTO PK "NOT NULL"
        varchar(60) DESCRICAO_PROCESSAMENTO UK "NOT NULL"
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
        blob DADOS_FINCONFIG "resumo: 15 campos de configuração"
    }

    MODULO ||--o{ AREA : "possui"
    MODULO ||--o{ CASO_TESTE : "possui"
    AREA ||--o{ CASO_TESTE : "possui"
    CASO_TESTE ||--o{ HISTORICO_EXECUCAO_TESTE : "gera"
    HISTORICO_EXECUCAO_TESTE ||--o{ METRICAS_TICK_DIFF : "mede"
    HISTORICO_EXECUCAO_TESTE ||--o{ METRICAS_ASSERTS : "consolida"
    MODULO ||--o{ UNIT : "possui"
    MODULO ||--o{ PROCESSAMENTO : "possui (FK implícita)"
    MODULO ||--o{ SCRIPT : "possui (FK implícita)"
```

## Notas

### FKs implícitas

`PROCESSAMENTO.MODULO_PROCESSAMENTO` e `SCRIPT.MODULO_SCRIPT` referenciam
semanticamente `MODULO.CODIGO_MODULO`, mas **não existe constraint FOREIGN KEY
no schema**. O diagrama mantém essas relações destacadas como "FK implícita"
para documentar a intenção.

### Tabelas de configuração sem PK

`FATURAMENTO_CONFIGURACAO` e `FINANCEIRO_CONFIGURACAO` **não possuem chave
primária** de forma proposital: armazenam apenas **um único registro** de
configuração global, sem necessidade de identificação individual.
