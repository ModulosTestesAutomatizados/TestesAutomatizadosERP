uses P39_TDD_PARAMETRO_MAPEAMENTO, P39_TDD_FUNCOES_JSON;

const
    cTipoString = 0;
    cTipoInteiro = 1;
    cTipoCurrency = 2;
    cTipoboolean = 3;

var 
 CDSParametro: TClientDataSet;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit responsável por consultar e aplicar parâmetros de configuração do sistema para os testes.'           + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'CDSParametro :TClientDataSet'                                                                                          + #13 +
    '  - Contém os parâmetros lidos no setup do lote; o teardown o libera quando foi criado.'                               + #13 +
    'cTipoString, cTipoInteiro, cTipoCurrency, cTipoboolean :Integer'                                                       + #13 +
    '  - Identificam o tipo de valor ao montar a atualização.'                                                              + #13 +
    '===================================================================================================================='  + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                   + #13 +
    'function GetSQLParametro :String'                                                                                      + #13 +
    '  - Monta a consulta das configurações de sistema, empresa e PCP.'                                                     + #13 +
    'procedure VerificarParametros(pJSONParametros :String)'                                                                + #13 +
    '  - Compara o JSON recebido e atualiza apenas chaves com valor diferente.'                                             + #13 +
    'function NecessarioModificarParam(pCampo, pValor :String) :Boolean'                                                    + #13 +
    '  - Compara o valor solicitado com a seção atual de parâmetros.'                                                       + #13 +
    'procedure AtualizarParametros(pCDS :TClientDataSet)'                                                                   + #13 +
    '  - Executa os updates solicitados e chama Relogar.'                                                                   + #13 +
    'procedure Relogar'                                                                                                     + #13 +
    '  - Reconecta e recarrega a seção atual após atualizar configurações.'                                                 + #13 +
    'function PegarTipoCampo(pValue :String) :Integer'                                                                      + #13 +
    '  - Classifica o valor para formatar a instrução SQL.'                                                                 + #13 +
    'procedure CriarEstruturaParametrosAtualizar(pCDS :TClientDataSet)'                                                     + #13 +
    '  - Prepara o dataset temporário de chaves e valores.'                                                                 + #13 +
    'procedure Setup_Inicializar_Parametros'                                                                                + #13 +
    '  - Mapeia os campos e carrega os parâmetros no dataset global.'                                                       + #13 +
    'procedure TearDown_FinalizarParametros'                                                                                + #13 +
    '  - Libera o dataset global quando foi criado.'                                                                        + #13 +
    '===================================================================================================================='  + #13 +
    'A seção parametros no JSON do caso é opcional; sua ausência não chama VerificarParametros.'                            + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('P39_TDD_PARAMETRO', lInstrucoes);
end;

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
      raise Exception.Create('Falha ao tentar encontrar campos nos parâmetros do sistema.' + #13 + e.Message);
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
  if Assigned(CDSParametro) then
    CDSParametro.Free;
end;
