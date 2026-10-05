

uses TDD_RUNNER,__USES_UNITS__;

procedure Main;
begin
  Run(__PARAMETROS_CASO_TESTE__);
end;

{$region Execução}
procedure Run(pDescricaoModulo,pDescricaoArea,pDescricaoCasoTeste :string);
begin
  try
    try
      // Inicializa para registrar todas as métricas até o ASSERTS.
      {P39_TDD_RUNNER}InicializarMetricasTickDiff;

      // Ponto de entrada deve sempre ser o run,assim o cronometro é capaz rastrear o tempo total corretamente.
      {P39_TDD_RUNNER.}RegistrarTick(0,'TOTAL');

      CallBack_AbreTela('Run');
      CallBack_AbreTela(ClassOwner);

      try
        {P39_TDD_RUNNER.}SetarCasoTeste(pDescricaoModulo,pDescricaoArea,pDescricaoCasoTeste);

        {P39_TDD_RUNNER.}FNomeMetodoAtual := 'STARTED';
        {P39_TDD_RUNNER.}RegistrarTick(0,FNomeMetodoAtual);
        {P39_TDD_STARTED.}Started;
        {P39_TDD_RUNNER.}RegistrarTick(1,FNomeMetodoAtual);

        FNomeMetodoAtual := 'IRUNNER';
        RegistrarTick(0,FNomeMetodoAtual);
__CHAMADAS_METODOS__ // Identação incorreta propositalmente!
        RegistrarTick(1,FNomeMetodoAtual);

        FNomeMetodoAtual := 'ASSERTS';
        RegistrarTick(0,FNomeMetodoAtual);
        //{P39_TDD_ASSERTS.} //PENDENTE O USE CASE DE ASSERTS;
        RegistrarTick(1,FNomeMetodoAtual);

        {P39_TDD_RUNNER.}FHistoricoExecucao.StatusExecucao := 'SUCESSO';
      except
        on Ex: Exception do
        begin
          FHistoricoExecucao.MensagemErro := Ex.Message;
          FHistoricoExecucao.EtapaFalha   := FEtapaAtual;

          if FHistoricoExecucao.StatusExecucao <> 'VERSAO_INCOMPATIVEL' then
            FHistoricoExecucao.StatusExecucao := 'FALHA';

          raise exception.Create(MensagemPersonalizada + Ex.Message);
        end;
      end;
    finally
      try
        RegistrarTick(1,'TOTAL');
        FHistoricoExecucao.LogsFalhas := LogDoProcessamento;
        {P39_TDD_FINISHED.}RegistrarMetricas;
      except
        on Ex: Exception do
          raise Exception.Create('Falha ao persistir metricas: ' + Ex.Message);
      end;
      CallBack_FechaTela(ClassOwner);
      CallBack_FechaTela('Run');
      {P39_TDD_RUNNER.}LiberarMetricasTickDiff;
    end;
  except
    on ex: Exception do
      raise Exception.Create(MensagemPersonalizada + #13 + ex.Message);
  end;
end;
{$endregion}
