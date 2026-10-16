import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  navegacao: { grupo: 'units', subgrupo: 'setup', ordem: 2 },
  nome: 'P39_TDD_PARAMETROS', resumo: 'Mapeamento, comparação e atualização dos parâmetros do ERP.',
  fonte: 'docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETROS.pas',
  responsabilidade: 'Comparar o bloco parametros com a configuração corrente e aplicar somente as diferenças necessárias.',
  problema: 'Permite que o JSON de cada cenário prepare o ERP para o Teste sem um processamento manual separado.',
  estados: [['CDSParametro: TClientDataSet', 'Leitura dos parâmetros disponíveis no ERP', 'Preparado no setup e liberado por TearDown_FinalizarParametros']],
  metodos: [
    ['procedure Main', 'Encaminhar instruções.', 'Chama MostrarInstrucoesUnit; a descrição local está vazia.'],
    ['function GetSQLParametro: String', 'Montar a leitura da configuração.', 'Obtém campos das classes de configuração e compõe SQL com filtros da empresa atual para as tabelas por empresa.'],
    ['procedure VerificarParametros(pJSONParametros: String)', 'Encontrar valores que precisam mudar.', 'Percorre pares JSON e monta dataset temporário indexado pela chave; chama AtualizarParametros quando há diferenças.'],
    ['function NecessarioModificarParam(pCampo, pValor: String): Boolean', 'Comparar um valor com o estado atual.', 'Compara o valor de GetValueJson(SecaoParametroJson, pCampo) com pValor e propaga falhas de leitura.'],
    ['procedure AtualizarParametros(pCDS: TClientDataSet)', 'Aplicar as diferenças.', 'Obtém campo/tabela do mapeamento, infere o tipo, monta UPDATE e executa ExecuteCommand. Erros são relançados; ao concluir, chama Relogar.'],
    ['procedure Relogar', 'Recarregar a configuração na sessão.', 'Obtém DMConexao, chama ConectaServidorAplicacao e depois CarregaSecaoAtual.'],
    ['function PegarTipoCampo(pValue: String): Integer', 'Inferir o tipo do valor.', 'Aspas indicam string, true/false indicam lógico, ponto indica moeda e os demais valores são tratados como inteiro; vazio retorna -1.'],
    ['procedure CriarEstruturaParametrosAtualizar(pCDS: TClientDataSet)', 'Preparar o dataset temporário.', 'Define CHAVE e VALOR, cria o dataset e indexa por CHAVE.'],
    ['procedure Setup_Inicializar_Parametros', 'Inicializar mapeamento e leitura.', 'Chama MapearParametros, lê GetSQLParametro com ExecuteReader e configura as propriedades dos campos.'],
    ['procedure TearDown_FinalizarParametros', 'Liberar a estrutura de parâmetros.', 'Executa Free em CDSParametro.']
  ],
  implementacao: ['P39_TDD_STARTED consome parametros do JSON do registro corrente e chama VerificarParametros.', 'CONFIG_SISTEMA é global; CONFIG_SISTEMA_EMPRESA e PCP_CONFIG recebem filtros da empresa atual.', 'As mudanças pertencem ao banco do ERP, não ao banco dedicado de testes.'],
  dependencias: ['Uses diretos: P39_TDD_PARAMETRO_MAPEAMENTO e P39_TDD_FUNCOES_JSON.'],
  limites: ['Falha de UPDATE propaga por Started e pode interromper o lote.', 'A limpeza do dataset não restaura os valores antigos de configuração.', 'O fonte não mostra rollback automático de toda a sequência de UPDATEs.']
});
