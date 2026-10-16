import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_LOGS",
  "resumo": "Acumular mensagens em memória e controlar a exibição por debug; instruções têm controle separado.",
  "responsabilidade": "Acumular mensagens em memória e controlar a exibição por debug; instruções têm controle separado.",
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
      "Run limpa por caso; FINISHED faz snapshot; lote libera. Reexecução requer atenção ao ponteiro liberado."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções da unit conforme FExibirInstrucoes.",
      "Implementação no fonte atual, linha 6."
    ],
    [
      "procedure DelimitadorLog(pTitulo :string);",
      "Registra separador, título e separador para agrupar mensagens da etapa.",
      "Implementação no fonte atual, linha 33."
    ],
    [
      "procedure RegistrarLog(pLog :string);",
      "Sempre adiciona pLog + #13; com debug ativo também exibe a mensagem na tela.",
      "Implementação no fonte atual, linha 42."
    ],
    [
      "procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes :string);",
      "Exige o nome da unit e exibe as instruções apenas quando FExibirInstrucoes está ativo.",
      "Implementação no fonte atual, linha 55."
    ]
  ],
  "implementacao": [
    "RegistrarLog garante FLogsCasoTeste e sempre adiciona pLog + #13. FModoDebug controla somente a exibição por MostrarLogTexto.",
    "DelimitadorLog usa RegistrarLog para registrar separador/título. FExibirInstrucoes controla MostrarInstrucoesUnit independentemente do debug.",
    "Run limpa mensagens por caso; FINISHED faz snapshot antes do INSERT; lote libera a lista. O corpo atual de LOGS substituiu RegistrarLogEmModoDebug por RegistrarLog."
  ],
  "dependencias": [],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "A casca atual libera FLogsCasoTeste no encerramento sem atribuir nil. A reexecução no mesmo contexto permanece uma limitação conhecida; não declarar a suíte toda aprovada.",
    "O uses TDD_VALIDAR_RESULTADO em TDD_RUN_RUNNER ainda difere do arquivo P39_TDD_RUN_VALIDAR_RESULTADO. A citação documental resolve o assunto, mas não comprova que esse identificador está instalado no interpretador.",
    "RegistrarLogEmModoDebug foi substituído por RegistrarLog(pLog :string), sem parâmetro para controlar captura: FModoDebug decide apenas a exibição. Ainda há chamadas antigas em TDD_RUN_IRUNNER, TDD_RUN_RUNNER, TDD_RUN_UNIT_BASE_IRUNNER, TDD_RUN_STARTED, TDD_RUN_FINISHED, P39_TDD_RUN_ASSERTS, P39_TDD_RUN_VALIDAR_RESULTADO, TDD_FIN_FINANCEIRO e no exemplo EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR. Essas chamadas exigem atualização no trabalho Pascal; esta documentação não certifica compilação desse conjunto no ERP."
  ]
});
