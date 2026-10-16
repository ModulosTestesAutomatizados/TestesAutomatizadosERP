import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  tipoArtefato: 'processamento',
  nome: 'P39_TDD_FIN_PROCESSAMENTO', navegacao: { grupo: 'units', subgrupo: 'irunner', ordem: 6 },
  resumo: 'Entrada que seleciona o piloto financeiro e inicia o lote de IRunner.Executar.',
  fonte: 'docs/assets/emDesenvolvimento/Runner/P39_TDD_FIN_PROCESSAMENTO.pas',
  responsabilidade: 'Definir a unit de cenário e os literais de módulo e área antes de chamar P39_TDD_IRUNNER.Executar.',
  problema: 'Manter a configuração do processamento separada do orquestrador, do molde de execução e do caso financeiro.',
  estado: 'em-desenvolvimento',
  metodos: [
    ['procedure Main', 'Apresentar instruções e iniciar o lote.', 'Desabilita FExibirInstrucoes no contexto compartilhado, prepara o texto, chama MostrarInstrucoesUnit, ativa FModoDebug e chama ExecutarIRunner.'],
    ['procedure ExecutarIRunner', 'Configurar a execução financeira.', 'Define P39_TDD_FIN_PAGAMENTO_RECEBIMENTO em SetTDDUnit, adiciona os dois literais FINANCEIRO com AddParamsRun e chama Executar.']
  ],
  implementacao: ['Não declara estado global próprio. FExibirInstrucoes e FModoDebug pertencem ao contexto compartilhado de logs.', 'O processamento não registra métodos de teste individualmente nem percorre os datasets de casos.'],
  dependencias: ['Uses direto: P39_TDD_IRUNNER.', 'P39_TDD_FIN_PAGAMENTO_RECEBIMENTO é a seleção dinâmica do cenário; o molde prepara o registro antes de chamar Teste.'],
  limites: ['O fonte não restaura os controles de logs após a chamada.', 'A documentação descreve a configuração disponível, sem declarar homologação ou comparação funcional por asserts.']
});
