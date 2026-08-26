uses P39_TDD_CASOS_DE_TESTE, P39_TDD_DOCUMENTO_FATURA_SQL, P39_TDD_FUNCOES_JSON;

{$Region 'Constantes'}
const  
  FCDSCadastro = 'CDSCadastro';
  FCDSItem = 'CDSItem';
  FCDSFiscal = 'CDSFiscal'; // Parte Fiscal de Frete e Talvez Nota.
  FCDSPedido = 'CDSPedido'; // Parte de Tabela de Preço e Frete
  FCDSCondicaoTabela = 'CDSCondicaoTabela'; // Condição da Tabela de Preço
  FCDSCondicaoDetalhe = 'CDSCondicaoDetalhe'; // Prazo para Informar no Pedido de Venda.
  FCDSItemDesconto = 'CDSItemDesconto'; // Incluir Desconto Por Item
  FCDSDescontoPrincipal = 'CDSDescontoPrincipal'; // Descontos Principais do Pedido
  FCDSTabela = 'CDSTabela';
  FCDSPrazos = 'CDSPrazos';
  
  FRGradeamento = 'FRGradeamento';  
  FGradeItens = 'grdItem';

  FBotaoIncluir = 'BotaoIncluir';
  FBotaoGravar = 'BotaoGravar';
  
  idCB = 'GERA_DOCUMENTOS_FATURA';

  cModuloFaturamento = 'FATURAMENTO';
  
{$endRegion}

{$Region 'Variáveis'}
var
  FItemMenu, FCadastro,
  FDM, FArea: string;

  FJSONDOC, FJSONITEMCONF, FJSONITENS: String;

  FTagCli    : Integer;
  FTagProduto: Integer;
  FTransacao : Integer;

  FCDSClientes: TClientDataSet;
  FCDSProdutos: TClientDataSet;
  FCDSConfigFaturamentoCasoTeste: TClientDataSet;

  grdItem : TComponent;
  Frame          : TComponent;
  FormCadastro   : TForm;
  DM             : TComponent;
  BotaoIncluir   : TComponent;
  BotaoGravar    : TComponent;
  
  CDSCad, CDSItem, CDSFiscal, CDSPedido,
  CDSCondicaoTabela, CDSCondicaoDetalhe, CDSDescontoPrincipal,
  CDSItemDesconto, CDSPrazos, CDSTabela: TClientDataSet;
  
  FTelaPedidoAberta: Boolean;
  //Parametro
  FBloqueioAutomatico: Boolean;  

  FCasoTesteInvalido: Boolean;
  FMsgCasoTesteInvalido: String;
{$endRegion}

procedure Main;
begin
  if ExecutandoNoServidor then
    raise exception.Create(MensagemPersonalizada + #13 + 'Processamento não disponível para execução pelo servidor!');

  if CodigoComoClienteTekSystem <> 1000 then
    raise exception.Create(MensagemPersonalizada + #13 + 'Processamento exclusivo para uso de testes dentro da TekSystem!');      
end;

procedure Setup_Inicializar;
begin
  Setup_InicializarObjetos;
  Setup_IniciarFormulario;
end;

procedure Setup_InicializarObjetos;
begin
  FCDSClientes := TClientDataSet.Create;
  FCDSProdutos := TClientDataSet.Create;
  FCDSConfigFaturamentoCasoTeste := TClientDataSet.Create;
  ScriptDeTestesEmExecucao := False;
  {P39_TDD_CASOS_DE_TESTE}Setup_Inicializar_CasosTeste;
  SetModulo(cModuloFaturamento);
  CarregarConfiguracoes;
  CarregarCasosTeste;
  FCDSConfigFaturamentoCasoTeste.Data := {P95_TDD_CASOS_DE_TESTE}GetConfiguracao;
end;

procedure Setup_IniciarFormulario;
begin
  FTelaPedidoAberta := False;
  FItemMenu := 'Emisso1'; // Verificando Utilização
  
  FormCadastro := CriarFormPeloNome(FCadastro); 
  if FormCadastro = nil then
    raise exception.Create('Não encontrado Form ' + FormCadastro);
  DM   := DMCriadoPeloNome(FDM);

  if DM = nil then
    raise exception.Create('Não encontrado DM ' + FDM);

  Frame          := FormCadastro.FindComponent(FRGradeamento);  
  grdItem        := FormCadastro.FindComponent(FGradeItens);

  CDSCad               := DM.FindComponent(FCDSCadastro);
  CDSItem              := DM.FindComponent(FCDSItem);
  CDSFiscal            := DM.FindComponent(FCDSFiscal);
  CDSPedido            := DM.FindComponent(FCDSPedido);
  CDSCondicaoTabela    := DM.FindComponent(FCDSCondicaoTabela);
  CDSCondicaoDetalhe   := DM.FindComponent(FCDSCondicaoDetalhe);
  CDSDescontoPrincipal := DM.FindComponent(FCDSDescontoPrincipal);
  CDSItemDesconto      := DM.FindComponent(FCDSItemDesconto);
  CDSTabela            := DM.FindComponent(FCDSTabela);
  CDSPrazos            := DM.FindComponent(FCDSPrazos);
  
  if CDSCad = nil then
    raise exception.Create('Não encontrado CDSCadastro');

  BotaoIncluir := FormCadastro.FindComponent(FBotaoIncluir);
  BotaoGravar  := FormCadastro.FindComponent(FBotaoGravar);
  
  FormCadastro.Show;
  FTelaPedidoAberta := True;
end;

procedure FinalizarFormulario;
begin
  CallBack_FechaTela(ClassOwner);
  FormCadastro.Close;
  FTelaPedidoAberta := False;
  Sleep(500);
end;

procedure TearDown_DestruirObjetos;
begin
  FCDSClientes.Free;
  FCDSProdutos.Free;
  FCDSConfigFaturamentoCasoTeste.Free;
  ScriptDeTestesEmExecucao := False;
end;

procedure Teste_Executar;
const cEx = 'Executando Teste...';
begin
  if CDSCasosTestes.IsEmpty then
    raise Exception.Create(MensagemPersonalizada + 'Não há casos de teste para ser executado.');  
  
  CallBack_AbreTela(ClassOwner);
  try
    CDSCasosTestes.First;
    while not CDSCasosTestes.Eof do
    begin
      SetCasoTeste(CDSCasosTestes.FieldByName('CASOTESTE').AsString);
      
      _IncluiDocumento();
      
      CDSCasosTestes.Edit;
      CDSCasosTestes.FieldByName('EXECUTADO').AsString := 'S';
      CDSCasosTestes.Post;
      
      //Comparar(CDSCasosTestes.FieldByName('ID').AsInteger);
      
      CDSCasosTestes.Next;
    end;  
           
  finally
    CallBack_FechaTela(ClassOwner);
  end;
end;

procedure LimparJsonCasoTeste;
begin
  FJSONDOC      := '';
  FJSONITEMCONF := '';
  FJSONITENS    := '';
end;

procedure _IncluiDocumento;
var lTag, lCliente: Integer;
begin
  if FCDSConfigFaturamentoCasoTeste.IsEmpty then
  begin
    EnviarMensagemInterna(Nome_Usuario_Atual, 'Teste Automatizado - Erro!', 'Configuração Não Carregaga.');
    Exit;
  end;
  
  if FCasoTesteInvalido then
  begin
    EnviarMensagemInterna(Nome_Usuario_Atual, 'Teste Automatizado - Erro!', FMsgCasoTesteInvalido);
    Exit;
  end;  
  
  // Processo de Carregamento de Clientes.....
  
  lTag     := ValorInteiroTagDoc('tag_cliente');
  lCliente := ValorInteiroTagDoc('cliente_docfat');    
 
  CarregarClientes(lTag, lCliente);
  //
  FCDSClientes.First;  
  while not (FCDSClientes.Eof) do
  begin
    ExecutarMetodoDeObjeto(FormCadastro, 'BotaoIncluirClick', [nil]);
    Sleep(300);
    
    //ConfigurarFiscal;
    _DadosPrincipais;
    _Financeiro;
    _DadosParaEntrega;
    _DadosFaturamento;
    _InformacoesFrete;
    ExecutarMetodoDeObjeto(BotaoGravar, 'Click');
    Sleep(300);
    //Break;
    FCDSClientes.Next;
  end;
end;

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
  
  _IncluirItens;
   
end;

{$Region 'Tabela Preço'}
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
   
  if (Trim(lDescTabela) <> '') then  // Tento Pegar Primeiro pela Descrição
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
    
    Sleep(400);
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
  
  Sleep(400);
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
  
  Sleep(400);  
end;
{$endRegion}

{$Region 'Condição Pagamento'}
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
    Sleep(300);
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
{$endRegion}

{$Region 'Prazo'}
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
      Sleep(300);
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
{$endRegion}

{$Region 'Desconto Geral'}

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
      LogDoProcessamentoAdd('**** Tabela de Preço ******');
      LogDoProcessamentoAdd('Log.: Desconto Não Lançado. Tabela não permite lançar desconto ou bloqueia desconto manual.');
      LogDoProcessamentoAdd('Desconto informado.......: ' + lPercDesconto);
      LogDoProcessamentoAdd('Codigo Tabela............: ' + CDSPedido.FieldByName('TABELA_DOCPED').AsString);
      LogDoProcessamentoAdd('Permite Lançar Desconto..: ' + CDSTabela.FieldByName('PERMITEDESCONTO_TABELA').AsString);
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

{$endRegion} // Fim Region Desconto Geral

{$Region 'Incluir Itens'}

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

// Validações de Item para ser Incluídas aqui.
function ItemValido(pItem, pVar, pCor, pAcab: Integer):Boolean;
begin
  Result := False;
  
  if (pItem <= 0) then
    Exit;
  
  //Fat Por Unidade Fabril.  
    
end;

procedure _IncluirItens;
var 
  lArrayItens: TJSONArray;
  lItemConfig, lItemEspec, lDesconto: String;
  lQuantidade, lValor: Currency;
  I, lItem, lVar, lCor, lAcab, iTagProd: Integer;
  lJSONItem: TJSONObject;
  CDS: TClientDataSet;
begin
  iTagProd := StrToInt(GetValueJsonDef(FJSONITEMCONF, 'tag_prodcomum', '0'));  

  lArrayItens := TJSONArray(TryParseJSONValue(GetArrayJson(FJSONITEMCONF, 'itens')));
  try
    if (lArrayItens.Count > 0) then // Possui Itens Específicos
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
          // Fim Atribuição de Valor
          
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
      raise exception.Create('Itens Inválidos do caso de Teste');  
       
  finally
    if Assigned(lArrayItens) then
      lArrayItens.Free;
  end;
end;
{
procedure _IncluiItemEspecifico(pItem, pVar, pCor, pAcab: Integer; pQuantidade, pValor: Currency; pDesconto: String;);
var 
  lDescontoSeparado: TStringDynArray;
  I: Integer;
  lLinha, S: String;
begin
  ExecutarMetodoDeObjeto(grdItem, 'SetFocus');
  
  CDSItem.Insert;

  CDSItem.FieldByName('ITEM_DOCITEM').AsInteger := pItem;

  if (pVar > 0) or
     (pCor > 0) or
     (pAcab > 0) then
  begin
    ExecutarMetodoDeObjeto(Frame,'IncluiDetalhamentoItem',[pVar, pCor, pAcab, pQuantidade, pValor, False]);
  end
  else
  begin
    CDSItem.FieldByName('QTDECHAPAS_DOCITEM').AsCurrency := pQuantidade;
    CDSItem.FieldByName('VLRUNITARIOBRUTO_DOCITEM').AsCurrency := pValor;
  end;

  if (Trim(pDesconto) <> '') then
  begin
    lDescontoSeparado := SplitString(pDesconto, ',');
    
    for I := 0 to Length(lDescontoSeparado) -1 do
    begin
      lLinha := StringReplace(lDescontoSeparado[I], '"', '');
      lLinha := StringReplace(lLinha, '.', ',');
    
      CDSItemDesconto.Insert;
      CDSItemDesconto.FieldByName('PERCDESC_DOCDESCITEM').AsCurrency := StrToCurrDef(lLinha, 0);  
      CDSItemDesconto.Post;
    end;
  
  end;

  ShowMessage('Vai dar Post.');
  
  //CDSItem.Edit;
  CDSItem.Post;
end;
}

procedure _IncluiItensPorTag(const pTagProduto: Integer);
var 
  lQuantidade, lValor: Currency;
  lDesconto: String;
  CDS: TClientDataSet;
begin
  FCDSProdutos.Data := BuscaDadosProdutos(pTagProduto);

  if FCDSProdutos.IsEmpty then
    Exit;

  CDS := TClientDataSet.Create;
  try
    _CriarEstruturaItens(CDS);
    
    lQuantidade := StrToCurr(Troca(GetValueJsonDef(FJSONITEMCONF ,'quantidade', '0'), '.', ','));
    lValor      := StrToCurr(Troca(GetValueJsonDef(FJSONITEMCONF ,'valor', '0'), '.', ','));
    lDesconto   := GetValueJson(FJSONITEMCONF ,'desconto', '0');
  
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
     { 
      _IncluiItemEspecifico(
        FCDSProdutos.FieldByName('CODIGO_ITEM').AsInteger,
        FCDSProdutos.FieldByName('VARIACAO_ITEM_DETALHE').AsInteger,
        FCDSProdutos.FieldByName('COR_ITEM_DETALHE').AsInteger,
        FCDSProdutos.FieldByName('ACABAMENTO_ITEM_DETALHE').AsInteger,
        lQuantidade,
        lValor,
        lDesconto);
      }
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
    // Registrar erro no Log pois não há itens para incluir.
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
        Log := Log + #13 + Ex.Message;
      end;
    end;
    
    pCDS.Next;
  end;
  ScriptDeTestesEmExecucao := False;
 
 
  if Log <> '' then
    MostrarLogTexto(Log);
end;

{$endRegion} // Fim da Region Incluir Itens

{$endRegion} // Fim Region Dados Principais

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
      
    Sleep(250);        
  end;
  
  if lBanco > 0 then
  begin
    iBanco := ExecuteScalarP('select CODIGO_BANCO from BANCO where CODIGO_BANCO = :BC', VarArrayOf([lBanco]));    
  
    if lBanco > 0 then
      CDSCad.FieldByName('BANCO_DOCFAT').AsInteger := iBanco;  
  
    Sleep(250);
  end;  
end;


{$endRegion}

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
  
  CDSCad.FieldByName('OBSERVACAO_DOCFAT').AsString := 'Documento gerado automaticamente via rotina de testes automatizados.';

end;

{$endRegion}

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

{$Region 'Informações Frete/Transporte'}
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

procedure SetCasoTeste(pCasoTeste: String);
var
  LObj: TJSONObject;
  LParams: String;
begin
  LimparJsonCasoTeste;
  
  FJSONDOC      := GetObjectJson(pCasoTeste, 'documento');
  FJSONITEMCONF := GetObjectJson(pCasoTeste, 'item');
  FJSONITENS    := GetArrayJson(FJSONITEMCONF, 'itens');
  
  LObj := TJSONObject.ParseJSONValue(GetObjectJson(pCasoTeste, 'parametros'));
  try
    if LObj.Count > 0 then
      _AjustarParametros(LObj.ToJson);  
  finally
    LObj.Free;
  end;
  ValidarCasoTeste;
end;

procedure _AjustarParametros(pParams: String);
begin
  if FTelaPedidoAberta then
    FinalizarFormulario;
    
  try
    VerificarParametros(pParams);
  finally
    Setup_IniciarFormulario;
  end;  
end;

procedure ValidarCasoTeste;
const cTAErr = 'Teste Automatizado - Erro!';
begin
  FMsgCasoTesteInvalido := '';
  
  if Trim(FJSONDOC) = '' then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + cTAErr + #13 + 'JSON do documento Vazio!'; 
  
  if Trim(FJSONITEMCONF) = '' then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'JSON de configuração do ITEM Vazio!';

  if Trim(FJSONDOC) = '' then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'JSON de ITENS Vazio!';

  FCasoTesteInvalido := (FMsgCasoTesteInvalido <> '');
end;

procedure CarregarClientes(pTag, pCliente: Integer);
begin
  if pTag > 0 then
    FCDSClientes.Data := _BuscaDadosClientes(pTag)
  else if (pCliente > 0) then
    FCDSClientes.Data := _BuscaCliente(pCliente)
  else if (FCDSConfigFaturamentoCasoTeste.FieldByName('PESSOA_GERAL_FATCONFIG').AsInteger > 0) then
    FCDSClientes.Data := _BuscaDadosClientes(FCDSConfigFaturamentoCasoTeste.FieldByName('PESSOA_GERAL_FATCONFIG').AsInteger);    
      
  if FCDSClientes.IsEmpty then
    raise Exception.Create(MensagemPersonalizada + 'Não há clientes para inclusão.');
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

// FUNCOES AUXILIARES

function ValorLogicoTagDoc(pTagName: String): Boolean;
begin
  Result := ValorLogicoTag(FJSONDOC, pTagName, False); 
end;

function ValorInteiroTagDoc(pTagName: String): Integer;
begin
  Result := ValorInteiroTag(FJSONDOC, pTagName, 0);   
end;

function ValorDataTagDoc(pTagName: String): TDateTime;
begin
  Result := ValorDataTag(FJSONDOC, pTagName);   
end;

function ValorCurrencyTagDoc(pTagName: String):Currency;
begin
  Result := ValorCurrencyTag(FJSONDOC, pTagName, 0);         
end;

function TagItemConfigExiste(pTagName: String):Boolean;
begin
  Result := TagExiste(FJSONITEMCONF, pTagName);
end;

function TagDocumentoExiste(pTagName: string): Boolean;
begin
  Result := TagExiste(FJSONDOC, pTagName);
end;

function ValorStringTagDoc(pTagName: String): String;
begin
  Result := ValorStringTag(FJSONDOC, pTagName);
end;