import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_LOGS",
  "resumo": "Acumular e exibir diagnósticos condicionados ao debug e controlar instruções separadamente.",
  "responsabilidade": "Acumular e exibir diagnósticos condicionados ao debug e controlar instruções separadamente.",
  "problema": "Separar captura de mensagens, instruções e ponto de snapshot para persistência.",
  "fonte": "docs/assets/emDesenvolvimento/Runner/TDD_RUN_LOGS.pas",
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
      "Habilita captura/exibição de diagnósticos em RUN_LOGS.",
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
      "Run limpa por caso; FINISHED faz snapshot; lote libera. Reexecução requer atenção ao ponteiro liberado."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções conforme FExibirInstrucoes; quando é entrada do molde/processamento, executa também a orquestração descrita abaixo.",
      "Implementação no fonte, linha 9. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure DelimitadorLog(pTitulo :string);",
      "Registra separador, título e separador para agrupar mensagens da etapa.",
      "Implementação no fonte, linha 36. Operações chamadas: RegistrarLogEmModoDebug."
    ],
    [
      "procedure RegistrarLogEmModoDebug(pLog :string);",
      "Cria a lista se necessário; com debug ativo adiciona pLog + #13, sem log nativo.",
      "Implementação no fonte, linha 45. Operações chamadas: Assigned, Add, MostrarLogTexto."
    ],
    [
      "procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes :string);",
      "Exige o nome da unit e exibe as instruções apenas quando FExibirInstrucoes está ativo.",
      "Implementação no fonte, linha 59. Operações chamadas: Trim, Create, MostrarLogTexto."
    ]
  ],
  "implementacao": [
    "RegistrarLogEmModoDebug garante FLogsCasoTeste; somente com FModoDebug ativo adiciona pLog + #13 e chama MostrarLogTexto. O corpo atual também exibe a mensagem nativa; o texto antigo que dizia sem log nativo não descreve essa chamada.",
    "FExibirInstrucoes controla MostrarInstrucoesUnit independentemente do modo debug. DelimitadorLog agrupa mensagens por etapa.",
    "Run limpa a lista por tentativa; TDD_RUN_FINISHED faz o snapshot antes do INSERT. O lote libera a lista, e uso externo ao lote deve cuidar do descarte."
  ],
  "dependencias": [],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "A casca atual libera FLogsCasoTeste no encerramento sem atribuir nil. A reexecução no mesmo contexto permanece uma limitação conhecida; não declarar a suíte toda aprovada.",
    "O uses TDD_VALIDAR_RESULTADO em TDD_RUN_RUNNER ainda difere do arquivo P39_TDD_RUN_VALIDAR_RESULTADO. A citação documental resolve o assunto, mas não comprova que esse identificador está instalado no interpretador."
  ]
});
