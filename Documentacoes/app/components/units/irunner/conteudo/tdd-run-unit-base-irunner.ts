import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_UNIT_BASE_IRUNNER",
  "resumo": "Controlar lote, cursor, preparação, execução, asserts e finalização de cada tentativa.",
  "responsabilidade": "Controlar lote, cursor, preparação, execução, asserts e finalização de cada tentativa.",
  "problema": "Manter o ciclo central e propagar falhas sem misturar carga do lote com o cenário Teste.",
  "fonte": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_UNIT_BASE_IRUNNER.pas",
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
  "estados": [
    [
      "FLogsPreparacao: string",
      "Cópia textual dos logs de preparação.",
      "Preenchida por IRunner no molde; reutilizada como prefixo independente por caso."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Cria a lista de logs do lote, aplica o debug e a preparação e chama ExecutarLote. Centraliza MensagemPersonalizada.",
      "Declaração no fonte atual, linha 20. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure ExecutarLote(pDescricaoModulo,pDescricaoArea :string);",
      "Carrega e percorre o lote uma vez, libera recursos e apresenta o resumo de falhas após encerrar.",
      "Declaração no fonte atual, linha 34. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure Run;",
      "Executa o ciclo do registro corrente, trata falhas e tenta a finalização sem mover o cursor.",
      "Declaração no fonte atual, linha 97. Consulte a implementação canônica vinculada."
    ]
  ],
  "implementacao": [
    "Main transmite o debug e concentra o prefixo MensagemPersonalizada. ExecutarLote chama SetupCasosTestes uma vez, controla First/Run/Next e consolida tentados e falhos após o encerramento.",
    "Main cria FLogsCasoTeste para este lote. Run limpa a lista e copia FLogsPreparacao antes da preparação do caso; após tentar persistir, limpa novamente. ExecutarLote libera essa lista uma vez. O resumo do lote é registrado após as persistências individuais e não passa a integrar retroativamente esses históricos.",
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
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria."
  ]
});
