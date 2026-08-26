uses P39_TDD_REGISTRAR_CASO_TESTE;

// Carrega um caso de teste individual do banco dedicado e popula o CDS por referência.
// A unit principal é quem cria e mantém o pCDSCasoTeste; esta rotina apenas preenche os dados.
procedure CarregarCasoTeste(
  pCDSCasoTeste        : TClientDataSet;
  pDescricaoModulo,
  pDescricaoArea,
  pDescricaoCasoTeste  : String
);
var
  lCodigoModulo,
  lCodigoArea         : integer;
  lSqlCasoTeste       : String;
begin
  try
    lCodigoModulo := {P39_TDD_REGISTRAR_CASO_TESTE.}RegistroFallbackModulo(pDescricaoModulo, false);
    lCodigoArea   := {P39_TDD_REGISTRAR_CASO_TESTE.}RegistroFallbackArea(lCodigoModulo, pDescricaoArea, false);

    lSqlCasoTeste := 'select CT.AUTOINC_CT,'         + #13 +
      '       CT.MODULO_CT,'                         + #13 +
      '       CT.AREA_CT,'                           + #13 +
      '       CT.DESCRICAO_CASO_TESTE_CT,'           + #13 +
      '       CT.JSON_CASO_TESTE,'                   + #13 +
      '       CT.CAMPOS_DISPONIVEIS_CT,'             + #13 +
      '       CT.RESULTADO_ESPERADO_CT'              + #13 +
      'from CASO_TESTE CT'                           + #13 +
      'where CT.DESCRICAO_CASO_TESTE_CT = :pDescricao and' + #13 +
      '      CT.MODULO_CT               = :pModulo    and' + #13 +
      '      CT.AREA_CT                 = :pArea      and' + #13 +
      '      CT.ATIVO_CT = ' + QuotedStr('S') + ';';

    pCDSCasoTeste.Close;
    pCDSCasoTeste.Data := {P39_TDD_ODBC.}TDDReaderODBC(lSqlCasoTeste, [
      pDescricaoCasoTeste,
      lCodigoModulo,
      lCodigoArea
    ]);
    pCDSCasoTeste.LogChanges := False;

    if pCDSCasoTeste.IsEmpty then
      raise Exception.Create(MensagemPersonalizada + 'Caso de teste não encontrado ou inativo.');
  except on ex: Exception do
    raise Exception.Create(MensagemPersonalizada + 'Erro ao carregar o caso de teste! ' + ex.Message);
  end;
end;
