import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_UNIT_BASE_IRUNNER",
  "resumo": "Controlar lote, cursor, preparação, execução, asserts e finalização de cada tentativa.",
  "responsabilidade": "Controlar lote, cursor, preparação, execução, asserts e finalização de cada tentativa.",
  "problema": "Manter o ciclo central e propagar falhas sem misturar carga do lote com o cenário Teste.",
  "fonte": "docs/assets/emDesenvolvimento/Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_BASE_UNIT_IRUNNER",
    "P39_TDD_RUN_UNIT_BASE_IRUNNER",
    "TDD_UNIT_BASE_IRUNNER"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 1
  },
  "estados": [],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções conforme FExibirInstrucoes; quando é entrada do molde/processamento, executa também a orquestração descrita abaixo.",
      "Implementação no fonte, linha 18. Operações chamadas: Create."
    ],
    [
      "procedure ExecutarLote(pDescricaoModulo,pDescricaoArea :string);",
      "Carrega e percorre o lote uma vez, libera recursos e apresenta o resumo de falhas após encerrar.",
      "Implementação no fonte, linha 30. Operações chamadas: SetupCasosTestes, Trim, IntToStr, DelimitadorLog, RegistrarLogEmModoDebug, Assigned."
    ],
    [
      "procedure Run;",
      "Executa o ciclo do registro corrente, trata falhas e tenta a finalização sem mover o cursor.",
      "Implementação no fonte, linha 93. Operações chamadas: DelimitadorLog, SetarCasoTeste, RegistrarTick, CallBack_AbreTela, FindKey, FieldByName."
    ]
  ],
  "implementacao": [
    "Main transmite o debug e concentra o prefixo MensagemPersonalizada. ExecutarLote chama SetupCasosTestes uma vez, controla First/Run/Next e consolida tentados e falhos após o encerramento.",
    "Run usa o registro corrente: SetarCasoTeste, ticks, callbacks, Started, Teste, CompararResultadoEsperado e AssertsOk. Uma reprovação de assert produz FALHA; SUCESSO não é atribuição incondicional.",
    "No piloto financeiro, Teste faz TEARDOWN no finally antes de retornar; ASSERTS compara as capturas feitas anteriormente por RegistrarDataSet.",
    "Run tenta RegistrarMetricas no finally quando há ID válido, antes de limpar FLogsCasoTeste. Falha ordinária pode permitir o próximo caso se a finalização passar; preparação, limpeza insegura, callbacks e persistência podem interromper.",
    "VERSAO_INCOMPATIVEL é preservado. O resumo de lote falho vem depois da limpeza e dos históricos individuais; não é automaticamente persistido em cada histórico."
  ],
  "dependencias": [
    "TDD_RUN_RUNNER: cláusula uses do fonte.",
    "__USES_UNITS__: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "A casca atual libera FLogsCasoTeste no encerramento sem atribuir nil. A reexecução no mesmo contexto permanece uma limitação conhecida; não declarar a suíte toda aprovada.",
    "O uses TDD_VALIDAR_RESULTADO em TDD_RUN_RUNNER ainda difere do arquivo P39_TDD_RUN_VALIDAR_RESULTADO. A citação documental resolve o assunto, mas não comprova que esse identificador está instalado no interpretador."
  ]
});
