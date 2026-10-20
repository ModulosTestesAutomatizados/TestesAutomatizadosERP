import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-constantes",
  "categoria": "units",
  "titulo": "P39_TDD_CONSTANTES",
  "unit": "P39_TDD_CONSTANTES",
  "tipoArtefato": "unit",
  "aliases": [],
  "resumo": "Constantes de conexão e consultas compartilhadas por configurações, cache e cadastros TDD.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "units",
    "subgrupo": "constantes",
    "ordem": 0
  },
  "fontes": [
    {
      "caminho": "docs/assets/configuracoesGerais/P39_TDD_CONSTANTES.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "CDSModulos",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSAreas",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "FCacheCarregado",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "Main",
      "tipo": "metodo",
      "assinatura": "procedure Main"
    },
    {
      "nome": "GetVersao",
      "tipo": "metodo",
      "assinatura": "function GetVersao: TVersao"
    },
    {
      "nome": "GetSQLConfigFaturamento",
      "tipo": "metodo",
      "assinatura": "function GetSQLConfigFaturamento: String"
    },
    {
      "nome": "GetSQLConfigFinanceiro",
      "tipo": "metodo",
      "assinatura": "function GetSQLConfigFinanceiro: String"
    },
    {
      "nome": "SQLCasosTestes",
      "tipo": "metodo",
      "assinatura": "function SQLCasosTestes: String"
    },
    {
      "nome": "SQLModulos",
      "tipo": "metodo",
      "assinatura": "function SQLModulos: String"
    },
    {
      "nome": "SQLAreas",
      "tipo": "metodo",
      "assinatura": "function SQLAreas: String"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Centralizar os identificadores de conexão e as consultas de versão, configurações, casos, módulos e áreas."
        },
        {
          "tipo": "paragrafo",
          "texto": "Evitar duplicação desses contratos em cada consumidor; sua responsabilidade vai além de IRunner.Executar."
        }
      ]
    },
    {
      "id": "estados",
      "titulo": "Estados globais",
      "blocos": [
        {
          "tipo": "tabela",
          "colunas": [
            "Estado / tipo",
            "Finalidade",
            "Ciclo de vida"
          ],
          "linhas": [
            [
              "CDSModulos, CDSAreas: TClientDataSet",
              "Referências globais declaradas no fonte de constantes.",
              "Não recebem atribuição nas rotinas desta unit."
            ],
            [
              "FCacheCarregado: Boolean",
              "Indicador declarado neste fonte.",
              "Não é alterado pelas rotinas desta unit; P39_TDD_CACHE mantém suas próprias declarações."
            ]
          ]
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
          "texto": "Apresentar instruções."
        },
        {
          "tipo": "paragrafo",
          "texto": "Delega a MostrarInstrucoesUnit."
        }
      ]
    },
    {
      "id": "getversao",
      "titulo": "GetVersao",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetVersao: TVersao;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Ler os dados de versão do banco dedicado."
        },
        {
          "tipo": "paragrafo",
          "texto": "Cria um dataset local, lê VERSAO_CTRL via ExecuteReaderODBCServ e libera o dataset em finally."
        }
      ]
    },
    {
      "id": "getsqlconfigfaturamento",
      "titulo": "GetSQLConfigFaturamento",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetSQLConfigFaturamento: String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Montar a consulta de configuração de faturamento."
        },
        {
          "tipo": "paragrafo",
          "texto": "Seleciona os campos explicitamente listados de FATURAMENTO_CONFIGURACAO."
        }
      ]
    },
    {
      "id": "getsqlconfigfinanceiro",
      "titulo": "GetSQLConfigFinanceiro",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetSQLConfigFinanceiro: String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Montar a consulta de configuração financeira."
        },
        {
          "tipo": "paragrafo",
          "texto": "Seleciona os campos de FINANCEIRO_CONFIGURACAO."
        }
      ]
    },
    {
      "id": "sqlcasostestes",
      "titulo": "SQLCasosTestes",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function SQLCasosTestes: String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Montar a leitura de CASO_TESTE."
        },
        {
          "tipo": "paragrafo",
          "texto": "Lista os campos do caso; os filtros de ativo, área e módulo estão comentados neste gerador."
        }
      ]
    },
    {
      "id": "sqlmodulos",
      "titulo": "SQLModulos",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function SQLModulos: String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Montar a leitura de módulos."
        },
        {
          "tipo": "paragrafo",
          "texto": "Retorna código e descrição de MODULO."
        }
      ]
    },
    {
      "id": "sqlareas",
      "titulo": "SQLAreas",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function SQLAreas: String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Montar a leitura de áreas e módulos."
        },
        {
          "tipo": "paragrafo",
          "texto": "Consulta AREA com LEFT JOIN em MODULO."
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
            "cDataBase preserva a conexão usada por GetVersao; cConexaoODBCPadrao centraliza a conexão cliente de 32 bits utilizada por P39_TDD_ODBC.",
            "TVersao contém Versao, Codigo e Numero."
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
            "P39_TDD_RUN_LOGS fornece a apresentação de instruções."
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
            "A geração de SQL não aplica filtros adicionais automaticamente.",
            "Os campos de cache declarados aqui não comprovam que o cache seja carregado por esta unit."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
