//uses
//  MOVIMENTO_CAIXA;  

const 
  cFCadBorderoAcerto  = 'FCadBorderoAcerto';
  cDMCadBorderoAcerto = 'DMCadBorderoAcerto';

var
  FCadBorderoAcerto:  TForm;
  DMCadBorderoAcerto: TDataModule;
  
  EditCodigo:         TJvCalcEdit;
  edtCliente:         TJvDBCalcEdit;
  
  PageControl1: TPageControl;
  CDSCadastro: TClientDataSet;
  CDSReceber: TClientDataSet;
  CDSProrrogacoes: TClientDataSet;
  CDSPagar: TClientDataSet;
  CDSOrdemPagto:     TClientDataSet;
  CDSGrupoResultado: TClientDataSet;
  CDSComplementos:   TClientDataSet;
  CDSChequeSaida:    TClientDataSet;
  CDSCheques:        TClientDataSet;
  CDSMovCartao:      TClientDataSet;
  
  {$Region 'Principal'}
    cbSubTipo:          TJvDBComboBox; 
    cbQualificacao:     TJvDBComboBox;
    cbCalcJuroDesconto: TJvDBComboBox;
    edtDiasDescarga:    TJvDBCalcEdit;
    edtNovoBanco:       TJvDBCalcEdit;
    edtNovaSituacao:    TJvDBCalcEdit;
    edtNovaConta:       TJvDBCalcEdit;
    edtTaxaMensal:      TJvDBCalcEdit;
    edtCaracteristica:  TJvDBCalcEdit;
    DataAcerto:         TJvDBDateEdit;
    mmObs:              TDBMemo;
  {$endRegion}
  
  {$Region 'Totalização'}
    TotalCredito:            TLabel;
    GRManuais:               TLabel;
    Prorrogacoes:            TLabel;
    CreditoNaoUtilizado:     TLabel;
    TotalDebito:             TLabel;
    VlrNominalBaixado:       TLabel;
    VlrAindaAberto:          TLabel;
    TotalDebitosAtualizados: TLabel;
    JurosCalculados:         TLabel;
    DescontosCalculados:     TLabel;
    Diferenca:               TLabel;
    PrazosMediosDebito:      TLabel;
    PrazosMediosCredito:     TLabel;
    PrazosMediosGeral:       TLabel;
 {$endRegion}
  
  {$Region 'Filtros'}
    ExibirContasReceberDescontadas:     TCheckBox;
    ExibirContasReceberDesconsideradas: TCheckBox;
    ExibirContasAPagar:                 TCheckBox;
    ExibirMovCartao:                    TCheckBox;
    chkDataFinalVencimentoDuplicatas:   TCheckBox;
    DataIniPagar:                       TJvDateEdit;
    DataFimPagar:                       TJvDateEdit;
    DataIniCartao:                      TJvDateEdit;
    DataFimCartao:                      TJvDateEdit;
    DtFinalVenc:                        TJvDateEdit;
  {$endRegion} 
 
  {$Region 'Contabilidade'}
    edtOperacao: TDBEdit;
    edtIntegracaoCTB: TJvDBCalcEdit;
    edtCodigoImportacao: TDBEdit;
    edtDataInicial: TJvDBDateEdit;
    edtDataFinal: TJvDBDateEdit;
  {$endRegion}
 
  {$Region 'TabSheets'}
    TabSheet1: TTabSheet;
    TSContabilidade: TTabSheet;
    TSDados: TTabSheet;
    TSEmpresa: TTabSheet;
    TSChequeSaida: TTabSheet;
    TSOrdemPgto: TTabSheet;
    TSMovCartao: TTabSheet;
    TSCheque: TTabSheet;
    TSComplementos: TTabSheet;
    TSGrupoResultado: TTabSheet;
    TSCarga: TTabSheet;
    TSSituacao: TTabSheet;
    TSFormaPagamento: TTabSheet;
    TSProrrogacoes: TTabSheet;
    TSReceber: TTabSheet;
    TSPagar: TTabSheet;
  {$endRegion}
  
procedure MapearBordero;
begin
  FCadBorderoAcerto := FormCriadoPeloNome(cFCadBorderoAcerto);
    
  if FCadBorderoAcerto = nil then
    FCadBorderoAcerto  := CriarFormPeloNome(cFCadBorderoAcerto);
  
  DMCadBorderoAcerto := FCadBorderoAcerto.FindComponent(cDMCadBorderoAcerto);
  
  try
    FCadBorderoAcerto.Show;
    CDSCadastro       := DMCadBorderoAcerto.FindComponent('CDSCadastro');
    CDSReceber        := DMCadBorderoAcerto.FindComponent('CDSReceber');
    CDSProrrogacoes   := DMCadBorderoAcerto.FindComponent('CDSProrrogacoes');
    CDSPagar          := DMCadBorderoAcerto.FindComponent('CDSPagar');
    CDSOrdemPagto     := DMCadBorderoAcerto.FindComponent('CDSOrdemPagto');
    CDSGrupoResultado := DMCadBorderoAcerto.FindComponent('CDSGrupoResultado');
    CDSComplementos   := DMCadBorderoAcerto.FindComponent('CDSComplementos');
    CDSChequeSaida    := DMCadBorderoAcerto.FindComponent('CDSChequeSaida'); // DEVOLVIDO
    CDSCheques        := DMCadBorderoAcerto.FindComponent('CDSCheques');
    CDSMovCartao      := DMCadBorderoAcerto.FindComponent('CDSMovCartao');
    EditCodigo        := FCadBorderoAcerto.FindComponent('EditCodigo');
    edtCliente        := FCadBorderoAcerto.FindComponent('EditCliente');
    MapearPrincipal;
    MapearTSFiltros;
    MapearTotalizacao;
    MapearTabSheets;
    MapearContabilidade;
   // MOVIMENTO_CAIXA.EstruturaMovimentoCaixa;
     
  except
    on E:Exception do
    begin
      ShowMessage(MensagemPersonalizada + E.Message);
      FCadBorderoAcerto.Free; 
    end;
  end; 
end;

procedure AbrirBordero(Codigo: Integer; AbreMovCx: Boolean);
begin
  CDSCadastro.Close;
  AtribuirValorPropriedadeDeObjeto(DMCadBorderoAcerto, 'CodigoAtual', Codigo);                   
  CDSCadastro.Open;
  AtribuirValorPropriedadeDeObjeto(EditCodigo, 'Value', Codigo);
  Calcular;
  
  if AbreMovCx then
    MovBordero(Codigo, false);
end;

procedure Calcular;
begin
  ExecutarMetodoDeObjeto(FCadBorderoAcerto, 'BotaoCalcularClick', [Nil]);
end;

procedure IncluirBordero;
begin
  ExecutarMetodoDeObjeto(FCadBorderoAcerto, 'BotaoIncluirClick', [nil]);
end;

procedure GravarBordero;
begin
  ExecutarMetodoDeObjeto(FCadBorderoAcerto, 'BotaoGravarClick', [Nil]);
end;

procedure Excluir;
begin
  ExecutarMetodoDeObjeto(DMCadBorderoAcerto, 'ExcluirRegistro', [false, true]);
end;

procedure Filtrar;
begin
  ExecutarMetodoDeObjeto(FCadBorderoAcerto, 'BotaoFiltrarClick', [nil]);  
end;

procedure Fechar;
begin
  FCadBorderoAcerto.Close;
end;

procedure MapearTSFiltros;
begin
  ExibirContasReceberDescontadas     := FCadBorderoAcerto.FindComponent('cbExibeReceberDescontadas');
  ExibirContasReceberDesconsideradas := FCadBorderoAcerto.FindComponent('cbExibeReceberDesconsiderado');
  ExibirContasAPagar                 := FCadBorderoAcerto.FindComponent('cbExibeContasAPagar');
  DataIniPagar                       := FCadBorderoAcerto.FindComponent('DataIniPagar');
  DataFimPagar                       := FCadBorderoAcerto.FindComponent('DataFimPagar');
  ExibirMovCartao                    := FCadBorderoAcerto.FindComponent('ckExibirMovCartao');
  DataIniCartao                      := FCadBorderoAcerto.FindComponent('dteIniCartao');
  DataFimCartao                      := FCadBorderoAcerto.FindComponent('dteFimCartao');
  chkDataFinalVencimentoDuplicatas   := FCadBorderoAcerto.FindComponent('cxDataFinalVencimentoDuplicatas');  
  DtFinalVenc                        := FCadBorderoAcerto.FindComponent('dteDataFinalVencimentoDuplicatas');
end;
 
 procedure MapearTotalizacao;
begin
  TotalCredito            :=  FCadBorderoAcerto.FindComponent('LabelTotCredito');
  GRManuais               :=  FCadBorderoAcerto.FindComponent('LabelGRManuais');
  Prorrogacoes            :=  FCadBorderoAcerto.FindComponent('LabelProrrogacoes');
  CreditoNaoUtilizado     :=  FCadBorderoAcerto.FindComponent('LabelCreditoNaoUtilizado');
  TotalDebito             :=  FCadBorderoAcerto.FindComponent('LabelTotDebito');
  VlrNominalBaixado       :=  FCadBorderoAcerto.FindComponent('LabelNominalABaixar');
  VlrAindaAberto          :=  FCadBorderoAcerto.FindComponent('LabelAindaAberto');
  TotalDebitosAtualizados :=  FCadBorderoAcerto.FindComponent('LabelTotDebitosAtualizados');
  JurosCalculados         :=  FCadBorderoAcerto.FindComponent('LabelJurosCalculados');
  DescontosCalculados     :=  FCadBorderoAcerto.FindComponent('LabelDescontosCalculados');
  Diferenca               :=  FCadBorderoAcerto.FindComponent('LabelDiferenca');
  PrazosMediosDebito      :=  FCadBorderoAcerto.FindComponent('LabelPMD');
  PrazosMediosCredito     :=  FCadBorderoAcerto.FindComponent('LabelPMC');
  PrazosMediosGeral       :=  FCadBorderoAcerto.FindComponent('LabelPMG');
end;

procedure MapearContabilidade;
begin
  edtOperacao         := FCadBorderoAcerto.FindComponent('edtOperacao');
  edtIntegracaoCTB    := FCadBorderoAcerto.FindComponent('edtIntegracaoCTB');
  edtCodigoImportacao := FCadBorderoAcerto.FindComponent('edtCodigoImportacao');
  edtDataInicial      := FCadBorderoAcerto.FindComponent('edtDataInicial');
  edtDataFinal        := FCadBorderoAcerto.FindComponent('edtDataFinal');
end;

procedure MapearTabSheets;
begin
  TabSheet1       := FCadBorderoAcerto.FindComponent('TabSheet1');
  TSContabilidade := FCadBorderoAcerto.FindComponent('TSContabilidade');
  TSDados         := FCadBorderoAcerto.FindComponent('TSDados');
  TSEmpresa       := FCadBorderoAcerto.FindComponent('tsEmpresa');
  TSChequeSaida   := FCadBorderoAcerto.FindComponent('TSChequeSaida');
  TSOrdemPgto     := FCadBorderoAcerto.FindComponent('TSOrdemPgto');
  TSMovCartao     := FCadBorderoAcerto.FindComponent('tbsMovCartao');
  TSCheque        := FCadBorderoAcerto.FindComponent('TSCheque');
  TSComplementos  := FCadBorderoAcerto.FindComponent('TSComplementos');
  TSGrupoResultado:= FCadBorderoAcerto.FindComponent('TSGrupoResultado');
  TSCarga         := FCadBorderoAcerto.FindComponent('tsCarga');
  TSSituacao      := FCadBorderoAcerto.FindComponent('tsSituacao');
  TSFormaPagamento:= FCadBorderoAcerto.FindComponent('tsFormaPagamento');
  TSProrrogacoes  := FCadBorderoAcerto.FindComponent('TSProrrogacoes');
  TSReceber       := FCadBorderoAcerto.FindComponent('TSReceber');
  TSPagar         := FCadBorderoAcerto.FindComponent('TSPagar');
end;

procedure MapearPrincipal;
begin
  EditCodigo         := FCadBorderoAcerto.FindComponent('EditCodigo');
  PageControl1       := FCadBorderoAcerto.FindComponent('PageControl1');
  cbSubTipo          := FCadBorderoAcerto.FindComponent('CBSubTipo');
  cbQualificacao     := FCadBorderoAcerto.FindComponent('CBQualificacao');
  edtCliente         := FCadBorderoAcerto.FindComponent('EditCliente');
  DataAcerto         := FCadBorderoAcerto.FindComponent('JvDBDateEdit2');
  edtDiasDescarga    := FCadBorderoAcerto.FindComponent('JvDBCalcEdit4');
  edtCaracteristica  := FCadBorderoAcerto.FindComponent('edtCaracteristica');
  edtNovoBanco       := FCadBorderoAcerto.FindComponent('JvDBCalcEditNovoBanco');
  edtNovaSituacao    := FCadBorderoAcerto.FindComponent('JvDBCalcEditNovaSituacao');
  edtNovaConta       := FCadBorderoAcerto.FindComponent('JvDBCalcEditNovaConta');
  cbCalcJuroDesconto := FCadBorderoAcerto.FindComponent('JvDBComboBox2');
  edtTaxaMensal      := FCadBorderoAcerto.FindComponent('JvDBDateEdit4');  
end;
