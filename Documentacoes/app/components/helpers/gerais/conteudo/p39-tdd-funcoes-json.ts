import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-funcoes-json",
  "categoria": "units",
  "titulo": "P39_TDD_FUNCOES_JSON",
  "unit": "P39_TDD_FUNCOES_JSON",
  "tipoArtefato": "unit",
  "aliases": [],
  "resumo": "Leitura tipada de tags JSON e acesso aos pares usados na configuração dos testes.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "helpers",
    "subgrupo": "gerais"
  },
  "fontes": [
    {
      "caminho": "docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "Main",
      "tipo": "metodo",
      "assinatura": "procedure Main"
    },
    {
      "nome": "TagExiste",
      "tipo": "metodo",
      "assinatura": "function TagExiste(pJson, pTag: String): Boolean"
    },
    {
      "nome": "ValorInteiroTag",
      "tipo": "metodo",
      "assinatura": "function ValorInteiroTag(pJson, pTag: String; pDefault: Integer): Integer"
    },
    {
      "nome": "ValorCurrencyTag",
      "tipo": "metodo",
      "assinatura": "function ValorCurrencyTag(pJson, pTag: String; pDefault: Currency): Currency"
    },
    {
      "nome": "ValorLogicoTag",
      "tipo": "metodo",
      "assinatura": "function ValorLogicoTag(pJson, pTag: String; pDefault: Boolean): Boolean"
    },
    {
      "nome": "ValorDataTag",
      "tipo": "metodo",
      "assinatura": "function ValorDataTag(pJson, pTag: String): TDateTime"
    },
    {
      "nome": "ValorStringTag",
      "tipo": "metodo",
      "assinatura": "function ValorStringTag(pJson, pTag: String): String"
    },
    {
      "nome": "GetPairName",
      "tipo": "metodo",
      "assinatura": "function GetPairName(pPair: TJSONPair): String"
    },
    {
      "nome": "GetPairValue",
      "tipo": "metodo",
      "assinatura": "function GetPairValue(pPair: TJSONPair): String"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Ler tags e converter valores para inteiro, moeda, lógico, data ou texto com os padrões definidos pelo consumidor."
        },
        {
          "tipo": "paragrafo",
          "texto": "Compartilhar as conversões entre cenários, parâmetros e infraestrutura, em vez de repeti-las no IRunner."
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
          "texto": "Apresentar instruções."
        },
        {
          "tipo": "paragrafo",
          "texto": "Delega a MostrarInstrucoesUnit."
        }
      ]
    },
    {
      "id": "tagexiste",
      "titulo": "TagExiste",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function TagExiste(pJson, pTag: String): Boolean;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Verificar uma tag com conteúdo."
        },
        {
          "tipo": "paragrafo",
          "texto": "Retorna False para entrada vazia, valor vazio ou falha de leitura."
        }
      ]
    },
    {
      "id": "valorinteirotag",
      "titulo": "ValorInteiroTag",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function ValorInteiroTag(pJson, pTag: String; pDefault: Integer): Integer;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Ler um inteiro."
        },
        {
          "tipo": "paragrafo",
          "texto": "Converte ValorStringTag com StrToInt e mantém pDefault em caso de erro."
        }
      ]
    },
    {
      "id": "valorcurrencytag",
      "titulo": "ValorCurrencyTag",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function ValorCurrencyTag(pJson, pTag: String; pDefault: Currency): Currency;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Ler um valor monetário."
        },
        {
          "tipo": "paragrafo",
          "texto": "Troca ponto por vírgula e usa StrToCurrDef com pDefault."
        }
      ]
    },
    {
      "id": "valorlogicotag",
      "titulo": "ValorLogicoTag",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function ValorLogicoTag(pJson, pTag: String; pDefault: Boolean): Boolean;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Ler um lógico."
        },
        {
          "tipo": "paragrafo",
          "texto": "Reconhece true/s e false/n; outros valores preservam o padrão."
        }
      ]
    },
    {
      "id": "valordatatag",
      "titulo": "ValorDataTag",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function ValorDataTag(pJson, pTag: String): TDateTime;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Ler uma data."
        },
        {
          "tipo": "paragrafo",
          "texto": "Usa StrToDateTime e retorna zero quando a conversão falha."
        }
      ]
    },
    {
      "id": "valorstringtag",
      "titulo": "ValorStringTag",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function ValorStringTag(pJson, pTag: String): String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Ler o conteúdo textual da tag."
        },
        {
          "tipo": "paragrafo",
          "texto": "Verifica TagExiste; ausência ou erro resultam em texto vazio."
        }
      ]
    },
    {
      "id": "getpairname",
      "titulo": "GetPairName",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetPairName(pPair: TJSONPair): String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Obter o nome do par."
        },
        {
          "tipo": "paragrafo",
          "texto": "Serializa ToJSON, remove aspas e corta até o separador; referência ausente resulta em vazio."
        }
      ]
    },
    {
      "id": "getpairvalue",
      "titulo": "GetPairValue",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetPairValue(pPair: TJSONPair): String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Obter o valor do par."
        },
        {
          "tipo": "paragrafo",
          "texto": "Usa a representação ToJSON e a rotina de recorte do fonte; referência ausente resulta em vazio."
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
            "Não mantém estado global de JSON próprio; os dados chegam como argumentos.",
            "Essas rotinas não substituem a validação de obrigatoriedade feita por cada caso."
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
            "TDD_RUN_LOGS fornece instruções; leitura JSON, conversão e recorte são fornecidos pelo host."
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
            "Falhas de leitura podem se transformar em valores padrão; o caso precisa verificar os campos obrigatórios.",
            "Datas e valores monetários dependem das conversões e do formato esperado pelo host."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
