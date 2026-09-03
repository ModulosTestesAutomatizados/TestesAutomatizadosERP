{ ================================================================
  TDD_STARTED - Casca única / Test Runner para testes TDD
  
  Herda via P39_TDD_CASOS_DE_TESTE:
  - P39_TDD_CONSTANTES (constantes, cache, SQL)
  - P39_TDD_ODBC (TDDCommandODBC, TDDReaderODBC, TDDScalarODBC)
  - P39_TDD_FUNCOES_JSON (GetValueJson, ValorCurrencyTag, etc.)
  - P39_TDD_CACHE (CDSModulos, CDSAreas, AreaPeloNome, ModuloPeloNome)
  - P39_TDD_PARAMETRO (Setup_Inicializar_Parametros, SetParametro, etc.)
  ================================================================ }
uses P39_TDD_CASOS_DE_TESTE;

var
  // Controle de fluxo
  FCasoTesteAtualId: Integer;
  FCasoTesteAtualJson: String;
  FSetupIniciado: Boolean;

  // Cronômetros (substituído TStopwatch por GetTickCount)
  FSetupTimeMs: Cardinal;
  FExecTimeMs: Cardinal;
  FTotalTimeMs: Cardinal;
  FSetupTickIni: Cardinal;
  FExecTickIni: Cardinal;
  FTotalTickIni: Cardinal;

  // Parâmetros do sistema (do JSON do caso de teste)
  FParametrosSistemaJson: String;

{ ================================================================
  MAIN / INSTRUÇÕES
  ================================================================ }
procedure Main;
var
  lInstrucoes: String;
begin
  lInstrucoes := 'TDD_STARTED - Casca única / Test Runner para testes TDD.'                 + #13 + #13 +
    'Uses mínimo: P39_TDD_CASOS_DE_TESTE (herda CONSTANTES, ODBC, JSON, CACHE, PARAMETRO)'  + #13 + #13 +
    '=== FLUXO PADRÃO ==='                                                                  + #13 +
    '  1. Setup_CasoTeste(Modulo, Area, CasoTesteId)'                                       + #13 +
    '     + Inicializa estrutura, carrega caso, aplica parâmetros do JSON, cronômetros'     + #13 +
    '  2. ExecutarCasoTeste(CasoTesteJson)'                                                 + #13 +
    '     + Implementar lógica específica do teste'                                         + #13 +
    '  3. TDD_ASSERTS.ValidarResultado(Atual, Esperado)'                                    + #13 +
    '     + Compara JSON actual vs expected (Igual/Maior/Menor/Contém/Schema)'              + #13 +
    '  4. TearDown_CasoTeste'                                                               + #13 +
    '     + Para cronômetros, persiste métricas em METRICAS_EXECUCAO_TESTE, limpa recursos' + #13 + #13 +
    '=== PARÂMETROS DO SISTEMA ==='                                                         + #13 +
    '  JSON do caso de teste pode conter objeto "parametros":'                              + #13 +
    '  { "parametros": { "CHAVE_PARAM": "VALOR", "OUTRA_CHAVE": 123 } }'                    + #13 +
    '  São aplicados automaticamente via SetParametroSistema no Setup.'                     + #13 + #13 +
    '=== MÉTRICAS ==='                                                                      + #13 +
    '  Persistidas automaticamente no banco dedicado (METRICAS_EXECUCAO_TESTE):'            + #13 +
    '  - TEMPO_SETUP_MS, TEMPO_EXECUCAO_MS, TEMPO_TOTAL_MS'                                 + #13 +
    '  - CASO_TESTE_ID, VERSAO_SISTEMA, DATA_EXECUCAO';
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_STARTED (Unit 40)');
end;

{ ================================================================
  INICIALIZAÇÃO DE PARÂMETROS DO SISTEMA
  ================================================================ }

procedure AplicarParametrosDoCasoTeste;
var
  lJsonObj: TJSONObject;
  lChave, lValor: String;
  i: Integer;
begin
  if (Trim(FParametrosSistemaJson) = '') or (FParametrosSistemaJson = '{}') then
    Exit;

  MostrarLogTextoEmModoDebug('Aplicando parâmetros do sistema do caso de teste...');

  try
    lJsonObj := TJSONObject.ParseJSONValue(FParametrosSistemaJson) as TJSONObject;
    if not Assigned(lJsonObj) then
      Exit;

    for i := 0 to lJsonObj.Count - 1 do
    begin
      lChave := lJsonObj.Get(i).JsonString.Value;
      lValor := lJsonObj.Get(lChave).ToJSON;
      if (lValor.StartsWith('"')) and (lValor.EndsWith('"')) then
        lValor := Copy(lValor, 2, Length(lValor) - 2);

      SetParametroSistema(lChave, lValor);
      MostrarLogTextoEmModoDebug('  Parâmetro [' + lChave + '] = ' + lValor);
    end;
  except
    on E: Exception do
      MostrarLogTextoEmModoDebug('AVISO: Erro ao aplicar parâmetros: ' + E.Message);
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
  
  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, '[SETUP TDD_STARTED] Inicializando....');
    MostrarLogTextoEmModoDebug('=== SETUP CASO DE TESTE INICIADO ===');
    MostrarLogTextoEmModoDebug('Módulo: ' + Modulo + ', Área: ' + Area + ', CasoTesteId: ' + IntToStr(CasoTesteId));

    FTotalTickIni := GetTickCount;

    FSetupTickIni := GetTickCount;

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

      MostrarLogTextoEmModoDebug('Caso de teste carregado: ' + IntToStr(CasoTesteId));
      MostrarLogTextoEmModoDebug('JSON do caso: ' + Copy(lCasoTesteJson, 1, 200) + '...');

      CarregarConfiguracoes;
      MostrarLogTextoEmModoDebug('Configurações carregadas');

      // APLICA PARÂMETROS DO SISTEMA ANTES DE EXECUTAR
      AplicarParametrosDoCasoTeste;

      FSetupTimeMs := GetTickCount - FSetupTickIni;
      MostrarLogTextoEmModoDebug('Setup concluído em ' + IntToStr(FSetupTimeMs) + ' ms');
      Result := True;

      FExecTickIni := GetTickCount;

    except
      on E: Exception do
      begin
        MostrarLogTextoEmModoDebug('ERRO NO SETUP: ' + E.Message);
        raise;
      end;
    end;
  finally
    CallBack_FechaTela(ClassOwner);
  end;
end;

{ ================================================================
  EXECUÇÃO DO CASO DE TESTE (placeholder - implementar no caso específico)
  ================================================================ }

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

{ ================================================================
  TEARDOWN + MÉTRICAS
  ================================================================ }

procedure TearDown_CasoTeste;
begin
  MostrarLogTextoEmModoDebug('=== TEARDOWN CASO DE TESTE ===');

  try
    FExecTimeMs := GetTickCount - FExecTickIni;
    FTotalTimeMs := GetTickCount - FTotalTickIni;

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

procedure PersistirMetricas(const CasoTesteId: Integer; const SetupMs, ExecMs, TotalMs: Cardinal);
var
  lSql: String;
  lVersao: TVersao;
  lVersaoSistema: String;
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
      MostrarLogTextoEmModoDebug('AVISO: Falha ao persistir métricas: ' + E.Message);
  end;
end;
