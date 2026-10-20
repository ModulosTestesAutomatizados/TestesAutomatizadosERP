import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "P39_TDD_RUN_LOGS",
  "resumo": "Acumular mensagens em memória e controlar a exibição por debug; instruções têm controle separado.",
  "responsabilidade": "Acumular mensagens em memória e controlar a exibição por debug; instruções têm controle separado.",
  "problema": "Separar captura de mensagens, instruções e ponto de snapshot para persistência.",
  "fonte": "docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_LOGS.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_LOGS",
    "TDD_LOGS"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 5
  },
  "estados": [
    [
      "FFlagsSetadas: Boolean",
      "Evita repetir as perguntas de debug e instruções.",
      "Inicialmente False; SetterFlags marca True depois das duas respostas. Não há chamada ao setter no fluxo local atual."
    ],
    [
      "FModoDebug: Boolean",
      "Habilita somente a exibição das mensagens; o registro em memória ocorre sempre.",
      "SetterFlags pode configurar no fluxo IRunner; a passagem ao programa interpretado depende da integração do IRunner."
    ],
    [
      "FExibirInstrucoes: Boolean",
      "Habilita instruções de Main independentemente do debug.",
      "SetterFlags pode configurar no fluxo IRunner; MostrarInstrucoesUnit consulta a flag quando uma Main é chamada."
    ],
    [
      "FLogsCasoTeste: TStringList",
      "Mensagens em memória da tentativa.",
      "Executar usa um buffer próprio para montagem. Main cria a lista do lote; Run reinicia cada caso com FLogsPreparacao; FINISHED captura; lote libera."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções da unit conforme FExibirInstrucoes.",
      "Monta as instruções e chama MostrarInstrucoesUnit; precisa ser invocada explicitamente pelo fluxo."
    ],
    [
      "procedure SetterFlags;",
      "Pergunta uma vez se deve ativar debug e exibir instruções.",
      "Quando FFlagsSetadas é False, chama P39_TDD_FILTROS.FiltroLogicoEmBoolean para FModoDebug e FExibirInstrucoes e então marca FFlagsSetadas como True. Destina-se ao IRunner; o ponto de chamada ainda não foi definido."
    ],
    [
      "procedure DelimitadorLog(pTitulo :string);",
      "Registra separador, título e separador para agrupar mensagens da etapa.",
      "Declaração no fonte atual, linha 33. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure RegistrarLog(pLog :string);",
      "Sempre adiciona pLog + #13; com debug ativo também exibe a mensagem na tela.",
      "Declaração no fonte atual, linha 42. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes :string);",
      "Exige o nome da unit e exibe as instruções apenas quando FExibirInstrucoes está ativo.",
      "Declaração no fonte atual, linha 55. Consulte a implementação canônica vinculada."
    ]
  ],
  "implementacao": [
    "P39_TDD_RUN_LOGS declara uses P39_TDD_FILTROS. O filtro referencia P39_TDD_RUN_LOGS para exibir sua Main; essa referência circular é controlada pelas chamadas explícitas, sem inicialização automática das instruções.",
    "Exibir instruções de uma unit exige FExibirInstrucoes ativo e chamada explícita à Main dessa unit. SetterFlags não é chamado automaticamente pela Main de P39_TDD_RUN_LOGS.",
    "RegistrarLog garante a lista e sempre adiciona pLog + #13. FModoDebug controla somente MostrarLogTexto(pLog, '[DEBUG]'). Sucesso e falha são registrados independentemente do debug.",
    "DelimitadorLog registra separador e título por RegistrarLog. FExibirInstrucoes controla MostrarInstrucoesUnit independentemente de FModoDebug.",
    "IRunner transfere a preparação por texto ao molde. Run limpa a lista, copia a preparação e acrescenta mensagens do caso. FINISHED captura imediatamente antes de persistir LOGS_PROCESSAMENTO_HE; Run limpa após essa tentativa e o lote libera sua lista."
  ],
  "dependencias": ["P39_TDD_FILTROS: cláusula uses do fonte para configurar FModoDebug e FExibirInstrucoes em SetterFlags."],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria."
  ]
});
