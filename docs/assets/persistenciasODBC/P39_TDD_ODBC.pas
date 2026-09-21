uses P39_TDD_CONSTANTES;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Essa Unit foi desenvolvida para centralizar a conexÃ£o ODBC em todos os testes para nÃ£o ocorrerem erros de DLL.' + #13 +
    'Os mÃ©todos centralizados, mantÃ©m a conexÃ£o ODBC em 32b (cliente) por meio da unit de constantes.'                            + #13 + #13 +
    'Os seguintes mÃ©todos foram disponibilizados:'                                                                                + #13 +
    ' - function TDDScalarODBCP(pSql :string; pParametros :OleVariant) :OleVariant'                                                + #13 +
    '   + Substitui o mÃ©todo ExecuteScalarODBC'                                                                                   + #13 +
    ' - function TDDReaderODBCP(pSql :string; pParametros :OleVariant) :OleVariant'                                                + #13 +
    '   + Substitui o mÃ©todo ExecuteReaderODBC'                                                                                   + #13 +
    ' - function TDDCommandODBCP(pSql :string; pParametros :OleVariant) :OleVariant'                                               + #13 +
    '   + Substitui o mÃ©todo ExecuteCommandODBC'                                                                                  + #13 + #13 +
    'Os mesmos mÃ©todos tambÃ©m estÃ£o disponÃ­veis sem o sufixo "P" para SQL pura, sem parÃ¢metros, como no ERP!'                     + #13 + #13 +
    'Ao usar um Format(sql, [parÃ¢metros]), pParametros devem ser passados como: null.'                                            + #13 +
    'Utilize esses mÃ©todos nas codificaÃ§Ãµes TDD!';
  MostrarLogTexto(lInstrucoes, 'InstruÃ§Ãµes P39_TDD_ODBC');
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
