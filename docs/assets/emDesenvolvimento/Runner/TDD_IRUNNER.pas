var
  FTDDUnit                            :string;
  FParamsCasosTeste, FUnitInterpretar :TStringList;

procedure Main();
var lInstrucoes :string;
begin
  lInstrucoes := '';
  {P39_TDD_LOGS.}MostrarInstrucoesUnit('TDD_IRUNNER', lInstrucoes);
end;

// Define a unica unit cujo Teste sera chamado por Run para cada caso.
procedure SetTDDUnit(pUnit :string);
begin
  FTDDUnit := Trim(pUnit);
end;

procedure AddItemToList(var pList: TStringList; const pValue: string);
begin
  if not Assigned(pList) then
    pList := TStringList.Create;
  pList.Add(pValue);
end;

procedure AddParamsRun(pParam :string);
begin
  AddItemToList(FParamsCasosTeste, pParam);
end;

procedure Executar;
var
  lLS     :TStringList;
  lMetodo :string;
begin
  if Trim(FTDDUnit) = '' then
    raise Exception.Create('Nenhuma Unit para uses informada! Impossivel executar o teste.');
  if not Assigned(FParamsCasosTeste) then
    raise Exception.Create('Módulo e área devem ser informados.');
  if FParamsCasosTeste.Count <> 2 then
    raise Exception.Create('Informe exatamente dois parâmetros: módulo e área.');

  lLS              := TStringList.Create;
  FUnitInterpretar := TStringList.Create;
  try
    FUnitInterpretar.Clear;
    FUnitInterpretar.Add(CodificacaoUnit('TDD_BASE_UNIT_IRUNNER'));

    lLS.Clear;
    lMetodo := 'Teste';
    lLS.Add('        CallBack_Mensagem(ClassOwner, '''     + lMetodo + ''');');
    lLS.Add('        {P39_TDD_RUNNER.}RegistrarTick(0, ''' + lMetodo + ''');');
    lLS.Add('        {' + FTDDUnit + '.}'                  + lMetodo +    ';');
    lLS.Add('        {P39_TDD_RUNNER.}RegistrarTick(1, ''' + lMetodo + ''');');

    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__USES_UNITS__', FTDDUnit);
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__PARAMETROS_CASO_TESTE__', FParamsCasosTeste.CommaText);
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, ',', ', ');
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__CHAMADAS_METODOS__ // Identacao incorreta propositalmente!', lLS.Text);

    {P39_TDD_LOGS.}MostrarLogTextoEmModoDebugT(FUnitInterpretar.Text, 'FUnitInterpretar.Text - TDD_IRUNNER.Executar');
    Interpretar(FUnitInterpretar.Text);
  finally
    lLS.Free;
    FUnitInterpretar.Free;
    FParamsCasosTeste.Free;
  end;
end;
