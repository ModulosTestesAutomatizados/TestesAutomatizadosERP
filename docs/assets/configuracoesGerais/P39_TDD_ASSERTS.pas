uses P39_TDD_CONSTANTES;

var
  FDebugMode: Boolean;

procedure SetDebugMode(Value: Boolean);
begin
  FDebugMode := Value;
end;

function IsDebugMode: Boolean;
begin
  Result := FDebugMode;
end;

procedure MostrarLogTextoEmModoDebug(const Msg: String);
begin
  if FDebugMode then
    MostrarLogTexto(Msg, '[DEBUG]');
end;

procedure AssertTrue(const Condicao: Boolean; const Msg: String = '');
begin
  if not Condicao then
    raise Exception.Create('[ASSERT] ' + Msg);
end;

procedure AssertEquals(const Esperado, Atual: Variant; const Msg: String = '');
var
  lMsg: String;
begin
  if Esperado <> Atual then
  begin
    lMsg := '[ASSERT] ';
    if Msg <> '' then
      lMsg := lMsg + Msg + ' - ';
    lMsg := lMsg + 'Esperado: ' + VarToStr(Esperado) + ', Atual: ' + VarToStr(Atual);
    raise Exception.Create(lMsg);
  end;
end;

procedure AssertNotEquals(const NaoEsperado, Atual: Variant; const Msg: String = '');
var
  lMsg: String;
begin
  if NaoEsperado = Atual then
  begin
    lMsg := '[ASSERT] ';
    if Msg <> '' then
      lMsg := lMsg + Msg + ' - ';
    lMsg := lMsg + 'Não esperado: ' + VarToStr(NaoEsperado) + ', mas Atual: ' + VarToStr(Atual);
    raise Exception.Create(lMsg);
  end;
end;

procedure Main;
var
  lInstrucoes: String;
begin
  lInstrucoes := 'Centralizacao de asserts e debug para os testes TDD.' + #13 + #13 +
    'Metodos disponibilizados:' + #13 +
    ' - procedure SetDebugMode(Value: Boolean)' + #13 +
    '   + Liga/desliga o modo debug globalmente.' + #13 +
    ' - function IsDebugMode: Boolean' + #13 +
    '   + Retorna se modo debug esta ativo.' + #13 +
    ' - procedure MostrarLogTextoEmModoDebug(const Msg: String)' + #13 +
    '   + Exibe log apenas se modo debug estiver ativo.' + #13 +
    ' - procedure AssertTrue(Condicao, Msg)' + #13 +
    '   + Falha se condicao for False.' + #13 +
    ' - procedure AssertEquals(Esperado, Atual, Msg)' + #13 +
    '   + Falha se valores forem diferentes.' + #13 +
    ' - procedure AssertNotEquals(NaoEsperado, Atual, Msg)' + #13 +
    '   + Falha se valores forem iguais.' + #13 + #13 +
    'Uso: chamar SetDebugMode(True) no inicio do teste para ativar logs de debug.' + #13 +
    'Usar Assert* para validacoes nos casos de teste.';
  MostrarLogTexto(lInstrucoes, 'Instrucoes TDD_ASSERTS');
end;