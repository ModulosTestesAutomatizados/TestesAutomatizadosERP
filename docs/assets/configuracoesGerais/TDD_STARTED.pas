uses P39_TDD_CASOS_DE_TESTE;

{ ================================================================
  TDD_STARTED - Casca única / Test Runner para testes TDD
  
  Herda via P39_TDD_CASOS_DE_TESTE:
  - P39_TDD_CONSTANTES (constantes, cache, SQL)
  - P39_TDD_ODBC (TDDCommandODBC, TDDReaderODBC, TDDScalarODBC)
  - P39_TDD_FUNCOES_JSON (GetValueJson, ValorCurrencyTag, etc.)
  - P39_TDD_CACHE (CDSModulos, CDSAreas, AreaPeloNome, ModuloPeloNome)
  - P39_TDD_PARAMETRO (Setup_Inicializar_Parametros, SetParametro, etc.)
  ================================================================ }

var
  // Controle de fluxo
  FCasoTesteAtualId: Integer;
  FCasoTesteAtualJson: String;
  FSetupIniciado: Boolean;

  // Cronômetros
  FSetupTimeMs: Int64;
  FExecTimeMs: Int64;
  FTotalTimeMs: Int64;
  FSetupStopwatch: TStopwatch;
  FExecStopwatch: TStopwatch;
  FTotalStopwatch: TStopwatch;

  // Parâmetros do sistema (do JSON do caso de teste)
  FParametrosSistemaJson: String;

{ ================================================================
  INICIALIZAÇÃO DE PARÂMETROS DO SISTEMA
  ================================================================ }

procedure AplicarParametrosDoCasoTeste;
var
  lJsonObj: TJSONObject;
  lParamObj: TJSONObject;
  lChave, lValor: String;
  i: Integer;
begin
  if (Trim(FParametrosSistemaJson) = '') or (FParametrosSistemaJson = '{}') then
    Exit;

  MostrarLogTexto('Aplicando parâmetros do sistema do caso de teste...', '[STARTED]');

  try
    lJsonObj := TJSONObject.ParseJSONValue(FParametrosSistemaJson) as TJSONObject;
    if not Assigned(lJsonObj) then
      Exit;

    // Itera sobre as chaves do objeto "parametros"
    for i := 0 to lJsonObj.Count - 1 do
    begin
      lChave := lJsonObj.Get(i).JsonString.Value;
      lValor := lJsonObj.Get(lChave).ToJSON;
      // Remove aspas se for string
      if (lValor.StartsWith('"')) and (lValor.EndsWith('"')) then
        lValor := Copy(lValor, 2, Length(lValor) - 2);

      // Usa a unit de parâmetros herdada
      SetParametroSistema(lChave, lValor);
      MostrarLogTexto('  Parametro [' + lChave + '] = ' + lValor, '[STARTED]');
    end;
  except
    on E: Exception do
      MostrarLogTexto('AVISO: Erro ao aplicar parâmetros: ' + E.Message, '[STARTED]');
  end;
end;

{ ================================================================
  SETUP DO CASO DE TESTE
  ================================================================ }

function Setup_CasoTeste(const Modulo, Area: String; const CasoTesteId: Integer): Boolean;
var
  lCasoTesteJson: String;
  lResultadoEsperadoJson: String;
  lCamposDisponiveisJson: String;
  lParametrosJson: String;
begin
  Result := False;
  MostrarLogTexto('=== SETUP CASO DE TESTE INICIADO ===', '[STARTED]');
  MostrarLogTexto('Módulo: ' + Modulo + ', Área: ' + Area + ', CasoTesteId: ' + IntToStr(CasoTesteId), '[STARTED]');

  FTotalStopwatch := TStopwatch.Create;
  FTotalStopwatch.Start;

  FSetupStopwatch := TStopwatch.Create;
  FSetupStopwatch.Start;

  try
    Setup_Inicializar_CasosTeste;
    MostrarLogTexto('Estrutura de casos de teste inicializada', '[STARTED]');

    SetModulo(Modulo);
    SetArea(Area);
    MostrarLogTexto('Módulo/Área configurados', '[STARTED]');

    CarregarCasosTeste;
    MostrarLogTexto('Casos de teste carregados', '[STARTED]');

    lCasoTesteJson := GetCasoTestePorId(CasoTesteId);
    if lCasoTesteJson = '' then
      raise Exception.Create(MensagemPersonalizada + 'Caso de teste ID ' + IntToStr(CasoTesteId) + ' não encontrado.');

    lResultadoEsperadoJson := GetResultadoEsperadoPorId(CasoTesteId);
    lCamposDisponiveisJson := GetCamposDisponiveisPorId(CasoTesteId);

    // Extrai parâmetros do JSON do caso de teste
    lParametrosJson := '';
    try
      var lJson := TJSONObject.ParseJSONValue(lCasoTesteJson) as TJSONObject;
      if Assigned(lJson) then
      begin
        if lJson.TryGetValue('parametros', lParametrosJson) then
          FParametrosSistemaJson := lParametrosJson;
      end;
    except end;

    FCasoTesteAtualId := CasoTesteId;
    FCasoTesteAtualJson := lCasoTesteJson;

    MostrarLogTexto('Caso de teste carregado: ' + IntToStr(CasoTesteId), '[STARTED]');
    MostrarLogTexto('JSON do caso: ' + Copy(lCasoTesteJson, 1, 200) + '...', '[STARTED]');

    CarregarConfiguracoes;
    MostrarLogTexto('Configurações carregadas', '[STARTED]');

    // APLICA PARÂMETROS DO SISTEMA ANTES DE EXECUTAR
    AplicarParametrosDoCasoTeste;

    FSetupStopwatch.Stop;
    FSetupTimeMs := FSetupStopwatch.ElapsedMilliseconds;

    MostrarLogTexto('Setup concluído em ' + IntToStr(FSetupTimeMs) + ' ms', '[STARTED]');
    Result := True;

    FExecStopwatch := TStopwatch.Create;
    FExecStopwatch.Start;

  except
    on E: Exception do
    begin
      MostrarLogTexto('ERRO NO SETUP: ' + E.Message, '[STARTED]');
      raise;
    end;
  end;
end;

{ ================================================================
  EXECUÇÃO DO CASO DE TESTE (placeholder - implementar no caso específico)
  ================================================================ }

function ExecutarCasoTeste(const CasoTesteJson: String): Boolean;
begin
  Result := False;
  MostrarLogTexto('=== EXECUÇÃO CASO DE TESTE ===', '[STARTED]');

  try
    MostrarLogTexto('Executando lógica do caso de teste...', '[STARTED]');
    MostrarLogTexto('JSON recebido: ' + Copy(CasoTesteJson, 1, 200) + '...', '[STARTED]');

    Result := True;
    MostrarLogTexto('Execução concluída com sucesso', '[STARTED]');

  except
    on E: Exception do
    begin
      MostrarLogTexto('ERRO NA EXECUÇÃO: ' + E.Message, '[STARTED]');
      Result := False;
      raise;
    end;
  end;
end;

{ ================================================================
  TEARDOWN + MÉTRICAS
  ================================================================ }

procedure TearDown_CasoTeste;
begin
  MostrarLogTexto('=== TEARDOWN CASO DE TESTE ===', '[STARTED]');

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

    MostrarLogTexto('Tempo Setup: ' + IntToStr(FSetupTimeMs) + ' ms', '[STARTED]');
    MostrarLogTexto('Tempo Execução: ' + IntToStr(FExecTimeMs) + ' ms', '[STARTED]');
    MostrarLogTexto('Tempo Total: ' + IntToStr(FTotalTimeMs) + ' ms', '[STARTED]');

    PersistirMetricas(FCasoTesteAtualId, FSetupTimeMs, FExecTimeMs, FTotalTimeMs);

    TearDown_Finalizar_CasosTeste;
    MostrarLogTexto('Teardown concluído', '[STARTED]');

  except
    on E: Exception do
    begin
      MostrarLogTexto('ERRO NO TEARDOWN: ' + E.Message, '[STARTED]');
      raise;
    end;
  end;
end;

procedure PersistirMetricas(const CasoTesteId: Integer; const SetupMs, ExecMs, TotalMs: Int64);
var
  lSql: String;
  lVersao: TVersao;
  lVersaoSistema: String;
begin
  MostrarLogTexto('Persistindo métricas no banco dedicado...', '[STARTED]');

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

    MostrarLogTexto('Métricas persistidas com sucesso', '[STARTED]');

  except
    on E: Exception do
      MostrarLogTexto('AVISO: Falha ao persistir métricas: ' + E.Message, '[STARTED]');
  end;
end;

{ ================================================================
  MAIN / INSTRUÇÕES
  ================================================================ }

procedure Main;
var
  lInstrucoes: String;
begin
  lInstrucoes := 'TDD_STARTED - Casca única / Test Runner para testes TDD.' + #13 + #13 +
    'Uses mínimo: P39_TDD_CASOS_DE_TESTE (herda CONSTANTES, ODBC, JSON, CACHE, PARAMETRO)' + #13 + #13 +
    '=== FLUXO PADRÃO ===' + #13 +
    '  1. Setup_CasoTeste(Modulo, Area, CasoTesteId)' + #13 +
    '     + Inicializa estrutura, carrega caso, aplica parâmetros do JSON, cronômetros' + #13 +
    '  2. ExecutarCasoTeste(CasoTesteJson)' + #13 +
    '     + Implementar lógica específica do teste' + #13 +
    '  3. TDD_ASSERTS.ValidarResultado(Atual, Esperado)' + #13 +
    '     + Compara JSON actual vs expected (Igual/Maior/Menor/Contém/Schema)' + #13 +
    '  4. TearDown_CasoTeste' + #13 +
    '     + Para cronômetros, persiste métricas em METRICAS_EXECUCAO_TESTE, limpa recursos' + #13 + #13 +
    '=== PARÂMETROS DO SISTEMA ===' + #13 +
    '  JSON do caso de teste pode conter objeto "parametros":' + #13 +
    '  { "parametros": { "CHAVE_PARAM": "VALOR", "OUTRA_CHAVE": 123 } }' + #13 +
    '  São aplicados automaticamente via SetParametroSistema no Setup.' + #13 + #13 +
    '=== MÉTRICAS ===' + #13 +
    '  Persistidas automaticamente no banco dedicado (METRICAS_EXECUCAO_TESTE):' + #13 +
    '  - TEMPO_SETUP_MS, TEMPO_EXECUCAO_MS, TEMPO_TOTAL_MS' + #13 +
    '  - CASO_TESTE_ID, VERSAO_SISTEMA, DATA_EXECUCAO';
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_STARTED (Unit 40)');
end;