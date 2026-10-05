uses P39_TDD_PARAMETRO_MAPEAMENTO, P39_TDD_FUNCOES_JSON;

const
    cTipoString = 0;
    cTipoInteiro = 1;
    cTipoCurrency = 2;
    cTipoboolean = 3;

var 
 CDSParametro: TClientDataSet;

function GetSQLParametro:String;
var LS: TStringList;
begin
    LS := TStringList.Create;
    try
        LS.Clear;
        LS.Add('select');
        LS.Add(ExecutarMetodoDeClasse('ClassConfigSistema','TClassConfigSistema' ,'CamposCadastro') + ',');
        LS.Add(ExecutarMetodoDeClasse('ClassConfigSistemaEmp','TClassConfigSistemaEmp' ,'CamposCadastro') + ',');
        LS.Add(ExecutarMetodoDeClasse('ClassPCP_Config','TClassPCP_Config' ,'CamposCadastro'));
        LS.Add('from CONFIG_SISTEMA,CONFIG_SISTEMA_EMPRESA,PCP_CONFIG');
        LS.Add('where CONFIG_SISTEMA_EMPRESA.EMPRESA_CFSEMP = ' + IntToStr(Codigo_Empresa_Atual));
        LS.Add('and PCP_CONFIG.CODIGO_CONFIG = ' + IntToStr(Codigo_Empresa_Atual));
        
        Result := LS.Text;
    finally
        LS.Free;    
    end;    
end;

procedure VerificarParametros(pJSONParametros: String);
var 
  LObj: TJSONObject;
  I: Integer;
  LPair: TJSONPair;
  LPairName, LPairValue: String;
  CDS: TClientDataSet;
begin
  if pJSONParametros = '' then
    Exit;

  LObj := TJSONObject.ParseJSONValue(pJSONParametros);
  CDS  := TClientDataSet.Create;
  try
    CriarEstruturaParametrosAtualizar(CDS);
    for I := 0 to LObj.Count -1 do
    begin
      LPair := ExecutarMetodoDeObjeto(LObj, 'GetPair', [I]);
      if Assigned(LPair) then
      begin
        LPairName := GetPairName(LPair);
        LPairValue := GetPairValue(LPair);

        if NecessarioModificarParam(LPairName, LPairValue) then
          if not CDS.FindKey([LPairName]) then
            CDS.InsertRecord([LPairName, LPairValue]);
      end;
    end;

    if not CDS.IsEmpty then
      AtualizarParametros(CDS);
  finally
    LObj.Free;
    CDS.Free;
  end;
end;

function NecessarioModificarParam(pCampo, pValor: String) :Boolean;
begin
  Result := False;
  if (pCampo = '')  then
      Exit;
  try
    Result := not (GetValueJson(SecaoParametroJson, pCampo) = pValor);
  except
    on e: Exception do
      raise Exception.Create('Falha ao tentar encontrar campos nos parÃ¢metros do sistema.' + #13 + e.Message);
  end;
end;

procedure AtualizarParametros(pCDS: TClientDataSet);
var 
    LS: TStringList;
    lChave, lTabela, lCampo, lValor, lValueUpdated: String;
begin
  LS := TStringList.Create;
  try
    LS.Clear;

    pCDS.First;
    while not pCDS.Eof do
    begin
      LS.Clear;
      lChave := pCDS.FieldByName('CHAVE').AsString;
      lTabela := GetTabela(lChave);
      lCampo := GetCampoDBParametro(lChave);
      lValor := pCDS.FieldByName('VALOR').AsString;
      
      case PegarTipoCampo(lValor) of
        cTipoString: lValueUpdated := QuotedStr(Troca(lValor, '"', ''));
        cTipoInteiro,
        cTipoCurrency: lValueUpdated := lValor;
        cTipoboolean: lValueUpdated := QuotedStr(iif(LowerCase(lValor) = 'true', 'S', 'N'));
      end;

      LS.Add('update ' + lTabela);
      LS.Add('set ' + lCampo + ' = ' + lValueUpdated);

      if lTabela = cTabelaConfigSistemaEmpresa then
        LS.Add('where EMPRESA_CFSEMP = ' + IntToStr(Codigo_Empresa_Atual))
      else
      if lTabela = ctabelaConfigPCP then
        LS.Add('where CODIGO_CONFIG = ' + IntToStr(Codigo_Empresa_Atual));

      try
        ExecuteCommand(LS.Text);
      except
        on e: Exception do
          raise Exception.Create(e.Message);
      end;

      pCDS.Next;    
    end;

    Relogar;
  finally
    LS.Free;
  end;
end;

procedure Relogar;
var S, sUser, sSenha: String;
iQuebra: Integer;
begin
  DM := DMCriadoPeloNome('DMConexao');
  sUser := Nome_Usuario_Atual;
  sSenha := 'A';
  iQuebra := StrToInt(GetValueJson(SecaoAtualJson, 'Quebra'));
     
//  ExecuteCommand('update CONFIG_SISTEMA_EMPRESA set BLOQ_PEDIDO_CFSEMP = ' + QuotedStr(iif(BloqueiaPedidoAutomaticamente,'N', 'S')) + 'where CONFIG_SISTEMA_EMPRESA.EMPRESA_CFSEMP = ' + IntToStr(Codigo_Empresa_Atual));
  ExecutarMetodoDeObjeto(DM, 'ConectaServidorAplicacao', [sUser, sSenha, iQuebra]);
  //Sleep(1000);
  ExecutarMetodoDeObjeto(DM, 'CarregaSecaoAtual');
 // Sleep(2000);
end;


function PegarTipoCampo(pValue: String): Integer;
begin
  Result := -1;
  if pValue = '' then
    Exit;

  if (Pos('"', pValue) > 0) then
    Result := cTipoString
  else 
  if ((LowerCase(pValue) = 'true') or            
      (LowerCase(pValue) = 'false')) then
    Result := cTipoboolean
  else
  if (Pos('.', pValue) > 0) then
    Result :=  cTipoCurrency
  else
    Result := cTipoInteiro;              
end;

procedure CriarEstruturaParametrosAtualizar(pCDS: TClientDataSet);
begin
  pCDS.Close;
  pCDS.FieldDefs.Clear;
  pCDS.FieldDefs.Add('CHAVE', ftString, 60, false);
  pCDS.FieldDefs.Add('VALOR', ftString, 200, false);
  pCDS.CreateDataSet;
  pCDS.IndexFieldNames := 'CHAVE';
  pCDS.LogChanges := False;
end;

procedure Setup_Inicializar_Parametros;
begin
  {P39_TDD_PARAMETRO_MAPEAMENTO.}MapearParametros;

  CDSParametro := TClientDataSet.Create;
  CDSParametro.Data := ExecuteReader(GetSQLParametro);

  ExecutarMetodoDeClasse('ClassConfigSistema','TClassConfigSistema' ,'ConfigurarPropriedadesDosCampos', [CDSParametro, true]);
  ExecutarMetodoDeClasse('ClassConfigSistemaEmp','TClassConfigSistemaEmp' ,'ConfigurarPropriedadesDosCampos', [CDSParametro, true]);
  ExecutarMetodoDeClasse('ClassPCP_Config','TClassPCP_Config' ,'ConfigurarPropriedadesDosCampos', [CDSParametro, true]);
end;

procedure TearDown_FinalizarParametros;
begin
  CDSParametro.Free;    
end;