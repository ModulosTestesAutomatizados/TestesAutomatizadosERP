import { criarDocumentoUnit } from './criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  navegacao: { grupo: 'units', subgrupo: 'irunner', ordem: 4 },
  nome: 'P39_TDD_FINISHED', resumo: 'Persistência do histórico e das métricas de tempo de uma tentativa.',
  fonte: 'docs/assets/emDesenvolvimento/Runner/P39_TDD_FINISHED.pas',
  responsabilidade: 'Inserir o histórico individual, obter seu ID e gravar as linhas de tempo vinculadas a ele.',
  problema: 'Conserva o resultado e o diagnóstico de cada tentativa com vínculo entre caso, histórico e duração das etapas.',
  metodos: [
    ['procedure Main', 'Exibir instruções.', 'Encaminha o texto ao recurso MostrarInstrucoesUnit.'],
    ['procedure RegistrarMetricas', 'Persistir histórico e tempos.', 'Usa TDDScalarODBCP no INSERT de HISTORICO_EXECUCAO com RETURNING, atribui o ID a FHistoricoExecucao e percorre FCDSMetricasTickDiff para inserir METRICAS_TICK_DIFF com TDDCommandODBCP.']
  ],
  implementacao: ['Não declara globais nem uses próprios; consome os artefatos disponíveis no contexto interpretado.', 'Run copia FLogsCasoTeste para FHistoricoExecucao.LogsProcessamento antes de chamar RegistrarMetricas.', 'O loop de tempos usa First/Next do dataset de métricas, não o cursor do lote de casos.', 'O tratamento existente relança as exceções, sem repetir automaticamente os INSERTs.'],
  dependencias: ['Contexto compartilhado: P39_TDD_RUNNER e funções de P39_TDD_ODBC.', 'Chamador: Run do molde P39_TDD_BASE_UNIT_IRUNNER.'],
  limites: ['O bloco de METRICAS_ASSERTS está comentado.', 'Não há garantia no fonte de transação única envolvendo todos os INSERTs; falhas podem deixar persistência parcial.']
});
