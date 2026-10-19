import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_IRUNNER",
  "resumo": "Montar uma interpretação para uma única unit com entrada Teste e dois parâmetros de contexto.",
  "responsabilidade": "Montar uma interpretação para uma única unit com entrada Teste e dois parâmetros de contexto.",
  "problema": "Evitar interpretar novamente a estrutura para cada caso do lote.",
  "fonte": "docs/assets/emDesenvolvimento/Runner/TDD_RUN_IRUNNER.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_IRUNNER",
    "P39_TDD_RUN_IRUNNER",
    "TDD_IRUNNER"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 0
  },
  "estados": [
    [
      "FTDDUnit: string",
      "Nome da única unit selecionada.",
      "Definido por SetTDDUnit; permanece selecionado após Executar."
    ],
    [
      "FParamsCasosTeste: TStringList",
      "Literais de módulo/área.",
      "AddParamsRun cria/adiciona; Executar libera e atribui nil no finally."
    ],
    [
      "FUnitInterpretar: TStringList",
      "Código do programa gerado.",
      "Criado e preenchido em Executar; liberado e recebe nil no finally."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções conforme FExibirInstrucoes; quando é entrada do molde/processamento, executa também a orquestração descrita abaixo.",
      "Implementação no fonte, linha 7. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure SetTDDUnit(pUnit :string);",
      "Define a unit cuja entrada Teste será chamada implicitamente para cada caso.",
      "Implementação no fonte, linha 31. Operações chamadas: Trim."
    ],
    [
      "procedure AddItemToList(var pList: TStringList; const pValue: string);",
      "Método de apoio utilizado por AddParamsRun.",
      "Implementação no fonte, linha 36. Operações chamadas: Assigned, Add."
    ],
    [
      "procedure AddParamsRun(pParam :string);",
      "Adiciona módulo e área, nessa ordem, como literais Pascal.",
      "Implementação no fonte, linha 43. Operações chamadas: AddItemToList."
    ],
    [
      "procedure Executar;",
      "Preenche o molde e chama Interpretar uma vez, mantendo a montagem por TStringList, CommaText e Troca.",
      "Implementação no fonte, linha 48. Operações chamadas: Create, Assigned, Add, CodificacaoUnit, Troca, iif."
    ]
  ],
  "implementacao": [
    "SetTDDUnit define uma unit; AddParamsRun deve receber exatamente dois literais Pascal, módulo e área. Executar valida essa configuração antes de montar o programa.",
    "Lê CodificacaoUnit('TDD_RUN_UNIT_BASE_IRUNNER'), preenche __USES_UNITS__, __PARAMETROS_CASO_TESTE__, __CHAMADAS_METODOS__ e __MODO_DEBUG__, e chama Interpretar uma vez.",
    "FParamsCasosTeste e FUnitInterpretar são liberadas e recebem nil no finally; FTDDUnit mantém a seleção. O debug externo é transmitido ao programa gerado; não presumir globais comuns entre interpretações."
  ],
  "dependencias": [
    "TDD_RUN_LOGS: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "A casca atual libera FLogsCasoTeste no encerramento sem atribuir nil. A reexecução no mesmo contexto permanece uma limitação conhecida; não declarar a suíte toda aprovada.",
    "O uses TDD_VALIDAR_RESULTADO em TDD_RUN_RUNNER ainda difere do arquivo P39_TDD_RUN_VALIDAR_RESULTADO. A citação documental resolve o assunto, mas não comprova que esse identificador está instalado no interpretador."
  ]
});
