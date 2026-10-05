uses P39_TDD_FAT_DOCUMENTO_FATURA;

{$Region 'Financeiro'}

procedure _Financeiro;
var
  lFinanceira, lBanco: Integer;
  iFinanceira, iBanco: Integer;
begin
  lFinanceira := ValorInteiroTagDoc('financeira_docfat');
  lBanco      := ValorInteiroTagDoc('banco_docfat');
  
  if lFinanceira > 0 then
  begin
    iFinanceira := {P95_TDD_DOCUMENTO_FATURA_SQL}GetPessoaPeloCod(lFinanceira);//ExecuteScalarP('select CODIGO_PESSOA from PESSOA where CODIGO_PESSOA = :PSSOA', VarArrayOf([lFinanceira]));
    
    if iFinanceira > 0 then
      CDSCad.FieldByName('FINANCEIRA_DOCFAT').AsInteger := iFinanceira;
      
    //Sleep(250);        
  end;
  
  if lBanco > 0 then
  begin
    iBanco := ExecuteScalarP('select CODIGO_BANCO from BANCO where CODIGO_BANCO = :BC', VarArrayOf([lBanco]));    
  
    if lBanco > 0 then
      CDSCad.FieldByName('BANCO_DOCFAT').AsInteger := iBanco;  
  
    //Sleep(250);
  end;  
end;


{$endRegion}
