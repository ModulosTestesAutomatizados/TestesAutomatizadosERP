uses TDD_CARREGAR_CASO_TESTE; 

procedure Main;
var CDSCasoTeste :TClientDataSet;
begin
  CDSCasoTeste := TClientDataSet.Create;
  try
    CarregarCasoTeste(CDSCasoTeste, 'FINANCEIRO', 'BORDERÔ', 'CADASTRAR DUPLICATA A RECEBER');
    CDSCasoTeste.LogChanges := False;
    CDSCasoTeste.IndexFieldNames := 'AUTOINC_CT';   
  
    MostrarCDS(CDSCasoTeste);
  finally
    CDSCasoTeste.Free;
  end;
end;
