uses P39_TDD_ASSERTS;

{$Region 'Constantes'}
const
  cMSecsPorDia = 86400000; // 24h * 60m * 60s * 1000ms: converte TDateTime p/ ms
  cCDSDefault  = 'CDSCad'; // CDS padrao quando tag "cds" nao informada

  cOperacaoIgual = 0;
  cOperacaoMaior = 1;
  cOperacaoMenor = 2;
{$endRegion}

{$Region 'Variaveis'}
var
  FCDSMap: TStringList;          // Mapa nome -> TClientDataSet
  FDTInicioCronometro: TDateTime;
  FTempoExecucaoMs: Double;
  FErrosReais: Integer;
  
  {$Region 'Variáveis de Validação'}
    lResultadoString: String;
    lResultadoInteger: Integer;
    lResultadoCurrency: Currency;
    lResultadoData: TDateTime;
    lResultadoBoolean: Boolean;
  {$endRegion}
  
{$endRegion}

procedure Main;
begin
 
end;

{$Region 'Cronometro'}

procedure Cronometro_Iniciar;
begin
  FDTInicioCronometro := Now;
  FTempoExecucaoMs    := 0;
  FErrosReais         := 0;
  AssertsZerar;
end;

procedure Cronometro_Finalizar;
begin
  if FDTInicioCronometro = 0 then
    Exit;

  FTempoExecucaoMs := (Now - FDTInicioCronometro) * cMSecsPorDia;
end;

procedure RegistrarErroReal(pDescricao: String);
begin
  FErrosReais := FErrosReais + 1;
  LogDoProcessamentoAdd('Erro real registrado ("erro.quantidade"): ' + pDescricao);
end;
{$endRegion}

{$Region 'Comparacoes internas'}

function GetOperacao(pOperacao: String): Integer;
begin
  if pOperacao = 'Igual' then
    Result := cOperacaoIgual
  else if pOperacao = 'Maior' then
    Result := cOperacaoMaior
  else if pOperacao = 'Menor' then
    Result := cOperacaoMenor
  else
    Result := -1;
end;

function AplicarOperacaoNumerica(pOperacao: Integer; pValorReal, pValorEsperado: Currency): Boolean;
begin
  Result := False;

  if pOperacao = cOperacaoIgual then
    Result := (pValorReal = pValorEsperado)
  else if pOperacao = cOperacaoMaior then
    Result := (pValorReal > pValorEsperado)
  else if pOperacao = cOperacaoMenor then
    Result := (pValorReal < pValorEsperado);
end;

function OperacaoDescricao(pOperacao: Integer): String;
begin
  if pOperacao = cOperacaoIgual then
    Result := 'igual a'
  else if pOperacao = cOperacaoMaior then
    Result := 'maior que'
  else if pOperacao = cOperacaoMenor then
    Result := 'menor que'
  else
    Result := '(operacao invalida)';
end;
{$endRegion}

{$Region 'Comparacao por secao do JSON'}

procedure CompararQuantidadeErros(pJSON: String);
var
  lQtdEsperada: Integer;
  lOperacao: Integer;
  lMensagem: String;
begin
  ShowMessage('Comparando com erro....');
  lQtdEsperada := ValorInteiroTag(pJSON, 'quantidade', -1);
  lOperacao    := GetOperacao(ValorStringTag(pJSON, 'operacao'));

  if lQtdEsperada < 0 then
  begin
    RegistrarResultado(false, 'Quantidade de erros informada na validação inválida: "Quantidade informada: ' + IntToStr(lQtdEsperada) + '"');
    Exit;  
  end;
    
  lMensagem := 'erro.quantidade: esperado ' + OperacaoDescricao(lOperacao) + ' ' +
    IntToStr(lQtdEsperada) + ', obtido ' + IntToStr(FErrosReais) + '.';

  if lOperacao = cOperacaoIgual then
    AssertIgualInteiro(lQtdEsperada, FErrosReais, 'erro.quantidade')
  else
    AssertVerdadeiro(AplicarOperacaoNumerica(lOperacao, FErrosReais, lQtdEsperada), lMensagem);

  ShowMessage('Finalizando comparação com erro....');  
end;

procedure LimparVariaveis;
begin
  lResultadoString := '';
  lResultadoInteger := 0;
  lResultadoCurrency := 0;
  lResultadoData := 0;
  lResultadoBoolean := False;
end;

procedure CompararCampoPorTipo(pTipoCampo, pValorReal, pValorEsperado: String; pOperacao: Integer; pCampoNome: String);
var
  lRealInt: Integer;
  lEsperadoInt: Integer;
  lRealCurr: Currency;
  lEsperadoCurr: Currency;
  lRealDate: TDateTime;
  lEsperadoDate: TDateTime;
  lRealBool: Boolean;
  lEsperadoBool: Boolean;
  lMensagem: String;
begin
  Result := True;
  lMensagem := pCampoNome + ': esperado ' + OperacaoDescricao(pOperacao) + ' ' + pValorEsperado + ', obtido ' + pValorReal + '.';

  try
    { --- ftString --- }
    if pTipoCampo = 'ftString' then
    begin
      if pOperacao = cOperacaoIgual then
        AssertIgual(pValorEsperado, pValorReal, lMensagem)
      else
        AssertFalhou('CompararCampoPorTipo', 'ftString nÃ£o suporta operaÃ§Ã£o Maior/Menor.');
    end

    { --- ftInteger --- }
    else if pTipoCampo = 'ftInteger' then
    begin
      lRealInt    := StrToIntDef(pValorReal, 0);
      lEsperadoInt := StrToIntDef(pValorEsperado, 0);

      if pOperacao = cOperacaoIgual then
        AssertIgualInteiro(lEsperadoInt, lRealInt, lMensagem)
      else if pOperacao = cOperacaoMaior then
        AssertVerdadeiro(lEsperadoInt > lRealInt, lMensagem)
      else if pOperacao = cOperacaoMenor then
        AssertVerdadeiro(lEsperadoInt < lRealInt, lMensagem);
    end

    { --- ftCurrency --- }
    else if pTipoCampo = 'ftCurrency' then
    begin
      lRealCurr    := ConverterParaCurrency(pValorReal, pTipoCampo);
      lEsperadoCurr := ConverterParaCurrency(pValorEsperado, pTipoCampo);

      if pOperacao = cOperacaoIgual then
        AssertIgualMoeda(lEsperadoCurr, lRealCurr, lMensagem)
      else if pOperacao = cOperacaoMaior then
        AssertVerdadeiro(lEsperadoCurr > lRealCurr, lMensagem)
      else if pOperacao = cOperacaoMenor then
        AssertVerdadeiro(lEsperadoCurr < lRealCurr, lMensagem);
    end

    { --- ftDateTime --- }
    else if pTipoCampo = 'ftDateTime' then
    begin
      lRealDate    := _StrToDateTimeDef(pValorReal, 0);
      lEsperadoDate := _StrToDateTimeDef(pValorEsperado, 0);

      if pOperacao = cOperacaoIgual then
        AssertVerdadeiro(lEsperadoDate = lRealDate, lMensagem)
      else if pOperacao = cOperacaoMaior then
        AssertVerdadeiro(lEsperadoDate > lRealDate, lMensagem)
      else if pOperacao = cOperacaoMenor then
        AssertVerdadeiro(lEsperadoDate < lRealDate, lMensagem);
    end

    { --- ftBoolean --- }
    else if pTipoCampo = 'ftBoolean' then
    begin
      lRealBool    := (LowerCase(Trim(pValorReal)) = 'true') or (LowerCase(Trim(pValorReal)) = 's');
      lEsperadoBool := (LowerCase(Trim(pValorEsperado)) = 'true') or (LowerCase(Trim(pValorEsperado)) = 's');

      if pOperacao = cOperacaoIgual then
        AssertVerdadeiro(lEsperadoBool = lRealBool, lMensagem)
      else
        AssertFalhou('CompararCampoPorTipo', 'ftBoolean não suporta operação Maior/Menor.');
    end
    else
      AssertFalhou('CompararCampoPorTipo', 'Tipo de campo não suportado: ' + pTipoCampo)

  except
    on E: Exception do
    begin
      AssertFalhou('CompararCampoPorTipo', 'Erro ao comparar campo ' + pCampoNome + ': ' + E.Message);
      Result := False;
    end;
  end;
end;

procedure CompararValor(pJSONItem: String);
var
  lCDSNome, lCampo, lDataSetName, lDMNome: String;
  lOperacao, I: Integer;
  lResultado, lTipoCampo: String;
  lCDS: TClientDataSet;
  lReal: Currency;
  lMensagem: String;
  lDM: TDataModule;
  LField: TField;
begin
  LogDoProcessamentoAdd('Comparando Valores Específicos'); 
  LimparVariaveis;
  
  lCampo     := GetValueJsonDef(pJSONItem, 'campo', '');
  lOperacao  := GetOperacao(GetValueJsonDef(pJSONItem, 'operacao', '-1'));
  lTipoCampo := GetValueJsonDef(pJSONItem, 'tipo_campo', 'ftString');
  lResultadoString := {P39_TDD_FUNCOES_JSON}ValorStringTag(pJSONItem, 'resultado');
  
  if lCampo = '' then
  begin
    AssertFalhou('Valor', '(campo nao informado).');
    Exit;
  end;

  if lTipoCampo = '' then
  begin
    AssertFalhou('Tipo Campo', '(tipo do campo nao informado).');
    Exit;
  end;
  
  if (lTipoCampo = 'ftString') and (lOperacao <> cOperacaoIgual) then
  begin
    AssertFalhou('tipo Campo', 'Campo String a operação deve ser Igual');
    Exit;
  end;

  if lOperacao = -1 then
  begin
    AssertFalhou('Valor', '(Operação -1 Inválida).');
    Exit;
  end;  

  ScriptDeTestesEmExecucao := False;
  //MostrarLogTexto(FDataSets.Text);
  for I := 0 to FDataSets.Count -1 do
  begin
    lDataSetName := FDataSets[I];
    lDMNome := CorteApos(lDataSetName, '|');
    lCDSNome := CorteAte(lDataSetName, '|');

   // ShowMessage('DM: ' + lDMNome + #13 + 'CDS: ' + lCDSNome);
    
    if (lDMNome <> '') and not Assigned(lDM) then
      lDM := DMCriadoPeloNome(lDMNome);
 
    try
      lCDS := lDM.FindComponent(lCDSNome);
    
      if not Assigned(lCDS) then
        raise exception.create('Dataset não encontrado ou não informado incorretamente.')
    except
      on e: Exception do
      begin
        AssertsFalhou('DataSet ' + lCDSNome + ' Inválido', E.Message);
        Continue;
      end;  
    end;
   
    //MostrarCDS(lCDS);  
    
    LField := lCDS.FindField(lCampo);
    if (LField = nil) then
      Continue;
      
    if lOperacao = cOperacaoIgual then
      AssertIgual(lResultadoString, 
                    lCDS.FieldByName(lCampo).AsString, 
                    lCDS.FieldByName(lCampo).FieldName + '(' +  lCDS.FieldByName(lCampo).AsString + ') = (' + lResultado + ')')
    else
      CompararCampoPorTipo(lTipoCampo, 
                           lCDS.FieldByName(lCampo).AsString,
                           lResultadoString,
                           lOperacao,
                           lCampo);

    break;                                            
   
  end;
end;

procedure CompararValores(pJSON: String);
var
  lArrayValor: TJSONArray;
  I: Integer;
  lItemJSON: String;
begin 
  lArrayValor := TJSONArray(TryParseJSONValue(GetArrayJsonOrEmpty(pJSON, '')));
  if lArrayValor.Count = 0 then
  begin
    AssertFalhou('Valor','Valores de Resultado esperádo não informados.');  
    Exit;
  end;
  
  for I := 0 to lArrayValor.Count -1 do
    CompararValor(lArrayValor.Items(I).ToJson);
end;

procedure CompararTempo(pJSON: String);
var
  lSecaoTempo: String;
  lLimite: Integer;
  lTipoRegistro: String;
  lFatorMs: currency;
  S: String;
begin
  if FDTInicioCronometro = 0 then
    Exit;

  lSecaoTempo := GetObjectJson(pJSON, 'tempo');
  if lSecaoTempo = '' then
    Exit;

  lLimite       := StrToIntDef(GetValueJsonDef(lSecaoTempo, 'tempo_total', '-1'), -1);
  lTipoRegistro := GetValueJson(lSecaoTempo, 'tipo_registo');

  if (lLimite <= 0) or (FTempoExecucaoMs <= 0) then
    Exit;

  lFatorMs := 1;
  S := LowerCase(Trim(lTipoRegistro));

  if Pos('milisegundo', S) > 0 then
    lFatorMs := 1
  else if Pos('minuto', S) > 0 then
    lFatorMs := 60000
  else if Pos('segundo', S) > 0 then
    lFatorMs := 1000;

  AssertVerdadeiro(FTempoExecucaoMs <= (lLimite * lFatorMs),
    'tempo: limite de ' + CurrToStr(lLimite * lFatorMs) + ' ms, obtido ' +
    CurrToStr(FTempoExecucaoMs) + ' ms.');
end;
{$endRegion}

{$Region 'Orquestracao principal'}

procedure FinalizarComparacao(pValidado: Boolean);
begin
  LogDoProcessamentoAdd('==================================================');

  if pValidado then
    LogDoProcessamentoAdd('Caso de Teste [' + CDSCasosTestes.FieldByName('ID').AsString + ' - ' + CDSCasosTestes.FieldByName('DESCRICAO').AsString + 
      ']: resultado esperado VALIDADO sem divergencias.')
  else
  begin
    LogDoProcessamentoAdd('Caso de Teste [' + CDSCasosTestes.FieldByName('ID').AsString + ' - ' + CDSCasosTestes.FieldByName('DESCRICAO').AsString + 
      ']: DIVERGENCIAS ENCONTRADAS');
    LogDoProcessamentoAdd(AssertsResumo);

    //EnviarMensagemInterna(Nome_Usuario_Atual,
    //  'Teste Automatizado - Divergencias!',
    //  'Caso de Teste [' + CDSCasosTestes.FieldByName('CASOTESTE').AsString + ']:' + #13 + AssertsResumo);
  end;

  LogDoProcessamentoAdd('==================================================');
  
  ScriptDeTestesEmExecucao := False;
  MostrarLogTexto(AssertsResumo);
  MostrarLogTexto(LogDoProcessamento, True);
end;

procedure CompararComJSON(pJSON: String);
var
  LObj: TJSONObject;
  LAsserts: Boolean;
  I: Integer;
  LPair: TJSONPair;
  LPairName: String;
begin
  AssertsZerar;
  LAsserts := AssertsOk; 
  try
    if Trim(pJSON) = '' then
    begin
      AssertFalhou('JSON', 'de resultado esperado vazio para o caso de teste [' +
      CDSCasosTestes.FieldByName('ID').AsString + '].');
      Exit;
      // Verificar
    end;

    LObj := TJSONObject.ParseJSONValue(pJSON);
    try
      for I := 0 to LObj.Count -1 do
      begin
        LPair := ExecutarMetodoDeObjeto(LObj, 'GetPair', [I]);
        LPairName := GetPairName(LPair);

        if (LPairName = 'erro') then
          CompararQuantidadeErros(GetObjectJson(LObj.ToJson, 'erro'))
        else if (LPairName = 'valor') then
          CompararValores(GetArrayJsonOrEmpty(LObj.ToJson, 'valor'))  
        else if (LPairName = 'tempo') then
          CompararTempo(GetObjectJson(LObj.ToJson, 'tempo'));
      end;
    finally
      LObj.Free;  
    end;
  finally
    FinalizarComparacao(AssertsOk);
  end;
end;

Procedure CompararResultadoEsperado;
var lJSON: String;
begin
  lJSON := '';
  if CDSResultadoEsperado.FindKey([CDSCasosTestes.FieldByName('ID').AsInteger]) then
    lJSON := CDSResultadoEsperado.FieldByName('RESULTADO_ESPERADO').AsString;

  CompararComJSON(lJSON);
end;
{$endRegion}

function ConverterParaCurrency(pValor: String; pTipoCampo: String): Currency;
begin
  Result := 0;

  try
    if pTipoCampo = 'ftCurrency' then
      Result := StrToCurrDef(StringReplace(pValor, '.', ',', [rfReplaceAll]), 0)
    else if pTipoCampo = 'ftInteger' then
      Result := StrToIntDef(pValor, 0)
    else if pTipoCampo = 'ftBoolean' then
    begin
      if (LowerCase(Trim(pValor)) = 'true') or (LowerCase(Trim(pValor)) = 's') then
        Result := 1
      else
        Result := 0;
    end
    else
      Result := StrToCurrDef(StringReplace(pValor, '.', ',', [rfReplaceAll]), 0);
  except
    Result := 0;
  end;
end;

function _StrToDateTimeDef(pValor: String; pDefault: TDateTime): TDateTime;
begin
  Result := pDefault;

  try
    if Trim(pValor) <> '' then
      Result := StrToDateTime(pValor);
  except
    Result := pDefault;
  end;
end;
