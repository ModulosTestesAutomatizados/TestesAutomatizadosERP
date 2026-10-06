

uses TDD_RUNNER,__USES_UNITS__;

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
      LogDoProcessamentoAdd('LOTE: carregados=' + IntToStr(CDSCasosTestes.RecordCount) +
        '; tentados=' + IntToStr(lTentados) + '; nao tentados=' + IntToStr(CDSCasosTestes.RecordCount - lTentados));
    end;
  finally
    // Os metodos existentes cuidam da limpeza, mesmo se outro encerramento falhar.
    try
      LiberarMetricasTickDiff;
    finally
      try
        TearDown_FinalizarParametros;
      finally
        try
          Cache_TearDown_LimparInformacoes;
        finally
          TearDown_Finalizar_CasosTeste;
        end;
      end;
    end;
  end;
end;

{$region Execucao individual}
procedure Run;
var lInicioLog :integer;
begin
  lInicioLog := Length(LogDoProcessamento);
  try
    InicializarMetricasTickDiff;
    RegistrarTick(0,'TOTAL');
    // SetarCasoTeste reinicia o estado e usa o registro corrente do lote.
    SetarCasoTeste(FDescModulo,FDescArea,CDSCasosTestes.FieldByName('DESCRICAO').AsString);

    try
      CallBack_AbreTela('Run');
      CallBack_AbreTela(ClassOwner);
      try
        try
          FNomeMetodoAtual := 'STARTED';
          RegistrarTick(0,'STARTED');
          {TDD_STARTED.}Started;
          RegistrarTick(1,'STARTED');

          FNomeMetodoAtual := 'IRUNNER';
          RegistrarTick(0,'IRUNNER');
__CHAMADAS_METODOS__ // Identacao incorreta propositalmente!
          RegistrarTick(1,'IRUNNER');

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
            LogDoProcessamentoAdd(FHistoricoExecucao.MensagemErro);

            // Falhas do teste e incompatibilidade ficam no historico; preparacao interrompe.
            if (FNomeMetodoAtual = 'STARTED') and
               (FHistoricoExecucao.StatusExecucao <> 'VERSAO_INCOMPATIVEL') then
              raise;
          end;
        end;
      finally
        // Fecha os tempos em aberto, inclusive quando o caso falha.
        FCDSMetricasTickDiff.First;
        while not FCDSMetricasTickDiff.Eof do
        begin
          if FCDSMetricasTickDiff.FieldByName('TEMPO_FIM').AsInteger = 0 then
            RegistrarTick(1,FCDSMetricasTickDiff.FieldByName('NOME_METODO').AsString);
          FCDSMetricasTickDiff.Next;
        end;
        FHistoricoExecucao.LogsFalhas := Copy(LogDoProcessamento,lInicioLog + 1,Length(LogDoProcessamento));
        FNomeMetodoAtual := 'FINISHED';
        {TDD_FINISHED.}RegistrarMetricas;
      end;
    finally
      try
        CallBack_FechaTela(ClassOwner);
      finally
        CallBack_FechaTela('Run');
      end;
    end;
    // As metricas ficam disponiveis ate a proxima inicializacao ou limpeza do lote.
  except
    on Ex: Exception do
      raise Exception.Create(MensagemPersonalizada + #13 +
        'Falha no caso ID ' + IntToStr(FHistoricoExecucao.AutoIncCasoTeste) +
        ', metodo ' + FNomeMetodoAtual + ': ' + Ex.Message);
  end;
end;
{$endregion}
