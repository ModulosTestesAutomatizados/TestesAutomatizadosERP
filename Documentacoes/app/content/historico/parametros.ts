import type { IDocumento } from '../../models/documentacao.ts';
// Conteúdo migrado do arquivo histórico; apresentação compartilhada.
export default {
  "slug": "parametros",
  "categoria": "documentos",
  "titulo": "Parâmetros do ERP",
  "resumo": "Mapeamento de parâmetros, aplicação por JSON e configuração por empresa.",
  "estado": "legado",
  "fontes": [
    {
      "caminho": "Documentacoes/app/arquivo/html/parametros/index.html"
    }
  ],
  "secoes": [
    {
      "id": "secao-1",
      "titulo": "Definições",
      "nivel": 2,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O Parâmetro é o mecanismo que permite a um caso de teste configurar o próprio sistema antes da execução. As units (P39_TDD_PARAMETROS e P39_TDD_PARAMETRO_MAPEAMENTO) leem o bloco parametros do JSON do caso de teste, escrevem o valor no banco de dados do ERP e reconectam a sessão para que o ERP carregue os novos valores em memória."
        },
        {
          "tipo": "paragrafo",
          "texto": "Sem esse mecanismo, um teste que depende de uma configuração específica (ex.: \"faturar por unidade fabril\") teria de deixar o sistema configurado manualmente antes de rodar, o que tornaria a suíte não repetível e dependente do ambiente."
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "O parâmetro do caso de teste é autoaplicado: não existe necessidade de executar um processamento separado. Ele é aplicado pela etapa STARTED do Runner, imediatamente após o carregamento do caso, e é cronometrado como etapa própria (AplicarParametrosDoCasoTeste)."
        },
        {
          "tipo": "paragrafo",
          "texto": "A aplicação acontece em duas situações:"
        },
        {
          "tipo": "lista",
          "itens": [
            "No STARTED (via AplicarParametrosDoCasoTeste) - aplica os parâmetros de todos os casos de teste carregados na área, uma vez, antes do IRUNNER executar;",
            "Na troca de caso (via P39_TDD_FAT_DOCUMENTO_FATURA.SetCasoTeste) - o módulo de Faturamento fecha o formulário, reaplica os parâmetros e reabro a tela, porque a mudança de configuração invalida o formulário já aberto."
          ]
        }
      ]
    },
    {
      "id": "secao-2",
      "titulo": "Artefatos",
      "nivel": 2,
      "blocos": []
    },
    {
      "id": "secao-3",
      "titulo": "Unidades Envolvidas",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "tabela",
          "colunas": [
            "Unit de Codificação",
            "Responsabilidade"
          ],
          "linhas": [
            [
              "P39_TDD_PARAMETRO_MAPEAMENTO",
              "Mantém o mapeamento nome no JSON → campo no banco → tabela"
            ],
            [
              "P39_TDD_PARAMETROS",
              "Lê o JSON, compara com o valor atual, monta e executa o UPDATE e reconecta a sessão"
            ],
            [
              "P39_TDD_STARTED",
              "Aplica os parâmetros do caso de teste na inicialização"
            ],
            [
              "P39_TDD_CASOS_DE_TESTE",
              "Dispara Setup_Inicializar_Parametros durante a criação dos DataSets"
            ],
            [
              "P39_TDD_FUNCOES_JSON",
              "Leitura do valor atual do parâmetro na seção JSON do sistema"
            ],
            [
              "P39_TDD_FAT_DOCUMENTO_FATURA",
              "Reaplica parâmetros ao trocar de caso de teste (fecha e reabre o formulário)"
            ]
          ]
        }
      ]
    },
    {
      "id": "secao-4",
      "titulo": "Tabelas do ERP Alteradas",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Os parâmetros são gravados diretamente nas tabelas de configuração do ERP (não no banco dedicado de testes). Sempre restrito à empresa atual (Codigo_Empresa_Atual). São três:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Tabela",
            "Chave do filtro"
          ],
          "linhas": [
            [
              "CONFIG_SISTEMA",
              "Configuração global (sem filtro por empresa no UPDATE)"
            ],
            [
              "CONFIG_SISTEMA_EMPRESA",
              "EMPRESA_CFSEMP = Codigo_Empresa_Atual"
            ],
            [
              "PCP_CONFIG",
              "CODIGO_CONFIG = Codigo_Empresa_Atual"
            ]
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Os parâmetros são persistidos no banco e não são revertidos ao final da execução. Ao terminar a suíte, o ambiente fica com a última configuração aplicada. Em bases dedicadas de teste isso é aceitável, mas em ambientes compartilhados exige atenção."
        }
      ]
    },
    {
      "id": "secao-5",
      "titulo": "Parâmetros Mapeados",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O mapeamento fica no corpo de MapearParametros, na unit P39_TDD_PARAMETRO_MAPEAMENTO, e é carregado uma única vez por sessão (protegido pela flag FParametroMapeado). O array de mapeamento é fixo em array [0..8] — atualmente 9 parâmetros mapeados:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "#",
            "Chave no JSON",
            "Campo no banco",
            "Tabela"
          ],
          "linhas": [
            [
              "0",
              "Fat_PorUnidadeFabril",
              "FAT_PORUNIDADEFABRIL_CFS",
              "CONFIG_SISTEMA"
            ],
            [
              "1",
              "OrdemImpressaoItemNF",
              "FAT_ORDEMIMPRESSAONF_CFSEMP",
              "CONFIG_SISTEMA_EMPRESA"
            ],
            [
              "2",
              "ConsideraDiasParaEntregaDupFrete",
              "CONS_DIASENT_DUP_FRETE_CFSEMP",
              "CONFIG_SISTEMA_EMPRESA"
            ],
            [
              "3",
              "NecessarioAutorizarPagamentos",
              "NECESSARIOAUTORIZARPAGTO_CFS",
              "CONFIG_SISTEMA"
            ],
            [
              "4",
              "NecessarioAutorizarAdiantamentos",
              "NECESSARIOAUTORIZARDIANT_CFS",
              "CONFIG_SISTEMA"
            ],
            [
              "5",
              "ObrigatorioGrupoResultadoDiferenteDeZeroNaDuplicata",
              "GR_OBRIGATORIO_DUPL_CFS",
              "CONFIG_SISTEMA"
            ],
            [
              "6",
              "OcultarDuplicataPagarSalario",
              "OCULTARDUPLSALARIO_CFS",
              "CONFIG_SISTEMA"
            ],
            [
              "7",
              "BloquearLancamentoBorderoQualificacao0Todas",
              "BLOQLANCQUALIFTODAS_CFS",
              "CONFIG_SISTEMA"
            ],
            [
              "8",
              "BorderoExigirPreenchimentoRegraIntegracaoContabil",
              "EXIGIRREGRAINTEGRACAOCTB_CFS",
              "CONFIG_SISTEMA"
            ]
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Para mapear um novo parâmetro, basta adicionar uma linha Add(índice, chaveJson, campoDB, tabela). A ordem dos índices é fixa — mudar a ordem embaralha o mapeamento. Para ampliar a lista, é necessário aumentar o limite do array FMapeamentoParam."
        }
      ]
    },
    {
      "id": "secao-6",
      "titulo": "Instruções de uso",
      "nivel": 2,
      "blocos": []
    },
    {
      "id": "secao-7",
      "titulo": "Fluxo geral de uso",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Para usar um parâmetro em um caso de teste:"
        },
        {
          "tipo": "lista",
          "itens": [
            "Verificar se a chave já está mapeada em P39_TDD_PARAMETRO_MAPEAMENTO; caso contrário, adicionar o mapeamento;",
            "Incluir a chave e o valor no bloco parametros do JSON do caso de teste;",
            "Publicar a unit P39_TDD_PARAMETRO_MAPEAMENTO na Tek-Store, se ela foi alterada;",
            "Executar o caso de teste. O STARTED aplica os parâmetros automaticamente."
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "Exemplo de bloco parametros:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "\"parametros\": {\n  \"Fat_PorUnidadeFabril\": true,\n  \"OrdemImpressaoItemNF\": 0\n}"
        }
      ]
    },
    {
      "id": "secao-8",
      "titulo": "Como a aplicação acontece",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A rotina VerificarParametros(pJSONParametros) executa o seguinte para cada par chave/valor do objeto JSON:"
        },
        {
          "tipo": "lista",
          "itens": [
            "Filtra por necessidade de alteração - NecessarioModificarParam compara o valor informado com o valor atual (GetValueJson(SecaoParametroJson, pCampo)). Se forem iguais, o parâmetro é descartado e nenhum acesso ao banco é feito;",
            "Infere o tipo do valor a partir do próprio texto JSON, pela rotina PegarTipoCampo: contém \" → string é true ou false → booleano contém . → currency caso contrário → inteiro",
            "Acumula apenas os parâmetros a alterar em um TClientDataSet (CHAVE, VALOR) indexado pela chave;",
            "Executa um UPDATE por parâmetro acumulado, na tabela correspondente ao mapeamento;",
            "Reconecta a sessão do ERP (rotina Relogar) para recarregar a seção atual com os novos valores."
          ]
        }
      ]
    },
    {
      "id": "secao-9",
      "titulo": "Montagem do UPDATE",
      "nivel": 4,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O valor é convertido conforme o tipo inferido, e o WHERE é montado conforme a tabela:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Tipo inferido",
            "Conversão aplicada"
          ],
          "linhas": [
            [
              "String",
              "Remove as aspas e envolve em QuotedStr"
            ],
            [
              "Inteiro / Currency",
              "Usado como está, sem aspas"
            ],
            [
              "Boolean",
              "true → 'S', false → 'N'"
            ]
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "A execução do UPDATE é envolvida em try / except que engole a exceção. Uma falha ao gravar o parâmetro não interrompe a execução do teste — ela apenas não surte efeito, e o teste pode falhar mais adiante por isso. Em caso de falha (parâmetros), verificar o log do processamento e o estado real da tabela de configuração."
        }
      ]
    },
    {
      "id": "secao-10",
      "titulo": "Rotina Relogar",
      "nivel": 4,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Após aplicar os parâmetros, a rotina Relogar reabre o data module de conexão (DMCriadoPeloNome('DMConexao')) chamando ConectaServidorAplicacao e, em seguida, CarregaSecaoAtual. É esse passo que faz o ERP enxergar a nova configuração — sem ele, o banco teria o valor novo, mas a sessão continuaria com o valor antigo."
        }
      ]
    },
    {
      "id": "secao-11",
      "titulo": "Carregamento inicial dos parâmetros",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Na inicialização (Setup_Inicializar_Parametros, chamada por Setup_Inicializar_CasosTeste):"
        },
        {
          "tipo": "lista",
          "itens": [
            "MapearParametros monta o mapa de parâmetros (idempotente);",
            "É montado o SELECT que junta as três tabelas de configuração, usando o método CamposCadastro de cada classe (TClassConfigSistema, TClassConfigSistemaEmp, TClassPCP_Config) para montar a lista de colunas automaticamente;",
            "O resultado é carregado no CDSParametro e as propriedades dos campos são configuradas pelos mesmos métodos ConfigurarPropriedadesDosCampos."
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "O CDSParametro é a imagem atual dos parâmetros - é ele que permite o filtro por necessidade de alteração."
        }
      ]
    },
    {
      "id": "secao-12",
      "titulo": "Reaplicação na troca de caso",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O módulo de Faturamento executa todos os casos de teste da área. Como cada caso pode ter parâmetros diferentes, a rotina SetCasoTeste da unit P39_TDD_FAT_DOCUMENTO_FATURA reabastece o contexto do caso e, se houver parâmetros:"
        },
        {
          "tipo": "lista",
          "itens": [
            "fecha o formulário de pedido de venda (a configuração invalida o formulário aberto);",
            "chama {P39_TDD_PARAMETROS}VerificarParametros;",
            "reabre o formulário via Setup_IniciarFormulario."
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Esse ciclo de fechar/reabrir executa uma vez por caso de teste na área. Em áreas com muitos casos, é a maior parcela de tempo da execução - e aparece isoladamente na métrica Total de METRICAS_TICK_DIFF."
        }
      ]
    },
    {
      "id": "secao-13",
      "titulo": "Instalação e configurações",
      "nivel": 2,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Necessário publicar na Tek-Store as units P39_TDD_PARAMETROS e P39_TDD_PARAMETRO_MAPEAMENTO. A unit de mapeamento é carregada como dependência da unit de parâmetros."
        },
        {
          "tipo": "paragrafo",
          "texto": "O usuário que executa a suíte precisa de permissão para alterar CONFIG_SISTEMA, CONFIG_SISTEMA_EMPRESA e PCP_CONFIG na base de dados do ERP em uso."
        }
      ]
    },
    {
      "id": "secao-14",
      "titulo": "Ao mapear um novo parâmetro",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Adicionar em MapearParametros, respeitando o próximo índice livre:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "Add(9, 'NomeDoParametro', 'CAMPO_NO_BANCO', cTabelaConfigSistema);"
        },
        {
          "tipo": "paragrafo",
          "texto": "A constante da tabela deve ser uma das três já declaradas: cTabelaConfigSistema, cTabelaConfigSistemaEmpresa ou ctabelaConfigPCP."
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "O limite do array de mapeamento é array [0..8]. Ao ultrapassar a 9 entradas, é necessário alterar o limite em FMapeamentoParam — do contrário o mapeamento é corrompido em memória."
        }
      ]
    },
    {
      "id": "secao-15",
      "titulo": "Restrições",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "O filtro de empresa é aplicado somente a CONFIG_SISTEMA_EMPRESA e PCP_CONFIG. Em CONFIG_SISTEMA o UPDATE é executado sem WHERE, pois a tabela tem um único registro por parâmetro;",
            "Chaves não mapeadas são ignoradas silenciosamente: o filtro NecessarioModificarParam já as descarta por não encontrarem o valor atual;",
            "A comparação de valor atual depende de a chave existir na seção JSON do ERP (SecaoParametroJson) — chaves não publicadas na seção nunca são aplicadas."
          ]
        }
      ]
    },
    {
      "id": "secao-16",
      "titulo": "Observações importantes",
      "nivel": 2,
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Sem rollback. Parâmetros aplicados permanecem no banco após a execução. Se a suíte precisar restaurar a configuração original, isso deve ser feito explicitamente (por exemplo, com um caso de teste final que reaplique os valores originais).",
            "Escopo por empresa. Tudo é filtrado por Codigo_Empresa_Atual. A mesma suíte executada em filiais diferentes altera configurações diferentes — comportamento esperado e desejado.",
            "Aplicação incremental. Só parâmetros cujo valor realmente mudou são gravados, o que reduz drasticamente a quantidade de UPDATE e de reconexões.",
            "Falha silenciosa. Exceções de escrita são engolidas por desenho (ver alerta na seção de aplicação). O sintoma típico é o teste falhar por \"comportamento não aplicado\" e não por erro de configuração - sempre conferir o valor efetivo na tabela antes de suspeitar do código do teste.",
            "Booleano por convenção do banco. Valores lógicos são persistidos como 'S' / 'N', enquanto o JSON usa true / false. A conversão é automática em AtualizarParametros, mas é comum errar o lado do JSON ao escrever novos casos.",
            "Inferência de tipo por formato. O tipo não é declarado no JSON: é deduzido do texto do valor. Um número sem ponto decimal (ex.: 10) é tratado como inteiro; para um Currency é necessário informar o separador decimal (ex.: 10.5).",
            "Mapeamento único carregado por sessão. A flag FParametroMapeado impede recarregar o mapa mais de uma vez. Alterações no mapa só têm efeito em nova sessão do ERP."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
