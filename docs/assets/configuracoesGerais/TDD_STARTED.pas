{ ================================================================
  TDD_STARTED - Casca única / Test Runner para testes TDD

  Herda via P39_TDD_CASOS_DE_TESTE:
  - P39_TDD_CONSTANTES (constantes, cache, SQL)
  - P39_TDD_ODBC (TDDCommandODBC, TDDReaderODBC, TDDScalarODBC)
  - P39_TDD_FUNCOES_JSON (GetValueJson, ValorCurrencyTag, etc.)
  - P39_TDD_CACHE (CDSModulos, CDSAreas, AreaPeloNome, ModuloPeloNome)
  - P39_TDD_PARAMETRO (Setup_Inicializar_Parametros, SetParametro, etc.)
  ================================================================ }
uses P39_TDD_CASOS_DE_TESTE, TDD_ASSERTS;

var
  // Controle de fluxo
  FCasoTesteAtualId: Integer;
  FCasoTesteAtualJson: String;
  FSetupIniciado: Boolean;
  FModoDebug: Boolean;

  // Cronometros baseados em TDateTime, suportado pelo interpretador.
  FSetupTimeMs: Integer;
  FExecTimeMs: Integer;
  FTotalTimeMs: Integer;
  FSetupInicio: TDateTime;
  FExecInicio: TDateTime;
  FTotalInicio: TDateTime;

  // Parâmetros do sistema

procedure SetModoDebug(pAtivo: Boolean);
begin
  FModoDebug := pAtivo;
end;

function ModoDebugAtivo: Boolean;
begin
  Result := FModoDebug;
end;

procedure MostrarLogTextoEmModoDebug(pTexto: String);
begin
  if FModoDebug then
    MostrarLogTexto(pTexto, '[DEBUG]');
end;

procedure ValidarResultadoDaExecucao(pEsperado, pObtido: String);
begin
  AssertsZerar;
  ValidarResultadoEsperado(pEsperado, pObtido, 'Validacao Resultado Completo');

  if not AssertsOk then
    raise Exception.Create(MensagemPersonalizada + 'Validacao falhou: ' + AssertsResumo);

  MostrarLogTextoEmModoDebug('[Asserts] ' + AssertsResumo);
end;

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
    '  1. Setup_CasoTeste(Modulo, Area, CasoTesteDescricao)'                                  + #13 +
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
    '  Sao aplicados automaticamente via VerificarParametros no Setup.'                     + #13 + #13 +
    '=== MÉTRICAS ==='                                                                      + #13 +
    '  Persistidas automaticamente no banco dedicado (METRICAS_EXECUCAO_TESTE):'            + #13 +
    '  - TEMPO_SETUP_MS, TEMPO_EXECUCAO_MS, TEMPO_TOTAL_MS'                                 + #13 +
    '  - CASO_TESTE_ID, VERSAO_SISTEMA, DATA_EXECUCAO';
  MostrarLogTexto(lInstrucoes, 'Instrucoes TDD_STARTED (Unit 41)');
end;

{ ================================================================
  INICIALIZAÇÃO DE PARÂMETROS DO SISTEMA
  ================================================================ }

procedure AplicarParametrosDoCasoTeste;
begin
  if (Trim(FCasoTesteAtualJson) = '') or (FCasoTesteAtualJson = '{}') then
    Exit;

  MostrarLogTextoEmModoDebug('Aplicando parametros do sistema do caso de teste...');

  try
    VerificarParametros(FCasoTesteAtualJson);
  except
    on E: Exception do
      MostrarLogTextoEmModoDebug('AVISO: Erro ao aplicar parametros: ' + E.Message);
  end;
end;

{ ================================================================
  SETUP DO CASO DE TESTE
  ================================================================ }

function Setup_CasoTeste(const Modulo, Area: String; const CasoTesteDesc: String): Boolean;
var
  lCasoTesteJson: String;
  lEncontrou: Boolean;
begin
  Result := False;

  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, '[SETUP TDD_STARTED] Inicializando....');
    MostrarLogTextoEmModoDebug('=== SETUP CASO DE TESTE INICIADO ===');
    MostrarLogTextoEmModoDebug('Modulo: ' + Modulo + ', Area: ' + Area + ', CasoTeste: ' + CasoTesteDesc);

    FTotalInicio := Now;

    FSetupInicio := Now;

    try
      Setup_Inicializar_CasosTeste;
      MostrarLogTextoEmModoDebug('Estrutura de casos de teste inicializada');

      SetModulo(Modulo);
      SetArea(Area);
      MostrarLogTextoEmModoDebug('Modulo/Area configurados');

      CarregarCasosTeste;
      MostrarLogTextoEmModoDebug('Casos de teste carregados');

      lCasoTesteJson := '';
      lEncontrou := False;
      CDSCasosTestes.First;
      while not CDSCasosTesteS.Eof do
      begin
        if UpperCase(Trim(CDSCasosTestes.FieldByName('DESCRICAO').AsString)) = UpperCase(Trim(CasoTesteDesc)) then
        begin
          lCasoTesteJson := CDSCasosTestes.FieldByName('CASOTESTE').AsString;
          FCasoTesteAtualId := CDSCasosTestes.FieldByName('ID').AsInteger;
          lEncontrou := True;
          Break;
        end;
        CDSCasosTestes.Next;
      end;

      if not lEncontrou then
        raise Exception.Create(MensagemPersonalizada + 'Caso de teste "' + CasoTesteDesc + '" nao encontrado.');

      FCasoTesteAtualJson := lCasoTesteJson;

      MostrarLogTextoEmModoDebug('Caso de teste encontrado: ' + CasoTesteDesc + ' (ID ' + IntToStr(FCasoTesteAtualId) + ')');
      MostrarLogTextoEmModoDebug('JSON do caso: ' + Copy(lCasoTesteJson, 1, 200) + '...');

      CarregarConfiguracoes;
      MostrarLogTextoEmModoDebug('Configurações carregadas');

      // APLICA PARÂMETROS DO SISTEMA ANTES DE EXECUTAR
      AplicarParametrosDoCasoTeste;

      FSetupTimeMs := Round((Now - FSetupInicio) * 86400000);
      MostrarLogTextoEmModoDebug('Setup concluído em ' + IntToStr(FSetupTimeMs) + ' ms');
      Result := True;

      FExecInicio := Now;

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
    FExecTimeMs := Round((Now - FExecInicio) * 86400000);
    FTotalTimeMs := Round((Now - FTotalInicio) * 86400000);

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

procedure PersistirMetricas(const CasoTesteId: Integer; const SetupMs, ExecMs, TotalMs: Integer);
var
  lSql: String;
  lVersao: TVersao;
  lVersaoSistema: String;
begin
  MostrarLogTextoEmModoDebug('Persistindo métricas no banco dedicado...');

  try
    lVersao := GetVersao;
    lVersaoSistema := Format('%d.%d', [lVersao.Codigo, lVersao.Numero]);

    lSql := 'INSERT INTO METRICAS_EXECUCAO_TESTE (' +
      'CASO_TESTE_ID, VERSAO_SISTEMA, TEMPO_SETUP_MS, TEMPO_EXECUCAO_MS, TEMPO_TOTAL_MS, DATA_EXECUCAO' +
      ') VALUES (' + IntToStr(CasoTesteId) + ', ' + QuotedStr(lVersaoSistema) + ', ' +
      IntToStr(SetupMs) + ', ' + IntToStr(ExecMs) + ', ' + IntToStr(TotalMs) +
      ', CURRENT_TIMESTAMP)';

    TDDCommandODBC(lSql);

    MostrarLogTextoEmModoDebug('Métricas persistidas com sucesso');

  except
    on E: Exception do
      MostrarLogTextoEmModoDebug('AVISO: Falha ao persistir métricas: ' + E.Message);
  end;
end;
