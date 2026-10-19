import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_LOGS",
  "resumo": "Acumular mensagens em memória e controlar a exibição por debug; instruções têm controle separado.",
  "responsabilidade": "Acumular mensagens em memória e controlar a exibição por debug; instruções têm controle separado.",
  "problema": "Separar captura de mensagens, instruções e ponto de snapshot para persistência.",
  "fonte": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_LOGS.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_LOGS",
    "P39_TDD_RUN_LOGS",
    "TDD_LOGS"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 5
  },
  "estados": [
    [
      "FModoDebug: Boolean",
      "Habilita somente a exibição das mensagens; o registro em memória ocorre sempre.",
      "Configurado pelo processamento e transmitido ao programa gerado."
    ],
    [
      "FExibirInstrucoes: Boolean",
      "Habilita instruções de Main independentemente do debug.",
      "Configurado pelo chamador; consultado em MostrarInstrucoesUnit."
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
      "Declaração no fonte atual, linha 6. Consulte a implementação canônica vinculada."
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
    "RegistrarLog garante a lista e sempre adiciona pLog + #13. FModoDebug controla somente MostrarLogTexto(pLog, '[DEBUG]'). Sucesso e falha são registrados independentemente do debug.",
    "DelimitadorLog registra separador e título por RegistrarLog. FExibirInstrucoes controla MostrarInstrucoesUnit independentemente de FModoDebug.",
    "IRunner transfere a preparação por texto ao molde. Run limpa a lista, copia a preparação e acrescenta mensagens do caso. FINISHED captura imediatamente antes de persistir LOGS_PROCESSAMENTO_HE; Run limpa após essa tentativa e o lote libera sua lista."
  ],
  "dependencias": [],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria."
  ]
});
