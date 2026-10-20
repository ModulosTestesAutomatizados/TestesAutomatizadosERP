

uses TDD_RUN_RUNNER,__USES_UNITS__;

var FLogsPreparacao :string;

{ ================================================================
  TDD_RUN_UNIT_BASE_IRUNNER - MOLDE DO FLUXO INTERPRETADO
  Main chama ExecutarLote com o módulo e a área configurados.
  ExecutarLote carrega uma vez, controla First/Run/Next e libera o lote.
  Falhas individuais são acumuladas e apresentadas depois do encerramento.
  Main concentra o único prefixo MensagemPersonalizada deste fluxo.
  Run prepara o caso corrente, executa Started/Teste, mantém ASSERTS
  reservado e persiste histórico e tempos individuais.
  FLogsCasoTeste mantém as mensagens capturadas e é limpa após tentar persistir.
  Marcadores de uses, parâmetros e Teste são preenchidos por IRunner.
  Esta unit é um molde e não deve ser executada isoladamente.
  ================================================================ }

procedure Main;
begin
  try
    // Esta lista pertence ao lote; não reutiliza o buffer da montagem do IRunner.
    FLogsCasoTeste  := TStringList.Create;
    FModoDebug      := __MODO_DEBUG__;
    FLogsPreparacao := __LOGS_PREPARACAO__;
    ExecutarLote(__PARAMETROS_CASO_TESTE__);
  except
    on Ex: Exception do
      raise Exception.Create(MensagemPersonalizada + #13 + Ex.Message);
  end;
end;

procedure ExecutarLote(pDescricaoModulo,pDescricaoArea :string);
var
  lTentados, lCasosFalhos :integer;
  lFalhas :string;
begin
  lTentados := 0;
  lCasosFalhos := 0;
  lFalhas := '';
  try
    // A carga pertence ao lote.
    // Somente este loop avança o CDS global.
    {TDD_RUN_RUNNER.}SetupCasosTestes(pDescricaoModulo,pDescricaoArea);
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
      FResultados.Free;
      FDataSets.Free;
      if Assigned(FLogsCasoTeste) then
        FLogsCasoTeste.Free;
    except
      on Ex: Exception do
        raise Exception.Create('Falha ao limpar os recursos do lote: ' + Ex.Message);
    end;
  end;
  // O resumo independe do modo debug e só é apresentado após liberar o lote.
  if lCasosFalhos > 0 then
    raise Exception.Create('Lote encerrado: ' + IntToStr(lTentados) + ' caso(s) executado(s), ' +
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
  FLogsCasoTeste.Text := FLogsPreparacao;
  try
    try
      {TDD_RUN_LOGS.}DelimitadorLog('PREPARAÇÃO DO CASO');
      // SetarCasoTeste reinicia o estado e usa o registro corrente do lote.
      SetarCasoTeste(FDescModulo,FDescArea);
      FNomeMetodoAtual := 'INICIALIZAR METRICAS';
      InicializarMetricasTickDiff;
      FNomeMetodoAtual := 'TOTAL';
      RegistrarTick(0,'TOTAL');

      try
        CallBack_AbreTela('Run');
        CallBack_AbreTela(ClassOwner);
        try
          {TDD_RUN_LOGS.}DelimitadorLog('STARTED');
          FNomeMetodoAtual := 'STARTED';
          RegistrarTick(0,'STARTED');
          {TDD_RUN_STARTED.}Started;
          RegistrarTick(1,'STARTED');

          {TDD_RUN_LOGS.}DelimitadorLog('IRUNNER');
          FNomeMetodoAtual := 'IRUNNER';
          RegistrarTick(0,'IRUNNER');

__CHAMADAS_METODOS__ // Identacao incorreta propositalmente!

          RegistrarTick(1,'IRUNNER');

          {TDD_RUN_LOGS.}DelimitadorLog('ASSERTS');
          FNomeMetodoAtual := 'ASSERTS';
          if FCDSMetricasTickDiff.FindKey(['IRUNNER']) then
            FTempoExecucaoMs := FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL').AsInteger;
          RegistrarTick(0,'ASSERTS');
          CompararResultadoEsperado;
          RegistrarTick(1,'ASSERTS');

          if AssertsOk then
            FHistoricoExecucao.StatusExecucao := 'SUCESSO'
          else
          begin
            FHistoricoExecucao.StatusExecucao := 'FALHA';
            FHistoricoExecucao.EtapaFalha := FEtapaAtual;
            FHistoricoExecucao.MensagemErro := 'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) +
              ', método ASSERTS: ' + AssertsResumo;
            RegistrarLog(FHistoricoExecucao.MensagemErro);
          end;
        except
          on Ex: Exception do
          begin
            FHistoricoExecucao.MensagemErro := 'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) +
              ', método ' + FNomeMetodoAtual + ': ' + Ex.Message;
            // O caso pode ter registrado a etapa da falha antes do tick de TEARDOWN.
            if (FNomeMetodoAtual = 'TEARDOWN') or (FHistoricoExecucao.EtapaFalha = 0) then
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
      // Persiste mesmo se preparação, ticks finais ou callbacks falharem.
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
