import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "runner",
  "categoria": "estrutura",
  "titulo": "IRunner.Executar",
  "resumo": "Da geração do programa ao lote, capturas, asserts e persistência: contratos atuais e fronteiras de responsabilidade.",
  "estado": "em-desenvolvimento",
  "navegacao": {
    "grupo": "estrutura",
    "ordem": 0
  },
  "fontes": [
    {
      "caminho": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_IRUNNER.pas"
    },
    {
      "caminho": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_UNIT_BASE_IRUNNER.pas"
    },
    {
      "caminho": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_RUNNER.pas"
    },
    {
      "caminho": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_STARTED.pas"
    },
    {
      "caminho": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_FINISHED.pas"
    },
    {
      "caminho": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_LOGS.pas"
    },
    {
      "caminho": "docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_ASSERTS.pas"
    },
    {
      "caminho": "docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_APPLICATION.pas"
    },
    {
      "caminho": "docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_VALIDAR_RESULTADO.pas"
    },
    {
      "caminho": "docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas"
    },
    {
      "caminho": "docs/assets/casosTestesFinanceiro/processamentos/P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO.pas"
    },
    {
      "caminho": "docs/assets/casosTestesFinanceiro/TDD_FIN_FINANCEIRO.pas"
    },
    {
      "caminho": "docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_RUN_IRUNNER.ast.json"
    }
  ],
  "secoes": [
    {
      "id": "contrato",
      "titulo": "Contrato de entrada",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO configura uma única unit com procedure Teste sem parâmetros, informa módulo e área como literais Pascal e chama TDD_RUN_IRUNNER.Executar. A interpretação ocorre uma vez; a casca percorre os registros do lote."
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "SetTDDUnit('TDD_FIN_FINANCEIRO');\nAddParamsRun('''FINANCEIRO''');\nAddParamsRun('''FINANCEIRO''');\nExecutar;"
        },
        {
          "tipo": "paragrafo",
          "texto": "O exemplo depende do cadastro das units no interpretador. Nome local, identificador no uses e referência remota P39_ são registrados separadamente; um alias no portal não instala uma variante remota."
        }
      ]
    },
    {
      "id": "responsabilidades",
      "titulo": "Responsabilidades e fronteiras",
      "blocos": [
        {
          "tipo": "mermaid",
          "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/runner/responsabilidades.md",
          "titulo": "Donos das responsabilidades"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Unit",
            "Responsabilidade",
            "Artefatos próprios/consumidos"
          ],
          "linhas": [
            [
              "TDD_RUN_IRUNNER",
              "Montagem e Interpretar uma vez",
              "FTDDUnit, FParamsCasosTeste, FUnitInterpretar"
            ],
            [
              "TDD_RUN_UNIT_BASE_IRUNNER",
              "Lote, cursor, Run, continuidade e limpeza",
              "Consome contexto compartilhado; não declara globais próprios"
            ],
            [
              "TDD_RUN_RUNNER",
              "Preparação do caso e ticks",
              "FHistoricoExecucao, FContextoCasoTeste, FMetricasAsserts, FCDSMetricasTickDiff"
            ],
            [
              "TDD_RUN_STARTED",
              "Versão e aplicação de parâmetros",
              "Registro corrente e parâmetros do ERP"
            ],
            [
              "P39_TDD_RUN_ASSERTS",
              "Contadores, resultados, erros reais e clones",
              "FAssertsTotal/Pass/Fail, FFalhas, FResultados, FDataSets, FErrosReais"
            ],
            [
              "P39_TDD_RUN_VALIDAR_RESULTADO",
              "Interpretação de critérios JSON",
              "Consome capturas/tempo e acumula por RUN_ASSERTS"
            ],
            [
              "TDD_RUN_FINISHED",
              "Consolidação e persistência, incluindo snapshot dos logs",
              "Consome records/métricas, preenche AutoIncHistorico"
            ],
            [
              "TDD_RUN_LOGS",
              "Mensagens em debug e instruções separadas",
              "FModoDebug, FExibirInstrucoes, FLogsCasoTeste"
            ],
            [
              "P39_TDD_CASOS_DE_TESTE",
              "Módulo/área e datasets do lote",
              "FModulo, FDescModulo, CDSCasosTestes, CDSResultadoEsperado"
            ],
            [
              "P39_TDD_RUN_APPLICATION",
              "Telas por menu e foco",
              "FP; consome contexto de CASOS_DE_TESTE"
            ]
          ]
        }
      ]
    },
    {
      "id": "geracao",
      "titulo": "Geração do programa interpretado",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Executar lê CodificacaoUnit('TDD_RUN_UNIT_BASE_IRUNNER') e substitui quatro marcadores: __USES_UNITS__, __PARAMETROS_CASO_TESTE__, __CHAMADAS_METODOS__ e __MODO_DEBUG__. A chamada Teste gerada recebe delimitadores, callback e ticks; o cenário não deve controlar o cursor."
        },
        {
          "tipo": "paragrafo",
          "texto": "O modo debug é transmitido ao programa gerado. FUnitInterpretar e FParamsCasosTeste são liberadas e recebem nil no finally; FTDDUnit permanece selecionada."
        },
        {
          "tipo": "mermaid",
          "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/runner/geracao.md",
          "titulo": "Carga dinâmica e montagem"
        }
      ]
    },
    {
      "id": "uses",
      "titulo": "Grafo AST dos uses",
      "blocos": [
        {
          "tipo": "mermaid",
          "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_RUN_IRUNNER.md",
          "titulo": "Dependências reais do conjunto Runner"
        },
        {
          "tipo": "paragrafo",
          "texto": "O inventário registra roots, caminhos, linhas, hashes e edges extraídos das cláusulas uses, mascarando comentários e literais Pascal. Dependências dinâmicas de CodificacaoUnit/SetTDDUnit e estados compartilhados aparecem em mapas separados."
        },
        {
          "tipo": "paragrafo",
          "texto": "Variantes sem P39_ só apontam para um arquivo local quando há candidato inequívoco, identificado como variante de referência no inventário; isso não comprova cadastro remoto. O uses TDD_VALIDAR_RESULTADO de TDD_RUN_RUNNER permanece não resolvido pelo nome dos arquivos locais; o validador atual tem nome P39_TDD_RUN_VALIDAR_RESULTADO."
        }
      ]
    },
    {
      "id": "lote",
      "titulo": "Lote e tentativa individual",
      "blocos": [
        {
          "tipo": "mermaid",
          "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/runner/lote.md",
          "titulo": "Controle do lote e cursor"
        },
        {
          "tipo": "mermaid",
          "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/runner/tentativa.md",
          "titulo": "Started, Teste, capturas, asserts e finalização"
        },
        {
          "tipo": "paragrafo",
          "texto": "ExecutarLote faz SetupCasosTestes uma vez e controla First/Run/Next. SetarCasoTeste recebe somente módulo e área, zera histórico/métricas/contexto e AssertsZerar antes de ler ID, REQUISITOVERSAO e DESCRICAO do registro corrente."
        },
        {
          "tipo": "paragrafo",
          "texto": "No financeiro, Teste valida dados, executa quatro operações e captura os datasets após gravar. Seu finally faz TEARDOWN antes de retornar. A etapa ASSERTS da casca então compara clones que continuam disponíveis em FDataSets."
        }
      ]
    },
    {
      "id": "asserts",
      "titulo": "Asserts, validação e estados do resultado",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "RegistrarResultado retorna Boolean e acumula PASS/FAIL. FResultados contém aprovados e reprovados; FFalhas guarda somente reprovações. AssertsOk determina SUCESSO ou FALHA em Run; erro de versão preserva VERSAO_INCOMPATIVEL."
        },
        {
          "tipo": "paragrafo",
          "texto": "RegistrarDataSet copia Data e RecNo de DataSet|DM sem editar/liberar o original. A captura seguinte da mesma chave substitui a anterior. cds/dm desambiguam campos; ausência, ambiguidade, NULL ou conversão inválida não devem aprovar zero/falso silenciosamente."
        },
        {
          "tipo": "paragrafo",
          "texto": "O validador compara obtido > esperado em Maior e obtido < esperado em Menor. Ele consome FErrosReais e FTempoExecucaoMs; não possui cronômetro próprio, não reinicia asserts, não mostra diálogos nem controla ScriptDeTestesEmExecucao."
        },
        {
          "tipo": "paragrafo",
          "texto": "CompararComJSON aceita resultadoEsperado como wrapper nos registros novos e seções erro/valor/tempo na raiz nos antigos. {} ou resultado ausente sinaliza SEM_VALIDACAO e preserva as verificações explícitas já acumuladas; o mínimo remoto é resolvido na sincronização, não no runner."
        }
      ]
    },
    {
      "id": "falhas",
      "titulo": "Falhas, continuidade e encerramento",
      "blocos": [
        {
          "tipo": "mermaid",
          "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/runner/falhas.md",
          "titulo": "Propagação e persistência parcial"
        },
        {
          "tipo": "lista",
          "itens": [
            "Falha ordinária do Teste ou reprovação de assert pode permitir outro caso se a finalização passar. Preparação, TEARDOWN inseguro, callbacks e persistência têm caminhos de propagação que podem interromper o lote.",
            "Run tenta RegistrarMetricas no finally quando existe ID válido, inclusive diante de falha anterior; só depois limpa a lista de logs.",
            "A causa anterior é preservada nos diagnósticos de finalização. O prefixo MensagemPersonalizada fica centralizado em Main.",
            "O resumo dos casos falhos é apresentado depois da limpeza e dos históricos individuais. Não é automaticamente salvo em cada histórico. Sucesso do lote não produz esse raise de resumo."
          ]
        }
      ]
    },
    {
      "id": "estado",
      "titulo": "Estados globais e execuções variáveis",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O cursor e os datasets pertencem ao lote, enquanto histórico, contexto, contadores, capturas e ticks são reiniciados por caso. Não transportar resultado do caso anterior para o seguinte; consumidores não devem recarregar o lote ou avançar o cursor."
        },
        {
          "tipo": "mermaid",
          "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/runner/estados.md",
          "titulo": "Produtores, consumidores e ciclo de vida"
        },
        {
          "tipo": "paragrafo",
          "texto": "Os parâmetros aplicados ao ERP não são automaticamente restaurados ao liberar datasets. A casca libera FLogsCasoTeste ao encerrar sem atribuir nil; reexecução no mesmo contexto continua sendo um limite que exige correção/evidência de outra iteração."
        }
      ]
    },
    {
      "id": "persistencia",
      "titulo": "Logs, métricas e persistência",
      "blocos": [
        {
          "tipo": "mermaid",
          "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/runner/persistencia-modelo.md",
          "titulo": "Modelo de histórico e métricas"
        },
        {
          "tipo": "mermaid",
          "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/runner/persistencia.md",
          "titulo": "Histórico e métricas por tentativa"
        },
        {
          "tipo": "paragrafo",
          "texto": "RegistrarLog sempre acumula mensagens em TDD_RUN_LOGS; FModoDebug controla somente sua exibição e FExibirInstrucoes controla instruções independentemente. Outros fontes ainda podem citar RegistrarLogEmModoDebug, que não é mais declarado na unit atual; essas chamadas exigem alinhamento no código TDD. FINISHED copia FLogsCasoTeste.Text imediatamente antes do INSERT."
        },
        {
          "tipo": "paragrafo",
          "texto": "RegistrarTick trabalha com base relativa Double, trata a volta Cardinal com 4294967296.0, rejeita relativo maior que 2147483646 e soma 1 porque zero indica fim em aberto. FINISHED encerra ticks pendentes pelo próprio RegistrarTick(1, nome)."
        },
        {
          "tipo": "paragrafo",
          "texto": "TDD_RUN_FINISHED insere HISTORICO_EXECUCAO com RETURNING, uma linha agregada de METRICAS_ASSERTS e linhas de METRICAS_TICK_DIFF. Os asserts incluem total zero/parciais, etapa, tempo, aprovados/falhos e esperado/obtido de FResultadoEsperadoCaso/FResultados.Text. O campo de logs é LOGS_PROCESSAMENTO_HE."
        },
        {
          "tipo": "paragrafo",
          "texto": "Não há retry automático nem garantia de transação única para histórico e filhos; pode haver persistência parcial. Banco indisponível impede prometer logs salvos. Consulte também docs/MER.md e o contrato da unit."
        }
      ]
    },
    {
      "id": "parametros",
      "titulo": "Parâmetros e limites nativos",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "TDD_RUN_STARTED usa TJSONObject/GetPair/GetPairName/GetPairValue. parametros ausente ou objeto vazio não aplica alterações; seção com tipo incorreto falha. GetValueJson não deve ser usado para extrair objeto inteiro: a sonda nativa observou Conversion from TJSONObject to string is not supported, e propriedade ausente também pode lançar."
        },
        {
          "tipo": "paragrafo",
          "texto": "A captura Data/RecNo, índices/filtros e disponibilidade após gravar precisam de validação no ERP. Testes locais com doubles e resultado {} não comprovam compilação no JvInterpreter nem efeitos financeiros universais."
        }
      ]
    }
  ]
} satisfies IDocumento;
