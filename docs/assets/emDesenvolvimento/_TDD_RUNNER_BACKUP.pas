uses TDD_ODBC;

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

var
  // Para a persistência
  FHistoricoExecucao :THistoricoExecucao;
  // Para as métricas
  FMetricasAsserts   :TMetricasAsserts;
  FCDSMetricasTickDiff :TClientDataSet;
  FNomeMetodoAtual   :string;
  FEtapaAtual        :integer;

procedure Main;
begin

end;

function ProximoSegmentoVersao(pVersao: String; var pPosicao: Integer): Integer;
var
  lInicio: Integer;
begin
  while (pPosicao <= Length(pVersao)) and (Copy(pVersao, pPosicao, 1) = '.') do
    pPosicao := pPosicao + 1;

  lInicio := pPosicao;
  while (pPosicao <= Length(pVersao)) and (Copy(pVersao, pPosicao, 1) <> '.') do
    pPosicao := pPosicao + 1;

  Result := StrToIntDef(Copy(pVersao, lInicio, pPosicao - lInicio), 0);
end;

function RequisitoVersaoAtendido(pRequisitoVersao, pVersaoExecucao: String): Boolean;
var
  lPosicaoRequisito, lPosicaoExecucao: Integer;
  lSegmentoRequisito, lSegmentoExecucao: Integer;
begin
  if Trim(pRequisitoVersao) = '' then
  begin
    Result := True;
    Exit;
  end;

  // A versao 0 representa o ambiente de desenvolvimento e nao possui restricao.
  if Trim(pVersaoExecucao) = '0' then
  begin
    Result := True;
    Exit;
  end;

  lPosicaoRequisito := 1;
  lPosicaoExecucao := 1;
  while (lPosicaoRequisito <= Length(pRequisitoVersao)) or
        (lPosicaoExecucao <= Length(pVersaoExecucao)) do
  begin
    lSegmentoRequisito := ProximoSegmentoVersao(pRequisitoVersao, lPosicaoRequisito);
    lSegmentoExecucao := ProximoSegmentoVersao(pVersaoExecucao, lPosicaoExecucao);

    if lSegmentoExecucao > lSegmentoRequisito then
    begin
      Result := True;
      Exit;
    end;

    if lSegmentoExecucao < lSegmentoRequisito then
    begin
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;

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
  if Assigned(FCDSMetricasTickDiff) then
  begin
    FCDSMetricasTickDiff.Free;
    FCDSMetricasTickDiff := nil;
  end;
end;

procedure Run(pSetupImp, pTesteImp: TProc);
begin
  FHistoricoExecucao.VersaoExecucao := VersaoSistemaCodigo;
  InicializarMetricasTickDiff;

  try
    if not RequisitoVersaoAtendido(
      FHistoricoExecucao.RequisitoVersao,
      FHistoricoExecucao.VersaoExecucao
    ) then
    begin
      FHistoricoExecucao.StatusExecucao := 'INCOMPATIVEL_VERSAO';
      FHistoricoExecucao.EtapaFalha := 0;
      raise Exception.Create('Requisito de versao nao atendido.');
    end;

    FNomeMetodoAtual := 'SetupTeste';
    FEtapaAtual := 1;
    CronometrarExecucao(SetupTeste(pSetupImp));

    FNomeMetodoAtual := 'ExecutarTeste';
    FEtapaAtual := 2;
    CronometrarExecucao(ExecutarTeste(pTesteImp));

    FHistoricoExecucao.StatusExecucao := 'SUCESSO';
  except
    on Ex: Exception do
    begin
      FHistoricoExecucao.MensagemErro := Ex.Message;
      if FHistoricoExecucao.StatusExecucao <> 'INCOMPATIVEL_VERSAO' then
        FHistoricoExecucao.StatusExecucao := 'FALHA';
      raise;
    end;
  finally
    try
      RegistrarMetricas;
    except
      on Ex: Exception do
        MostrarLogTexto('Falha ao persistir metricas: ' + Ex.Message, 'TDD_RUNNER');
    end;
    LiberarMetricasTickDiff;
  end;
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
    PreencherComZeros(lMinutos, 2) + ':' +
    PreencherComZeros(lSegundos, 2) + ':' +
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

function CronometrarExecucao(pMetodoExecutar: TProc): OleVariant;
var lInicio, lFim: Cardinal;
begin
  lInicio := GetTickCount;
  try
    if Assigned(pMetodoExecutar) then
      pMetodoExecutar;
  finally
    lFim := GetTickCount;
    Result := RegistrarTickDiff(lInicio, lFim);
  end;
end;

function CronometrarExecucaoRetorno(pMetodoExecutar: TProc; var pResult: OleVariant): OleVariant;
var lInicio, lFim: Cardinal;
begin
  lInicio := GetTickCount;
  try
    if Assigned(pMetodoExecutar) then
      pResult := pMetodoExecutar;
  finally
    lFim := GetTickCount;
    Result := RegistrarTickDiff(lInicio, lFim);
  end;
end;
{$endregion}

{$region 'Persistência'}
procedure RegistrarMetricas;
var lSQL :string;
begin
  lSQL := 'INSERT INTO HISTORICO_EXECUCAO_TESTE ('                + #13 +
    '  AUTOINC_CASO_TESTE,'                                       + #13 +
    '  VERSAO_EXECUCAO,'                                          + #13 +
    '  REQUISITO_VERSAO,'                                         + #13 +
    '  STATUS_EXECUCAO,'                                          + #13 +
    '  ETAPA_FALHA,'                                              + #13 +
    '  MENSAGEM_ERRO,'                                            + #13 +
    '  LOGS_FALHAS'                                               + #13 +
    ') VALUES ('                                                  + #13 +
    '  :AutoIncCasoTeste,'                                        + #13 +
    '  :VersaoExecucao,'                                          + #13 +
    '  :RequisitoVersao,'                                         + #13 +
    '  :StatusExecucao,'                                          + #13 +
    '  :EtapaFalha,'                                              + #13 +
    '  :MensagemErro,'                                            + #13 +
    '  :LogsFalhas'                                               + #13 +
    ') RETURNING AUTOINC_HISTORICO';

  FHistoricoExecucao.AutoIncHistorico := TDDScalarODBCP(lSQL, [
    FHistoricoExecucao.AutoIncCasoTeste,
    FHistoricoExecucao.VersaoExecucao,
    FHistoricoExecucao.RequisitoVersao,
    FHistoricoExecucao.StatusExecucao,
    FHistoricoExecucao.EtapaFalha,
    FHistoricoExecucao.MensagemErro,
    FHistoricoExecucao.LogsFalhas
  ]);

  lSQL := 'INSERT INTO METRICAS_ASSERTS ('  + #13 +
    '  AUTOINC_HISTORICO,'                  + #13 +
    '  ETAPA_CASO_TESTE,'                   + #13 +
    '  TEMPO_TOTAL,'                        + #13 +
    '  ASSERTS_TOTAL,'                      + #13 +
    '  ASSERTS_APROVADOS,'                  + #13 +
    '  ASSERTS_FALHOS,'                     + #13 +
    '  RESULTADO_ESPERADO,'                 + #13 +
    '  RESULTADO_OBTIDO'                    + #13 +
    ') VALUES ('                            + #13 +
    '  :AutoIncHistorico,'                  + #13 +
    '  :EtapaCasoTeste,'                    + #13 +
    '  :TempoTotal,'                        + #13 +
    '  :AssertsTotal,'                      + #13 +
    '  :AssertsAprovados,'                  + #13 +
    '  :AssertsFalhos,'                     + #13 +
    '  :ResultadoEsperado,'                 + #13 +
    '  :ResultadoObtido'                    + #13 +
    ')';

  TDDCommandODBCP(lSQL, [
    FHistoricoExecucao.AutoIncHistorico,
    FMetricasAsserts.EtapaCasoTeste,
    FMetricasAsserts.TempoTotal,
    FMetricasAsserts.AssertsTotal,
    FMetricasAsserts.AssertsAprovados,
    FMetricasAsserts.AssertsFalhos,
    FMetricasAsserts.ResultadoEsperado,
    FMetricasAsserts.ResultadoObtido
  ]);

  lSQL := 'INSERT INTO METRICAS_TICK_DIFF ('  + #13 +
    '  AUTOINC_HISTORICO,'                    + #13 +
    '  NOME_METODO,'                          + #13 +
    '  ETAPA_CASO_TESTE,'                     + #13 +
    '  TEMPO_INICIO,'                         + #13 +
    '  TEMPO_FIM,'                            + #13 +
    '  TEMPO_TOTAL,'                          + #13 +
    '  TEMPO_TOTAL_FORMATADO'                 + #13 +
    ') VALUES ('                              + #13 +
    '  :AutoIncHistorico,'                    + #13 +
    '  :NomeMetodo,'                          + #13 +
    '  :EtapaCasoTeste,'                      + #13 +
    '  :TempoInicio,'                         + #13 +
    '  :TempoFim,'                            + #13 +
    '  :TempoTotal,'                          + #13 +
    '  :TempoTotalFormatado'                  + #13 +
    ')';

  if Assigned(FCDSMetricasTickDiff) then
  begin
    FCDSMetricasTickDiff.First;
    while not FCDSMetricasTickDiff.Eof do
    begin
      TDDCommandODBCP(lSQL, [
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
end;
{$endregion}
