uses P39_TDD_CONSTANTES;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Essa Unit foi desenvolvida para centralizar a conexão ODBC em todos os testes para não ocorrerem erros de DLL.' + #13 +
    'Os métodos centralizados, mantém a conexão ODBC em 32b (cliente) por meio da unit de constantes.'                            + #13 + #13 +
    'Os seguintes métodos foram disponibilizados:'                                                                                + #13 +
    ' - function TDDScalarODBCP(pSql :string; pParametros :OleVariant) :OleVariant'                                               + #13 +
    '   + Substitui o método ExecuteScalarODBC'                                                                                   + #13 +
    ' - function TDDReaderODBCP(pSql :string; pParametros :OleVariant) :OleVariant'                                               + #13 +
    '   + Substitui o método ExecuteReaderODBC'                                                                                   + #13 +
    ' - function TDDCommandODBCP(pSql :string; pParametros :OleVariant) :OleVariant'                                              + #13 +
    '   + Substitui o método ExecuteCommandODBC'                                                                                  + #13 + #13 +
    'Os mesmos métodos também estão disponíveis sem o sufixo "P" para SQL pura, sem parâmetros, como no ERP!'                     + #13 + #13 +
    'Ao usar um Format(sql, [parâmetros]), pParametros devem ser passados como: null.'                                            + #13 +
    'Utilize esses métodos nas codificações TDD!';
  {P39_TDD_CONSTANTES -> P39_TDD_LOGS.}MostrarInstrucoesUnit('TDD_ODBC', lInstrucoes);
end;

function TDDScalarODBC(pSql :string) :OleVariant;
begin
  Result := TDDScalarODBCP(pSql, null);
end;

function TDDScalarODBCP(pSql :string; pParametros :OleVariant) :OleVariant;
begin
  Result := ExecuteScalarODBC({P39_TDD_CONSTANTES}cConexaoODBCPadrao, pSql, pParametros);
end;

function TDDReaderODBC(pSql :string) :OleVariant;
begin
  Result := TDDReaderODBCP(pSql, null);
end;

function TDDReaderODBCP(pSql :string; pParametros :OleVariant) :OleVariant;
begin
  Result := ExecuteReaderODBC({P39_TDD_CONSTANTES}cConexaoODBCPadrao, pSql, pParametros);
end;

function TDDCommandODBC(pSql :string) :OleVariant;
begin
  Result := TDDCommandODBCP(pSql, null);
end;

function TDDCommandODBCP(pSql :string; pParametros :OleVariant) :OleVariant;
begin
  Result := ExecuteCommandODBC({P39_TDD_CONSTANTES}cConexaoODBCPadrao, pSql, pParametros);
end;
