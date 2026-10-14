uses P39_TDD_FAT_DOCUMENTO_FATURA;

{$Region 'Dados Faturamento'}
procedure _DadosFaturamento;
var  lTransacao: Integer;
begin
  lTransacao := ValorInteiroTagDoc('transacao_docfat');
  
  if lTransacao = 0 then
  else if (FCDSConfigFaturamentoCasoTeste.FieldByName('PEDIDO_VENDA_FATCONFIG').AsInteger > 0) then
    lTransacao := FCDSConfigFaturamentoCasoTeste.FieldByName('PEDIDO_VENDA_FATCONFIG').AsInteger
  else
    lTransacao := StrToInt(GetValueJson(SecaoParametroJson, 'TransacaoVenda'));

  CDSCad.FieldByName('TRANSACAO_DOCFAT').AsInteger := lTransacao;    
end;
{$endRegion}