import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-registrar-caso-teste",
  "categoria": "units",
  "titulo": "P39_TDD_REGISTRAR_CASO_TESTE",
  "unit": "P39_TDD_REGISTRAR_CASO_TESTE",
  "tipoArtefato": "unit",
  "aliases": [],
  "resumo": "Lê os JSONs das units e registra ou atualiza um caso no banco dedicado ao TDD.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "helpers",
    "subgrupo": "sincronizacao",
    "ordem": 0
  },
  "fontes": [
    {
      "caminho": "docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "FCasoTeste",
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
      "nome": "RegistrarCasoTeste",
      "tipo": "metodo",
      "assinatura": "procedure RegistrarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste, pRequisitoVersao, pUnitJsonCasoTeste, pUnitJsonCamposDisponiveis, pUnitJsonResultadoEsperado: string; pSincRemoto: boolean)"
    },
    {
      "nome": "CarregarConteudoUnit",
      "tipo": "metodo",
      "assinatura": "function CarregarConteudoUnit(pNomeUnit: string; pSincRemoto: boolean): string"
    },
    {
      "nome": "SincronizarCasoTeste",
      "tipo": "metodo",
      "assinatura": "procedure SincronizarCasoTeste"
    },
    {
      "nome": "QuestionarParaRodarUpdateCasoTeste",
      "tipo": "metodo",
      "assinatura": "procedure QuestionarParaRodarUpdateCasoTeste(pCodigoCasoTeste: integer)"
    },
    {
      "nome": "InsertCasoTeste",
      "tipo": "metodo",
      "assinatura": "procedure InsertCasoTeste"
    },
    {
      "nome": "RegistroFallbackBase",
      "tipo": "metodo",
      "assinatura": "function RegistroFallbackBase(pSqlSelect, pSqlInsert: string; pParametrosSql: OleVariant; pAtivarFallback: boolean): integer"
    },
    {
      "nome": "RegistroFallbackModulo",
      "tipo": "metodo",
      "assinatura": "function RegistroFallbackModulo(pDescricaoModulo: string; pAtivarFallback: boolean): integer"
    },
    {
      "nome": "RegistroFallbackArea",
      "tipo": "metodo",
      "assinatura": "function RegistroFallbackArea(pCodigoModulo: integer; pDescricaoArea: string; pAtivarFallback: boolean): integer"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Montar FCasoTeste, localizar ou criar módulo e área e persistir o caso de teste com comandos parametrizados."
        },
        {
          "tipo": "paragrafo",
          "texto": "Centralizar o cadastro dos casos vindos de fontes locais ou remotos, sem duplicar as regras de insert e confirmação de atualização."
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
              "FCasoTeste: TCasoTeste",
              "Record com módulo, área, descrição, versão e os três conteúdos JSON do caso.",
              "Reutilizado a cada chamada de RegistrarCasoTeste. A unit não o limpa após inserir, atualizar, cancelar ou falhar. Não é o record do caso corrente preparado pelo Started."
            ]
          ]
        }
      ]
    },
    {
      "id": "campos-registro",
      "titulo": "Campos de TCasoTeste",
      "blocos": [
        {
          "tipo": "tabela",
          "colunas": [
            "Campo",
            "Tipo",
            "Finalidade",
            "Impacto no cadastro"
          ],
          "linhas": [
            [
              "Modulo",
              "integer",
              "Código do módulo.",
              "Compõe a chave de busca do caso e o campo MODULO_CT."
            ],
            [
              "Area",
              "integer",
              "Código da área dentro do módulo.",
              "Compõe a chave de busca e o campo AREA_CT."
            ],
            [
              "Descricao",
              "string",
              "Descrição do caso.",
              "Compõe a chave de busca e DESCRICAO_CASO_TESTE_CT."
            ],
            [
              "RequisitoVersao",
              "string",
              "Versão mínima informada pelo cadastro.",
              "Persistida em REQUISITO_VERSAO_CT, sem validação nesta unit."
            ],
            [
              "CasoTeste",
              "string",
              "Conteúdo da unit JSON do cenário.",
              "Persistido em CASO_TESTE_CT; alimenta os dados do teste quando o caso for carregado."
            ],
            [
              "CamposDisponiveis",
              "string",
              "Conteúdo da unit com campos disponíveis.",
              "Persistido em CAMPOS_DISPONIVEIS_CT; nome vazio ou leitura inválida resulta em {}."
            ],
            [
              "ResultadoEsperado",
              "string",
              "Conteúdo da unit de resultado esperado.",
              "Persistido em RESULTADO_ESPERADO_CT; cadastrar o conteúdo não implementa asserts."
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
          "texto": "Exibir as instruções da unit."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama MostrarInstrucoesUnit pelo contexto de P39_TDD_ODBC e suas dependências. Não registra casos."
        }
      ]
    },
    {
      "id": "registrarcasoteste",
      "titulo": "RegistrarCasoTeste",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure RegistrarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste, pRequisitoVersao, pUnitJsonCasoTeste, pUnitJsonCamposDisponiveis, pUnitJsonResultadoEsperado: string; pSincRemoto: boolean);"
        },
        {
          "tipo": "paragrafo",
          "texto": "Orquestrar o cadastro de um caso."
        },
        {
          "tipo": "paragrafo",
          "texto": "Cria três TStringList, carrega os conteúdos, obtém módulo e área com fallback habilitado, preenche FCasoTeste e chama SincronizarCasoTeste. O finally libera as listas; não restaura o record global nem desfaz gravações anteriores."
        }
      ]
    },
    {
      "id": "carregarconteudounit",
      "titulo": "CarregarConteudoUnit",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function CarregarConteudoUnit(pNomeUnit: string; pSincRemoto: boolean): string;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Ler o conteúdo de uma unit JSON."
        },
        {
          "tipo": "paragrafo",
          "texto": "Inicia Result com {}. Nome vazio retorna esse objeto. Se pSincRemoto for true, acrescenta cPrefixoSincRemoto antes de CodificacaoUnit. Qualquer exceção de leitura é silenciada e mantém {}. O conteúdo retornado não é validado como JSON."
        }
      ]
    },
    {
      "id": "sincronizarcasoteste",
      "titulo": "SincronizarCasoTeste",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure SincronizarCasoTeste;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Decidir entre inclusão e atualização."
        },
        {
          "tipo": "paragrafo",
          "texto": "Consulta CASO_TESTE pela combinação descrição, módulo e área. Código maior que zero chama QuestionarParaRodarUpdateCasoTeste; caso contrário chama InsertCasoTeste. A decisão depende dos dados do record global."
        }
      ]
    },
    {
      "id": "questionarpararodarupdatecasoteste",
      "titulo": "QuestionarParaRodarUpdateCasoTeste",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure QuestionarParaRodarUpdateCasoTeste(pCodigoCasoTeste: integer);"
        },
        {
          "tipo": "paragrafo",
          "texto": "Solicitar confirmação antes de sobrescrever um caso."
        },
        {
          "tipo": "paragrafo",
          "texto": "Mostra MessageDlg com Sim/Não. Apenas mrYes executa UPDATE parametrizado dos sete campos usando o código como filtro. Recusar retorna sem alterar o caso existente; não retorna um indicador de cancelamento ao chamador."
        }
      ]
    },
    {
      "id": "insertcasoteste",
      "titulo": "InsertCasoTeste",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure InsertCasoTeste;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Inserir o caso com os dados de FCasoTeste."
        },
        {
          "tipo": "paragrafo",
          "texto": "Executa INSERT em CASO_TESTE via P39_TDD_ODBC.TDDCommandODBCP. AUTOINC_CT é atribuído pela trigger do banco. JSONs são parâmetros sem QuotedStr para não introduzir aspas literais no conteúdo."
        }
      ]
    },
    {
      "id": "registrofallbackbase",
      "titulo": "RegistroFallbackBase",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function RegistroFallbackBase(pSqlSelect, pSqlInsert: string; pParametrosSql: OleVariant; pAtivarFallback: boolean): integer;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Consultar um identificador e opcionalmente criar o registro ausente."
        },
        {
          "tipo": "paragrafo",
          "texto": "Usa TDDScalarODBCP, converte o retorno para string e trata vazio ou zero como ausência. Com fallback ativo executa INSERT com RETURNING; sem fallback lança exceção. O resultado final usa StrToIntDef com zero como padrão."
        }
      ]
    },
    {
      "id": "registrofallbackmodulo",
      "titulo": "RegistroFallbackModulo",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function RegistroFallbackModulo(pDescricaoModulo: string; pAtivarFallback: boolean): integer;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Resolver o código do módulo pela descrição."
        },
        {
          "tipo": "paragrafo",
          "texto": "Prepara SELECT e INSERT com RETURNING em MODULO e delega a RegistroFallbackBase. Acrescenta contexto à mensagem em caso de exceção."
        }
      ]
    },
    {
      "id": "registrofallbackarea",
      "titulo": "RegistroFallbackArea",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "function RegistroFallbackArea(pCodigoModulo: integer; pDescricaoArea: string; pAtivarFallback: boolean): integer;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Resolver a área dentro de um módulo."
        },
        {
          "tipo": "paragrafo",
          "texto": "Prepara SELECT por descrição e módulo e INSERT com RETURNING em AREA. Delega o controle de criação ao booleano pAtivarFallback."
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
            "TCasoTeste é o tipo do record global FCasoTeste. A tabela abaixo descreve os campos e seus efeitos na persistência.",
            "Os parâmetros pUnitJsonCasoTeste, pUnitJsonCamposDisponiveis e pUnitJsonResultadoEsperado são nomes de unidades de codificação, não o JSON literal.",
            "RegistrarCasoTeste habilita a criação de módulo e área antes de verificar se o caso já existe. Cancelar o UPDATE do caso não desfaz essas criações.",
            "REQUISITO_VERSAO_CT recebe a string fornecida; esta unit não compara a versão com o ERP. O consumidor do caso faz essa verificação.",
            "A unit não abre uma transação para todo o processo nem garante rollback de operações anteriores."
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
            "Uses direto: P39_TDD_ODBC. cPrefixoSincRemoto e os helpers de instrução vêm do contexto compartilhado de suas dependências.",
            "P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS chama RegistrarCasoTeste em sequência."
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
            "Não há execução nem homologação no ERP comprovada por esta documentação.",
            "Falhas de leitura podem persistir {} no lugar do conteúdo esperado. Confira os nomes e o ambiente antes de sincronizar.",
            "O record global permanece com o último conteúdo atribuído; chamadas concorrentes ou reentrantes não têm isolamento implementado."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
