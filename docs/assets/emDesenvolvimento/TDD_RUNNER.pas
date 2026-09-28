uses TDD_IRUNNER, TDD_ODBC, TDD_LOGS, TDD_STARTED, TDD_FINISHED;

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
  TContextoCasoTeste   = record
    DescricaoModulo    :string;
    DescricaoArea      :string;
    DescricaoCasoTeste :string;
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
var lInstrucoes :string;
begin
  lInstrucoes := '';
  {TDD_LOGS.}MostrarInstrucoesUnit('TDD_RUNNER', lInstrucoes);
end;

{ ================================================================
  INICIALIZAÇÃO DE CDS PARA ARMAZENAR TICKS DE EXECUÇÕES
  Responsabilidade mantida no RUNNER para cronometrar o STARTED
  ================================================================ }
{$region CDS Métricas}
procedure LiberarMetricasTickDiff;
begin
  if Assigned(FCDSMetricasTickDiff) then
    FCDSMetricasTickDiff.Free;
end;

procedure InicializarMetricasTickDiff;
begin
  LiberarMetricasTickDiff;
  FEtapaAtual := 0;

  FCDSMetricasTickDiff := TClientDataSet.Create;
  FCDSMetricasTickDiff.FieldDefs.Add('NOME_METODO', ftString, 120, False);
  FCDSMetricasTickDiff.FieldDefs.Add('ETAPA_CASO_TESTE', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_INICIO', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_FIM', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_TOTAL', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_TOTAL_FORMATADO', ftString, 20, False);
  FCDSMetricasTickDiff.CreateDataSet;
  FCDSMetricasTickDiff.LogChanges      := False;
  FCDSMetricasTickDiff.IndexFieldNames := 'NOME_METODO; ETAPA_CASO_TESTE';
end;
{$endregion}

{$region 'Cronômetro'}
{ ================================================================
  CRONÔMETRO PARA MÉTRICAS DE TEMPO DAS EXECUÇÕES NOS TESTES
  Formatação e registro de marcadores Início e Fim por execução
  ================================================================ }
function PreencherComZeros(pValor :Cardinal; pTamanho :Integer) :string;
begin
  Result := IntToStr(pValor);
  while Length(Result) < pTamanho do
    Result := '0' + Result;
end;

function FormatarTickDiff(pTempoMs :Cardinal) :string;
var lHoras, lMinutos, lSegundos, lMilissegundos :Cardinal;
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

procedure RegistrarTick(pPontoTick :integer; pNomeMetodo :string);
var
  lTempoTick, lTempoTotal :Cardinal;
  lPontoTick              :string;
  lVerificaFindKey        :Boolean;
begin
  // O registro de início e fim, não aplica formatação para permitir o uso de TickDiff.
  lTempoTick := GetTickCount;

  {TDD_LOGS.}MostrarLogTextoEmModoDebugT(Assigned(FCDSMetricasTickDiff), 'CDS Métricas já está assinado?');
  {TDD_LOGS.}MostrarCDSEmModoDebug(FCDSMetricasTickDiff);
  
  // Camada de decisão entre registrar início ou fim, "0" = Início, "1" = Fim.
  case pPontoTick of
    0:
      begin
        lPontoTick  := 'Início';

        // Validação correta: Se o FindKey achou, é porque a etapa já existe!
        if lVerificaFindKey then
          raise Exception.Create('A etapa atual já possui registro de início, impossível registrar Tick da execução para: Etapa ' + IntToStr(FEtapaAtual));

        // Incrementa a etapa atual APENAS depois de validar que pode inserir.
        FEtapaAtual := FEtapaAtual + 1;

        // Registrar o Ponto de Início
        FCDSMetricasTickDiff.Insert;
        FCDSMetricasTickDiff.FieldByName('NOME_METODO').AsString       := pNomeMetodo;
        FCDSMetricasTickDiff.FieldByName('ETAPA_CASO_TESTE').AsInteger := FEtapaAtual;
        FCDSMetricasTickDiff.FieldByName('TEMPO_INICIO').AsInteger     := lTempoTick;
        FCDSMetricasTickDiff.FieldByName('TEMPO_FIM').AsInteger        := 0; // Registra como zero para identificar que ainda precisa desse registro no Fim da execução.
        FCDSMetricasTickDiff.Post;
      end;

    1:
      begin
        // Usa FindKey ao invés de Filter para ganho em desempenho.
        lVerificaFindKey := FCDSMetricasTickDiff.FindKey([pNomeMetodo, FEtapaAtual]);

        {TDD_LOGS.}MostrarLogTextoEmModoDebugT(
          Format('Valores utilizados no FindKey: Método "%s", Etapa: "%s".', [pNomeMetodo, IntToStr(FEtapaAtual)]),
          'Valor da verificação do FindKey das métricas Tick'
        );
      
        {TDD_LOGS.}MostrarLogTextoEmModoDebugT(lVerificaFindKey, 'Valor de "lVerificaFindKey" para o método: ' + pNomeMetodo);
      
        // Só tenta finalizar se encontrou algo ou tem certeza que existe.
        if lVerificaFindKey then
        begin
          lPontoTick := 'Fim';

          // Procura pelo Nome do Método, mas APENAS os que o TEMPO_FIM ainda é 0 (Em aberto).
          if FCDSMetricasTickDiff.Locate('NOME_METODO;TEMPO_FIM', VarArrayOf([pNomeMetodo, 0]), []) then
          begin
            // REMOVIDO: FCDSMetricasTickDiff.First; -> Isso estragava o Locate!
            FCDSMetricasTickDiff.Edit;
            FCDSMetricasTickDiff.FieldByName('TEMPO_FIM').AsInteger := lTempoTick;

            // Registra o tempo total da execução.
            lTempoTotal := TickDiff(FCDSMetricasTickDiff.FieldByName('TEMPO_INICIO').AsInteger, lTempoTick);
            FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL').AsInteger          := lTempoTotal;
            FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL_FORMATADO').AsString := FormatarTickDiff(lTempoTotal);
            FCDSMetricasTickDiff.Post;
          end
          else
            raise Exception.Create('Não foi encontrado o registro de INÍCIO aberto para: ' + pNomeMetodo);
        end
        else
          raise Exception.Create('Método não encontrado para finalizar: ' + pNomeMetodo);
      end; // <-- Fim do bloco 1:
  else
    raise Exception.Create('Não é possível registrar métrica Tick para: ' + IntToStr(pPontoTick));
  end; // <-- Fim do Case

  {TDD_LOGS.}MostrarLogTextoEmModoDebug('Tick Registrado. Ponto: "' + IntToStr(pPontoTick) + '" = ' + lPontoTick + ' | Método: ' + pNomeMetodo);
end;
{$endregion}

{ ================================================================
  MÉTODO COM PAPEL DE SETTER PARA O CASO DE TESTE
  Responsabilidade mantida no RUNNER para cronometrar o STARTED
  ================================================================ }
procedure SetarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string);
begin
  FContextoCasoTeste.DescricaoModulo    := pDescricaoModulo;
  FContextoCasoTeste.DescricaoArea      := pDescricaoArea;
  FContextoCasoTeste.DescricaoCasoTeste := pDescricaoCasoTeste;
end;

{$region Execução}
procedure Run(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string);
var lMensagemFeedback :string;
begin
  // Inicializa para registrar todas as métricas até o FINISHED.
  InicializarMetricasTickDiff;

  // Ponto de entrada deve sempre ser o run, assim o cronometro é capaz rastrear o tempo total corretamente.
  RegistrarTick(0, 'Total');

  CallBack_AbreTela('Run');
  CallBack_AbreTela(ClassOwner);
  try
    try
      SetarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste);

      FNomeMetodoAtual := 'STARTED';
      RegistrarTick(0, FNomeMetodoAtual);
      LogDoProcessamentoAdd('INICIOU STARTED');
      {TDD_STARTED.}Started;
      LogDoProcessamentoAdd('ENCERROU STARTED');
      RegistrarTick(1, FNomeMetodoAtual);
      
      FNomeMetodoAtual := 'IRUNNER';
      RegistrarTick(0, FNomeMetodoAtual);
      LogDoProcessamentoAdd('INICIOU IRUNNER');
      {TDD_IRUNNER.}Executar;
      LogDoProcessamentoAdd('ENCERROU IRUNNER');
      RegistrarTick(1, FNomeMetodoAtual);      

      FNomeMetodoAtual := 'FINISHED';
      RegistrarTick(0, FNomeMetodoAtual);
      LogDoProcessamentoAdd('INICIOU FINISHED');
      {TDD_FINISHED.}RegistrarMetricas;
      LogDoProcessamentoAdd('ENCERROU FINISHED');
      RegistrarTick(1, FNomeMetodoAtual);

      // Marca que o teste foi finalizado com sucesso.
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
        {TDD_LOGS.}MostrarLogTextoEmModoDebug('Falha ao persistir metricas: ' + Ex.Message);
    end;
    LiberarMetricasTickDiff;
    CallBack_FechaTela(ClassOwner);
    CallBack_FechaTela('Run');
    // Encerra o cronometro de tempo total.
    RegistrarTick(1, 'Total');
  end;
end;
{$endregion}