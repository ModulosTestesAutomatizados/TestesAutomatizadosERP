uses P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO, P39_TDD_FIN_CONFIG_FINANCEIRO;

// ---------------------- Procedure Incluir Borderô de Pagamento -------------------------- //

procedure IncluirBorderoPagamento;  // criar uma procedure para gerar o bordero e baixar as duplicatas criadas
var
  VlrPagar: Currency;
begin
  VlrPagar := 0;

  CDSConfig := TClientDataSet.Create;
  try
    CDSConfig.Close;
    CDSConfig.Data := ExecuteReaderODBC(ConexaoODBC, GetSQLSelectFinanceiroConfig);  

    {P39_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}CriarObjetos;
    {P39_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}IniciarCDSCadastroBordero;

    ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoIncluirClick', [nil]);
    
    ceConta.Value := CDSConfig.FieldByName('CONTA_PRINCIPAL_FINCONFIG').AsInteger;
    
    PageControl.TabIndex  := 1;
    PageControl2.TabIndex := 1;

    dtEditContasPgEntreIni.Text := '01/01/2000';
    dtEditContasPgEntreFim.Text := '31/12/2099'; 

    rgPessoa.ItemIndex := 1;
    
    CDSSelecao.Edit;
    CDSSelecao.FieldByName('Codigo').AsInteger := CDSConfig.FieldByName('FORNECEDOR_FINCONFIG').AsInteger;
    CDSSelecao.Post;

    ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoFiltrarClick', [nil]);
    
    if CDSPagar.IsEmpty then
    begin
      ShowMessage('Não há duplicatas para o fornecedor selecionado');
      Abort;     
    end;

    CDSPagar.First;
    while not CDSPagar.Eof do
    begin
      CDSPagar.Edit;
      VlrPagar := VlrPagar + CDSPagar.FieldByName('VLREMABERTO').AsCurrency;
      CDSPagar.FieldByName('MARQUE').AsInteger := 1;
      CDSPagar.Post;
      CDSPagar.Next;
    end;

    PageControl.TabIndex  := 9;
    
    CDSComplemento.Insert;
    CDSComplemento.FieldByName('CONTA_COMPLBORD').AsCurrency := CDSConfig.FieldByName('CONTA_PRINCIPAL_FINCONFIG').AsInteger;
    CDSComplemento.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
    CDSComplemento.Post;

    ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoGravarClick', [nil]);

  finally
    //fBorderoPagamento.Free;
    CDSConfig.Free;
  end;
end;