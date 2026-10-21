uses TDD_FAT_MAPEAMENTO_COMPONENTES_CARGA, P39_TDD_FUNCOES_JSON;

var
  FPedidoVendaCarga: Integer;
  FDescricaoCarga: String;

procedure Main;
var lInstrucoes :String;
begin
  lInstrucoes := 'Unit responsavel por incluir e verificar uma carga para o caso corrente do IRunner.'                      + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'FPedidoVendaCarga: Integer'                                                                                            + #13 +
    '  - Codigo do pedido de venda informado pelo JSON corrente.'                                                           + #13 +
    'FDescricaoCarga: String'                                                                                               + #13 +
    '  - Descricao da carga informada pelo JSON corrente.'                                                                  + #13 +
    'FEtapaAtual: Integer (P39_TDD_RUN_RUNNER)'                                                                                 + #13 +
    '  - Etapa incrementada por RegistrarTick e registrada no historico de falhas.'                                         + #13 +
    '===================================================================================================================='  + #13 +
    'Metodos disponibilizados pela Unit:'                                                                                   + #13 +
    'procedure ValidarCasoTeste'                                                                                            + #13 +
    '  - Valida PEDIDO_VENDA e DESCRICAO_CARGA, a empresa e a ausencia de vinculo anterior.'                                + #13 +
    'procedure Teste'                                                                                                       + #13 +
    '  - Registra ticks ao validar, abrir, incluir, vincular, gravar e confirmar a carga.'                                  + #13 +
    'procedure TearDown_DestruirObjetos'                                                                                    + #13 +
    '  - Localiza e fecha o cadastro de Carga e libera o mapeamento local.'                                                 + #13 +
    '===================================================================================================================='  + #13 +
    'O IRunner controla o cursor, os datasets do lote, os asserts e o historico.'                                           + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_FAT_CARGA', lInstrucoes);
end;

procedure ValidarCasoTeste;
var
  lPedido, lJSONCompacto :String;
  lObjeto                :TJSONObject;
begin
  if Trim(FCasoTesteAtualJson) = '' then
    raise Exception.Create('Carga: JSON do caso vazio.');

  lObjeto := TJSONObject.ParseJSONValue(FCasoTesteAtualJson);
  if not Assigned(lObjeto) then
    raise Exception.Create('Carga: JSON do caso invalido.');
  try
    lJSONCompacto := ExecutarMetodoDeObjeto(lObjeto, 'ToJSON');
  finally
    lObjeto.Free;
  end;

  FPedidoVendaCarga := {P39_TDD_FUNCOES_JSON.}ValorInteiroTag(lJSONCompacto, 'PEDIDO_VENDA', 0);
  FDescricaoCarga := Trim({P39_TDD_FUNCOES_JSON.}ValorStringTag(lJSONCompacto, 'DESCRICAO_CARGA'));

  if FPedidoVendaCarga <= 0 then
    raise Exception.Create('Carga: informe PEDIDO_VENDA apto no JSON.');

  if FDescricaoCarga = '' then
    raise Exception.Create('Carga: informe DESCRICAO_CARGA no JSON.');

  lPedido := IntToStr(FPedidoVendaCarga);
  if ExecuteScalar('SELECT COUNT(*) FROM DOCUMENTO_FATURA WHERE CODIGO_DOCFAT = ' + lPedido +
    ' AND TIPO_DOCFAT = 1 AND EMPRESA_DOCFAT = ' + IntToStr(Codigo_Empresa_Atual) +
    ' AND COALESCE(CARGA_DOCFAT, 0) = 0') <> 1 then
    raise Exception.Create('Carga: pedido inexistente, de outra empresa ou ja consumido: ' + lPedido);
  if ExecuteScalar('SELECT COUNT(*) FROM CARGA_DOCUMENTOS WHERE DOCUMENTO_CARDOC = ' + lPedido) > 0 then
    raise Exception.Create('Carga: pedido ja vinculado a outra carga: ' + lPedido);
end;

procedure TearDown_DestruirObjetos;
var
  lForm: TForm;
  lDM: TDataModule;
  lCDS: TClientDataSet;
begin
  lForm := FormCriadoPeloNome('FCadCarga');
  if Assigned(lForm) then
  begin
    try
      lDM := DMCriadoPeloNome('DMCadCarga');
      if not Assigned(lDM) then
        lDM := lForm.FindComponent('DMCadCarga');
      if Assigned(lDM) then
      begin
        lCDS := lDM.FindComponent('CDSDocumentos');
        if Assigned(lCDS) then
          if lCDS.Active then
            if (lCDS.State = 2) or (lCDS.State = 3) then
              lCDS.Cancel;
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

procedure Teste;
var
  lCodigoCarga: Integer;
  lFormExistente: TForm;
  lMetodoAntesTeardown: String;
  lOperacaoVinculo: String;
begin
  FNomeMetodoAtual := 'CARGA_VALIDAR_ENTRADA';
  {P39_TDD_RUN_RUNNER.}RegistrarTick(0, FNomeMetodoAtual);
  ValidarCasoTeste;
  lFormExistente := FormCriadoPeloNome('FCadCarga');

  if Assigned(lFormExistente) then
    raise Exception.Create('FCadCarga ja esta aberta; feche o cadastro antes do teste.');

  {P39_TDD_RUN_RUNNER.}RegistrarTick(1, FNomeMetodoAtual);

  try
    try
      FNomeMetodoAtual := 'CARGA_ABRIR_MAPEAR';
      {P39_TDD_RUN_RUNNER.}RegistrarTick(0, FNomeMetodoAtual);
      {P39_TDD_RUN_APPLICATION.}AbrirTela('CadastrodeCarga1Click');
      {TDD_FAT_MAPEAMENTO_COMPONENTES_CARGA.}MapearCarga;
      {P39_TDD_RUN_RUNNER.}RegistrarTick(1, FNomeMetodoAtual);

      FNomeMetodoAtual := 'CARGA_INCLUIR_CABECALHO';
      {P39_TDD_RUN_RUNNER.}RegistrarTick(0, FNomeMetodoAtual);
      ExecutarMetodoDeObjeto(FCadCarga, 'BotaoIncluirClick', [nil]);

      if not CDSCadastroCarga.Active or (CDSCadastroCarga.State <> 3) then
        raise Exception.Create('CDSCadastro nao entrou em inclusao.');

      if not Assigned(CDSCadastroCarga.FindField('DESCRICAO_CARGA')) then
        raise Exception.Create('Campo DESCRICAO_CARGA ausente.');

      CDSCadastroCarga.FieldByName('DESCRICAO_CARGA').AsString       := FDescricaoCarga;
      CDSCadastroCarga.FieldByName('DTEMISSAO_CARGA').AsDateTime     := Hoje;
      CDSCadastroCarga.FieldByName('EMPRESA_CARGA').AsInteger        := Codigo_Empresa_Atual;
      CDSCadastroCarga.FieldByName('SERVICODEENVIO_CARGA').AsInteger := 0;
      {P39_TDD_RUN_RUNNER.}RegistrarTick(1, FNomeMetodoAtual);

      FNomeMetodoAtual := 'CARGA_VINCULAR_PEDIDO';
      {P39_TDD_RUN_RUNNER.}RegistrarTick(0, FNomeMetodoAtual);

      if not CDSDocumentosCarga.Active then
        raise Exception.Create('CDSDocumentos inativo.');

      if not Assigned(CDSDocumentosCarga.FindField('DOCUMENTO_CARDOC')) then
        raise Exception.Create('Campo DOCUMENTO_CARDOC ausente no detalhe da carga.');

      lOperacaoVinculo := 'Insert';
      try
        CDSDocumentosCarga.Insert;
        lOperacaoVinculo := 'atribuir DOCUMENTO_CARDOC';
        CDSDocumentosCarga.FieldByName('DOCUMENTO_CARDOC').AsInteger := FPedidoVendaCarga;
        lOperacaoVinculo := 'Post';
        CDSDocumentosCarga.Post;
      except
        on Ex: Exception do
          raise Exception.Create('CDSDocumentos.' + lOperacaoVinculo + ': ' + Ex.Message);
      end;
      {P39_TDD_RUN_RUNNER.}RegistrarTick(1, FNomeMetodoAtual);

      FNomeMetodoAtual := 'CARGA_GRAVAR';
      {P39_TDD_RUN_RUNNER.}RegistrarTick(0, FNomeMetodoAtual);
      ExecutarMetodoDeObjeto(FCadCarga, 'BotaoGravarClick', [nil]);

      if not CDSCadastroCarga.Active then
        raise Exception.Create('CDSCadastro inativo apos gravacao.');

      if not Assigned(CDSCadastroCarga.FindField('CODIGO_CARGA')) then
        raise Exception.Create('Campo CODIGO_CARGA ausente apos gravacao.');

      lCodigoCarga := CDSCadastroCarga.FieldByName('CODIGO_CARGA').AsInteger;
      if lCodigoCarga <= 0 then
        raise Exception.Create('Gravacao nao retornou CODIGO_CARGA positivo.');
      {P39_TDD_RUN_RUNNER.}RegistrarTick(1, FNomeMetodoAtual);

      FNomeMetodoAtual := 'CARGA_CONFIRMAR_PERSISTENCIA';
      {P39_TDD_RUN_RUNNER.}RegistrarTick(0, FNomeMetodoAtual);

      CDSCadastroCarga.Close;
      CDSCadastroCarga.Params.ParamByName('COD').AsInteger := lCodigoCarga;
      CDSCadastroCarga.Open;

      if CDSCadastroCarga.IsEmpty or
         (CDSCadastroCarga.FieldByName('CODIGO_CARGA').AsInteger <> lCodigoCarga) then
        raise Exception.Create('Carga nao foi encontrada ao reabrir CODIGO_CARGA ' + IntToStr(lCodigoCarga));

      if ExecuteScalar('SELECT COUNT(*) FROM CARGA_DOCUMENTOS WHERE CARGA_CARDOC = ' +
        IntToStr(lCodigoCarga) + ' AND DOCUMENTO_CARDOC = ' + IntToStr(FPedidoVendaCarga)) <> 1 then
        raise Exception.Create('Pedido de venda nao encontrado na carga persistida.');

      {P39_TDD_RUN_ASSERTS.}RegistrarDataSet('CDSCadastro|DMCadCarga');
      {P39_TDD_RUN_LOGS.}RegistrarLog('Carga gravada: ' + IntToStr(lCodigoCarga) +
        '; pedido de venda: ' + IntToStr(FPedidoVendaCarga));
      {P39_TDD_RUN_RUNNER.}RegistrarTick(1, FNomeMetodoAtual);
    except
      on Ex: Exception do
      begin
        FHistoricoExecucao.EtapaFalha := FEtapaAtual;
        raise;
      end;
    end;
  finally
    lMetodoAntesTeardown := FNomeMetodoAtual;
    {P39_TDD_RUN_LOGS.}DelimitadorLog('TEARDOWN');
    FNomeMetodoAtual := 'TEARDOWN';
    {P39_TDD_RUN_RUNNER.}RegistrarTick(0, FNomeMetodoAtual);
    TearDown_DestruirObjetos;
    {P39_TDD_RUN_RUNNER.}RegistrarTick(1, FNomeMetodoAtual);
    if FHistoricoExecucao.EtapaFalha > 0 then
      FNomeMetodoAtual := lMetodoAntesTeardown
    else
      FNomeMetodoAtual := 'IRUNNER';
  end;
end;
