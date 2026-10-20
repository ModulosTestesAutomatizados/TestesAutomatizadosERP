uses P39_TDD_CASOS_DE_TESTE;

const
  cPulada = 'ASSERTS: PULADO - ';
  cFalha  = 'ASSERTS: FALHOU - ';

var
  FAssertsTotal          :Integer;
  FAssertsPass           :Integer;
  FAssertsFail           :Integer;
  FFalhas                :TStringList;
  FDataSets              :TStringList;
  FResultados            :TStringList;
  FErrosReais            :Integer;
  FTempoExecucaoMs       :Double;
  FResultadoEsperadoCaso :String;

procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes := 'Unit responsável pelo use case de asserts (baseado no modelo DUnitX) para uso no interpretador.'          + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'FAssertsTotal :Integer'                                                                                                + #13 +
    '  - Contabiliza a quantidade total de asserções executadas no caso de teste.'                                          + #13 +
    'FAssertsPass :Integer'                                                                                                 + #13 +
    '  - Contabiliza a quantidade de asserções que obtiveram sucesso (PASS).'                                               + #13 +
    'FAssertsFail :Integer'                                                                                                 + #13 +
    '  - Contabiliza a quantidade de asserções que falharam (FAIL).'                                                        + #13 +
    'FFalhas :TStringList'                                                                                                  + #13 +
    '  - Lista em memória que armazena as mensagens detalhadas apenas das asserções que falharam.'                          + #13 +
    'FDataSets :TStringList'                                                                                                + #13 +
    '  - Mantém clones (TClientDataSet) dos datasets capturados durante o teste, indexados por "DataSet|DM".'               + #13 +
    'FResultados :TStringList'                                                                                              + #13 +
    '  - Armazena o histórico sequencial completo de todas as asserções (PASS e FAIL).'                                     + #13 +
    'FErrosReais :Integer'                                                                                                  + #13 +
    '  - Contabiliza a quantidade de erros reais de execução capturados durante o teste.'                                   + #13 +
    'FTempoExecucaoMs :Double'                                                                                              + #13 +
    '  - Armazena o tempo total de execução em milissegundos para validação de métricas de performance.'                    + #13 +
    'FResultadoEsperadoCaso :String'                                                                                        + #13 +
    '  - Guarda a string JSON contendo os critérios de resultado esperado do caso de teste atual.'                          + #13 +
    '===================================================================================================================='  + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                   + #13 +
    'procedure InicializarAcumulo'                                                                                          + #13 +
    '  - Garante a instanciação das listas globais (FFalhas, FDataSets e FResultados) antes do uso.'                        + #13 +
    'procedure RegistrarDataSet(pDataSetName :String)'                                                                      + #13 +
    '  - Localiza o par "DataSet|DM", valida se está ativo/preenchido e salva uma cópia dos dados em FDataSets.'            + #13 +
    'function RegistrarResultado(pPassou :Boolean; pMsg :String) :Boolean'                                                  + #13 +
    '  - Incrementa os totalizadores (Total, Pass ou Fail), alimenta as listas de histórico/falhas e registra log debug.'   + #13 +
    'procedure RegistrarErroReal(pDescricao :String)'                                                                       + #13 +
    '  - Incrementa o contador FErrosReais e grava a descrição do erro no log em modo debug.'                               + #13 +
    'function AssertsPassou(pDescricao :String) :Boolean'                                                                   + #13 +
    '  - Registra diretamente um resultado positivo (PASS) com a mensagem informada.'                                       + #13 +
    'function AssertsFalhou(pDescricao, pDetalhe :String) :Boolean'                                                         + #13 +
    '  - Registra diretamente uma falha (FAIL) concatenando a descrição e o detalhe do problema.'                           + #13 +
    'function AssertVerdadeiro(pCondicao :Boolean; pDescricao :String) :Boolean'                                            + #13 +
    '  - Valida se a condição informada é verdadeira (True).'                                                               + #13 +
    'function AssertFalso(pCondicao :Boolean; pDescricao :String) :Boolean'                                                 + #13 +
    '  - Valida se a condição informada é falsa (False).'                                                                   + #13 +
    'function AssertIgual(pEsperado, pObtido, pDescricao :String) :Boolean'                                                 + #13 +
    '  - Compara duas strings e valida se o valor obtido é exatamente igual ao esperado.'                                   + #13 +
    'function AssertIgualInteiro(pEsperado, pObtido :Integer; pDescricao :String) :Boolean'                                 + #13 +
    '  - Compara dois números inteiros e valida se são iguais.'                                                             + #13 +
    'function Arredondar(pValor :Currency; pCasas :Integer) :Currency'                                                      + #13 +
    '  - Função auxiliar que arredonda um valor Currency para a quantidade de casas decimais especificada.'                 + #13 +
    'function AssertIgualCurrency(pEsperado, pObtido :Currency; pCasas :Integer; pDescricao :String) :Boolean'              + #13 +
    '  - Compara dois valores monetários (Currency) aplicando arredondamento prévio conforme pCasas.'                       + #13 +
    'function AssertListaVazia(pLista :TStringList; pDescricao :String) :Boolean'                                           + #13 +
    '  - Valida se a TStringList informada não está instanciada (nil) ou não possui elementos (Count = 0).'                 + #13 +
    'function AssertContem(pTexto, pSubstring, pDescricao :String) :Boolean'                                                + #13 +
    '  - Verifica (sem diferenciar maiúsculas/minúsculas) se pSubstring está contida em pTexto.'                            + #13 +
    'procedure AssertsZerar'                                                                                                + #13 +
    '  - Reinicia contadores, limpa listas de resultados/falhas e libera da memória os TClientDataSet clonados.'            + #13 +
    'function AssertsTotal / AssertsPass / AssertsFail :Integer'                                                            + #13 +
    '  - Funções de leitura que retornam os respectivos contadores acumulados na execução.'                                 + #13 +
    'function AssertsOk :Boolean'                                                                                           + #13 +
    '  - Retorna True caso nenhuma falha tenha sido registrada (FAssertsFail = 0).'                                         + #13 +
    'function AssertsResumo :String'                                                                                        + #13 +
    '  - Gera uma string formatada com o placar de execução (total, pass, fail) e a listagem detalhada das falhas.'         + #13 +
    '===================================================================================================================='  + #13 +
    'Cada assert registra PASS/FAIL acumulado e retorna Boolean.'                                                           + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('P39_TDD_RUN_ASSERTS', lInstrucoes);
end;

{$Region 'Nucleo interno'}

procedure InicializarAcumulo;
begin
  if not Assigned(FFalhas) then
  begin
    FFalhas := TStringList.Create;
    FFalhas.Clear;
  end;

  if not Assigned(FDataSets) then
  begin
    FDataSets := TStringList.Create;
    FDataSets.CLear;
  end;
  if not Assigned(FResultados) then
    FResultados := TStringList.Create;
end;

// Informar DataSet | DM
procedure RegistrarDataSet(pDataSetName :String);
var lDM: TDataModule;
  lOrigem, lCopia: TClientDataSet;
  lIndice: Integer;
begin
  InicializarAcumulo;
  lDM := DMCriadoPeloNome(CorteApos(pDataSetName, '|'));
  if not Assigned(lDM) then
    raise Exception.Create('DataModule não encontrado para captura: ' + pDataSetName);
  lOrigem := lDM.FindComponent(CorteAte(pDataSetName, '|'));
  if not Assigned(lOrigem) then
    raise Exception.Create('Dataset não encontrado para captura: ' + pDataSetName);
  if not lOrigem.Active then
    raise Exception.Create('Dataset inativo para captura: ' + pDataSetName);
  if lOrigem.IsEmpty then
    raise Exception.Create('Dataset vazio para captura: ' + pDataSetName);
  lCopia := TClientDataSet.Create;
  try
    lCopia.Data := lOrigem.Data;
    lCopia.RecNo := lOrigem.RecNo;
    lIndice := FDataSets.IndexOf(pDataSetName);
    if lIndice >= 0 then
    begin
      TClientDataSet(FDataSets.Objects[lIndice]).Free;
      FDataSets.Objects[lIndice] := lCopia;
    end
    else
      FDataSets.AddObject(pDataSetName, lCopia);
  except
    lCopia.Free;
    raise;
  end;
end;

function RegistrarResultado(pPassou :Boolean; pMsg :String) :Boolean;
begin
  InicializarAcumulo;
  FAssertsTotal := FAssertsTotal + 1;

  if pPassou then
  begin
    FAssertsPass := FAssertsPass + 1;
    FResultados.Add('PASS - ' + pMsg);
    RegistrarLog('ASSERTS: PASS - ' + pMsg);
  end
  else
  begin
    FAssertsFail := FAssertsFail + 1;
    FFalhas.Add(pMsg);
    FResultados.Add('FAIL - ' + pMsg);
    RegistrarLog(cFalha + pMsg);
  end;

  Result := pPassou;
end;
{$endRegion}

procedure RegistrarErroReal(pDescricao :String);
begin
  FErrosReais := FErrosReais + 1;
  {P39_TDD_RUN_LOGS}RegistrarLog('Erro real registrado: ' + pDescricao);
end;

{$Region 'Asserts base'}

function AssertsPassou(pDescricao :String) :Boolean;
begin
  Result := RegistrarResultado(True, pDescricao);
end;

function AssertsFalhou(pDescricao, pDetalhe :String) :Boolean;
begin
  Result := RegistrarResultado(False, pDescricao + ' ' + pDetalhe);
end;

function AssertVerdadeiro(pCondicao :Boolean; pDescricao :String) :Boolean;
begin
  InicializarAcumulo;
  if pCondicao then
    Result := RegistrarResultado(True, pDescricao + ': esperado TRUE, obtido TRUE')
  else
    Result := RegistrarResultado(False, pDescricao + ': esperado TRUE, obtido FALSE');
end;

function AssertFalso(pCondicao :Boolean; pDescricao :String) :Boolean;
begin
  InicializarAcumulo;
  if pCondicao then
    Result := RegistrarResultado(False, pDescricao + ': esperado FALSE, obtido TRUE')
  else
    Result := RegistrarResultado(True, pDescricao + ': esperado FALSE, obtido FALSE');
end;

function AssertIgual(pEsperado, pObtido, pDescricao :String) :Boolean;
begin
  InicializarAcumulo;
  if pEsperado = pObtido then
    Result := RegistrarResultado(True, pDescricao + ' [' + pEsperado + ']')
  else
    Result := RegistrarResultado(False,
      pDescricao + ': esperado "' + pEsperado + '", obtido "' + pObtido + '".');
end;

function AssertIgualInteiro(pEsperado, pObtido :Integer; pDescricao :String) :Boolean;
begin
  InicializarAcumulo;
  if pEsperado = pObtido then
    Result := RegistrarResultado(True, pDescricao + ' [' + IntToStr(pEsperado) + ']')
  else
    Result := RegistrarResultado(False,
      pDescricao + ': esperado ' + IntToStr(pEsperado) + ', obtido ' + IntToStr(pObtido) + '.');
end;

function Arredondar(pValor :Currency; pCasas :Integer) :Currency;
var lFator: Currency;
  I: Integer;
begin
  lFator := 1;
  for I := 1 to pCasas do
    lFator := lFator * 10;

  Result := Round(pValor * lFator) / lFator;
end;

function AssertIgualCurrency(pEsperado, pObtido :Currency; pCasas :Integer; pDescricao :String) :Boolean;
begin
  InicializarAcumulo;
  if Arredondar(pEsperado, pCasas) = Arredondar(pObtido, pCasas) then
    Result := RegistrarResultado(True,
      pDescricao + ': esperado ' + CurrToStr(pEsperado) + ', obtido ' + CurrToStr(pObtido))
  else
    Result := RegistrarResultado(False,
      pDescricao + ': esperado ' + CurrToStr(pEsperado) +
      ', obtido ' + CurrToStr(pObtido) + '.');
end;

function AssertListaVazia(pLista :TStringList; pDescricao :String) :Boolean;
begin
  InicializarAcumulo;
  if (pLista = nil) or (pLista.Count = 0) then
    Result := RegistrarResultado(True, pDescricao + ' -> lista vazia')
  else
    Result := RegistrarResultado(False,
      pDescricao + ': lista com ' + IntToStr(pLista.Count) + ' itens, esperado vazio.');
end;

function AssertContem(pTexto, pSubstring, pDescricao :String) :Boolean;
begin
  InicializarAcumulo;
  if Pos(UpperCase(pSubstring), UpperCase(pTexto)) > 0 then
    Result := RegistrarResultado(True, pDescricao + ': esperado conter "' + pSubstring + '", obtido "' + pTexto + '"')
  else
    Result := RegistrarResultado(False,
      pDescricao + ': esperado conter "' + pSubstring + '", obtido "' + pTexto + '"');
end;
{$endRegion}

{$Region 'Totalizadores'}
procedure AssertsZerar;
begin
  InicializarAcumulo;
  FAssertsTotal := 0;
  FAssertsPass  := 0;
  FAssertsFail  := 0;
  FFalhas.Clear;
  FResultados.Clear;
  FErrosReais := 0;
  FTempoExecucaoMs := 0;
  FResultadoEsperadoCaso := '';
  while FDataSets.Count > 0 do
  begin
    TClientDataSet(FDataSets.Objects[0]).Free;
    FDataSets.Delete(0);
  end;
end;

function AssertsTotal :Integer;
begin
  Result := FAssertsTotal;
end;

function AssertsPass :Integer;
begin
  Result := FAssertsPass;
end;

function AssertsFail :Integer;
begin
  Result := FAssertsFail;
end;

function AssertsOk :Boolean;
begin
  Result := (FAssertsFail = 0);
end;

function AssertsResumo :String;
var I: Integer;
begin
  Result := '-----------------------------' + #13 +
    'Asserts:' + #13 + 
    'total=' + IntToStr(FAssertsTotal) + #13 +
    'pass=' + IntToStr(FAssertsPass) + #13 +
    'fail=' + IntToStr(FAssertsFail) + #13 + 
    '--------------------------------------';

  if FAssertsFail > 0 then
  begin
    Result := Result + #13 + 'Falhas:';
    for I := 0 to FFalhas.Count - 1 do
      Result := Result + #13 + '  * ' + FFalhas[I];
  end;
end;
{$endRegion}
