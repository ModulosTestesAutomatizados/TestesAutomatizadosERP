

uses TDD_RUNNER,__USES_UNITS__;

{ ================================================================
  TDD_BASE_UNIT_IRUNNER - MOLDE DO FLUXO INTERPRETADO
  Main chama ExecutarLote com o módulo e a área configurados.
  ExecutarLote carrega uma vez, controla First/Run/Next e libera o lote.
  Run prepara o caso corrente, executa Started/Teste, mantém ASSERTS
  reservado e persiste histórico e tempos individuais.
  FLogsCasoTeste é limpa por tentativa; somente o debug registra texto.
  Marcadores de uses, parâmetros e Teste são preenchidos por IRunner.
  Esta unit é um molde e não deve ser executada isoladamente.
  ================================================================ }

procedure Main;
begin
  ExecutarLote(__PARAMETROS_CASO_TESTE__);
end;

procedure ExecutarLote(pDescricaoModulo,pDescricaoArea :string);
var lTentados :integer;
begin
  lTentados := 0;
  try
    // A carga pertence ao lote; somente este loop avanca o CDS global.
    {TDD_RUNNER.}SetupCasosTestes(pDescricaoModulo,pDescricaoArea);
    try
      CDSCasosTestes.First;
      while not CDSCasosTestes.Eof do
      begin
        lTentados := lTentados + 1;
        Run;
        CDSCasosTestes.Next;
      end;
    finally
      {TDD_LOGS.}DelimitadorLog('RESUMO DO LOTE');
      {TDD_LOGS.}RegistrarLogEmModoDebug(
        '| Carregados: ' + IntToStr(CDSCasosTestes.RecordCount) + #13 +
        '| Tentados:   ' + IntToStr(lTentados)
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
end;

{$region Execucao individual}
procedure Run;
begin
  if not Assigned(FLogsCasoTeste) then
    FLogsCasoTeste := TStringList.Create;
  FLogsCasoTeste.Clear;
  try
    try
      {TDD_LOGS.}DelimitadorLog('PREPARAÇÃO DO CASO');
      // SetarCasoTeste reinicia o estado e usa o registro corrente do lote.
      SetarCasoTeste(FDescModulo,FDescArea,CDSCasosTestes.FieldByName('DESCRICAO').AsString);
      InicializarMetricasTickDiff;
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
                ', metodo ' + FNomeMetodoAtual + ': ' + Ex.Message;
              FHistoricoExecucao.EtapaFalha := FEtapaAtual;
              if FHistoricoExecucao.StatusExecucao <> 'VERSAO_INCOMPATIVEL' then
                FHistoricoExecucao.StatusExecucao := 'FALHA';
              {TDD_LOGS.}RegistrarLogEmModoDebug(FHistoricoExecucao.MensagemErro);

              // Falhas do teste ficam no historico; preparacao/limpeza insegura interrompe.
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
          {TDD_LOGS.}DelimitadorLog('FINISHED');
          FHistoricoExecucao.LogsProcessamento := {TDD_LOGS.}FLogsCasoTeste.Text;
          FNomeMetodoAtual                     := 'FINISHED';
          {TDD_FINISHED.}RegistrarMetricas;
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
        raise Exception.Create(MensagemPersonalizada                          + #13 +
          'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) + #13 +
          'Método: ' + FNomeMetodoAtual + ': '                                + #13 +
          Ex.Message
        );
    end;
  finally
    FLogsCasoTeste.Clear;
  end;
end;
{$endregion}
