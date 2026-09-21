uses P39_TDD_ASSERTS;

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
        AssertFalhou('CompararCampoPorTipo', 'ftString nÃÂ£o suporta operaÃÂ§ÃÂ£o Maior/Menor.');
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
        AssertFalhou('CompararCampoPorTipo', 'ftBoolean nÃ£o suporta operaÃ§Ã£o Maior/Menor.');
    end
    else
      AssertFalhou('CompararCampoPorTipo', 'Tipo de campo nÃ£o suportado: ' + pTipoCampo)

  except
    on E: Exception do
    begin
      AssertFalhou('CompararCampoPorTipo', 'Erro ao comparar campo ' + pCampoNome + ': ' + E.Message);
      Result := False;
    end;
  end;
end;

function ObterValorCampoFormatado(
  pCDS: TClientDataSet;
  pCampo: String;
  pTipoCampo: String
): String;
begin
  Result := '';

  if not Assigned(pCDS) then
    Exit;

  if pCDS.FindField(pCampo) = nil then
    Exit;

  if pTipoCampo = 'ftString' then
    Result := pCDS.FieldByName(pCampo).AsString
  else if pTipoCampo = 'ftInteger' then
    Result := IntToStr(pCDS.FieldByName(pCampo).AsInteger)
  else if pTipoCampo = 'ftCurrency' then
    Result := CurrToStr(pCDS.FieldByName(pCampo).AsCurrency)
  else if pTipoCampo = 'ftDateTime' then
  begin
    if pCDS.FieldByName(pCampo).IsNull then
      Result := ''
    else
      Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', pCDS.FieldByName(pCampo).AsDateTime);
  end
  else if pTipoCampo = 'ftBoolean' then
  begin
    if pCDS.FieldByName(pCampo).AsBoolean then
      Result := 'true'
    else
      Result := 'false';
  end
  else
    Result := pCDS.FieldByName(pCampo).AsString;
end;

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
