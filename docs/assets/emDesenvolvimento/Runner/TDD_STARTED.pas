{ ================================================================
  TDD_STARTED - Preparação individual no fluxo IRunner

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

{ ================================================================
  MAIN / INSTRUÇÕES
  ================================================================ }
procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit responsável pela preparação do caso corrente, validação de versão e aplicação de parâmetros.'       + #13 +
    '====================================================================================================================' + #13 +
    'Dependências herdadas:'                                                                                               + #13 +
    'Uses: P39_TDD_CASOS_DE_TESTE; herda CONSTANTES, ODBC, JSON, CACHE e PARAMETRO.'                                       + #13 +
    '====================================================================================================================' + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                  + #13 +
    'procedure Started'                                                                                                    + #13 +
    '  - Obtém ID, descrição e JSON do registro corrente, sem carregar casos ou mover o cursor.'                           + #13 +
    'function ValidarVersaoRequisito :Boolean'                                                                             + #13 +
    '  - Aceita requisito vazio; valida a versão mínima quando informada e registra incompatibilidade.'                    + #13 +
    'procedure AplicarParametrosDoCasoTeste'                                                                               + #13 +
    '  - Aplica a seção opcional de parâmetros; ausência ou objeto vazio não altera o sistema.'                              + #13 +
    '  - Lê somente a seção de parâmetros da raiz e rejeita JSON ou seção inválidos.'                                     + #13 +
    '====================================================================================================================' + #13 +
    'Contrato de execução:'                                                                                                + #13 +
    'Started é chamada por Run após SetarCasoTeste; a carga do lote permanece em SetupCasosTestes.'                        + #13 +
    'FCasoTesteAtualId e FCasoTesteAtualJson são compartilhados com a unit de Teste.'                                      + #13 +
    'Os tempos são registrados pelos métodos existentes; a captura dos logs respeita FModoDebug.'                        + #13 +
    'FExibirInstrucoes controla a exibição destas instruções.'                                                             + #13 +
    '====================================================================================================================';
  {P39_TDD_LOGS.}MostrarInstrucoesUnit('TDD_STARTED', lInstrucoes);
end;

{$region Aplicação de parâmetros do sistema do caso de teste}
{ ================================================================
  APLICAÇÃO DE PARÂMETROS DO SISTEMA PARA EXECUTAR O TESTE
    - Está sendo cronometrado em sua chamada por Started
  ================================================================ }
procedure AplicarParametrosDoCasoTeste;
var
  lTexto, lParametrosJson :string;
  lObj :TJSONObject;
  lPair :TJSONPair;
  lIndice :Integer;
begin
  lParametrosJson := '';
  lTexto := Trim(FCasoTesteAtualJson);
  if lTexto = '' then
    Exit;
  if Copy(lTexto, 1, 1) <> '{' then
    raise Exception.Create('JSON do caso de teste deve ser um objeto.');

  lObj := nil;
  try
    lObj := TJSONObject.ParseJSONValue(lTexto);
    if not Assigned(lObj) then
      raise Exception.Create('JSON do caso de teste inválido.');

    // GetPair e os leitores de pares já são usados em P39_TDD_PARAMETRO.
    // Não usa GetObjectJson: a ausência de uma seção opcional não é erro.
    for lIndice := 0 to lObj.Count - 1 do
    begin
      lPair := ExecutarMetodoDeObjeto(lObj, 'GetPair', [lIndice]);
      if (GetPairName(lPair) = 'parametros') and (lParametrosJson = '') then
      begin
        lParametrosJson := Trim(GetPairValue(lPair));
        if Copy(lParametrosJson, 1, 1) <> '{' then
          raise Exception.Create('A seção de parâmetros deve ser um objeto JSON.');
      end;
    end;
  finally
    if Assigned(lObj) then
      lObj.Free;
  end;
  if (Trim(lParametrosJson) <> '') and (Trim(lParametrosJson) <> '{}') then
  begin
    {P39_TDD_LOGS.}RegistrarLogEmModoDebug(
      'Aplicando parâmetros do caso de teste no sistema.' + #13 +
      lParametrosJson
    );
    {P39_TDD_PARAMETRO.}VerificarParametros(lParametrosJson);
    {P39_TDD_LOGS.}RegistrarLogEmModoDebug('Parâmetros verificados.');
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
  Result := True;
  {P39_TDD_RUNNER.}FHistoricoExecucao.VersaoExecucao := Troca(IntToStr(NumeroVersao), ',', '.');
  try
    if (Trim(CDSCasosTestes.FieldByName('REQUISITOVERSAO').AsString) <> '') then
    begin
      lVersaoRequisito := Troca(CDSCasosTestes.FieldByName('REQUISITOVERSAO').AsString, ',', '.');
      FHistoricoExecucao.RequisitoVersao := lVersaoRequisito;
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
  FCasoTesteAtualId                   := 0;
  FCasoTesteAtualJson                 := '';
  FHistoricoExecucao.AutoIncCasoTeste := 0;

  if (Trim(FContextoCasoTeste.DescricaoModulo) = '') or
     (Trim(FContextoCasoTeste.DescricaoArea) = '') then
    raise Exception.Create('Contexto do caso de teste não foi configurado corretamente no TDD_RUNNER.');

  if not Assigned(CDSCasosTestes) then
    raise Exception.Create('CDS global dos casos de teste não foi inicializado.');

  if not CDSCasosTestes.Active then
    raise Exception.Create('CDS global dos casos de teste não está ativo.');

  if CDSCasosTestes.IsEmpty or CDSCasosTestes.Eof then
    raise Exception.Create('Não há registro corrente para preparar o caso de teste.');

  FCasoTesteAtualId := CDSCasosTestes.FieldByName('ID').AsInteger;
  if FCasoTesteAtualId <= 0 then
    raise Exception.Create('Registro corrente possui ID de caso de teste inválido.');

  FCasoTesteAtualJson := CDSCasosTestes.FieldByName('CASOTESTE').AsString;
  FContextoCasoTeste.DescricaoCasoTeste := CDSCasosTestes.FieldByName('DESCRICAO').AsString;
  FHistoricoExecucao.AutoIncCasoTeste := FCasoTesteAtualId;

  {P39_TDD_LOGS.}RegistrarLogEmModoDebug(
    'Preparando caso de teste: ' + FContextoCasoTeste.DescricaoCasoTeste + #13 +
    ' (ID ' + IntToStr(FCasoTesteAtualId) + ')'                          + #13 +
    'JSON do caso: '                                                     + #13 +
    FCasoTesteAtualJson
  );

  CallBack_Mensagem(ClassOwner, 'ValidarVersaoRequisito');
  {P39_TDD_RUNNER.}RegistrarTick(0, 'Validar Versao Requisito');
  if not ValidarVersaoRequisito then
    raise Exception.Create('Versão do sistema não atende o requisito do caso de teste.');
  {P39_TDD_RUNNER.}RegistrarTick(1, 'Validar Versao Requisito');

  CallBack_Mensagem(ClassOwner, 'AplicarParametrosDoCasoTeste');
  {P39_TDD_RUNNER.}RegistrarTick(0, 'Aplicar Parametros Do Caso de Teste');
  AplicarParametrosDoCasoTeste;
  {P39_TDD_RUNNER.}RegistrarTick(1, 'Aplicar Parametros Do Caso de Teste');
end;
{$endregion}
