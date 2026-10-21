uses TDD_RUN_LOGS;

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
    'Os diagnósticos usam RegistrarLog. FExibirInstrucoes controla a exibição destas instruções.'                          + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_RUN_IRUNNER', lInstrucoes);
end;

// Define a única unit cujo Teste será chamado por Run para cada caso.
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
  lLS, lLogsMontagem,
  lLogsAnteriores :TStringList;
  lMetodo,
  lLogsPreparacao :string;
begin
  if Trim(FTDDUnit) = '' then
    raise Exception.Create('Nenhuma Unit para uses informada! Impossível executar o teste.');
  if not Assigned(FParamsCasosTeste) then
    raise Exception.Create('Módulo e área devem ser informados.');
  if FParamsCasosTeste.Count <> 2 then
    raise Exception.Create('Informe exatamente dois parâmetros: módulo e área.');

  {P39_TDD_RUN_LOGS}SetterFlags;

  lLS              := TStringList.Create;
  lLogsMontagem    := TStringList.Create;
  lLogsAnteriores  := FLogsCasoTeste;
  FUnitInterpretar := TStringList.Create;
  try
    // A preparação pertence somente a esta chamada de Executar.
    FLogsCasoTeste := lLogsMontagem;

    FUnitInterpretar.Clear;
    FUnitInterpretar.Add(CodificacaoUnit('TDD_RUN_UNIT_BASE_IRUNNER'));

    lLS.Clear;
    lMetodo := 'Teste';
    lLS.Add('        {P39_TDD_RUN_LOGS.}DelimitadorLog('''     + lMetodo + ''');');
    lLS.Add('        CallBack_Mensagem(ClassOwner, '''         + lMetodo + ''');');
    lLS.Add('        {P39_TDD_RUN_RUNNER.}RegistrarTick(0, ''' + lMetodo + ''');');
    lLS.Add('        {' + FTDDUnit + '.}'                      + lMetodo +    ';');
    lLS.Add('        {P39_TDD_RUN_RUNNER.}RegistrarTick(1, ''' + lMetodo + ''');');

    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__USES_UNITS__', FTDDUnit);
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__MODO_DEBUG__', iif(FModoDebug, 'True', 'False'));
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__EXIBIR_INSTRUCOES__', iif(FExibirInstrucoes, 'True', 'False'));
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__PARAMETROS_CASO_TESTE__', FParamsCasosTeste.CommaText);
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, ',', ', ');
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__CHAMADAS_METODOS__ // Identacao incorreta propositalmente!', lLS.Text);

    {P39_TDD_RUN_LOGS.}DelimitadorLog('CÓDIGO GERADO - TDD_RUN_IRUNNER.Executar');
    // Exibe o código sem incorporar a própria cópia de logs recursivamente.
    {P39_TDD_RUN_LOGS.}RegistrarLog(Troca(FUnitInterpretar.Text, '__LOGS_PREPARACAO__', ''''''));

    lLogsPreparacao       := QuotedStr(FLogsCasoTeste.Text);
    // Literais consecutivos evitam uma expressão com centenas de somas no interpretador.
    lLogsPreparacao       := Troca(lLogsPreparacao, #13, '''#13''');
    lLogsPreparacao       := Troca(lLogsPreparacao, #10, '''#10''');
    FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__LOGS_PREPARACAO__', lLogsPreparacao);

    // Main cria a lista do lote; somente o texto da preparação é transferido.
    Interpretar(FUnitInterpretar.Text);
  finally
    FLogsCasoTeste := lLogsAnteriores;
    lLogsMontagem.Free;
    lLS.Free;
    FUnitInterpretar.Free;
    FParamsCasosTeste.Free;
  end;
end;
