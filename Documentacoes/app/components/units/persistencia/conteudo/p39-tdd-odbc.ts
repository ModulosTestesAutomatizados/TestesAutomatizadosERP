import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-odbc",
  "categoria": "units",
  "titulo": "P39_TDD_ODBC",
  "unit": "P39_TDD_ODBC",
  "tipoArtefato": "unit",
  "aliases": [],
  "resumo": "Wrappers de leitura, comando e valor escalar usando a conexão ODBC compartilhada do TDD.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "units",
    "subgrupo": "persistencia",
    "ordem": 0
  },
  "fontes": [
    {
      "caminho": "docs/assets/configuracoesGerais/P39_TDD_ODBC.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "Main",
      "tipo": "metodo",
      "assinatura": "procedure Main"
    },
    {
      "nome": "TDDScalarODBC",
      "tipo": "metodo",
      "assinatura": "function TDDScalarODBC(pSql: String): OleVariant"
    },
    {
      "nome": "TDDScalarODBCP",
      "tipo": "metodo",
      "assinatura": "function TDDScalarODBCP(pSql: String; pParametros: OleVariant): OleVariant"
    },
    {
      "nome": "TDDReaderODBC",
      "tipo": "metodo",
      "assinatura": "function TDDReaderODBC(pSql: String): OleVariant"
    },
    {
      "nome": "TDDReaderODBCP",
      "tipo": "metodo",
      "assinatura": "function TDDReaderODBCP(pSql: String; pParametros: OleVariant): OleVariant"
    },
    {
      "nome": "TDDCommandODBC",
      "tipo": "metodo",
      "assinatura": "function TDDCommandODBC(pSql: String): OleVariant"
    },
    {
      "nome": "TDDCommandODBCP",
      "tipo": "metodo",
      "assinatura": "function TDDCommandODBCP(pSql: String; pParametros: OleVariant): OleVariant"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Encaminhar operações ao host ODBC usando cConexaoODBCPadrao."
        },
        {
          "tipo": "paragrafo",
          "texto": "Padronizar a conexão cliente de 32 bits entre consumidores, sem restringir a infraestrutura ao IRunner."
        }
      ]
    },
    {
      "id": "estados",
      "titulo": "Estados globais",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Esta unit não declara estado global próprio. Os artefatos consumidos do contexto interpretado são descritos na implementação abaixo."
        }
      ]
    },
    {
      "id": "metodos",
      "titulo": "Procedures e functions",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "As assinaturas abaixo pertencem ao fonte referenciado. Cada entrada descreve sua responsabilidade e a forma de implementação."
        }
      ]
    },
    {
      "id": "main",
      "titulo": "Main",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Main;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Apresentar o contrato dos wrappers."
        },
        {
          "tipo": "paragrafo",
          "texto": "Mostra instruções de uso dos métodos com e sem parâmetros."
        }
      ]
    },
    {
      "id": "tddscalarodbc",
      "titulo": "TDDScalarODBC",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function TDDScalarODBC(pSql: String): OleVariant;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Consultar um valor escalar sem parâmetros."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama TDDScalarODBCP passando null."
        }
      ]
    },
    {
      "id": "tddscalarodbcp",
      "titulo": "TDDScalarODBCP",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function TDDScalarODBCP(pSql: String; pParametros: OleVariant): OleVariant;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Consultar um valor escalar com parâmetros."
        },
        {
          "tipo": "paragrafo",
          "texto": "Delega a ExecuteScalarODBC com a conexão padrão."
        }
      ]
    },
    {
      "id": "tddreaderodbc",
      "titulo": "TDDReaderODBC",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function TDDReaderODBC(pSql: String): OleVariant;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Ler dados sem parâmetros."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama TDDReaderODBCP passando null."
        }
      ]
    },
    {
      "id": "tddreaderodbcp",
      "titulo": "TDDReaderODBCP",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function TDDReaderODBCP(pSql: String; pParametros: OleVariant): OleVariant;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Ler dados com parâmetros."
        },
        {
          "tipo": "paragrafo",
          "texto": "Delega a ExecuteReaderODBC com a conexão padrão."
        }
      ]
    },
    {
      "id": "tddcommandodbc",
      "titulo": "TDDCommandODBC",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function TDDCommandODBC(pSql: String): OleVariant;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Executar um comando sem parâmetros."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama TDDCommandODBCP passando null."
        }
      ]
    },
    {
      "id": "tddcommandodbcp",
      "titulo": "TDDCommandODBCP",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function TDDCommandODBCP(pSql: String; pParametros: OleVariant): OleVariant;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Executar um comando com parâmetros."
        },
        {
          "tipo": "paragrafo",
          "texto": "Delega a ExecuteCommandODBC com a conexão padrão."
        }
      ]
    },
    {
      "id": "implementacao",
      "titulo": "Como a unit é implementada",
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Não declara conexão ou dataset global próprio; o host fornece os métodos e P39_TDD_CONSTANTES fornece a identificação da conexão."
          ]
        }
      ]
    },
    {
      "id": "dependencias",
      "titulo": "Dependências e integração",
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "P39_TDD_CONSTANTES é a dependência direta."
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "O nome canônico identifica o arquivo Pascal e a página. O fonte vinculado é a evidência local; confira o cadastro e a versão da unit instalada no ERP antes de executar."
        }
      ]
    },
    {
      "id": "limites",
      "titulo": "Limites e observações",
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Os wrappers não implementam transação, reconexão ou tratamento de exceções próprios.",
            "Os tipos concretos e a liberação do resultado dependem da API do host e do consumidor."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
