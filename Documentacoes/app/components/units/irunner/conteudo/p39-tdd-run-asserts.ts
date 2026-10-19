import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "P39_TDD_RUN_ASSERTS",
  "resumo": "Acumular resultados, contadores de asserts, erros reais e capturas de datasets do caso.",
  "responsabilidade": "Acumular resultados, contadores de asserts, erros reais e capturas de datasets do caso.",
  "problema": "Manter evidências depois do TEARDOWN, sem depender das telas já fechadas.",
  "fonte": "docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_ASSERTS.pas",
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
      "Apresenta as instruções conforme FExibirInstrucoes; quando é entrada do molde/processamento, executa também a orquestração descrita abaixo.",
      "Implementação no fonte, linha 18. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure InicializarAcumulo;",
      "Garante a instanciação das listas globais (FFalhas, FDataSets e FResultados) antes do uso.",
      "Implementação no fonte, linha 88. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure RegistrarDataSet(pDataSetName :String);",
      "Localiza o par \"DataSet|DM\", valida se está ativo/preenchido e salva uma cópia dos dados em FDataSets.",
      "Implementação no fonte, linha 106. Operações chamadas: DMCriadoPeloNome, CorteApos, Assigned, Create, FindComponent, CorteAte."
    ],
    [
      "function RegistrarResultado(pPassou :Boolean; pMsg :String) :Boolean;",
      "Incrementa os totalizadores (Total, Pass ou Fail), alimenta as listas de histórico/falhas e registra log debug.",
      "Implementação no fonte, linha 140. Operações chamadas: Add, RegistrarLogEmModoDebug."
    ],
    [
      "procedure RegistrarErroReal(pDescricao :String);",
      "Incrementa o contador FErrosReais e grava a descrição do erro no log em modo debug.",
      "Implementação no fonte, linha 163. Operações chamadas: RegistrarLogEmModoDebug."
    ],
    [
      "function AssertsPassou(pDescricao :String) :Boolean;",
      "Registra diretamente um resultado positivo (PASS) com a mensagem informada.",
      "Implementação no fonte, linha 171. Operações chamadas: RegistrarResultado."
    ],
    [
      "function AssertsFalhou(pDescricao, pDetalhe :String) :Boolean;",
      "Registra diretamente uma falha (FAIL) concatenando a descrição e o detalhe do problema.",
      "Implementação no fonte, linha 176. Operações chamadas: RegistrarResultado."
    ],
    [
      "function AssertVerdadeiro(pCondicao :Boolean; pDescricao :String) :Boolean;",
      "Valida se a condição informada é verdadeira (True).",
      "Implementação no fonte, linha 181. Operações chamadas: RegistrarResultado."
    ],
    [
      "function AssertFalso(pCondicao :Boolean; pDescricao :String) :Boolean;",
      "Valida se a condição informada é falsa (False).",
      "Implementação no fonte, linha 190. Operações chamadas: RegistrarResultado."
    ],
    [
      "function AssertIgual(pEsperado, pObtido, pDescricao :String) :Boolean;",
      "Compara duas strings e valida se o valor obtido é exatamente igual ao esperado.",
      "Implementação no fonte, linha 199. Operações chamadas: RegistrarResultado."
    ],
    [
      "function AssertIgualInteiro(pEsperado, pObtido :Integer; pDescricao :String) :Boolean;",
      "Compara dois números inteiros e valida se são iguais.",
      "Implementação no fonte, linha 209. Operações chamadas: RegistrarResultado, IntToStr."
    ],
    [
      "function Arredondar(pValor :Currency; pCasas :Integer) :Currency;",
      "Função auxiliar que arredonda um valor Currency para a quantidade de casas decimais especificada.",
      "Implementação no fonte, linha 219. Operações chamadas: Round."
    ],
    [
      "function AssertIgualCurrency(pEsperado, pObtido :Currency; pCasas :Integer; pDescricao :String) :Boolean;",
      "Compara dois valores monetários (Currency) aplicando arredondamento prévio conforme pCasas.",
      "Implementação no fonte, linha 230. Operações chamadas: Arredondar, RegistrarResultado, CurrToStr."
    ],
    [
      "function AssertListaVazia(pLista :TStringList; pDescricao :String) :Boolean;",
      "Valida se a TStringList informada não está instanciada (nil) ou não possui elementos (Count = 0).",
      "Implementação no fonte, linha 242. Operações chamadas: if, or, RegistrarResultado, IntToStr."
    ],
    [
      "function AssertContem(pTexto, pSubstring, pDescricao :String) :Boolean;",
      "Verifica (sem diferenciar maiúsculas/minúsculas) se pSubstring está contida em pTexto.",
      "Implementação no fonte, linha 252. Operações chamadas: Pos, UpperCase, RegistrarResultado."
    ],
    [
      "procedure AssertsZerar;",
      "Reinicia contadores, limpa listas de resultados/falhas e libera da memória os TClientDataSet clonados.",
      "Implementação no fonte, linha 264. Operações chamadas: Delete."
    ],
    [
      "function AssertsTotal :Integer;",
      "Funções de leitura que retornam os respectivos contadores acumulados na execução.",
      "Implementação no fonte, linha 282. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function AssertsPass :Integer;",
      "Retorna o contador de aprovações.",
      "Implementação no fonte, linha 287. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function AssertsFail :Integer;",
      "Retorna o contador de reprovações.",
      "Implementação no fonte, linha 292. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function AssertsOk :Boolean;",
      "Retorna True caso nenhuma falha tenha sido registrada (FAssertsFail = 0).",
      "Implementação no fonte, linha 297. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function AssertsResumo :String;",
      "Gera uma string formatada com o placar de execução (total, pass, fail) e a listagem detalhada das falhas.",
      "Implementação no fonte, linha 302. Atribuições e fluxo locais seguem o contrato descrito acima."
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
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "A casca atual libera FLogsCasoTeste no encerramento sem atribuir nil. A reexecução no mesmo contexto permanece uma limitação conhecida; não declarar a suíte toda aprovada.",
    "O uses TDD_VALIDAR_RESULTADO em TDD_RUN_RUNNER ainda difere do arquivo P39_TDD_RUN_VALIDAR_RESULTADO. A citação documental resolve o assunto, mas não comprova que esse identificador está instalado no interpretador."
  ]
});
