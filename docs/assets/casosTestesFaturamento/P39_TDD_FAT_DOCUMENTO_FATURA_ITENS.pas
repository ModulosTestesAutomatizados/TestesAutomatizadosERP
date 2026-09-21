uses P39_TDD_FAT_DOCUMENTO_FATURA, P39_TDD_DOCUMENTO_FATURA_SQL;

procedure Main;
begin

end;

procedure _CriarEstruturaItens(pCDS: TClientDataSet);
begin
  pCDS.Close;
  pCDS.FieldDefs.Clear;
  pCDS.FieldDefs.Add('ITEM', ftInteger, 0, False);
  pCDS.FieldDefs.Add('VAR', ftInteger, 0, False);
  pCDS.FieldDefs.Add('COR', ftInteger, 0, False);
  pCDS.FieldDefs.Add('ACAB', ftInteger, 0, False);
  pCDS.FieldDefs.Add('QTD', ftCurrency, 0, False);
  pCDS.FieldDefs.Add('VALOR', ftCurrency, 0, False);
  pCDS.FieldDefs.Add('DESCONTO', ftString, 50, False);
  pCDS.CreateDataSet;
  pCDS.IndexFieldNames := 'ITEM;VAR;COR;ACAB';
end;

// ValidaÃ§Ãµes de Item para ser IncluÃ­das aqui.
function ItemValido(pItem, pVar, pCor, pAcab: Integer):Boolean;
begin
  Result := False;
  
  if (pItem <= 0) then
    Exit;
  
  //Fat Por Unidade Fabril.  
    
end;

procedure Itens_Incluir;
var 
  lArrayItens: TJSONArray;
  lItemConfig, lItemEspec, lDesconto: String;
  lQuantidade, lValor: Currency;
  I, lItem, lVar, lCor, lAcab, iTagProd: Integer;
  lJSONItem: TJSONObject;
  CDS: TClientDataSet;
begin
  iTagProd := StrToInt(GetValueJsonDef(FJSONITEMCONF, 'tag_prodcomum', '0'));  

  lArrayItens := TJSONArray(TryParseJSONValue(GetArrayJsonOrEmpty(FJSONITEMCONF, 'itens')));
  
  try
    if (lArrayItens.Count > 0) then // Possui Itens EspecÃ­ficos
    begin
      CDS := TClientDataSet.Create;
      try
        _CriarEstruturaItens(CDS);
          
        for I := 0 to lArrayItens.Count -1 do
        begin
          lJSONItem := GetObjectJson(lArrayItens.Items(I).ToJson, '');
          
          lItem := StrToInt(GetValueJsonDef(lJSONItem, 'item', '0'));
          
          if (lItem = 0) then
            Continue;
          
          lVar  := StrToInt(GetValueJsonDef(lJSONItem, 'variacao', '0'));
          lCor  := StrToInt(GetValueJsonDef(lJSONItem, 'cor', '0'));
          lAcab := StrToInt(GetValueJsonDef(lJSONItem, 'acabamento', '0'));
          
          // Valor
          lValor := StrToCurr(Troca(GetValueJsonDef(lJSONItem ,'valor', '0'), '.', ','));  
          
          if (lValor = 0) then
            lValor := StrToCurr(Troca(GetValueJsonDef(FJSONITEMCONF ,'valor', '0'), '.', ','));
          
          if lValor = 0 then
            lValor := _GetVlrItem; // Atribui Randomicamente      
          // Fim AtribuiÃ§Ã£o de Valor
          
          // Quantidade
          lQuantidade := StrToCurr(Troca(GetValueJsonDef(lJSONItem ,'quantidade', '0'), '.', ','));
          
          if lQuantidade = 0 then
            lQuantidade := StrToCurr(Troca(GetValueJsonDef(FJSONITEMCONF ,'quantidade', '0'), '.', ','));
            
          if lQuantidade = 0 then
            lQuantidade := _GetQuantidadeItem; // Pega quantidade Randomicamente  
          // Fim Atribuicao Quantidade
          
          lDesconto := GetValueJsonDef(lJSONItem ,'desconto', '0');
          
          CDS.InsertRecord([lItem, lVar, lCor, lAcab, lQuantidade, lValor, lDesconto]);
          //_IncluiItemEspecifico(lItem, lVar, lCor, lAcab, lQuantidade, lValor, lDesconto);
        end;
        
        _IncluirItensDocumento(CDS);     
      finally
        CDS.Free;
      end;
 
    end
    else if (iTagProd > 0) then // vai tentar via Tag Item Global
      _IncluiItensPorTag(iTagProd)
    else
      AssertsFalhou('Itens InvÃ¡lidos', 'Itens nÃ£o existentes!')  
       
  finally
    if Assigned(lArrayItens) then
      lArrayItens.Free;
  end;
end;

procedure _IncluiItensPorTag(const pTagProduto: Integer);
var 
  lQuantidade, lValor: Currency;
  lDesconto: String;
  lQuantidadeTotalItens: Integer;
  CDS: TClientDataSet;
begin
  lQuantidadeTotalItens := 0;

  FCDSProdutos.Data := BuscaDadosProdutos(pTagProduto, lQuantidadeTotalItens);

  if FCDSProdutos.IsEmpty then
    Exit;

  CDS := TClientDataSet.Create;
  try
    _CriarEstruturaItens(CDS);
    
    lQuantidade := StrToCurr(Troca(GetValueJsonDef(FJSONITEMCONF ,'quantidade', '0'), '.', ','));
    lValor      := StrToCurr(Troca(GetValueJsonDef(FJSONITEMCONF ,'valor', '0'), '.', ','));
    lDesconto   := GetValueJsonDef(FJSONITEMCONF ,'desconto', '0');
  
    if lQuantidade = 0 then
      lQuantidade := _GetQuantidadeItem;
      
    if lValor = 0 then
      lValor := _GetVlrItem;  
  
    FCDSProdutos.First;
  
    while not FCDSProdutos.Eof do
    begin
    
      CDS.InsertRecord([
        FCDSProdutos.FieldByName('CODIGO_ITEM').AsInteger,
        FCDSProdutos.FieldByName('VARIACAO_ITEM_DETALHE').AsInteger,
        FCDSProdutos.FieldByName('COR_ITEM_DETALHE').AsInteger,
        FCDSProdutos.FieldByName('ACABAMENTO_ITEM_DETALHE').AsInteger,
        lQuantidade,
        lValor,
        lDesconto]);
    
      FCDSProdutos.Next;
    end;
    
    _IncluirItensDocumento(CDS);   
  finally
    CDS.Free;
  end;
end;

procedure _IncluirItensDocumento(pCDS: TClientDataSet);
var
  lItem, lVar, lCor, lAcab: Integer;
  lValor, lQuantidade: Currency;
  lDesconto, Log: String;
begin
  if pCDS.IsEmpty then
  begin
    // Registrar erro no Log pois nÃ£o hÃ¡ itens para incluir.
    Exit;
  end;  
  
  ExecutarMetodoDeObjeto(grdItem, 'SetFocus');
  
  lItem := 0;
  
  ScriptDeTestesEmExecucao := True;
  pCDS.First;
  while not pCDS.Eof do
  begin
    lItem := pCDS.FieldByName('ITEM').AsInteger;
    lVar := pCDS.FieldByName('VAR').AsInteger;
    lCor := pCDS.FieldByName('COR').AsInteger;
    lAcab := pCDS.FieldByName('ACAB').AsInteger;
    lValor := pCDS.FieldByName('VALOR').AsCurrency;
    lQuantidade := pCDS.FieldByName('QTD').AsCurrency;
    lDesconto := pCDS.FieldByName('DESCONTO').AsString;
  
    try
      if lItem <> CDSItem.FieldByName('ITEM_DOCITEM').AsInteger then
      begin
        CDSItem.Insert;
        CDSItem.FieldByName('ITEM_DOCITEM').AsInteger := lItem;
      end;
        
      if (lVar > 0) or
         (lCor > 0) or
         (lAcab > 0) then
      begin
        ExecutarMetodoDeObjeto(Frame,'IncluiDetalhamentoItem',[lVar, lCor, lAcab, lQuantidade, lValor, False]);
      end
      else
      begin
        CDSItem.FieldByName('QTDECHAPAS_DOCITEM').AsCurrency := lQuantidade;
        CDSItem.FieldByName('VLRUNITARIOBRUTO_DOCITEM').AsCurrency := lValor;
      end;  
    
      if lItem <> CDSItem.FieldByName('ITEM_DOCITEM').AsInteger then
        CDSItem.Post;
    
    except
      on Ex: Exception do
      begin
        CDSItem.Cancel;
        AssertsFalhou('Erro ao Incluir Item: ' + IntToStr(lItem), Ex.Message);
      end;
    end;
    
    pCDS.Next;
  end;
  //ScriptDeTestesEmExecucao := False;
end;

function _GetQuantidadeItem: Currency;
begin
  Result := FCDSConfigFaturamentoCasoTeste.FieldByName('QTD_FIXA_ITEM_FATCONFIG').AsCurrency;
  if Result = 0 then
    Result := Max(1, Random(FCDSConfigFaturamentoCasoTeste.FieldByName('QTD_MAX_ITEM_FATCONFIG').AsCurrency));
end;

function _GetVlrItem: Currency;
begin
  Result := FCDSConfigFaturamentoCasoTeste.FieldByName('VALOR_ITEM_FIXO_FATCONFIG').AsCurrency;
  if Result = 0 then
    Result := Max(10, Random(FCDSConfigFaturamentoCasoTeste.FieldByName('VLR_MAX_ITEM_FATCONFIG').AsCurrency));
end;

function _LancaDetalhamento(CDSPro: TClientDataSet): Boolean;
begin
  Result := (CDSPro.FieldByName('DIFERENCIAVARIACAO_ITEM').AsString = 'S') or
   (CDSPro.FieldByName('DIFERENCIACOR_ITEM').AsString = 'S') or
   (CDSPro.FieldByName('DIFERENCIAACABAMENTO_ITEM').AsString = 'S');
end;