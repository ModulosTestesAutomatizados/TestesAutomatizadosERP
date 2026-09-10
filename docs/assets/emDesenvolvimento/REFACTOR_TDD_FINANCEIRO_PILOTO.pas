uses TDD_STARTED, TDD_ASSERTS, TDD_CARREGAR_CASO_TESTE,
  TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO,
  TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO;

const
  cModuloFinanceiro = 'FINANCEIRO';
  cAreaFinanceiro   = 'FINANCEIRO';
  cCasoTesteUnico   = 'TDD_FINANCEIRO';

  cTipoDuplicataReceber = 0;
  cTipoDuplicataPagar   = 1;

  cFormReceber    = 'FCadReceber';
  cFormPagar      = 'FCadPagar';
  cDMCadDuplicata = 'DMCadDuplicata';

  cEtapaDuplicataReceber   = 1;
  cEtapaDuplicataPagar     = 2;
  cEtapaBorderoRecebimento = 3;
  cEtapaBorderoPagamento   = 4;
  cEtapaFluxoCompleto      = 0;

  cEtapaAtual = cEtapaFluxoCompleto;

var
  FCDSCasoTeste: TClientDataSet;
  FCDSConfig: TClientDataSet;
  FJSONCasoTeste: String;
  FCasoTesteInvalido: Boolean;
  FMsgCasoTesteInvalido: String;

procedure Main;
var lInstrucoes :string;
begin
  // TDD_CARREGAR_CASO_TESTE.Main;
  // TDD_STARTED.Main;
  // TDD_ASSERTS.Main;

  lInstrucoes := 'PILOTO TDD_STARTED + TDD_ASSERTS - Caso Unico TDD_FINANCEIRO por ETAPAS:' + #13 +
    'Etapa 1 - Cadastro de Duplicata a Receber' + #13 +
    'Etapa 2 - Cadastro de Duplicata a Pagar' + #13 +
    'Etapa 3 - Borda de Recebimento (baixa duplicatas a receber)' + #13 +
    'Etapa 4 - Borda de Pagamento (baixa duplicatas a pagar)' + #13 + #13 +
    'Etapa em execucao: ' + IntToStr(cEtapaAtual) + #13 +
    ' - altere a constante cEtapaAtual para avancar de etapa.' + #13 + #13 +
    'Fluxo: Setup -> Teste -> TearDown_DestruirObjetos' + #13 + #13 +
    'Caso de Teste: Modulo=' + cModuloFinanceiro + ', Area=' + cAreaFinanceiro + ', Teste=' + cCasoTesteUnico;
  MostrarLogTexto(lInstrucoes, 'Instrucoes REFACTOR_TDD_FINANCEIRO_PILOTO');
end;

procedure ExecutarFluxoCompletoFinanceiro;
var
  lEsperado: String;
  lAtual: String;
begin
  Setup;
  try
    Teste;

    lEsperado := ObterResultadoEsperado;
    lAtual := ObterResultadoAtual;
    {TDD_STARTED.}ValidarResultadoDaExecucao(lEsperado, lAtual);
  finally
    TearDown_DestruirObjetos;
  end;
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

  try
    Result := FCDSCasoTeste.FieldByName('RESULTADO_ESPERADO_CT').AsString;
  except
    Result := '';
  end;
end;

procedure Setup;
begin
  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, '[SETUP TDD_STARTED] Inicializando....');
    Setup_InicializarObjetos;
  finally
    CallBack_FechaTela(ClassOwner);
  end;
end;

procedure Setup_InicializarObjetos;
begin
  FCDSCasoTeste := TClientDataSet.Create;
  FCDSConfig    := TClientDataSet.Create;

  CarregarCasoTeste(cModuloFinanceiro, cAreaFinanceiro, cCasoTesteUnico, FCDSCasoTeste);

  FJSONCasoTeste := FCDSCasoTeste.FieldByName('CASO_TESTE_CT').AsString;

  // MostrarLogTexto(FJSONCasoTeste, 'FJSONCasoTeste');

  FCDSConfig.Close;
  FCDSConfig.Data := TDDReaderODBCP('SELECT * FROM FINANCEIRO_CONFIGURACAO', null);

  if FCDSConfig.IsEmpty then
    raise Exception.Create(MensagemPersonalizada + 'Configuracao financeira nao carregada.');

  ValidarCasoTeste;
end;

procedure TearDown_DestruirObjetos;
begin
  FCDSCasoTeste.Free;
  FCDSConfig.Free;
end;

procedure Teste;
begin
  if FCDSCasoTeste.IsEmpty then
    raise Exception.Create(MensagemPersonalizada + 'Nao ha caso de teste para ser executado.');

  if FCasoTesteInvalido then
  begin
    EnviarMensagemInterna(Nome_Usuario_Atual, 'Teste Automatizado - Erro!', FMsgCasoTesteInvalido);
    Exit;
  end;

  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, 'Executando Etapa ' + IntToStr(cEtapaAtual) + '.....');

    case cEtapaAtual of
      cEtapaFluxoCompleto:
      begin
        try _IncluirDuplicata(cTipoDuplicataReceber);
        except on ex: Exception do raise Exception.Create('[Fluxo] Falha Etapa 1 (Dup Receber): ' + ex.Message); end;
        try _IncluirDuplicata(cTipoDuplicataPagar);
        except on ex: Exception do raise Exception.Create('[Fluxo] Falha Etapa 2 (Dup Pagar): ' + ex.Message); end;
        try _IncluirBorderoRecebimento;
        except on ex: Exception do raise Exception.Create('[Fluxo] Falha Etapa 3 (Bordero Receber): ' + ex.Message); end;
        try _IncluirBorderoPagamento;
        except on ex: Exception do raise Exception.Create('[Fluxo] Falha Etapa 4 (Bordero Pagar): ' + ex.Message); end;
      end;
      cEtapaDuplicataReceber:   _IncluirDuplicata(cTipoDuplicataReceber);
      cEtapaDuplicataPagar:     _IncluirDuplicata(cTipoDuplicataPagar);
      cEtapaBorderoRecebimento: _IncluirBorderoRecebimento;
      cEtapaBorderoPagamento:   _IncluirBorderoPagamento;
    else
      raise Exception.Create(MensagemPersonalizada + 'Etapa ' + IntToStr(cEtapaAtual) + ' nao reconhecida.');
    end;
  finally
    CallBack_FechaTela(ClassOwner);
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
  if pTipo = cTipoDuplicataReceber then lNomeForm := cFormReceber else lNomeForm := cFormPagar;
  lNomeDM := cDMCadDuplicata;

  lFDuplicatas := FormCriadoPeloNome(lNomeForm);
  if lFDuplicatas = nil then lFDuplicatas := CriarFormPeloNome(lNomeForm);
  if lFDuplicatas = nil then raise Exception.Create(MensagemPersonalizada + 'Formulario "' + lNomeForm + '" nao encontrado.');

  lFDuplicatas.Show;
  lDMDuplicatas  := DMCriadoPeloNome(lNomeDM);
  lCDSCadastro   := lDMDuplicatas.FindComponent('CDSCadastro');
  lCDSGrupResult := lDMDuplicatas.FindComponent('CDSDuplicata_GrupoResultado');
  lCePessoa      := lFDuplicatas.FindComponent('EditPessoa');

  lPessoa := ValorInteiroTagLocal(FJSONCasoTeste, 'PESSOA_DUP', 0);
  if lPessoa = 0 then lPessoa := PessoaPadraoConfig(pTipo);

  lValor := ValorCurrencyTagLocal(FJSONCasoTeste, 'VALOR_DUP', 0);
  if lValor = 0 then lValor := ValorPadraoConfig(pTipo);

  lGR := ValorInteiroTagLocal(FJSONCasoTeste, 'GRUPORESULTADO_DUPGR', 0);
  if lGR = 0 then lGR := GRPadraoConfig(pTipo);

  lTipoDoc := ValorInteiroTagLocal(FJSONCasoTeste, 'TIPODOC_DUP', 0);
  if lTipoDoc = 0 then lTipoDoc := FCDSConfig.FieldByName('TIPO_FINCONFIG').AsInteger;

  lQualificacao := ValorInteiroTagLocal(FJSONCasoTeste, 'QUALIFICACAO_DUP', 0);

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
  lPrazoVencimento := ValorInteiroTagLocal(FJSONCasoTeste, 'PRAZOVENCIMENTO_DUP', 0);
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

  try lFDuplicatas.Close; except end;
end;

procedure _IncluirBorderoRecebimento;
var
  VlrPagar: Double;
  lPessoa: Integer;
  lEtapa: String;
begin
  lEtapa := 'mapear componentes';
  try
    {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}MapearBordero;

    lEtapa := 'incluir bordero';
    {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}IncluirBordero;

    lEtapa := 'obter pessoa';
    lPessoa := ValorInteiroTagLocal(FJSONCasoTeste, 'PESSOA_DUP', 0);
    if lPessoa = 0 then lPessoa := FCDSConfig.FieldByName('CLIENTE_FINCONFIG').AsInteger;

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
      raise Exception.Create(MensagemPersonalizada + 'Nao ha duplicatas a receber em aberto para a pessoa ' + IntToStr(lPessoa) + '.');

    lEtapa := 'incluir complemento';
    PageControl1.ActivePage := TSComplementos;
    CDSComplementosRecebimento.Insert;
    CDSComplementosRecebimento.FieldByName('CONTA_COMPLBORD').AsCurrency := ContaBorderoPadrao;
    CDSComplementosRecebimento.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
    CDSComplementosRecebimento.Post;

    lEtapa := 'gravar bordero';
    {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}GravarBordero;

    lEtapa := 'fechar bordero';
    try {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}Fechar; except end;
  except
    on E: Exception do
      raise Exception.Create(MensagemPersonalizada + 'Bordero receber - ' + lEtapa + ': ' + E.Message);
  end;
end;

procedure _IncluirBorderoPagamento;
var
  VlrPagar: Double;
  lFornecedor: Integer;
  lPessoaNotaCredito: Integer;
begin
  {P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}CriarObjetos;
  {P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}IniciarCDSCadastroBordero;
  
  try if CDSCadastroPagamento.State <> 1 then CDSCadastroPagamento.Cancel; except end;
  ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoIncluirClick', [nil]);

  if CDSCadastroPagamento.State < 2 then
    ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoIncluirClick', [nil]);

  CDSCadastroPagamento.FieldByName('CONTA_BORDERO').AsInteger := ContaBorderoPadrao;

  lPessoaNotaCredito := ValorInteiroTagLocal(FJSONCasoTeste, 'PESSOANOTACREDITO_BORD', 0);
  if lPessoaNotaCredito > 0 then
    CDSCadastroPagamento.FieldByName('PESSOANOTACREDITO_BORDERO').AsInteger := lPessoaNotaCredito;

  lFornecedor := ValorInteiroTagLocal(FJSONCasoTeste, 'PESSOA_DUP', 0);
  if lFornecedor = 0 then lFornecedor := FCDSConfig.FieldByName('FORNECEDOR_FINCONFIG').AsInteger;

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
    MostrarCDS(CDSPagarPagamento);

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
    raise Exception.Create(MensagemPersonalizada + 'Nao ha duplicatas a pagar em aberto para a pessoa ' + IntToStr(lFornecedor) + '.');

  CDSComplementoPagamento.Insert;
  CDSComplementoPagamento.FieldByName('CONTA_COMPLBORD').AsCurrency := ContaBorderoPadrao;
  CDSComplementoPagamento.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
  CDSComplementoPagamento.Post;

  ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoGravarClick', [nil]);

  try fBorderoPagamento.Close; except end;
end;

procedure DefinirPessoaSelecao(pPessoa: Integer);
begin
  if CDSSelecao = nil then
    raise Exception.Create(MensagemPersonalizada + 'CDSSelecao nao encontrado no SPessoa do bordero de pagamento.');

  if not CDSSelecao.Active then CDSSelecao.Open;

  CDSSelecao.Insert;
  CDSSelecao.FieldByName('Codigo').AsInteger := pPessoa;
  CDSSelecao.FieldByName('Descricao').AsString := '';
  CDSSelecao.FieldByName('Ordem').AsInteger := 1;
  CDSSelecao.Post;
end;

function ExtrairTag(pJson, pTag: String): String;
var lMarcador, lPos, lFim: Integer; lChar: String;
begin
  Result := '';
  try Result := GetValueJson(pJson, pTag); except end;
  if Trim(Result) = '' then
  begin
    lMarcador := '"' + pTag + '":';
    lPos := Pos(lMarcador, pJson);
    if lPos > 0 then
    begin
      lPos := lPos + Length(lMarcador);
      lFim := lPos;
      while lFim <= Length(pJson) do
      begin
        lChar := Copy(pJson, lFim, 1);
        if (lChar = ',') or (lChar = '}') then Break;
        lFim := lFim + 1;
      end;
      Result := Trim(Copy(pJson, lPos, lFim - lPos));
    end;
  end;
end;

function TagJson(pTag: String): String;
begin Result := ExtrairTag(FJSONCasoTeste, pTag); end;

function ValorInteiroTagLocal(pJson, pTag: String; pDefault: Integer): Integer;
var lValor: String; lNum: Integer;
begin
  Result := pDefault;
  lValor := Trim(ExtrairTag(pJson, pTag));
  try lNum := StrToInt(lValor); Result := lNum; except end;
end;

function ValorCurrencyTagLocal(pJson, pTag: String; pDefault: Double): Double;
begin Result := StrToCurrDef(Troca(Trim(ExtrairTag(pJson, pTag)), '.', ','), pDefault); end;

procedure SetCasoTeste(pCasoTeste: String);
begin FJSONCasoTeste := pCasoTeste; ValidarCasoTeste; end;

procedure ValidarCasoTeste;
var lPosEmpresa, lPosTipoDoc: Integer;
begin
  FMsgCasoTesteInvalido := '';
  if Trim(FJSONCasoTeste) = '' then FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'JSON do caso de teste vazio!';
  lPosEmpresa := Pos('"EMPRESA_DUP"', FJSONCasoTeste);
  lPosTipoDoc := Pos('"TIPODOC_DUP"', FJSONCasoTeste);
  if ValorInteiroTagLocal(FJSONCasoTeste, 'EMPRESA_DUP', 0) = 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag EMPRESA_DUP ausente ou zerada.';
  if ValorInteiroTagLocal(FJSONCasoTeste, 'TIPODOC_DUP', 0) = 0 then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'Tag TIPODOC_DUP ausente ou zerada.';
  FCasoTesteInvalido := (FMsgCasoTesteInvalido <> '');
  if FCasoTesteInvalido then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + #13 + '[DEBUG] Len=' + IntToStr(Length(FJSONCasoTeste)) + ' | Inicio=[' + Copy(FJSONCasoTeste, 1, 120) + ']';
end;

function PessoaPadraoConfig(pTipo: Integer): Integer;
begin
  Result := 0;
  if FCDSConfig.IsEmpty then Exit;
  if pTipo = cTipoDuplicataReceber then Result := FCDSConfig.FieldByName('CLIENTE_FINCONFIG').AsInteger
  else Result := FCDSConfig.FieldByName('FORNECEDOR_FINCONFIG').AsInteger;
end;

function ValorPadraoConfig(pTipo: Integer): Double;
begin
  Result := 0;
  if FCDSConfig.IsEmpty then Exit;
  if pTipo = cTipoDuplicataReceber then Result := FCDSConfig.FieldByName('VALOR_PADRAO_RECEBER_FINCONFIG').AsCurrency
  else Result := FCDSConfig.FieldByName('VALOR_PADRAO_PAGAR_FINCONFIG').AsCurrency;
end;

function GRPadraoConfig(pTipo: Integer): Integer;
begin
  Result := 0;
  if FCDSConfig.IsEmpty then Exit;
  if pTipo = cTipoDuplicataReceber then Result := FCDSConfig.FieldByName('GR_CONTAS_RECEBER_FINCONFIG').AsInteger
  else Result := FCDSConfig.FieldByName('GR_CONTAS_PAGAR_FINCONFIG').AsInteger;
end;

function ContaBorderoPadrao: Integer;
begin
  Result := ValorInteiroTagLocal(FJSONCasoTeste, 'CONTA_BORD', 0);
  if Result = 0 then Result := FCDSConfig.FieldByName('CONTA_PRINCIPAL_FINCONFIG').AsInteger;
end;
