uses 
  P39_TDD_MODULO, 
  P39_TDD_DOCUMENTO_FATURA_SQL, 
  P39_TDD_FAT_DOCUMENTO_FATURA_JSON, 
  P39_TDD_FAT_VALIDAR_RESULTADO,
  P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_PRINCIPAIS,
  P39_TDD_FAT_DOCUMENTO_FATURA_FINANCEIRO,
  P39_TDD_FAT_DOCUMENTO_FATURA_ITENS,
  P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_ENTREGA,
  P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_FATURAMENTO,
  P39_TDD_FAT_DOCUMENTO_FATURA_INFORMACOES_FRETE;

{$Region 'Constantes'}
const  
  FCDSCadastro = 'CDSCadastro';
  FCDSItem = 'CDSItem';
  FCDSFiscal = 'CDSFiscal'; // Parte Fiscal de Frete e Talvez Nota.
  FCDSPedido = 'CDSPedido'; // Parte de Tabela de PreÃ§o e Frete
  FCDSCondicaoTabela = 'CDSCondicaoTabela'; // CondiÃ§Ã£o da Tabela de PreÃ§o
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

{$Region 'VariÃ¡veis'}
var
  FItemMenu, FCadastro,
  FDM, FArea: string;

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
    raise exception.Create(MensagemPersonalizada + #13 + 'Processamento nÃ£o disponÃ­vel para execuÃ§Ã£o pelo servidor!');

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
  P39_TDD_MODULO.SetModulo(cModuloFaturamento);
  FCDSConfigFaturamentoCasoTeste.Data := {P95_TDD_CASOS_DE_TESTE}GetConfiguracao;
end;

procedure Setup_IniciarFormulario;
begin
  FTelaPedidoAberta := False;
  FItemMenu := 'Emisso1'; // Nome do Menu para forÃ§ar o click e chamar a tela
  
  {TDD_MODULO}AbrirTela('Emisso1Click');

  FormCadastro := FormCriadoPeloNome(FCadastro);
  if not Assigned(FormCadastro) then
    FormCadastro := CriarFormPeloNome(FCadastro);

  if not Assigned(FormCadastro) then
    raise exception.Create('NÃ£o encontrado Form ' + FormCadastro);
  
  //DM := DMCriadoPeloNome(FDM);
  DM := FormCadastro.FindComponent(FDM);

  if not Assigned(DM) then
    raise exception.Create('NÃ£o encontrado DM ' + FDM);

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
    raise exception.Create('NÃ£o encontrado CDSCadastro');

//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSCadastro + '|' + FDM);
//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSItem + '|' + FDM);
//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSFiscal + '|' + FDM);
//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSPedido + '|' + FDM);
//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSCondicaoTabela + '|' + FDM);
//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSCondicaoDetalhe + '|' + FDM);
//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSDescontoPrincipal + '|' + FDM);
//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSItemDesconto + '|' + FDM);
//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSTabela + '|' + FDM);
//  {P39_TDD_ASSERTS}RegistrarDataSet(FCDSPrazos + '|' + FDM);

  BotaoIncluir := FormCadastro.FindComponent(FBotaoIncluir);
  BotaoGravar  := FormCadastro.FindComponent(FBotaoGravar);
  
  FormCadastro.Show;
  FTelaPedidoAberta := True;
  Sleep(1000);
end;

procedure FinalizarFormulario;
begin
  FormCadastro.Free;
  {TDD_MODULO}FocarModulo;
  {TDD_MODULO}TrazerParaFrente;
  FTelaPedidoAberta := False;
end;

procedure TearDown_DestruirObjetos;
begin
  FCDSClientes.Free;
  FCDSProdutos.Free;
  FCDSConfigFaturamentoCasoTeste.Free;
  ScriptDeTestesEmExecucao := False;
  TearDown_Finalizar_CasosTeste;
end;

procedure Teste_Executar;
begin
  if CDSCasosTestes.IsEmpty then
    raise Exception.Create(MensagemPersonalizada + 'NÃ£o hÃ¡ casos de teste para ser executado.');  

  //MostrarLogTexto(MetodosDeObjeto(FormCadastro));
  try
    CDSCasosTestes.First;
    while not CDSCasosTestes.Eof do
    begin
      SetCasoTeste(CDSCasosTestes.FieldByName('CASOTESTE').AsString);
      
      _IncluiDocumento();
      
      CDSCasosTestes.Edit;
      CDSCasosTestes.FieldByName('EXECUTADO').AsString := 'S';
      CDSCasosTestes.Post;
      
      // Validacao do resultado esperado (TDD_FAT_VALIDAR_RESULTADO -> TDD_ASSERTS).
      //ShowMessage('Comparando Resultado....');
      //P39_TDD_FAT_VALIDAR_RESULTADO.CompararResultadoEsperado;
      //ShowMessage('Comparado.....');

      CDSCasosTestes.Next;
    end;  
           
  finally
    //ExecutarMetodoDeObjeto(FormCadastro, 'BringToFront');
//    FormCadastro.Close;
//    TearDown_DestruirObjetos;
  end;
end;

procedure _IncluiDocumento;
var lTag, lCliente: Integer;
begin
  if FCDSConfigFaturamentoCasoTeste.IsEmpty then
  begin
    EnviarMensagemInterna(Nome_Usuario_Atual, 'Teste Automatizado - Erro!', 'ConfiguraÃ§Ã£o NÃ£o Carregaga.');
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
    //Sleep(300);
    
    P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_PRINCIPAIS._DadosPrincipais;
    P39_TDD_FAT_DOCUMENTO_FATURA_FINANCEIRO._Financeiro;
    P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_ENTREGA._DadosParaEntrega;
    P39_TDD_FAT_DOCUMENTO_FATURA_DADOS_FATURAMENTO._DadosFaturamento;
    P39_TDD_FAT_DOCUMENTO_FATURA_INFORMACOES_FRETE._InformacoesFrete;
    ExecutarMetodoDeObjeto(BotaoGravar, 'Click');
    //Sleep(300);
    //Break;
    FCDSClientes.Next;
  end;
end;

procedure SetCasoTeste(pCasoTeste: String);
var
  LObj: TJSONObject;
  FJSONDOC, FJSONITEMCONF, FJSONITENS: String;
begin
  LimparRegistrosCasoTeste;
   
  FJSONDOC      := '';
  FJSONITEMCONF := '';
  FJSONITENS    := '';

  FJSONDOC      := GetObjectJson(pCasoTeste, 'documento');
  FJSONITEMCONF := GetObjectJson(pCasoTeste, 'item');
  FJSONITENS    := GetArrayJsonOrEmpty(FJSONITEMCONF, 'itens');
  
  LObj := TJSONObject.ParseJSONValue(GetObjectJson(pCasoTeste, 'parametros'));
  try
    if LObj.Count > 0 then
      _AjustarParametros(LObj.ToJson);  
  finally
    LObj.Free;
  end;

  SetJSON_Caso_Teste(FJSONDOC, FJSONITEMCONF, FJSONITENS);
  ValidarCasoTeste;
end;

procedure _AjustarParametros(pParams: String);
begin
  if FTelaPedidoAberta then
    FinalizarFormulario;
    
  try
    {TDD_PARAMETRO}VerificarParametros(pParams);
  finally
    //Sleep(2000);
    Setup_IniciarFormulario;
  end;  
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
    raise Exception.Create(MensagemPersonalizada + 'NÃ£o hÃ¡ clientes para inclusÃ£o.');
end;