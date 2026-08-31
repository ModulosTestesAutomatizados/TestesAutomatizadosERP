uses P39_TDD_CONSTANTES, P39_TDD_CASOS_DE_TESTE, P39_TDD_ODBC, P39_TDD_FUNCOES_JSON;

var
  // Debug mode
  FDebugMode: Boolean;

  // Assets / Test flow control
  FCasoTesteAtualId: Integer;
  FCasoTesteAtualJson: String;
  FSetupIniciado: Boolean;
  FSetupTimeMs: Int64;
  FExecTimeMs: Int64;
  FTotalTimeMs: Int64;
  FSetupStopwatch: TStopwatch;
  FExecStopwatch: TStopwatch;
  FTotalStopwatch: TStopwatch;

{ ================================================================
  DEBUG MODE
  ================================================================ }

procedure SetDebugMode(Value: Boolean);
begin
  FDebugMode := Value;
end;

function IsDebugMode: Boolean;
begin
  Result := FDebugMode;
end;

procedure MostrarLogTextoEmModoDebug(const Msg: String);
begin
  if FDebugMode then
    MostrarLogTexto(Msg, '[DEBUG]');
end;

{ ================================================================
  ASSERTS
  ================================================================ }

procedure AssertTrue(const Condicao: Boolean; const Msg: String = '');
begin
  if not Condicao then
    raise Exception.Create('[ASSERT] ' + Msg);
end;

procedure AssertEquals(const Esperado, Atual: Variant; const Msg: String = '');
var
  lMsg: String;
begin
  if Esperado <> Atual then
  begin
    lMsg := '[ASSERT] ';
    if Msg <> '' then
      lMsg := lMsg + Msg + ' - ';
    lMsg := lMsg + 'Esperado: ' + VarToStr(Esperado) + ', Atual: ' + VarToStr(Atual);
    raise Exception.Create(lMsg);
  end;
end;

procedure AssertNotEquals(const NaoEsperado, Atual: Variant; const Msg: String = '');
var
  lMsg: String;
begin
  if NaoEsperado = Atual then
  begin
    lMsg := '[ASSERT] ';
    if Msg <> '' then
      lMsg := lMsg + Msg + ' - ';
    lMsg := lMsg + 'Não esperado: ' + VarToStr(NaoEsperado) + ', mas Atual: ' + VarToStr(Atual);
    raise Exception.Create(lMsg);
  end;
end;

{ ================================================================
  ASSETS - SETUP / EXECUÇÃO / TEARDOWN / MÉTRICAS
  ================================================================ }

function Setup_CasoTeste(const Modulo, Area: String; const CasoTesteId: Integer): Boolean;
var
  lCasoTesteJson: String;
  lResultadoEsperadoJson: String;
  lCamposDisponiveisJson: String;
begin
  Result := False;
  MostrarLogTextoEmModoDebug('=== SETUP CASO DE TESTE INICIADO ===');
  MostrarLogTextoEmModoDebug('Módulo: ' + Modulo + ', Área: ' + Area + ', CasoTesteId: ' + IntToStr(CasoTesteId));

  FTotalStopwatch := TStopwatch.Create;
  FTotalStopwatch.Start;

  FSetupStopwatch := TStopwatch.Create;
  FSetupStopwatch.Start;

  try
    Setup_Inicializar_CasosTeste;
    MostrarLogTextoEmModoDebug('Estrutura de casos de teste inicializada');

    SetModulo(Modulo);
    SetArea(Area);
    MostrarLogTextoEmModoDebug('Módulo/Área configurados');

    CarregarCasosTeste;
    MostrarLogTextoEmModoDebug('Casos de teste carregados');

    lCasoTesteJson := GetCasoTestePorId(CasoTesteId);
    if lCasoTesteJson = '' then
      raise Exception.Create(MensagemPersonalizada + 'Caso de teste ID ' + IntToStr(CasoTesteId) + ' não encontrado.');

    lResultadoEsperadoJson := GetResultadoEsperadoPorId(CasoTesteId);
    lCamposDisponiveisJson := GetCamposDisponiveisPorId(CasoTesteId);

    FCasoTesteAtualId := CasoTesteId;
    FCasoTesteAtualJson := lCasoTesteJson;

    MostrarLogTextoEmModoDebug('Caso de teste carregado: ' + IntToStr(CasoTesteId));
    MostrarLogTextoEmModoDebug('JSON do caso: ' + Copy(lCasoTesteJson, 1, 200) + '...');

    CarregarConfiguracoes;
    MostrarLogTextoEmModoDebug('Configurações carregadas');

    FSetupStopwatch.Stop;
    FSetupTimeMs := FSetupStopwatch.ElapsedMilliseconds;

    MostrarLogTextoEmModoDebug('Setup concluído em ' + IntToStr(FSetupTimeMs) + ' ms');
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
  MostrarLogTextoEmModoDebug('=== EXECUÇÃO CASO DE TESTE ===');

  try
    MostrarLogTextoEmModoDebug('Executando lógica do caso de teste...');
    MostrarLogTextoEmModoDebug('JSON recebido: ' + Copy(CasoTesteJson, 1, 200) + '...');

    Result := True;
    MostrarLogTextoEmModoDebug('Execução concluída com sucesso');

  except
    on E: Exception do
    begin
      MostrarLogTextoEmModoDebug('ERRO NA EXECUÇÃO: ' + E.Message);
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
  MostrarLogTextoEmModoDebug('=== VALIDAÇÃO RESULTADO ESPERADO ===');

  try
    lAtualObj := TJSONObject.ParseJSONValue(ResultadoAtual) as TJSONObject;
    lEsperadoObj := TJSONObject.ParseJSONValue(ResultadoEsperado) as TJSONObject;

    if not Assigned(lAtualObj) or not Assigned(lEsperadoObj) then
      raise Exception.Create('JSON inválido para comparação.');

    lCampos := lEsperadoObj.Get('campos') as TJSONArray;
    if not Assigned(lCampos) then
    begin
      Result := lAtualObj.ToJSON = lEsperadoObj.ToJSON;
      MostrarLogTextoEmModoDebug('Comparação simples: ' + BoolToStr(Result, True));
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
        MostrarLogTextoEmModoDebug('Campo não encontrado no resultado atual: ' + lCampoNome);
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

      MostrarLogTextoEmModoDebug('Validação [' + lCampoNome + ']: Atual=' + lValorAtual + ', Esperado=' + lValorEsperado + ', Op=' + IntToStr(lOperacao) + ', OK=' + BoolToStr(lIgual, True));

      if not lIgual then
        Result := False;
    end;

    MostrarLogTextoEmModoDebug('Validação final: ' + BoolToStr(Result, True));

  except
    on E: Exception do
    begin
      MostrarLogTextoEmModoDebug('ERRO NA VALIDAÇÃO: ' + E.Message);
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
    MostrarLogTextoEmModoDebug('Tempo Execução: ' + IntToStr(FExecTimeMs) + ' ms');
    MostrarLogTextoEmModoDebug('Tempo Total: ' + IntToStr(FTotalTimeMs) + ' ms');

    PersistirMetricas(FCasoTesteAtualId, FSetupTimeMs, FExecTimeMs, FTotalTimeMs);

    TearDown_Finalizar_CasosTeste;
    MostrarLogTextoEmModoDebug('Teardown concluído');

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
  MostrarLogTextoEmModoDebug('Persistindo métricas no banco dedicado...');

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

    MostrarLogTextoEmModoDebug('Métricas persistidas com sucesso');

  except
    on E: Exception do
    begin
      MostrarLogTextoEmModoDebug('AVISO: Falha ao persistir métricas: ' + E.Message);
    end;
  end;
end;

{ ================================================================
  MAIN / INSTRUÇÕES
  ================================================================ }

procedure Main;
var
  lInstrucoes: String;
begin
  lInstrucoes := 'TDD_ASSETS - Casca única para testes TDD (Debug + Asserts + Assets).' + #13 + #13 +
    '=== DEBUG ===' + #13 +
    ' - procedure SetDebugMode(Value: Boolean)' + #13 +
    '   + Liga/desliga o modo debug globalmente.' + #13 +
    ' - function IsDebugMode: Boolean' + #13 +
    '   + Retorna se modo debug está ativo.' + #13 +
    ' - procedure MostrarLogTextoEmModoDebug(const Msg: String)' + #13 +
    '   + Exibe log apenas se modo debug estiver ativo.' + #13 + #13 +
    '=== ASSERTS ===' + #13 +
    ' - procedure AssertTrue(Condicao, Msg)' + #13 +
    '   + Falha se condição for False.' + #13 +
    ' - procedure AssertEquals(Esperado, Atual, Msg)' + #13 +
    '   + Falha se valores forem diferentes.' + #13 +
    ' - procedure AssertNotEquals(NaoEsperado, Atual, Msg)' + #13 +
    '   + Falha se valores forem iguais.' + #13 + #13 +
    '=== ASSETS (FLUXO DE TESTE) ===' + #13 +
    ' - function Setup_CasoTeste(const Modulo, Area: String; const CasoTesteId: Integer): Boolean' + #13 +
    '   + Inicializa estrutura, carrega caso de teste, inicia cronômetros (Setup/Exec/Total).' + #13 +
    ' - function ExecutarCasoTeste(const CasoTesteJson: String): Boolean' + #13 +
    '   + Executa a lógica do caso de teste (implementar no caso específico).' + #13 +
    ' - function ValidarResultadoEsperado(const ResultadoAtual, ResultadoEsperado: String): Boolean' + #13 +
    '   + Compara JSONs com operações: Igual (0), Maior (1), Menor (2).' + #13 +
    ' - procedure TearDown_CasoTeste' + #13 +
    '   + Para cronômetros, persiste métricas no banco dedicado (METRICAS_EXECUCAO_TESTE), limpa recursos.' + #13 + #13 +
    'FLUXO PADRÃO:' + #13 +
    '  1. SetDebugMode(True)  // opcional' + #13 +
    '  2. Setup_CasoTeste(Modulo, Area, CasoTesteId)' + #13 +
    '  3. ExecutarCasoTeste(CasoTesteJson)' + #13 +
    '  4. ValidarResultadoEsperado(Atual, Esperado)' + #13 +
    '  5. TearDown_CasoTeste  // persiste métricas automaticamente' + #13 + #13 +
    'Uso: chamar SetDebugMode(True) no início para ativar logs de debug.' + #13 +
    'Usar Assert* para validações pontuais nos casos de teste.';
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_ASSETS (Unit 40 - Casca Única)');
end;