import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_FINISHED",
  "resumo": "Encerrar tempos, consolidar evidências e persistir histórico, asserts agregados e ticks.",
  "responsabilidade": "Encerrar tempos, consolidar evidências e persistir histórico, asserts agregados e ticks.",
  "problema": "Salvar evidências inclusive parciais sem atribuir persistência à casca ou ao validador.",
  "fonte": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_FINISHED.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_FINISHED",
    "P39_TDD_RUN_FINISHED",
    "TDD_FINISHED"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 4
  },
  "estados": [],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções da unit conforme FExibirInstrucoes.",
      "Declaração no fonte atual, linha 1. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure RegistrarMetricas;",
      "Insere o histórico de FHistoricoExecucao e obtém o ID retornado. Persiste os registros de FCDSMetricasTickDiff vinculados ao histórico dessa tentativa. Encerra ticks abertos e tenta gravar o histórico mesmo se esse encerramento falhar.",
      "Declaração no fonte atual, linha 23. Consulte a implementação canônica vinculada."
    ]
  ],
  "implementacao": [
    "RegistrarMetricas encerra ticks com TEMPO_FIM zero chamando RegistrarTick(1, nome). Falha nessa etapa é registrada sem abandonar imediatamente a tentativa de persistir o histórico.",
    "Consolida FMetricasAsserts a partir de AssertsTotal/Pass/Fail, FResultadoEsperadoCaso e FResultados.Text. Copia FLogsCasoTeste.Text imediatamente antes do INSERT em HISTORICO_EXECUCAO com RETURNING.",
    "Com o ID retornado, insere uma linha agregada em METRICAS_ASSERTS (etapa, duração, total/aprovados/falhos, esperado/obtido), inclusive total zero ou parciais, e linhas de METRICAS_TICK_DIFF.",
    "O campo usado é LOGS_PROCESSAMENTO_HE. Não há retry automático nem transação única garantida para pai e filhos. Falhas preservam diagnóstico anterior; indisponibilidade do banco impede garantir logs persistidos."
  ],
  "dependencias": [],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria."
  ]
});
