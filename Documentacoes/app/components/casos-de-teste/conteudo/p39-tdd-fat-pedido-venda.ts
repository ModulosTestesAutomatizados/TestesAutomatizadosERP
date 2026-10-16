import type { IDocumento } from '../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-fat-pedido-venda",
  "categoria": "units",
  "titulo": "P39_TDD_FAT_PEDIDO_VENDA",
  "unit": "P39_TDD_FAT_PEDIDO_VENDA",
  "tipoArtefato": "unit",
  "aliases": [],
  "resumo": "Entrada do caso de Pedido de Venda no faturamento refatorado, com configuração de tela e delegação ao núcleo.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "casos",
    "ordem": 0
  },
  "fontes": [
    {
      "caminho": "docs/assets/casosTestesFaturamento/P39_TDD_FAT_PEDIDO_VENDA.pas"
    },
    {
      "caminho": "docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA.pas"
    },
    {
      "caminho": "docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA_JSON.pas"
    },
    {
      "caminho": "docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA_ITENS.pas"
    },
    {
      "caminho": "docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_PRINCIPAIS.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "main",
      "tipo": "metodo",
      "assinatura": "procedure main"
    },
    {
      "nome": "Setup",
      "tipo": "metodo",
      "assinatura": "procedure Setup"
    },
    {
      "nome": "Teste",
      "tipo": "metodo",
      "assinatura": "procedure Teste"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Definir a área PEDIDO DE VENDA, o formulário FCadPedidoVenda e o módulo de dados DMCadPedidoVenda, e delegar a execução a P39_TDD_FAT_DOCUMENTO_FATURA."
        },
        {
          "tipo": "paragrafo",
          "texto": "Separar a configuração específica do Pedido de Venda das camadas compartilhadas de Documento de Fatura."
        }
      ]
    },
    {
      "id": "json-base",
      "titulo": "JSON base do caso de teste",
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "json",
          "codigo": "{\n  \"documento\": {\n    \"tag_cliente\": 0,\n    \"cliente_docfat\": 0,\n    \"unidfabril_docfat\": 0,\n    \"tabela_preco\": 0,\n    \"tabelacondicao_docped\": 0,\n    \"condicaoprazo_docped\": 0\n  },\n  \"item\": {\n    \"tag_prodcomum\": 0,\n    \"quantidade\": 1,\n    \"valor\": 100,\n    \"itens\": [\n      {\n        \"item\": 0,\n        \"variacao\": 0,\n        \"cor\": 0,\n        \"acabamento\": 0,\n        \"quantidade\": 1,\n        \"valor\": 100,\n        \"desconto\": \"0\"\n      }\n    ]\n  },\n  \"parametros\": {}\n}"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Objeto / campo",
            "Tipo",
            "Finalidade",
            "Impacto no teste"
          ],
          "linhas": [
            [
              "documento",
              "objeto",
              "Tags de cliente e dados principais do documento.",
              "SetCasoTeste separa este objeto e as camadas consultam as tags por Valor*TagDoc."
            ],
            [
              "documento.tag_cliente / cliente_docfat",
              "inteiros",
              "Selecionar clientes por tag ou por código.",
              "CarregarClientes prioriza tag positiva, depois cliente positivo e por último a configuração; não localizar clientes interrompe a inclusão."
            ],
            [
              "documento.unidfabril_docfat",
              "inteiro",
              "Unidade fabril do documento.",
              "Consumida pela camada de dados principais conforme o comportamento de configuração."
            ],
            [
              "documento.tabela_preco / tabelacondicao_docped / condicaoprazo_docped",
              "inteiros",
              "Tabela de preço, condição e prazo.",
              "Selecionam os dados principais; as rotinas possuem alternativas por descrição e configuração."
            ],
            [
              "item",
              "objeto",
              "Configuração comum de inclusão dos itens.",
              "É extraído para FJSON.Item; as rotinas usam Valor*TagItemConfig."
            ],
            [
              "item.tag_prodcomum",
              "inteiro",
              "Seleção de produtos por tag.",
              "Usada quando a lista itens está vazia; lista não vazia tem prioridade."
            ],
            [
              "item.quantidade / valor",
              "números",
              "Valores padrão para os itens.",
              "Substituem valores zero de cada item; se continuarem zero, o fonte pode gerar quantidade ou valor aleatórios."
            ],
            [
              "item.itens",
              "lista de objetos",
              "Itens específicos do pedido.",
              "A lista não vazia ativa inclusão específica; item com código zero é ignorado, sem retornar ao caminho por tag."
            ],
            [
              "item.itens[].item",
              "inteiro",
              "Código do produto específico.",
              "Deve corresponder a um produto da base; zero pula este item."
            ],
            [
              "item.itens[].variacao / cor / acabamento",
              "inteiros",
              "Características do produto.",
              "Alimentam a estrutura intermediária de itens."
            ],
            [
              "item.itens[].quantidade / valor / desconto",
              "números / texto",
              "Condições do item específico.",
              "Quantidade e valor têm prioridade sobre os padrões; desconto é lido como texto, preservando o formato esperado pelo fonte."
            ],
            [
              "parametros",
              "objeto",
              "Configurações de ERP para o caso.",
              "Objeto não vazio chama _AjustarParametros, libera a tela e pode executar Relogar; o finally reabre o formulário."
            ]
          ]
        },
        {
          "tipo": "lista",
          "itens": [
            "Preencha os identificadores zero com códigos válidos para a base utilizada. A lista de exemplo contém um produto ainda não preenchido; ele será ignorado pelo fonte até receber um código.",
            "Para usar produtos por tag, esvazie item.itens e informe uma tag_prodcomum válida. Os números de quantidade e valor são exemplos, sem declaração de homologação.",
            "parametros deve ser um objeto JSON, inclusive quando vazio. Este contrato usa seu próprio cursor em Teste_Executar e não está adaptado ao cursor por registro do IRunner.",
            "RegistrarDataSet e CompararResultadoEsperado permanecem comentados no núcleo; o JSON base não habilita a comparação por asserts."
          ]
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
      "titulo": "main",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure main;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Preparar e executar o caso."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama Setup e Teste nesta ordem."
        }
      ]
    },
    {
      "id": "setup",
      "titulo": "Setup",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Setup;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Configurar a área e a tela do Pedido de Venda."
        },
        {
          "tipo": "paragrafo",
          "texto": "Define FCadastro e FDM no contexto do núcleo, chama SetArea e Setup_Inicializar."
        }
      ]
    },
    {
      "id": "teste",
      "titulo": "Teste",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Teste;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Delegar a execução dos registros."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama Teste_Executar no núcleo de Documento de Fatura."
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
            "A unit não declara variáveis globais próprias; FCadastro e FDM são mantidas pelo núcleo.",
            "O núcleo extrai documento, item e parametros e P39_TDD_FAT_DOCUMENTO_FATURA_JSON mantém o record TEstrutura com as partes do caso."
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
            "P39_TDD_FAT_DOCUMENTO_FATURA coordena o cursor e as camadas de gravação."
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
            "O fonte de referência foi incorporado da contribuição do PR #20; a documentação não declara homologação no ERP."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
