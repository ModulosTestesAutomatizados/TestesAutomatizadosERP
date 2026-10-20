

uses TDD_RUN_RUNNER, TDD_FIN_FINANCEIRO;

{ ================================================================
  TDD_RUN_UNIT_BASE_IRUNNER - MOLDE DO FLUXO INTERPRETADO
  Main chama ExecutarLote com o módulo e a área configurados.
  ExecutarLote carrega uma vez,  controla First/Run/Next e libera o lote.
  Falhas individuais são acumuladas e apresentadas depois do encerramento.
  Main propaga a excecao sem acrescentar prefixo neste exemplo.
  Run prepara o caso corrente,  executa Started/Teste,  mantém ASSERTS
  reservado e persiste histórico e tempos individuais.
  FLogsCasoTeste mantém as mensagens capturadas e é limpa após tentar persistir.
  Marcadores de uses,  parâmetros e Teste são preenchidos por IRunner.
  Esta unit é um molde e não deve ser executada isoladamente.
  ================================================================ }

procedure Main;
begin
  try
    // Propaga o modo debug para a thread do método Interpreta.
    FModoDebug := True;
    ExecutarLote('FINANCEIRO', 'FINANCEIRO');
  except
    on Ex: Exception do
      raise;
  end;
end;

procedure ExecutarLote(pDescricaoModulo, pDescricaoArea :string);
var
  lTentados,  lCasosFalhos :integer;
  lFalhas :string;
begin
  lTentados := 0;
  lCasosFalhos := 0;
  lFalhas := '';
  try
    // A carga pertence ao lote. Somente este loop avança o CDS global.
    {TDD_RUN_RUNNER.}SetupCasosTestes(pDescricaoModulo, pDescricaoArea);
    try
      CDSCasosTestes.First;
      while not CDSCasosTestes.Eof do
      begin
        lTentados := lTentados + 1;
        Run;
        // Copia a falha antes de preparar o próximo caso e limpar seu contexto.
        if FHistoricoExecucao.StatusExecucao <> 'SUCESSO' then
        begin
          lCasosFalhos := lCasosFalhos + 1;
          if Trim(FHistoricoExecucao.MensagemErro) <> '' then
            lFalhas := lFalhas + #13 + FHistoricoExecucao.MensagemErro
          else
            lFalhas := lFalhas + #13 + 'Caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) +
              ': ' + FHistoricoExecucao.StatusExecucao;
        end;
        CDSCasosTestes.Next;
      end;
    finally
      {TDD_RUN_LOGS.}DelimitadorLog('RESUMO DO LOTE');
      {TDD_RUN_LOGS.}RegistrarLog(
        '| Carregados: ' + IntToStr(CDSCasosTestes.RecordCount) + #13 +
        '| Tentados:   ' + IntToStr(lTentados) + #13 +
        '| Falhos:     ' + IntToStr(lCasosFalhos)
      );
    end;
  finally
    // Uma falha de limpeza interrompe o encerramento e propaga o erro do lote.
    try
      LiberarMetricasTickDiff;
      TearDown_FinalizarParametros;
      Cache_TearDown_LimparInformacoes;
      TearDown_Finalizar_CasosTeste;
      AssertsZerar;
      FFalhas.Free;
      FFalhas := nil;
      FResultados.Free;
      FResultados := nil;
      FDataSets.Free;
      FDataSets := nil;
      if Assigned(FLogsCasoTeste) then
      begin
        FLogsCasoTeste.Free;
        FLogsCasoTeste := nil;
      end;
    except
      on Ex: Exception do
        raise Exception.Create('Falha ao limpar os recursos do lote: ' + Ex.Message);
    end;
  end;
  // O resumo independe do modo debug e só é apresentado após liberar o lote.
  if lCasosFalhos > 0 then
    raise Exception.Create('Lote encerrado: ' + IntToStr(lTentados) + ' caso(s) executado(s),  ' +
      IntToStr(lCasosFalhos) + ' caso(s) com falha.' + #13 + lFalhas);
end;

{$region Execução individual}
procedure Run;
var lErroDaExecucao :string;
begin
  lErroDaExecucao := '';
  if not Assigned(FLogsCasoTeste) then
    FLogsCasoTeste := TStringList.Create;
  FLogsCasoTeste.Clear;
  try
    try
      {TDD_RUN_LOGS.}DelimitadorLog('PREPARAÇÃO DO CASO');
      // SetarCasoTeste reinicia o estado e usa o registro corrente do lote.
      SetarCasoTeste(FDescModulo, FDescArea);
      FNomeMetodoAtual := 'INICIALIZAR METRICAS';
      InicializarMetricasTickDiff;
      FNomeMetodoAtual := 'TOTAL';
      RegistrarTick(0, 'TOTAL');

      try
        CallBack_AbreTela('Run');
        CallBack_AbreTela(ClassOwner);
        try
          {TDD_RUN_LOGS.}DelimitadorLog('STARTED');
          FNomeMetodoAtual := 'STARTED';
          RegistrarTick(0, 'STARTED');
          {TDD_RUN_STARTED.}Started;
          RegistrarTick(1, 'STARTED');

          {TDD_RUN_LOGS.}DelimitadorLog('IRUNNER');
          FNomeMetodoAtual := 'IRUNNER';
          RegistrarTick(0, 'IRUNNER');

        {P39_TDD_RUN_LOGS.}DelimitadorLog('Teste');
        CallBack_Mensagem(ClassOwner, 'Teste');
        {P39_TDD_RUN_RUNNER.}RegistrarTick(0, 'Teste');
        {TDD_FIN_FINANCEIRO.}Teste;
        {P39_TDD_RUN_RUNNER.}RegistrarTick(1, 'Teste');

          RegistrarTick(1, 'IRUNNER');

          {TDD_RUN_LOGS.}DelimitadorLog('ASSERTS');
          FNomeMetodoAtual := 'ASSERTS';
          if FCDSMetricasTickDiff.FindKey(['IRUNNER']) then
            FTempoExecucaoMs := FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL').AsInteger;
          RegistrarTick(0, 'ASSERTS');
          CompararResultadoEsperado;
          RegistrarTick(1, 'ASSERTS');

          if AssertsOk then
            FHistoricoExecucao.StatusExecucao := 'SUCESSO'
          else
          begin
            FHistoricoExecucao.StatusExecucao := 'FALHA';
            FHistoricoExecucao.EtapaFalha := FEtapaAtual;
            FHistoricoExecucao.MensagemErro := 'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) +
              ',  método ASSERTS: ' + AssertsResumo;
            RegistrarLog(FHistoricoExecucao.MensagemErro);
          end;
        except
          on Ex: Exception do
          begin
            FHistoricoExecucao.MensagemErro := 'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) +
              ',  método ' + FNomeMetodoAtual + ': ' + Ex.Message;
            FHistoricoExecucao.EtapaFalha := FEtapaAtual;
            if FHistoricoExecucao.StatusExecucao <> 'VERSAO_INCOMPATIVEL' then
              FHistoricoExecucao.StatusExecucao := 'FALHA';
            {TDD_RUN_LOGS.}RegistrarLog(FHistoricoExecucao.MensagemErro);

            // Falhas do teste ficam no histórico; preparação/limpeza insegura interrompe.
            if (FNomeMetodoAtual = 'TEARDOWN') or
               ((FNomeMetodoAtual = 'STARTED') and
                (FHistoricoExecucao.StatusExecucao <> 'VERSAO_INCOMPATIVEL')) then
              raise;
          end;
        end;
      finally
        try
          CallBack_FechaTela(ClassOwner);
        finally
          CallBack_FechaTela('Run');
        end;
      end;
      // As métricas ficam disponíveis até a próxima inicialização ou limpeza do lote.
    except
      on Ex: Exception do
      begin
        lErroDaExecucao := 'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) + #13 +
          'Método: ' + FNomeMetodoAtual + ': ' + #13 + Ex.Message;
        {TDD_RUN_LOGS.}RegistrarLog(lErroDaExecucao);
        if FHistoricoExecucao.StatusExecucao <> 'VERSAO_INCOMPATIVEL' then
          FHistoricoExecucao.StatusExecucao := 'FALHA';
        if Trim(FHistoricoExecucao.MensagemErro) = '' then
        begin
          FHistoricoExecucao.MensagemErro := lErroDaExecucao;
          FHistoricoExecucao.EtapaFalha := FEtapaAtual;
        end;
        raise Exception.Create(lErroDaExecucao);
      end;
    end;
  finally
    try
      // Persiste mesmo se preparação,  ticks finais ou callbacks falharem.
      // Sem um ID válido não há FK segura para criar o histórico.
      if FHistoricoExecucao.AutoIncCasoTeste > 0 then
      begin
        {TDD_RUN_FINISHED.}RegistrarMetricas;
      end;
    finally
      FLogsCasoTeste.Clear;
    end;
  end;
end;
{$endregion}
