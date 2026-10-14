import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  navegacao: { grupo: 'casos', ordem: 0 },
  nome: 'P39_TDD_FAT_PEDIDO_VENDA',
  resumo: 'Entrada do caso de Pedido de Venda no faturamento refatorado, com configuração de tela e delegação ao núcleo.',
  fonte: 'docs/assets/casosTestesFaturamento/P39_TDD_FAT_PEDIDO_VENDA.pas',
  responsabilidade: 'Definir a área PEDIDO DE VENDA, o formulário FCadPedidoVenda e o módulo de dados DMCadPedidoVenda, e delegar a execução a P39_TDD_FAT_DOCUMENTO_FATURA.',
  problema: 'Separar a configuração específica do Pedido de Venda das camadas compartilhadas de Documento de Fatura.',
  jsonBase: {
    fontes: [
      'docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA.pas',
      'docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA_JSON.pas',
      'docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA_ITENS.pas',
      'docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_PRINCIPAIS.pas'
    ],
    exemplo: {
      documento: { tag_cliente: 0, cliente_docfat: 0, unidfabril_docfat: 0, tabela_preco: 0, tabelacondicao_docped: 0, condicaoprazo_docped: 0 },
      item: { tag_prodcomum: 0, quantidade: 1, valor: 100, itens: [{ item: 0, variacao: 0, cor: 0, acabamento: 0, quantidade: 1, valor: 100, desconto: '0' }] },
      parametros: {}
    },
    campos: [
      ['documento', 'objeto', 'Tags de cliente e dados principais do documento.', 'SetCasoTeste separa este objeto e as camadas consultam as tags por Valor*TagDoc.'],
      ['documento.tag_cliente / cliente_docfat', 'inteiros', 'Selecionar clientes por tag ou por código.', 'CarregarClientes prioriza tag positiva, depois cliente positivo e por último a configuração; não localizar clientes interrompe a inclusão.'],
      ['documento.unidfabril_docfat', 'inteiro', 'Unidade fabril do documento.', 'Consumida pela camada de dados principais conforme o comportamento de configuração.'],
      ['documento.tabela_preco / tabelacondicao_docped / condicaoprazo_docped', 'inteiros', 'Tabela de preço, condição e prazo.', 'Selecionam os dados principais; as rotinas possuem alternativas por descrição e configuração.'],
      ['item', 'objeto', 'Configuração comum de inclusão dos itens.', 'É extraído para FJSON.Item; as rotinas usam Valor*TagItemConfig.'],
      ['item.tag_prodcomum', 'inteiro', 'Seleção de produtos por tag.', 'Usada quando a lista itens está vazia; lista não vazia tem prioridade.'],
      ['item.quantidade / valor', 'números', 'Valores padrão para os itens.', 'Substituem valores zero de cada item; se continuarem zero, o fonte pode gerar quantidade ou valor aleatórios.'],
      ['item.itens', 'lista de objetos', 'Itens específicos do pedido.', 'A lista não vazia ativa inclusão específica; item com código zero é ignorado, sem retornar ao caminho por tag.'],
      ['item.itens[].item', 'inteiro', 'Código do produto específico.', 'Deve corresponder a um produto da base; zero pula este item.'],
      ['item.itens[].variacao / cor / acabamento', 'inteiros', 'Características do produto.', 'Alimentam a estrutura intermediária de itens.'],
      ['item.itens[].quantidade / valor / desconto', 'números / texto', 'Condições do item específico.', 'Quantidade e valor têm prioridade sobre os padrões; desconto é lido como texto, preservando o formato esperado pelo fonte.'],
      ['parametros', 'objeto', 'Configurações de ERP para o caso.', 'Objeto não vazio chama _AjustarParametros, libera a tela e pode executar Relogar; o finally reabre o formulário.']
    ],
    observacoes: [
      'Preencha os identificadores zero com códigos válidos para a base utilizada. A lista de exemplo contém um produto ainda não preenchido; ele será ignorado pelo fonte até receber um código.',
      'Para usar produtos por tag, esvazie item.itens e informe uma tag_prodcomum válida. Os números de quantidade e valor são exemplos, sem declaração de homologação.',
      'parametros deve ser um objeto JSON, inclusive quando vazio. Este contrato usa seu próprio cursor em Teste_Executar e não está adaptado ao cursor por registro do IRunner.',
      'RegistrarDataSet e CompararResultadoEsperado permanecem comentados no núcleo; o JSON base não habilita a comparação por asserts.'
    ]
  },
  metodos: [
    ['procedure main', 'Preparar e executar o caso.', 'Chama Setup e Teste nesta ordem.'],
    ['procedure Setup', 'Configurar a área e a tela do Pedido de Venda.', 'Define FCadastro e FDM no contexto do núcleo, chama SetArea e Setup_Inicializar.'],
    ['procedure Teste', 'Delegar a execução dos registros.', 'Chama Teste_Executar no núcleo de Documento de Fatura.']
  ],
  implementacao: ['A unit não declara variáveis globais próprias; FCadastro e FDM são mantidas pelo núcleo.', 'O núcleo extrai documento, item e parametros e P39_TDD_FAT_DOCUMENTO_FATURA_JSON mantém o record TEstrutura com as partes do caso.'],
  dependencias: ['P39_TDD_FAT_DOCUMENTO_FATURA coordena o cursor e as camadas de gravação.'],
  limites: ['O fonte de referência foi incorporado da contribuição do PR #20; a documentação não declara homologação no ERP.']
});
