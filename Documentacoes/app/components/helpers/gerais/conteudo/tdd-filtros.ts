import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  nome: 'TDD_FILTROS',
  aliases: ['P39_TDD_FILTROS'],
  resumo: 'Ler um filtro lógico e atribuir sua escolha a uma flag Boolean.',
  responsabilidade: 'Oferecer aos processamentos uma entrada lógica para configurar flags antes da execução.',
  problema: 'Evitar valores Boolean fixos nas entradas de sincronização e dos lotes IRunner.',
  fonte: 'docs/assets/emDesenvolvimento/TDD_FILTROS.pas',
  estado: 'em-desenvolvimento',
  navegacao: { grupo: 'helpers', subgrupo: 'gerais', ordem: 2 },
  metodos: [
    ['procedure Main;', 'Apresentar as instruções da unit.', 'Chama MostrarInstrucoesUnit; a exibição depende de FExibirInstrucoes.'],
    ['function ConverterFiltroLogicoEmBoolean(pValorFiltroString :String) :Boolean;', 'Converter a resposta do filtro em Boolean.', "Compara UpperCase(Trim(valor)) com QuotedStr('S'); os demais valores resultam em False."],
    ['procedure SetarFiltroLogicoEmBoolean(pNomeDoFiltro :String; var pBooleanRecebeFiltro :Boolean);', 'Atribuir a resposta à flag recebida por referência.', 'Lê Filtro(pNomeDoFiltro) e chama ConverterFiltroLogicoEmBoolean.'],
    ['procedure FiltroLogicoEmBoolean(pNomeDoFiltro :String; var pBooleanRecebeFiltro :Boolean);', 'Apresentar o filtro e configurar a flag.', 'Cria um TClientDataSet, inclui filtro lógico com valor inicial N, executa o diálogo, atribui a resposta e libera o dataset no finally.']
  ],
  implementacao: [
    'Cada chamada apresenta um filtro lógico independente com valor inicial N. Passe o nome exibido e uma variável Boolean do processamento.',
    'O processamento de sincronização, fora do IRunner, chama o filtro diretamente para FSincRemoto e FExibirInstrucoes. Sincronizar apresenta uma segunda pergunta para FSincRemoto antes de registrar os casos; as duas perguntas são intencionais.',
    'No fluxo IRunner, TDD_RUN_LOGS oferece SetterFlags para configurar FModoDebug e FExibirInstrucoes uma vez. O ponto de chamada no fluxo ainda precisa ser definido; a existência do método não significa que ele já seja executado.',
    'O fonte e a página canônica se chamam TDD_FILTROS. P39_TDD_FILTROS é referência da sincronização e alias de consulta; a rota /units/p39-tdd-filtros redireciona para esta página.',
    'A unit não declara estado global próprio. A variável recebida por referência pertence à unit consumidora ou a uma dependência dela.'
  ],
  dependencias: [
    'P39_TDD_RUN_LOGS: cláusula uses para MostrarInstrucoesUnit.',
    'APIs do host: EstruturaDeFiltrosDinamicos, IncluirFiltroDinamico, ExecutarFiltroDinamico e Filtro.'
  ],
  limites: [
    'Fonte local em desenvolvimento; o portal e o build não comprovam instalação nem execução no ERP.',
    "O código atual compara a resposta com QuotedStr('S'); a forma retornada por Filtro no ambiente de destino precisa ser conferida em execução.",
    'O valor inicial N é aplicado a cada chamada; opções antes fixadas em True passam a exigir escolha explícita.'
  ]
});
