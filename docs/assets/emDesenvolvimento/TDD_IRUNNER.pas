var FUsesUnits, FMetodos, FUnitInterpretar :TStringList;
  
procedure AddMetodo(pMetodo :string);
begin
  if not Assigned(FMetodos)then
  begin
    FMetodos := TStringList.Create;
    FMetodos.Clear;  
  end;
  
  FMetodos.Add(pMetodo);
end;

procedure AddUsesUnit(pUnit :string);
begin
  if not Assigned(FUsesUnits)then
  begin
    FUsesUnits := TStringList.Create;
    FUsesUnits.Clear;  
  end;
  
  FUsesUnits.Add(pUnit);
end;  

procedure Executar;
var 
  lIndice :integer;
  lLS     :TStringList;
  lLinha  :string;
begin
  try
    if ((Trim(FUsesUnits.Text) = '') or (Trim(FUsesUnits[0]) = '')) then
      raise Exception.Create('Nenhuma Unit para uses informada! Impossível executar o teste.');

    if ((Trim(FMetodos.Text) = '') or (Trim(FMetodos[0]) = '')) then
      raise Exception.Create('Não existem métodos para serem executados! Impossível executar o teste.');

    lLS              := TStringList.Create;
    FUnitInterpretar := TStringList.Create;  
    try
      FUnitInterpretar.Clear;
      FUnitInterpretar.Add(CodificacaoUnit('TDD_BASE_UNIT_IRUNNER'));

      lLS.Clear;
      for lIndice := 0 to FMetodos.Count -1 do
      begin
        lLinha := FMetodos[lIndice];

        if ((Pos('Setup', lLinha) > 0) or (Pos('Teste', lLinha) > 0)) then
        begin
          lLS.Add('  CallBack_Mensagem(ClassOwner, ' + lLinha + ');');
          lLS.Add('  {P39_TDD_RUNNER.}RegistrarTick(0, ' + lLinha + ');');
          lLS.Add('  ' + lLinha + ';');
          lLS.Add('  {P39_TDD_RUNNER.}RegistrarTick(1, ' + lLinha + ');');
        end
        else // Restringe apenas a Setup e Teste.
          raise Exception.Create('Apenas os métodos de "Setup" e "Teste" são aceitos!');
      end;

      FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__USES_UNITS__', FUsesUnits.CommaText);
      FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, ',', ', ');
      FUnitInterpretar.Text := Troca(FUnitInterpretar.Text, '__CHAMADAS_METODOS__', lLS.Text);

      {P39_TDD_LOGS.}MostrarLogTextoEmModoDebugT(FUnitInterpretar.Text, 'FUnitInterpretar.Text - TDD_IRUNNER.Executar');

      Interpretar(FUnitInterpretar.Text);
    finally
      FUsesUnits.Free;
      FMetodos.Free;
      lLS.Free;
      FUnitInterpretar.Free;
    end;
  except
    on ex: Exception do
      raise Exception.Create(ex.Message);
  end;
end;
