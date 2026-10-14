import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  nome: 'P39_TDD_CONSTANTES', navegacao: { grupo: 'units', subgrupo: 'constantes', ordem: 0 },
  resumo: 'Constantes de conexão e consultas compartilhadas por configurações, cache e cadastros TDD.',
  fonte: 'docs/assets/configuracoesGerais/P39_TDD_CONSTANTES.pas',
  responsabilidade: 'Centralizar os identificadores de conexão e as consultas de versão, configurações, casos, módulos e áreas.',
  problema: 'Evitar duplicação desses contratos em cada consumidor; sua responsabilidade vai além de IRunner.Executar.',
  estados: [
    ['CDSModulos, CDSAreas: TClientDataSet', 'Referências globais declaradas no fonte de constantes.', 'Não recebem atribuição nas rotinas desta unit.'],
    ['FCacheCarregado: Boolean', 'Indicador declarado neste fonte.', 'Não é alterado pelas rotinas desta unit; P39_TDD_CACHE mantém suas próprias declarações.']
  ],
  metodos: [
    ['procedure Main', 'Apresentar instruções.', 'Delega a MostrarInstrucoesUnit.'],
    ['function GetVersao: TVersao', 'Ler os dados de versão do banco dedicado.', 'Cria um dataset local, lê VERSAO_CTRL via ExecuteReaderODBCServ e libera o dataset em finally.'],
    ['function GetSQLConfigFaturamento: String', 'Montar a consulta de configuração de faturamento.', 'Seleciona os campos explicitamente listados de FATURAMENTO_CONFIGURACAO.'],
    ['function GetSQLConfigFinanceiro: String', 'Montar a consulta de configuração financeira.', 'Seleciona os campos de FINANCEIRO_CONFIGURACAO.'],
    ['function SQLCasosTestes: String', 'Montar a leitura de CASO_TESTE.', 'Lista os campos do caso; os filtros de ativo, área e módulo estão comentados neste gerador.'],
    ['function SQLModulos: String', 'Montar a leitura de módulos.', 'Retorna código e descrição de MODULO.'],
    ['function SQLAreas: String', 'Montar a leitura de áreas e módulos.', 'Consulta AREA com LEFT JOIN em MODULO.']
  ],
  implementacao: ['cDataBase preserva a conexão usada por GetVersao; cConexaoODBCPadrao centraliza a conexão cliente de 32 bits utilizada por P39_TDD_ODBC.', 'TVersao contém Versao, Codigo e Numero.'],
  dependencias: ['P39_TDD_LOGS fornece a apresentação de instruções.'],
  limites: ['A geração de SQL não aplica filtros adicionais automaticamente.', 'Os campos de cache declarados aqui não comprovam que o cache seja carregado por esta unit.']
});
