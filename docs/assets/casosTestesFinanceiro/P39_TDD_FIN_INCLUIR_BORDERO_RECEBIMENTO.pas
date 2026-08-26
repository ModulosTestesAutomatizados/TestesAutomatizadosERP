uses FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO, P39_TDD_FIN_CONFIG_FINANCEIRO;

// ---------------------- Procedure Incluir Borderô de Recebimento -------------------------- //

procedure IncluirBorderoRecebimento;  // criar uma procedure para gerar o bordero e baixar as duplicatas criadas
const 
  cAbaComplemento = 8;
  cAbaBorderoReceber = 9;
var
  VlrPagar: Currency;

begin
  VlrPagar := 0;

  CDSConfig := TClientDataSet.Create;
  try
    CDSConfig.Close;
    CDSConfig.Data := ExecuteReaderODBC(ConexaoODBC, GetSQLSelectFinanceiroConfig);  

    {FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}MapearBordero;

    IncluirBordero;
   
    edtCliente.SetFocus;
    CDSCadastro.FieldByName('PESSOA_BORDERO').AsInteger := 595;
    edtNovoBanco.SetFocus;     

    Filtrar;
    PageControl1.TabIndex  := 5;
 
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
    
    PageControl1.TabIndex  := cAbaComplemento;
    
    CDSComplementos.Insert;
    CDSComplementos.FieldByName('CONTA_COMPLBORD').AsCurrency := CDSConfig.FieldByName('CONTA_PRINCIPAL_FINCONFIG').AsInteger;
    CDSComplementos.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
    CDSComplementos.Post;    
     
    GravarBordero;                         
  finally
    //fBorderoPagamento.Free;
    CDSConfig.Free;
  end;
end;