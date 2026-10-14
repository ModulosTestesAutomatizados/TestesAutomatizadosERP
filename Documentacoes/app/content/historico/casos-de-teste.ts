import type { IDocumento } from '../../models/documentacao.ts';
// Conteúdo migrado do arquivo histórico; apresentação compartilhada.
export default {
  "slug": "casos-de-teste",
  "categoria": "documentos",
  "titulo": "Casos de teste",
  "resumo": "Cadastro, sincronização, datasets e modelos de entrada da documentação anterior.",
  "estado": "legado",
  "fontes": [
    {
      "caminho": "Documentacoes/app/arquivo/html/casos-de-teste/index.html"
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
          "texto": "O caso de teste é a unidade de negócio que descreve o que deve ser testado e com quais dados. Ele vive na tabela CASO_TESTE do banco dedicado de testes e é identificado pela tripla Módulo + Área + Descrição."
        },
        {
          "tipo": "paragrafo",
          "texto": "fisicamente, um caso de teste é composto por quatro blobs JSON:"
        },
        {
          "tipo": "lista",
          "itens": [
            "CASO_TESTE_CT - os dados de entrada do teste (o que será executado);",
            "CAMPOS_DISPONIVEIS_CT - a relação de campos que o caso pode utilizar (uso opcional);",
            "RESULTADO_ESPERADO_CT - as asserts a serem comparadas ao final;",
            "parametros (dentro do JSON do caso) - os parâmetros do sistema a aplicar antes da execução."
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "Essa separação é o que torna a suíte data-driven: o mesmo código de teste (unit de caso de teste) atende qualquer número de cenários, bastando cadastrar novos registros no banco."
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "O Runner identifica o caso de teste pela descrição exata (comparação sem diferenciar maiúsculas de minúsculas). Renomear a descrição de um caso de teste ativo quebra a unit que o executa."
        },
        {
          "tipo": "paragrafo",
          "texto": "Os casos de teste são identificados por descrição e não por código na unit de teste. A unit passa 'FATURAMENTO', 'PEDIDO DE VENDA' e 'PEDIDO COM DESCONTO PERCENTUAL' ao Runner, que faz a conversão para os códigos internos de módulo e área usando o cache."
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
      "titulo": "Estrutura da Tabela CASO_TESTE",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "tabela",
          "colunas": [
            "Campo",
            "Tipo",
            "Descrição"
          ],
          "linhas": [
            [
              "AUTOINC_CT",
              "BIGINT",
              "Chave primária (gerada por trigger no banco)"
            ],
            [
              "MODULO_CT",
              "BIGINT",
              "Módulo do caso de teste (FK → MODULO)"
            ],
            [
              "AREA_CT",
              "BIGINT",
              "Área do caso de teste (FK → AREA)"
            ],
            [
              "DESCRICAO_CASO_TESTE_CT",
              "VARCHAR(255)",
              "Descrição do caso de teste - chave de negócio"
            ],
            [
              "CASO_TESTE_CT",
              "BLOB",
              "JSON com os dados de entrada do teste"
            ],
            [
              "CAMPOS_DISPONIVEIS_CT",
              "BLOB",
              "JSON com os campos disponíveis para o caso"
            ],
            [
              "RESULTADO_ESPERADO_CT",
              "BLOB",
              "JSON com as asserts esperadas"
            ],
            [
              "REQUISITO_VERSAO_CT",
              "VARCHAR(10)",
              "Versão mínima do ERP exigida (opcional)"
            ],
            [
              "ATIVO_CT",
              "CHAR(1)",
              "'S' / 'N'. Só casos ativos são carregados pelo Runner"
            ]
          ]
        }
      ]
    },
    {
      "id": "secao-4",
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
              "P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS",
              "Cadastro em lote. Declara no corpo da routine a lista de casos e dispara a sincronização no banco dedicado"
            ],
            [
              "P39_TDD_REGISTRAR_CASO_TESTE",
              "Registra / sincroniza um caso de teste, criando módulo e área por fallback"
            ],
            [
              "P39_TDD_CARREGAR_CASO_TESTE",
              "Carrega um caso de teste específico, filtrando por descrição, módulo e área"
            ],
            [
              "P39_TDD_CASOS_DE_TESTE",
              "DataSets em memória com os casos de teste do módulo/área e o resultado esperado"
            ],
            [
              "P39_TDD_CACHE",
              "Traduz nome de módulo / área em código, via cache"
            ],
            [
              "P39_TDD_CONSTANTES",
              "SQL SQLCasosTestes e SQLs de configuração por módulo"
            ],
            [
              "P39_TDD_FAT_VALIDAR_RESULTADO",
              "Compara o resultado obtido contra RESULTADO_ESPERADO_CT"
            ]
          ]
        }
      ]
    },
    {
      "id": "secao-5",
      "titulo": "Cases de Teste Cadastrados",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A unit de sincronização mantém o cadastro canônico dos casos de teste. Ao rodar Sincronizar, os casos abaixo são criados ou atualizados no banco dedicado:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Módulo",
            "Área",
            "Caso de Teste",
            "Unit com o JSON de entrada",
            "Resultado esperado"
          ],
          "linhas": [
            [
              "FINANCEIRO",
              "BORDERO",
              "CADASTRAR DUPLICATA A RECEBER",
              "P39_TDD_JSON_FINANCEIRO",
              "-"
            ],
            [
              "FATURAMENTO",
              "PEDIDO DE VENDA",
              "PEDIDO COM DESCONTO PERCENTUAL",
              "P39_TDD_JSON_PEDIDO_DESCONTO_PERCENTUAL",
              "P39_TDD_JSON_BASE_RESULTADO_ESPERADO"
            ],
            [
              "FATURAMENTO",
              "PEDIDO DE VENDA",
              "PEDIDO POR UNIDADE FABRIL",
              "P39_TDD_JSON_PEDIDO_UNIDADE_FABRIL",
              "P39_TDD_JSON_BASE_RESULTADO_ESPERADO"
            ],
            [
              "FATURAMENTO",
              "PEDIDO DE VENDA",
              "PEDIDO COM SEQUENCIA NOS ITENS",
              "P39_TDD_JSON_PEDIDO_SEQUENCIA_ITENS",
              "P39_TDD_JSON_BASE_RESULTADO_ESPERADO"
            ]
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "O conteúdo dos JSONs fica em units separadas (nomeadas P39_TDD_JSON_*). Isso é intencional: o dado de teste é versionado como código, enquanto o registro no banco é gerado a partir dele."
        }
      ]
    },
    {
      "id": "secao-6",
      "titulo": "DataSets em Memória",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O carregamento feito por P39_TDD_CASOS_DE_TESTE preenche dois DataSets, indexados pelo código do caso de teste:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "DataSet",
            "Campos"
          ],
          "linhas": [
            [
              "CDSCasosTestes",
              "ID, MODULO, AREA, DESCRICAO, CASOTESTE (blob), EXECUTADO, COMPARADO"
            ],
            [
              "CDSResultadoEsperado",
              "ID, RESULTADO_ESPERADO (blob)"
            ]
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "Os campos EXECUTADO e COMPARADO nacem como 'N' e são usados pela unit de teste para marcar o andamento da suíte (EXECUTADO passa a 'S' ao final de cada caso)."
        },
        {
          "tipo": "paragrafo",
          "texto": "A consulta base (montada em SQLCasosTestes) filtra somente casos ativos:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "SELECT AUTOINC_CT,\n       DESCRICAO_CASO_TESTE_CT,\n       CASO_TESTE_CT,\n       CAMPOS_DISPONIVEIS_CT,\n       RESULTADO_ESPERADO_CT\nFROM CASO_TESTE\nwhere ATIVO_CT = 'S'\n  and MODULO_CT = :codigoModulo\n  and AREA_CT   = :codigoArea"
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
          "texto": "Para cadastrar um novo caso de teste, o fluxo é:"
        },
        {
          "tipo": "lista",
          "itens": [
            "Criar a unit com o JSON de entrada do caso, nomeada P39_TDD_JSON_<ASSUNTO>, e publicá-la na Tek-Store;",
            "Se o caso tiver asserts, criar (ou reaproveitar) a unit de resultado esperado;",
            "Adicionar uma linha RegistrarCasoTeste('MÓDULO', 'ÁREA', 'DESCRIÇÃO', 'UNIT_JSON', 'CAMPOS', 'RESULTADO') no corpo de RegistrosCasosTestes;",
            "Executar P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS - módulo e área são criados automaticamente se ainda não existirem;",
            "Referenciar o caso pela descrição na unit de teste, ao chamar o {P39_TDD_RUNNER.}Run."
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "A sincronização é idempotente: rodar novamente sem alterações não gera diferenças no banco. Se o registro já existir, é exibida uma confirmação antes do UPDATE."
        }
      ]
    },
    {
      "id": "secao-9",
      "titulo": "Cadastro e Sincronização",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A rotina RegistrarCasoTeste executa, nesta ordem:"
        },
        {
          "tipo": "lista",
          "itens": [
            "Carrega o conteúdo das units JSON informadas (usando CodificacaoUnit). Unit vazia é gravada como {};",
            "Resolve o módulo por descrição; se não existir, cria (RegistroFallbackModulo);",
            "Resolve a área por descrição dentro do módulo; se não existir, cria (RegistroFallbackArea);",
            "Consulta se já existe caso de teste com a mesma descrição + módulo + área;",
            "Se não existir, faz INSERT; se existir, pergunta ao usuário e então faz UPDATE."
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Todas as inserções e atualizações usam comandos parametrizados (TDDCommandODBCP). Nunca use QuotedStr ao gravar os blobs JSON: aspas literais corrompem o JSON armazenado no banco."
        },
        {
          "tipo": "paragrafo",
          "texto": "O AUTOINC_CT não é informado no INSERT: o autoincremento é responsabilidade de trigger no banco dedicado."
        }
      ]
    },
    {
      "id": "secao-10",
      "titulo": "Estrutura do JSON de entrada",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O JSON do caso (CASO_TESTE_CT) é dividido em três blocos de alto nível:"
        },
        {
          "tipo": "codigo",
          "linguagem": "json",
          "codigo": "{\n  \"documento\": {\n    \"cliente_docfat\": 1125,\n    \"descricao_tabela_preco\": \"TABELA DE PREÇOS FOB 2023\",\n    \"percdesc_docdescprinc\": \"10.5, 5.3, 3.1\",\n    \"transacao_docfat\": 0\n  },\n  \"item\": {\n    \"tag_prodcomum\": 0,\n    \"quantidade\": 0,\n    \"valor\": 0,\n    \"itens\": [\n      { \"item\": 2, \"variacao\": 0, \"cor\": 23, \"acabamento\": 0,\n        \"quantidade\": 2, \"valor\": 355.55, \"desconto\": 1.1 }\n    ]\n  },\n  \"parametros\": {\n    \"ConsideraDiasParaEntregaDupFrete\": true,\n    \"OrdemImpressaoItemNF\": 0\n  }\n}"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Bloco",
            "Conteúdo"
          ],
          "linhas": [
            [
              "documento",
              "Dados do cabeçalho do documento a ser gerado"
            ],
            [
              "item",
              "Configuração e relação de itens do documento"
            ],
            [
              "parametros",
              "Parâmetros do sistema aplicados antes da execução (ver documentação de Parâmetro)"
            ]
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "As chaves do JSON são os nomes dos campos do ERP, em minúsculas (ex.: cliente_docfat → CLIENTE_DOCFAT). Os valores são lidos de forma tipada: inteiros, moeda, data e lógico aceitam o valor padrão quando a tag não existe."
        }
      ]
    },
    {
      "id": "secao-11",
      "titulo": "Resultado Esperado (asserts)",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "O blob RESULTADO_ESPERADO_CT descreve o que deve ser verdadeiro ao final do caso:"
        },
        {
          "tipo": "codigo",
          "linguagem": "json",
          "codigo": "{\n  \"erro\": {\n    \"quantidade\": 0,\n    \"operacao\": \"Igual\"\n  },\n  \"valor\": [\n    {\n      \"campo\": \"VALOR_BRUTO_DOCFAT\",\n      \"operacao\": \"Igual, Maior, Menor\",\n      \"tipo_campo\": \"ftCurrency\",\n      \"resultado\": 1.0\n    }\n  ],\n  \"tempo\": {\n    \"tempo_total\": 10000,\n    \"tipo_registo\": \"data, hora, minuto, segundo, milissegundo\"\n  }\n}"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Seção",
            "Chave",
            "Descrição"
          ],
          "linhas": [
            [
              "erro",
              "quantidade, operacao",
              "Quantidade de erros reais gerados durante a execução e a operação de comparação (Igual, Maior, Menor)"
            ],
            [
              "valor",
              "campo, operacao, resultado, tipo_campo",
              "Lista de verificações campo a campo nos DataSets registrados"
            ],
            [
              "tempo",
              "tempo_total, tipo_registo",
              "Limite de tempo da execução do caso"
            ]
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "Tipos de campo suportados na comparação: ftString (somente Igual), ftInteger, ftCurrency, ftDateTime e ftBoolean."
        }
      ]
    },
    {
      "id": "secao-12",
      "titulo": "Execução e carga individual",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Na execução da suíte, o STARTED carrega todos os casos ativos do módulo/área e seleciona o pedido. Já a unit P39_TDD_CARREGAR_CASO_TESTE permite carregar um caso específico, útil para depuração pontual:"
        },
        {
          "tipo": "codigo",
          "linguagem": "json",
          "codigo": "{P39_TDD_CARREGAR_CASO_TESTE.}CarregarCasoTeste(\n    'FATURAMENTO',\n    'PEDIDO DE VENDA',\n    'PEDIDO COM DESCONTO PERCENTUAL',\n    CDSCasoTeste\n);"
        },
        {
          "tipo": "paragrafo",
          "texto": "O DataSet é criado pelo chamador — a unit apenas o popula. Caso o caso não exista ou esteja inativo, a exceção \"Caso de teste não encontrado ou inativo.\" é lançada."
        },
        {
          "tipo": "paragrafo",
          "texto": "Nesta routine o fallback está desligado (RegistroFallbackModulo(..., false)): se o módulo ou a área não existirem, o erro é \"Recurso não encontrado\" — nenhum cadastro é criado."
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
          "texto": "Necessário publicar na Tek-Store as units de codificação quealke-load do caso de teste (P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS, P39_TDD_REGISTRAR_CASO_TESTE, P39_TDD_CARREGAR_CASO_TESTE) e as units de dados P39_TDD_JSON_*."
        },
        {
          "tipo": "paragrafo",
          "texto": "O acesso ao banco dedicado é feito exclusivamente pelos métodos da unit P39_TDD_ODBC, que usam a conexão TESTE_AUTOMATIZADO_32B. Não declarar string de conexão local nas units de caso de teste."
        }
      ]
    },
    {
      "id": "secao-14",
      "titulo": "Cadastros necessários",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Módulo - registrado automaticamente pelo fallback na primeira sincronização, com a descrição informada no código (ex.: FATURAMENTO, FINANCEIRO);",
            "Área - registrada automaticamente dentro do módulo, com a descrição informada (ex.: PEDIDO DE VENDA, BORDERO);",
            "Registro único de configuração do módulo - FATURAMENTO_CONFIGURACAO ou FINANCEIRO_CONFIGURACAO, carregado automaticamente conforme o módulo do caso de teste;",
            "Histórico de execução - as tabelas HISTORICO_EXECUCAO, METRICAS_TICK_DIFF e METRICAS_ASSERTS (ver documentação do Runner)."
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "FATURAMENTO_CONFIGURACAO e FINANCEIRO_CONFIGURACAO não possuem chave primária de propósito: armazenam um único registro de configuração global por módulo. Inserir mais de um registro faz o CDSConfiguracao receber a última linha lida, e a unit passa a se comportar de forma imprevisível."
        }
      ]
    },
    {
      "id": "secao-15",
      "titulo": "Reprocessamento de um caso existente",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Ao sincronizar, casos já cadastrados exigem confirmação do usuário antes do UPDATE. A pergunta apresentada é:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "Registro para o caso de teste: <DESCRIÇÃO> já existe!\nA operação de sincronização será realizada via update. Confirmar esta operação?"
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
            "Descrição é chave de negócio. Não existem dois casos de teste com a mesma descrição dentro do mesmo módulo/área. Alterar a descrição exige alterar a unit que a referencia.",
            "Casos inativos não são removidos. Ao desativar um caso (ATIVO_CT = 'N'), ele deixa de ser carregado pelo Runner, mas continua no banco e no histórico de execuções anteriores.",
            "JSON sem aspas literais. Gravações dos blobs devem usar parâmetros (TDDCommandODBCP) e nunca QuotedStr, sob pena de corromper o JSON e fazer o caso falhar na leitura.",
            "CAMPOS_DISPONIVEIS_CT é opcional. Os casos cadastrados até hoje não utilizam esse blob; ele existe como contrato de quais campos o caso pode manipular.",
            "Comparação de asserts ainda parcial. No fluxo atual, a comparação do resultado esperado é orquestrada por P39_TDD_FAT_VALIDAR_RESULTADO, que está em evolução: a seção tempo ainda não é efetivamente comparada e a comparação da seção erro depende de correção do acesso à subseção JSON. Trate divergências de assert com ressalva até a conclusão desses ajustes.",
            "Volumes de teste. Por padrão, o módulo de Faturamento carrega todos os casos ativos da área. Ao acrescentar muitos casos, considere o impacto sobre o tempo total da execução — o Runner mede e grava esse tempo em METRICAS_TICK_DIFF."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
