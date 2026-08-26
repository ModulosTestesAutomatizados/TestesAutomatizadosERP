function TagExiste(pJson, pTag: String):Boolean;
var lValue: String;
begin
  Result := False;

  if (Trim(pJson) = '') or (Trim(pTag) = '') then
    Exit;

  try
    lValue := GetValueJson(pJson, pTag);
    Result := (lValue <> '');
  except
    Result := False;
  end;
end;

function ValorInteiroTag(pJson, pTag: String; pDefault: Integer): Integer;
var I: Integer;
begin
  Result := pDefault; 

  try
    I := StrToInt(ValorStringTag(pJson, pTag));
    Result := I;
  except
    // Engolir Erro
  end;
end;

function ValorCurrencyTag(pJson, pTag: String; pDefault: Currency):Currency;
begin
  Result := pDefault;

  Result :=  StrToCurrDef(Troca(ValorStringTag(pJson, pTag), '.', ','), pDefault);
end;

function ValorLogicoTag(pJson, pTag: String; pDefault: Boolean): Boolean;
var
  S: String;
begin
  Result := pDefault;

  S := LowerCase(Trim(ValorStringTag(pJson, pTag)));

  if S = '' then
    Exit;

  if (S = 'false') or (S = 'n') then
    Result := False
  else if (S = 'true') or (S = 's') then
    Result := True;
end;

function ValorDataTag(pJson, pTag: String): TDateTime;
begin
  Result := 0;
  try
    Result := StrToDateTime(ValorStringTag(pJson, pTag));  
  except
    Result := 0;
  end;
end;

function ValorStringTag(pJson, pTag: String):String;
begin
  Result := '';

  if not TagExiste(pJson, pTag) then
    Exit;

  try
    Result := GetValueJson(pJson, pTag);  
  except
    Result := '';
  end;
end;

function GetPairName(pPair: TJSONPair): String;
begin
  Result := '';
  if not Assigned(pPair) then
    Exit;

  Result := ExecutarMetodoDeObjeto(pPair, 'ToJSON');
  Result := Troca(Result, '"', '');
  Result := CorteAte(Result, ':');
end;

function GetPairValue(pPair: TJSONPair):String;
begin
  Result := '';

  if not Assigned(pPair) then
    Exit;

  Result := ExecutarMetodoDeObjeto(pPair, 'ToJSON');
  Result := CorteApos(Result, ':');
end;