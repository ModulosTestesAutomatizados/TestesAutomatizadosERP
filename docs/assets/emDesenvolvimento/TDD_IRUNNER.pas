var
  FQuantidadeTotalEtapas :integer;
  FUnit                  :string;
  FMetodosExecutar       :TStringList;
  
procedure Add(pMetodo :string);
begin
  if not Assigned(Metodos)then
  begin
    Metodos := TStringList.Create;
    Metodos.Clear;  
  end;
  
  Metodos.Add(pMetodo);
end;

procedure AddUnit(pUnit :string);
begin
  FUnit := pUnit;
end;  

procedure Executar;
var 
  I: Integer;
  LS: TStringList;
  Linha: String;
begin
  if Trim(FUnit) = '' then
    raise Exception.Create(MensagemPersonalizada + 'Unit Não Informada!');

  if Trim(Metodos.Text) = '' then
    raise Exception.Create(MensagemPersonalizada + 'Metodos para Executar Não incluídos!');

  LS := TStringList.Create; 
  try
    LS.Clear;
    LS.Add('unit EXECUCAO_TDD;');
    LS.Add('uses ' + FUnit + ';');
    LS.Add('procedure main;'#13'begin');
    for I := 0 to Metodos.Count -1 do
    begin
      //
      Linha := Metodos[I];
      
      if Pos('Setup', Linha) > 0 then
      begin
        //
        LS.Add(Linha + ';');
        //  
      end
      else if Pos('Teste', Linha) > 0 then
      begin
        //
        LS.Add(Linha + ';');
        //
      end;    
      //  
    end;
    
    LS.Add('end;');
    LS.Add('end.');
    
    MostrarLogTexto(LS.Text);
    
    Interpretar(LS.Text);
  finally
    Metodos.Free;
    LS.Free;
  end;
  
end;
