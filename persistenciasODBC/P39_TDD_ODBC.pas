uses P39_TDD_CONSTANTES;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Essa Unit foi desenvolvida para centralizar a conexão ODBC em todos os testes para não ocorrerem erros de DLL.' + #13 +
    'Os métodos centralizados, mantém a conexão ODBC em 32b (cliente)'                                                      + #13 + #13 +
    'Os seguintes métodos foram disponibilizados:'                                                                                + #13 +
    ' - function TDDScalarODBC(pSql :string; pParametros :OleVariant) :OleVariant'                                                + #13 +
    '   + Substitui o método ExecuteScalarODBC'                                                                                   + #13 +
    ' - function TDDReaderODBC(pSql :string; pParametros :OleVariant) :OleVariant'                                                + #13 +
    '   + Substitui o método ExecuteReaderODBC'                                                                                   + #13 +
    ' - function TDDCommandODBC(pSql :string; pParametros :OleVariant) :OleVariant'                                               + #13 +
    '   + Substitui o método ExecuteCommandODBC'                                                                            + #13 + #13 +
    'ao usar um Format(sql, [parâmetros]), pParametros devem ser passados como: null.'                                            + #13 +
    'Utilize esses métodos nas codificações TDD!';
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_ODBC');
end;

function TDDScalarODBC(pSql :string; pParametros :OleVariant) :OleVariant;
begin
  Result := ExecuteScalarODBC(cConexaoODBCPadrao, pSql, pParametros);    
end;

function TDDReaderODBC(pSql :string; pParametros :OleVariant) :OleVariant;
begin
  Result := ExecuteReaderODBC(cConexaoODBCPadrao, pSql, pParametros);
end;

function TDDCommandODBC(pSql :string; pParametros :OleVariant) :OleVariant;
begin
  Result := ExecuteCommandODBC(cConexaoODBCPadrao, pSql, pParametros);
end;
