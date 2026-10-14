import type { IDocumento } from '../../models/documentacao.ts';
// Conteúdo migrado do arquivo histórico; apresentação compartilhada.
export default {
  "slug": "documento-fatura",
  "categoria": "documentos",
  "titulo": "Documento Fatura",
  "resumo": "Fluxo legado de Pedido de Venda, componentes de tela e exemplos de casos.",
  "estado": "legado",
  "fontes": [
    {
      "caminho": "Documentacoes/app/arquivo/html/documento-fatura/index.html"
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
          "texto": "As units DOCUMENTO_FATURA são o caso de uso mais completo da suíte de testes automatizados: implementam um pedido de venda virtual, inteiramente na tela real do ERP. O roteiro percorre o formulário de pedido de venda (o mesmo que o usuário utiliza), preenche os campos a partir do JSON do caso de teste, inclui itens e grava o documento."
        },
        {
          "tipo": "paragrafo",
          "texto": "O objetivo é não simular a funcionalidade: o teste aciona os mesmos componentes, eventos e DataSets da aplicação, de modo que qualquer regressão no cadastro de pedidos de venda é detectada como falha real do teste."
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Este processamento é exclusivo para uso de testes dentro da TekSystem e não pode ser executado pelo servidor. A rotina Main da unit faz as duas validações e aborta com exceção caso contrário: if ExecutandoNoServidor then raise exception... if CodigoComoClienteTekSystem <> 1000 then raise exception..."
        },
        {
          "tipo": "paragrafo",
          "texto": "Ao final da inclusão de cada documento, a unit monta uma observação automática no campo OBSERVACAO_DOCFAT contendo o texto \"Documento gerado automaticamente via rotina de testes automatizados\" e a descrição do caso de teste — o que permite rastrear, no próprio cadastro, a origem do documento."
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
              "P39_TDD_FAT_DOCUMENTO_FATURA",
              "Unit principal. Monta o documento de venda: cliente, tabela de preço, condição, prazo, desconto, financeiro, entrega, faturamento e frete"
            ],
            [
              "P39_TDD_FAT_DOCUMENTO_FATURA_ITENS",
              "Montagem e inclusão dos itens do documento, com detalhamento de variação, cor e acabamento"
            ],
            [
              "P39_TDD_DOCUMENTO_FATURA_SQL",
              "SQLs de seleção de clientes, produtos e pessoas"
            ],
            [
              "P39_TDD_FAT_DOCUMENTO_FATURA_JSON",
              "Carregamento e validação do JSON de contexto do caso de teste"
            ],
            [
              "P39_TDD_FAT_PEDIDO_VENDA",
              "Unit de caso de teste que o IRUNNER executa: define o formulário e registra os métodos Setup e Teste"
            ],
            [
              "P39_TDD_FAT_VALIDAR_RESULTADO",
              "Comparação do documento gerado contra o resultado esperado"
            ],
            [
              "P39_TDD_ASSERTS",
              "Acumuladores PASS / FAIL utilizados nas verificações"
            ],
            [
              "P39_TDD_CASOS_DE_TESTE",
              "DataSets de casos de teste e de configuração do módulo Faturamento"
            ]
          ]
        }
      ]
    },
    {
      "id": "secao-4",
      "titulo": "Componentes do ERP Utilizados",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A unit localiza, por nome, o formulário e todos os DataSets do cadastro de pedido de venda. Os nomes são constantes, definidas no topo da unit e podem ser ajustados conforme a versão do cadastro:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Constante",
            "Valor",
            "Uso"
          ],
          "linhas": [
            [
              "FCadastro",
              "'FCadPedidoVenda'",
              "Nome do formulário (atribuído pela unit de caso de teste)"
            ],
            [
              "FDM",
              "'DMCadPedidoVenda'",
              "Nome do data module"
            ],
            [
              "FRGradeamento",
              "'FRGradeamento'",
              "Frame de detalhamento de itens"
            ],
            [
              "FGradeItens",
              "'grdItem'",
              "Grade de itens (usada para foco antes da inclusão)"
            ],
            [
              "FBotaoIncluir",
              "'BotaoIncluir'",
              "Botão que dispara BotaoIncluirClick"
            ],
            [
              "FBotaoGravar",
              "'BotaoGravar'",
              "Botão que grava o documento"
            ]
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "DataSets registrados na unit de asserts (para conferência campo a campo):"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "CDSCadastro      -> CLIENTE_DOCFAT, UNIDFABRIL_DOCFAT, VLRDESCONTOPARCIAL_DOCFAT,\n                    FINANCEIRA_DOCFAT, BANCO_DOCFAT, ENTREGARMERCADORIA_DOCFAT,\n                    OBSERVACAO_DOCFAT, TRANSACAO_DOCFAT\nCDSItem          -> ITEM_DOCITEM, QTDECHAPAS_DOCITEM, VLRUNITARIOBRUTO_DOCITEM\nCDSPedido        -> TABELA_DOCPED, TABELACONDICAO_DOCPED, CONDICAOPRAZO_DOCPED,\n                    DTPREVISAOFATURAMENTO_DOCPED, DIASENTREGA_DOCPED, DTVENDA_DOCPED,\n                    CAMPANHA_DOCPED, DTPROMESSAENTREGA_DOCPED, PARCERIA_DOCPED,\n                    FRETEEMBUTIDO_DOCPED, FRETE_MANUAL_DOCPED, PERCFRETE_DOCPED,\n                    VALORFRETE_DOCPED\nCDSFiscal        -> TIPOFRETE_DOCFISCAL, TIPOFRETECT_DOCFISCAL,\n                    PERCFRETEAUTONOMO_DOCFISCAL, PERCFRETECT_DOCFISCAL\nCDSCondicaoTabela, CDSCondicaoDetalhe, CDSTabela,\nCDSDescontoPrincipal, CDSItemDesconto, CDSPrazos"
        },
        {
          "tipo": "paragrafo",
          "texto": "Cada DataSet é registrado no formato <NomeDoCDS>|<NomeDoDM>, que é o formato usado por CompararValor para localizar o componente em tempo de comparação."
        }
      ]
    },
    {
      "id": "secao-5",
      "titulo": "Configuração do Módulo",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A unit P39_TDD_CASOS_DE_TESTE carrega, para o módulo FATURAMENTO, o registro único da tabela FATURAMENTO_CONFIGURACAO. Os campos mais relevantes para a geração de documentos são:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Campo",
            "Uso no teste"
          ],
          "linhas": [
            [
              "PESSOA_GERAL_FATCONFIG",
              "Cliente usado quando o caso de teste não informa tag_cliente nem cliente_docfat"
            ],
            [
              "PEDIDO_VENDA_FATCONFIG",
              "Transação de venda padrão, sobrescrevendo a informada no JSON"
            ],
            [
              "QTD_FIXA_ITEM_FATCONFIG",
              "Quantidade fixa do item (quando não informada no JSON)"
            ],
            [
              "QTD_MAX_ITEM_FATCONFIG",
              "Limite superior para sorteio aleatório da quantidade"
            ],
            [
              "VALOR_ITEM_FIXO_FATCONFIG",
              "Valor unitário fixo do item"
            ],
            [
              "VLR_MAX_ITEM_FATCONFIG",
              "Limite superior para sorteio aleatório do valor unitário"
            ]
          ]
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Quando não há valor fixo configurado, quantidade e valor unitário são sorteados aleatoriamente (Random), com piso de 1 para quantidade e 10 para valor. Isso é útil para variar a massa de teste, mas exige que o resultado esperado use operadores tolerantes (Maior / Menor) em campos derivados (valor bruto, descontos, etc.)."
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
          "texto": "O roteiro de execução é:"
        },
        {
          "tipo": "lista",
          "itens": [
            "A unit de caso de teste (P39_TDD_FAT_PEDIDO_VENDA) é a entrada: ela define o formulário e o data module, e registra os métodos Setup e Teste para o IRUNNER executar;",
            "Setup chama Setup_Inicializar, que carrega os casos de teste do módulo Faturamento / área Pedido de Venda e abre o formulário de pedido de venda;",
            "Teste chama Teste_Executar, que percorre todos os casos de teste ativos carregados;",
            "Para cada caso: define o contexto JSON, inclui um documento por cliente encontrado e marca o caso como executado."
          ]
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "uses P39_TDD_FAT_DOCUMENTO_FATURA;\n\nconst cArea = 'PEDIDO DE VENDA';\n\nprocedure Setup;\nbegin\n  FCadastro := 'FCadPedidoVenda';\n  FDM       := 'DMCadPedidoVenda';\n  SetArea(cArea);\n  Setup_Inicializar;\nend;\n\nprocedure Teste;\nbegin\n  Teste_Executar;\nend;"
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Teste_Executar percorre todos os casos de teste da área, não apenas um. Para executar um caso específico, filtre-o por DESCRICAO no CDSCasosTestes ou utilize a carga individual pela unit P39_TDD_CARREGAR_CASO_TESTE."
        }
      ]
    },
    {
      "id": "secao-8",
      "titulo": "Montagem do documento",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Para cada cliente encontrado, a rotina _IncluiDocumento executa a sequência de preenchimento e gravação:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "BotaoIncluirClick  (novo documento)\n ├─ _DadosPrincipais    (cliente, unidade fabril, tabela, desconto e itens)\n ├─ _Financeiro         (financeira e banco)\n ├─ _DadosParaEntrega   (datas, campanha, parceria, dias de entrega)\n ├─ _DadosFaturamento   (transação)\n └─ _InformacoesFrete   (frete manual / embutido e frete fiscal)\nBotaoGravar.Click"
        },
        {
          "tipo": "paragrafo",
          "texto": "A ordem importa: os itens são incluídos dentro de _DadosPrincipais, e o frete é processado por último porque depende dos valores calculados com os itens já lançados."
        }
      ]
    },
    {
      "id": "secao-9",
      "titulo": "Seleção de clientes",
      "nivel": 4,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A origem dos clientes segue uma ordem de prioridade:"
        },
        {
          "tipo": "lista",
          "itens": [
            "tag_cliente > 0 - seleciona todas as pessoas com a característica informada (valor 'S');",
            "cliente_docfat > 0 - seleciona uma pessoa específica;",
            "caso contrário, usa PESSOA_GERAL_FATCONFIG da configuração do módulo."
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "Se nenhum cliente for encontrado, a execução é interrompida com a exceção \"Não há clientes para inclusão.\"."
        }
      ]
    },
    {
      "id": "secao-10",
      "titulo": "Inclusão de itens",
      "nivel": 4,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A unit P39_TDD_FAT_DOCUMENTO_FATURA_ITENS resolve os itens em três caminhos:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Ordem",
            "Condição",
            "Comportamento"
          ],
          "linhas": [
            [
              "1",
              "Array item.itens preenchido",
              "Inclui exatamente os itens informados no JSON"
            ],
            [
              "2",
              "item.tag_prodcomum > 0",
              "Busca produtos pela tag e inclui os detalhamentos encontrados"
            ],
            [
              "3",
              "Nenhum dos anteriores",
              "Registra assert de falha \"Itens Inválidos - Itens não existentes!\""
            ]
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "Itens com variação, cor ou acabamento são incluídos através do método Frame.IncluiDetalhamentoItem. Itens sem detalhamento são lançados diretamente no CDSItem (quantidade de chapas e valor unitário bruto)."
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Hierarquia de valores por item: o valor do próprio item prevalece; se não informado, usa-se o valor do bloco item; se ainda assim for zero, o valor é sorteado a partir da configuração do módulo. A mesma lógica vale para a quantidade."
        }
      ]
    },
    {
      "id": "secao-11",
      "titulo": "Descontos, tabela de preço e prazo",
      "nivel": 4,
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "A tabela de preço é localizada pela descrição primeiro e, se não encontrada, pelo código — ambas em memória, via FindKey no CDSTabela;",
            "A condição de pagamento tem o mesmo tratamento, com fallback de descrição para código;",
            "O prazo, quando a condição não bloqueia, pode ser informado manualmente no formato \"7/14/21\", gerando um registro por prazo em CDSPrazos;",
            "O desconto principal aceita múltiplos percentuais separados por vírgula (\"10.5, 5.3, 3.1\"), e é ignorado quando a tabela de preço bloqueia desconto manual ou não permite desconto — nesse caso o motivo é registrado no log."
          ]
        }
      ]
    },
    {
      "id": "secao-12",
      "titulo": "Transação de faturamento",
      "nivel": 4,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A resolução da transação segue a ordem: valor do JSON → PEDIDO_VENDA_FATCONFIG (se maior que zero) → parâmetro do sistema TransacaoVenda lido da seção de parâmetros. Observação: quando o JSON informa transacao_docfat = 0, o valor não é substituído — a variável permanece zero."
        }
      ]
    },
    {
      "id": "secao-13",
      "titulo": "Contexto e validação do caso de teste",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A rotina SetCasoTeste(pCasoTeste) é executada a cada iteração de Teste_Executar e extrai três blocos do JSON:"
        },
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "FJSONDOC      := GetObjectJson(pCasoTeste, 'documento');\nFJSONITEMCONF := GetObjectJson(pCasoTeste, 'item');\nFJSONITENS    := GetArrayJsonOrEmpty(FJSONITEMCONF, 'itens');"
        },
        {
          "tipo": "paragrafo",
          "texto": "Em seguida, o caso é validado por ValidarCasoTeste, que acumula as pendências em FMsgCasoTesteInvalido e define a flag FCasoTesteInvalido. Havendo pendência, uma mensagem interna é enviada ao usuário e o documento não é incluído — mas a execução da suíte continua."
        },
        {
          "tipo": "paragrafo",
          "texto": "O bloco parametros, se presente, é aplicado por _AjustarParametros, que fecha e reabre o formulário de pedido de venda (ver documentação de Parâmetro)."
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "A flag ScriptDeTestesEmExecucao é ligada durante a inclusão de itens e desligada no TearDown. Ela existe para que a rotina que dispara o processamento não seja reentrada (executar teste dentro do teste)."
        }
      ]
    },
    {
      "id": "secao-14",
      "titulo": "Comparação do resultado esperado",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "A comparação do documento gerado contra o RESULTADO_ESPERADO_CT é orquestrada por P39_TDD_FAT_VALIDAR_RESULTADO, que usa os DataSets registrados pela unit principal:"
        },
        {
          "tipo": "lista",
          "itens": [
            "Cronometro_Iniciar zera os contadores de assert e marca o instante inicial;",
            "Para cada item da seção valor, a rotina CompararValor percorre todos os DataSets registrados, localizando pelo campo informado e executando o assert correspondente;",
            "Campos ftString só aceitam a operação Igual — o uso de Maior / Menor gera assert de falha;",
            "Campos não existentes em determinado DataSet são simplesmente ignorados (Continue), o que permite descrever o mesmo campo em DataSets distintos;",
            "FinalizarComparacao registra no log o resultado da comparação e o resumo dos asserts."
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "Erros na inclusão de itens não interrompem a execução: são registrados via AssertsFalhou com a mensagem da exceção, e o CDSItem tem o registro cancelado antes de seguir para o próximo item."
        }
      ]
    },
    {
      "id": "secao-15",
      "titulo": "Tags reconhecidas no JSON do documento",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "tabela",
          "colunas": [
            "Tag",
            "Destino"
          ],
          "linhas": [
            [
              "cliente_docfat",
              "CDSCadastro.CLIENTE_DOCFAT"
            ],
            [
              "unidfabril_docfat",
              "CDSCadastro.UNIDFABRIL_DOCFAT"
            ],
            [
              "tag_cliente",
              "Característica usada na seleção de clientes"
            ],
            [
              "descricao_tabela_preco / tabela_preco",
              "CDSPedido.TABELA_DOCPED"
            ],
            [
              "descricao_condicao / tabelacondicao_docped",
              "CDSPedido.TABELACONDICAO_DOCPED"
            ],
            [
              "descricao_prazo / condicaoprazo_docped",
              "CDSPedido.CONDICAOPRAZO_DOCPED"
            ],
            [
              "prazo_manual",
              "CDSPrazos (um registro por prazo)"
            ],
            [
              "percdesc_docdescprinc",
              "CDSDescontoPrincipal"
            ],
            [
              "vlrdescontoparcial_docfat",
              "CDSCadastro.VLRDESCONTOPARCIAL_DOCFAT"
            ],
            [
              "financeira_docfat",
              "CDSCadastro.FINANCEIRA_DOCFAT"
            ],
            [
              "banco_docfat",
              "CDSCadastro.BANCO_DOCFAT"
            ],
            [
              "entregarmercadoria_docfat",
              "CDSCadastro.ENTREGARMERCADORIA_DOCFAT"
            ],
            [
              "dtvenda_docped",
              "CDSPedido.DTVENDA_DOCPED"
            ],
            [
              "dtpromessaentrega_docped",
              "CDSPedido.DTPROMESSAENTREGA_DOCPED"
            ],
            [
              "dtprevisaofaturamento_docped",
              "CDSPedido.DTPREVISAOFATURAMENTO_DOCPED"
            ],
            [
              "diasentrega_docped",
              "CDSPedido.DIASENTREGA_DOCPED"
            ],
            [
              "campanha_docped",
              "CDSPedido.CAMPANHA_DOCPED"
            ],
            [
              "parceria_docped",
              "CDSPedido.PARCERIA_DOCPED"
            ],
            [
              "transacao_docfat",
              "CDSCadastro.TRANSACAO_DOCFAT"
            ],
            [
              "frete_manual_docped",
              "CDSPedido.FRETE_MANUAL_DOCPED"
            ],
            [
              "freteembutido_docped",
              "CDSPedido.FRETEEMBUTIDO_DOCPED"
            ],
            [
              "valorfrete_docped",
              "CDSPedido.VALORFRETE_DOCPED"
            ],
            [
              "percfrete_docped",
              "CDSPedido.PERCFRETE_DOCPED"
            ]
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "Tags do bloco item:"
        },
        {
          "tipo": "tabela",
          "colunas": [
            "Tag",
            "Uso"
          ],
          "linhas": [
            [
              "tag_prodcomum",
              "Tag de produto para seleção automática de itens"
            ],
            [
              "quantidade",
              "Quantidade padrão (por item ou para toda a seleção)"
            ],
            [
              "valor",
              "Valor unitário padrão"
            ],
            [
              "desconto",
              "Desconto padrão"
            ],
            [
              "itens",
              "Array de itens explícitos"
            ]
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "No array itens, cada item aceita item, variacao, cor, acabamento, quantidade, valor e desconto. O desconto é tratado como texto, podendo informar múltiplos valores separados por vírgula."
        }
      ]
    },
    {
      "id": "secao-16",
      "titulo": "Instalação e configurações",
      "nivel": 2,
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Necessário publicar na Tek-Store as units P39_TDD_FAT_DOCUMENTO_FATURA, P39_TDD_FAT_DOCUMENTO_FATURA_ITENS, P39_TDD_DOCUMENTO_FATURA_SQL, P39_TDD_FAT_DOCUMENTO_FATURA_JSON, P39_TDD_FAT_PEDIDO_VENDA e P39_TDD_FAT_VALIDAR_RESULTADO."
        },
        {
          "tipo": "paragrafo",
          "texto": "A execução deve ser feita em uma instância do ERP com o usuário cliente TekSystem (código 1000), interativamente, e não pelo servidor."
        }
      ]
    },
    {
      "id": "secao-17",
      "titulo": "Cadastros e dados necessários",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Cadastro de pedido de venda publicado e com os componentes estes: FCadPedidoVenda, DMCadPedidoVenda, FRGradeamento, grdItem, BotaoIncluir e BotaoGravar;",
            "DataSets CDSCadastro, CDSItem, CDSFiscal, CDSPedido, CDSCondicaoTabela, CDSCondicaoDetalhe, CDSDescontoPrincipal, CDSItemDesconto, CDSTabela e CDSPrazos no data module do cadastro;",
            "Módulo FATURAMENTO e área PEDIDO DE VENDA registrados no banco dedicado, com ao menos um caso de teste ativo (ATIVO_CT = 'S');",
            "Registro em FATURAMENTO_CONFIGURACAO - define cliente padrão, transação e regras de sorteio de quantidade e valor dos itens;",
            "Clientes - ao menos um com a característica informada em tag_cliente, ou o cliente em cliente_docfat, ou o cliente geral da configuração;",
            "Itens, cores e acabamentos ativos, quando o caso usa o array item.itens."
          ]
        }
      ]
    },
    {
      "id": "secao-18",
      "titulo": "Exemplo de caso de teste completo",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "json",
          "codigo": "{\n  \"documento\": {\n    \"cliente_docfat\": 1125,\n    \"descricao_tabela_preco\": \"TABELA DE PREÇOS FOB 2023\",\n    \"descricao_condicao\": \"CONDIÇÃO GERAL\",\n    \"descricao_prazo\": \"7/14/21 DIAS\",\n    \"percdesc_docdescprinc\": \"10.5, 5.3, 3.1\",\n    \"frete_manual_docped\": \"S\",\n    \"valorfrete_docped\": 1.1,\n    \"entregarmercadoria_docfat\": \"S\"\n  },\n  \"item\": {\n    \"itens\": [\n      { \"item\": 2, \"cor\": 23, \"quantidade\": 2, \"valor\": 355.55, \"desconto\": 1.1 },\n      { \"item\": 7, \"cor\": 14, \"quantidade\": 3, \"valor\": 456.99,\n        \"desconto\": \"1.1, 2.1, 2.3, 3.5\" }\n    ]\n  },\n  \"parametros\": {\n    \"OrdemImpressaoItemNF\": 0\n  }\n}"
        },
        {
          "tipo": "aviso",
          "severidade": "info",
          "texto": "Nos percentuais de desconto, use ponto decimal nos valores e vírgula como separador de lista. A unit converte o ponto em vírgula antes de gravar no Currency do ERP."
        }
      ]
    },
    {
      "id": "secao-19",
      "titulo": "Observações importantes",
      "nivel": 2,
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Teste com efeito real no banco. Diferente dos demais casos, este cria documentos de venda efetivos. Execute sempre em base de testes.",
            "Rastreabilidade. Todo documento gerado recebe a observação \"Documento gerado automaticamente via rotina de testes automatizados\" acompanhada da descrição do caso de teste, o que permite identificar e limpar os registros gerados.",
            "Massa de teste aleatória. Sem valor e quantidade fixos, os itens usam Random. Isso torna a suíte não determinística - asserts de igualdade exata em campos derivados ficam instáveis. Prefira operadores Maior / Menor nesses campos, ou configure valores fixos em FATURAMENTO_CONFIGURACAO.",
            "Janela do ERP visível. O formulário é aberto com FormCadastro.Show e permanece visível durante a execução. Qualquer caixa de mensagem de erro do ERP interrompe o fluxo.",
            "Falhas não interrompem a suíte. Erros na inclusão de um item e casos de teste inválidos são registrados (assert de falha ou mensagem interna) sem abortar os demais casos. Consequentemente, o log é a evidência do que de fato aconteceu: o status SUCESSO gravado no histórico pode coexistir com asserts de falha.",
            "Configuração não carregada. Se FATURAMENTO_CONFIGURACAO estiver vazia, a unit envia mensagem interna \"Configuração Não Carregada.\" e não gera documento, sem interromper a suíte.",
            "Validação de asserts em evolução. A rotina CompararResultadoEsperado ainda contém chamadas de depuração (ShowMessage e MostrarCDS), e a comparação da seção tempo está desativada. A comparação da seção erro depende de correção do acesso à subseção JSON. Trate o resultado das asserts com ressalva até a conclusão desses ajustes.",
            "Nomenclatura de componente. As constantes FCadastro, FDM, FItemMenu (fixado em 'Emisso1') e os nomes dos DataSets precisam existir exatamente como declarados. Qualquer renomeação no cadastro do ERP exige atualização destas constantes.",
            "Cobertura de itens por tag. Quando o caso usa tag_prodcomum, a SQL BuscaDadosProdutos filtra apenas itens, variações, cores e acabamentos com STATUS = 0 e VALOR_ITEMTAG = 'S' - itens inativos simplesmente não entram no documento, sem gerar erro."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
