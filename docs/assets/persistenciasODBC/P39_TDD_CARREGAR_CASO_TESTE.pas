uses P39_TDD_REGISTRAR_CASO_TESTE;

procedure Main;
var lInstrucao :string;
begin
  P39_TDD_REGISTRAR_CASO_TESTE.Main; // DocumentaÃ§Ã£o!
  
  lInstrucao := 'Unit utilizada para carregar um caso de teste para ser utilizado em uma suÃ­te.'                                    + #13 + 
    'Assinatura do mÃ©todo de carregar teste:'                                                                                       + #13 +
    ' - procedure CarregarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string; pCDSCasoTeste :TClientDataSet);' + #13 +
    '   + Carrega um caso de teste individual do banco dedicado e popula o CDS por referÃªncia.'                                     + #13 +
    'A unit principal Ã© quem cria e mantÃ©m o pCDSCasoTeste! Esta rotina apenas preenche os dados.';
  MostrarLogTexto(lInstrucao, 'InstruÃ§Ãµes P39_TDD_CARREGAR_CASO_TESTE');
end;

procedure CarregarCasoTeste(
  pDescricaoModulo,
  pDescricaoArea,
  pDescricaoCasoTeste :string;
  pCDSCasoTeste       :TClientDataSet;  
);
var
  lCodigoModulo,
  lCodigoArea         :integer;
  lSqlCasoTeste       :string;
begin
  try
    lCodigoModulo := {P39_TDD_REGISTRAR_CASO_TESTE.}RegistroFallbackModulo(pDescricaoModulo, false);
    lCodigoArea   := {P39_TDD_REGISTRAR_CASO_TESTE.}RegistroFallbackArea(lCodigoModulo, pDescricaoArea, false);

    lSqlCasoTeste := 'select CT.AUTOINC_CT,'               + #13 +
      '       CT.MODULO_CT,'                               + #13 +
      '       CT.AREA_CT,'                                 + #13 +
      '       CT.DESCRICAO_CASO_TESTE_CT,'                 + #13 +
      '       CT.CASO_TESTE_CT,'                           + #13 +
      '       CT.CAMPOS_DISPONIVEIS_CT,'                   + #13 +
      '       CT.RESULTADO_ESPERADO_CT'                    + #13 +
      'from CASO_TESTE CT'                                 + #13 +
      'where CT.DESCRICAO_CASO_TESTE_CT = :pDescricao and' + #13 +
      '      CT.MODULO_CT               = :pModulo    and' + #13 +
      '      CT.AREA_CT                 = :pArea      and' + #13 +
      '      CT.ATIVO_CT = ' + QuotedStr('S') + ';';

    pCDSCasoTeste.Close;
    pCDSCasoTeste.Data := {P39_TDD_ODBC.}TDDReaderODBCP(lSqlCasoTeste, [
      pDescricaoCasoTeste,
      lCodigoModulo,
      lCodigoArea
    ]);
    pCDSCasoTeste.LogChanges := False;

    if pCDSCasoTeste.IsEmpty then
      raise Exception.Create(MensagemPersonalizada + 'Caso de teste nÃ£o encontrado ou inativo.');
  except on ex: Exception do
    raise Exception.Create(MensagemPersonalizada + 'Erro ao carregar o caso de teste! ' + ex.Message);
  end;
end;
