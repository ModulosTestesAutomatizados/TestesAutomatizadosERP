uses TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO,
  TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO;

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
  lInstrucoes := 'Piloto financeiro executado pelo Teste dentro do fluxo IRunner.'                + #13 +
    'Usa o registro corrente, JSON e contexto global preparados por Run/Started.'                 + #13 +
    'Sequencia: duplicata receber, duplicata pagar, bordero receber e bordero pagar.'             + #13 +
    'A casca carrega e libera os CDS compartilhados; o piloto encerra seus recursos financeiros.';
  {P39_TDD_LOGS.}MostrarInstrucoesUnit('TDD_FINANCEIRO', lInstrucoes);
end;

function ObterResultadoAtual: String;
var lJSON: TStringList;
begin
  lJSON := TStringList.Create;
  try
    lJSON.Add('{');
    lJSON.Add('  "campos": [');
    lJSON.Add('    { "campo": "duplicata_receber_criada", "operacao": 0, "valor": "true" },');
    lJSON.Add('    { "campo": "duplicata_pagar_criada", "operacao": 0, "valor": "true" },');
    lJSON.Add('    { "campo": "bordero_recebimento_gravado", "operacao": 0, "valor": "true" },');
    lJSON.Add('    { "campo": "bordero_pagamento_gravado", "operacao": 0, "valor": "true" }');
    lJSON.Add('  ]');
    lJSON.Add('}');
    Result := lJSON.Text;
  finally
    lJSON.Free;
  end;
end;

function ObterResultadoEsperado: String;
begin
  Result := '';
  if CDSResultadoEsperado.FindKey([FCasoTesteAtualId]) then
    Result := CDSResultadoEsperado.FieldByName('RESULTADO_ESPERADO').AsString;
end;

procedure Setup_InicializarObjetos;
begin
  // O caso e seu JSON ja foram preparados por Started; nao ha CDS local.
  ValidarCasoTeste;
  {P39_TDD_CASOS_DE_TESTE.}CarregarConfiguracoes;
  if CDSConfiguracao.IsEmpty then
    raise Exception.Create('Configuracao financeira nao carregada.');
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

procedure Teste;
begin
  try
    Setup_InicializarObjetos;
    try _IncluirDuplicata(0);
    except on Ex: Exception do raise Exception.Create('[Fluxo] Duplicata receber: ' + Ex.Message); end;
    try _IncluirDuplicata(1);
    except on Ex: Exception do raise Exception.Create('[Fluxo] Duplicata pagar: ' + Ex.Message); end;
    try _IncluirBorderoRecebimento;
    except on Ex: Exception do raise Exception.Create('[Fluxo] Bordero receber: ' + Ex.Message); end;
    try _IncluirBorderoPagamento;
    except on Ex: Exception do raise Exception.Create('[Fluxo] Bordero pagar: ' + Ex.Message); end;
  finally
    // O campo de fase distingue falha de limpeza de falha do teste.
    FNomeMetodoAtual := 'TEARDOWN';
    TearDown_DestruirObjetos;
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

  lFDuplicatas := FormCriadoPeloNome(lNomeForm);
  if lFDuplicatas = nil then lFDuplicatas := CriarFormPeloNome(lNomeForm);
  if lFDuplicatas = nil then raise Exception.Create('Formulario "' + lNomeForm + '" nao encontrado.');

  lFDuplicatas.Show;
  lDMDuplicatas  := DMCriadoPeloNome(lNomeDM);
  lCDSCadastro   := lDMDuplicatas.FindComponent('CDSCadastro');
  lCDSGrupResult := lDMDuplicatas.FindComponent('CDSDuplicata_GrupoResultado');
  lCePessoa      := lFDuplicatas.FindComponent('EditPessoa');

  lPessoa := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PESSOA_DUP', 0);
  if lPessoa = 0 then lPessoa := PessoaPadraoConfig(pTipo);

  lValor := {P39_TDD_FUNCOES_JSON.}ValorCurrencyTag(FCasoTesteAtualJson, 'VALOR_DUP', 0);
  if lValor = 0 then lValor := ValorPadraoConfig(pTipo);

  lGR := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'GRUPORESULTADO_DUPGR', 0);
  if lGR = 0 then lGR := GRPadraoConfig(pTipo);

  lTipoDoc := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'TIPODOC_DUP', 0);
  if lTipoDoc = 0 then lTipoDoc := CDSConfiguracao.FieldByName('TIPO_FINCONFIG').AsInteger;

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

  lFDuplicatas.Close;
end;

procedure _IncluirBorderoRecebimento;
var
  VlrPagar: Double;
  lPessoa: Integer;
  lEtapa: String;
begin
  VlrPagar := 0;
  lEtapa := 'mapear componentes';
  try
    {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}MapearBordero;

    lEtapa := 'incluir bordero';
    {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}IncluirBordero;

    lEtapa := 'obter pessoa';
    lPessoa := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PESSOA_DUP', 0);
    if lPessoa = 0 then lPessoa := CDSConfiguracao.FieldByName('CLIENTE_FINCONFIG').AsInteger;

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
    CDSComplementosRecebimento.FieldByName('CONTA_COMPLBORD').AsCurrency := ContaBorderoPadrao;
    CDSComplementosRecebimento.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
    CDSComplementosRecebimento.Post;

    lEtapa := 'gravar bordero';
    {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}GravarBordero;

    // O fechamento pertence a TearDown_DestruirObjetos.
  except
    on E: Exception do
      raise Exception.Create('Bordero receber - ' + lEtapa + ': ' + E.Message);
  end;
end;

procedure _IncluirBorderoPagamento;
var
  VlrPagar: Double;
  lFornecedor: Integer;
  lPessoaNotaCredito: Integer;
begin
  VlrPagar := 0;
  fBorderoPagamento := FormCriadoPeloNome('FCadBorderoPagamento');
  if not Assigned(fBorderoPagamento) then
    fBorderoPagamento := CriarFormPeloNome('FCadBorderoPagamento');
  if not Assigned(fBorderoPagamento) then
    raise Exception.Create('Formulario de bordero de pagamento nao encontrado.');
  fBorderoPagamento.Show;
  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}MapearComponentesBorderoPagamento;
  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}IniciarCDSCadastroBordero;
  
  try if CDSCadastroPagamento.State <> 1 then CDSCadastroPagamento.Cancel; except end;
  ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoIncluirClick', [nil]);

  if CDSCadastroPagamento.State < 2 then
    ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoIncluirClick', [nil]);

  CDSCadastroPagamento.FieldByName('CONTA_BORDERO').AsInteger := ContaBorderoPadrao;

  lPessoaNotaCredito := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PESSOANOTACREDITO_BORD', 0);
  if lPessoaNotaCredito > 0 then
    CDSCadastroPagamento.FieldByName('PESSOANOTACREDITO_BORDERO').AsInteger := lPessoaNotaCredito;

  lFornecedor := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'PESSOA_DUP', 0);
  if lFornecedor = 0 then lFornecedor := CDSConfiguracao.FieldByName('FORNECEDOR_FINCONFIG').AsInteger;

  try rgPessoa.ItemIndex := 1; except end;
  DefinirPessoaSelecao(lFornecedor);

  try
    dtEditContasPgEntreIni.Date := Hoje - 365;
    dtEditContasPgEntreFim.Date := Hoje + 365;
  except end;

  ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoFiltrarClick', [nil]);

  if CDSPagarPagamento.IsEmpty then
    MostrarLogTextoEmModoDebug('[Etapa 4] Filtro contas a pagar vazio para pessoa ' + IntToStr(lFornecedor))
  else
    MostrarCDSEmModoDebug(CDSPagarPagamento);

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
  CDSComplementoPagamento.FieldByName('CONTA_COMPLBORD').AsCurrency := ContaBorderoPadrao;
  CDSComplementoPagamento.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
  CDSComplementoPagamento.Post;

  ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoGravarClick', [nil]);

  // O fechamento pertence a TearDown_DestruirObjetos.
end;

procedure DefinirPessoaSelecao(pPessoa: Integer);
begin
  if CDSSelecao = nil then
    raise Exception.Create('CDSSelecao nao encontrado no SPessoa do bordero de pagamento.');

  if not CDSSelecao.Active then CDSSelecao.Open;

  CDSSelecao.EmptyDataSet;
  CDSSelecao.Insert;
  CDSSelecao.FieldByName('Codigo').AsInteger := pPessoa;
  CDSSelecao.FieldByName('Descricao').AsString := '';
  CDSSelecao.FieldByName('Ordem').AsInteger := 1;
  CDSSelecao.Post;
end;

function ExtrairTag(pJson, pTag: String): String;
begin
  Result := {P39_TDD_FUNCOES_JSON.}ValorStringTag(pJson, pTag);
end;

function TagJson(pTag: String): String;
begin
  Result := {P39_TDD_FUNCOES_JSON.}ValorStringTag(FCasoTesteAtualJson, pTag);
end;

function ValorInteiroTagLocal(pJson, pTag: String; pDefault: Integer): Integer;
begin
  Result := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(pJson, pTag, pDefault);
end;

function ValorCurrencyTagLocal(pJson, pTag: String; pDefault: Double): Double;
begin
  Result := {P39_TDD_FUNCOES_JSON.}ValorCurrencyTag(pJson, pTag, pDefault);
end;

procedure SetCasoTeste(pCasoTeste: String);
begin FCasoTesteAtualJson := pCasoTeste; ValidarCasoTeste; end;

procedure ValidarCasoTeste;
var lEmpresa, lTipoDoc: Integer;
begin
  FMsgCasoTesteInvalido := '';
  FCasoTesteInvalido := False;
  if Trim(FCasoTesteAtualJson) = '' then
    FMsgCasoTesteInvalido := 'JSON do caso de teste vazio!';

  lEmpresa := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'EMPRESA_DUP', 0);
  lTipoDoc := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'TIPODOC_DUP', 0);
  if lEmpresa <= 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag EMPRESA_DUP ausente ou invalida.'
  else if lEmpresa <> Codigo_Empresa_Atual then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'EMPRESA_DUP difere da empresa atual.';
  if lTipoDoc <= 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag TIPODOC_DUP ausente ou invalida.';

  FCasoTesteInvalido := FMsgCasoTesteInvalido <> '';
  if FCasoTesteInvalido then
    raise Exception.Create('Caso financeiro invalido: ' + FMsgCasoTesteInvalido);
end;

function PessoaPadraoConfig(pTipo: Integer): Integer;
begin
  Result := 0;
  if CDSConfiguracao.IsEmpty then Exit;
  if pTipo = 0 then Result := CDSConfiguracao.FieldByName('CLIENTE_FINCONFIG').AsInteger
  else Result := CDSConfiguracao.FieldByName('FORNECEDOR_FINCONFIG').AsInteger;
end;

function ValorPadraoConfig(pTipo: Integer): Double;
begin
  Result := 0;
  if CDSConfiguracao.IsEmpty then Exit;
  if pTipo = 0 then Result := CDSConfiguracao.FieldByName('VALOR_PADRAO_RECEBER_FINCONFIG').AsCurrency
  else Result := CDSConfiguracao.FieldByName('VALOR_PADRAO_PAGAR_FINCONFIG').AsCurrency;
end;

function GRPadraoConfig(pTipo: Integer): Integer;
begin
  Result := 0;
  if CDSConfiguracao.IsEmpty then Exit;
  if pTipo = 0 then Result := CDSConfiguracao.FieldByName('GR_CONTAS_RECEBER_FINCONFIG').AsInteger
  else Result := CDSConfiguracao.FieldByName('GR_CONTAS_PAGAR_FINCONFIG').AsInteger;
end;

function ContaBorderoPadrao: Integer;
begin
  Result := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(FCasoTesteAtualJson, 'CONTA_BORD', 0);
  if Result = 0 then Result := CDSConfiguracao.FieldByName('CONTA_PRINCIPAL_FINCONFIG').AsInteger;
end;
