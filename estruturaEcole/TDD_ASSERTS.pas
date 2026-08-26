uses P39_TDD_CASOS_DE_TESTE;

{
  Unit base para estruturas de validacao de casos de teste.
  
  Fornece constantes e funcoes auxiliares para comparacao de resultados:
    - cOperacaoIgual, cOperacaoMaior, cOperacaoMenor: tipos de operacao
    - GetOperacao: converte string para constante de operacao
  
  Esta unit e herdada por TDD_FAT_VALIDAR_RESULTADO e outras units
  de validacao de modulo.
}

const
  JSON_CONFIG =
    '{' +
    '"erro":{' +
      '"quantidade":10,' +
      '"operacao":"Igual"' + 
    '},' +
    '"valor":[{' +
      '"campo":"VALOR_BRUTO_DOCFAT",' +
      '"operacao":"Maior",' + 
      '"resultado":155.015' +
    '}],' +
    '"tempo":{' +
      '"tempo_total":10000,' +
      '"tipo_registo":"milisegundo"' +
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

procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes :=
    'Unit base para estruturas de validacao de casos de teste.' + #13 +
    'Fornece constantes e funcoes auxiliares para comparacao de resultados.' + #13 + #13 +
    'Constantes exportadas:' + #13 +
    ' - cOperacaoIgual (0), cOperacaoMaior (1), cOperacaoMenor (2)' + #13 + #13 +
    'Funcoes exportadas:' + #13 +
    ' - function GetOperacao(pOperacao: String): Integer' + #13 +
    '   + Converte string ("Igual", "Maior", "Menor") para constante.';
  MostrarLogTexto(lInstrucoes, 'Instrucoes TDD_ASSERTS');
end;

function GetOperacao(pOperacao: String): Integer;
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
