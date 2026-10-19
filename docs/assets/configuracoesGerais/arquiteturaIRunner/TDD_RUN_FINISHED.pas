procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit responsável pela persistência individual do histórico e das métricas de tempo.'                     + #13 +
    '====================================================================================================================' + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                  + #13 +
    'procedure RegistrarMetricas'                                                                                          + #13 +
    '  - Insere o histórico de FHistoricoExecucao e obtém o ID retornado.'                                                 + #13 +
    '  - Persiste os registros de FCDSMetricasTickDiff vinculados ao histórico dessa tentativa.'                           + #13 +
    '  - Encerra ticks abertos e tenta gravar o histórico mesmo se esse encerramento falhar.'                              + #13 +
    '====================================================================================================================' + #13 +
    'Contrato de persistência:'                                                                                            + #13 +
    'Run fornece o contexto; Finished copia os logs em memória imediatamente antes do INSERT.'                             + #13 +
    'Erros continuam propagados pelos tratamentos existentes; não há repetição automática de INSERT.'                      + #13 +
    'Os resultados de asserts são persistidos por tentativa, inclusive quando parciais ou vazios.'                         + #13 +
    'Falhas de encerramento e persistência são registradas; o diagnóstico preserva a causa anterior.'                      + #13 +
    'FExibirInstrucoes controla a exibição destas instruções.'                                                             + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_RUN_FINISHED', lInstrucoes);
end;

{$region 'Persistência'}
procedure RegistrarMetricas;
var lSQL, lMetodoAntesFinished, lErroEncerramento, lErroPersistencia :string;
begin
  lMetodoAntesFinished := FNomeMetodoAtual;
  lErroEncerramento := '';
  try
    {P39_TDD_RUN_LOGS.}DelimitadorLog('ENCERRAMENTO DOS TEMPOS');
    if Assigned(FCDSMetricasTickDiff) then
    begin
      FCDSMetricasTickDiff.First;
      while not FCDSMetricasTickDiff.Eof do
      begin
        if FCDSMetricasTickDiff.FieldByName('TEMPO_FIM').AsInteger = 0 then
          RegistrarTick(1, FCDSMetricasTickDiff.FieldByName('NOME_METODO').AsString);
        FCDSMetricasTickDiff.Next;
      end;
    end;
  except
    on Ex: Exception do
    begin
      lErroEncerramento := 'Falha ao encerrar os tempos: ' + Ex.Message;
      {P39_TDD_RUN_LOGS.}RegistrarLog(lErroEncerramento);
      if FHistoricoExecucao.StatusExecucao <> 'VERSAO_INCOMPATIVEL' then
        FHistoricoExecucao.StatusExecucao := 'FALHA';
      if Trim(FHistoricoExecucao.MensagemErro) = '' then
      begin
        FHistoricoExecucao.MensagemErro := lErroEncerramento;
        FHistoricoExecucao.EtapaFalha := FEtapaAtual;
      end;
    end;
  end;

  {P39_TDD_RUN_LOGS.}DelimitadorLog('FINISHED');
  FNomeMetodoAtual := 'FINISHED';
  FMetricasAsserts.AssertsTotal := AssertsTotal;
  FMetricasAsserts.AssertsAprovados := AssertsPass;
  FMetricasAsserts.AssertsFalhos := AssertsFail;
  FMetricasAsserts.ResultadoEsperado := FResultadoEsperadoCaso;
  FMetricasAsserts.ResultadoObtido := '';
  if Assigned(FResultados) then
    FMetricasAsserts.ResultadoObtido := FResultados.Text;
  if Assigned(FCDSMetricasTickDiff) then
  begin
    if FCDSMetricasTickDiff.FindKey(['ASSERTS']) then
    begin
      FMetricasAsserts.EtapaCasoTeste := FCDSMetricasTickDiff.FieldByName('ETAPA_CASO_TESTE').AsInteger;
      FMetricasAsserts.TempoTotal := FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL').AsInteger;
    end;
  end;
  // Copia no ponto de persistência, antes que Run limpe a lista da tentativa.
  if Assigned(FLogsCasoTeste) then
    FHistoricoExecucao.LogsProcessamento := FLogsCasoTeste.Text;

  try
    lSQL := 'INSERT INTO HISTORICO_EXECUCAO ('                    + #13 +
      '  AUTOINC_CASO_TESTE_HE,'                                  + #13 +
      '  VERSAO_EXECUCAO_HE,'                                     + #13 +
      '  REQUISITO_VERSAO_HE,'                                    + #13 +
      '  STATUS_EXECUCAO_HE,'                                     + #13 +
      '  ETAPA_FALHA_HE,'                                         + #13 +
      '  MENSAGEM_ERRO_HE,'                                       + #13 +
      '  LOGS_PROCESSAMENTO_HE'                                   + #13 +
      ') VALUES ('                                                + #13 +
      '  :AutoIncCasoTeste,'                                      + #13 +
      '  :VersaoExecucao,'                                        + #13 +
      '  :RequisitoVersao,'                                       + #13 +
      '  :StatusExecucao,'                                        + #13 +
      '  :EtapaFalha,'                                            + #13 +
      '  :MensagemErro,'                                          + #13 +
      '  :LogsProcessamento'                                      + #13 +
      ') RETURNING AUTOINC_HISTORICO_HE';

    {P39_TDD_RUN_RUNNER.}FHistoricoExecucao.AutoIncHistorico := {P39_TDD_ODBC.}TDDScalarODBCP(lSQL, [
      // Parâmetros vem de {P39_TDD_RUN_RUNNER}
      FHistoricoExecucao.AutoIncCasoTeste,
      FHistoricoExecucao.VersaoExecucao,
      FHistoricoExecucao.RequisitoVersao,
      FHistoricoExecucao.StatusExecucao,
      FHistoricoExecucao.EtapaFalha,
      FHistoricoExecucao.MensagemErro,
      FHistoricoExecucao.LogsProcessamento
    ]);

    lSQL := 'INSERT INTO METRICAS_ASSERTS ('       + #13 +
      '  AUTOINC_HISTORICO_HE,'                    + #13 +
      '  ETAPA_CASO_TESTE_AT,'                     + #13 +
      '  TEMPO_TOTAL_AT,'                          + #13 +
      '  ASSERTS_TOTAL_AT,'                        + #13 +
      '  ASSERTS_APROVADOS_AT,'                    + #13 +
      '  ASSERTS_FALHOS_AT,'                       + #13 +
      '  RESULTADO_ESPERADO_AT,'                   + #13 +
      '  RESULTADO_OBTIDO_AT'                      + #13 +
      ') VALUES ('                                 + #13 +
      '  :AutoIncHistorico,'                       + #13 +
      '  :EtapaCasoTeste,'                         + #13 +
      '  :TempoTotal,'                             + #13 +
      '  :AssertsTotal,'                           + #13 +
      '  :AssertsAprovados,'                       + #13 +
      '  :AssertsFalhos,'                          + #13 +
      '  :ResultadoEsperado,'                      + #13 +
      '  :ResultadoObtido'                         + #13 +
      ')';

    {P39_TDD_ODBC.}TDDCommandODBCP(lSQL, [
      // Parâmetros vem de {P39_TDD_RUN_RUNNER}
      FHistoricoExecucao.AutoIncHistorico,
      FMetricasAsserts.EtapaCasoTeste,
      FMetricasAsserts.TempoTotal,
      FMetricasAsserts.AssertsTotal,
      FMetricasAsserts.AssertsAprovados,
      FMetricasAsserts.AssertsFalhos,
      FMetricasAsserts.ResultadoEsperado,
      FMetricasAsserts.ResultadoObtido
    ]);

    lSQL := 'INSERT INTO METRICAS_TICK_DIFF ('     + #13 +
      '  AUTOINC_HISTORICO_HE,'                    + #13 +
      '  NOME_METODO_TD,'                          + #13 +
      '  ETAPA_CASO_TESTE_TD,'                     + #13 +
      '  TEMPO_INICIO_TD,'                         + #13 +
      '  TEMPO_FIM_TD,'                            + #13 +
      '  TEMPO_TOTAL_TD,'                          + #13 +
      '  TEMPO_TOTAL_FORMATADO_TD'                 + #13 +
      ') VALUES ('                                 + #13 +
      '  :AutoIncHistorico,'                       + #13 +
      '  :NomeMetodo,'                             + #13 +
      '  :EtapaCasoTeste,'                         + #13 +
      '  :TempoInicio,'                            + #13 +
      '  :TempoFim,'                               + #13 +
      '  :TempoTotal,'                             + #13 +
      '  :TempoTotalFormatado'                     + #13 +
      ')';

    if Assigned({P39_TDD_RUN_RUNNER.}FCDSMetricasTickDiff) then
    begin
      FCDSMetricasTickDiff.First;
      while not FCDSMetricasTickDiff.Eof do
      begin
        {P39_TDD_ODBC}TDDCommandODBCP(lSQL, [
          // Parâmetros vem de P39_TDD_RUN_RUNNER
          FHistoricoExecucao.AutoIncHistorico,
          FCDSMetricasTickDiff.FieldByName('NOME_METODO').AsString,
          FCDSMetricasTickDiff.FieldByName('ETAPA_CASO_TESTE').AsInteger,
          FCDSMetricasTickDiff.FieldByName('TEMPO_INICIO').AsInteger,
          FCDSMetricasTickDiff.FieldByName('TEMPO_FIM').AsInteger,
          FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL').AsInteger,
          FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL_FORMATADO').AsString
        ]);

        FCDSMetricasTickDiff.Next;
      end;
    end;
  except
    on Ex: Exception do
    begin
      lErroPersistencia := 'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) +
        ', método FINISHED: ' + Ex.Message;

      {P39_TDD_RUN_LOGS.}RegistrarLog(lErroPersistencia);

      if Assigned(FLogsCasoTeste) then
        FHistoricoExecucao.LogsProcessamento := FLogsCasoTeste.Text;

      if (lErroEncerramento <> '') and (FHistoricoExecucao.MensagemErro <> lErroEncerramento) then
        lErroPersistencia := lErroEncerramento + #13 + lErroPersistencia;

      if Trim(FHistoricoExecucao.MensagemErro) <> '' then
        raise Exception.Create(FHistoricoExecucao.MensagemErro + #13 + lErroPersistencia);

      raise Exception.Create(lErroPersistencia);
    end;
  end;

  FNomeMetodoAtual := lMetodoAntesFinished;

  if lErroEncerramento <> '' then
  begin
    if (Trim(FHistoricoExecucao.MensagemErro) <> '') and (FHistoricoExecucao.MensagemErro <> lErroEncerramento) then
      raise Exception.Create(FHistoricoExecucao.MensagemErro + #13 + lErroEncerramento);
    raise Exception.Create(lErroEncerramento);
  end;
end;
{$endregion}
