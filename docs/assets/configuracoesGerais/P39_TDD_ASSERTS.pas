uses P39_TDD_CONSTANTES, P39_TDD_CASOS_DE_TESTE;

const
  JSON_CONFIG =
    '{' +
    '"erro":{' +
      '"quantidade":10,' +
//      '"operacao":"Igual, Maior, Menor"' +
      '"operacao":"Igual"' +
    '},' +
    '"valor":[{' +
      '"campo":"VALOR_BRUTO_DOCFAT",' +
    //  '"operacao":"Igual, Maior, Menor",' +
      '"operacao":"Maior",' +
      '"resultado":155.015' +
    '}],' +
    '"tempo":{' +
      '"tempo_total":10000,' +
      '"tipo_registo":"data, hora, minuto, segundo, milisegundo"' +
    '}' +
    '}';

  cOperacaoIgual = 0;
  cOperacaoMaior = 1;
  cOperacaoMenor = 2;

  cTipoData = 'data';
  cTipoHora = 'hora';
  cTipoDataHora = 'data/hora';
  cTipoMinuto = 'minuto';
  cTipoMinutoSegundo = 'minuto/segundo';
  cTipoSegundo = 'segundo';

var
  FJSONResultadoEsperado: String;
  CDSErro: TClientDataSet;
  CDSValor: TClientDataSet;
  CDSTempo: TClientDataSet;
  FEstruturaCriada: Boolean;
  FDebugMode: Boolean;

procedure SetDebugMode(Value: Boolean);
begin
  FDebugMode := Value;
end;

procedure MostrarLogTextoEmModoDebug(const Msg: String);
begin
  if FDebugMode then
    MostrarLogTexto(Msg, '[DEBUG]');
end;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Centralizacao de asserts e debug para os testes TDD.' + #13 + #13 +
    'Metodos disponibilizados:' + #13 +
    ' - procedure SetDebugMode(Value: Boolean)' + #13 +
    '   + Liga/desliga o modo debug globalmente.' + #13 +
    ' - procedure MostrarLogTextoEmModoDebug(const Msg: String)' + #13 +
    '   + Exibe log apenas se modo debug estiver ativo.' + #13 + #13 +
    'Uso: chamar SetDebugMode(True) no inicio do teste para ativar logs de debug.';
  MostrarLogTexto(lInstrucoes, 'Instrucoes TDD_ASSERTS');
end;

procedure MontarEstruturaValidacao;
var
  FJSON: String;
begin
  if not FEstruturaCriada then
  begin
    CriarObjetos;
    CriarEstruturaObjetos;
  end;

  FJSON := JSON_CONFIG;

  CarregarEstruturaErro(FJSON);
  CarregarEstruturaValor(FJSON);
  CarregarEstruturaTempo(FJSON);
end;

procedure CarregarEstruturaErro(pJSON: String);
var Obj: TJSONObject;
begin
  try
    Obj := TJSONObject.ParseJSONValue(GetObjectJson(pJSON, 'erro'));
  except
    Obj := TJSONObject.Create;
  end;

  try
    if (Obj.Count > 0) then
      CDSErro.InsertRecord([StrToInt(GetValueJsonDef(Obj.ToJSON, 'quantidade', '-1')),
                            GetOperacao(GetValueJson(Obj.ToJSON, 'operacao'))]);

  finally
    Obj.Free;
  end;
end;

procedure CarregarEstruturaValor(pJson: String);
var
  Obj: TJSONObject;
  ArrayValor: TJSONArray;
  I : Integer;
  LCampo: String;
  LOperacao: Integer;
  LResultado: Currency;
begin
  ArrayValor := TJSONArray(TryParseJSONValue(GetArrayJsonOrEmpty(pJson, 'valor')));

  try
    if (ArrayValor.Count > 0) then
    begin
      for I := 0 to ArrayValor.Count -1 do
      begin
        Obj := TJSONObject.ParseJSONValue(GetObjectJson(ArrayValor.Items(I).ToJson, ''));

        if (GetValueJson(Obj.ToJSON, 'campo') = '') then
          raise Exception.Create(MensagemPersonalizada + 'Resultado esperado com campo para validar Valor NAO Informado.');

        LCampo := GetValueJsonDef(Obj.ToJSON, 'campo', '');
        LOperacao := GetOperacao(GetValueJson(Obj.ToJSON, 'operacao'));
        LResultado := StrToCurr(Troca(GetValueJsonDef(Obj.ToJSON, 'resultado', '0'), '.', ','));

        CDSValor.InsertRecord([LCampo, LOperacao, LResultado]);

      end;
    end;
  finally
    ArrayValor.Free;
  end;
end;

procedure CarregarEstruturaTempo(pJSON: String);
var Obj: TJSONObject;
begin
  try
    Obj := TJSONObject.ParseJSONValue(GetObjectJson(pJSON, 'tempo'));
  except
    Obj := TJSONObject.Create;
  end;

  try
    if (Obj.Count > 0) then
      CDSTempo.InsertRecord([StrToInt(GetValueJsonDef(Obj.ToJSON, 'tempo_total', '-1')),
                             GetValueJson(Obj.ToJSON, 'tipo_registo')]);

  finally
    Obj.Free;
  end;

  MostrarCDS(CDSTempo, true, 'CDS Tempo');
end;

function GetOperacao(pOperacao: String): Integer;
var S: String;
begin
  if pOperacao = 'Igual' then
    Result := cOperacaoIgual
  else if pOperacao = 'Maior' then
    Result := cOperacaoMaior
  else if pOperacao = 'Menor' then
    Result := cOperacaoMenor
  else
    Result := -1;
end;

procedure Limpar;
begin
  CDSErro.ApagarRegistros('');
  CDSValor.ApagarRegistros('');
  CDSTempo.ApagarRegistros('');
end;

procedure CriarObjetos;
begin
  CDSErro  := TClientDataSet.Create;
  CDSValor := TClientDataSet.Create;
  CDSTempo := TClientDataSet.Create;
end;

procedure CriarEstruturaObjetos;
begin
  CDSErro.FieldDefs.Clear;
  CDSErro.FieldDefs.Add('QUANTIDADE', ftInteger, 0, False);
  CDSErro.FieldDefs.Add('OPERACAO', ftInteger, 0, False);
  CDSErro.CreateDataSet;
  CDSErro.LogChanges := False;

  CDSValor.FieldDefs.Clear;
  CDSValor.FieldDefs.Add('CAMPO', ftString, 50, False);
  CDSValor.FieldDefs.Add('OPERACAO', ftInteger, 0, False);
  CDSValor.FieldDefs.Add('RESULTADO', ftCurrency, 0, False);
  CDSValor.CreateDataSet;
  CDSValor.LogChanges := False;

  CDSTempo.FieldDefs.Clear;
  CDSTempo.FieldDefs.Add('TEMPO_TOTAL', ftInteger, 0, False);
  CDSTempo.FieldDefs.Add('TIPO_REGISTRO', ftString, 20, False);
  CDSTempo.CreateDataSet;
  CDSTempo.LogChanges := False;

  FEstruturaCriada := True;
end;