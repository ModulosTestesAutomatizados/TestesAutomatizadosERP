import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  nome: 'P39_TDD_FIN_BORDERO_PAGAMENTO', navegacao: { grupo: 'mapeamentos', subgrupo: 'financeiro', ordem: 0 },
  resumo: 'Mapeia a tela de borderô de pagamento e mantém referências aos componentes, datasets e seletores.',
  fonte: 'docs/assets/casosTestesFinanceiro/P39_TDD_FIN_BORDERO_PAGAMENTO.pas',
  responsabilidade: 'Localizar a tela e seus componentes e preparar os datasets temporários utilizados pelo cenário financeiro.',
  problema: 'Separar os nomes concretos de componentes do fluxo de teste; o helper pode atender consumidores além do IRunner.',
  estados: [
    ['fBorderoPagamento: TForm', 'Referência a FCadBorderoPagamento.', 'Obtida ou criada em CriarObjetos; Show abre a tela.'],
    ['PageControl, PageControl2: TPageControl', 'Abas usadas pelo cenário.', 'Mapeadas por FindComponent; pertencem ao formulário.'],
    ['cbTipoBordero, cbQualificacaoPagamento, cbCalculoJuros: TJvDBComboBox', 'Seleção de tipo, qualificação e juros.', 'Mapeadas a partir dos componentes da tela.'],
    ['ceCodBordero, ceConta, ceDataAcerto, ceTaxaJuros: TJvDBCalcEdit', 'Referências aos campos de código, conta, data e taxa.', 'Tipos e nomes são os declarados no fonte; pertencem à tela.'],
    ['btnIncluir, btnExcluir, btnGravar, btnCancelar, sbUltimo: TNewBtn', 'Referências a comandos da tela.', 'Os quatro botões principais são mapeados; sbUltimo é declarado, sem atribuição no mapeamento.'],
    ['CDSPagarPagamento, CDSProrrogacaoPagamento, CDSChqDevolvido, CDSChqTerceiro, CDSChqProprio, CDSComplementoPagamento, CDSReceberPagamento, CDSAdiantamento, CDSGrupoResultadoPagamento, CDSCadastroPagamento: TClientDataSet', 'Datasets reais de DMCadBorderoPagamento.', 'Obtidos em IniciarCDSCadastroBordero; não são liberados por DestruirObjetos.'],
    ['CDSCadastroTemp, CDSProrrogacaoTemp, CDSChqDevolvidoTemp, CDSChqTerceiroTemp, CDSChqProprioTemp, CDSComplementoTemp, CDSReceberTemp, CDSAdiantamentoTemp, CDSGrupoResultadoTemp, CDSPagarTemp: TClientDataSet', 'Datasets temporários próprios.', 'Criados em CriarObjetos e liberados por DestruirObjetos.'],
    ['SPessoa: TSelecao', 'Componente de seleção de pessoa.', 'Obtido no formulário; fornece CDSSelecao e rgPessoa.'],
    ['CDSSelecao: TClientDataSet', 'Dataset do seletor de pessoa.', 'Referência ao componente filho de SPessoa; não é criado pelo helper.'],
    ['rgPessoa: TRadioGroup', 'Opções de pessoa no seletor.', 'Mapeado por SPessoa.FindComponent.']
,
    ["ckProrrogacao, ckChequesDev, ckDuplicReceber, ckExibirBaixados, ckConPromessaPag, ckExibirDevolvidos, ckExibirChequeRecParc, ckExibirDupRecParc: TCheckBox", "Filtros e op??es da tela.", "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."],
    ["dtEditProrrogacoesIni, dtEditProrrogacoesFim, dtEditchequeDevEntreIni, dtEditchequeDevEntreFim, dtEditContasPgEntreIni, dtEditContasPgEntreFim, dtEditChequeTerceiroIni, dtEditChequeTerceiroFim, dtEditDupReceberEntreIni, dtEditDupReceberEntreFim: TJvDateEdit", "Intervalos de datas dos filtros.", "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."],
    ["LabelPMC, LabelPMD, LabelPMG, LabelTotCredito, LabelGRManuais, LabelProrrogacoes, LabelChequeDev, LabelTotDebito, LabelNominalABaixar, LabelAindaAberto, lblTotDebitoAtualizado, LabelJurosCalculados, LabelDescontosCalculados, LabelPreDesconto, LabelDiferenca: TLabel", "Labels de totaliza??o da tela.", "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."]
  ],
  metodos: [
    ['procedure Main', 'Preparar os objetos e datasets da tela.', 'Chama CriarObjetos e IniciarCDSCadastroBordero; a chamada de limpeza no finally está comentada.'],
    ['procedure CriarObjetos', 'Obter a tela e preparar temporários.', 'Obtém ou cria FCadBorderoPagamento, mostra a tela, cria dez datasets temporários e mapeia componentes.'],
    ['procedure MapearComponentesBorderoPagamento', 'Resolver componentes pelos nomes da tela.', 'Atribui abas, controles, filtros, labels, botões e componentes da seleção de pessoa via FindComponent.'],
    ['procedure IniciarCDSCadastroBordero', 'Obter os datasets reais do módulo de dados.', 'Localiza DMCadBorderoPagamento e atribui os datasets ao contexto global do helper.'],
    ['procedure DestruirObjetos', 'Liberar os datasets temporários.', 'Chama Free nos dez temporários; a liberação do formulário está comentada.']
  ],
  implementacao: ['As constantes cAbaPrincipal até cAbaTotalizacao identificam índices de abas.', 'Também declara checkboxes de filtros, intervalos de datas e labels de totalização, mapeados por nomes concretos do formulário.'],
  dependencias: ['Sem uses ativo no fonte; tipos e métodos de localização são fornecidos pelo host.', 'O piloto P39_TDD_FIN_PAGAMENTO_RECEBIMENTO referencia P39_TDD_FIN_BORDERO_PAGAMENTO no uses.'],
  limites: ['O nome do cadastro externo precisa acompanhar a renomeação local; a versão instalada no ERP exige conferência.', 'FindComponent pode retornar referência ausente; o fonte não valida todas as atribuições.', 'CriarObjetos cria novos temporários em cada chamada; Main não executa a limpeza comentada no finally.']
});
