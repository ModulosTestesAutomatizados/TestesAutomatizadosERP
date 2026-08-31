uses P39_TDD_CONSTANTES, P39_TDD_ODBC, P39_TDD_FUNCOES_JSON, P39_TDD_ASSERTS;

procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes := 'Unit genérica para validação de resultados de casos de teste.' + #13 +
    'Fornece funções de comparação por tipo de campo e orquestração de asserts.' + #13 + #13 +
    'Métodos disponíveis:' + #13 +
    ' - function CompararCampoPorTipo(pTipoCampo, pValorReal, pValorEsperado, pOperacao, pCampoNome: String): Boolean;' + #13 +
    '   + Compara valores de acordo com o tipo do campo (String, Integer, Currency, DateTime, Boolean).' + #13 +
    '   + Parâmetros:' + #13 +
    '     * pTipoCampo: Tipo do campo (ftString, ftInteger, ftCurrency, ftDateTime, ftBoolean)' + #13 +
    '     * pValorReal: Valor obtido do DataSet' + #13 +
    '     * pValorEsperado: Valor esperado (do JSON)' + #13 +
    '     * pOperacao: Operação de comparação (Igual, Maior, Menor)' + #13 +
    '     * pCampoNome: Nome do campo (para mensagem de erro)' + #13 + #13 +
    ' - function ObterValorCampoFormatado(pCDS: TClientDataSet; pCampo: String; pTipoCampo: String): String;' + #13 +
    '   + Obtém o valor do campo formatado como String de acordo com o tipo.' + #13 +
    '   + Parâmetros:' + #13 +
    '     * pCDS: TClientDataSet fonte' + #13 +
    '     * pCampo: Nome do campo' + #13 +
    '     * pTipoCampo: Tipo do campo (ftString, ftInteger, ftCurrency, ftDateTime, ftBoolean)' + #13 + #13 +
    ' - function ConverterParaCurrency(pValor: String; pTipoCampo: String): Currency;' + #13 +
    '   + Converte String para Currency de acordo com o tipo do campo.';
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_VALIDAR_GENERICO');
end;

{ ---------------------------------------------------------------------------
  Função genérica de comparação por tipo de campo
  Retorna True se a comparação foi válida, False caso contrário.
  Emite Assert automaticamente quando a comparação falha.
--------------------------------------------------------------------------- }
function CompararCampoPorTipo(
  pTipoCampo: String;
  pValorReal: String;
  pValorEsperado: String;
  pOperacao: Integer;
  pCampoNome: String
): Boolean;
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
      begin
        AssertFalhou('CompararCampoPorTipo', 'ftString não suporta operação Maior/Menor.');
        Result := False;
      end;
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
      lRealDate    := StrToDateTimeDef(pValorReal, 0);
      lEsperadoDate := StrToDateTimeDef(pValorEsperado, 0);

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
      begin
        AssertFalhou('CompararCampoPorTipo', 'ftBoolean não suporta operação Maior/Menor.');
        Result := False;
      end;
    end

    else
    begin
      AssertFalhou('CompararCampoPorTipo', 'Tipo de campo não suportado: ' + pTipoCampo);
      Result := False;
    end;

  except
    on E: Exception do
    begin
      AssertFalhou('CompararCampoPorTipo', 'Erro ao comparar campo ' + pCampoNome + ': ' + E.Message);
      Result := False;
    end;
  end;
end;

{ ---------------------------------------------------------------------------
  Obtém o valor do campo formatado como String
--------------------------------------------------------------------------- }
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

{ ---------------------------------------------------------------------------
  Converte String para Currency de acordo com o tipo do campo
--------------------------------------------------------------------------- }
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

{ ---------------------------------------------------------------------------
  Converte String para DateTime com fallback
--------------------------------------------------------------------------- }
function StrToDateTimeDef(pValor: String; pDefault: TDateTime): TDateTime;
begin
  Result := pDefault;

  try
    if Trim(pValor) <> '' then
      Result := StrToDateTime(pValor);
  except
    Result := pDefault;
  end;
end;
