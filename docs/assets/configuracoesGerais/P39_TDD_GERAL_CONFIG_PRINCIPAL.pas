const ConexaoODBC = 'TESTE_AUTOMATIZADO';

var 
  { PainÃ©is }
  pnlPrincipal      : TPanel;
  pnlInferior       : TPanel;

  { BotÃµes }
  btnSalvar       : TButton;
  btnCancelar     : TButton;

  { PageControls }
  PCModulos         : TPageControl;

  { Abas de faturamento }
  tsConfiguracao    : TTabSheet;

function _CriarFormularioGenerico(pCaption: String): TForm;
begin
  Result := CriarFormPeloNome('FPai');
  Result.Caption      := pCaption;
  Result.ClientWidth  := 1060;
  Result.ClientHeight := 712;
  Result.Position     := poScreenCenter;
  Result.Font.Name    := 'Tahoma';
  Result.Font.Height  := -11;
  Result.OnKeyDown    := _FormKeyDown;

  { =========================================================
    PAINEL INFERIOR
    ========================================================= }
    pnlInferior        := TPanel.Create(Result);
    pnlInferior.Parent := Result;
    pnlInferior.Align  := alBottom;
    pnlInferior.Height := 72;
    
    btnCancelar         := TButton.Create(Result);
    btnCancelar.Parent  := pnlInferior;
    btnCancelar.Align   := alRight;
    btnCancelar.Width   := 106;
    btnCancelar.Caption := 'Cancelar';
    btnCancelar.OnClick := _BtnCancelarClick;

    btnSalvar         := TButton.Create(Result);
    btnSalvar.Parent  := pnlInferior;
    btnSalvar.Align   := alRight;
    btnSalvar.Width   := 106;
    btnSalvar.Caption := 'Gravar';
    btnSalvar.OnClick := BtnGravarClick;

  { =========================================================
    PAINEL PRINCIPAL
    ========================================================= }
  pnlPrincipal        := TPanel.Create(Result);
  pnlPrincipal.Parent := Result;
  pnlPrincipal.Align  := alClient;

  { =========================================================
    PAGE CONTROL DE MÃDULOS
    ========================================================= }
  PCModulos        := TPageControl.Create(Result);
  PCModulos.Parent := pnlPrincipal;
  PCModulos.Align  := alClient;

  { -- Sub-aba ConfiguraÃ§Ã£o ---------------------------------- }
  tsConfiguracao             := TTabSheet.Create(Result);
  tsConfiguracao.PageControl := PCModulos;
  tsConfiguracao.Caption     := 'ConfiguraÃ§Ã£o';
  tsConfiguracao.ImageIndex  := 1;
  tsConfiguracao.PageIndex   := 0;
  PCModulos.ActivePage   := tsConfiguracao;

  { Aba ativa inicial }
  PCModulos.ActivePage := tsConfiguracao;
end;

function _CriarEditNumerico(AOwner: TComponent; AParent: TWinControl; ALeft, ATop, AWidth, ATabOrder: Integer; pDS: TDataSource = nil; const pNomeCampo: string = ''): TDBEdit;
begin
  Result := TDBEdit.Create(AOwner);

  Result.Parent   := AParent;
  Result.Left     := ALeft;
  Result.Top      := ATop;
  Result.Width    := AWidth;
  Result.Height   := 21;
  Result.TabOrder := ATabOrder;
  Result.ReadOnly := False;

  // VinculaÃ§Ã£o opcional ao dataset
  if Assigned(pDS) and (pNomeCampo <> '') then
  begin    
    Result.DataSource := pDS;
    Result.DataField  := pNomeCampo;
    Result.ReadOnly := False;
  end;
end;

{ ============================================================
  FunÃ§Ã£o auxiliar: cria um TLabel simples
  ============================================================ }
function _CriarLabel(AOwner: TWinControl; AParent: TWinControl;
  ALeft, ATop: Integer; const ACaption: string): TLabel;
begin
  Result         := TLabel.Create(AOwner);
  Result.Parent  := AParent;
  Result.Left    := ALeft;
  Result.Top     := ATop;
  Result.Caption := ACaption;
end;

procedure _FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and (Assigned(Frm)) and (Shift = []) then
  begin    
    if (Confirma('Deseja Fechar o Processamento?')) then
      Frm.Close;
  end;
end;

procedure _BtnCancelarClick(Sender: TObject);
begin  
  if Assigned(Sender) then
    Frm.Close;
end;