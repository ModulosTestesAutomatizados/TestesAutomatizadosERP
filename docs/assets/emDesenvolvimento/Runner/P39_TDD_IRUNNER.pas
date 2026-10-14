uses P39_TDD_LOGS;

var
  FTDDUnit                            :string;
  FParamsCasosTeste, FUnitInterpretar :TStringList;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit responsável pela montagem do fluxo interpretado para uma única unit TDD.'                           + #13 +
    '====================================================================================================================' + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                  + #13 +
    'procedure SetTDDUnit(pUnit :string)'                                                                                  + #13 +
    '  - Define a unit cuja entrada Teste será chamada implicitamente para cada caso.'                                     + #13 +
    'procedure AddParamsRun(pParam :string)'                                                                               + #13 +
    '  - Adiciona módulo e área, nessa ordem, como literais Pascal.'                                                       + #13 +
    'procedure Executar'                                                                                                   + #13 +
    '  - Preenche o molde e chama Interpretar uma vez, mantendo a montagem por TStringList, CommaText e Troca.'            + #13 +
    'procedure AddItemToList(var pList :TStringList; const pValue :string)'                                                + #13 +
    '  - Método de apoio utilizado por AddParamsRun.'                                                                      + #13 +
    '====================================================================================================================' + #13 +
    'Contrato de execução:'                                                                                                + #13 +
    'Configure somente uma unit com entrada Teste sem parâmetros e informe módulo/área antes de Executar.'                 + #13 +
    'A casca controla a carga e o cursor dos casos. Esta unit monta código; não executa Teste fora de Interpretar.'        + #13 +
    'Os diagnósticos usam RegistrarLogEmModoDebug. FExibirInstrucoes controla a exibição destas instruções.'               + #13 +
    '====================================================================================================================';
  {P39_TDD_LOGS.}MostrarInstrucoesUnit('P39_TDD_IRUNNER', lInstrucoes);
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
    FUnitInterpretar.Add(CodificacaoUnit('P39_TDD_BASE_UNIT_IRUNNER'));

    lLS.Clear;
    lMetodo := 'Teste';
    lLS.Add('        {P39_TDD_LOGS.}DelimitadorLog(''' + lMetodo + ''');');
    lLS.Add('        CallBack_Mensagem(ClassOwner, '''     + lMetodo + ''');');
    lLS.Add('        {P39_TDD_RUNNER.}RegistrarTick(0, ''' + lMetodo + ''');');
    lLS.Add('        {' + FTDDUnit + '.}'                  + lMetodo +    ';');
    lLS.Add('        {P39_TDD_RUNNER.}RegistrarTick(1, ''' + lMetodo + ''');');

    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__USES_UNITS__', FTDDUnit);
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__PARAMETROS_CASO_TESTE__', FParamsCasosTeste.CommaText);
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, ',', ', ');
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__CHAMADAS_METODOS__ // Identacao incorreta propositalmente!', lLS.Text);

    {P39_TDD_LOGS.}DelimitadorLog('CÓDIGO GERADO - P39_TDD_IRUNNER.Executar');
    {P39_TDD_LOGS.}RegistrarLogEmModoDebug(FUnitInterpretar.Text);
    Interpretar(FUnitInterpretar.Text);
  finally
    lLS.Free;
    FUnitInterpretar.Free;
    FParamsCasosTeste.Free;
  end;
end;
