import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "P39_TDD_RUN_VALIDAR_RESULTADO",
  "resumo": "Interpretar a configuração de resultado esperado e comparar erro, valor e tempo usando asserts.",
  "responsabilidade": "Interpretar a configuração de resultado esperado e comparar erro, valor e tempo usando asserts.",
  "problema": "Aplicar critérios JSON sobre capturas e métricas sem assumir o ciclo do runner ou reiniciar verificações.",
  "fonte": "docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_VALIDAR_RESULTADO.pas",
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
      "Apresenta as instruções da unit conforme FExibirInstrucoes.",
      "Declaração no fonte atual, linha 8. Consulte a implementação canônica vinculada."
    ],
    [
      "function GetOperacao(pOperacao :String): Integer;",
      "Traduz o nome da operação (\"Igual\", \"Maior\", \"Menor\") para a constante numérica correspondente (0, 1 ou 2).",
      "Declaração no fonte atual, linha 44. Consulte a implementação canônica vinculada."
    ],
    [
      "function AplicarOperacaoNumerica(pOperacao: Integer; pValorReal, pValorEsperado: Double): Boolean;",
      "Efetua a comparação relacional (=, >, <) entre dois valores numéricos com base no código da operação.",
      "Declaração no fonte atual, linha 52. Consulte a implementação canônica vinculada."
    ],
    [
      "function OperacaoDescricao(pOperacao :Integer) :String;",
      "Retorna o texto legível da operação (\"igual a\", \"maior que\", \"menor que\") para compor mensagens de log/assert.",
      "Declaração no fonte atual, linha 60. Consulte a implementação canônica vinculada."
    ],
    [
      "function ConverterParaCurrency(pValor :String; pTipoCampo :String) :Double;",
      "Converte string numérica para Double, trocando ponto por vírgula para adequação ao padrão decimal do ERP.",
      "Declaração no fonte atual, linha 68. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure CompararQuantidadeErros(pJSON :String);",
      "Valida a seção \"erro\" do JSON, confrontando FErrosReais com a quantidade e operação esperadas.",
      "Declaração no fonte atual, linha 74. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure CompararCampoPorTipo(pTipoCampo, pValorReal, pValorEsperado :String; pOperacao :Integer; pCampoNome :String);",
      "Realiza o cast e a comparação do campo conforme seu tipo (String, Boolean, Integer, Currency, DateTime).",
      "Declaração no fonte atual, linha 88. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure CompararValor(pJSONItem :String);",
      "Localiza o campo nos datasets capturados em FDataSets (filtrando por cds/dm) e aciona CompararCampoPorTipo.",
      "Declaração no fonte atual, linha 160. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure CompararValores(pJSON :String);",
      "Faz o parse do array JSON da seção \"valor\" e executa CompararValor para cada item configurado.",
      "Declaração no fonte atual, linha 222. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure CompararTempo(pJSON :String);",
      "Valida a seção \"tempo\" do JSON, verificando se FTempoExecucaoMs respeita o limite na unidade informada.",
      "Declaração no fonte atual, linha 244. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure FinalizarComparacao(pValidado: Boolean);",
      "Grava no log em modo debug o resumo consolidado das asserções (AssertsResumo).",
      "Declaração no fonte atual, linha 266. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure CompararComJSON(pJSON :String);",
      "Faz o parse do objeto JSON principal, distribui as validações por seção (erro, valor, tempo) e finaliza o resumo.",
      "Declaração no fonte atual, linha 271. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure CompararResultadoEsperado;",
      "Ponto de entrada que busca o JSON do caso atual em CDSResultadoEsperado e dispara CompararComJSON.",
      "Declaração no fonte atual, linha 338. Consulte a implementação canônica vinculada."
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
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria."
  ]
});
