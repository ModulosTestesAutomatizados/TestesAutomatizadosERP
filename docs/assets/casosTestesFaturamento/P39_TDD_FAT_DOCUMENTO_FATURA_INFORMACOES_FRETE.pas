uses P39_TDD_FAT_DOCUMENTO_FATURA;

{$Region 'InformaÃ§Ãµes Frete/Transporte'}
procedure _InformacoesFrete;
var 
  lValorFrete, lPercFrete : currency;
  lFreteManual, lFreteEmbutido: Boolean;
begin
  lFreteManual   := ValorLogicoTagDoc('frete_manual_docped');
  lFreteEmbutido := ValorLogicoTagDoc('freteembutido_docped');
  lValorFrete    := ValorCurrencyTagDoc('valorfrete_docped');
  lPercFrete     := ValorCurrencyTagDoc('percfrete_docped');
  
  CDSPedido.FieldByName('FRETEEMBUTIDO_DOCPED').AsString := iif(lFreteEmbutido, 'S', 'N');
  CDSPedido.FieldByName('FRETE_MANUAL_DOCPED').AsString  := iif(lFreteManual, 'S', 'N');
  
  if lFreteManual then
  begin
    CDSPedido.FieldByName('PERCFRETE_DOCPED').AsCurrency := 0;
    CDSPedido.FieldByName('VALORFRETE_DOCPED').AsCurrency := lValorFrete;
  end
  else
  begin
    CDSPedido.FieldByName('PERCFRETE_DOCPED').AsCurrency := lPercFrete;
    //CDSPedido.FieldByName('VALORFRETE_DOCPED').AsCurrency := 0;
  end;
  
  _InformacoesFreteFiscal;
end;

procedure _InformacoesFreteFiscal;
begin
  if not ((CDSFiscal.State = dsInsert) or (CDSFiscal.State = dsEdit)) then
    CDSFiscal.Edit;

  {
  if FTagCli = TagPessoaConsumidorNFCe then
  begin
    CDSCad.FieldByName('PARTICIONAVEL_DOCFAT').AsString := 'N';

    CDSCad.FieldByName('INDICADORPRESENCA_DOCFAT').AsInteger := 1;

    if ClassificacaoPedidoNF_NFCe > 0 then
      CDSCad.FieldByName('CLASSIFICACAO_DOCFAT').AsInteger :=
        ClassificacaoPedidoNF_NFCe;

    CDSFiscal.FieldByName('TIPOFRETE_DOCFISCAL').AsInteger := 9;
    CDSFiscal.FieldByName('TIPOFRETECT_DOCFISCAL').AsInteger := 9;
  end;
  ^}
  
  if CDSFiscal.FieldByName('TIPOFRETE_DOCFISCAL').AsInteger = 9 then
    CDSFiscal.FieldByName('PERCFRETEAUTONOMO_DOCFISCAL').AsCurrency := 0;

  if CDSFiscal.FieldByName('TIPOFRETECT_DOCFISCAL').AsInteger = 9 then
    CDSFiscal.FieldByName('PERCFRETECT_DOCFISCAL').AsCurrency := 0;    
end;
{$endRegion}
