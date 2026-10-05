var FUsesUnits, FMetodos, FParamsCasosTeste, FUnitInterpretar :TStringList;

procedure AddItemToList(var pList: TStringList; const pValue: string);
begin
  if not Assigned(pList) then
    pList := TStringList.Create;

  pList.Add(pValue);
end;

procedure AddMetodo(pMetodo: string);
begin
  AddItemToList(FMetodos, pMetodo);
end;

procedure AddUsesUnit(pUnit: string);
begin
  AddItemToList(FUsesUnits, pUnit);
end;

procedure AddParamsRun(pParam: string);
begin
  AddItemToList(FParamsCasosTeste, pParam);
end;

procedure Executar;
var 
  lIndice :integer;
  lLS     :TStringList;
  lMetodo :string;
begin
  try
    try
      if not Assigned(FUsesUnits) then
        raise Exception.Create('Nenhuma Unit para uses informada!');

      if not Assigned(FMetodos) then
        raise Exception.Create('Nenhum metodo para executar informado!');

      if not Assigned(FParamsCasosTeste) then
        raise Exception.Create('Parametros do caso de teste nao informados!');

      if ((Trim(FUsesUnits.Text) = '') or (Trim(FUsesUnits[0]) = '')) then
        raise Exception.Create('Nenhuma Unit para uses informada! Impossível executar o teste.');

      if ((Trim(FMetodos.Text) = '') or (Trim(FMetodos[0]) = '')) then
        raise Exception.Create('Não existem métodos para serem executados! Impossível executar o teste.');

      lLS              := TStringList.Create;
      FUnitInterpretar := TStringList.Create;
      FUnitInterpretar.Clear;
      FUnitInterpretar.Add(CodificacaoUnit('TDD_BASE_UNIT_IRUNNER'));

      lLS.Clear;
      for lIndice := 0 to FMetodos.Count -1 do
      begin
        lMetodo := FMetodos[lIndice];

        CallBack_Mensagem(ClassOwner, lMetodo);
        if ((Pos('Setup', lMetodo) > 0) or (Pos('Teste', lMetodo) > 0)) then
        begin
          lLS.Add('        CallBack_Mensagem(ClassOwner, '''     + lMetodo + ''');');
          lLS.Add('        {P39_TDD_RUNNER.}RegistrarTick(0, ''' + lMetodo + ''');');
          lLS.Add('        LogDoProcessamentoAdd(''INICIOU '     + lMetodo + ''');');
          lLS.Add('        '                                     + lMetodo +    ';');
          lLS.Add('        LogDoProcessamentoAdd(''ENCERROU '    + lMetodo + ''');');
          lLS.Add('        {P39_TDD_RUNNER.}RegistrarTick(1, ''' + lMetodo + ''');');
        end
        else
        begin
          lLS.Add('        CallBack_Mensagem(ClassOwner, '''     + lMetodo + ''');');
          lLS.Add('        {P39_TDD_RUNNER.}RegistrarTick(0, ''' + lMetodo + ''');');
          lLS.Add('        LogDoProcessamentoAdd(''INICIOU '     + lMetodo + ''');');
          lLS.Add('        '                                     + lMetodo +    ';');
          lLS.Add('        LogDoProcessamentoAdd(''ENCERROU '    + lMetodo + ''');');
          lLS.Add('        {P39_TDD_RUNNER.}RegistrarTick(1, ''' + lMetodo + ''');');
        end;
//        else // Restringe apenas a Setup e Teste.
//          raise Exception.Create('Apenas os métodos de "Setup" e "Teste" são aceitos!');
      end;

      FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__USES_UNITS__', FUsesUnits.CommaText);
      FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__PARAMETROS_CASO_TESTE__', FParamsCasosTeste.CommaText);
      FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, ',', ', ');
      FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__CHAMADAS_METODOS__', lLS.Text);

      {P39_TDD_LOGS.}MostrarLogTextoEmModoDebugT(FUnitInterpretar.Text, 'FUnitInterpretar.Text - TDD_IRUNNER.Executar');

      Interpretar(FUnitInterpretar.Text);
    finally
      FUsesUnits.Free;
      FMetodos.Free;
      FParamsCasosTeste.Free;
      lLS.Free;
      FUnitInterpretar.Free;
    end;
  except
    on ex: Exception do
      raise Exception.Create(ex.Message);
  end;
end;
