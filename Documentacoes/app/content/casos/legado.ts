import type { IDocumento } from '../../models/documentacao.ts';
export default {
  slug: 'casos-legado', categoria: 'documentos', titulo: 'Casos de teste — legado',
  resumo: 'Inventário dos cenários e entradas do contrato anterior, com as divergências dos fontes locais.',
  navegacao: { grupo: 'casos', subgrupo: 'legado', ordem: 0 }, estado: 'legado',
  fontes: [
    'docs/assets/casosTestesFinanceiro/processamentos/InclusaoDeDuplicatas.pas',
    ...['P39_TDD_FIN_CONTAS_RECEBER', 'P39_TDD_FIN_CONTAS_PAGAR', 'P39_TDD_FIN_INCLUIR_BORDERO_PAGAMENTO', 'P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO'].map(pN => `docs/assets/casosTestesFinanceiro/${pN}.pas`),
    'docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA.pas',
    'docs/assets/casosTestesFaturamento/P39_TDD_FAT_PEDIDO_VENDA.pas',
    'docs/MAPEAMENTO_AST_USES_UNITS/casos-legado/entrada.md'
  ].map(pCaminho => ({ caminho: pCaminho })),
  secoes: [
    { id: 'contrato', titulo: 'Entrada do contrato anterior', blocos: [
      { tipo: 'paragrafo', texto: 'O processamento InclusaoDeDuplicatas solicita o filtro Tipo de Teste e encaminha uma das quatro opções a uma chamada explícita de unit. O inventário abaixo representa essas opções presentes no fonte; a execução desse processamento não passa por TDD_IRUNNER.Executar nem pelo cursor do molde novo.' },
      { tipo: 'mermaid', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/casos-legado/entrada.md', titulo: 'Seleção manual do cenário financeiro anterior' }
    ] },
    { id: 'financeiro', titulo: 'Casos financeiros referenciados', blocos: [
      { tipo: 'tabela', colunas: ['Opção do filtro', 'Entrada referenciada pelo processamento', 'Evidência local'], linhas: [
        ['0 · Duplicata a receber', 'P39_TDD_FIN_CONTAS_RECEBER.CriarContasaReceber', 'A chamada existe no processamento; o arquivo local da unit contém o modelo de geração de documentos de faturamento.'],
        ['1 · Duplicata a pagar', 'P39_TDD_FIN_CONTAS_PAGAR.CriarContasAPagar', 'A chamada existe no processamento; o arquivo local não declara essa entrada.'],
        ['2 · Borderô de pagamento', 'P39_TDD_FIN_INCLUIR_BORDERO_PAGAMENTO.IncluirBorderoPagamento', 'A chamada existe no processamento; o arquivo local contém Main e rotinas de documentos, sem essa entrada.'],
        ['3 · Borderô de recebimento', 'P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO.IncluirBorderoRecebimento', 'A chamada existe no processamento; o arquivo local contém o mesmo modelo de faturamento.']
      ] },
      { tipo: 'aviso', severidade: 'warning', texto: 'Os nomes financeiros de alguns arquivos não correspondem ao conteúdo disponível no repositório. Esta lista registra as chamadas do processamento e sua divergência com os arquivos locais; não comprova que essas entradas existam na variante instalada no ERP.' }
    ] },
    { id: 'faturamento', titulo: 'Cenários presentes nos fontes de faturamento', blocos: [
      { tipo: 'paragrafo', texto: 'Os arquivos locais P39_TDD_FAT_DOCUMENTO_FATURA e P39_TDD_FAT_PEDIDO_VENDA contêm Main, ConfirmarFiltros e cinco caminhos selecionáveis. Main exige execução cliente e o código interno TekSystem 1000, prepara FAT_CONFIG_TESTE e abre o callback antes de processar as escolhas.' },
      { tipo: 'lista', itens: [
        'Pedido de venda: IncluiPedidoVenda.',
        'Pedido de venda para NFCe: IncluiPedidoVendaNFCe.',
        'Assistência técnica: IncluiAssistencia.',
        'Pedido de consignação: IncluiConsignacao.',
        'Conferência e liberação de documentos: ConfereLiberaDocumentos.'
      ] },
      { tipo: 'paragrafo', texto: 'A referência Documento Fatura preserva a descrição anterior dessa área. A implementação disponível nestes arquivos deve ser avaliada pelo seu conteúdo, pois o nome do arquivo não identifica sozinho o cenário que Main executa.' }
    ] },
    { id: 'migracao', titulo: 'Relação com o IRunner', blocos: [
      { tipo: 'paragrafo', texto: 'O fluxo novo configura uma única unit com entrada Teste, carrega os registros ativos por módulo/área e reutiliza o contexto por tentativa. O piloto financeiro executa as quatro operações dentro de Teste para cada registro; não seleciona uma delas com o filtro Tipo de Teste deste processamento.' },
      { tipo: 'paragrafo', texto: 'Cadastro de registros, Parâmetros do ERP e suas units são dependências utilizadas pelo IRunner. A identificação de legado desta página se aplica ao contrato de execução anterior, e não a essas dependências compartilhadas.' }
    ] }
  ]
} satisfies IDocumento;
