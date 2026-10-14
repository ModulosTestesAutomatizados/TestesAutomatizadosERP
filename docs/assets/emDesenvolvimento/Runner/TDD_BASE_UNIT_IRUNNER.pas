

uses TDD_RUNNER,__USES_UNITS__;

{ ================================================================
  TDD_BASE_UNIT_IRUNNER - MOLDE DO FLUXO INTERPRETADO
  Main chama ExecutarLote com o módulo e a área configurados.
  ExecutarLote carrega uma vez, controla First/Run/Next e libera o lote.
  Falhas individuais são acumuladas e apresentadas depois do encerramento.
  Main concentra o único prefixo MensagemPersonalizada deste fluxo.
  Run prepara o caso corrente, executa Started/Teste, mantém ASSERTS
  reservado e persiste histórico e tempos individuais.
  FLogsCasoTeste registra todas as mensagens e é limpa após tentar persistir.
  Marcadores de uses, parâmetros e Teste são preenchidos por IRunner.
  Esta unit é um molde e não deve ser executada isoladamente.
  ================================================================ }

procedure Main;
begin
  try
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
    {TDD_RUNNER.}SetupCasosTestes(pDescricaoModulo,pDescricaoArea);
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
      {TDD_LOGS.}DelimitadorLog('RESUMO DO LOTE');
      {TDD_LOGS.}RegistrarLogEmModoDebug(
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
var lMetodoAntesFinished, lErroDaExecucao, lErroPersistencia :string;
begin
  lErroDaExecucao := '';
  // Não reutiliza o ID da tentativa anterior se a preparação falhar.
  FHistoricoExecucao.AutoIncCasoTeste := 0;
  FHistoricoExecucao.AutoIncHistorico := 0;
  FHistoricoExecucao.StatusExecucao := '';
  FHistoricoExecucao.MensagemErro := '';
  FHistoricoExecucao.LogsProcessamento := '';
  FEtapaAtual := 0;
  FNomeMetodoAtual := 'PREPARAÇÃO DO CASO';
  if not Assigned(FLogsCasoTeste) then
    FLogsCasoTeste := TStringList.Create;
  FLogsCasoTeste.Clear;
  try
    try
      {TDD_LOGS.}DelimitadorLog('PREPARAÇÃO DO CASO');
      // SetarCasoTeste reinicia o estado e usa o registro corrente do lote.
      SetarCasoTeste(FDescModulo,FDescArea,CDSCasosTestes.FieldByName('DESCRICAO').AsString);
      FNomeMetodoAtual := 'INICIALIZAR METRICAS';
      InicializarMetricasTickDiff;
      FNomeMetodoAtual := 'TOTAL';
      RegistrarTick(0,'TOTAL');

      try
        CallBack_AbreTela('Run');
        CallBack_AbreTela(ClassOwner);
        try
          try
            {TDD_LOGS.}DelimitadorLog('STARTED');
            FNomeMetodoAtual := 'STARTED';
            RegistrarTick(0,'STARTED');
            {TDD_STARTED.}Started;
            RegistrarTick(1,'STARTED');

            {TDD_LOGS.}DelimitadorLog('IRUNNER');
            FNomeMetodoAtual := 'IRUNNER';
            RegistrarTick(0,'IRUNNER');

__CHAMADAS_METODOS__ // Identacao incorreta propositalmente!

            RegistrarTick(1,'IRUNNER');

            {TDD_LOGS.}DelimitadorLog('ASSERTS');
            FNomeMetodoAtual := 'ASSERTS';
            RegistrarTick(0,'ASSERTS');
            //{P39_TDD_ASSERTS.} //PENDENTE O USE CASE DE ASSERTS;
            RegistrarTick(1,'ASSERTS');

            FHistoricoExecucao.StatusExecucao := 'SUCESSO';
          except
            on Ex: Exception do
            begin
              FHistoricoExecucao.MensagemErro := 'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) +
                ', método ' + FNomeMetodoAtual + ': ' + Ex.Message;
              FHistoricoExecucao.EtapaFalha := FEtapaAtual;
              if FHistoricoExecucao.StatusExecucao <> 'VERSAO_INCOMPATIVEL' then
                FHistoricoExecucao.StatusExecucao := 'FALHA';
              {TDD_LOGS.}RegistrarLogEmModoDebug(FHistoricoExecucao.MensagemErro);

              // Falhas do teste ficam no histórico; preparação/limpeza insegura interrompe.
              if (FNomeMetodoAtual = 'TEARDOWN') or
                 ((FNomeMetodoAtual = 'STARTED') and
                  (FHistoricoExecucao.StatusExecucao <> 'VERSAO_INCOMPATIVEL')) then
                raise;
            end;
          end;
        finally
          {TDD_LOGS.}DelimitadorLog('ENCERRAMENTO DOS TEMPOS');
          // Fecha os tempos em aberto, inclusive quando o caso falha.
          FCDSMetricasTickDiff.First;
          while not FCDSMetricasTickDiff.Eof do
          begin
            if FCDSMetricasTickDiff.FieldByName('TEMPO_FIM').AsInteger = 0 then
              RegistrarTick(1,FCDSMetricasTickDiff.FieldByName('NOME_METODO').AsString);
            FCDSMetricasTickDiff.Next;
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
        {TDD_LOGS.}RegistrarLogEmModoDebug(lErroDaExecucao);
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
        {TDD_LOGS.}DelimitadorLog('FINISHED');
        lMetodoAntesFinished := FNomeMetodoAtual;
        FNomeMetodoAtual := 'FINISHED';
        try
          {TDD_FINISHED.}RegistrarMetricas;
        except
          on Ex: Exception do
          begin
            lErroPersistencia := 'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) +
              ', método FINISHED: ' + Ex.Message;
            {TDD_LOGS.}RegistrarLogEmModoDebug(lErroPersistencia);
            // Mantém a cópia em memória quando o banco não consegue recebê-la.
            FHistoricoExecucao.LogsProcessamento := FLogsCasoTeste.Text;
            if lErroDaExecucao <> '' then
              raise Exception.Create(lErroDaExecucao + #13 + lErroPersistencia);
            if Trim(FHistoricoExecucao.MensagemErro) <> '' then
              raise Exception.Create(FHistoricoExecucao.MensagemErro + #13 + lErroPersistencia);
            raise Exception.Create(lErroPersistencia);
          end;
        end;
        FNomeMetodoAtual := lMetodoAntesFinished;
      end;
    finally
      FLogsCasoTeste.Clear;
    end;
  end;
end;
{$endregion}
