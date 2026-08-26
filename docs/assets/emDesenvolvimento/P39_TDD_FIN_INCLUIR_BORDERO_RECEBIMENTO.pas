uses TDD_CARREGAR_CASO_TESTE, TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO, P39_TDD_FUNCOES_JSON;

// ---------------------- Incluir Borderô de Recebimento (Padrão Faturamento) -------------------------- //

const
  cModuloFinanceiro   = 'FINANCEIRO';
  cAreaBorderoReceber = 'BORDERÔ';
  cCasoTesteReceber   = 'CADASTRAR DUPLICATA A RECEBER';

var
  FCDSCasoTeste: TClientDataSet;
  FCDSConfig: TClientDataSet;

  FJSONCasoTeste: String;

  FCasoTesteInvalido: Boolean;
  FMsgCasoTesteInvalido: String;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Essa Unit foi desenvolvida para incluir um Borderô de Recebimento e baixar as duplicatas criadas no caso de teste.' + #13 +
    'O fluxo segue o padrão de faturamento (Setup/Teste) e lê o caso de teste do banco dedicado.'                                 + #13 + #13 +
    'Os seguintes métodos foram disponibilizados:'                                                                                + #13 +
    ' - procedure IncluirBorderoRecebimento'                                                                                      + #13 +
    '   + Executa o fluxo completo: Setup, Teste e TearDown.'                                                                     + #13 + #13 +
    'Caso de Teste utilizado:'                                                                                                    + #13 +
    '   Módulo : ' + cModuloFinanceiro                                                                                            + #13 +
    '   Área   : ' + cAreaBorderoReceber                                                                                          + #13 +
    '   Teste  : ' + cCasoTesteReceber;
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO');
end;

procedure IncluirBorderoRecebimento;
begin
  Setup;
  try
    Teste;
  finally
    TearDown_DestruirObjetos;
  end;
end;

procedure Setup;
begin
  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, '[SETUP] Inicializando....');
    Setup_Inicializar;
  finally
    CallBack_FechaTela(ClassOwner);
  end;
end;

procedure Teste;
begin
  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, 'Executando Teste.....');
    Teste_Executar;
  finally
    CallBack_FechaTela(ClassOwner);
  end;
end;

procedure Setup_Inicializar;
begin
  Setup_InicializarObjetos;
  Setup_IniciarFormulario;
end;

procedure Setup_InicializarObjetos;
begin
  FCDSCasoTeste := TClientDataSet.Create;
  FCDSConfig    := TClientDataSet.Create;

  {TDD_CARREGAR_CASO_TESTE.}CarregarCasoTeste(FCDSCasoTeste, cModuloFinanceiro, cAreaBorderoReceber, cCasoTesteReceber);

  FJSONCasoTeste := FCDSCasoTeste.FieldByName('JSON_CASO_TESTE').AsString;

  FCDSConfig.Close;
  FCDSConfig.Data := TDDReaderODBC(GetSQLSelectFinanceiroConfig, null);

  if FCDSConfig.IsEmpty then
    raise Exception.Create(MensagemPersonalizada + 'Configuração financeira não carregada.');

  ValidarCasoTeste;
end;

procedure Setup_IniciarFormulario;
begin
  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}MapearBordero;
end;

procedure TearDown_DestruirObjetos;
begin
  FCDSCasoTeste.Free;
  FCDSConfig.Free;
end;

procedure Teste_Executar;
begin
  if FCDSCasoTeste.IsEmpty then
    raise Exception.Create(MensagemPersonalizada + 'Não há caso de teste para ser executado.');

  if FCasoTesteInvalido then
  begin
    EnviarMensagemInterna(Nome_Usuario_Atual, 'Teste Automatizado - Erro!', FMsgCasoTesteInvalido);
    Exit;
  end;

  _IncluiBorderoRecebimento;
end;

procedure SetCasoTeste(pCasoTeste: String);
begin
  FJSONCasoTeste := pCasoTeste;
  ValidarCasoTeste;
end;

procedure ValidarCasoTeste;
begin
  FMsgCasoTesteInvalido := '';

  if Trim(FJSONCasoTeste) = '' then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'JSON do caso de teste vazio! (JSON_CASO_TESTE)';

  FCasoTesteInvalido := (FMsgCasoTesteInvalido <> '');
end;

procedure _IncluiBorderoRecebimento;
var
  VlrPagar: Currency;
  lPessoa: Integer;
begin
  VlrPagar := 0;

  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}IncluirBordero;

  lPessoa := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FJSONCasoTeste, 'PESSOA_DUP', 0);
  if lPessoa = 0 then
    lPessoa := FCDSConfig.FieldByName('CLIENTE_FINCONFIG').AsInteger;

  edtCliente.SetFocus;
  CDSCadastro.FieldByName('PESSOA_BORDERO').AsInteger := lPessoa;
  edtNovoBanco.SetFocus;

  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}Filtrar;
  PageControl1.ActivePage := TSReceber;

  if not CDSReceber.IsEmpty then
  begin
    CDSReceber.First;
    while not CDSReceber.Eof do
    begin
      CDSReceber.Edit;
      VlrPagar := VlrPagar + CDSReceber.FieldByName('VLREMABERTO').AsCurrency;
      CDSReceber.FieldByName('MARQUE').AsInteger := 1;
      CDSReceber.Post;
      CDSReceber.Next;
    end;
  end;

  if not CDSProrrogacoes.IsEmpty then
  begin
    CDSProrrogacoes.First;
    while not CDSProrrogacoes.Eof do
    begin
      CDSProrrogacoes.Edit;
      CDSProrrogacoes.FieldByName('MARQUE').AsInteger := 1;
      VlrPagar := VlrPagar + CDSProrrogacoes.FieldByName('VALORCOBRADO_PRORROGACAO').AsCurrency;
      CDSProrrogacoes.Post;
      CDSProrrogacoes.Next;
    end;
  end;

  if VlrPagar = 0 then
    raise Exception.Create(MensagemPersonalizada +
      'Não há duplicatas a receber em aberto para a pessoa ' + IntToStr(lPessoa) + '.' + #13 +
      'Verifique o PESSOA_DUP do JSON do caso de teste e o CLIENTE_FINCONFIG da configuração financeira.');

  PageControl1.ActivePage := TSComplementos;

  CDSComplementos.Insert;
  CDSComplementos.FieldByName('CONTA_COMPLBORD').AsCurrency := FCDSConfig.FieldByName('CONTA_PRINCIPAL_FINCONFIG').AsInteger;
  CDSComplementos.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
  CDSComplementos.Post;

  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}GravarBordero;
end;

// ---------------------- Funções Auxiliares -------------------------- //

function GetSQLSelectFinanceiroConfig: string;
begin
  Result := 'SELECT * FROM FINANCEIRO_CONFIGURACAO';
end;
