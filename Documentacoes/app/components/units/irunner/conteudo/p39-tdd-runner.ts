import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  navegacao: { grupo: 'units', subgrupo: 'irunner', ordem: 2 },
  nome: 'P39_TDD_RUNNER', resumo: 'Carga do lote, contexto individual e medição de tempo das etapas.',
  fonte: 'docs/assets/emDesenvolvimento/Runner/P39_TDD_RUNNER.pas',
  responsabilidade: 'Carregar os casos do módulo/área, reiniciar o contexto de uma tentativa e registrar os tempos usados pela casca.',
  problema: 'Centraliza histórico e instrumentação para que Started e Teste trabalhem com o registro corrente, sem duplicar o controle do lote.',
  estados: [
    ['FHistoricoExecucao: THistoricoExecucao', 'ID, versão, requisito, status, erro, etapa e logs', 'Reiniciado em SetarCasoTeste e persistido em P39_TDD_FINISHED'],
    ['FContextoCasoTeste: TContextoCasoTeste', 'Descrições de módulo, área e caso corrente', 'Configurado no setup e atualizado por tentativa'],
    ['FCDSMetricasTickDiff: TClientDataSet', 'Início, fim, total e nome de cada etapa', 'Recriado por tentativa e liberado no lote'],
    ['FNomeMetodoAtual: string / FEtapaAtual: integer', 'Identificar a fase e a etapa da falha', 'Reiniciados por caso; incrementados/atualizados durante a execução'],
    ['FMetricasAsserts: TMetricasAsserts', 'Estrutura reservada para resultados de asserts', 'Persistência comentada; não tratar como validação concluída']
  ],
  metodos: [
    ['procedure Main', 'Exibir instruções.', 'Usa P39_TDD_LOGS.MostrarInstrucoesUnit.'],
    ['function SetupCasosTestes(const pDescricaoModulo, pDescricaoArea: string): Boolean', 'Carregar os casos ativos uma vez para o lote.', 'Valida módulo/área, chama SetModulo e SetArea, limpa datasets existentes e chama CarregarCasosTeste. Erros são relançados com contexto.'],
    ['procedure SetarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste: string)', 'Reiniciar o contexto individual.', 'Zera histórico, método e etapa, lê o ID/requisito corrente e redefine as descrições. Não carrega casos nem move o cursor.'],
    ['procedure InicializarMetricasTickDiff', 'Criar o dataset de tempos da tentativa.', 'Libera a estrutura anterior, define campos e índice NOME_METODO e desabilita controles e LogChanges.'],
    ['procedure LiberarMetricasTickDiff', 'Liberar o dataset de métricas.', 'Executa Free quando Assigned e registra diagnóstico em modo debug.'],
    ['procedure RegistrarTick(pPontoTick: integer; pNomeMetodo: string)', 'Registrar início (0) ou fim (1).', 'Normaliza o nome em maiúsculas. O início rejeita duplicidade e incrementa a etapa; o fim localiza o registro aberto e calcula TickDiff. Pontos inválidos ou ausência de início propagam erro.'],
    ['function PreencherComZeros(pValor: Cardinal; pTamanho: Integer): string', 'Preencher a representação numérica à esquerda.', 'Converte o valor para texto e acrescenta zeros até atingir o tamanho solicitado.'],
    ['function FormatarTickDiff(pTempoMs: Cardinal): string', 'Formatar a duração.', 'Decompõe milissegundos em horas, minutos, segundos e milissegundos, usando PreencherComZeros.']
  ],
  implementacao: ['A casca P39_TDD_BASE_UNIT_IRUNNER chama setup/contexto/métricas nas fases correspondentes.', 'P39_TDD_STARTED e P39_TDD_FINISHED compartilham os artefatos de contexto e persistência.', 'Run e ExecutarLote estão no molde, não declarados neste arquivo.'],
  dependencias: ['Uses diretos: P39_TDD_ODBC, P39_TDD_LOGS, P39_TDD_STARTED e P39_TDD_FINISHED.', 'P39_TDD_CASOS_DE_TESTE chega pela herança transitiva de P39_TDD_STARTED.'],
  limites: ['Métricas de asserts existem como estrutura reservada; TDD_ASSERTS permanece pendente.', 'Free sem atribuição de nil no fonte não comprova chamadas repetidas seguras no host.']
});
