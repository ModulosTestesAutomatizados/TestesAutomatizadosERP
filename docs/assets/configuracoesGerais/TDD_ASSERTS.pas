{
  Unit de asserts inspirada no DUnitX (Assert igualdade, verdadeiro/falso,
  lista vazia, texto) adaptada ao interpretador do ERP (JvInterpreter).

  Diferente do DUnitX (que usa classes e RTTI), aqui cada assert:
    - nao lanca excecao: registra PASS / FAIL acumulado (FResultados);
    - retorna Boolean (True = passou), permitindo uso em `if AssertX(...)`.

  No final, `AssertsResumo` devolve o total de pass/fail e a listagem, e
  `AssertsOk` indica se todos passaram.

  Metodos exportados:
    - function AssertsPassou(pDescricao: String): Boolean
      + Registra um assert bem-sucedido. Retorna sempre True.
    - function AssertsFalhou(pDescricao, pDetalhe: String): Boolean
      + Registra um assert reprovado. Retorna sempre False.
    - function AssertIgual(pEsperado, pObtido: String; pDescricao: String): Boolean
      + Compara igualdade de texto (String).
    - function AssertIgualInteiro(pEsperado, pObtido: Integer; pDescricao: String): Boolean
      + Compara igualdade numerica (Integer).
    - function AssertIgualCurrency(pEsperado, pObtido: Currency; pCasas: Integer; pDescricao: String): Boolean
      + Compara igualdade monetaria com arredondamento em pCasas.
    - function AssertVerdadeiro(pCondicao: Boolean; pDescricao: String): Boolean
      + Exige condicao True.
    - function AssertFalso(pCondicao: Boolean; pDescricao: String): Boolean
      + Exige condicao False.
    - function AssertListaVazia(pLista: TStringList; pDescricao: String): Boolean
      + Exige lista sem itens.
    - function AssertContem(pTexto, pSubstring: String; pDescricao: String): Boolean
      + Exige que pTexto contenha pSubstring (case-insensitive).
    - procedure AssertsZerar
      + Reinicia contadores/acumulados.
    - function AssertsTotal, AssertsPass, AssertsFail: Integer
      + Totais de asserts executados / aprovados / reprovados.
    - function AssertsOk: Boolean
      + True quando nao houve falha.
    - function AssertsResumo: String
      + Texto com total, pass, fail e lista de falhas.
}

uses P39_TDD_CASOS_DE_TESTE;

{$Region 'Constantes'}
const
  cPulada = 'ASSERTS: PULADO - ';
  cFalha  = 'ASSERTS: FALHOU - ';
{$endRegion}

{$Region 'Variaveis globais de acumulo'}
var
  FAssertsTotal: Integer;
  FAssertsPass:  Integer;
  FAssertsFail:  Integer;
  FFalhas: TStringList;
{$endRegion}

procedure Main;
var lInstrucoes: String;
begin
  P39_TDD_CASOS_DE_TESTE.Main; // Documentacao das units do uses

  lInstrucoes :=
    'Unit de asserts (modelo DUnitX) para uso no interpretador.' + #13 +
    'Cada assert registra PASS/FAIL acumulado e retorna Boolean.' + #13 +
    'Metodos: AssertIgual, AssertIgualInteiro, AssertIgualCurrency,' + #13 +
    'AssertVerdadeiro, AssertFalso, AssertListaVazia, AssertContem,' + #13 +
    'AssertsZerar, AssertsTotal, AssertsPass, AssertsFail, AssertsOk, AssertsResumo.';
  MostrarLogTexto(lInstrucoes, 'Instrucoes TDD_ASSERTS');
end;

{$Region 'Nucleo interno'}

procedure InicializarAcumulo;
begin
  if FFalhas = nil then
    FFalhas := TStringList.Create;
end;

function RegistrarResultado(pPassou: Boolean; pMsg: String): Boolean;
begin
  InicializarAcumulo;
  FAssertsTotal := FAssertsTotal + 1;

  if pPassou then
  begin
    FAssertsPass := FAssertsPass + 1;
    LogDoProcessamentoAdd('ASSERTS: PASS - ' + pMsg);
  end
  else
  begin
    FAssertsFail := FAssertsFail + 1;
    FFalhas.Add(pMsg);
    LogDoProcessamentoAdd(cFalha + pMsg);
  end;

  Result := pPassou;
end;
{$endRegion}

{$Region 'Asserts base'}

function AssertsPassou(pDescricao: String): Boolean;
begin
  Result := RegistrarResultado(True, pDescricao);
end;

function AssertsFalhou(pDescricao, pDetalhe: String): Boolean;
begin
  Result := RegistrarResultado(False, pDescricao + ' ' + pDetalhe);
end;

function AssertVerdadeiro(pCondicao: Boolean; pDescricao: String): Boolean;
begin
  InicializarAcumulo;
  Result := RegistrarResultado(pCondicao, pDescricao + ' -> esperado TRUE');
end;

function AssertFalso(pCondicao: Boolean; pDescricao: String): Boolean;
begin
  InicializarAcumulo;
  Result := RegistrarResultado(not pCondicao, pDescricao + ' -> esperado FALSE');
end;

function AssertIgual(pEsperado, pObtido, pDescricao: String): Boolean;
begin
  InicializarAcumulo;
  if pEsperado = pObtido then
    Result := RegistrarResultado(True, pDescricao + ' [' + pEsperado + ']')
  else
    Result := RegistrarResultado(False,
      pDescricao + ': esperado "' + pEsperado + '", obtido "' + pObtido + '".');
end;

function AssertIgualInteiro(pEsperado, pObtido: Integer; pDescricao: String): Boolean;
begin
  InicializarAcumulo;
  if pEsperado = pObtido then
    Result := RegistrarResultado(True, pDescricao + ' [' + IntToStr(pEsperado) + ']')
  else
    Result := RegistrarResultado(False,
      pDescricao + ': esperado ' + IntToStr(pEsperado) + ', obtido ' + IntToStr(pObtido) + '.');
end;

function Arredondar(pValor: Currency; pCasas: Integer): Currency;
var lFator: Currency;
  I: Integer;
begin
  lFator := 1;
  for I := 1 to pCasas do
    lFator := lFator * 10;

  Result := Round(pValor * lFator) / lFator;
end;

function AssertIgualCurrency(pEsperado, pObtido: Currency; pCasas: Integer; pDescricao: String): Boolean;
begin
  InicializarAcumulo;
  if Arredondar(pEsperado, pCasas) = Arredondar(pObtido, pCasas) then
    Result := RegistrarResultado(True,
      pDescricao + ' [' + CurrToStr(Arredondar(pEsperado, pCasas)) + ']')
  else
    Result := RegistrarResultado(False,
      pDescricao + ': esperado ' + CurrToStr(Arredondar(pEsperado, pCasas)) +
      ', obtido ' + CurrToStr(Arredondar(pObtido, pCasas)) + '.');
end;

function AssertListaVazia(pLista: TStringList; pDescricao: String): Boolean;
begin
  InicializarAcumulo;
  if (pLista = nil) or (pLista.Count = 0) then
    Result := RegistrarResultado(True, pDescricao + ' -> lista vazia')
  else
    Result := RegistrarResultado(False,
      pDescricao + ': lista com ' + IntToStr(pLista.Count) + ' itens, esperado vazio.');
end;

function AssertContem(pTexto, pSubstring, pDescricao: String): Boolean;
begin
  InicializarAcumulo;
  if Pos(UpperCase(pSubstring), UpperCase(pTexto)) > 0 then
    Result := RegistrarResultado(True, pDescricao + ' -> contem "' + pSubstring + '"')
  else
    Result := RegistrarResultado(False,
      pDescricao + ': texto nao contem "' + pSubstring + '".');
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
end;

function AssertsTotal: Integer;
begin
  Result := FAssertsTotal;
end;

function AssertsPass: Integer;
begin
  Result := FAssertsPass;
end;

function AssertsFail: Integer;
begin
  Result := FAssertsFail;
end;

function AssertsOk: Boolean;
begin
  Result := (FAssertsFail = 0);
end;

function AssertsResumo: String;
var I: Integer;
begin
  Result := 'Asserts: total=' + IntToStr(FAssertsTotal) +
    ', pass=' + IntToStr(FAssertsPass) +
    ', fail=' + IntToStr(FAssertsFail);

  if FAssertsFail > 0 then
  begin
    Result := Result + #13 + 'Falhas:';
    for I := 0 to FFalhas.Count - 1 do
      Result := Result + #13 + '  * ' + FFalhas[I];
  end;
end;
{$endRegion}
