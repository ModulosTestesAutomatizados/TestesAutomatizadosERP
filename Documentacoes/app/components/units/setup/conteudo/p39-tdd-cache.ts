import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-cache",
  "categoria": "units",
  "titulo": "P39_TDD_CACHE",
  "unit": "P39_TDD_CACHE",
  "tipoArtefato": "unit",
  "aliases": [],
  "resumo": "Carrega e consulta módulos e áreas do banco dedicado para preparar o contexto dos testes.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "units",
    "subgrupo": "setup",
    "ordem": 1
  },
  "fontes": [
    {
      "caminho": "docs/assets/configuracoesGerais/P39_TDD_CACHE.pas"
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
      "nome": "Cache_Setup_CarregarInformacoes",
      "tipo": "metodo",
      "assinatura": "procedure Cache_Setup_CarregarInformacoes"
    },
    {
      "nome": "Cache_TearDown_LimparInformacoes",
      "tipo": "metodo",
      "assinatura": "procedure Cache_TearDown_LimparInformacoes"
    },
    {
      "nome": "VerificaCarregamentoCache",
      "tipo": "metodo",
      "assinatura": "procedure VerificaCarregamentoCache"
    },
    {
      "nome": "AreaPeloNome",
      "tipo": "metodo",
      "assinatura": "function AreaPeloNome(pArea: String): Integer"
    },
    {
      "nome": "GetArea",
      "tipo": "metodo",
      "assinatura": "function GetArea(pCodArea: Integer): Integer"
    },
    {
      "nome": "ValidarArea",
      "tipo": "metodo",
      "assinatura": "procedure ValidarArea"
    },
    {
      "nome": "ModuloPeloNome",
      "tipo": "metodo",
      "assinatura": "function ModuloPeloNome(pModulo: String): Integer"
    },
    {
      "nome": "GetModulo",
      "tipo": "metodo",
      "assinatura": "function GetModulo(pCodModulo: Integer): Integer"
    },
    {
      "nome": "ValidarModulo",
      "tipo": "metodo",
      "assinatura": "procedure ValidarModulo"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Manter os datasets de módulos e áreas e resolver seus códigos por nome ou identificador."
        },
        {
          "tipo": "paragrafo",
          "texto": "Evitar repetir a carga dessas informações a cada consulta do contexto de Casos de Teste."
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
              "Cache de módulos e áreas do banco dedicado.",
              "Criados no setup quando não atribuídos; liberados no teardown."
            ],
            [
              "FCacheCarregado: Boolean",
              "Indica que a carga dos dois datasets foi concluída.",
              "True após carga, False após limpeza."
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
          "texto": "Apresentar instruções da unit."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama MostrarInstrucoesUnit com uma descrição vazia no fonte atual."
        }
      ]
    },
    {
      "id": "cache-setup-carregarinformacoes",
      "titulo": "Cache_Setup_CarregarInformacoes",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Cache_Setup_CarregarInformacoes;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Preparar e carregar o cache."
        },
        {
          "tipo": "paragrafo",
          "texto": "Cria datasets quando necessário, lê SQLModulos e SQLAreas via TDDReaderODBC e marca a carga."
        }
      ]
    },
    {
      "id": "cache-teardown-limparinformacoes",
      "titulo": "Cache_TearDown_LimparInformacoes",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Cache_TearDown_LimparInformacoes;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Liberar os datasets."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama Free em ambos e redefine FCacheCarregado."
        }
      ]
    },
    {
      "id": "verificacarregamentocache",
      "titulo": "VerificaCarregamentoCache",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure VerificaCarregamentoCache;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Garantir a carga antes das consultas."
        },
        {
          "tipo": "paragrafo",
          "texto": "Aciona o setup quando FCacheCarregado está False."
        }
      ]
    },
    {
      "id": "areapelonome",
      "titulo": "AreaPeloNome",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function AreaPeloNome(pArea: String): Integer;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Resolver uma área por descrição."
        },
        {
          "tipo": "paragrafo",
          "texto": "Valida o cache, indexa por DESCRICAO_AREA e usa FindKey; lança erro se não encontrar."
        }
      ]
    },
    {
      "id": "getarea",
      "titulo": "GetArea",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetArea(pCodArea: Integer): Integer;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Confirmar uma área por identificador."
        },
        {
          "tipo": "paragrafo",
          "texto": "Valida o cache, indexa por AUTOINC_AREA e usa FindKey."
        }
      ]
    },
    {
      "id": "validararea",
      "titulo": "ValidarArea",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure ValidarArea;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Validar o dataset de áreas."
        },
        {
          "tipo": "paragrafo",
          "texto": "Garante a carga e rejeita referência ausente ou dataset vazio."
        }
      ]
    },
    {
      "id": "modulopelonome",
      "titulo": "ModuloPeloNome",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function ModuloPeloNome(pModulo: String): Integer;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Resolver um módulo por descrição."
        },
        {
          "tipo": "paragrafo",
          "texto": "Indexa CDSModulos por DESCRICAO_MODULO e retorna CODIGO_MODULO."
        }
      ]
    },
    {
      "id": "getmodulo",
      "titulo": "GetModulo",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetModulo(pCodModulo: Integer): Integer;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Confirmar um módulo por código."
        },
        {
          "tipo": "paragrafo",
          "texto": "Indexa por CODIGO_MODULO e lança erro quando não encontra."
        }
      ]
    },
    {
      "id": "validarmodulo",
      "titulo": "ValidarModulo",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure ValidarModulo;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Validar o dataset de módulos."
        },
        {
          "tipo": "paragrafo",
          "texto": "Garante a carga e rejeita referência ausente ou dataset vazio."
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
            "P39_TDD_CASOS_DE_TESTE usa este cache para preparar módulo e área do lote.",
            "O subgrupo IRunner representa sua utilização documental principal, não exclusividade de uso."
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
            "P39_TDD_ODBC fornece as leituras; P39_TDD_CONSTANTES fornece SQLModulos e SQLAreas transitivamente."
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
            "O teardown usa Free sem zerar as referências; este fonte não demonstra reinicialização segura após a liberação.",
            "P39_TDD_CONSTANTES também declara CDSModulos, CDSAreas e FCacheCarregado; essas declarações distintas não devem ser confundidas."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
