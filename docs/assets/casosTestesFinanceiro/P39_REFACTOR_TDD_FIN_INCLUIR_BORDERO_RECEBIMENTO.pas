uses P39_TDD_CARREGAR_CASO_TESTE, P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO, P39_TDD_FUNCOES_JSON;

// ---------------------- Incluir BorderÃ´ de Recebimento (PadrÃ£o Faturamento) -------------------------- //

const
  cModuloFinanceiro   = 'FINANCEIRO';
  cAreaBorderoReceber = 'BORDERÃ';
  cCasoTesteReceber   = 'CADASTRAR DUPLICATA A RECEBER';

var
  FCDSCasoTeste         :TClientDataSet;
  FCDSConfig            :TClientDataSet;

  FJSONCasoTeste        :string;

  FCasoTesteInvalido    :boolean;
  FMsgCasoTesteInvalido :string;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Essa Unit foi desenvolvida para incluir um BorderÃ´ de Recebimento e baixar as duplicatas criadas no caso de teste.' + #13 +
    'O fluxo segue o padrÃ£o de faturamento (Setup/Teste) e lÃª o caso de teste do banco dedicado.'                                     + #13 + #13 +
    'Diversos CDSs estÃ£o disponÃ­vel por meio de: P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.'                                 + #13 +
    'Os seguintes mÃ©todos foram disponibilizados:'                                                                                    + #13 +
    ' - procedure IncluirBorderoRecebimento'                                                                                          + #13 +
    '   + Executa o fluxo completo: Setup, Teste e TearDown.'                                                                         + #13 + #13 +
    'Caso de Teste utilizado:'                                                                                                        + #13 +
    '   MÃ³dulo : ' + cModuloFinanceiro                                                                                                + #13 +
    '   Ãrea   : ' + cAreaBorderoReceber                                                                                              + #13 +
    '   Teste  : ' + cCasoTesteReceber;  
  MostrarLogTexto(lInstrucoes, 'InstruÃ§Ãµes TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO');
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

  {TDD_CARREGAR_CASO_TESTE.}CarregarCasoTeste(cModuloFinanceiro, cAreaBorderoReceber, cCasoTesteReceber, FCDSCasoTeste);

  FJSONCasoTeste := FCDSCasoTeste.FieldByName('JSON_CASO_TESTE').AsString;

  FCDSConfig.Close;
  FCDSConfig.Data := {TDD_ODBC.}TDDReaderODBC(GetSQLSelectFinanceiroConfig);

  if FCDSConfig.IsEmpty then
    raise Exception.Create(MensagemPersonalizada + 'ConfiguraÃ§Ã£o financeira nÃ£o carregada.');

  ValidarCasoTeste;
end;

procedure Setup_IniciarFormulario;
begin
  {P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}MapearBordero;
end;

procedure TearDown_DestruirObjetos;
begin
  FCDSCasoTeste.Free;
  FCDSConfig.Free;
end;

procedure Teste_Executar;
begin
  if FCDSCasoTeste.IsEmpty then
    raise Exception.Create(MensagemPersonalizada + 'NÃ£o hÃ¡ caso de teste para ser executado.');

  if FCasoTesteInvalido then
  begin
    EnviarMensagemInterna(Nome_Usuario_Atual, 'Teste Automatizado - Erro!', FMsgCasoTesteInvalido);
    Exit;
  end;

  _IncluiBorderoRecebimento;
end;

procedure SetCasoTeste(pCasoTeste :string);
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
  VlrPagar :Currency;
  lPessoa  :Integer;
begin
  VlrPagar := 0;

  {P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}IncluirBordero;

  lPessoa := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FJSONCasoTeste, 'PESSOA_DUP', 0);
  if lPessoa = 0 then
    lPessoa := FCDSConfig.FieldByName('CLIENTE_FINCONFIG').AsInteger;

  edtCliente.SetFocus;
  CDSCadastro.FieldByName('PESSOA_BORDERO').AsInteger := lPessoa;
  edtNovoBanco.SetFocus;

  {P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}Filtrar;
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

  PageControl1.ActivePage := TSComplementos;

  CDSComplementos.Insert;
  CDSComplementos.FieldByName('CONTA_COMPLBORD').AsCurrency := FCDSConfig.FieldByName('CONTA_PRINCIPAL_FINCONFIG').AsInteger;
  CDSComplementos.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
  CDSComplementos.Post;

  {P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}GravarBordero;
end;

// ---------------------- FunÃ§Ãµes Auxiliares -------------------------- //

function GetSQLSelectFinanceiroConfig: string;
begin
  Result := 'SELECT * FROM FINANCEIRO_CONFIGURACAO';
end;
