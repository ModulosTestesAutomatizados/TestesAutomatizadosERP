import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  nome: 'P39_TDD_ODBC', aliases: ['TDD_ODBC'], navegacao: { grupo: 'units', subgrupo: 'infraestrutura' },
  resumo: 'Wrappers de leitura, comando e valor escalar usando a conexão ODBC compartilhada do TDD.',
  fonte: 'docs/assets/configuracoesGerais/P39_TDD_ODBC.pas',
  responsabilidade: 'Encaminhar operações ao host ODBC usando cConexaoODBCPadrao.',
  problema: 'Padronizar a conexão cliente de 32 bits entre consumidores, sem restringir a infraestrutura ao IRunner.',
  metodos: [
    ['procedure Main', 'Apresentar o contrato dos wrappers.', 'Mostra instruções de uso dos métodos com e sem parâmetros.'],
    ['function TDDScalarODBC(pSql: String): OleVariant', 'Consultar um valor escalar sem parâmetros.', 'Chama TDDScalarODBCP passando null.'],
    ['function TDDScalarODBCP(pSql: String; pParametros: OleVariant): OleVariant', 'Consultar um valor escalar com parâmetros.', 'Delega a ExecuteScalarODBC com a conexão padrão.'],
    ['function TDDReaderODBC(pSql: String): OleVariant', 'Ler dados sem parâmetros.', 'Chama TDDReaderODBCP passando null.'],
    ['function TDDReaderODBCP(pSql: String; pParametros: OleVariant): OleVariant', 'Ler dados com parâmetros.', 'Delega a ExecuteReaderODBC com a conexão padrão.'],
    ['function TDDCommandODBC(pSql: String): OleVariant', 'Executar um comando sem parâmetros.', 'Chama TDDCommandODBCP passando null.'],
    ['function TDDCommandODBCP(pSql: String; pParametros: OleVariant): OleVariant', 'Executar um comando com parâmetros.', 'Delega a ExecuteCommandODBC com a conexão padrão.']
  ],
  implementacao: ['Não declara conexão ou dataset global próprio; o host fornece os métodos e P39_TDD_CONSTANTES fornece a identificação da conexão.'],
  dependencias: ['P39_TDD_CONSTANTES é a dependência direta.'],
  limites: ['Os wrappers não implementam transação, reconexão ou tratamento de exceções próprios.', 'Os tipos concretos e a liberação do resultado dependem da API do host e do consumidor.']
});
