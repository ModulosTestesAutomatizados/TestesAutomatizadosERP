{ ================================================================
  TDD_STARTED - Casca única / Test Runner para testes TDD

  Herda via P39_TDD_CASOS_DE_TESTE:
  - P39_TDD_CONSTANTES (constantes, cache, SQL)
  - P39_TDD_ODBC (TDDCommandODBC, TDDReaderODBC, TDDScalarODBC)
  - P39_TDD_FUNCOES_JSON (GetValueJson, ValorCurrencyTag, etc.)
  - P39_TDD_CACHE (CDSModulos, CDSAreas, AreaPeloNome, ModuloPeloNome)
  - P39_TDD_PARAMETRO (Setup_Inicializar_Parametros, SetParametro, etc.)
  ================================================================ }
uses P39_TDD_CASOS_DE_TESTE, TDD_LOGS;

var
  // Controle de fluxo
  FCasoTesteAtualId: Integer;
  FCasoTesteAtualJson: String;
  FSetupIniciado: Boolean;

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
    '  1. SetupCasoTeste(Modulo, Area, CasoTesteDescricao)'                                 + #13 +
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
  SETUP DO CASO DE TESTE
  ================================================================ }
function SetupCasoTeste(const Modulo, Area, CasoTesteDesc: String): Boolean;
var
  lCasoTesteJson: String;
  lEncontrou: Boolean;
begin
  Result := False;

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

    // Aplica parametros antes da execucao do caso.
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
end;

{ ================================================================
  VERIFICAÇÕES INICIAIS DE VALIDAÇÃO DA VERSÃO REQUISITO
  ================================================================ }
function ValidarVersaoRequisito :boolean;
var lVersaoRequisito :string;
begin
  try
    lVersaoRequisito := GetValueJson(FCasoTesteAtualJson, 'REQUISITO_VERSAO_CT');
    if VersaoSistemaIgualOuSuperior(lVersaoRequisito) then 
      Result         := True
    else
      raise Exception.Create(
        Format('Versão atual não atende o requisito mínimo.' + #13 + 'Versão atual: %s | Versão requisito: %s', [
          Troca(IntToStr(VersaoSistemaCodigo), ',', '.'),
          lVersaoRequisito 
        ])
      );
  except
    on ex: Exception do
      raise Exception.Create('Falha ao verificar a versão: ' + ex.Message);
  end;
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
      MostrarLogTextoEmModoDebug('Erro ao aplicar parametros: ' + #13 + E.Message);
  end;
end;

{ ================================================================
  STARTED - Fluxo de inicialização para o RUNNER
  ================================================================ }
procedure Started;
begin
  if (Trim(FContextoCasoTeste.Modulo) = '') or
     (Trim(FContextoCasoTeste.Area) = '') or
     (Trim(FContextoCasoTeste.CasoTesteDesc) = '') then
    raise Exception.Create(MensagemPersonalizada + 'Contexto do caso de teste nao foi configurado no TDD_RUNNER.');

  SetupCasoTeste(
    FContextoCasoTeste.Modulo,
    FContextoCasoTeste.Area,
    FContextoCasoTeste.CasoTesteDesc
  );

  FHistoricoExecucao.AutoIncCasoTeste := FCasoTesteAtualId;

  // Faz a verificação da versão de requisito, se falhar já encerra a execução
  ValidarVersaoRequisito;
end;
