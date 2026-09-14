uses TDD_ODBC;

type
  THistoricoExecucao = record
    AutoIncHistorico :integer; // PK
    AutoIncCasoTeste :integer; // FK
    VersaoExecucao   :string;
    RequisitoVersao  :string;
    StatusExecucao   :string;
    EtapaFalha       :integer;
    MensagemErro:    :string;
    LogsFalhas       :string;
    DataHoraExecucao :string;
  end;

type
  TMetricasTickDiff  = record
    AutoIncHistorico :integer; // FK
    NomeMetodo       :integer;
    EtapaCasoTeste   :integer;
    TempoInicio      :Cardinal;
    TempoFim         :Cardinal;
    TempoTotal       :Cardinal;
  end;

type
  TMetricasAsserts     = record
    AutoIncHistorico   :integer; // FK
    EtapaCasoTeste     :integer;
    TempoTotal         :Cardinal;
    AssertsTotal       :integer;
    AssertsAprovados   :integer;
    AssertsFalhos      :integer;
    ResultadoEsperado  :string;
    ResultadoObtido    :string;
  end;

var
  // Para a persistência
  FHistoricoExecucao :THistoricoExecucao;
  // Para as métricas
  FMetricasAsserts   :TMetricasAsserts;
  FMetricasTickDiff  :TMetricasTickDiff;
  // Para o cronômetro
  FInicio, FFim      :Cardinal;
  FTickDiffs         :Cardinal;

procedure Main;
begin

end;

function Run();
var
  Results := Olevariant;
begin
  CronometrarExecucao(Etapas, Results);
end;

function Etapas(const Results := Olevariant);
begin
  CronometrarExecucao(SetupTeste, Results);
  CronometrarExecucao(ExecutarTeste, Results);
end;

procedure SetupTeste(pMetodoSetupImplementacao :TProc);
begin
  if Assigned(pMetodoSetupImplementacao) then
    pMetodoSetupImplementacao
  else
    begin
      // Implementação genérica.
      try
        // Setar a etapa!
      finally
        // Setar o tratamento!
      end;
    end;
  end;
end;

procedure ExecutarTeste(pMetodoTesteImplementacao :TProc);
begin
  if Assigned(pMetodoTesteImplementacao) then
    pMetodoTesteImplementacao
  else
    begin
      // Implementação genérica.
      try
        // Setar a etapa!
      finally
        // Setar o tratamento!
      end;
    end;
  end;
end;

{$region 'Cronômetro'}
function CronometrarExecucao(pMetodoExecutar :TProc; const pResultMetodo :Olevariant) :Cardinal;
begin
  FInicio := GetTickCount;
  
  try
    pResultMetodo := pMetodoExecutar;
  except
  
  FFim := GetTickCount;
  
  Result := TickDiff(FInicio, FFim);  
end;
{$endregion}

{$region 'Persistência'}
procedure RegistrarMetricas;
var
  lSQL                 :string;
  lCodigoAutoIncGerado :integer;
begin
  lSQL                                := '';
  FHistoricoExecucao.AutoIncCasoTeste := 0;
  FHistoricoExecucao.AutoIncHistorico := 0;

  // Insert do histórico
  lSQL := '';
  TDDCommandODBCP(lSQL, [
    FHistoricoExecucao.AutoIncCasoTeste,
    FHistoricoExecucao.VersaoExecucao,
    FHistoricoExecucao.RequisitoVersao,
    FHistoricoExecucao.StatusExecucao,
    FHistoricoExecucao.EtapaFalha,
    FHistoricoExecucao.MensagemErro,
    FHistoricoExecucao.LogsFalhas,
    FHistoricoExecucao.DataHoraExecucao
  ]);

  lSQL := '';
  FHistoricoExecucao.AutoIncHistorico := TDDScalarODBCP(lSQL, [

  ]);

  // Atribuindo o ID gerado em caso de precisar de novas manipulações futuramente.
  FMetricasAsserts.AutoIncHistorico := FHistoricoExecucao.AutoIncHistorico;
  FMetricasTickDiff.AutoIncHistorico := FHistoricoExecucao.AutoIncHistorico;

  lSQL := '';
  TDDCommandODBCP(lSQL, [
    FMetricasAsserts.AutoIncHistorico,
    FMetricasAsserts.EtapaCasoTeste,
    FMetricasAsserts.TempoTotal,
    FMetricasAsserts.AssertsTotal,
    FMetricasAsserts.AssertsAprovados,
    FMetricasAsserts.AssertsFalhos,
    FMetricasAsserts.ResultadoEsperado,
    FMetricasAsserts.ResultadoObtido
  ]);

  lSQL := '';
  TDDCommandODBCP(lSQL, [
    FMetricasTickDiff.AutoIncHistorico,
    FMetricasTickDiff.NomeMetodo,
    FMetricasTickDiff.EtapaCasoTeste,
    FMetricasTickDiff.TempoInicio,
    FMetricasTickDiff.TempoFim,
    FMetricasTickDiff.TempoTotal
  ]);
end;
{$endregion}
