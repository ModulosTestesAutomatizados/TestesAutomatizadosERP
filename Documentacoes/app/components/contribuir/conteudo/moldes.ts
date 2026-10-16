import type { IDocumento } from '../../../contracts/documentacao.ts';
export default {
  "slug": "moldes",
  "categoria": "guias",
  "titulo": "Moldes de units e JSON",
  "resumo": "Modelos canônicos copiáveis de Main, caso JSON e configurações mínimas.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "guias",
    "ordem": 1
  },
  "fontes": [
    {
      "caminho": "docs/assets/snippets/formatoTDDProcedureMainComInstrucoes.pas"
    },
    {
      "caminho": "docs/assets/snippets/TDD_CASO_TESTE_MODELO_JSON.json"
    },
    {
      "caminho": "docs/assets/snippets/TDD_ASSERTS_JSON_MINIMO.json"
    },
    {
      "caminho": "docs/assets/snippets/TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO.json"
    }
  ],
  "secoes": [
    {
      "id": "main",
      "titulo": "Main com instruções",
      "blocos": [
        {
          "tipo": "codigo-fonte",
          "fonte": "docs/assets/snippets/formatoTDDProcedureMainComInstrucoes.pas",
          "linguagem": "pascal"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Objeto / elemento",
            "Finalidade",
            "Impacto"
          ],
          "linhas": [
            [
              "Main",
              "Ponto de entrada de instruções.",
              "Preencher a responsabilidade da unit; manter a chamada de instruções compatível com o contexto."
            ],
            [
              "lInstrucoes",
              "Texto descritivo agrupado por responsabilidade, estados e métodos.",
              "Não é documentação de um contrato executável pronto até preencher os campos."
            ],
            [
              "NOME_UNIT",
              "Identificador de instrução a substituir.",
              "Use o nome real da unit instalada; o molde não a registra no ERP."
            ]
          ]
        }
      ]
    },
    {
      "id": "caso-json",
      "titulo": "Fonte JSON única do caso",
      "blocos": [
        {
          "tipo": "codigo-fonte",
          "fonte": "docs/assets/snippets/TDD_CASO_TESTE_MODELO_JSON.json",
          "linguagem": "json"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Objeto / elemento",
            "Finalidade",
            "Impacto"
          ],
          "linhas": [
            [
              "ATRIBUTO_INTEIRO_1/2",
              "Exemplos numéricos dos dados do caso.",
              "Substituir por tags reais consumidas pela unit."
            ],
            [
              "ATRIBUTO_STRING_1/2",
              "Exemplos de dados textuais.",
              "Substituir pelos campos do cenário."
            ],
            [
              "parametros",
              "Objeto de parâmetros.",
              "Vazio não aplica alterações; preenchido altera o ERP em Started."
            ],
            [
              "camposDisponiveis",
              "Objeto reservado de campos.",
              "Ausente ou vazio solicita o mínimo na sincronização."
            ],
            [
              "resultadoEsperado",
              "Objeto reservado de critérios.",
              "Vazio explícito não usa mínimo; execução sinaliza SEM_VALIDACAO sem limpar asserts explícitos."
            ]
          ]
        }
      ]
    },
    {
      "id": "asserts-minimo",
      "titulo": "Resultado esperado mínimo",
      "blocos": [
        {
          "tipo": "codigo-fonte",
          "fonte": "docs/assets/snippets/TDD_ASSERTS_JSON_MINIMO.json",
          "linguagem": "json"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Objeto / elemento",
            "Finalidade",
            "Impacto"
          ],
          "linhas": [
            [
              "resultadoEsperado",
              "Wrapper do mínimo de asserts.",
              "O registrador preserva essa tag; o comparador aceita o wrapper."
            ],
            [
              "erro.quantidade",
              "Quantidade esperada de erros registrados explicitamente.",
              "Zero verifica FErrosReais; não comprova todos os efeitos do financeiro."
            ],
            [
              "erro.operacao",
              "Comparação Igual no molde.",
              "Maior/Menor comparam obtido com esperado quando configurados."
            ]
          ]
        }
      ]
    },
    {
      "id": "campos-minimo",
      "titulo": "Campos disponíveis mínimos",
      "blocos": [
        {
          "tipo": "codigo-fonte",
          "fonte": "docs/assets/snippets/TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO.json",
          "linguagem": "json"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Objeto / elemento",
            "Finalidade",
            "Impacto"
          ],
          "linhas": [
            [
              "{}",
              "Mínimo atual de campos disponíveis.",
              "É válido como corpo mínimo; o registrador produz camposDisponiveis: {}. Não descreve campos financeiros completos."
            ]
          ]
        }
      ]
    },
    {
      "id": "uso",
      "titulo": "Como usar os moldes",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Copie o conteúdo pelo botão do terminal e preencha os nomes, dados e instruções do seu cenário. O conteúdo exibido vem do arquivo canônico em docs/assets/snippets; não há uma cópia editável independente no componente."
        },
        {
          "tipo": "aviso",
          "severidade": "warning",
          "texto": "Estes são formatos padrão e não dados universais de execução. Copiar um molde não cadastra a unit no ERP nem comprova versão/homologação. O frontend apenas exibe texto; não executa Pascal ou sincroniza dados."
        }
      ]
    }
  ]
} satisfies IDocumento;
