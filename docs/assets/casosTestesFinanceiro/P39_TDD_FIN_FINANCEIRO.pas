uses  P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO,
      P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO;

const
  cFormReceber    = 'FCadReceber';
  cFormPagar      = 'FCadPagar';
  cDMCadDuplicata = 'DMCadDuplicata';

var
  FCasoTesteInvalido: Boolean;
  FMsgCasoTesteInvalido: String;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit de Teste financeiro executada na casca IRunner com o contexto global do caso corrente.'             + #13 +
    '====================================================================================================================' + #13 +
    'Entrada e validação do caso:'                                                                                         + #13 +
    'procedure Teste'                                                                                                      + #13 +
    '  - Valida o JSON e executa duplicata receber, duplicata pagar, borderô receber e borderô pagar.'                     + #13 +
    'procedure ValidarCasoTeste'                                                                                           + #13 +
    '  - Validação específica do financeiro; usa o JSON preparado por Started sem carregar casos.'                         + #13 +
    '  - EMPRESA_DUP deve corresponder à empresa atual; TIPODOC_DUP mantém a validação existente.'                         + #13 +
    '  - PESSOA_DUP, VALOR_DUP, GRUPORESULTADO_DUPGR e CONTA_BORD não usam configuração padrão.'                           + #13 +
    '  - QUALIFICACAO_DUP, PESSOANOTACREDITO_BORD e PRAZOVENCIMENTO_DUP continuam opcionais.'                              + #13 +
    '====================================================================================================================' + #13 +
    'Métodos financeiros:'                                                                                                 + #13 +
    'procedure _IncluirDuplicata(pTipo :Integer)'                                                                          + #13 +
    '  - Tipo 0: duplicata receber. Tipo 1: duplicata pagar.'                                                              + #13 +
    'procedure _IncluirBordero(pTipo :Integer)'                                                                            + #13 +
    '  - Tipo 0: recebimento. Tipo 1: pagamento, incluindo a seleção da pessoa.'                                           + #13 +
    '  - Mantém os mapeamentos, filtros, totalização e gravação próprios de cada tipo.'                                    + #13 +
    '====================================================================================================================' + #13 +
    'Encerramento e diagnóstico:'                                                                                          + #13 +
    'procedure TearDown_DestruirObjetos'                                                                                   + #13 +
    '  - Declarada no final; cancela edições e fecha telas sem destruir CDS compartilhados.'                               + #13 +
    'TEARDOWN no campo FNomeMetodoAtual mantém a interrupção do lote se a limpeza falhar.'                                 + #13 +
    'Logs usam RegistrarLog e DelimitadorLog, com captura independente de FModoDebug.'                                     + #13 +
    'Resultados e comparações pertencem à etapa de asserts, que não é implementada nesta unit.'                            + #13 +
    'FExibirInstrucoes controla a exibição destas instruções.'                                                             + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('P39_TDD_FIN_FINANCEIRO', lInstrucoes);
end;

procedure ValidarCasoTeste;
var lEmpresa, lTipoDoc: Integer;
begin
  FMsgCasoTesteInvalido   := '';
  FCasoTesteInvalido      := False;
  if Trim(FCasoTesteAtualJson) = '' then
    FMsgCasoTesteInvalido := 'JSON do caso de teste vazio!';

  lEmpresa := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'EMPRESA_DUP', 0);
  lTipoDoc := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'TIPODOC_DUP', 0);

  if lEmpresa <= 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag EMPRESA_DUP ausente ou inválida.';

  if lTipoDoc <= 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag TIPODOC_DUP ausente ou inválida.';

  if {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PESSOA_DUP', 0) = 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag PESSOA_DUP ausente, inválida ou zerada.';

  if {P39_TDD_FUNCOES_JSON.}ValorCurrencyTag(FCasoTesteAtualJson, 'VALOR_DUP', 0) = 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag VALOR_DUP ausente, inválida ou zerada.';

  if {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'GRUPORESULTADO_DUPGR', 0) = 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag GRUPORESULTADO_DUPGR ausente, inválida ou zerada.';

  if {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'CONTA_BORD', 0) = 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag CONTA_BORD ausente, inválida ou zerada.';

  FCasoTesteInvalido := FMsgCasoTesteInvalido <> '';
  if FCasoTesteInvalido then
    raise Exception.Create('Caso financeiro inválido: ' + #13 + FMsgCasoTesteInvalido);
end;

procedure Teste;
begin
  try
    ValidarCasoTeste;
    {P39_TDD_RUN_LOGS.}RegistrarLog('Inclusão da duplicata a receber.');
    try _IncluirDuplicata(0);
    except on Ex: Exception do raise Exception.Create('[Fluxo] Duplicata receber: ' + Ex.Message); end;
    {P39_TDD_RUN_LOGS.}RegistrarLog('Inclusão da duplicata a pagar.');
    try _IncluirDuplicata(1);
    except on Ex: Exception do raise Exception.Create('[Fluxo] Duplicata pagar: ' + Ex.Message); end;
    {P39_TDD_RUN_LOGS.}RegistrarLog('Inclusão do borderô de recebimento.');
    try _IncluirBordero(0);
    except on Ex: Exception do raise Exception.Create('[Fluxo] Bordero receber: ' + Ex.Message); end;
    {P39_TDD_RUN_LOGS.}RegistrarLog('Inclusão do borderô de pagamento.');
    try _IncluirBordero(1);
    except on Ex: Exception do raise Exception.Create('[Fluxo] Bordero pagar: ' + Ex.Message); end;
  finally
    // O campo de fase distingue falha de limpeza de falha do teste.
    {P39_TDD_RUN_LOGS.}DelimitadorLog('TEARDOWN');
    FNomeMetodoAtual := 'TEARDOWN';
    RegistrarTick(0, FNomeMetodoAtual);
    TearDown_DestruirObjetos;
    RegistrarTick(1, FNomeMetodoAtual);
    FNomeMetodoAtual := 'IRUNNER';
  end;
end;

procedure _IncluirDuplicata(pTipo: Integer);
var
  lNomeForm, lNomeDM: String;
  lFDuplicatas: TForm;
  lDMDuplicatas: TDataModule;
  lCDSCadastro, lCDSGrupResult: TClientDataSet;
  lCePessoa: TComponent;
  lPessoa, lGR, lTipoDoc, lQualificacao: Integer;
  lValor: Double;
  lPrazoVencimento: Integer;
begin
  if pTipo = 0 then lNomeForm := cFormReceber else lNomeForm := cFormPagar;
  lNomeDM := cDMCadDuplicata;

  if pTipo = 0 then
    {P39_TDD_RUN_APPLICATION.}AbrirTela('DuplicatasaReceber1Click')
  else
    {P39_TDD_RUN_APPLICATION.}AbrirTela('DuplicatasaPagar1Click');
  lFDuplicatas := FormCriadoPeloNome(lNomeForm);
  if lFDuplicatas = nil then raise Exception.Create('Formulario "' + lNomeForm + '" nao encontrado.');

  lDMDuplicatas  := DMCriadoPeloNome(lNomeDM);
  lCDSCadastro   := lDMDuplicatas.FindComponent('CDSCadastro');
  lCDSGrupResult := lDMDuplicatas.FindComponent('CDSDuplicata_GrupoResultado');
  lCePessoa      := lFDuplicatas.FindComponent('EditPessoa');

  lPessoa := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PESSOA_DUP', 0);

  lValor := {P39_TDD_FUNCOES_JSON.}ValorCurrencyTag(FCasoTesteAtualJson, 'VALOR_DUP', 0);

  lGR := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'GRUPORESULTADO_DUPGR', 0);

  lTipoDoc := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'TIPODOC_DUP', 0);

  lQualificacao := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'QUALIFICACAO_DUP', 0);

  lCePessoa.Value := lPessoa;

  try
    if lCDSCadastro.State <> 1 then lCDSCadastro.Cancel;
  except end;

  ExecutarMetodoDeObjeto(lFDuplicatas, 'BotaoAbrirClick', [nil]);
  ExecutarMetodoDeObjeto(lFDuplicatas, 'BotaoIncluirClick', [nil]);

  if lCDSCadastro.State < 2 then
    ExecutarMetodoDeObjeto(lFDuplicatas, 'BotaoIncluirClick', [nil]);

  lCDSCadastro.FieldByName('PESSOA_DUP').AsInteger := lPessoa;
  lCDSCadastro.FieldByName('DOCUMENTO_DUP').AsString := 'DUP_' + FormatDateTime('hh_mm_ss_zz', DataHoraServidor);
  lCDSCadastro.FieldByName('EMISSAO_DUP').AsDateTime := DataHoraServidor;
  lPrazoVencimento := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PRAZOVENCIMENTO_DUP', 0);
  lCDSCadastro.FieldByName('VENCIMENTO_DUP').AsDateTime := Hoje + lPrazoVencimento;
  lCDSCadastro.FieldByName('VALORNOMINALORIGINAL_DUP').AsCurrency := lValor;
  lCDSCadastro.FieldByName('VALOR_DUP').AsCurrency := lValor;
  lCDSCadastro.FieldByName('TIPODOC_DUP').AsInteger := lTipoDoc;

  if lQualificacao > 0 then
    lCDSCadastro.FieldByName('QUALIFICACAO_DUP').AsInteger := lQualificacao;

  lCDSGrupResult.Insert;
  lCDSGrupResult.FieldByName('GRUPORESULTADO_DUPGR').AsInteger := lGR;
  lCDSGrupResult.FieldByName('VALOR_DUPGR').AsCurrency := lValor;
  lCDSGrupResult.Post;

  ExecutarMetodoDeObjeto(lFDuplicatas, 'BotaoGravarClick', [nil]);

  {P39_TDD_RUN_ASSERTS.}RegistrarDataSet('CDSCadastro|' + lNomeDM);
  lFDuplicatas.Close;
end;

procedure _IncluirBordero(pTipo: Integer);
var
  VlrPagar: Double;
  lPessoa, lFornecedor, lPessoaNotaCredito: Integer;
  lEtapa: String;
begin
  VlrPagar := 0;
  if pTipo = 0 then
  begin
    lEtapa := 'mapear componentes';
    try
      {P39_TDD_RUN_APPLICATION.}AbrirTela('BorderdeAcerto1Click');
      {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}MapearBordero;

      lEtapa := 'incluir bordero';
      {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}IncluirBordero;

      lEtapa := 'obter pessoa';
      lPessoa := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PESSOA_DUP', 0);

      lEtapa := 'preparar cadastro';
      try if CDSCadastroRecebimento.State <> 1 then CDSCadastroRecebimento.Cancel; except end;
      if CDSCadastroRecebimento.State < 2 then
        {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}IncluirBordero;

      lEtapa := 'definir cliente';
      edtCliente.SetFocus;
      CDSCadastroRecebimento.FieldByName('PESSOA_BORDERO').AsInteger := lPessoa;
      edtNovoBanco.SetFocus;

      lEtapa := 'filtrar titulos';
      {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}Filtrar;
      PageControl1.ActivePage := TSReceber;

      lEtapa := 'marcar contas a receber';
      if not CDSReceberRecebimento.IsEmpty then
      begin
        CDSReceberRecebimento.First;
        while not CDSReceberRecebimento.Eof do
        begin
          CDSReceberRecebimento.Edit;
          VlrPagar := VlrPagar + CDSReceberRecebimento.FieldByName('VLREMABERTO').AsCurrency;
          CDSReceberRecebimento.FieldByName('MARQUE').AsInteger := 1;
          CDSReceberRecebimento.Post;
          CDSReceberRecebimento.Next;
        end;
      end;

      lEtapa := 'marcar prorrogacoes';
      if not CDSProrrogacoesRecebimento.IsEmpty then
      begin
        CDSProrrogacoesRecebimento.First;
        while not CDSProrrogacoesRecebimento.Eof do
        begin
          CDSProrrogacoesRecebimento.Edit;
          CDSProrrogacoesRecebimento.FieldByName('MARQUE').AsInteger := 1;
          VlrPagar := VlrPagar + CDSProrrogacoesRecebimento.FieldByName('VALORCOBRADO_PRORROGACAO').AsCurrency;
          CDSProrrogacoesRecebimento.Post;
          CDSProrrogacoesRecebimento.Next;
        end;
      end;

      lEtapa := 'validar valor';
      if VlrPagar = 0 then
        raise Exception.Create('Nao ha duplicatas a receber em aberto para a pessoa ' + IntToStr(lPessoa) + '.');

      lEtapa := 'incluir complemento';
      PageControl1.ActivePage := TSComplementos;
      CDSComplementosRecebimento.Insert;
      CDSComplementosRecebimento.FieldByName('CONTA_COMPLBORD').AsCurrency := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'CONTA_BORD', 0);
      CDSComplementosRecebimento.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
      CDSComplementosRecebimento.Post;

      lEtapa := 'gravar bordero';
      {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}GravarBordero;
      {P39_TDD_RUN_ASSERTS.}RegistrarDataSet('CDSCadastro|DMCadBorderoAcerto');

      // O fechamento pertence a TearDown_DestruirObjetos.
    except
      on E: Exception do
        raise Exception.Create('Bordero receber - ' + lEtapa + ': ' + E.Message);
    end;
  end
  else
  begin
    {P39_TDD_RUN_APPLICATION.}AbrirTela('BorderdePagamento1Click');
    fBorderoPagamento := FormCriadoPeloNome('FCadBorderoPagamento');

    if not Assigned(fBorderoPagamento) then
      raise Exception.Create('Formulario de bordero de pagamento nao encontrado.');
    {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}MapearComponentesBorderoPagamento;
    {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}IniciarCDSCadastroBordero;

    try if CDSCadastroPagamento.State <> 1 then CDSCadastroPagamento.Cancel; except end;
    ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoIncluirClick', [nil]);

    if CDSCadastroPagamento.State < 2 then
      ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoIncluirClick', [nil]);

    CDSCadastroPagamento.FieldByName('CONTA_BORDERO').AsInteger := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'CONTA_BORD', 0);

    lPessoaNotaCredito := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PESSOANOTACREDITO_BORD', 0);
    if lPessoaNotaCredito > 0 then
      CDSCadastroPagamento.FieldByName('PESSOANOTACREDITO_BORDERO').AsInteger := lPessoaNotaCredito;

    lFornecedor := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PESSOA_DUP', 0);

    try rgPessoa.ItemIndex := 1; except end;
    if CDSSelecao = nil then
      raise Exception.Create('CDSSelecao nao encontrado no SPessoa do bordero de pagamento.');

    if not CDSSelecao.Active then CDSSelecao.Open;

    CDSSelecao.First;
    while not CDSSelecao.IsEmpty do
      CDSSelecao.Delete;
    CDSSelecao.Insert;
    CDSSelecao.FieldByName('Codigo').AsInteger := lFornecedor;
    CDSSelecao.FieldByName('Descricao').AsString := '';
    CDSSelecao.FieldByName('Ordem').AsInteger := 1;
    CDSSelecao.Post;

    try
      dtEditContasPgEntreIni.Date := Hoje - 365;
      dtEditContasPgEntreFim.Date := Hoje + 365;
    except end;

    ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoFiltrarClick', [nil]);

    if CDSPagarPagamento.IsEmpty then
      RegistrarLog('[Etapa 4] Filtro contas a pagar vazio para pessoa ' + IntToStr(lFornecedor))
    else
      {P39_TDD_RUN_LOGS.}RegistrarLog('Títulos a pagar encontrados: ' + IntToStr(CDSPagarPagamento.RecordCount));

    if not CDSPagarPagamento.IsEmpty then
    begin
      CDSPagarPagamento.First;
      while not CDSPagarPagamento.Eof do
      begin
        CDSPagarPagamento.Edit;
        VlrPagar := VlrPagar + CDSPagarPagamento.FieldByName('VLREMABERTO').AsCurrency;
        CDSPagarPagamento.FieldByName('MARQUE').AsInteger := 1;
        CDSPagarPagamento.Post;
        CDSPagarPagamento.Next;
      end;
    end;

    if VlrPagar = 0 then
      raise Exception.Create('Nao ha duplicatas a pagar em aberto para a pessoa ' + IntToStr(lFornecedor) + '.');

    CDSComplementoPagamento.Insert;
    CDSComplementoPagamento.FieldByName('CONTA_COMPLBORD').AsCurrency := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'CONTA_BORD', 0);
    CDSComplementoPagamento.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
    CDSComplementoPagamento.Post;

    ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoGravarClick', [nil]);
    {P39_TDD_RUN_ASSERTS.}RegistrarDataSet('CDSCadastro|DMCadBorderoPagamento');
    // O fechamento pertence a TearDown_DestruirObjetos.
  end;
end;

procedure TearDown_DestruirObjetos;
var
  lIndice: Integer;
  lNomeForm, lNomeDM: String;
  lForm: TForm;
  lDM: TDataModule;
  lCDS: TClientDataSet;
begin
  // Encerra apenas os recursos financeiros; os CDS compartilhados pertencem ao lote.
  for lIndice := 0 to 3 do
  begin
    case lIndice of
      0: begin lNomeForm := cFormReceber; lNomeDM := cDMCadDuplicata; end;
      1: begin lNomeForm := cFormPagar; lNomeDM := cDMCadDuplicata; end;
      2: begin lNomeForm := 'FCadBorderoAcerto'; lNomeDM := 'DMCadBorderoAcerto'; end;
      3: begin lNomeForm := 'FCadBorderoPagamento'; lNomeDM := 'DMCadBorderoPagamento'; end;
    end;
    lForm := FormCriadoPeloNome(lNomeForm);
    if Assigned(lForm) then
    begin
      try
        lDM := DMCriadoPeloNome(lNomeDM);
        if Assigned(lDM) then
        begin
          lCDS := lDM.FindComponent('CDSCadastro');
          if Assigned(lCDS) then
            if lCDS.Active then
              if (lCDS.State = 2) or (lCDS.State = 3) then
                lCDS.Cancel;
        end;
      finally
        lForm.Close;
      end;
    end;
  end;
end;
