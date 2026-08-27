uses P39_TDD_CONSTANTES, P39_TDD_CASOS_DE_TESTE, P39_TDD_ODBC, P39_TDD_ASSERTS, P39_TDD_FUNCOES_JSON;

var
  FCasoTesteAtualId: Integer;
  FCasoTesteAtualJson: String;
  FSetupIniciado: Boolean;
  FSetupTimeMs: Int64;
  FExecTimeMs: Int64;
  FTotalTimeMs: Int64;
  FSetupStopwatch: TStopwatch;
  FExecStopwatch: TStopwatch;
  FTotalStopwatch: TStopwatch;

procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes := 'Assets para estrutura padrao de testes TDD.' + #13 + #13 +
    'Centraliza setup, execucao, validacao e teardown de casos de teste.' + #13 + #13 +
    'Metodos disponibilizados:' + #13 +
    ' - function Setup_CasoTeste(const Modulo, Area: String; const CasoTesteId: Integer): Boolean' + #13 +
    '   + Inicializa estrutura, carrega caso de teste, inicia cronometros.' + #13 +
    ' - function ExecutarCasoTeste(const CasoTesteJson: String): Boolean' + #13 +
    '   + Executa a logica do caso de teste (deve ser implementado no caso especifico).' + #13 +
    ' - function ValidarResultadoEsperado(const ResultadoAtual, ResultadoEsperado: String): Boolean' + #13 +
    '   + Compara resultado atual com esperado (JSON).' + #13 +
    ' - procedure TearDown_CasoTeste' + #13 +
    '   + Finaliza cronometros, persiste metricas, limpa recursos.' + #13 + #13 +
    'Uso: chamar Setup_CasoTeste -> ExecutarCasoTeste -> ValidarResultadoEsperado -> TearDown_CasoTeste';
  MostrarLogTexto(lInstrucoes, 'Instrucoes TDD_ASSETS');
end;

function Setup_CasoTeste(const Modulo, Area: String; const CasoTesteId: Integer): Boolean;
var
  lCasoTesteJson: String;
  lResultadoEsperadoJson: String;
  lCamposDisponiveisJson: String;
begin
  Result := False;
  MostrarLogTextoEmModoDebug('=== SETUP CASO DE TESTE INICIADO ===');
  MostrarLogTextoEmModoDebug('Modulo: ' + Modulo + ', Area: ' + Area + ', CasoTesteId: ' + IntToStr(CasoTesteId));

  FTotalStopwatch := TStopwatch.Create;
  FTotalStopwatch.Start;

  FSetupStopwatch := TStopwatch.Create;
  FSetupStopwatch.Start;

  try
    Setup_Inicializar_CasosTeste;
    MostrarLogTextoEmModoDebug('Estrutura de casos de teste inicializada');

    SetModulo(Modulo);
    SetArea(Area);
    MostrarLogTextoEmModoDebug('Modulo/Area configurados');

    CarregarCasosTeste;
    MostrarLogTextoEmModoDebug('Casos de teste carregados');

    lCasoTesteJson := GetCasoTestePorId(CasoTesteId);
    if lCasoTesteJson = '' then
      raise Exception.Create(MensagemPersonalizada + 'Caso de teste ID ' + IntToStr(CasoTesteId) + ' nao encontrado.');

    lResultadoEsperadoJson := GetResultadoEsperadoPorId(CasoTesteId);
    lCamposDisponiveisJson := GetCamposDisponiveisPorId(CasoTesteId);

    FCasoTesteAtualId := CasoTesteId;
    FCasoTesteAtualJson := lCasoTesteJson;

    MostrarLogTextoEmModoDebug('Caso de teste carregado: ' + IntToStr(CasoTesteId));
    MostrarLogTextoEmModoDebug('JSON do caso: ' + Copy(lCasoTesteJson, 1, 200) + '...');

    CarregarConfiguracoes;
    MostrarLogTextoEmModoDebug('Configuracoes carregadas');

    FSetupStopwatch.Stop;
    FSetupTimeMs := FSetupStopwatch.ElapsedMilliseconds;

    MostrarLogTextoEmModoDebug('Setup concluido em ' + IntToStr(FSetupTimeMs) + ' ms');
    Result := True;

    FExecStopwatch := TStopwatch.Create;
    FExecStopwatch.Start;

  except
    on E: Exception do
    begin
      MostrarLogTextoEmModoDebug('ERRO NO SETUP: ' + E.Message);
      raise;
    end;
  end;
end;

function ExecutarCasoTeste(const CasoTesteJson: String): Boolean;
begin
  Result := False;
  MostrarLogTextoEmModoDebug('=== EXECUCAO CASO DE TESTE ===');

  try
    MostrarLogTextoEmModoDebug('Executando logica do caso de teste...');
    MostrarLogTextoEmModoDebug('JSON recebido: ' + Copy(CasoTesteJson, 1, 200) + '...');

    Result := True;
    MostrarLogTextoEmModoDebug('Execucao concluida com sucesso');

  except
    on E: Exception do
    begin
      MostrarLogTextoEmModoDebug('ERRO NA EXECUCAO: ' + E.Message);
      Result := False;
      raise;
    end;
  end;
end;

function ValidarResultadoEsperado(const ResultadoAtual, ResultadoEsperado: String): Boolean;
var
  lAtualObj, lEsperadoObj: TJSONObject;
  lCampos: TJSONArray;
  lCampoNome: String;
  lValorAtual, lValorEsperado: String;
  lOperacao: Integer;
  lIgual: Boolean;
  i: Integer;
begin
  Result := False;
  MostrarLogTextoEmModoDebug('=== VALIDACAO RESULTADO ESPERADO ===');

  try
    lAtualObj := TJSONObject.ParseJSONValue(ResultadoAtual) as TJSONObject;
    lEsperadoObj := TJSONObject.ParseJSONValue(ResultadoEsperado) as TJSONObject;

    if not Assigned(lAtualObj) or not Assigned(lEsperadoObj) then
      raise Exception.Create('JSON invalido para comparacao.');

    lCampos := lEsperadoObj.Get('campos') as TJSONArray;
    if not Assigned(lCampos) then
    begin
      Result := lAtualObj.ToJSON = lEsperadoObj.ToJSON;
      MostrarLogTextoEmModoDebug('Comparacao simples: ' + BoolToStr(Result, True));
      Exit;
    end;

    Result := True;
    for i := 0 to lCampos.Count - 1 do
    begin
      lCampoNome := lCampos.Items[i].GetValue<String>('campo');
      lOperacao := lCampos.Items[i].GetValue<Integer>('operacao');
      lValorEsperado := lCampos.Items[i].GetValue<String>('valor');

      if not lAtualObj.TryGetValue(lCampoNome, lValorAtual) then
      begin
        MostrarLogTextoEmModoDebug('Campo nao encontrado no resultado atual: ' + lCampoNome);
        Result := False;
        Continue;
      end;

      case lOperacao of
        0: lIgual := (lValorAtual = lValorEsperado);
        1: lIgual := (StrToFloatDef(lValorAtual, 0) > StrToFloatDef(lValorEsperado, 0));
        2: lIgual := (StrToFloatDef(lValorAtual, 0) < StrToFloatDef(lValorEsperado, 0));
      else
        lIgual := False;
      end;

      MostrarLogTextoEmModoDebug('Validacao [' + lCampoNome + ']: Atual=' + lValorAtual + ', Esperado=' + lValorEsperado + ', Op=' + IntToStr(lOperacao) + ', OK=' + BoolToStr(lIgual, True));

      if not lIgual then
        Result := False;
    end;

    MostrarLogTextoEmModoDebug('Validacao final: ' + BoolToStr(Result, True));

  except
    on E: Exception do
    begin
      MostrarLogTextoEmModoDebug('ERRO NA VALIDACAO: ' + E.Message);
      Result := False;
      raise;
    end;
  end;
end;

procedure TearDown_CasoTeste;
var
  lVersaoSistema: String;
begin
  MostrarLogTextoEmModoDebug('=== TEARDOWN CASO DE TESTE ===');

  try
    if Assigned(FExecStopwatch) then
    begin
      FExecStopwatch.Stop;
      FExecTimeMs := FExecStopwatch.ElapsedMilliseconds;
    end;

    if Assigned(FTotalStopwatch) then
    begin
      FTotalStopwatch.Stop;
      FTotalTimeMs := FTotalStopwatch.ElapsedMilliseconds;
    end;

    MostrarLogTextoEmModoDebug('Tempo Setup: ' + IntToStr(FSetupTimeMs) + ' ms');
    MostrarLogTextoEmModoDebug('Tempo Execucao: ' + IntToStr(FExecTimeMs) + ' ms');
    MostrarLogTextoEmModoDebug('Tempo Total: ' + IntToStr(FTotalTimeMs) + ' ms');

    PersistirMetricas(FCasoTesteAtualId, FSetupTimeMs, FExecTimeMs, FTotalTimeMs);

    TearDown_Finalizar_CasosTeste;
    MostrarLogTextoEmModoDebug('Teardown concluido');

  except
    on E: Exception do
    begin
      MostrarLogTextoEmModoDebug('ERRO NO TEARDOWN: ' + E.Message);
      raise;
    end;
  end;
end;

procedure PersistirMetricas(const CasoTesteId: Integer; const SetupMs, ExecMs, TotalMs: Int64);
var
  lSql: String;
  lVersao: TVersao;
begin
  MostrarLogTextoEmModoDebug('Persistindo metricas no banco dedicado...');

  try
    lVersao := GetVersao;
    lVersaoSistema := Format('%d.%d', [lVersao.Codigo, lVersao.Numero]);

    lSql := 'INSERT INTO METRICAS_EXECUCAO_TESTE (' + #13 +
      '  CASO_TESTE_ID, VERSAO_SISTEMA, TEMPO_SETUP_MS, TEMPO_EXECUCAO_MS, TEMPO_TOTAL_MS, DATA_EXECUCAO' + #13 +
      ') VALUES (' + #13 +
      '  :pCasoTesteId, :pVersao, :pSetupMs, :pExecMs, :pTotalMs, CURRENT_TIMESTAMP' + #13 +
      ');';

    TDDCommandODBC(lSql, [
      CasoTesteId,
      lVersaoSistema,
      SetupMs,
      ExecMs,
      TotalMs
    ]);

    MostrarLogTextoEmModoDebug('Metricas persistidas com sucesso');

  except
    on E: Exception do
    begin
      MostrarLogTextoEmModoDebug('AVISO: Falha ao persistir metricas: ' + E.Message);
    end;
  end;
end;