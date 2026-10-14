import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  nome: 'P39_TDD_PARAMETRO_MAPEAMENTO', navegacao: { grupo: 'units', subgrupo: 'setup', ordem: 3 },
  resumo: 'Relaciona as chaves JSON de parâmetros aos campos e tabelas de configuração do ERP.',
  fonte: 'docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO_MAPEAMENTO.pas',
  responsabilidade: 'Resolver o nome JSON, o campo do banco e a tabela correspondente para cada parâmetro registrado.',
  problema: 'Separar o vocabulário do caso de teste do esquema de configuração usado por P39_TDD_PARAMETROS.',
  estados: [
    ['FParametroMapeado: Boolean', 'Controla o preenchimento do mapa.', 'MapearParametros preenche uma vez e marca True; não há reset declarado.'],
    ['FMapeamentoParam: array [0..8] of TMapeamentoParametro', 'Nove relações CampoJSON, CampoDB e Tabela.', 'Preenchidas por AddParamMapped; disponíveis no contexto da unit.']
  ],
  metodos: [
    ['procedure Main', 'Apresentar instruções.', 'Delega a MostrarInstrucoesUnit.'],
    ['function GetTabela(pCampo: String): String', 'Resolver a tabela do parâmetro.', 'Delega a GetCampo com o seletor de tabela.'],
    ['function GetCampoJsonParametro(pCampoDB: String): String', 'Converter campo do banco para chave JSON.', 'Consulta GetCampo com o seletor de campo JSON.'],
    ['function GetCampoDBParametro(pCampoJson: String): String', 'Converter chave JSON para campo do banco.', 'Consulta GetCampo com o seletor de campo do banco.'],
    ['function GetCampo(pTipo: Integer; pCampo: String): String', 'Buscar a relação cadastrada.', 'Percorre o array; campo vazio ou relação ausente resultam em string vazia.'],
    ['procedure MapearParametros', 'Preencher o mapa de parâmetros.', 'Registra as nove relações quando FParametroMapeado está False.'],
    ['procedure AddParamMapped(pIdx: Integer; const pChaveJson, pCampoDB, pTabela: String)', 'Atribuir uma relação no array.', 'Grava CampoJSON, CampoDB e Tabela na posição recebida.']
  ],
  implementacao: ['As constantes identificam CONFIG_SISTEMA, CONFIG_SISTEMA_EMPRESA e PCP_CONFIG e os seletores de consulta.', 'A lista é fixa no fonte: ampliar parâmetros exige revisar o limite do array e os registros.'],
  dependencias: ['P39_TDD_LOGS fornece instruções; P39_TDD_PARAMETROS consome o mapa para comparação e UPDATE.'],
  limites: ['Não há validação explícita de pIdx antes da atribuição nem registro dinâmico de parâmetros.', 'A consulta não inicializa o mapa automaticamente; o setup consumidor deve chamar MapearParametros.']
});
