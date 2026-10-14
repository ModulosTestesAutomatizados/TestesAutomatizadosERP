import { criarDocumentoUnit } from './criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  navegacao: { grupo: 'units', subgrupo: 'irunner' },
  nome: 'P39_TDD_BASE_UNIT_IRUNNER', resumo: 'Molde do programa interpretado: entrada, lote, tentativa e limpeza.',
  fonte: 'docs/assets/emDesenvolvimento/Runner/P39_TDD_BASE_UNIT_IRUNNER.pas',
  responsabilidade: 'Orquestrar a execução por lote depois que P39_TDD_IRUNNER preenche os marcadores do molde.',
  problema: 'Estabelece um único dono do cursor, das fases da tentativa e da limpeza compartilhada, evitando que cada Teste replique essas responsabilidades.',
  metodos: [
    ['procedure Main', 'Iniciar o lote com a configuração inserida no molde.', 'Chama ExecutarLote(__PARAMETROS_CASO_TESTE__).'],
    ['procedure ExecutarLote(pDescricaoModulo, pDescricaoArea: string)', 'Carregar, percorrer e encerrar o lote.', 'Chama SetupCasosTestes, percorre CDSCasosTestes com First/Run/Next e registra o resumo. O finally libera métricas, parâmetros, cache, casos e logs.'],
    ['procedure Run', 'Executar uma tentativa sobre o registro corrente.', 'Reinicia contexto e métricas, chama P39_TDD_STARTED, executa o bloco Teste inserido e reserva ASSERTS. Fecha tempos, copia logs e chama P39_TDD_FINISHED. Trata falhas do teste e propaga condições que interrompem o lote.']
  ],
  implementacao: ['Não declara globais próprios; consome FHistoricoExecucao, FContextoCasoTeste, FCDSMetricasTickDiff, FNomeMetodoAtual e FEtapaAtual de P39_TDD_RUNNER.', 'Consome CDSCasosTestes da unit de casos e FLogsCasoTeste de P39_TDD_LOGS.', 'Os marcadores __USES_UNITS__, __PARAMETROS_CASO_TESTE__ e __CHAMADAS_METODOS__ são preenchidos por P39_TDD_IRUNNER.', 'Falhas de Started, exceto incompatibilidade de versão, e falhas de TEARDOWN propagam. Falhas do Teste podem permitir continuidade depois da persistência.'],
  dependencias: ['Uses: P39_TDD_RUNNER e a unit de Teste inserida dinamicamente.', 'A herança transitiva disponibiliza P39_TDD_STARTED, P39_TDD_FINISHED e os recursos de preparação.'],
  limites: ['É um molde, não um programa pronto para executar isoladamente.', 'SUCESSO não comprova asserts; a etapa está reservada.', 'Uma falha de limpeza interrompe as liberações seguintes do bloco.']
});
