import type { IDocumento } from '../../models/documentacao.ts';

export default {
  slug: 'pedido-venda', categoria: 'documentos', titulo: 'Pedido de venda — Documento de Fatura',
  resumo: 'Fluxo refatorado de faturamento: preparação, camadas de gravação, parâmetros, foco da tela e pendências dos asserts.',
  estado: 'em-uso', navegacao: { grupo: 'casos', subgrupo: 'legado', ordem: 2 },
  referenciaAnterior: '/documentos/documento-fatura',
  fontes: [
    'docs/MAPEAMENTO_AST_USES_UNITS/pedido-venda/dependencias.md',
    'docs/MAPEAMENTO_AST_USES_UNITS/pedido-venda/execucao.md',
    'docs/assets/casosTestesFaturamento/P39_TDD_FAT_PEDIDO_VENDA.pas',
    'docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA.pas',
    'docs/assets/casosTestesFaturamento/P39_TDD_FAT_VALIDAR_RESULTADO.pas',
    'docs/assets/configuracoesGerais/P39_TDD_MODULO.pas'
  ].map(pCaminho => ({ caminho: pCaminho })),
  secoes: [
    { id: 'origem', titulo: 'Origem e contrato de execução', blocos: [
      { tipo: 'paragrafo', texto: 'Documentação incorporada da contribuição de TEK-JoaoPauloJaques no PR #20, referente à refatoração da issue #12 e à sincronização de fontes de 05/10/2026. O núcleo P39_TDD_FAT_DOCUMENTO_FATURA foi dividido em camadas de responsabilidade. Os mapas e o Draw.io originais ficam no diretório canônico pedido-venda.' },
      { tipo: 'paragrafo', texto: 'P39_TDD_FAT_PEDIDO_VENDA.main chama Setup e Teste. Setup define FCadastro, FDM e a área PEDIDO DE VENDA; Teste delega ao cursor interno de Teste_Executar em P39_TDD_FAT_DOCUMENTO_FATURA. Por isso esta página fica no grupo de contratos anteriores ao IRunner, embora essas units estejam em uso.' },
      { tipo: 'aviso', severidade: 'warning', texto: 'Este contrato percorre CDSCasosTestes dentro de Teste. Não deve ser tratado como uma unit já adaptada ao molde do IRunner, que controla o cursor por registro. A incorporação documental não habilita asserts nem comprova homologação no ERP.' }
    ] },
    { id: 'dependencias', titulo: 'Grafo de uses e heranças transitivas', blocos: [
      { tipo: 'mermaid', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/pedido-venda/dependencias.md', titulo: 'Dependências do Pedido de Venda refatorado' },
      { tipo: 'paragrafo', texto: 'O núcleo usa P39_TDD_MODULO para abrir a tela e recuperar o foco. P39_TDD_CASOS_DE_TESTE, os parâmetros e o cache chegam por dependências transitivas. As camadas usam o estado do núcleo, formando ciclos declarados no mapa; chamadas qualificadas deixam explícita a unit responsável.' }
    ] },
    { id: 'fluxo', titulo: 'Preparação, execução e gravação', blocos: [
      { tipo: 'mermaid', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/pedido-venda/execucao.md', titulo: 'Do main à gravação do pedido por cliente' },
      { tipo: 'lista', itens: [
        'P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_PRINCIPAIS: tabela de preço, condições, prazos e descontos; chama P39_TDD_FAT_DOCUMENTO_FATURA_ITENS para inclusão dos itens.',
        'P39_TDD_FAT_DOCUMENTO_FATURA_FINANCEIRO: financeira e banco.',
        'P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_ENTREGA: datas de entrega e venda, campanha e parceria.',
        'P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_FATURAMENTO: transação de venda.',
        'P39_TDD_FAT_DOCUMENTO_FATURA_INFORMACOES_FRETE: frete manual ou embutido e ajuste fiscal.',
        'P39_TDD_FAT_DOCUMENTO_FATURA_JSON: record TEstrutura e acesso às tags do documento e dos itens.'
      ] }
    ] },
    { id: 'parametros-foco', titulo: 'Parâmetros e recuperação do foco', blocos: [
      { tipo: 'paragrafo', texto: 'Ao receber parâmetros no JSON do caso, SetCasoTeste chama _AjustarParametros. A tela aberta é liberada por FinalizarFormulario, que executa FormCadastro.Free e recupera o foco com P39_TDD_MODULO. VerificarParametros pode atualizar a configuração e executar Relogar. O finally reabre a tela por Setup_IniciarFormulario.' },
      { tipo: 'paragrafo', texto: 'AbrirTela dispara Emisso1Click no FPrincipal, usando o evento real do menu. FocarModulo chama SetFocus e Repaint; TrazerParaFrente chama BringToFront. Relogar permanece no contrato para aplicar a situação de parâmetros de cada caso.' }
    ] },
    { id: 'estados', titulo: 'Estado compartilhado e ciclo de vida', blocos: [
      { tipo: 'paragrafo', texto: 'O núcleo mantém FCDSClientes, FCDSProdutos e FCDSConfigFaturamentoCasoTeste; as referências aos DataSets da tela incluem CDSCad, CDSItem, CDSFiscal e CDSPedido. FCadastro e FDM identificam o formulário e o módulo de dados, enquanto FTelaPedidoAberta controla a reabertura após parâmetros. P39_TDD_FAT_DOCUMENTO_FATURA_JSON mantém o contexto de tags do caso.' },
      { tipo: 'aviso', severidade: 'warning', texto: 'TearDown_DestruirObjetos existe no núcleo, mas sua chamada no finally de Teste_Executar está comentada no fonte incorporado. A documentação registra o estado disponível; não afirma que a liberação final esteja ativa.' }
    ] },
    { id: 'asserts', titulo: 'Asserts e pendências de integração', blocos: [
      { tipo: 'lista', itens: [
        'As dez chamadas de RegistrarDataSet em Setup_IniciarFormulario estão comentadas.',
        'A chamada CompararResultadoEsperado em Teste_Executar está comentada.',
        'P39_TDD_FAT_VALIDAR_RESULTADO declara uses P39_TDD_ASSERTS; essa dependência existe mesmo com a comparação não acionada pelo núcleo.',
        'O uses P39_TDD_CASOS_DE_TESTE dentro de P39_TDD_ASSERTS está comentado; não confundir essa cláusula com o uses do validador.',
        'AssertsFalhou permanece ativo no tratamento de erro de inclusão de itens. Isso não equivale à comparação completa dos resultados esperados.',
        'Sem a integração, COMPARADO não recebe o resultado da comparação e METRICAS_ASSERTS não é alimentada por este fluxo.'
      ] }
    ] }
  ]
} satisfies IDocumento;
