import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "P39_TDD_RUN_ASSERTS",
  "resumo": "Acumular resultados, contadores de asserts, erros reais e capturas de datasets do caso.",
  "responsabilidade": "Acumular resultados, contadores de asserts, erros reais e capturas de datasets do caso.",
  "problema": "Manter evidências depois do TEARDOWN, sem depender das telas já fechadas.",
  "fonte": "docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_ASSERTS.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_ASSERTS",
    "TDD_RUN_ASSERTS",
    "TDD_ASSERTS"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 6
  },
  "estados": [
    [
      "FAssertsTotal: Integer",
      "Total de asserções acumuladas.",
      "RegistrarResultado incrementa; AssertsZerar reinicia por caso."
    ],
    [
      "FAssertsPass: Integer",
      "Quantidade aprovada.",
      "RegistrarResultado incrementa no PASS; AssertsZerar reinicia."
    ],
    [
      "FAssertsFail: Integer",
      "Quantidade reprovada que define AssertsOk.",
      "RegistrarResultado incrementa no FAIL; AssertsZerar reinicia."
    ],
    [
      "FFalhas: TStringList",
      "Lista somente das reprovações.",
      "Criada sob demanda; limpa no reset; liberada pelo lote."
    ],
    [
      "FDataSets: TStringList",
      "Clones de datasets por chave DataSet|DM.",
      "RegistrarDataSet captura/substitui; validador consome; AssertsZerar libera clones."
    ],
    [
      "FResultados: TStringList",
      "Lista completa de PASS e FAIL disponíveis para evidência.",
      "Acumulada pelos asserts; copiada para ResultadoObtido em FINISHED; reset por caso."
    ],
    [
      "FErrosReais: Integer",
      "Erros registrados explicitamente para comparação erro.quantidade.",
      "RegistrarErroReal incrementa; reset por caso. Não captura automaticamente toda exceção."
    ],
    [
      "FTempoExecucaoMs: Double",
      "Tempo IRUNNER em milissegundos para comparação.",
      "Preenchido pela casca antes de ASSERTS; reset pelo ciclo."
    ],
    [
      "FResultadoEsperadoCaso: String",
      "Configuração JSON da tentativa usada pelo comparador e histórico.",
      "Reset antes do registro seguinte; preenchida por SetarCasoTeste/CompararResultadoEsperado."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções da unit conforme FExibirInstrucoes.",
      "Declaração no fonte atual, linha 18. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure InicializarAcumulo;",
      "Garante a instanciação das listas globais (FFalhas, FDataSets e FResultados) antes do uso.",
      "Declaração no fonte atual, linha 88. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure RegistrarDataSet(pDataSetName :String);",
      "Localiza o par \"DataSet|DM\", valida se está ativo/preenchido e salva uma cópia dos dados em FDataSets.",
      "Declaração no fonte atual, linha 106. Consulte a implementação canônica vinculada."
    ],
    [
      "function RegistrarResultado(pPassou :Boolean; pMsg :String) :Boolean;",
      "Incrementa os totalizadores (Total, Pass ou Fail), alimenta as listas de histórico/falhas e registra log debug.",
      "Declaração no fonte atual, linha 140. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure RegistrarErroReal(pDescricao :String);",
      "Incrementa o contador FErrosReais e grava a descrição do erro no log em modo debug.",
      "Declaração no fonte atual, linha 163. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertsPassou(pDescricao :String) :Boolean;",
      "Registra diretamente um resultado positivo (PASS) com a mensagem informada.",
      "Declaração no fonte atual, linha 171. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertsFalhou(pDescricao, pDetalhe :String) :Boolean;",
      "Registra diretamente uma falha (FAIL) concatenando a descrição e o detalhe do problema.",
      "Declaração no fonte atual, linha 176. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertVerdadeiro(pCondicao :Boolean; pDescricao :String) :Boolean;",
      "Valida se a condição informada é verdadeira (True).",
      "Declaração no fonte atual, linha 181. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertFalso(pCondicao :Boolean; pDescricao :String) :Boolean;",
      "Valida se a condição informada é falsa (False).",
      "Declaração no fonte atual, linha 190. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertIgual(pEsperado, pObtido, pDescricao :String) :Boolean;",
      "Compara duas strings e valida se o valor obtido é exatamente igual ao esperado.",
      "Declaração no fonte atual, linha 199. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertIgualInteiro(pEsperado, pObtido :Integer; pDescricao :String) :Boolean;",
      "Compara dois números inteiros e valida se são iguais.",
      "Declaração no fonte atual, linha 209. Consulte a implementação canônica vinculada."
    ],
    [
      "function Arredondar(pValor :Currency; pCasas :Integer) :Currency;",
      "Função auxiliar que arredonda um valor Currency para a quantidade de casas decimais especificada.",
      "Declaração no fonte atual, linha 219. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertIgualCurrency(pEsperado, pObtido :Currency; pCasas :Integer; pDescricao :String) :Boolean;",
      "Compara dois valores monetários (Currency) aplicando arredondamento prévio conforme pCasas.",
      "Declaração no fonte atual, linha 230. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertListaVazia(pLista :TStringList; pDescricao :String) :Boolean;",
      "Valida se a TStringList informada não está instanciada (nil) ou não possui elementos (Count = 0).",
      "Declaração no fonte atual, linha 242. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertContem(pTexto, pSubstring, pDescricao :String) :Boolean;",
      "Verifica (sem diferenciar maiúsculas/minúsculas) se pSubstring está contida em pTexto.",
      "Declaração no fonte atual, linha 252. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure AssertsZerar;",
      "Reinicia contadores, limpa listas de resultados/falhas e libera da memória os TClientDataSet clonados.",
      "Declaração no fonte atual, linha 264. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertsTotal :Integer;",
      "Funções de leitura que retornam os respectivos contadores acumulados na execução.",
      "Declaração no fonte atual, linha 282. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertsPass :Integer;",
      "Retorna o contador de aprovações.",
      "Declaração no fonte atual, linha 287. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertsFail :Integer;",
      "Retorna o contador de reprovações.",
      "Declaração no fonte atual, linha 292. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertsOk :Boolean;",
      "Retorna True caso nenhuma falha tenha sido registrada (FAssertsFail = 0).",
      "Declaração no fonte atual, linha 297. Consulte a implementação canônica vinculada."
    ],
    [
      "function AssertsResumo :String;",
      "Gera uma string formatada com o placar de execução (total, pass, fail) e a listagem detalhada das falhas.",
      "Declaração no fonte atual, linha 302. Consulte a implementação canônica vinculada."
    ]
  ],
  "implementacao": [
    "InicializarAcumulo cria listas; RegistrarResultado incrementa total/pass/fail, FResultados para PASS e FAIL e FFalhas somente para falhas. Retorna Boolean sem lançar apenas por reprovação; Run consulta AssertsOk.",
    "RegistrarDataSet recebe DataSet|DM, valida módulo/dataset ativo e preenchido, clona Data e RecNo e guarda a cópia em FDataSets. A última captura da mesma chave substitui a anterior; não edita nem libera o componente original.",
    "RegistrarErroReal incrementa FErrosReais explicitamente. Exceções do runner não viram automaticamente erro esperado. AssertsZerar reinicia contadores/listas e libera clones no ciclo do caso.",
    "FResultadoEsperadoCaso e FTempoExecucaoMs dão contexto ao validador e à persistência. Comparação posterior ao TEARDOWN usa capturas e não telas fechadas."
  ],
  "dependencias": [
    "P39_TDD_CASOS_DE_TESTE: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria."
  ]
});
