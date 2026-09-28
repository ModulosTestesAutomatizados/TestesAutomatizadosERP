uses TDD_ODBC, TDD_LOGS;

procedure Main;
begin

end;

{$region 'Persistência'}
procedure RegistrarMetricas;
var lSQL :string;
begin
  try
    lSQL := 'INSERT INTO HISTORICO_EXECUCAO ('                    + #13 +
      '  AUTOINC_CASO_TESTE_HE,'                                  + #13 +
      '  VERSAO_EXECUCAO_HE,'                                     + #13 +
      '  REQUISITO_VERSAO_HE,'                                    + #13 +
      '  STATUS_EXECUCAO_HE,'                                     + #13 +
      '  ETAPA_FALHA_HE,'                                         + #13 +
      '  MENSAGEM_ERRO_HE,'                                       + #13 +
      '  LOGS_FALHAS_HE'                                          + #13 +
      ') VALUES ('                                                + #13 +
      '  :AutoIncCasoTeste,'                                      + #13 +
      '  :VersaoExecucao,'                                        + #13 +
      '  :RequisitoVersao,'                                       + #13 +
      '  :StatusExecucao,'                                        + #13 +
      '  :EtapaFalha,'                                            + #13 +
      '  :MensagemErro,'                                          + #13 +
      '  :LogsFalhas'                                             + #13 +
      ') RETURNING AUTOINC_HISTORICO_HE';

    {TDD_RUNNER.}FHistoricoExecucao.AutoIncHistorico := {TDD_ODBC.}TDDScalarODBCP(lSQL, [
      // Parâmetros vem de {TDD_RUNNER}
      FHistoricoExecucao.AutoIncCasoTeste,
      FHistoricoExecucao.VersaoExecucao,
      FHistoricoExecucao.RequisitoVersao,
      FHistoricoExecucao.StatusExecucao,
      FHistoricoExecucao.EtapaFalha,
      FHistoricoExecucao.MensagemErro,
      FHistoricoExecucao.LogsFalhas
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

    {TDD_ODBC.}TDDCommandODBCP(lSQL, [
      // Parâmetros vem de {TDD_RUNNER}
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

    if Assigned({TDD_RUNNER.}FCDSMetricasTickDiff) then
    begin
      FCDSMetricasTickDiff.First;
      while not FCDSMetricasTickDiff.Eof do
      begin
        {TDD_ODBC}TDDCommandODBCP(lSQL, [
          // Parâmetros vem de TDD_RUNNER
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
      {TDD_LOGS.}MostrarLogTextoEmModoDebug('Falha ao persistir metricas: ' + Ex.Message);
      raise;
    end;
  end;
end;
{$endregion}
