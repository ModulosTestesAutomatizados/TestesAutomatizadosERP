import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-parametro",
  "categoria": "units",
  "titulo": "P39_TDD_PARAMETRO",
  "unit": "P39_TDD_PARAMETRO",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_PARAMETROS"
  ],
  "resumo": "Mapeamento, comparação e atualização dos parâmetros do ERP.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "units",
    "subgrupo": "setup",
    "ordem": 2
  },
  "fontes": [
    {
      "caminho": "docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "CDSParametro",
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
      "nome": "GetSQLParametro",
      "tipo": "metodo",
      "assinatura": "function GetSQLParametro: String"
    },
    {
      "nome": "VerificarParametros",
      "tipo": "metodo",
      "assinatura": "procedure VerificarParametros(pJSONParametros: String)"
    },
    {
      "nome": "NecessarioModificarParam",
      "tipo": "metodo",
      "assinatura": "function NecessarioModificarParam(pCampo, pValor: String): Boolean"
    },
    {
      "nome": "AtualizarParametros",
      "tipo": "metodo",
      "assinatura": "procedure AtualizarParametros(pCDS: TClientDataSet)"
    },
    {
      "nome": "Relogar",
      "tipo": "metodo",
      "assinatura": "procedure Relogar"
    },
    {
      "nome": "PegarTipoCampo",
      "tipo": "metodo",
      "assinatura": "function PegarTipoCampo(pValue: String): Integer"
    },
    {
      "nome": "CriarEstruturaParametrosAtualizar",
      "tipo": "metodo",
      "assinatura": "procedure CriarEstruturaParametrosAtualizar(pCDS: TClientDataSet)"
    },
    {
      "nome": "Setup_Inicializar_Parametros",
      "tipo": "metodo",
      "assinatura": "procedure Setup_Inicializar_Parametros"
    },
    {
      "nome": "TearDown_FinalizarParametros",
      "tipo": "metodo",
      "assinatura": "procedure TearDown_FinalizarParametros"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Comparar o bloco parametros com a configuração corrente e aplicar somente as diferenças necessárias."
        },
        {
          "tipo": "paragrafo",
          "texto": "Permite que o JSON de cada cenário prepare o ERP para o Teste sem um processamento manual separado."
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
              "CDSParametro: TClientDataSet",
              "Leitura dos parâmetros disponíveis no ERP",
              "Preparado no setup e liberado por TearDown_FinalizarParametros"
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
          "texto": "Encaminhar instruções."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama MostrarInstrucoesUnit; a descrição local está vazia."
        }
      ]
    },
    {
      "id": "getsqlparametro",
      "titulo": "GetSQLParametro",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function GetSQLParametro: String;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Montar a leitura da configuração."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém campos das classes de configuração e compõe SQL com filtros da empresa atual para as tabelas por empresa."
        }
      ]
    },
    {
      "id": "verificarparametros",
      "titulo": "VerificarParametros",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure VerificarParametros(pJSONParametros: String);"
        },
        {
          "tipo": "paragrafo",
          "texto": "Encontrar valores que precisam mudar."
        },
        {
          "tipo": "paragrafo",
          "texto": "Percorre pares JSON e monta dataset temporário indexado pela chave; chama AtualizarParametros quando há diferenças."
        }
      ]
    },
    {
      "id": "necessariomodificarparam",
      "titulo": "NecessarioModificarParam",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function NecessarioModificarParam(pCampo, pValor: String): Boolean;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Comparar um valor com o estado atual."
        },
        {
          "tipo": "paragrafo",
          "texto": "Compara o valor de GetValueJson(SecaoParametroJson, pCampo) com pValor e propaga falhas de leitura."
        }
      ]
    },
    {
      "id": "atualizarparametros",
      "titulo": "AtualizarParametros",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure AtualizarParametros(pCDS: TClientDataSet);"
        },
        {
          "tipo": "paragrafo",
          "texto": "Aplicar as diferenças."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém campo/tabela do mapeamento, infere o tipo, monta UPDATE e executa ExecuteCommand. Erros são relançados; ao concluir, chama Relogar."
        }
      ]
    },
    {
      "id": "relogar",
      "titulo": "Relogar",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Relogar;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Recarregar a configuração na sessão."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém DMConexao, chama ConectaServidorAplicacao e depois CarregaSecaoAtual."
        }
      ]
    },
    {
      "id": "pegartipocampo",
      "titulo": "PegarTipoCampo",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function PegarTipoCampo(pValue: String): Integer;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Inferir o tipo do valor."
        },
        {
          "tipo": "paragrafo",
          "texto": "Aspas indicam string, true/false indicam lógico, ponto indica moeda e os demais valores são tratados como inteiro; vazio retorna -1."
        }
      ]
    },
    {
      "id": "criarestruturaparametrosatualizar",
      "titulo": "CriarEstruturaParametrosAtualizar",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure CriarEstruturaParametrosAtualizar(pCDS: TClientDataSet);"
        },
        {
          "tipo": "paragrafo",
          "texto": "Preparar o dataset temporário."
        },
        {
          "tipo": "paragrafo",
          "texto": "Define CHAVE e VALOR, cria o dataset e indexa por CHAVE."
        }
      ]
    },
    {
      "id": "setup-inicializar-parametros",
      "titulo": "Setup_Inicializar_Parametros",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Setup_Inicializar_Parametros;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Inicializar mapeamento e leitura."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama MapearParametros, lê GetSQLParametro com ExecuteReader e configura as propriedades dos campos."
        }
      ]
    },
    {
      "id": "teardown-finalizarparametros",
      "titulo": "TearDown_FinalizarParametros",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure TearDown_FinalizarParametros;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Liberar a estrutura de parâmetros."
        },
        {
          "tipo": "paragrafo",
          "texto": "Executa Free em CDSParametro."
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
            "P39_TDD_RUN_STARTED consome parametros do JSON do registro corrente e chama VerificarParametros.",
            "CONFIG_SISTEMA é global; CONFIG_SISTEMA_EMPRESA e PCP_CONFIG recebem filtros da empresa atual.",
            "As mudanças pertencem ao banco do ERP, não ao banco dedicado de testes."
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
            "Uses diretos: P39_TDD_PARAMETRO_MAPEAMENTO e P39_TDD_FUNCOES_JSON."
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
            "Falha de UPDATE propaga por Started e pode interromper o lote.",
            "A limpeza do dataset não restaura os valores antigos de configuração.",
            "O fonte não mostra rollback automático de toda a sequência de UPDATEs."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
