import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "P39_TDD_RUN_VALIDAR_RESULTADO",
  "resumo": "Interpretar a configuração de resultado esperado e comparar erro, valor e tempo usando asserts.",
  "responsabilidade": "Interpretar a configuração de resultado esperado e comparar erro, valor e tempo usando asserts.",
  "problema": "Aplicar critérios JSON sobre capturas e métricas sem assumir o ciclo do runner ou reiniciar verificações.",
  "fonte": "docs/assets/emDesenvolvimento/P39_TDD_RUN_VALIDAR_RESULTADO.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "TDD_RUN_VALIDAR_RESULTADO",
    "TDD_VALIDAR_RESULTADO",
    "P39_TDD_VALIDAR_RESULTADO"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 8
  },
  "estados": [],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções conforme FExibirInstrucoes; quando é entrada do molde/processamento, executa também a orquestração descrita abaixo.",
      "Implementação no fonte, linha 8. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function GetOperacao(pOperacao :String): Integer;",
      "Traduz o nome da operação (\"Igual\", \"Maior\", \"Menor\") para a constante numérica correspondente (0, 1 ou 2).",
      "Implementação no fonte, linha 44. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function AplicarOperacaoNumerica(pOperacao: Integer; pValorReal, pValorEsperado: Double): Boolean;",
      "Efetua a comparação relacional (=, >, <) entre dois valores numéricos com base no código da operação.",
      "Implementação no fonte, linha 52. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function OperacaoDescricao(pOperacao :Integer) :String;",
      "Retorna o texto legível da operação (\"igual a\", \"maior que\", \"menor que\") para compor mensagens de log/assert.",
      "Implementação no fonte, linha 60. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function ConverterParaCurrency(pValor :String; pTipoCampo :String) :Double;",
      "Converte string numérica para Double, trocando ponto por vírgula para adequação ao padrão decimal do ERP.",
      "Implementação no fonte, linha 68. Operações chamadas: StrToFloat, Troca, Trim."
    ],
    [
      "procedure CompararQuantidadeErros(pJSON :String);",
      "Valida a seção \"erro\" do JSON, confrontando FErrosReais com a quantidade e operação esperadas.",
      "Implementação no fonte, linha 74. Operações chamadas: StrToInt, GetValueJson, GetOperacao, if, or, AssertsFalhou."
    ],
    [
      "procedure CompararCampoPorTipo(pTipoCampo, pValorReal, pValorEsperado :String; pOperacao :Integer; pCampoNome :String);",
      "Realiza o cast e a comparação do campo conforme seu tipo (String, Boolean, Integer, Currency, DateTime).",
      "Implementação no fonte, linha 88. Operações chamadas: OperacaoDescricao, if, or, Create, RegistrarResultado, LowerCase."
    ],
    [
      "procedure CompararValor(pJSONItem :String);",
      "Localiza o campo nos datasets capturados em FDataSets (filtrando por cds/dm) e aciona CompararCampoPorTipo.",
      "Implementação no fonte, linha 160. Operações chamadas: GetValueJson, GetValueJsonDef, GetOperacao, Trim, AssertsFalhou, if."
    ],
    [
      "procedure CompararValores(pJSON :String);",
      "Faz o parse do array JSON da seção \"valor\" e executa CompararValor para cada item configurado.",
      "Implementação no fonte, linha 222. Operações chamadas: Copy, Trim, Create, TJSONArray, ParseJSONValue, Assigned."
    ],
    [
      "procedure CompararTempo(pJSON :String);",
      "Valida a seção \"tempo\" do JSON, verificando se FTempoExecucaoMs respeita o limite na unidade informada.",
      "Implementação no fonte, linha 244. Operações chamadas: StrToInt, GetValueJson, Create, LowerCase, Pos, RegistrarResultado."
    ],
    [
      "procedure FinalizarComparacao(pValidado: Boolean);",
      "Grava no log em modo debug o resumo consolidado das asserções (AssertsResumo).",
      "Implementação no fonte, linha 266. Operações chamadas: RegistrarLogEmModoDebug."
    ],
    [
      "procedure CompararComJSON(pJSON :String);",
      "Faz o parse do objeto JSON principal, distribui as validações por seção (erro, valor, tempo) e finaliza o resumo.",
      "Implementação no fonte, linha 271. Operações chamadas: Copy, Trim, Create, ParseJSONValue, Assigned, ExecutarMetodoDeObjeto."
    ],
    [
      "procedure CompararResultadoEsperado;",
      "Ponto de entrada que busca o JSON do caso atual em CDSResultadoEsperado e dispara CompararComJSON.",
      "Implementação no fonte, linha 338. Operações chamadas: FieldByName, Trim, RegistrarLogEmModoDebug, CompararComJSON."
    ]
  ],
  "implementacao": [
    "CompararResultadoEsperado procura o ID corrente em CDSResultadoEsperado, mantém FResultadoEsperadoCaso e invoca CompararComJSON quando há configuração. Não reinicia asserts já executados.",
    "CompararComJSON aceita o wrapper resultadoEsperado preservado nos cadastros novos e o formato histórico com erro/valor/tempo na raiz. Objeto vazio gera SEM_VALIDACAO e preserva verificações explícitas; não busca mínimo remoto durante a execução.",
    "CompararValor resolve campo em FDataSets com desambiguação cds/dm, valida tipo, disponibilidade e NULL; conversão inválida ou referência ausente/ambígua não aprova zero/falso silenciosamente.",
    "Maior e Menor comparam obtido > esperado e obtido < esperado. CompararTempo usa FTempoExecucaoMs; CompararQuantidadeErros usa FErrosReais. Falhas estruturais viram AssertsFalhou; o comparador não exibe diálogos nem governa ScriptDeTestesEmExecucao."
  ],
  "dependencias": [
    "P39_TDD_RUN_ASSERTS: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "A casca atual libera FLogsCasoTeste no encerramento sem atribuir nil. A reexecução no mesmo contexto permanece uma limitação conhecida; não declarar a suíte toda aprovada.",
    "O uses TDD_VALIDAR_RESULTADO em TDD_RUN_RUNNER ainda difere do arquivo P39_TDD_RUN_VALIDAR_RESULTADO. A citação documental resolve o assunto, mas não comprova que esse identificador está instalado no interpretador."
  ]
});
