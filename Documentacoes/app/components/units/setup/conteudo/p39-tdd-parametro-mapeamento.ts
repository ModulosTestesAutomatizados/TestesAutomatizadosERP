import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-parametro-mapeamento",
  "categoria": "units",
  "titulo": "P39_TDD_PARAMETRO_MAPEAMENTO",
  "unit": "P39_TDD_PARAMETRO_MAPEAMENTO",
  "tipoArtefato": "unit",
  "aliases": [],
  "resumo": "Relaciona as chaves JSON de parâmetros aos campos e tabelas de configuração do ERP.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "units",
    "subgrupo": "setup",
    "ordem": 3
  },
  "fontes": [
    {
      "caminho": "docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO_MAPEAMENTO.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "FParametroMapeado",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "FMapeamentoParam",
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
      "nome": "GetTabela",
      "tipo": "metodo",
      "assinatura": "function GetTabela(pCampo: String): String"
    },
    {
      "nome": "GetCampoJsonParametro",
      "tipo": "metodo",
      "assinatura": "function GetCampoJsonParametro(pCampoDB: String): String"
    },
    {
      "nome": "GetCampoDBParametro",
      "tipo": "metodo",
      "assinatura": "function GetCampoDBParametro(pCampoJson: String): String"
    },
    {
      "nome": "GetCampo",
      "tipo": "metodo",
      "assinatura": "function GetCampo(pTipo: Integer; pCampo: String): String"
    },
    {
      "nome": "MapearParametros",
      "tipo": "metodo",
      "assinatura": "procedure MapearParametros"
    },
    {
      "nome": "AddParamMapped",
      "tipo": "metodo",
      "assinatura": "procedure AddParamMapped(pIdx: Integer; const pChaveJson, pCampoDB, pTabela: String)"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Resolver o nome JSON, o campo do banco e a tabela correspondente para cada parâmetro registrado."
        },
        {
          "tipo": "paragrafo",
          "texto": "Separar o vocabulário do caso de teste do esquema de configuração usado por P39_TDD_PARAMETRO."
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
              "FParametroMapeado: Boolean",
              "Controla o preenchimento do mapa.",
              "MapearParametros preenche uma vez e marca True; não há reset declarado."
            ],
            [
              "FMapeamentoParam: array [0..8] of TMapeamentoParametro",
              "Nove relações CampoJSON, CampoDB e Tabela.",
              "Preenchidas por AddParamMapped; disponíveis no contexto da unit."
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
      "id": "gettabela",
      "titulo": "GetTabela",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetTabela(pCampo: String): String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Resolver a tabela do parâmetro."
        },
        {
          "tipo": "paragrafo",
          "texto": "Delega a GetCampo com o seletor de tabela."
        }
      ]
    },
    {
      "id": "getcampojsonparametro",
      "titulo": "GetCampoJsonParametro",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetCampoJsonParametro(pCampoDB: String): String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Converter campo do banco para chave JSON."
        },
        {
          "tipo": "paragrafo",
          "texto": "Consulta GetCampo com o seletor de campo JSON."
        }
      ]
    },
    {
      "id": "getcampodbparametro",
      "titulo": "GetCampoDBParametro",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetCampoDBParametro(pCampoJson: String): String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Converter chave JSON para campo do banco."
        },
        {
          "tipo": "paragrafo",
          "texto": "Consulta GetCampo com o seletor de campo do banco."
        }
      ]
    },
    {
      "id": "getcampo",
      "titulo": "GetCampo",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetCampo(pTipo: Integer; pCampo: String): String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Buscar a relação cadastrada."
        },
        {
          "tipo": "paragrafo",
          "texto": "Percorre o array; campo vazio ou relação ausente resultam em string vazia."
        }
      ]
    },
    {
      "id": "mapearparametros",
      "titulo": "MapearParametros",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure MapearParametros;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Preencher o mapa de parâmetros."
        },
        {
          "tipo": "paragrafo",
          "texto": "Registra as nove relações quando FParametroMapeado está False."
        }
      ]
    },
    {
      "id": "addparammapped",
      "titulo": "AddParamMapped",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure AddParamMapped(pIdx: Integer; const pChaveJson, pCampoDB, pTabela: String);"
        },
        {
          "tipo": "paragrafo",
          "texto": "Atribuir uma relação no array."
        },
        {
          "tipo": "paragrafo",
          "texto": "Grava CampoJSON, CampoDB e Tabela na posição recebida."
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
            "As constantes identificam CONFIG_SISTEMA, CONFIG_SISTEMA_EMPRESA e PCP_CONFIG e os seletores de consulta.",
            "A lista é fixa no fonte: ampliar parâmetros exige revisar o limite do array e os registros."
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
            "TDD_RUN_LOGS fornece instruções; P39_TDD_PARAMETRO consome o mapa para comparação e UPDATE."
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
            "Não há validação explícita de pIdx antes da atribuição nem registro dinâmico de parâmetros.",
            "A consulta não inicializa o mapa automaticamente; o setup consumidor deve chamar MapearParametros."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
