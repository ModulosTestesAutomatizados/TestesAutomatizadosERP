uses P39_TDD_FAT_DOCUMENTO_FATURA, P39_TDD_FAT_DOCUMENTO_FATURA_ITENS;

{$Region 'Dados Principais'}

procedure _DadosPrincipais;
var lUnidadeFabril, iUnidadeFabril: Integer;
begin
  CDSCad.FieldByName('CLIENTE_DOCFAT').AsInteger := FCDSClientes.FieldByName('CODIGO_PESSOA').AsInteger;

  lUnidadeFabril := ValorInteiroTagDoc('unidfabril_docfat');
  if lUnidadeFabril > 0 then
  begin
    iUnidadeFabril := ExecuteScalarP('select CODIGO_UNIDPROD from PCP_UNIDADEPRODUCAO where CODIGO_UNIDPROD = :UNID', VarArrayOf([lUnidadeFabril]));  
    if iUnidadeFabril > 0 then
      CDSCad.FieldByName('UNIDFABRIL_DOCFAT').AsInteger := iUnidadeFabril; 
  end;
  
  _DefinirTabelaPreco;

  _DefinirDescontos;
  //_IncluirItens;
  P39_TDD_FAT_DOCUMENTO_FATURA_ITENS.Itens_Incluir;
  // Chamada nova Unit
end;

procedure _DefinirTabelaPreco;
var 
  lTabela: Integer;
  lDescTabela: String;
  lIndiceCDSTabelaPreco: String;
begin
  lDescTabela := ValorStringTagDoc('descricao_tabela_preco');
  lTabela     := ValorInteiroTagDoc('tabela_preco');
  
  lIndiceCDSTabelaPreco     := CDSTabela.IndexFieldNames;
  CDSTabela.IndexFieldNames := '';
   
  if (Trim(lDescTabela) <> '') then  // Tento Pegar Primeiro pela DescriÃ§Ã£o
    lTabela := CodigoTabelaPrecoPeloNome(lDescTabela)
  else if (lTabela > 0) then // Depois Somente se o Codigo tiver Sido informado.
  begin
    lTabela := CodigoTabelaPrecoPeloCodigo(lTabela)
  end
  else 
    lTabela := 0;
  
  CDSTabela.IndexFieldNames := lIndiceCDSTabelaPreco;
  
  if lTabela > 0 then
  begin
    CDSPedido.Edit;
    CDSPedido.FieldByName('TABELA_DOCPED').AsInteger := lTabela;
    
    _DefinirCondicao;
    
   // Sleep(400);
  end;
end;

function CodigoTabelaPrecoPeloCodigo(pCodTabelaPreco: Integer): Integer;
begin
  Result := 0;
  if CDSTabela.IsEmpty or not CDSTabela.Active then
    Exit;
   
  CDSTabela.IndexFieldNames := 'CODIGO_TABELA';
  try
    if CDSTabela.FindKey([pCodTabelaPreco]) then
      Result := CDSTabela.FieldByName('CODIGO_TABELA').AsInteger;   
  finally
    CDSTabela.IndexFieldNames := '';
  end;
  
  //Sleep(400);
end;

function CodigoTabelaPrecoPeloNome(pNomeTabela: String):Integer;
begin
  Result := 0;
  
  if CDSTabela.IsEmpty or not CDSTabela.Active then
    Exit;
  
  CDSTabela.IndexFieldNames := 'DESCRICAO_TABELA';
  try
    if CDSTabela.FindKey([pNomeTabela]) then
      Result := CDSTabela.FieldByName('CODIGO_TABELA').AsInteger;
  finally
    CDSTabela.IndexFieldNames := '';
  end;
  
 // Sleep(400);  
end;

procedure _DefinirCondicao;
var
  lDescCondicao, lIndiceCDSCondicao: String;
  lCondicao: Integer;
begin
  lDescCondicao := ValorStringTagDoc('descricao_condicao');
  lCondicao     := ValorInteiroTagDoc('tabelacondicao_docped');

  lIndiceCDSCondicao := CDSCondicaoTabela.IndexFieldNames;
  if (Trim(lDescCondicao) <> '') then
  begin
    lCondicao := CodigoCondicaoPeloNome(lDescCondicao);
    
    if (lCondicao = 0) then
      lCondicao := CodigoCondicaoPeloCodigo(ValorInteiroTagDoc('tabelacondicao_docped'));     
  end
  else if (lCondicao > 0) then
    lCondicao := CodigoCondicaoPeloCodigo(lCondicao)
  else
    lCondicao := 0;
  
  CDSCondicaoTabela.IndexFieldNames := lIndiceCDSCondicao; 
  
  if (lCondicao > 0) then
  begin
    CDSPedido.FieldByName('TABELACONDICAO_DOCPED').AsInteger := lCondicao;
  //  Sleep(300);
    _DefinirPrazos;   
  end; 
end;

function CodigoCondicaoPeloNome(pCondicao: String):Integer;
begin
  Result := 0;
  
  if CDSCondicaoTabela.IsEmpty or not CDSCondicaoTabela.Active then
    Exit;
    
  CDSCondicaoTabela.IndexFieldNames := 'DESCRICAO_TABELA_COND';
  if CDSCondicaoTabela.FindKey([pCondicao]) then
    Result := CDSCondicaoTabela.FieldByName('CODIGO_TABELA_COND').AsInteger;
end;

function CodigoCondicaoPeloCodigo(pCondicao: Integer):Integer;
begin
  Result := 0;
  
  if CDSCondicaoTabela.IsEmpty or not CDSCondicaoTabela.Active then
    Exit;
    
  CDSCondicaoTabela.IndexFieldNames := 'CODIGO_TABELA_COND';
  if CDSCondicaoTabela.FindKey([pCondicao]) then
    Result := CDSCondicaoTabela.FieldByName('CODIGO_TABELA_COND').AsInteger;
end;

procedure _DefinirPrazos;
var
  lDescPrazo, lIndiceCDSPrazo, lPrazoManual: String;
  lPrazo: Integer;
  I: Integer;
  lPrazoManualSeparado: TStringDynArray;
begin
  lDescPrazo   := ValorStringTagDoc('descricao_prazo');
  lPrazo       := ValorInteiroTagDoc('condicaoprazo_docped');
  lPrazoManual := ValorStringTagDoc('prazo_manual');
  
  if (Trim(lPrazoManual) <> '') and (CDSCondicaoTabela.FieldByName('BLOQUEAR_TABELA_COND').AsString = 'N') then
  begin
    CDSPrazos.ApagarRegistros('');
    lPrazoManualSeparado := SplitString(lPrazoManual, '/');
    
    for I := 0 to Length(lPrazoManualSeparado) -1 do
    begin
      CDSPrazos.Insert;
      CDSPrazos.FieldByName('PRAZODIAS_DOCPRAZO').AsInteger := StrToInt(lPrazoManualSeparado[I]);
      CDSPrazos.Post;
    end;  
  end
  else
  begin
    lIndiceCDSPrazo := CDSCondicaoDetalhe.IndexFieldNames;
  
    if (Trim(lDescPrazo) <> '') then
    begin
      lPrazo := CodigoPrazoPeloNome(lDescPrazo);
      
      if lPrazo = 0 then
        lPrazo := CodigoPrazoPeloCodigo(ValorInteiroTagDoc('condicaoprazo_docped'));    
    end
    else if (lPrazo > 0) then  
      lPrazo := CodigoPrazoPeloCodigo(lPrazo)
    else
      lPrazo := 0;
    
    CDSCondicaoDetalhe.IndexFieldNames := lIndiceCDSPrazo;  
    if lPrazo > 0 then
    begin
      CDSPedido.FieldByName('CONDICAOPRAZO_DOCPED').AsInteger := lPrazo;
    //  Sleep(300);
    end;
  end;
  
end;

function CodigoPrazoPeloNome(pPrazo: String): Integer;
begin
  Result := 0;
  
  if CDSCondicaoDetalhe.IsEmpty or not CDSCondicaoDetalhe.Active then
    Exit;
    
  CDSCondicaoDetalhe.IndexFieldNames := 'DESCRICAO_TABCONDPRAZO';
  
  if CDSCondicaoDetalhe.FindKey([pPrazo]) then
    Result := CDSCondicaoDetalhe.FieldByName('AUTOINC_TABCONDPRAZO').AsInteger;   
end;

function CodigoPrazoPeloCodigo(pPrazo: Integer): Integer;
begin
  Result := 0;
  
  if CDSCondicaoDetalhe.IsEmpty or not CDSCondicaoDetalhe.Active then
    Exit;
    
  CDSCondicaoDetalhe.IndexFieldNames := 'AUTOINC_TABCONDPRAZO';
  
  if CDSCondicaoDetalhe.FindKey([pPrazo]) then
    Result := CDSCondicaoDetalhe.FieldByName('AUTOINC_TABCONDPRAZO').AsInteger;   
end;

procedure _DefinirDescontos;
var 
  lValorDescParcial: Currency;
  lPercDesconto, lLinha: String;
  lDescontoSeparado: TStringDynArray;
  I: Integer;
begin
  lPercDesconto := ValorStringTagDoc('percdesc_docdescprinc');
  
  if lPercDesconto <> '' then
  begin
    if (CDSPedido.FieldByName('TABELA_DOCPED').AsInteger > 0) then
    if (CDSTabela.FieldByName('BLOQUEIADESCONTOMANUAL_TABELA').AsString = 'S') or 
       (CDSTabela.FieldByName('PERMITEDESCONTO_TABELA').AsString = 'N') then
    begin
      LogDoProcessamentoAdd('**** Tabela de PreÃ§o ******');
      LogDoProcessamentoAdd('Log.: Desconto NÃ£o LanÃ§ado. Tabela nÃ£o permite lanÃ§ar desconto ou bloqueia desconto manual.');
      LogDoProcessamentoAdd('Desconto informado.......: ' + lPercDesconto);
      LogDoProcessamentoAdd('Codigo Tabela............: ' + CDSPedido.FieldByName('TABELA_DOCPED').AsString);
      LogDoProcessamentoAdd('Permite LanÃ§ar Desconto..: ' + CDSTabela.FieldByName('PERMITEDESCONTO_TABELA').AsString);
      LogDoProcessamentoAdd('Bloqueia Desconto Manual.: ' + CDSTabela.FieldByName('BLOQUEIADESCONTOMANUAL_TABELA').AsString);
      Exit;
    end;
    
    lDescontoSeparado := SplitString(lPercDesconto, ',');
    
    for I := 0 to Length(lDescontoSeparado) -1 do
    begin
      lLinha := StringReplace(lDescontoSeparado[I], '"', '');
      lLinha := StringReplace(lLinha, '.', ',');
      
      CDSDescontoPrincipal.Insert;
      CDSDescontoPrincipal.FieldByName('PERCDESC_DOCDESCPRINC').AsCurrency := StrToCurrDef(lLinha, 0);  
      CDSDescontoPrincipal.Post;
    end;
  end;
  
  lValorDescParcial := ValorCurrencyTagDoc('vlrdescontoparcial_docfat');  
  CDSCad.FieldByName('VLRDESCONTOPARCIAL_DOCFAT').AsCurrency := lValorDescParcial;
end;