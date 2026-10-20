import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  nome: 'P39_TDD_FAT_PROCESSAMENTO_CARGA', tipoArtefato: 'processamento',
  resumo: 'Configurar a exibição de instruções e executar o lote FATURAMENTO/CARGA.',
  responsabilidade: 'Selecionar o caso TDD_FAT_CARGA no IRunner e passar módulo e área do lote.',
  problema: 'Fornecer uma entrada única para executar o piloto de carga com a opção de exibir instruções.',
  fonte: 'docs/assets/emDesenvolvimento/carga/P39_TDD_FAT_PROCESSAMENTO_CARGA.pas',
  estado: 'em-desenvolvimento',
  navegacao: { grupo: 'units', subgrupo: 'irunner', ordem: 10 },
  metodos: [
    ['procedure Main;', 'Perguntar se exibe instruções e iniciar o lote.', 'Chama P39_TDD_FILTROS para FExibirInstrucoes, apresenta as próprias instruções conforme a flag e chama ExecutarIRunner.'],
    ['procedure ExecutarIRunner;', 'Configurar e executar o IRunner.', "Seleciona TDD_FAT_CARGA, passa 'FATURAMENTO' e 'CARGA' e chama Executar uma vez."]
  ],
  implementacao: [
    "O filtro 'Exibir Instruções?' começa em N e atribui a escolha ao estado FExibirInstrucoes de P39_TDD_RUN_LOGS.",
    'ExecutarIRunner informa ao IRunner o nome do caso, o módulo e a área antes de iniciar o lote.'
  ],
  dependencias: [
    'P39_TDD_RUN_IRUNNER: cláusula uses do fonte.',
    'P39_TDD_FILTROS: cláusula uses do fonte; configura FExibirInstrucoes.'
  ],
  limites: [
    'Fonte e documentação em desenvolvimento; build do portal não comprova execução no ERP.',
    'P39_TDD_FILTROS e TDD_FAT_CARGA precisam estar disponíveis ao interpretador para executar este processamento.'
  ]
});
