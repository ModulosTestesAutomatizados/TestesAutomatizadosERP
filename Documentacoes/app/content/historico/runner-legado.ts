import type { IDocumento } from '../../models/documentacao.ts';
// Conteúdo migrado do arquivo histórico; apresentação compartilhada.
export default {
  "slug": "runner-legado",
  "categoria": "documentos",
  "titulo": "Runner — referência anterior",
  "resumo": "APIs anteriores, configuração e observações preservadas para comparação com o fluxo refatorado.",
  "estado": "legado",
  "fontes": [
    {
      "caminho": "Documentacoes/app/arquivo/html/runner-orquestrador/index.html"
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
          "texto": "O Runner (P39_TDD_RUNNER) é o orquestrador da execução de testes automatizados do ERP. É o ponto de entrada de toda a suíte: recebe a identificação do caso de teste (Módulo, Área e Descrição), conduz as etapas de inicialização, execução e encerramento, cronometra cada etapa e persiste o histórico e as métricas de execução no banco de dados dedicado de testes."
        },
        {
          "tipo": "paragrafo",
          "texto": "O fluxo do orquestrador é sequencial e sempre o mesmo:"
        },
        {
          "tipo": "lista",
          "itens": [
            "STARTED - carrega o caso de teste, aplica os parâmetros do sistema e valida a versão mínima exigida;",
            "IRUNNER - monta dinamicamente uma unit e a executa pelo interpretador, chamando os métodos de teste registrados;",
            "ASSERTS - acumuladores de verificação (PASS/FAIL);",
            "FINISHED - grava o histórico da execução e as métricas de tempo e de asserts."
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "A execução ocorre inteiramente dentro do interpretador do ERP. As units de teste não devem ser executadas pelo servidor: unit de caso de teste que Lange possui a validação if ExecutandoNoServidor then raise exception... em sua rotina Main."
        },
        {
          "tipo": "paragrafo",
          "texto": "Todo o acesso a dados é feito por conexão ODBC de 32 bits contra o banco dedicado, nunca contra o banco de produção. A centralização está na unit P39_TDD_ODBC, que fixa a conexão em P39_TDD_CONSTANTES.cConexaoODBCPadrao."
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
      "titulo": "Fluxo do Orquestrador",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A rotina pública Run(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string) é o único ponto de entrada. Sua estrutura é:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "Run(...)\n ├─ InicializarMetricasTickDiff\n ├─ RegistrarTick(0, 'Total')            <-- cronômetro da execução inteira\n ├─ CallBack_AbreTela('Run')\n ├─ try\n │   ├─ SetarCasoTeste(Modulo, Area, CasoTeste)\n │   ├─ STARTED      {P39_TDD_STARTED.}Started\n │   ├─ IRUNNER      {P39_TDD_IRUNNER.}Executar\n │   ├─ ASSERTS      (acumuladores)\n │   └─ FINISHED     {P39_TDD_FINISHED.}RegistrarMetricas\n │       └─ StatusExecucao := 'SUCESSO'\n └─ finally\n     ├─ RegistrarMetricas (proteção contra falha na persistência)\n     ├─ LiberarMetricasTickDiff\n     ├─ CallBack_FechaTela\n     └─ RegistrarTick(1, 'Total')"
        }
      ]
    },
    {
      "id": "secao-4",
      "titulo": "Etapas cronometradas",
      "nivel": 4,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O cronômetro usa GetTickCount / TickDiff e uma numeração incremental de etapas. Cada registro é gravado em um TClientDataSet interno (FCDSMetricasTickDiff) indexado por NOME_METODO; ETAPA_CASO_TESTE e indexado por é persistido ao final em METRICAS_TICK_DIFF."
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Etapa",
            "Responsável",
            "Descrição"
          ],
          "linhas": [
            [
              "Total",
              "RUNNER",
              "Tempo total da execução (aberto antes de tudo, fechado no finally)"
            ],
            [
              "STARTED",
              "RUNNER",
              "Etapa macro de inicialização"
            ],
            [
              "SetupCasoTeste",
              "STARTED",
              "Carrega módulo, área e o caso de teste do banco dedicado"
            ],
            [
              "AplicarParametrosDoCasoTeste",
              "STARTED",
              "Aplica o bloco parametros do JSON no sistema (relogar)"
            ],
            [
              "ValidarVersaoRequisito",
              "STARTED",
              "Compara REQUISITO_VERSAO_CT com a versão do ERP em execução"
            ],
            [
              "IRUNNER",
              "RUNNER",
              "Etapa macro de execução dos testes"
            ],
            [
              "ASSERTS",
              "RUNNER",
              "Etapa reservada para o acumulador de verificações"
            ],
            [
              "FINISHED",
              "RUNNER",
              "Persistência das métricas"
            ]
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "O tempo formatado é gravado no formato HH:MM:SS:mmm (ex.: 00:00:01:250), obtido por FormatarTickDiff."
        }
      ]
    },
    {
      "id": "secao-5",
      "titulo": "Unidades do Processo",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "tabela",
          "colunas": [
            "Unit de Codificação",
            "Papel no Runner"
          ],
          "linhas": [
            [
              "P39_TDD_RUNNER",
              "Orquestrador. Cronômetro, fluxo de etapas e contexto do caso de teste"
            ],
            [
              "P39_TDD_IRUNNER",
              "Executor. Monta a unit dinâmica e a envia ao interpretador"
            ],
            [
              "TDD_BASE_UNIT_IRUNNER",
              "Template da unit interpretada (placeholders __USES_UNITS__ e __CHAMADAS_METODOS__)"
            ],
            [
              "P39_TDD_STARTED",
              "Setup do caso de teste, aplicação de parâmetros e validação de versão"
            ],
            [
              "P39_TDD_FINISHED",
              "Persistência do histórico e das métricas"
            ],
            [
              "P39_TDD_LOGS",
              "Controle de modo debug e exibição de logs"
            ],
            [
              "P39_TDD_ASSERTS",
              "Acumuladores PASS / FAIL e asserts (modelo DUnitX)"
            ],
            [
              "P39_TDD_CASOS_DE_TESTE",
              "DataSets de casos de teste e carregamento de configuração do módulo"
            ],
            [
              "P39_TDD_ODBC",
              "Centralização da conexão ODBC de 32 bits"
            ],
            [
              "P39_TDD_CONSTANTES",
              "Constantes (conexão ODBC, versão) e SQLs do banco dedicado"
            ],
            [
              "P39_TDD_CACHE",
              "Cache de módulos e áreas em memória"
            ],
            [
              "P39_TDD_PARAMETRO",
              "Aplicação dos parâmetros do sistema a partir do JSON do caso de teste"
            ],
            [
              "P39_TDD_FUNCOES_JSON",
              "Leitura tipada de tags do JSON"
            ],
            [
              "P39_TDD_VALIDAR_GENERICO",
              "Comparação genérica campo a campo por tipo (usada na validação de resultado)"
            ]
          ]
        }
      ]
    },
    {
      "id": "secao-6",
      "titulo": "Tabelas do Banco Dedicado",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O Runner grava o resultado de toda execução. Uma execução gera exatamente 1 registro em HISTORICO_EXECUCAO, e N registros nas tabelas de métricas (uma por etapa cronometrada e uma de consolidação de asserts):"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Tabela",
            "Conteúdo"
          ],
          "linhas": [
            [
              "HISTORICO_EXECUCAO",
              "Uma linha por execução: caso de teste (FK), versão, requisito de versão, status (SUCESSO, FALHA, INCOMPATIVEL_VERSAO), etapa de falha, mensagem de erro e logs"
            ],
            [
              "METRICAS_TICK_DIFF",
              "Uma linha por etapa cronometrada: nome do método, número da etapa, início, fim, total (ms) e total formatado"
            ],
            [
              "METRICAS_ASSERTS",
              "Uma linha por execução com o consolidado de asserts (total, aprovados, falhos) e resultado esperado / obtido"
            ]
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "O vínculo entre elas é feito pela chave devolvida pelo INSERT ... RETURNING AUTOINC_HISTORICO_HE, executado por TDDScalarODBCP. As métricas só são gravadas se o FCDSMetricasTickDiff estiver atribuído."
        }
      ]
    },
    {
      "id": "secao-7",
      "titulo": "Instruções de uso",
      "nivel": 2,
      "blocos": []
    },
    {
      "id": "secao-8",
      "titulo": "Fluxo geral de uso",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O Runner não é chamado diretamente pelo usuário: ele é acionado pela unit de caso de teste, que declara o módulo, a área e o caso a executar. O fluxo é:"
        },
        {
          "tipo": "lista",
          "itens": [
            "O caso de teste chama {P39_TDD_RUNNER.}Run('FATURAMENTO', 'PEDIDO DE VENDA', 'PEDIDO COM DESCONTO PERCENTUAL');",
            "O Runner abre a tela de processamento e registra o cronômetro da execução total;",
            "STARTED localiza o caso de teste no banco dedicado, carrega o JSON, aplica os parâmetros e valida a versão do ERP;",
            "IRUNNER interpreta a unit montada e chama os métodos de teste (todas as rotinas Setup* na ordem de registro e, em seguida, todas as rotinas Teste*);",
            "FINISHED grava o histórico e as métricas e libera os recursos;",
            "O retorno da execução é o próprio log do processamento, exibido ao final."
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Ordem de execução dos métodos: o IRUNNER percorre a lista de métodos registrados e mantém apenas os que contenham Setup ou Teste no nome, preservando a ordem de registro. Métodos com outros prefixos são ignorados."
        }
      ]
    },
    {
      "id": "secao-9",
      "titulo": "Etapa STARTED - Inicialização",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Responsável pela unit P39_TDD_STARTED. Antes de qualquer teste, ela:"
        },
        {
          "tipo": "lista",
          "itens": [
            "Valida se o contexto do caso de teste foi configurado no Runner (módulo, área e descrição não podem estar em branco);",
            "Executa Setup_Inicializar_CasosTeste, que cria os DataSets, carrega o cache de módulos/áreas e inicializa os parâmetros;",
            "Define módulo e área pelo descrição (convertida para código pelo cache);",
            "Carrega todos os casos de teste ativos do módulo/área (ATIVO_CT = 'S') no CDSCasosTestes;",
            "Localiza o registro cuja DESCRICAO seja igual (comparação case-insensitive) à descrição informada e captura seu AUTOINC_CT no histórico;",
            "Carrega a configuração do módulo em CDSConfiguracao;",
            "Aplica o bloco parametros do JSON do caso de teste (ver documentação de Parâmetro);",
            "Valida a REQUISITO_VERSAO_CT contra a versão do ERP em execução, usando VersaoSistemaIgualOuSuperior."
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Se a versão do ERP for inferior à exigida pelo caso de teste, a execução é interrompida com a mensagem \"Versão atual não atende o requisito mínimo\", contendo a versão atual e a versão requisito. Esse cenário deve ser classificado como INCOMPATIVEL_VERSAO no histórico, e não como simples falha."
        },
        {
          "tipo": "paragrafo",
          "texto": "Quando o caso de teste não existe no banco dedicado, a exceção \"Caso de teste ... não encontrado\" é lançada e a execução termina antes do IRUNNER."
        }
      ]
    },
    {
      "id": "secao-10",
      "titulo": "Etapa IRUNNER - Execução dos testes",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O IRUNNER é a etapa que efetivamente roda os testes. A unit de caso de teste registra, antes de chamar o Runner, quais units e quais métodos devem ser executados:"
        },
        {
          "tipo": "codigo",
          "linguagem": "json",
          "codigo": "{P39_TDD_IRUNNER.}AddUsesUnit('P39_TDD_FAT_DOCUMENTO_FATURA');\n{P39_TDD_IRUNNER.}AddMetodo('Setup');\n{P39_TDD_IRUNNER.}AddMetodo('Teste');"
        },
        {
          "tipo": "paragrafo",
          "texto": "O IRUNNER então lê o template TDD_BASE_UNIT_IRUNNER do banco de testes (via CodificacaoUnit), substitui os placeholders e entrega o resultado ao método Interpretar do ERP:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "unit TDD_BASE_UNIT_IRUNNER;\n\nuses __USES_UNITS__;\n\nprocedure Main();\nbegin\n  __CHAMADAS_METODOS__\nend;\n\nend."
        },
        {
          "tipo": "paragrafo",
          "texto": "Após a substituição, o método gerado fica, por exemplo:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Main();\nbegin\n  Setup;\n  Teste;\nend;"
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Os métodos Setup* são executados antes dos métodos Teste* apenas se estiverem registrados nessa ordem. O IRUNNER respeita exatamente a ordem de registro em que foram adicionados."
        },
        {
          "tipo": "paragrafo",
          "texto": "O IRUNNER aborta com exceção antes de interpretar se:"
        },
        {
          "tipo": "lista",
          "itens": [
            "nenhuma unit tiver sido informada em AddUsesUnit;",
            "nenhum método tiver sido informado em AddMetodo."
          ]
        }
      ]
    },
    {
      "id": "secao-11",
      "titulo": "Tratamento de falhas e status",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O Runner envolve todo o fluxo em try / except. Quando qualquer etapa levanta exceção:"
        },
        {
          "tipo": "lista",
          "itens": [
            "a MensagemErro é preenchida com o texto da exceção;",
            "o StatusExecucao passa a FALHA — exceto se já for INCOMPATIVEL_VERSAO, que é preservado;",
            "a exceção é relançada, de modo que o processamento continue o tratamento de erro padrão do ERP."
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "O bloco finally garante que as métricas sejam persistidas, os DataSets liberados e as telas fechadas mesmo em caso de erro. A falha ao persistir as métricas, nesse cenário, é apenas registrada em log e não substitui o erro original."
        },
        {
          "tipo": "paragrafo",
          "texto": "Status possíveis gravados em HISTORICO_EXECUCAO.STATUS_EXECUCAO_HE:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Status",
            "Quando ocorre"
          ],
          "linhas": [
            [
              "SUCESSO",
              "Todas as etapas (STARTED, IRUNNER, ASSERTS, FINISHED) concluíram sem exceção"
            ],
            [
              "FALHA",
              "Qualquer etapa lançou exceção"
            ],
            [
              "INCOMPATIVEL_VERSAO",
              "Versão do ERP inferior ao REQUISITO_VERSAO_CT do caso de teste"
            ]
          ]
        }
      ]
    },
    {
      "id": "secao-12",
      "titulo": "Logs e modo debug",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Cada transição de etapa do Runner gera duas linhas no log do processamento, o que permite auditar a sequência executada mesmo quando há falha:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "INICIOU STARTED\nENCERROU STARTED\nINICIOU IRUNNER\nENCERROU IRUNNER\nINICIOU ASSERTS\nENCERROU ASSERTS\nINICIOU FINISHED\nENCERROU FINISHED"
        },
        {
          "tipo": "paragrafo",
          "texto": "O controle de mensagens de debug é feito pela variável global FModoDebug, declarada em P39_TDD_LOGS. Todas as units definem suas próprias instruções em Main, exibidas através de MostrarInstrucoesUnit quando FExibirInstrucoes estiver habilitada."
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "O cronômetro desliga o modo debug durante o registro de ticks (FModoDebug := False) e religa ao final, para que as rotinas de instrumentação não poluam o log."
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
          "texto": "Necessário publicar na Tek-Store as units de codificação do Runner e suas dependências listadas em Artefatos. O Runner não é uma unit autônoma: se qualquer dependência não estiver publicada, a interpretação falha na carga do uses."
        }
      ]
    },
    {
      "id": "secao-14",
      "titulo": "Conexão com o banco dedicado",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A conexão é definida em P39_TDD_CONSTANTES e consumida por P39_TDD_ODBC:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "cDataBase          = 'DBTESTESAUTOMATIZADOS';\ncConexaoODBCPadrao = 'TESTE_AUTOMATIZADO_32B';"
        },
        {
          "tipo": "paragrafo",
          "texto": "Nunca declarar string de conexão local nas units de teste: sempre passar pelos métodos TDDScalarODBC, TDDReaderODBC e TDDCommandODBC (e suas variantes ...P, com parâmetros), que já forçam o uso da conexão ODBC de 32 bits."
        }
      ]
    },
    {
      "id": "secao-15",
      "titulo": "Tabelas obrigatórias",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "As tabelas HISTORICO_EXECUCAO, METRICAS_TICK_DIFF e METRICAS_ASSERTS devem existir no banco dedicado. Sem elas, a etapa FINISHED falha e a execução é registrada como FALHA mesmo que todos os testes tenham passado."
        }
      ]
    },
    {
      "id": "secao-16",
      "titulo": "Registro dos casos de teste",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Antes da primeira execução, os casos de teste precisam estar registrados na tabela CASO_TESTE. Isso é feito pela unit P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS, que chama RegistrarCasoTeste para cada combinação Módulo / Área / Caso de Teste mapeada no corpo da rotina. Ver a documentação de Caso de Teste."
        }
      ]
    },
    {
      "id": "secao-17",
      "titulo": "Template da unit interpretada",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O IRUNNER busca o template pelo nome TDD_BASE_UNIT_IRUNNER usando CodificacaoUnit. Esse nome deve existir no banco de testes, e não pode ser confundido com o nome de arquivo P39_TDD_BASE_UNIT_IRUNNER.pas no diretório de sources: o Runner resolve o template em tempo de execução pelo código da unit."
        }
      ]
    },
    {
      "id": "secao-18",
      "titulo": "Observações importantes",
      "nivel": 2,
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Acoplamento intencional. As units do Runner acessam diretamente variáveis e rotinas umas das outras (por exemplo FHistoricoExecucao, FCDSMetricasTickDiff e RegistrarTick de TDD_RUNNER são usados por TDD_STARTED e TDD_FINISHED). Isso é proposital: existe um fluxo completo de TDD, não módulos isolados.",
            "Execução no interpretador. Não há compilação das units de teste. Alterações de código exigem republicação da unit na Tek-Store antes de produzirem efeito.",
            "Métricas mesmo em falha. O finally garante a persistência das métricas mesmo quando o teste falha, permitindo a análise de desempenho de execuções com erro.",
            "Granularidade do cronômetro. GetTickCount é monotônico e mede em milissegundos; valores muito curtos (abaixo de ~15 ms) podem aparecer como 00:00:00:000 por resolução do sistema.",
            "Etapa de falha. O campo ETAPA_FALHA_HE existe no histórico, mas o Runner não o preenche automaticamente na tratativa de erro: hoje a informação de em qual etapa a falha ocorreu é obtida pela sequência de linhas INICIOU / ENCERROU no log.",
            "Consolidação de asserts. A unit TDD_FINISHED grava METRICAS_ASSERTS a partir do registro FMetricasAsserts, que é declarado no Runner mas não é preenchido no fluxo atual — os contadores são gravados como zero.",
            "Validação de versão dentro do STARTED. A rotina SetupCasoTeste possui um ponto de parada de depuração (\"Finalizamos até aqui!\") imediatamente após o carregamento dos casos de teste. Enquanto ele estiver presente, a execução sempre será interrompida antes de aplicar os parâmetros.",
            "Leitura do registro de início. No ramo de Início de RegistrarTick, a variável de verificação do FindKey não é atribuída antes do uso, o que torna a validação de \"etapa já iniciada\" ineficaz. A proteção efetiva vem do Locate por TEMPO_FIM = 0 feito no ramo de Fim.",
            "Leitura de logs. O arquivo de log do processamento é a saída oficial de cada execução. Em caso de falha, sempre consultar o log antes de investigar o banco: a etapa exata fica evidentemente marcada."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
