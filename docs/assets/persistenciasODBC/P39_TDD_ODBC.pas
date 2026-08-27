uses P39_GERAR_FAT_CONFIG_TESTE, P39_FAT_DADOS_TESTE;

const  
  FCDSCadastro = 'CDSCadastro';
  FCDSItem = 'CDSItem';
  FCDSFiscal = 'CDSFiscal';
  FRGradeamento = 'FRGradeamento';  
  FGradeItens = 'grdItem';

  FBotaoIncluir = 'BotaoIncluir';
  FBotaoGravar = 'BotaoGravar';
  
  idCB = 'GERA_DOCUMENTOS_FATURA';
  cMaxDetalhamento = 2;

var
  FItemMenu, FCadastro,
   FDM: string;

  FTagCli    : Integer;
  FTagProduto: Integer;
  FTransacao : Integer;

  FCDSClientes: TClientDataSet;
  FCDSProdutos: TClientDataSet;

  grdItem : TComponent;
  Frame          : TComponent;
  FormCadastro   : TForm;
  DM             : TComponent;
  BotaoIncluir   : TComponent;
  BotaoGravar    : TComponent;  
  
  CDSCad, CDSItem,
  CDSFiscal: TClientDataSet;

procedure Main;
begin
  if ExecutandoNoServidor then
    raise exception.Create(MensagemPersonalizada + #13 + 'Processamento nÃ£o disponÃ­vel para execuÃ§Ã£o pelo servidor!');

  if CodigoComoClienteTekSystem <> 1000 then
    raise exception.Create(MensagemPersonalizada + #13 + 'Processamento exclusivo para uso de testes dentro da TekSystem!');
  
  P39_GERAR_FAT_CONFIG_TESTE.Main;

  CarregarUnitDinamicamente('FAT_CONFIG_TESTE');
    
  if not ConfirmarFiltros then
     Exit;
     
  CallBack_AbreTela(idCB);
  try
    CallBack_Mensagem(idCB, 'Pedido de Venda');
    if Filtro(1) = QuotedStr('S') then
      IncluiPedidoVenda;
    
    CallBack_Mensagem(idCB, 'Pedido de Venda para NFCe');   
    if Filtro(2) = QuotedStr('S') then
      IncluiPedidoVendaNFCe;
      
    CallBack_Mensagem(idCB, 'AssistÃªncia Tecnica');   
    if Filtro(3) = QuotedStr('S') then
      IncluiAssistencia;
    
    CallBack_Mensagem(idCB, 'Pedido de ConsignaÃ§Ã£o');   
    if Filtro(4) = QuotedStr('S') then
      IncluiConsignacao;
    
    CallBack_Mensagem(idCB, 'ConferÃªncia e LiberaÃ§Ã£o de Pedidos');   
    if Filtro(5) = QuotedStr('S') then
      ConfereLiberaDocumentos;
  finally
    CallBack_FechaTela(idCB);
  end;
end;

function ConfirmarFiltros: Boolean;
var
  CDS: TClientDataSet;
begin
  CDS := TClientDataSet.Create; 
  try     
    CDS.Data := EstruturaDeFiltrosDinamicos;      
   
    {01} IncluirFiltroDinamico(CDS, 'Pedidos de Venda', cTipoFiltro_Logico, 'S', '', '', '');               
    {02} IncluirFiltroDinamico(CDS, 'Pedidos de Venda para NFCe', cTipoFiltro_Logico, 'N', '', '', '');
    {03} IncluirFiltroDinamico(CDS, 'AssistÃªncia TÃ©cnica', cTipoFiltro_Logico, 'S', '', '', '');
    {04} IncluirFiltroDinamico(CDS, 'Pedido de ConsignaÃ§Ã£o', cTipoFiltro_Logico, 'S', '', '', '');
    {05} IncluirFiltroDinamico(CDS, 'Conferir e Liberar Bloqueios do Dia', cTipoFiltro_Logico, 'S', '', '', '');
    CDS.Data := ExecutarFiltroDinamico(CDS.Data, 'Selecione os documentos e processos a serem executados');
    
    Result := (not CDS.IsEmpty);
  finally
    CDS.Free;
  end;
end;


procedure IncluiPedidoVenda;
begin
  _Inicializar;
  try
    _DefinirCadastro(1);
    _CarregaCadastros;
    _IncluiDocumento;
  finally
    _Finalizar;
  end;
end;

procedure IncluiPedidoVendaNFCe;
begin
  _Inicializar;
  try
    _DefinirCadastro(1);
    
    FTagCli := TagPessoaConsumidorNFCe;
    FTagProduto := TagProdComum;
    FTransacao  := TransacaoPedidoNF_NFCe;
    _CarregaCadastros;
    _IncluiDocumento;
  finally
    _Finalizar;
  end;
end;

procedure IncluiAssistencia;
begin
  _Inicializar;
  try
    _DefinirCadastro(2);
    _CarregaCadastros;
    _IncluiDocumento;
  finally
    _Finalizar;
  end;
end;

procedure IncluiConsignacao;
begin
  _Inicializar;
  try
    _DefinirCadastro(3);
    _CarregaCadastros;
    _IncluiDocumento;
  finally
    _Finalizar;
  end;
end;

procedure ConfereLiberaDocumentos;
var
  sSQL: string;
begin
  sSQL := 'update DOCUMENTO_FATURA set DOCUMENTO_FATURA.DATACONFERENCIA_DOCFAT = current_date ' + #13 +
    ' where DOCUMENTO_FATURA.DTEMISSAO_DOCFAT between ' + DataSQL(HOJE, 1) + ' and ' + DataSQL(HOJE, 2) + #13 +
    '  and  DOCUMENTO_FATURA.ENTREGA_DOCFAT = ' + QuotedStr('N');
  ExecuteCommand(sSQL); 
  
  sSQL := 	'update DOCUMENTO_BLOQUEIO ' + #13 +
	'set DOCUMENTO_BLOQUEIO.DTLIBERACAO_DOCBLOQ = current_timestamp(0), ' + #13 +
	'    DOCUMENTO_BLOQUEIO.USUARIOLIBERACAO_DOCBLOQ = ' + QuotedStr(Nome_Usuario_Atual) + #13 +
	'where DOCUMENTO_BLOQUEIO.DTBLOQUEIO_DOCBLOQ >= current_date ' + #13 +
	'      and DOCUMENTO_BLOQUEIO.DTLIBERACAO_DOCBLOQ is null ' + #13 +
	'      and exists(select DOCUMENTO_FATURA.CODIGO_DOCFAT ' + #13 +
	'                 from DOCUMENTO_FATURA ' + #13 +
	'                 where DOCUMENTO_FATURA.DTEMISSAO_DOCFAT between ' + DataSQL(HOJE, 1) + ' and ' + DataSQL(HOJE, 2) + #13 +
	'                       and DOCUMENTO_FATURA.ENTREGA_DOCFAT = ' + QuotedStr('N') + #13 +
	'                       and DOCUMENTO_FATURA.CODIGO_DOCFAT = DOCUMENTO_BLOQUEIO.CODIGO_DOCBLOQ)'; 
  ExecuteCommand(sSQL); 
end;

procedure _Inicializar;
begin
  FCDSClientes := TClientDataSet.Create;
  FCDSProdutos := TClientDataSet.Create;
  ScriptDeTestesEmExecucao := True;
end;

procedure _Finalizar;
begin
  FCDSClientes.Free;
  FCDSProdutos.Free;
  ScriptDeTestesEmExecucao := False;
end;

procedure _CarregaCadastros;
begin
  FCDSClientes.Data := P39_FAT_DADOS_TESTE.BuscaDadosClientes(FTagCli);
  FCDSProdutos.Data := P39_FAT_DADOS_TESTE.BuscaDadosProdutos(FTagProduto);   

  MostrarCDS(FCDSClientes);
  Exit;
  
  if FCDSClientes.IsEmpty then
    raise Exception.Create('Lista de Clientes para InclusÃ£o no documento vazia!');
    
  if FCDSProdutos.IsEmpty then
    raise Exception.Create('Lista de Produtos para InclusÃ£o no pedido Vazia!');
end;

procedure _DefinirCadastro(tpDoc: Integer);
begin
  FTagCli := 0;
  FTagProduto := 0;
  //Pedido
  if tpDoc = 1 then
  begin
    FItemMenu := 'Emisso1';
    FCadastro := 'FCadPedidoVenda';
    FDM       := 'DMCadPedidoVenda';
    FTransacao  := TransacaoPedido;
  end //Assistencia
  else if tpDoc = 2 then
  begin
    FItemMenu := 'Emisso2';
    FCadastro := 'FCadAssistencia';
    FDM       := 'DMCadAssistencia';
    FTagProduto := TagItemAssistencia;   
    FTransacao  := TransacaoAssistencia;
  end //ConsignaÃ§Ã£o
  else if tpDoc = 3 then
  begin
    FItemMenu := 'Emisso5';
    FCadastro := 'FCadPedidoConsignacao';
    FDM       := 'DMCadPedidoConsignacao';   
    FTransacao  := TransacaoConsignacao;
  end; 
  
end;

procedure _IncluiDocumento;  
begin  
  FormCadastro := CriarFormPeloNome(FCadastro); 
  if FormCadastro = nil then
    raise exception.Create('NÃ£o encontrado Form ' + FormCadastro);
  try  
  FormCadastro.Show;
  
  DM   := DMCriadoPeloNome(FDM);

  if DM = nil then
    raise exception.Create('NÃ£o encontrado DM ' + FDM);

  Frame          := FormCadastro.FindComponent(FRGradeamento);  
  grdItem        := FormCadastro.FindComponent(FGradeItens);

  CDSCad    := DM.FindComponent(FCDSCadastro);
  CDSItem   := DM.FindComponent(FCDSItem);
  CDSFiscal := DM.FindComponent(FCDSFiscal);

  if CDSCad = nil then
    raise exception.Create('NÃ£o encontrado CDSCadastro');

  BotaoIncluir := FormCadastro.FindComponent(FBotaoIncluir);
  BotaoGravar  := FormCadastro.FindComponent(FBotaoGravar);

  FCDSClientes.First;
  while not FCDSClientes.Eof do
  begin   
 
    ExecutarMetodoDeObjeto(BotaoIncluir, 'Click');   

    CDSCad.FieldByName('CLIENTE_DOCFAT').AsInteger   := FCDSClientes.FieldByName('CODIGO_PESSOA').AsInteger;
    
    if FTransacao > 0 then
      CDSCad.FieldByName('TRANSACAO_DOCFAT').AsInteger := FTransacao;
      
    CDSCad.FieldByName('OBSERVACAO_DOCFAT').AsString := 'Documento gerado por Unidade de CodificaÃ§Ã£o.' + #13 +
     'Tag Cliente: ' + FCDSClientes.FieldByName('DESCRICAO_CARACT').AsString;
     
    if not ((CDSFiscal.State = dsInsert) or (CDSFiscal.State = dsEdit)) then
       CDSFiscal.Edit;
     
    if FTagCli = TagPessoaConsumidorNFCe then
    begin
      CDSCad.FieldByName('PARTICIONAVEL_DOCFAT').AsString := 'N';
      CDSCad.FieldByName('INDICADORPRESENCA_DOCFAT').AsInteger := 1;//NFCe - OperaÃ§Ã£o presencial.  

      if ClassificacaoPedidoNF_NFCe > 0 then
        CDSCad.FieldByName('CLASSIFICACAO_DOCFAT').AsInteger := ClassificacaoPedidoNF_NFCe;    
          
      CDSFiscal.FieldByName('TIPOFRETE_DOCFISCAL').AsInteger := 9;
      CDSFiscal.FieldByName('TIPOFRETECT_DOCFISCAL').AsInteger := 9;
    end;
    
    if CDSFiscal.FieldByName('TIPOFRETE_DOCFISCAL').AsInteger = 9 then
       CDSFiscal.FieldByName('PERCFRETEAUTONOMO_DOCFISCAL').AsCurrency := 0;
       
    if CDSFiscal.FieldByName('TIPOFRETECT_DOCFISCAL').AsInteger = 9 then
       CDSFiscal.FieldByName('PERCFRETECT_DOCFISCAL').AsCurrency := 0;

    _IncluiItens;

    ExecutarMetodoDeObjeto(BotaoGravar, 'Click');

    FCDSClientes.Next;
  end;
  finally
    FormCadastro.Free;
  end;
end;

procedure _IncluiItens;
var
  ItemAnt: Integer;  
  iCont: Integer;
  iQtdeMax: Integer;
begin

  FCDSProdutos.IndexFieldNames := 'CODIGO_ITEM;VARIACAO_ITEM_DETALHE;COR_ITEM_DETALHE;ACABAMENTO_ITEM_DETALHE';
  FCDSProdutos.First;
  ItemAnt := 0;
  iCont := 0;
  while not FCDSProdutos.Eof do
  begin
    if (ItemAnt <> FCDSProdutos.FieldByName('CODIGO_ITEM').AsInteger) then
       iCont := 0;

    if cMaxDetalhamento = 0 then
      iQtdeMax := 1 + Random(5)
    else
      iQtdeMax := cMaxDetalhamento;
    
    if iCont < iQtdeMax then
    begin
      ExecutarMetodoDeObjeto(grdItem, 'setFocus');
      if (ItemAnt = 0) or (ItemAnt <> FCDSProdutos.FieldByName('CODIGO_ITEM').AsInteger) then
      begin
        CDSItem.Insert;
        CDSItem.FieldByName('ITEM_DOCITEM').AsInteger := FCDSProdutos.FieldByName('CODIGO_ITEM').AsInteger;
        iCont := 0;
      end
      else
        CDSItem.Edit;

      if _LancaDetalhamento(FCDSProdutos) then
      begin
        {IncluiDetalhamentoItem(AVariacao, ACor, AAcabamento: Integer; AQuantidade, AValorUnitario: Currency; ASubstituir: Boolean);}
        ExecutarMetodoDeObjeto(Frame, 'IncluiDetalhamentoItem', 
          [FCDSProdutos.FieldByName('VARIACAO_ITEM_DETALHE').AsInteger,
           FCDSProdutos.FieldByName('COR_ITEM_DETALHE').AsInteger,
           FCDSProdutos.FieldByName('ACABAMENTO_ITEM_DETALHE').AsInteger,
           _GetQuantidadeItem,
           _GetVlrItem, False]);                          
      end
      else
      begin
        CDSItem.FieldByName('QTDECHAPAS_DOCITEM').AsCurrency := _GetQuantidadeItem;
        
        if CDSItem.FieldByName('VLRUNITARIOBRUTO_DOCITEM').AsCurrency = 0 then
          CDSItem.FieldByName('VLRUNITARIOBRUTO_DOCITEM').AsCurrency := _GetVlrItem;
        
      end;    
      CDSItem.Post;
    end;
    ItemAnt := FCDSProdutos.FieldByName('CODIGO_ITEM').AsInteger;
    iCont := iCont + 1;
    FCDSProdutos.Next;
  end;

end;

function _GetQuantidadeItem: Currency;
begin
  Result := QtdeFixaItem;
  if Result = 0 then
    Result := Max(1, Random(QtdeMaximaItem));
end;

function _GetVlrItem: Currency;
begin
  Result := VlrFixoItem;
  if Result = 0 then
    Result := Max(10, Random(VlrMaximoItem));
end;

function _LancaDetalhamento(CDSPro: TClientDataSet): Boolean;
begin
  Result := (CDSPro.FieldByName('DIFERENCIAVARIACAO_ITEM').AsString = 'S') or
   (CDSPro.FieldByName('DIFERENCIACOR_ITEM').AsString = 'S') or
   (CDSPro.FieldByName('DIFERENCIAACABAMENTO_ITEM').AsString = 'S');
end;