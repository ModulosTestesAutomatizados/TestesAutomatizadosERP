import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_RUNNER",
  "resumo": "Preparar lote e contexto corrente e medir tempos relativos por tentativa.",
  "responsabilidade": "Preparar lote e contexto corrente e medir tempos relativos por tentativa.",
  "problema": "Separar os records de execução e os ticks do cenário e da persistência.",
  "fonte": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_RUNNER.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_RUNNER",
    "P39_TDD_RUN_RUNNER",
    "TDD_RUNNER"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 2
  },
  "estados": [
    [
      "FHistoricoExecucao: THistoricoExecucao",
      "Record com identidade, versão, status, causa e logs para o histórico.",
      "SetarCasoTeste reinicia; ciclo altera; FINISHED persiste e recebe a PK."
    ],
    [
      "FMetricasAsserts: TMetricasAsserts",
      "Record agregado de contadores, etapa, tempo e evidências.",
      "Reset no caso; preenchido e persistido em FINISHED."
    ],
    [
      "FCDSMetricasTickDiff: TClientDataSet",
      "Ticks por NOME_METODO, início/fim/total/etapa.",
      "Inicializado por tentativa; FINISHED encerra/persiste; lote libera."
    ],
    [
      "FTempoBaseTick: Double",
      "Base bruta Double para calcular ticks relativos.",
      "Definida ao inicializar métricas; referência para todos os ticks da tentativa."
    ],
    [
      "FNomeMetodoAtual: string",
      "Método/etapa corrente para diagnóstico.",
      "Reset na preparação; alterado em STARTED, IRUNNER, ASSERTS, TEARDOWN e FINISHED."
    ],
    [
      "FEtapaAtual: integer",
      "Etapa numérica do caso.",
      "Reset na preparação; consumida em históricos e métricas."
    ],
    [
      "FContextoCasoTeste: TContextoCasoTeste",
      "Record de descrições módulo/área/caso.",
      "Lote define contexto; caso reinicia e lê DESCRICAO corrente."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções da unit conforme FExibirInstrucoes.",
      "Declaração no fonte atual, linha 56. Consulte a implementação canônica vinculada."
    ],
    [
      "function SetupCasosTestes(const pDescricaoModulo, pDescricaoArea :string) :Boolean;",
      "Carrega os casos ativos do módulo/área uma vez antes do loop da casca.",
      "Declaração no fonte atual, linha 95. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure SetarCasoTeste(pDescricaoModulo, pDescricaoArea :string);",
      "Reinicia histórico, erros e etapa; prepara o contexto do registro corrente sem mover o cursor.",
      "Declaração no fonte atual, linha 152. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure LiberarMetricasTickDiff;",
      "Operação LiberarMetricasTickDiff do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Declaração no fonte atual, linha 195. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure InicializarMetricasTickDiff;",
      "Cria os tempos de uma tentativa e libera seu CDS pelos métodos existentes.",
      "Declaração no fonte atual, linha 205. Consulte a implementação canônica vinculada."
    ],
    [
      "function PreencherComZeros(pValor :Cardinal; pTamanho :Integer) :string;",
      "Operação PreencherComZeros do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Declaração no fonte atual, linha 232. Consulte a implementação canônica vinculada."
    ],
    [
      "function FormatarTickDiff(pTempoMs :Cardinal) :string;",
      "Métodos de apoio à formatação das durações.",
      "Declaração no fonte atual, linha 239. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure RegistrarTick(pPontoTick :integer; pNomeMetodo :string);",
      "Registra tempos relativos à tentativa; zero no fim identifica uma métrica aberta. Trata a virada do contador e valida o limite Integer antes de gravar o CDS.",
      "Declaração no fonte atual, linha 255. Consulte a implementação canônica vinculada."
    ]
  ],
  "implementacao": [
    "SetupCasosTestes usa SetModulo/SetArea de P39_TDD_CASOS_DE_TESTE, limpa registros anteriores com First/IsEmpty/Delete e carrega o lote. SetarCasoTeste recebe somente módulo/área, reinicia estado e lê ID, REQUISITOVERSAO e DESCRICAO sem avançar o cursor.",
    "O reset inclui FHistoricoExecucao, FMetricasAsserts, FContextoCasoTeste, FNomeMetodoAtual, FEtapaAtual e AssertsZerar. InicializarMetricasTickDiff define o CDS indexado por NOME_METODO.",
    "RegistrarTick lê GetTickCount em Double, subtrai FTempoBaseTick, soma 4294967296.0 na volta do contador e rejeita relativo maior que 2147483646 antes da conversão. Acrescenta 1 porque zero representa fim em aberto.",
    "FTempoExecucaoMs recebe a duração da etapa IRUNNER antes de ASSERTS. RegistrarTick(1, nome) também encerra as métricas pendentes em RegistrarMetricas; não existe API EncerrarTemposPendentes."
  ],
  "dependencias": [
    "TDD_RUN_STARTED: cláusula uses do fonte.",
    "TDD_RUN_APPLICATION: cláusula uses do fonte.",
    "P39_TDD_RUN_VALIDAR_RESULTADO: cláusula uses do fonte.",
    "TDD_RUN_FINISHED: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria."
  ]
});
