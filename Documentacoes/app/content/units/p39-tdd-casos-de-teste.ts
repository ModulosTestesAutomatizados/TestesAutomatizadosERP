import { criarDocumentoUnit } from './criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  navegacao: { grupo: 'units', subgrupo: 'irunner' },
  nome: 'P39_TDD_CASOS_DE_TESTE', aliases: ['TDD_CASOS_DE_TESTE', 'TDD_CASOS_DE_TESTES'], resumo: 'Datasets e seleção dos registros usados pelo lote de casos.',
  aliasesArtefatos: { CDSCasosTestes: ['FCDSCasosTestes'] },
  fonte: 'docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas',
  responsabilidade: 'Inicializar datasets de casos e referência, obter identificadores de módulo/área e carregar os casos ativos do banco dedicado.',
  problema: 'Mantém a seleção e os dados compartilhados de cenários fora da unit Teste; permite executar registros diferentes com os mesmos artefatos do Runner.',
  estados: [
    ['CDSCasosTestes: TClientDataSet', 'ID, módulo, área, descrição, requisito, JSON e flags', 'Carregado no setup; cursor pertence ao molde'],
    ['CDSResultadoEsperado: TClientDataSet', 'ID e JSON esperado por cenário', 'Carregado junto dos casos e liberado no lote'],
    ['CDSCamposDisponiveis / CDSConfiguracao: TClientDataSet', 'Estruturas de referência e configuração', 'Criadas no setup; liberadas no teardown'],
    ['FModulo / FArea: Integer', 'Identificadores da seleção', 'Definidos por SetModulo e SetArea'],
    ['FDescModulo / FDescArea: String', 'Nomes da seleção atual', 'Mantidos durante o lote'],
    ['FEstruturaCasoTesteIniciada: Boolean', 'Indicar preparação dos datasets', 'True no setup; False no teardown']
  ],
  metodos: [
    ['procedure Main', 'Encaminhar instruções.', 'Chama MostrarInstrucoesUnit; o texto local está vazio.'],
    ['procedure SetModulo(Value: String)', 'Configurar o módulo.', 'Resolve ModuloPeloNome no cache e conserva a descrição.'],
    ['procedure SetArea(Value: String)', 'Configurar a área.', 'Resolve AreaPeloNome no cache e conserva a descrição.'],
    ['procedure CarregarCasosTeste', 'Carregar a seleção configurada.', 'Inicializa a estrutura se necessário, valida módulo/área e encaminha a CarregarCasosTestes.'],
    ['procedure CarregarCasosTestes(Modulo, Area: Integer)', 'Consultar os casos ativos.', 'Monta SQLCasosTestes com ATIVO_CT, módulo e área, lê via TDDReaderODBC e preenche os datasets. Resultado vazio gera exceção.'],
    ['procedure PreencheInformacoesDataSets(CDSTemp: TClientDataSet; Modulo, Area: Integer)', 'Transferir registros para os datasets compartilhados.', 'Percorre o dataset temporário, evita ID duplicado por FindKey e inicializa EXECUTADO/COMPARADO como N.'],
    ['procedure ConfigurarDataSets', 'Definir campos e índices.', 'Cria as estruturas de CDSCasosTestes e CDSResultadoEsperado e indexa por ID.'],
    ['procedure CarregarConfiguracoes', 'Ler a configuração do módulo.', 'Seleciona o SQL de Faturamento ou Financeiro e atribui a leitura a CDSConfiguracao.Data.'],
    ['function GetConfiguracao: OleVariant', 'Retornar os dados de configuração disponíveis.', 'Retorna null quando não há estrutura atribuída; caso contrário, retorna Data.'],
    ['function GetCasosTeste: OleVariant', 'Retornar os dados dos casos disponíveis.', 'Verifica Assigned, Active e IsEmpty antes de retornar CDSCasosTestes.Data.'],
    ['procedure Setup_Inicializar_CasosTeste', 'Preparar os recursos compartilhados.', 'Cria quatro datasets, configura campos, carrega cache e inicializa parâmetros; ativa a flag de estrutura.'],
    ['procedure TearDown_Finalizar_CasosTeste', 'Liberar os datasets.', 'Tenta liberar cada estrutura, agrega os erros e redefine a flag; erros agregados são propagados.']
  ],
  implementacao: ['TDD_RUNNER.SetupCasosTestes faz a carga do lote. TDD_STARTED apenas lê o registro corrente.', 'ExecutarLote de TDD_BASE_UNIT_IRUNNER controla First e Next.', 'A carga prepara os dados esperados; não implementa a etapa TDD_ASSERTS.'],
  dependencias: ['Uses diretos: P39_TDD_CONSTANTES, P39_TDD_PARAMETRO e P39_TDD_CACHE.'],
  limites: ['Não atribuir a esta unit a responsabilidade de executar os cenários ou aprovar asserts.', 'O nome real do arquivo é singular: CASOS_DE_TESTE.']
});
