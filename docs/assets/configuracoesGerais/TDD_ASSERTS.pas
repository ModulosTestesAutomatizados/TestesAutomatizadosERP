uses P39_TDD_CONSTANTES, P39_TDD_FUNCOES_JSON;

{ ================================================================
  TDD_ASSERTS - Validação de resultados (Actual vs Expected)
  
  Compara resultado atual com esperado (JSON) para validar o teste.
  Suporta operações: Igual (0), Maior (1), Menor (2), Contém (3), Schema (4)
  ================================================================ }

const
  // Operações de comparação
  cOpIgual     = 0;  // actual == expected
  cOpMaior     = 1;  // actual > expected
  cOpMenor     = 2;  // actual < expected
  cOpContem    = 3;  // actual contém expected (substring/array)
  cOpSchema    = 4;  // valida schema/estrutura

type
  TValidacaoResultado = record
    Sucesso: Boolean;
    Campo: String;
    Mensagem: String;
    ValorAtual: String;
    ValorEsperado: String;
    Operacao: Integer;
  end;

  TArrayValidacaoResultado = array of TValidacaoResultado;

var
  FValidacoes: TArrayValidacaoResultado;

{ ================================================================
  COMPARAÇÃO DE JSON (Actual vs Expected)
  ================================================================ }

function ValidarResultadoEsperado(const ResultadoAtual, ResultadoEsperado: String): Boolean;
var
  lAtualObj, lEsperadoObj: TJSONObject;
  lCampos: TJSONArray;
  lCampoNome: String;
  lValorAtual, lValorEsperado: String;
  lOperacao: Integer;
  lIgual: Boolean;
  i: Integer;
  lValidacao: TValidacaoResultado;
begin
  Result := False;
  SetLength(FValidacoes, 0);

  try
    lAtualObj := TJSONObject.ParseJSONValue(ResultadoAtual) as TJSONObject;
    lEsperadoObj := TJSONObject.ParseJSONValue(ResultadoEsperado) as TJSONObject;

    if not Assigned(lAtualObj) or not Assigned(lEsperadoObj) then
    begin
      AdicionarValidacao('', 'JSON inválido para comparação', '', '', -1, False);
      Exit;
    end;

    // O JSON esperado deve ter array "campos" com: campo, operacao, valor
    lCampos := lEsperadoObj.Get('campos') as TJSONArray;
    if not Assigned(lCampos) then
    begin
      // Comparação simples: JSONs idênticos
      Result := lAtualObj.ToJSON = lEsperadoObj.ToJSON;
      AdicionarValidacao('JSON_COMPLETO', 'Comparação completa', lAtualObj.ToJSON, lEsperadoObj.ToJSON, cOpIgual, Result);
      Exit;
    end;

    Result := True;
    for i := 0 to lCampos.Count - 1 do
    begin
      lCampoNome := lCampos.Items[i].GetValue<String>('campo');
      lOperacao := lCampos.Items[i].GetValue<Integer>('operacao');
      lValorEsperado := lCampos.Items[i].GetValue<String>('valor');

      if not lAtualObj.TryGetValue(lCampoNome, lValorAtual) then
      begin
        AdicionarValidacao(lCampoNome, 'Campo não encontrado no resultado atual', '', lValorEsperado, lOperacao, False);
        Result := False;
        Continue;
      end;

      case lOperacao of
        cOpIgual:   lIgual := (lValorAtual = lValorEsperado);
        cOpMaior:   lIgual := CompararNumeros(lValorAtual, lValorEsperado) > 0;
        cOpMenor:   lIgual := CompararNumeros(lValorAtual, lValorEsperado) < 0;
        cOpContem:  lIgual := Pos(lValorEsperado, lValorAtual) > 0;
        cOpSchema:  lIgual := ValidarSchema(lValorAtual, lValorEsperado);
      else
        lIgual := False;
      end;

      AdicionarValidacao(lCampoNome, '', lValorAtual, lValorEsperado, lOperacao, lIgual);

      if not lIgual then
        Result := False;
    end;

  except
    on E: Exception do
    begin
      AdicionarValidacao('', 'Erro na validação: ' + E.Message, '', '', -1, False);
      Result := False;
    end;
  end;
end;

function CompararNumeros(const Atual, Esperado: String): Integer;
var
  lAtual, lEsperado: Double;
begin
  Result := 0;
  try
    lAtual := StrToFloat(Atual);
    lEsperado := StrToFloat(Esperado);
    if lAtual > lEsperado then Result := 1
    else if lAtual < lEsperado then Result := -1;
  except
    // Se não for número, compara como string
    if Atual > Esperado then Result := 1
    else if Atual < Esperado then Result := -1;
  end;
end;

function ValidarSchema(const Atual, SchemaJson: String): Boolean;
var
  lAtualObj, lSchemaObj: TJSONObject;
begin
  Result := False;
  try
    lAtualObj := TJSONObject.ParseJSONValue(Atual) as TJSONObject;
    lSchemaObj := TJSONObject.ParseJSONValue(SchemaJson) as TJSONObject;
    if Assigned(lAtualObj) and Assigned(lSchemaObj) then
      Result := SchemaValido(lAtualObj, lSchemaObj);
  except end;
end;

function SchemaValido(const Atual, Schema: TJSONObject): Boolean;
var
  lChave: String;
  lSchemaVal: TJSONValue;
  i: Integer;
begin
  Result := True;
  for i := 0 to Schema.Count - 1 do
  begin
    lChave := Schema.Get(i).JsonString.Value;
    lSchemaVal := Schema.Get(lChave);
    
    if not Atual.TryGetValue(lChave, lSchemaVal) then
    begin
      Result := False;
      Break;
    end;
    
    // Se o schema define tipo, validar
    if lSchemaVal is TJSONObject then
    begin
      var lTipo := lSchemaVal.AsObject.GetValue<String>('tipo');
      if lTipo <> '' then
      begin
        var lAtualVal := Atual.GetValue<TJSONValue>(lChave);
        if not ValidarTipo(lAtualVal, lTipo) then
        begin
          Result := False;
          Break;
        end;
      end;
    end;
  end;
end;

function ValidarTipo(const Valor: TJSONValue; const Tipo: String): Boolean;
begin
  Result := False;
  if not Assigned(Valor) then Exit;
  
  if Tipo = 'string' then Result := Valor is TJSONString
  else if Tipo = 'number' then Result := Valor is TJSONNumber
  else if Tipo = 'boolean' then Result := Valor is TJSONTrue or Valor is TJSONFalse
  else if Tipo = 'array' then Result := Valor is TJSONArray
  else if Tipo = 'object' then Result := Valor is TJSONObject
  else if Tipo = 'null' then Result := Valor is TJSONNull;
end;

procedure AdicionarValidacao(const Campo, Mensagem, Atual, Esperado: String; Operacao: Integer; Sucesso: Boolean);
var
  lIdx: Integer;
begin
  lIdx := Length(FValidacoes);
  SetLength(FValidacoes, lIdx + 1);
  FValidacoes[lIdx].Campo := Campo;
  FValidacoes[lIdx].Mensagem := Mensagem;
  FValidacoes[lIdx].ValorAtual := Atual;
  FValidacoes[lIdx].ValorEsperado := Esperado;
  FValidacoes[lIdx].Operacao := Operacao;
  FValidacoes[lIdx].Sucesso := Sucesso;
end;

function GetValidacoes: TArrayValidacaoResultado;
begin
  Result := FValidacoes;
end;

function GetResumoValidacao: String;
var
  lV: TValidacaoResultado;
  lTotal, lOk: Integer;
begin
  lTotal := Length(FValidacoes);
  lOk := 0;
  Result := '=== RESUMO VALIDAÇÃO ===' + #13;
  Result := Result + 'Total: ' + IntToStr(lTotal) + #13;
  
  for lV in FValidacoes do
  begin
    if lV.Sucesso then
      Inc(lOk);
    Result := Result + '  [' + IfThen(lV.Sucesso, 'OK', 'FALHA') + '] ' + lV.Campo;
    if lV.Mensagem <> '' then
      Result := Result + ' - ' + lV.Mensagem;
    Result := Result + ' (Atual: ' + lV.ValorAtual + ', Esperado: ' + lV.ValorEsperado + ', Op: ' + IntToStr(lV.Operacao) + ')' + #13;
  end;
  
  Result := Result + 'Sucesso: ' + IntToStr(lOk) + '/' + IntToStr(lTotal) + #13;
end;

function IfThen(Condicao: Boolean; const Verdadeiro, Falso: String): String;
begin
  if Condicao then Result := Verdadeiro else Result := Falso;
end;

procedure Main;
var
  lInstrucoes: String;
begin
  lInstrucoes := 'TDD_ASSERTS - Validação de resultados (Actual vs Expected).' + #13 + #13 +
    'Método principal:' + #13 +
    '  function ValidarResultadoEsperado(const ResultadoAtual, ResultadoEsperado: String): Boolean' + #13 + #13 +
    'JSON Esperado (schema de validação):' + #13 +
    '{' + #13 +
    '  "campos": [' + #13 +
    '    { "campo": "VALOR_TOTAL", "operacao": 0, "valor": "100.00" },' + #13 +
    '    { "campo": "QUANTIDADE", "operacao": 1, "valor": "10" },' + #13 +
    '    { "campo": "STATUS", "operacao": 3, "valor": "APROVADO" },' + #13 +
    '    { "campo": "DADOS", "operacao": 4, "valor": "{ \"tipo\": \"object\" }" }' + #13 +
    '  ]' + #13 +
    '}' + #13 + #13 +
    'Operações:' + #13 +
    '  0 = Igual (string/number exato)' + #13 +
    '  1 = Maior (numérico)' + #13 +
    '  2 = Menor (numérico)' + #13 +
    '  3 = Contém (substring/array)' + #13 +
    '  4 = Schema (valida estrutura/tipos)' + #13 + #13 +
    'Retorna: Boolean (True = todas passaram)' + #13 +
    'Use GetResumoValidacao() para detalhes das falhas.';
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_ASSERTS');
end;