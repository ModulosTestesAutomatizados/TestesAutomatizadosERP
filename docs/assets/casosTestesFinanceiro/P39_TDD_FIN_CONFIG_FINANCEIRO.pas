uses P39_TDD_GERAL_CONFIG_PRINCIPAL, P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO;

var
  Frm: TForm;

  CDSFinConfig: TCLientDataSet;
  DSFinConfig: TDataSource;

  { GroupBox - Pessoas }
  grpPessoas      : TGroupBox;
  lblFinCliente   : TLabel;
  lblFinFornecedor: TLabel;
  edtFinCliente   : TDBEdit;
  edtFinFornecedor: TDBEdit;
 
  { GroupBox - Grupo de Resultado }
  grpGrupoResultado: TGroupBox;
  GRContasReceber  : TLabel;
  Label23          : TLabel;
  DBEdit1          : TDBEdit;
  DBEdit2          : TDBEdit;
 
  { GroupBox - Relacionamento }
  grpFinRelacionamento: TGroupBox;
  lblFinTipo          : TLabel;
  lblFinSituacao      : TLabel;
  lblFinBanco         : TLabel;
  lblFormaPgto        : TLabel;
  lblFinProjeto       : TLabel;
  Label25             : TLabel;
  lblFinIntermediador : TLabel;
  edtFinTipo          : TDBEdit;
  edtFinSituacao      : TDBEdit;
  edtFinBanco         : TDBEdit;
  edtFinFormPagto     : TDBEdit;
  edtFinProjeto       : TDBEdit;
  edtFinanceira       : TDBEdit;
  edtFinIntermediador : TDBEdit;

  lblVlrPadraoReceber,
  lblVlrPadraoPagar,
  lblContaPrincipal: TLabel;
  edtVlrPadraoReceber,
  edtContaPrincipal,
  edtVlrPadraoPagar: TDBEdit;

  //  ------------  VariÃ¡veis para InclusÃ£o de Duplicatas Pagar/Receber -------------------//
  FDuplicatas: TForm;
  DMDuplicatas: TDataModule;
  
  CDSConfig,
  CDSCadastro,
  CDSGrupResult: TClientDataSet;
  cePessoa: TComponent;
  
procedure Main();
begin
  CriarFormConfiguracaoFinanceiro;
end; 

procedure CriarFormConfiguracaoFinanceiro;
begin
  Frm := TForm.Create(nil);
  
  CDSFinConfig := TClientDataSet.Create;
  DSFinConfig  := TDataSource.Create(Frm); 
  
  DSFinConfig.DataSet := CDSFinConfig;
  try
    Frm := _CriarFormularioGenerico('ConfiguraÃ§Ã£o do Financeiro');
  
    CDSFinConfig.Data := ExecuteReaderODBC(ConexaoODBC, GetSQLSelectFinanceiroConfig);  
    CDSFinConfig.ReadOnly := False;
    
    CriarFormularioFinanceiro(Frm);

    Frm.ShowModal;
  finally
    Frm.Free;
    Frm := nil; 
    CDSFinConfig.Free;  
  end;  
end;  

procedure CriarFormularioFinanceiro(AForm: TForm);
begin 

{ ===========================================================
    GROUPBOX: PESSOAS
    =========================================================== }
  grpPessoas          := TGroupBox.Create(AForm);
  grpPessoas.Parent   := tsConfiguracao;
  grpPessoas.Left     := 15; 
  grpPessoas.Top      := 15;
  grpPessoas.Width    := 231; 
  grpPessoas.Height   := 71;
  grpPessoas.Caption  := 'Pessoas';
  grpPessoas.TabOrder := 0;
 
  lblFinCliente    := _CriarLabel(AForm, grpPessoas, 15, 21, 'Cliente');
  lblFinFornecedor := _CriarLabel(AForm, grpPessoas, 15, 48, 'Fornecedor');
 
  edtFinCliente    := _CriarEditNumerico(AForm, grpPessoas, 107, 17, 121, 0, DSFinConfig, 'CLIENTE_FINCONFIG');
  edtFinFornecedor := _CriarEditNumerico(AForm, grpPessoas, 107, 44, 121, 1, DSFinConfig, 'FORNECEDOR_FINCONFIG');
 
  { ===========================================================
    GROUPBOX: GRUPO DE RESULTADO
    =========================================================== }
  grpGrupoResultado          := TGroupBox.Create(AForm);
  grpGrupoResultado.Parent   := tsConfiguracao;
  grpGrupoResultado.Left     := 15;  grpGrupoResultado.Top    := 92;
  grpGrupoResultado.Width    := 231; grpGrupoResultado.Height := 79;
  grpGrupoResultado.Caption  := 'Grupo de Resultado';
  grpGrupoResultado.TabOrder := 1;
 
  GRContasReceber := _CriarLabel(AForm, grpGrupoResultado, 15, 26, 'Contas a Receber');
  Label23         := _CriarLabel(AForm, grpGrupoResultado, 15, 58, 'Contas a Pagar');
 
  DBEdit1 := _CriarEditNumerico(AForm, grpGrupoResultado, 107, 22, 121, 0, DSFinConfig, 'GR_CONTAS_RECEBER_FINCONFIG');
  DBEdit2 := _CriarEditNumerico(AForm, grpGrupoResultado, 107, 54, 121, 1, DSFinConfig, 'GR_CONTAS_PAGAR_FINCONFIG');
 
  { ===========================================================
    GROUPBOX: RELACIONAMENTO
    =========================================================== }
  grpFinRelacionamento          := TGroupBox.Create(AForm);
  grpFinRelacionamento.Parent   := tsConfiguracao;
  grpFinRelacionamento.Left     := 15;  grpFinRelacionamento.Top    := 173;
  grpFinRelacionamento.Width    := 231; grpFinRelacionamento.Height := 179;
  grpFinRelacionamento.Caption  := 'Relacionamento';
  grpFinRelacionamento.TabOrder := 2;
 
  lblFinTipo          := _CriarLabel(AForm, grpFinRelacionamento, 10, 17,  'Tipo');
  lblFinSituacao      := _CriarLabel(AForm, grpFinRelacionamento, 10, 41,  'SituaÃ§Ã£o');
  lblFinBanco         := _CriarLabel(AForm, grpFinRelacionamento, 10, 64,  'Banco');
  lblFormaPgto        := _CriarLabel(AForm, grpFinRelacionamento, 10, 88,  'Forma Pagto');
  lblFinProjeto       := _CriarLabel(AForm, grpFinRelacionamento, 10, 112, 'Projeto');
  Label25             := _CriarLabel(AForm, grpFinRelacionamento, 10, 135, 'Financeira');
  lblFinIntermediador := _CriarLabel(AForm, grpFinRelacionamento, 10, 158, 'Intermediador');
  
  edtFinTipo          := _CriarEditNumerico(AForm, grpFinRelacionamento, 107, 13,  121, 0, DSFinConfig, 'TIPO_FINCONFIG');
  edtFinSituacao      := _CriarEditNumerico(AForm, grpFinRelacionamento, 107, 37,  121, 1, DSFinConfig, 'SITUACAO_FINCONFIG');
  edtFinBanco         := _CriarEditNumerico(AForm, grpFinRelacionamento, 107, 60,  121, 2, DSFinConfig, 'BANCO_FINCONFIG');
  edtFinFormPagto     := _CriarEditNumerico(AForm, grpFinRelacionamento, 107, 84,  121, 3, DSFinConfig, 'FORMA_PAGTO_FINCONFIG');
  edtFinProjeto       := _CriarEditNumerico(AForm, grpFinRelacionamento, 107, 108, 121, 4, DSFinConfig, 'PROJETO_FINCONFIG');
  edtFinanceira       := _CriarEditNumerico(AForm, grpFinRelacionamento, 107, 131, 121, 5, DSFinConfig, 'FINANCEIRA_FINCONFIG');
  edtFinIntermediador := _CriarEditNumerico(AForm, grpFinRelacionamento, 107, 154, 121, 6, DSFinConfig, 'INTERMEDIADOR_FINCONFIG');

  // -----  Valor PadrÃ£o Contas a Receber e A Pagar --------- //

  lblVlrPadraoReceber := _CriarLabel(AForm, tsConfiguracao, 270, 35, 'Valor PadrÃ£o Contas a Receber');
  lblVlrPadraoPagar   := _CriarLabel(AForm, tsConfiguracao, 270, 62, 'Valor PadrÃ£o Contas a Pagar');
  lblContaPrincipal   := _CriarLabel(AForm, tsConfiguracao, 270, 92, 'Conta Principal (BorderÃ´)');
  edtVlrPadraoReceber := _CriarEditNumerico(AForm, tsConfiguracao, 426, 32,  121, 3, DSFinConfig, 'VALOR_PADRAO_RECEBER_FINCONFIG');
  edtVlrPadraoPagar   := _CriarEditNumerico(AForm, tsConfiguracao, 426, 59,  121, 4, DSFinConfig, 'VALOR_PADRAO_PAGAR_FINCONFIG');
  edtContaPrincipal   := _CriarEditNumerico(AForm, tsConfiguracao, 426, 89,  121, 5, DSFinConfig, 'CONTA_PRINCIPAL_FINCONFIG');
end;

function GetSQLSelectFinanceiroConfig: string;
begin
  Result :=
    'SELECT ' + #13 +
    '*' + #13 +
    'FROM FINANCEIRO_CONFIGURACAO';
end;

function GetSQLUpdateFinanceiroConfig: string;
begin
  Result :=
    'UPDATE FINANCEIRO_CONFIGURACAO SET' + #13 +
    '  CLIENTE_FINCONFIG = '            + IntToStr(CDSFinConfig.FieldByName('CLIENTE_FINCONFIG').AsInteger) + ',' + #13 +
    '  FORNECEDOR_FINCONFIG = '         + IntToStr(CDSFinConfig.FieldByName('FORNECEDOR_FINCONFIG').AsInteger) + ',' + #13 +
    '  TIPO_FINCONFIG = '               + IntToStr(CDSFinConfig.FieldByName('TIPO_FINCONFIG').AsInteger) + ',' + #13 +
    '  SITUACAO_FINCONFIG = '           + IntToStr(CDSFinConfig.FieldByName('SITUACAO_FINCONFIG').AsInteger) + ',' + #13 +
    '  BANCO_FINCONFIG = '              + IntToStr(CDSFinConfig.FieldByName('BANCO_FINCONFIG').AsInteger) + ',' + #13 +
    '  FORMA_PAGTO_FINCONFIG = '        + IntToStr(CDSFinConfig.FieldByName('FORMA_PAGTO_FINCONFIG').AsInteger) + ',' + #13 +
    '  PROJETO_FINCONFIG = '            + IntToStr(CDSFinConfig.FieldByName('PROJETO_FINCONFIG').AsInteger) + ',' + #13 +
    '  FINANCEIRA_FINCONFIG = '         + IntToStr(CDSFinConfig.FieldByName('FINANCEIRA_FINCONFIG').AsInteger) + ',' + #13 +
    '  INTERMEDIADOR_FINCONFIG = '      + IntToStr(CDSFinConfig.FieldByName('INTERMEDIADOR_FINCONFIG').AsInteger) + ',' + #13 +
    '  GR_CONTAS_RECEBER_FINCONFIG = '  + IntToStr(CDSFinConfig.FieldByName('GR_CONTAS_RECEBER_FINCONFIG').AsInteger) + ',' + #13 +
    '  GR_CONTAS_PAGAR_FINCONFIG = '    + IntToStr(CDSFinConfig.FieldByName('GR_CONTAS_PAGAR_FINCONFIG').AsInteger) + ',' + #13 +
    '  VALOR_PADRAO_RECEBER_FINCONFIG = ' + CurrToStr(CDSFinConfig.FieldByName('VALOR_PADRAO_RECEBER_FINCONFIG').AsCurrency) + ',' + #13 +
    '  VALOR_PADRAO_PAGAR_FINCONFIG = '   + CurrToStr(CDSFinConfig.FieldByName('VALOR_PADRAO_PAGAR_FINCONFIG').AsCurrency) + ',' + #13 +
    '  CONTA_PRINCIPAL_FINCONFIG = '      + IntToStr(CDSFinConfig.FieldByName('CONTA_PRINCIPAL_FINCONFIG').AsInteger);
end;

procedure BtnGravarClick(Sender: TObject);
begin
  ExecuteCommandODBC(ConexaoODBC, GetSQLUpdateFinanceiroConfig);

  ShowMessage('InformaÃ§Ãµes salvas com sucesso');
end;