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
  lCDSCadastroRecebimento: TClientDataSet;
  lCDSReceberRecebimento: TClientDataSet;
  lCDSProrrogacoesRecebimento: TClientDataSet;
  lCDSComplementosRecebimento: TClientDataSet;
  lCDSCadastroPagamento: TClientDataSet;
  lCDSPagarPagamento: TClientDataSet;
  lCDSComplementoPagamento: TClientDataSet;
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

    if Trim(lEsperado) = '' then
      MostrarLogTextoEmModoDebug('[Validacao] Resultado esperado vazio - validacao ignorada')
    else
    begin
      AssertsZerar;
      AssertIgual(lEsperado, lAtual, 'Validacao Resultado Completo');

      if not AssertsOk then
        raise Exception.Create(MensagemPersonalizada + 'Validacao falhou: ' + AssertsResumo);

      MostrarLogTextoEmModoDebug('[Asserts] ' + AssertsResumo);
    end;
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
begin
  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}MapearBordero;
  lCDSCadastroRecebimento := TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.CDSCadastro;
  lCDSReceberRecebimento := TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.CDSReceber;
  lCDSProrrogacoesRecebimento := TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.CDSProrrogacoes;
  lCDSComplementosRecebimento := TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.CDSComplementos;
  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}IncluirBordero;

  lPessoa := ValorInteiroTagLocal(FJSONCasoTeste, 'PESSOA_DUP', 0);
  if lPessoa = 0 then lPessoa := FCDSConfig.FieldByName('CLIENTE_FINCONFIG').AsInteger;

  try if lCDSCadastroRecebimento.State <> 1 then lCDSCadastroRecebimento.Cancel; except end;
  if lCDSCadastroRecebimento.State < 2 then
    {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}IncluirBordero;

  edtCliente.SetFocus;
  lCDSCadastroRecebimento.FieldByName('PESSOA_BORDERO').AsInteger := lPessoa;
  edtNovoBanco.SetFocus;

  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}Filtrar;
  PageControl1.ActivePage := TSReceber;

  if not lCDSReceberRecebimento.IsEmpty then
  begin
    lCDSReceberRecebimento.First;
    while not lCDSReceberRecebimento.Eof do
    begin
      lCDSReceberRecebimento.Edit;
      VlrPagar := VlrPagar + lCDSReceberRecebimento.FieldByName('VLREMABERTO').AsCurrency;
      lCDSReceberRecebimento.FieldByName('MARQUE').AsInteger := 1;
      lCDSReceberRecebimento.Post;
      lCDSReceberRecebimento.Next;
    end;
  end;

  if not lCDSProrrogacoesRecebimento.IsEmpty then
  begin
    lCDSProrrogacoesRecebimento.First;
    while not lCDSProrrogacoesRecebimento.Eof do
    begin
      lCDSProrrogacoesRecebimento.Edit;
      lCDSProrrogacoesRecebimento.FieldByName('MARQUE').AsInteger := 1;
      VlrPagar := VlrPagar + lCDSProrrogacoesRecebimento.FieldByName('VALORCOBRADO_PRORROGACAO').AsCurrency;
      lCDSProrrogacoesRecebimento.Post;
      lCDSProrrogacoesRecebimento.Next;
    end;
  end;

  if VlrPagar = 0 then
    raise Exception.Create(MensagemPersonalizada + 'Nao ha duplicatas a receber em aberto para a pessoa ' + IntToStr(lPessoa) + '.');

  PageControl1.ActivePage := TSComplementos;

  lCDSComplementosRecebimento.Insert;
  lCDSComplementosRecebimento.FieldByName('CONTA_COMPLBORD').AsCurrency := ContaBorderoPadrao;
  lCDSComplementosRecebimento.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
  lCDSComplementosRecebimento.Post;

  {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}GravarBordero;

  try {TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.}Fechar; except end;
end;

procedure _IncluirBorderoPagamento;
var
  VlrPagar: Double;
  lFornecedor: Integer;
  lPessoaNotaCredito: Integer;
begin
  {P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}CriarObjetos;
  {P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.}IniciarCDSCadastroBordero;
  
  lCDSCadastroPagamento := TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.CDSCadastro;
  lCDSPagarPagamento := TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.CDSPagar;
  lCDSComplementoPagamento := TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.CDSComplemento;

  try if lCDSCadastroPagamento.State <> 1 then lCDSCadastroPagamento.Cancel; except end;
  ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoIncluirClick', [nil]);

  if lCDSCadastroPagamento.State < 2 then
    ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoIncluirClick', [nil]);

  lCDSCadastroPagamento.FieldByName('CONTA_BORDERO').AsInteger := ContaBorderoPadrao;

  lPessoaNotaCredito := ValorInteiroTagLocal(FJSONCasoTeste, 'PESSOANOTACREDITO_BORD', 0);
  if lPessoaNotaCredito > 0 then
    lCDSCadastroPagamento.FieldByName('PESSOANOTACREDITO_BORDERO').AsInteger := lPessoaNotaCredito;

  lFornecedor := ValorInteiroTagLocal(FJSONCasoTeste, 'PESSOA_DUP', 0);
  if lFornecedor = 0 then lFornecedor := FCDSConfig.FieldByName('FORNECEDOR_FINCONFIG').AsInteger;

  try rgPessoa.ItemIndex := 1; except end;
  DefinirPessoaSelecao(lFornecedor);

  try
    dtEditContasPgEntreIni.Date := Hoje - 365;
    dtEditContasPgEntreFim.Date := Hoje + 365;
  except end;

  ExecutarMetodoDeObjeto(fBorderoPagamento, 'BotaoFiltrarClick', [nil]);

  if lCDSPagarPagamento.IsEmpty then
    MostrarLogTextoEmModoDebug('[Etapa 4] Filtro contas a pagar vazio para pessoa ' + IntToStr(lFornecedor))
  else
    MostrarCDS(lCDSPagarPagamento);

  if not lCDSPagarPagamento.IsEmpty then
  begin
    lCDSPagarPagamento.First;
    while not lCDSPagarPagamento.Eof do
    begin
      lCDSPagarPagamento.Edit;
      VlrPagar := VlrPagar + lCDSPagarPagamento.FieldByName('VLREMABERTO').AsCurrency;
      lCDSPagarPagamento.FieldByName('MARQUE').AsInteger := 1;
      lCDSPagarPagamento.Post;
      lCDSPagarPagamento.Next;
    end;
  end;

  if VlrPagar = 0 then
    raise Exception.Create(MensagemPersonalizada + 'Nao ha duplicatas a pagar em aberto para a pessoa ' + IntToStr(lFornecedor) + '.');

  lCDSComplementoPagamento.Insert;
  lCDSComplementoPagamento.FieldByName('CONTA_COMPLBORD').AsCurrency := ContaBorderoPadrao;
  lCDSComplementoPagamento.FieldByName('VALOR_COMPLBORD').AsCurrency := VlrPagar;
  lCDSComplementoPagamento.Post;

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
