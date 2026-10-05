uses P39_TDD_CONSTANTES, P39_TDD_PARAMETRO, P39_TDD_CACHE;

var 
  CDSCasosTestes: TClientDataSet;
  CDSResultadoEsperado: TClientDataSet;
  CDSCamposDisponiveis: TClientDataSet;
  CDSConfiguracao: TClientDataSet;
  
  FModulo, FArea: Integer;
  FDescModulo, FDescArea: String;
  FEstruturaCasoTesteIniciada: Boolean;

procedure Main;
begin
  // Add instruÃ§Ãµes;
end;

procedure CarregarConfiguracoes;
var SQL: String;
begin
  if not FEstruturaCasoTesteIniciada then
    Setup_Inicializar_CasosTeste;

  ValidarModulo;
  if UpperCase(FDescModulo) = 'FATURAMENTO' then
    SQL := GetSQLConfigFaturamento
  else if UpperCase(FDescModulo) = 'FINANCEIRO' then
    SQL := GetSQLConfigFinanceiro;    
  
  CDSConfiguracao.Data := TDDReaderODBC(SQL);      
end;

procedure SetModulo(Value: String);
begin
  FModulo := ModuloPeloNome(Value);
  FDescModulo := Value;
end;

procedure SetArea(Value: String);
begin
  FArea := AreaPeloNome(Value);
  FDescArea := Value;
end;

procedure CarregarCasosTeste;
begin
  if not FEstruturaCasoTesteIniciada then
    Setup_Inicializar_CasosTeste;

  ValidarModulo;
  ValidarArea;
  CarregarCasosTestes(FModulo, FArea);
end;

procedure CarregarCasosTestes(Modulo, Area: Integer);
var 
  iMod, iArea: Integer;
  SL: TStringList;
  CDS: TClientDataSet;
begin
  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, 'Carregando InformaÃ§Ãµes de Casos de Testes...');
    
    if (Trim(Modulo) = '') then
      raise Exception.Create(MensagemPersonalizada + 'Modulo nÃ£o Informado.');
    
    iMod := GetModulo(Modulo);

    iArea := Area;
    if iArea > 0 then
      iArea := GetArea(Area);

    CDS := TClientDataSet.Create;  
    SL  := TStringList.Create; 
    try
      SL.Clear;
      SL.Text := SQLCasosTestes;
      SL.Add('where ATIVO_CT = ' + QuotedStr('S'));
      SL.Add('  and MODULO_CT = ' + IntToStr(iMod));
      
      if iArea > 0 then
        SL.Add('  and AREA_CT = ' + IntToStr(iArea));

      CDS.Data := TDDReaderODBC(SL.Text);
      
      if CDS.IsEmpty then
        raise Exception.Create(MensagemPersonalizada + 'Falha ao carregar Casos de Testes.');
        
      PreencheInformacoesDataSets(CDS, iMod, iArea);
    finally
      SL.Free;
      CDS.Free;
    end;   
  finally
    CallBack_FechaTela(ClassOwner);
  end;
   
end;

procedure PreencheInformacoesDataSets(CDSTemp: TClientDataSet; Modulo, Area: Integer);
begin
  //{P39_TDD_LOGS.}MostrarCDSEmModoDebugT(CDSTemp, 'CDSTemp - PreencheInformacoesDataSets');
  CallBack_Mensagem(ClassOwner, 'Preenchendo DataSets de Casos de Testes...');
  CDSTemp.DisableControls;
  CDSTemp.LogChanges := False;
  
  CDSTemp.First;
  while not CDSTemp.Eof do
  begin
    if not CDSCasosTestes.FindKey([CDSTemp.FieldByName('AUTOINC_CT').AsInteger]) then
    begin
      CDSCasosTestes.Insert;
      CDSCasosTestes.FieldByName('ID').AsInteger := CDSTemp.FieldByName('AUTOINC_CT').AsInteger;
      CDSCasosTestes.FieldByName('MODULO').AsInteger := Modulo;
      CDSCasosTestes.FieldByName('AREA').AsInteger := Area;
      CDSCasosTestes.FieldByName('DESCRICAO').AsString := CDSTemp.FieldByName('DESCRICAO_CASO_TESTE_CT').AsString;
      CDSCasosTestes.FieldByName('REQUISITOVERSAO').AsString := CDSTemp.FieldByName('REQUISITO_VERSAO_CT').AsString;
      CDSCasosTestes.FieldByName('CASOTESTE').AsString := CDSTemp.FieldByName('CASO_TESTE_CT').AsString;
      CDSCasosTestes.FieldByName('EXECUTADO').AsString := 'N';
      CDSCasosTestes.FieldByName('COMPARADO').AsString := 'N';
      CDSCasosTestes.Post;
    end;
    if not CDSResultadoEsperado.FindKey([CDSTemp.FieldByName('AUTOINC_CT').AsInteger]) then
    begin
      CDSResultadoEsperado.Insert;
      CDSResultadoEsperado.FieldByName('ID').AsInteger := CDSTemp.FieldByName('AUTOINC_CT').AsInteger;
      CDSResultadoEsperado.FieldByName('RESULTADO_ESPERADO').AsString := CDSTemp.FieldByName('RESULTADO_ESPERADO_CT').AsString;
      CDSResultadoEsperado.Post;
    end;
    // Fazer para os Demais DataSets
  
    CDSTemp.Next;
  end;
end;

procedure ConfigurarDataSets;
begin
  CDSCasosTestes.FieldDefs.Clear;
  CDSCasosTestes.FieldDefs.Add('ID', ftInteger, 0, False);
  CDSCasosTestes.FieldDefs.Add('MODULO', ftInteger, 0, False);
  CDSCasosTestes.FieldDefs.Add('AREA', ftInteger, 0, False);
  CDSCasosTestes.FieldDefs.Add('DESCRICAO', ftString, 180, False);
  CDSCasosTestes.FieldDefs.Add('REQUISITOVERSAO', ftString, 10, False);
  CDSCasosTestes.FieldDefs.Add('CASOTESTE', ftBlob, 0, False);
  CDSCasosTestes.FieldDefs.Add('EXECUTADO', ftString, 1, False);
  CDSCasosTestes.FieldDefs.Add('COMPARADO', ftString, 1, False);
  
  CDSCasosTestes.CreateDataSet;
  CDSCasosTestes.LogChanges := False;
  CDSCasosTestes.IndexFieldNames := 'ID';
  
  CDSResultadoEsperado.FieldDefs.Clear;
  CDSResultadoEsperado.FieldDefs.Add('ID', ftInteger, 0, False); //CODIGO DO CASO DE TESTE
  CDSResultadoEsperado.FieldDefs.Add('RESULTADO_ESPERADO', ftBlob, 0, False); // JSON REsultado Esperado.
  CDSResultadoEsperado.CreateDataSet;
  CDSResultadoEsperado.LogChanges := False;
  CDSResultadoEsperado.IndexFieldNames := 'ID';  

  // Fazer com os Demais DataSets
end;

function GetConfiguracao: OleVariant;
begin
  Result := null;
  
  if Assigned(CDSConfiguracao) then
    Result := CDSConfiguracao.Data;
end;

function GetCasosTeste: OleVariant;
begin
  Result := null;

  if not Assigned(CDSCasosTestes) or 
     not CDSCasosTestes.Active or
     CDSCasosTestes.IsEmpty then
    Exit;

  Result := CDSCasosTestes.Data;
end;

procedure Setup_Inicializar_CasosTeste;
begin
  CDSCasosTestes       := TClientDataSet.Create;
  CDSResultadoEsperado := TClientDataSet.Create;
  CDSCamposDisponiveis := TClientDataSet.Create;
  CDSConfiguracao      := TClientDataSet.Create;
  ConfigurarDataSets;
  Cache_Setup_CarregarInformacoes;
  Setup_Inicializar_Parametros;
  FEstruturaCasoTesteIniciada := True;
end;

procedure TearDown_Finalizar_CasosTeste;
begin
  CDSCasosTestes.Free;
  CDSResultadoEsperado.Free;
  CDSCamposDisponiveis.Free;
  CDSConfiguracao.Free;
  FEstruturaCasoTesteIniciada := False;
end;
