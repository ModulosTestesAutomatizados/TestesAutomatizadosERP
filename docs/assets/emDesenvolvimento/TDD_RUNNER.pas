uses TDD_ODBC, TDD_LOGS, TDD_STARTED, TDD_FINISHED;

const FQuantidadeTotalEtapas = 3;

type
  THistoricoExecucao = record
    AutoIncHistorico :integer; // PK
    AutoIncCasoTeste :integer; // FK
    VersaoExecucao   :string;
    RequisitoVersao  :string;
    StatusExecucao   :string;
    EtapaFalha       :integer;
    MensagemErro     :string;
    LogsFalhas       :string;
  end;

type
  TMetricasTickDiff     = record
    //AutoIncHistorico    :integer; // FK
    NomeMetodo          :string;
    EtapaCasoTeste      :integer;
    TempoInicio         :Cardinal;
    TempoFim            :Cardinal;
    TempoTotal          :Cardinal;
    TempoTotalFormatado :string;
  end;

type
  TMetricasAsserts    = record
    //AutoIncHistorico  :integer; // FK
    EtapaCasoTeste    :integer;
    TempoTotal        :Cardinal;
    AssertsTotal      :integer;
    AssertsAprovados  :integer;
    AssertsFalhos     :integer;
    ResultadoEsperado :string;
    ResultadoObtido   :string;
  end;

type
  TContextoCasoTeste = record
    Modulo        :string;
    Area          :string;
    CasoTesteDesc :string;
  end;

var
  // Para a persistência
  FHistoricoExecucao   :THistoricoExecucao;
  // Para as métricas
  FMetricasAsserts     :TMetricasAsserts;
  FCDSMetricasTickDiff :TClientDataSet;
  FNomeMetodoAtual     :string;
  FEtapaAtual          :integer;
  FContextoCasoTeste   :TContextoCasoTeste;

procedure Main;
begin
end;

procedure ConfigurarCasoTeste(pModulo, pArea, pCasoTesteDesc: string);
begin
  FContextoCasoTeste.Modulo        := pModulo;
  FContextoCasoTeste.Area          := pArea;
  FContextoCasoTeste.CasoTesteDesc := pCasoTesteDesc;
end;

{ ================================================================
  INICIALIZAÇÃO DE CDS PARA ARMAZENAR TICKS DE EXECUÇÕES
  Responsabilidade mantida no RUNNER para cronometrar o STARTED
  ================================================================ }
procedure InicializarMetricasTickDiff;
begin
  if Assigned(FCDSMetricasTickDiff) then
    FCDSMetricasTickDiff.Free;

  FCDSMetricasTickDiff := TClientDataSet.Create;
  FCDSMetricasTickDiff.FieldDefs.Add('NOME_METODO', ftString, 120, False);
  FCDSMetricasTickDiff.FieldDefs.Add('ETAPA_CASO_TESTE', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_INICIO', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_FIM', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_TOTAL', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_TOTAL_FORMATADO', ftString, 20, False);
  FCDSMetricasTickDiff.CreateDataSet;
  FCDSMetricasTickDiff.LogChanges := False;
end;

procedure LiberarMetricasTickDiff;
begin
  MostrarCDSEmModoDebug(FCDSMetricasTickDiff);
  if Assigned(FCDSMetricasTickDiff) then
  begin
    FCDSMetricasTickDiff.Free;
    FCDSMetricasTickDiff := nil;
  end;
end;

procedure Run(pSetupImp, pTesteImp: TProc);
begin
  // Inicializa para registrar todas as métricas até o FINISHED
  InicializarMetricasTickDiff;

  CallBack_AbreTela(ClassOwner);
  try
    try
      FNomeMetodoAtual := 'STARTED';
      FEtapaAtual      := 1;
      CronometrarExecucao(Started);

      FNomeMetodoAtual := 'SETUP';
      FEtapaAtual      := 2;
      CronometrarExecucao(pSetupImp);

      FNomeMetodoAtual := 'EXECUÇÃO';
      FEtapaAtual      := 3;
      CronometrarExecucao(pTesteImp);

      FHistoricoExecucao.StatusExecucao := 'SUCESSO';
    except
      on Ex: Exception do
      begin
        FHistoricoExecucao.MensagemErro := Ex.Message;
        if FHistoricoExecucao.StatusExecucao <> 'INCOMPATIVEL_VERSAO' then
          FHistoricoExecucao.StatusExecucao := 'FALHA';
        raise;
      end;
    end;
  finally
    try
      {TDD_FINISHED.}RegistrarMetricas;
    except
      on Ex: Exception do
        MostrarLogTextoEmModoDebug('Falha ao persistir metricas: ' + Ex.Message);
    end;
    LiberarMetricasTickDiff;
    CallBack_FechaTela(ClassOwner);
  end;
end;

{$region 'Cronômetro'}
function PreencherComZeros(pValor: Cardinal; pTamanho: Integer): String;
begin
  Result := IntToStr(pValor);
  while Length(Result) < pTamanho do
    Result := '0' + Result;
end;

function FormatarTickDiff(pTempoMs: Cardinal): String;
var lHoras, lMinutos, lSegundos, lMilissegundos: Cardinal;
begin
  lHoras         := pTempoMs div 3600000;
  pTempoMs       := pTempoMs mod 3600000;
  lMinutos       := pTempoMs div 60000;
  pTempoMs       := pTempoMs mod 60000;
  lSegundos      := pTempoMs div 1000;
  lMilissegundos := pTempoMs mod 1000;

  Result := PreencherComZeros(lHoras, 2) + ':' +
    PreencherComZeros(lMinutos, 2)       + ':' +
    PreencherComZeros(lSegundos, 2)      + ':' +
    PreencherComZeros(lMilissegundos, 3);
end;

function RegistrarTickDiff(pTempoInicio, pTempoFim: Cardinal): OleVariant;
var lTempoTotal: Cardinal;
begin
  lTempoTotal := TickDiff(pTempoInicio, pTempoFim);

  FCDSMetricasTickDiff.Insert;
  FCDSMetricasTickDiff.FieldByName('NOME_METODO').AsString := FNomeMetodoAtual;
  FCDSMetricasTickDiff.FieldByName('ETAPA_CASO_TESTE').AsInteger := FEtapaAtual;
  FCDSMetricasTickDiff.FieldByName('TEMPO_INICIO').AsInteger := pTempoInicio;
  FCDSMetricasTickDiff.FieldByName('TEMPO_FIM').AsInteger := pTempoFim;
  FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL').AsInteger := lTempoTotal;
  FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL_FORMATADO').AsString := FormatarTickDiff(lTempoTotal);
  FCDSMetricasTickDiff.Post;

  Result := FormatarTickDiff(lTempoTotal);
end;

procedure FeedBackExecucao(pClassCallBackTela, pMensagem :string);
begin
  CallBack_Incremento(pClassCallBackTela, FEtapaAtual, FQuantidadeTotalEtapas, pMensagem);
  LogDoProcessamentoAdd(pMensagem);
end;

function CronometrarExecucao(pMetodoExecutar: TProc) :OleVariant;
var
  lInicio, lFim                     :Cardinal;
  lClassCallBackTela, lMensagemTemp :string;
begin
  lInicio            := GetTickCount;
  lClassCallBackTela := 'Cronômetro';
  lMensagemTemp      := '';

  CallBack_AbreTela(lClassCallBackTela);
  try
    lMensagemTemp := 'Iniciando processo ' + FNomeMetodoAtual + ' - ' + IntToStr(FEtapaAtual) + '.';
    FeedBackExecucao(lClassCallBackTela, lMensagemTemp);

    try
      if Assigned(pMetodoExecutar) then
      begin
        try
          lMensagemTemp := 'Executando processo ' + FNomeMetodoAtual + ' - ' + IntToStr(FEtapaAtual) + '.';
          FeedBackExecucao(lClassCallBackTela, lMensagemTemp);
          pMetodoExecutar;
        except on ex: Exception do
          begin
            lMensagemTemp := 'Falha ao executar o processo ' + FNomeMetodoAtual + ' - ' + IntToStr(FEtapaAtual) + '.';
            FHistoricoExecucao.EtapaFalha     := FEtapaAtual;
            FHistoricoExecucao.StatusExecucao := 'FALHA';
            FeedBackExecucao(lClassCallBackTela, lMensagemTemp);
            raise Exception.Create(lMensagemTemp + ' ' + ex.Message);
          end;
        end;
      end;
    finally
      lFim   := GetTickCount;
      Result := RegistrarTickDiff(lInicio, lFim);
    end;
  finally
    CallBack_FechaTela(lClassCallBackTela);
  end;
end;

{$endregion}
