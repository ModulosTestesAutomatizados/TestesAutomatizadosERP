{ ================================================================
  P39_TDD_STARTED - Casca única / Test Runner para testes TDD

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
  lInstrucoes :string;
begin
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
  {P39_TDD_LOGS.}MostrarInstrucoesUnit('TDD_STARTED', lInstrucoes);
end;

{$region Setup Casos de Testes}
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

  CallBack_Mensagem(ClassOwner, '[SETUP CASO DE TESTE INICIADO]');
  {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug(
    '=================================================================' + #13 +
    'SETUP CASO DE TESTE INICIADO'                                      + #13 +
    '=================================================================' + #13 +
    '| Modulo:    ' + pDescricaoModulo                                  + #13 + 
    '| Area:      ' + pDescricaoArea                                    + #13 + 
    '| CasoTeste: ' + pDescricaoCasoTeste
  );

  try
    {P39_TDD_CASOS_DE_TESTE.}SetModulo(pDescricaoModulo);
    {P39_TDD_CASOS_DE_TESTE.}SetArea(pDescricaoArea);
    {P39_TDD_CASOS_DE_TESTE.}CarregarCasosTeste;

    {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug(
      'Estrutura de casos de teste inicializada' + #13 +
      'Modulo/Area configurados'                 + #13 +
      'Casos de teste carregados'
    );
      
    {P39_TDD_LOGS.}MostrarCDSEmModoDebugT(CDSCasosTestes, 'CDSCasosTestes - P39_TDD_STARTED');

    lCasoTesteJson := '';
    lEncontrou     := False;
    {P39_TDD_CASOS_DE_TESTE.}CDSCasosTestes.First;
    while not CDSCasosTestes.Eof do
    begin
      if UpperCase(Trim(CDSCasosTestes.FieldByName('DESCRICAO').AsString)) = UpperCase(Trim(pDescricaoCasoTeste)) then
      begin
        lCasoTesteJson    := CDSCasosTestes.FieldByName('CASOTESTE').AsString;
        FCasoTesteAtualId := CDSCasosTestes.FieldByName('ID').AsInteger;
        lEncontrou        := True;
        Break; // Encerra prematuramente o Loop.
      end;
      CDSCasosTestes.Next;
    end;

    if not lEncontrou then raise Exception.Create('Caso de teste "' + pDescricaoCasoTeste + '" nao encontrado.');

    FCasoTesteAtualJson := lCasoTesteJson;
    {P39_TDD_RUNNER}FHistoricoExecucao.AutoIncCasoTeste := FCasoTesteAtualId;
    //{P39_TDD_CASOS_DE_TESTE.}CarregarConfiguracoes;

    {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug(
      'Caso de teste encontrado: ' + pDescricaoCasoTeste + ' (ID ' + IntToStr(FCasoTesteAtualId) + ')' + #13 +
      'JSON do caso: '                                                                                 + #13 +
      lCasoTesteJson                                                                                   + #13 +
      'Configurações carregadas.'
    );

    // Aplica parametros antes da execucao do caso.
    CallBack_Mensagem(ClassOwner, 'AplicarParametrosDoCasoTeste');
    {P39_TDD_RUNNER.}RegistrarTick(0, 'Aplicar Parametros Do Caso de Teste');
    AplicarParametrosDoCasoTeste;    
    {P39_TDD_RUNNER.}RegistrarTick(1, 'Aplicar Parametros Do Caso de Teste');        

    Result := True;

  except
    on E: Exception do
    begin
      {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('ERRO NO SETUP: ' + E.Message);
      raise Exception.Create(E.Message);
    end;
  end;
end;
{$endregion}

{$region Aplicação de parâmetros do sistema do caso de teste}
{ ================================================================
  APLICAÇÃO DE PARÂMETROS DO SISTEMA PARA EXECUTAR O TESTE
    - Está sendo cronometrado em sua chamada por SetupCasoTeste
  ================================================================ }
procedure AplicarParametrosDoCasoTeste;
var
  lParametrosJson: string;
  lObj: TJSONObject;
begin
  if (Trim(FCasoTesteAtualJson) <> '') and (Trim(FCasoTesteAtualJson) <> '{}') then
  begin
    lParametrosJson := GetObjectJson(FCasoTesteAtualJson, 'parametros');
    if (Trim(lParametrosJson) <> '') and (Trim(lParametrosJson) <> '{}') then
    begin
      try
        lObj := TJSONObject.ParseJSONValue(lParametrosJson);
        if not Assigned(lObj) then
          raise Exception.Create('JSON de parâmetros inválido.');

        {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug(
          'Aplicando parâmetros do caso de teste no sistema.' + #13 +
          lObj.ToJSON
        );

        {P39_TDD_PARAMETRO.}VerificarParametros(lObj.ToJSON);
        {P39_TDD_LOGS.}MostrarLogTextoEmModoDebug('Parâmetros verificados.');
      finally
        lObj.Free;
      end;
    end;
  end;
end;
{$endregion}

{$region validação da versão}
{ ================================================================
  VERIFICAÇÕES INICIAIS DE VALIDAÇÃO DA VERSÃO REQUISITO
    - Está sendo cronometrado em sua chamada por Started
  ================================================================ }
function ValidarVersaoRequisito :boolean;
var lVersaoRequisito :string;
begin
  {P39_TDD_RUNNER.}FHistoricoExecucao.VersaoExecucao := Troca(IntToStr(NumeroVersao), ',', '.');
  try
    if (Trim(CDSCasosTestes.FieldByName('REQUISITOVERSAO').AsString) <> '') then
    begin
      lVersaoRequisito := Troca(CDSCasosTestes.FieldByName('REQUISITOVERSAO').AsString, ',', '.');
      if VersaoSistemaIgualOuSuperior(lVersaoRequisito) then
        Result := True
      else
      begin
        FHistoricoExecucao.StatusExecucao := 'VERSAO_INCOMPATIVEL';
        raise Exception.Create(
          Format('Versão atual não atende o requisito mínimo.' + #13 + 'Versão atual: %s | Versão requisito: %s', [
            FHistoricoExecucao.VersaoExecucao,
            lVersaoRequisito
          ])
        );
      end;      
    end;
  except
    on ex: Exception do
      raise Exception.Create('Falha ao verificar a versão: ' + ex.Message);
  end;
end;
{$endregion}

{$region Use case da TDD_STARTED}
{ ================================================================
  USE CASE DA TDD_STARTED PARA O TDD_RUNNER.Run
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
  {P39_TDD_RUNNER.}RegistrarTick(0, 'Setup Casos de Testes');
  SetupCasoTeste(
    FContextoCasoTeste.DescricaoModulo,
    FContextoCasoTeste.DescricaoArea,
    FContextoCasoTeste.DescricaoCasoTeste
  );
  {P39_TDD_RUNNER.}RegistrarTick(1, 'Setup Casos de Testes');

  CallBack_Mensagem(ClassOwner, 'ValidarVersaoRequisito');
  {P39_TDD_RUNNER.}RegistrarTick(0, 'Validar Versao Requisito');
  ValidarVersaoRequisito;
  {P39_TDD_RUNNER.}RegistrarTick(1, 'Validar Versao Requisito');
end;
{$endregion}
