import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "P39_TDD_RUN_IRUNNER",
  "resumo": "Montar uma interpretação para uma única unit com entrada Teste e dois parâmetros de contexto.",
  "responsabilidade": "Montar uma interpretação para uma única unit com entrada Teste e dois parâmetros de contexto.",
  "problema": "Evitar interpretar novamente a estrutura para cada caso do lote.",
  "fonte": "docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_IRUNNER.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_IRUNNER",
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
      "AddParamsRun cria/adiciona; Executar libera no finally com Free."
    ],
    [
      "FUnitInterpretar: TStringList",
      "Código do programa gerado.",
      "Criado e preenchido por Executar; liberado no finally com Free."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções da unit conforme FExibirInstrucoes.",
      "Declaração no fonte atual, linha 7. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure SetTDDUnit(pUnit :string);",
      "Define a unit cuja entrada Teste será chamada implicitamente para cada caso.",
      "Declaração no fonte atual, linha 31. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure AddItemToList(var pList: TStringList; const pValue: string);",
      "Método de apoio utilizado por AddParamsRun.",
      "Declaração no fonte atual, linha 36. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure AddParamsRun(pParam :string);",
      "Adiciona módulo e área, nessa ordem, como literais Pascal.",
      "Declaração no fonte atual, linha 43. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure Executar;",
      "Preenche o molde e chama Interpretar uma vez, mantendo a montagem por TStringList, CommaText e Troca.",
      "Declaração no fonte atual, linha 48. Consulte a implementação canônica vinculada."
    ]
  ],
  "implementacao": [
    "SetTDDUnit define uma unit com entrada Teste. AddParamsRun recebe exatamente dois literais Pascal: módulo e área; Executar valida a configuração.",
    "Lê P39_TDD_RUN_UNIT_BASE_IRUNNER por CodificacaoUnit e preenche __USES_UNITS__, __PARAMETROS_CASO_TESTE__, __CHAMADAS_METODOS__, __MODO_DEBUG__ e __LOGS_PREPARACAO__. Chama Interpretar uma vez para o lote.",
    "Executar cria seu buffer local de preparação, guarda a referência anterior de FLogsCasoTeste e a restaura no finally. O buffer local, o auxiliar lLS, FUnitInterpretar e FParamsCasosTeste são liberados com Free. A lista do lote é criada por Main e liberada pelo lote, sem compartilhar a propriedade da lista de montagem.",
    "O diagnóstico do código gerado substitui __LOGS_PREPARACAO__ por uma string vazia para não incorporar a própria cópia recursivamente. Depois captura os logs e injeta seu conteúdo completo no programa efetivamente interpretado.",
    "A serialização usa QuotedStr e literais consecutivos, como 'linha'#13#10'outra linha', preservando aspas e quebras sem gerar centenas de operadores + em uma expressão. Cada Run recebe uma cópia textual em FLogsPreparacao.",
    "FModoDebug controla somente a exibição. FTDDUnit permanece selecionada. Não se presume memória ou thread compartilhada entre interpretações; somente o texto é transferido."
  ],
  "dependencias": [
    "P39_TDD_RUN_LOGS: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "O teste local de nova chamada recria a lista de parâmetros; não comprova reuso de AddParamsRun no mesmo contexto após Free. O comportamento nativo depende do interpretador instalado."
  ]
});
