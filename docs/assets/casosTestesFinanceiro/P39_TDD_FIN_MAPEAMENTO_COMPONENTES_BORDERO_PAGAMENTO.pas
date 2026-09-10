{MAPEAMENTO DOS COMPONENTES DO BORDERÔ DE PAGAMENTO}

const
  cAbaPrincipal     = 0;
  cAbaFiltros       = 1;
  cAbaContabilidade = 2;
  cAbaProrrogacoes  = 3;
  cAbaChqDevolvido  = 4;
  cAbaContasPagar   = 5;
  cAbaAdiantamentos = 6;
  cAbaChqTerceiro   = 7;
  cAbaChqProprio    = 8;
  cAbaComplementos  = 9;
  cAbaReceber       = 10;
  cAbaTotalizacao   = 11;

var 
  fBorderoPagamento: TForm;

  PageControl: TPageControl;
  PageControl2: TPageControl;
  
  cbTipoBordero: TJvDBComboBox;
  cbQualificacaoPagamento: TJvDBComboBox;
  cbCalculoJuros: TJvDBComboBox;

  ceCodBordero: TJvDBCalcEdit;
  ceConta: TJvDBCalcEdit;        
  ceDataAcerto: TJvDBCalcEdit;
  ceTaxaJuros: TJvDBCalcEdit;  
  
  btnIncluir: TNewBtn;
  btnExcluir: TNewBtn;
  btnGravar: TNewBtn;
  btnCancelar: TNewBtn;
  sbUltimo: TNewBtn;
  
  ckProrrogacao,
  ckChequesDev,
  ckDuplicReceber,
  ckExibirBaixados,
  ckConPromessaPag,
  ckExibirDevolvidos,
  ckExibirChequeRecParc,
  ckExibirDupRecParc: TCheckBox;
  
  dtEditProrrogacoesIni,
  dtEditProrrogacoesFim,
  dtEditchequeDevEntreIni,
  dtEditchequeDevEntreFim,
  dtEditContasPgEntreIni,
  dtEditContasPgEntreFim,
  dtEditChequeTerceiroIni,
  dtEditChequeTerceiroFim,
  dtEditDupReceberEntreIni,
  dtEditDupReceberEntreFim: TJvDateEdit;

  // CDSs Vinculados ao Formulario borderô
  CDSPagarPagamento,
  CDSProrrogacaoPagamento,
  CDSChqDevolvido,
  CDSChqTerceiro,
  CDSChqProprio,
  CDSComplementoPagamento,
  CDSReceberPagamento,
  CDSAdiantamento,
  CDSGrupoResultadoPagamento,
  CDSCadastroPagamento: TClientDataSet;
  
  // CDS Temporarios para obter as informações do borderô
  CDSCadastroTemp,
  CDSProrrogacaoTemp,
  CDSChqDevolvidoTemp,
  CDSChqTerceiroTemp,
  CDSChqProprioTemp,
  CDSComplementoTemp,
  CDSReceberTemp,
  CDSAdiantamentoTemp,
  CDSGrupoResultadoTemp,
  CDSPagarTemp: TClientDataSet;

  // Label de Totalizações
  LabelPMC,
  LabelPMD,
  LabelPMG,
  
  LabelTotCredito,
  LabelGRManuais,
  LabelProrrogacoes,
  LabelChequeDev,
  
  LabelTotDebito,
  LabelNominalABaixar,
  LabelAindaAberto,
  lblTotDebitoAtualizado,
  
  LabelJurosCalculados,
  LabelDescontosCalculados,
  LabelPreDesconto,
  LabelDiferenca: TLabel;  
  
  { TSelecao Pessoa}
  SPessoa: TSelecao;
  CDSSelecao: TClientDataSet; 
  rgPessoa: TRadioGroup;
         
procedure Main;
begin
  try
    CriarObjetos;
    IniciarCDSCadastroBordero; 
    //ObterDadosCDSBorderoPagamento;
  finally  
    //DestruirObjetos;
  end;
end;

procedure CriarObjetos;
begin
  fBorderoPagamento := FormCriadoPeloNome('FCadBorderoPagamento');
    
  if fBorderoPagamento = nil then
    fBorderoPagamento := CriarFormPeloNome('FCadBorderoPagamento');
 
  fBorderoPagamento.Show(); 
  
  CDSCadastroTemp       := TClientDataSet.Create; 
  CDSProrrogacaoTemp    := TClientDataSet.Create;
  CDSChqDevolvidoTemp   := TClientDataSet.Create;
  CDSChqTerceiroTemp    := TClientDataSet.Create;
  CDSChqProprioTemp     := TClientDataSet.Create;
  CDSComplementoTemp    := TClientDataSet.Create;
  CDSReceberTemp        := TClientDataSet.Create;
  CDSAdiantamentoTemp   := TClientDataSet.Create;
  CDSGrupoResultadoTemp := TClientDataSet.Create;
  CDSPagarTemp          := TClientDataSet.Create;  

  MapearComponentesBorderoPagamento;
end;

procedure MapearComponentesBorderoPagamento;
begin    
  PageControl  := fBorderoPagamento.FindComponent('PageControl1');
  PageControl2 := fBorderoPagamento.FindComponent('PageControl2');
                
  cbTipoBordero  := fBorderoPagamento.FindComponent('CBSubTipo');
  cbQualificacaoPagamento := fBorderoPagamento.FindComponent('CBQualificacao');
  cbCalculoJuros := fBorderoPagamento.FindComponent('JvDBComboBox2');
  
  ceConta      := fBorderoPagamento.FindComponent('JvDBCalcEdit1');        
  ceDataAcerto := fBorderoPagamento.FindComponent('JvDBDateEdit2'); 
  ceTaxaJuros  := fBorderoPagamento.FindComponent('JvDBCalcEditTaxa');
  ceCodBordero := fBorderoPagamento.FindComponent('EditCodigo');
  
  btnIncluir  := fBorderoPagamento.FindComponent('BotaoIncluir');
  btnExcluir  := fBorderoPagamento.FindComponent('BotaoExcluir');
  btnGravar   := fBorderoPagamento.FindComponent('BotaoGravar');
  btnCancelar := fBorderoPagamento.FindComponent('BotaoCancelar');
  
  ckProrrogacao         := fBorderoPagamento.FindComponent('CheckBox2');
  ckChequesDev          := fBorderoPagamento.FindComponent('CheckBox3'); 
  ckDuplicReceber       := fBorderoPagamento.FindComponent('CheckBox1'); 
  ckExibirBaixados      := fBorderoPagamento.FindComponent('cbExibirBaixados');
  ckConPromessaPag      := fBorderoPagamento.FindComponent('cbConsiderarPromessaPgto');
  ckExibirDevolvidos    := fBorderoPagamento.FindComponent('cbExibeDevolvidos');
  ckExibirChequeRecParc := fBorderoPagamento.FindComponent('cbExibeChequeRecebidoParcialmente');
  ckExibirDupRecParc    := fBorderoPagamento.FindComponent('cbExibeRecebidasParcialmente');
  
  dtEditProrrogacoesIni    := fBorderoPagamento.FindComponent('DataIniProrrogacao');
  dtEditProrrogacoesFim    := fBorderoPagamento.FindComponent('DataFimProrrogacao');
  dtEditchequeDevEntreIni  := fBorderoPagamento.FindComponent('DataIniChequeDev');
  dtEditchequeDevEntreFim  := fBorderoPagamento.FindComponent('DataFimChequeDev');
  dtEditContasPgEntreIni   := fBorderoPagamento.FindComponent('DataIniPagar'); 
  dtEditContasPgEntreFim   := fBorderoPagamento.FindComponent('DataFimPagar');
  dtEditChequeTerceiroIni  := fBorderoPagamento.FindComponent('DataIniChequeTer');
  dtEditChequeTerceiroFim  := fBorderoPagamento.FindComponent('DataFimChequeTer');
  dtEditDupReceberEntreIni := fBorderoPagamento.FindComponent('DataIniReceber');
  dtEditDupReceberEntreFim := fBorderoPagamento.FindComponent('DataFimReceber'); 

  // Label de Totalizações 
  LabelPMC                 := fBorderoPagamento.FindComponent('LabelPMC');
  LabelPMD                 := fBorderoPagamento.FindComponent('LabelPMD');
  LabelPMG                 := fBorderoPagamento.FindComponent('LabelPMG');
  LabelTotCredito          := fBorderoPagamento.FindComponent('LabelTotCredito');
  LabelGRManuais           := fBorderoPagamento.FindComponent('LabelGRManuais');
  LabelProrrogacoes        := fBorderoPagamento.FindComponent('LabelProrrogacoes');
  LabelChequeDev           := fBorderoPagamento.FindComponent('LabelChequeDev');
  LabelTotDebito           := fBorderoPagamento.FindComponent('LabelTotDebito');
  LabelNominalABaixar      := fBorderoPagamento.FindComponent('LabelNominalABaixar');
  LabelAindaAberto         := fBorderoPagamento.FindComponent('LabelAindaAberto');
  lblTotDebitoAtualizado   := fBorderoPagamento.FindComponent('lblTotDebitoAtualizado');
  LabelJurosCalculados     := fBorderoPagamento.FindComponent('LabelJurosCalculados');
  LabelDescontosCalculados := fBorderoPagamento.FindComponent('LabelDescontosCalculados');
  LabelPreDesconto         := fBorderoPagamento.FindComponent('LabelPreDesconto');
  LabelDiferenca           := fBorderoPagamento.FindComponent('LabelDiferenca');

  SPessoa    := fBorderoPagamento.FindComponent('SPessoa');
  CDSSelecao := SPessoa.FindComponent('CDSSelecao');
  rgPessoa   := SPessoa.FindComponent('RadioGroup1');
end;
 
// Procedure para Validar as informações de pagamento, complemento, cheque
procedure IniciarCDSCadastroBordero;
var
  DMBordero: TDataModule;
begin
  DMBordero := DMCriadoPeloNome('DMCadBorderoPagamento');

  CDSPagarPagamento          := DMBordero.FindComponent('CDSPagar');
  CDSProrrogacaoPagamento    := DMBordero.FindComponent('CDSProrrogacoes');
  CDSChqDevolvido      := DMBordero.FindComponent('CDSChequeDev');
  CDSChqTerceiro       := DMBordero.FindComponent('CDSChequeTer');
  CDSChqProprio        := DMBordero.FindComponent('CDSChequeEmit');
  CDSComplementoPagamento    := DMBordero.FindComponent('CDSComplementos');
  CDSReceberPagamento         := DMBordero.FindComponent('CDSReceber');
  CDSAdiantamento      := DMBordero.FindComponent('CDSAdiantamentos');
  CDSGrupoResultadoPagamento := DMBordero.FindComponent('CDSGrupoResultado');
  CDSCadastroPagamento := DMBordero.FindComponent('CDSCadastro');
end;

procedure DestruirObjetos;
begin
 //fBorderoPagamento.Free;
  CDSCadastroTemp.Free;
  CDSPagarTemp.Free;
  CDSProrrogacaoTemp.Free;
  CDSChqDevolvidoTemp.Free;
  CDSChqTerceiroTemp.Free;
  CDSChqProprioTemp.Free;
  CDSComplementoTemp.Free;
  CDSReceberTemp.Free;
  CDSAdiantamentoTemp.Free;
  CDSGrupoResultadoTemp.Free;
end;

end.
