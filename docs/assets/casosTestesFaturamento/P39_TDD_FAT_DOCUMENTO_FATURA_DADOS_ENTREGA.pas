uses P39_TDD_FAT_DOCUMENTO_FATURA;

{$Region 'Dados Para Entrega'}

procedure _DadosParaEntrega;
var 
  lEntregar: boolean;
  lDTPrevisaoFat, lDTVenda, lDTPromessaEntrega: TDateTime;
  lCampanha, iCampanha, lParceria, iParceria, lDiasEntrega: Integer;
begin
  lDTVenda           := ValorDataTagDoc('dtvenda_docped');
  lDTPromessaEntrega := ValorDataTagDoc('dtpromessaentrega_docped');
  lCampanha          := ValorInteiroTagDoc('campanha_docped');
  lParceria          := ValorInteiroTagDoc('parceria_docped');    
  lDiasEntrega       := ValorInteiroTagDoc('diasentrega_docped');
  lEntregar          := ValorLogicoTagDoc('entregarmercadoria_docfat');
  lDTPrevisaoFat     := ValorDataTagDoc('dtprevisaofaturamento_docped');
  
  CDSCad.FieldByName('ENTREGARMERCADORIA_DOCFAT').AsString := iif(lEntregar, 'S', 'N');
  
  if (lDTPrevisaoFat > 0) then
    CDSPedido.FieldByName('DTPREVISAOFATURAMENTO_DOCPED').AsDateTime := lDTPrevisaoFat;
  
  CDSPedido.FieldByName('DIASENTREGA_DOCPED').AsInteger := lDiasEntrega; 
    
  if (lDTVenda > 0) then
    CDSPedido.FieldByName('DTVENDA_DOCPED').AsDateTime := lDTVenda;
    
  if (lCampanha > 0) then
  begin
    iCampanha := ExecuteScalarP('select CODIGO_CAMPANHA from CAMPANHA where CODIGO_CAMPANHA = :CAMP', VarArrayOf([lCampanha]));
    if (iCampanha > 0) then
      CDSPedido.FieldByName('CAMPANHA_DOCPED').AsInteger := iCampanha;  
  end;    
       
  if (lDTPromessaEntrega > 0) then
    CDSPedido.FieldByName('DTPROMESSAENTREGA_DOCPED').AsDateTime := lDTPromessaEntrega;
    
  if (lParceria > 0) then   
  begin
    iParceria := ExecuteScalarP('select CODIGO_PARCERIA from PARCERIA where CODIGO_PARCERIA = :PARCERIA', VarArrayOf([lParceria]));
    if iParceria > 0 then
      CDSPedido.FieldByName('PARCERIA_DOCPED').AsInteger := iParceria;
  end;
  
  CDSCad.FieldByName('OBSERVACAO_DOCFAT').AsString := 'Documento gerado automaticamente via rotina de testes automatizados.' + #13 + 
                                                      'Caso Teste.:[' + CDSCasosTestes.FieldByName('DESCRICAO').AsString + ']';
end;

{$endRegion}
