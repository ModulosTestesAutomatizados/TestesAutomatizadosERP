{ ================================================================
  TDD_STARTED - Casca única / Test Runner para testes TDD

  Herda via P39_TDD_CASOS_DE_TESTE:
  - P39_TDD_CONSTANTES (constantes, cache, SQL)
  - P39_TDD_ODBC (TDDCommandODBC, TDDReaderODBC, TDDScalarODBC)
  - P39_TDD_FUNCOES_JSON (GetValueJson, ValorCurrencyTag, etc.)
  - P39_TDD_CACHE (CDSModulos, CDSAreas, AreaPeloNome, ModuloPeloNome)
  - P39_TDD_PARAMETRO (Setup_Inicializar_Parametros, SetParametro, etc.)
  ================================================================ }
uses P39_TDD_CASOS_DE_TESTE;

var
  // Controle de fluxo
  FCasoTesteAtualId   :integer;
  FCasoTesteAtualJson :string;
  FSetupIniciado      :Boolean;

{ ================================================================
  MAIN / INSTRUÇÕES
  ================================================================ }
procedure Main;
var
  lInstrucoes: String;
begin
  TDD_RUNNER.Main;
  lInstrucoes := 'Unit Responsável pelo processo de inicialização padrão de um teste TDD. Dentre as suas responsabilidades estão um setter de caso de teste, parâmetros e validação de versão.'             + #13 +
    '=====================================================================================================================================================================================================' + #13 +
    'Uses mínimo: P39_TDD_CASOS_DE_TESTE (herda CONSTANTES, ODBC, JSON, CACHE, PARAMETRO)'                                                                                                                  + #13 +
    '=====================================================================================================================================================================================================' + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                                                                                                   + #13 +
    'procedure AplicarParametrosDoCasoTeste'                                                                                                                                                                + #13 +
    '  - Após carregar um caso de teste, temos a possibilidade de ter no json do caso de teste um objeto de parâmetros do sistema, caso existam eles são setados antes de iniciar o teste.'                 + #13 +
    'function SetupCasoTeste(const pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string) :Boolean'                                                                                                 + #13 +
    '  - Consumo enxuto da unit de TDD_CASOS_DE_TESTE, fazendo um set de Módulo, Área e Caso de Teste (pelas descrições dos mesmos), um caso de teste é carregado para as execuções prosseguirem.'          + #13 +                                                                       
    'function ValidarVersaoRequisito :boolean'                                                                                                                                                              + #13 +
    '  - Quando existir uma versão requisito no caso de teste, validamos se a versão do ERP em que a execução está sendo executada é valida utilizando VersaoSistemaIgualOuSuperior.'                       + #13 +
    '=====================================================================================================================================================================================================' + #13 +
    'Todos esses métodos estão altamente acoplados em TDD_RUNNER, eles possuem diversas dependências presentes na unit principal da execução, isso é proposital pois temos um fluxo completo para o TDD.'   + #13 +
    '=====================================================================================================================================================================================================';
  {TDD_LOGS.}MostrarInstrucoesUnit('TDD_STARTED', lInstrucoes);
end;

{ ================================================================
  INICIALIZAÇÃO DE PARÂMETROS DO SISTEMA
    - Está sendo cronometrado em sua chamada por SetupCasoTeste
  ================================================================ }
procedure AplicarParametrosDoCasoTeste;
begin
  if (Trim(FCasoTesteAtualJson) = '') or (FCasoTesteAtualJson = '{}') then
    Exit;

  {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('Aplicando parametros do sistema do caso de teste...');

  try
    {P39_TDD_PARAMETRO.}VerificarParametros(FCasoTesteAtualJson);
  except
    on E: Exception do
    begin
      {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('Erro ao aplicar parametros: ' + #13 + E.Message);
      raise Exception.Create(E.Message);
    end;
  end;
end;

{ ================================================================
  SETUP DO CASO DE TESTE
    - Está sendo cronometrado em sua chamada por Started
  ================================================================ }
function SetupCasoTeste(const pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string) :Boolean;
var
  lCasoTesteJson :string;
  lEncontrou     :Boolean;
begin
  Result := False;

  CallBack_Mensagem(ClassOwner, '[SETUP TDD_STARTED] Inicializando....');
  {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('=== SETUP CASO DE TESTE INICIADO ===');
  {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('Modulo: ' + pDescricaoModulo + ', Area: ' + pDescricaoArea + ', CasoTeste: ' + pDescricaoCasoTeste);

  try
    {P39_TDD_CASOS_DE_TESTE.}Setup_Inicializar_CasosTeste;
    {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('Estrutura de casos de teste inicializada');

    {P39_TDD_CASOS_DE_TESTE.}SetModulo(pDescricaoModulo);
    {P39_TDD_CASOS_DE_TESTE.}SetArea(pDescricaoArea);
    {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('Modulo/Area configurados');

    {P39_TDD_CASOS_DE_TESTE.}CarregarCasosTeste;
    {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('Casos de teste carregados');

    lCasoTesteJson := '';
    lEncontrou     := False;
    {P39_TDD_CASOS_DE_TESTE.}CDSCasosTestes.First;
    while not CDSCasosTesteS.Eof do
    begin
      if UpperCase(Trim(CDSCasosTestes.FieldByName('DESCRICAO').AsString)) = UpperCase(Trim(pDescricaoCasoTeste)) then
      begin
        lCasoTesteJson    := CDSCasosTestes.FieldByName('CASOTESTE').AsString;
        FCasoTesteAtualId := CDSCasosTestes.FieldByName('ID').AsInteger;
        lEncontrou        := True;
        Break;
      end;
      CDSCasosTestes.Next;
    end;

    if not lEncontrou then
      raise Exception.Create(MensagemPersonalizada + 'Caso de teste "' + pDescricaoCasoTeste + '" nao encontrado.');

    FCasoTesteAtualJson := lCasoTesteJson;
    {TDD_RUNNER}FHistoricoExecucao.AutoIncCasoTeste := FCasoTesteAtualId;

    {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('Caso de teste encontrado: ' + pDescricaoCasoTeste + ' (ID ' + IntToStr(FCasoTesteAtualId) + ')');
    {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('JSON do caso: ' + Copy(lCasoTesteJson, 1, 200) + '...');

    {P39_TDD_CASOS_DE_TESTE.}CarregarConfiguracoes;
    {P39_TDD_LOGS.}MostrarCDSEmModoDebugT(CDSCasosTestes, 'Configurações carregadas');

    // Aplica parametros antes da execucao do caso.
    CallBack_Mensagem(ClassOwner, 'AplicarParametrosDoCasoTeste');

    {TDD_RUNNER.}RegistrarTick(0, 'AplicarParametrosDoCasoTeste');
    AplicarParametrosDoCasoTeste;
    {TDD_RUNNER.}RegistrarTick(1, 'AplicarParametrosDoCasoTeste');

    Result := True;

  except
    on E: Exception do
    begin
      {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('ERRO NO SETUP: ' + E.Message);
      raise Exception.Create(E.Message);
    end;
  end;
end;

{ ================================================================
  VERIFICAÇÕES INICIAIS DE VALIDAÇÃO DA VERSÃO REQUISITO
    - Está sendo cronometrado em sua chamada por Started
  ================================================================ }
function ValidarVersaoRequisito :boolean;
var lVersaoRequisito :string;
begin
  try
    lVersaoRequisito := GetValueJson(FCasoTesteAtualJson, 'REQUISITO_VERSAO_CT');
    if VersaoSistemaIgualOuSuperior(lVersaoRequisito) then 
      Result         := True
    else
      raise Exception.Create(
        Format('Versão atual não atende o requisito mínimo.' + #13 + 'Versão atual: %s | Versão requisito: %s', [
          Troca(IntToStr(VersaoSistemaCodigo), ',', '.'),
          lVersaoRequisito 
        ])
      );
  except
    on ex: Exception do
      raise Exception.Create('Falha ao verificar a versão: ' + ex.Message);
  end;
end;

{ ================================================================
  STARTED - Fluxo de inicialização para o RUNNER
    - Está sendo cronometrado por sua chamada em TDD_RUNNER
  ================================================================ }
procedure Started;
begin
  if (Trim(FContextoCasoTeste.DescricaoModulo) = '') or
     (Trim(FContextoCasoTeste.DescricaoArea) = '') or
     (Trim(FContextoCasoTeste.DescricaoCasoTeste) = '') then
    raise Exception.Create('Contexto do caso de teste nao foi configurado corretamente no TDD_RUNNER.');

  // A Unit STARTED está altamente acoplada à TDD_RUNNER, então ela pode usar o callback aberto pela mesma.
  CallBack_Mensagem(ClassOwner, 'SetupCasoTeste');

  {TDD_RUNNER.}RegistrarTick(0, 'SetupCasoTeste');
  SetupCasoTeste(
    FContextoCasoTeste.DescricaoModulo,
    FContextoCasoTeste.DescricaoArea,
    FContextoCasoTeste.DescricaoCasoTeste
  );
  {TDD_RUNNER.}RegistrarTick(1, 'SetupCasoTeste');

  // Faz a verificação da versão de requisito, se falhar já encerra a execução.
  CallBack_Mensagem(ClassOwner, 'ValidarVersaoRequisito');

  {TDD_RUNNER.}RegistrarTick(0, 'ValidarVersaoRequisito');
  ValidarVersaoRequisito;
  {TDD_RUNNER.}RegistrarTick(1, 'ValidarVersaoRequisito');
end;
