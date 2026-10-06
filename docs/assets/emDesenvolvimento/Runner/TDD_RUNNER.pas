uses P39_TDD_ODBC, TDD_IRUNNER, TDD_LOGS, TDD_STARTED, TDD_FINISHED;

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
  lInstrucoes := 'Unit responsável pela carga do lote, contexto individual e métricas de tempo.'                           + #13 +
    '====================================================================================================================' + #13 +
    'Métodos de preparação:'                                                                                               + #13 +
    'function SetupCasosTestes(const pDescricaoModulo, pDescricaoArea :string) :Boolean'                                   + #13 +
    '  - Carrega os casos ativos do módulo/área uma vez antes do loop da casca.'                                           + #13 +
    'procedure SetarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string)'                              + #13 +
    '  - Reinicia histórico, erros e etapa; prepara o contexto do registro corrente sem mover o cursor.'                   + #13 +
    '====================================================================================================================' + #13 +
    'Métodos de métricas:'                                                                                                 + #13 +
    'procedure InicializarMetricasTickDiff / LiberarMetricasTickDiff'                                                      + #13 +
    '  - Cria os tempos de uma tentativa e libera seu CDS pelos métodos existentes.'                                       + #13 +
    'procedure RegistrarTick(pPontoTick :integer; pNomeMetodo :string)'                                                    + #13 +
    '  - Registra início (0) e fim (1) de cada método; mantém o cálculo por TickDiff.'                                     + #13 +
    'function PreencherComZeros(pValor :Cardinal; pTamanho :Integer) :string'                                              + #13 +
    'function FormatarTickDiff(pTempoMs :Cardinal) :string'                                                                + #13 +
    '  - Métodos de apoio à formatação das durações.'                                                                      + #13 +
    '====================================================================================================================' + #13 +
    'Contrato compartilhado:'                                                                                              + #13 +
    'FHistoricoExecucao, FContextoCasoTeste, FNomeMetodoAtual e FEtapaAtual pertencem ao fluxo da casca.'                  + #13 +
    'Os logs usam TDD_LOGS; a casca limpa FLogsCasoTeste por tentativa e libera a lista no fim do lote.'                   + #13 +
    'FExibirInstrucoes controla a exibição destas instruções.'                                                             + #13 +
    '====================================================================================================================';
  {P39_TDD_LOGS.}MostrarInstrucoesUnit('TDD_RUNNER', lInstrucoes);
end;

{$region Setup Casos de Testes}
{ ================================================================
  CARGA DO CONJUNTO DE CASOS DE TESTE
    - Chamada pela Main da casca antes da iteracao dos casos
  ================================================================ }
function SetupCasosTestes(const pDescricaoModulo, pDescricaoArea :string) :Boolean;
begin
  Result := False;

  if (Trim(pDescricaoModulo) = '') or (Trim(pDescricaoArea) = '') then
    raise Exception.Create('Modulo e area devem ser informados para carregar os casos de teste.');

  CallBack_Mensagem(ClassOwner, '[SETUP CASOS DE TESTE INICIADO]');
  {P39_TDD_LOGS.}DelimitadorLog('SETUP CASOS DE TESTE');
  {P39_TDD_LOGS.}RegistrarLogEmModoDebug(
    'Módulo: ' + pDescricaoModulo + #13 +
    'Área: ' + pDescricaoArea
  );

  try
    {P39_TDD_CASOS_DE_TESTE.}SetModulo(pDescricaoModulo);
    {P39_TDD_CASOS_DE_TESTE.}SetArea(pDescricaoArea);

    if FEstruturaCasoTesteIniciada then
    begin
      CDSCasosTestes.EmptyDataSet;
      CDSResultadoEsperado.EmptyDataSet;
    end;

    {P39_TDD_CASOS_DE_TESTE.}CarregarCasosTeste;

    FContextoCasoTeste.DescricaoModulo := pDescricaoModulo;
    FContextoCasoTeste.DescricaoArea := pDescricaoArea;

    {P39_TDD_LOGS.}RegistrarLogEmModoDebug(
      'Estrutura de casos de teste inicializada' + #13 +
      'Modulo/Area configurados'                 + #13 +
      'Casos de teste carregados'
    );

    {P39_TDD_LOGS.}RegistrarLogEmModoDebug('Casos de teste carregados: ' + IntToStr(CDSCasosTestes.RecordCount));

    Result := True;
  except
    on E: Exception do
    begin
      {P39_TDD_LOGS.}RegistrarLogEmModoDebug('ERRO NO SETUP: ' + E.Message);
      raise Exception.Create('Falha ao carregar os casos de teste: ' + E.Message);
    end;
  end;
end;

{ ================================================================
  CONTEXTO INDIVIDUAL DO REGISTRO CORRENTE DO CDS GLOBAL
    - Chamada por Run para preparar cada tentativa
    - Reinicia historico, status, erros, etapa e dados do caso anterior
    - Define o contexto sem carregar casos ou mover o cursor
  ================================================================ }
procedure SetarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string);
begin
  FHistoricoExecucao.AutoIncHistorico := 0;
  FHistoricoExecucao.AutoIncCasoTeste := CDSCasosTestes.FieldByName('ID').AsInteger;
  FHistoricoExecucao.VersaoExecucao := '';
  FHistoricoExecucao.RequisitoVersao := CDSCasosTestes.FieldByName('REQUISITOVERSAO').AsString;
  FHistoricoExecucao.StatusExecucao := '';
  FHistoricoExecucao.EtapaFalha := 0;
  FHistoricoExecucao.MensagemErro := '';
  FHistoricoExecucao.LogsFalhas := '';

  FNomeMetodoAtual := '';
  FEtapaAtual := 0;
  FCasoTesteAtualId := 0;
  FCasoTesteAtualJson := '';
  FContextoCasoTeste.DescricaoModulo    := pDescricaoModulo;
  FContextoCasoTeste.DescricaoArea      := pDescricaoArea;
  FContextoCasoTeste.DescricaoCasoTeste := pDescricaoCasoTeste;
end;
{$endregion}

{ ================================================================
  INICIALIZAÇÃO DE CDS PARA ARMAZENAR TICKS DE EXECUÇÕES
  Responsabilidade mantida no RUNNER para cronometrar o STARTED
  ================================================================ }
{$region CDS Métricas}
procedure LiberarMetricasTickDiff;
begin
  if Assigned(FCDSMetricasTickDiff) then
    FCDSMetricasTickDiff.Free;
  {P39_TDD_LOGS}RegistrarLogEmModoDebug('Memória liberada para o CDS de Métricas Tick.');
end;

procedure InicializarMetricasTickDiff;
begin
  LiberarMetricasTickDiff;
  FEtapaAtual := 0;

  FCDSMetricasTickDiff := TClientDataSet.Create;
  FCDSMetricasTickDiff.FieldDefs.Add('ETAPA_CASO_TESTE', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('NOME_METODO', ftString, 120, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_INICIO', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_FIM', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_TOTAL', ftInteger, 0, False);
  FCDSMetricasTickDiff.FieldDefs.Add('TEMPO_TOTAL_FORMATADO', ftString, 20, False);
  FCDSMetricasTickDiff.CreateDataSet;
  FCDSMetricasTickDiff.DisableControls;
  FCDSMetricasTickDiff.LogChanges      := False;
  FCDSMetricasTickDiff.IndexFieldNames := 'NOME_METODO';
  {P39_TDD_LOGS}RegistrarLogEmModoDebug('Criado o DataSet para o CDS de Métricas Tick.');
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

  pNomeMetodo := UpperCase(pNomeMetodo);

  // Usa FindKey ao invés de Filter para ganho em desempenho.
  lVerificaFindKey := FCDSMetricasTickDiff.FindKey([pNomeMetodo]);

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
        {P39_TDD_LOGS}RegistrarLogEmModoDebug('INICIOU ' + pNomeMetodo);
      end;
    1:
      begin
        // Só tenta finalizar se encontrou algo ou tem certeza que existe.
        if lVerificaFindKey then
        begin
          lPontoTick := 'Fim';

          // Procura pelo Nome do Método, mas APENAS os que o TEMPO_FIM ainda é 0 (Em aberto).
          if FCDSMetricasTickDiff.Locate('NOME_METODO;TEMPO_FIM', VarArrayOf([pNomeMetodo, 0]), 0) then
          begin
            // REMOVIDO: FCDSMetricasTickDiff.First; -> Isso estragava o Locate!
            FCDSMetricasTickDiff.Edit;
            FCDSMetricasTickDiff.FieldByName('TEMPO_FIM').AsInteger := lTempoTick;

            // Registra o tempo total da execução.
            lTempoTotal := TickDiff(FCDSMetricasTickDiff.FieldByName('TEMPO_INICIO').AsInteger, lTempoTick);
            FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL').AsInteger          := lTempoTotal;
            FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL_FORMATADO').AsString := FormatarTickDiff(lTempoTotal);
            FCDSMetricasTickDiff.Post;
           {P39_TDD_LOGS}RegistrarLogEmModoDebug('ENCERROU ' + pNomeMetodo);
          end
          else
            raise Exception.Create('Não foi encontrado o registro de INÍCIO aberto para: ' + pNomeMetodo);
        end
        else
          raise Exception.Create('Método não encontrado para finalizar: ' + pNomeMetodo);
      end; // <-- Fim do bloco 1:
  else
    raise Exception.Create('Não é possível registrar métrica Tick para ponto: ' + IntToStr(pPontoTick));
  end; // <-- Fim do Case

  {P39_TDD_LOGS.}RegistrarLogEmModoDebug(
    'Tick Registrado!'                                        + #13 +
    '| Ponto: "' + IntToStr(pPontoTick) + '" = ' + lPontoTick + #13 +
    '| Método: ' + pNomeMetodo
  );
end;
{$endregion}
