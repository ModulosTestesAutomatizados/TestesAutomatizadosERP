var FModoDebug: Boolean;

procedure Main;
begin

end;

function ModoDebugAtivo: Boolean;
begin
  Result := FModoDebug;
end;

procedure MostrarLogTextoEmModoDebug(pTexto: String);
begin
  if FModoDebug then
    MostrarLogTexto(pTexto, '[DEBUG]');
end;

procedure MostrarCDSEmModoDebug(CDSDebug: TClientDataSet);
begin
  if FModoDebug then
    MostrarCDS(CDSDebug);
end;
