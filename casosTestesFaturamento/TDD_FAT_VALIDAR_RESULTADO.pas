uses P39_TDD_CASOS_DE_TESTE, P39_TDD_FUNCOES_JSON;

{
  Unit de validacao do resultado esperado dos casos de teste de faturamento.
  
  Orquestra toda a logica de comparacao entre o resultado esperado (JSON)
  e os dados reais obtidos durante a execucao do caso de teste.
  
  Secoes do JSON de resultado esperado:
    - "erro":    quantidade de erros esperados e operacao de comparacao
    - "valor":   array de campos a validar nos CDS do formulario
    - "tempo":   limite de tempo de execucao
  
  Cada item do array "valor" deve conter:
    - "cds":      nome do TClientDataSet (opcional, padrao "CDSCad")
    - "campo":    nome do campo no CDS
    - "operacao": "Igual" | "Maior" | "Menor"
    - "resultado": valor esperado (numerico)
  
  Exemplo de JSON resultado esperado:
  {
    "erro":    {"quantidade":0, "operacao":"Igual"},
    "valor": [
      {"cds":"CDSCad",  "campo":"VALOR_BRUTO_DOCFAT", "operacao":"Maior", "resultado":155.015},
      {"cds":"CDSPedido","campo":"TABELA_DOCPED",     "operacao":"Igual", "resultado":0}
    ],
    "tempo":   {"tempo_total":10000, "tipo_registo":"milisegundo"}
  }
}

{$Region 'Constantes'}
const
  cMSecsPorDia = 86400000; // 24h * 60m * 60s * 1000ms: converte TDateTime p/ ms
  cCDSDefault  = 'CDSCad'; // CDS padrao quando tag "cds" nao informada
  
  cOperacaoIgual = 0;
  cOperacaoMaior = 1;
  cOperacaoMenor = 2;
{$endRegion}

{$Region 'Variaveis'}
var
  FCDSMap: TStringList;          // Mapa nome -> TClientDataSet
  FDivergencias: TStringList;    // Acumulado de divergencias encontradas
  FDTInicioCronometro: TDateTime;
  FTempoExecucaoMs: Double;
  FErrosReais: Integer;
{$endRegion}

procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes :=
    'Unit de validacao do resultado esperado dos casos de teste de faturamento.' + #13 +
    'Faz a ponte entre o nucleo do fluxo e os CDSComponents' + #13 +
    'do formulario, comparando os campos configurados no JSON de resultado esperado.' + #13 + #13 +
    'Metodos exportados:' + #13 +
    ' - procedure RegistrarCDS(pNome: String; pCDS: TClientDataSet)' + #13 +
    '   + Registra um CDS no mapa para uso na comparacao de valores.' + #13 +
    ' - procedure Cronometro_Iniciar / Cronometro_Finalizar' + #13 +
    '   + Mede o tempo total de execucao do caso (em milissegundos).' + #13 +
    ' - procedure RegistrarErroReal(pDescricao: String)' + #13 +
    '   + Incrementa o contador de erros reais (secao "erro.quantidade").' + #13 +
    ' - function CompararResultadoEsperado(pIDCasoTeste: Integer): Boolean' + #13 +
    '   + Executa a validacao completa: erro, valores e tempo.' + #13 +
    '     Retorna True quando nao ha divergencias.' + #13 + #13 +
    'Formato do array "valor":' + #13 +
    '  - "cds": nome do CDS a consultar (ex: "CDSCad", "CDSFiscal", "CDSPedido").' + #13 +
    '           Se omitido, usa o CDS padrao (CDSCad).' + #13 +
    '  - "campo": nome do campo no CDS informado.' + #13 +
    '  - "operacao": "Igual" | "Maior" | "Menor".' + #13 +
    '  - "resultado": valor esperado (numerico).';
  MostrarLogTexto(lInstrucoes, 'Instrucoes TDD_FAT_VALIDAR_RESULTADO');
end;

{$Region 'Mapa de CDS'}

procedure InicializarMapa;
begin
  if FCDSMap = nil then
  begin
    FCDSMap := TStringList.Create;
    FCDSMap.Sorted     := True;
    FCDSMap.Duplicates := dupIgnore;
  end;

  if FDivergencias = nil then
    FDivergencias := TStringList.Create;
end;

procedure RegistrarCDS(pNome: String; pCDS: TClientDataSet);
var I: Integer;
begin
  InicializarMapa;

  I := FCDSMap.IndexOf(pNome);
  if I >= 0 then
    FCDSMap.Objects[I] := pCDS
  else
    FCDSMap.AddObject(pNome, pCDS);
end;

function ObterCDS(pNome: String): TClientDataSet;
var I: Integer;
begin
  Result := nil;

  if FCDSMap = nil then
    Exit;

  I := FCDSMap.IndexOf(pNome);
  if I >= 0 then
    Result := TClientDataSet(FCDSMap.Objects[I]);
end;
{$endRegion}

{$Region 'Cronometro'}

procedure Cronometro_Iniciar;
begin
  FDTInicioCronometro := Now;
  FTempoExecucaoMs    := 0;
  FErrosReais         := 0;
end;

procedure Cronometro_Finalizar;
begin
  if FDTInicioCronometro = 0 then
    Exit;

  FTempoExecucaoMs := (Now - FDTInicioCronometro) * cMSecsPorDia;
end;

procedure RegistrarErroReal(pDescricao: String);
begin
  FErrosReais := FErrosReais + 1;
  LogDoProcessamentoAdd('Erro real registrado ("erro.quantidade"): ' + pDescricao);
end;
{$endRegion}

{$Region 'Divergencias'}

procedure ZerarDivergencias;
begin
  FDivergencias.Clear;
end;

procedure RegistrarDivergencia(pMsg: String);
begin
  FDivergencias.Add(' * ' + pMsg);
end;

function HaDivergencias: Boolean;
begin
  Result := (FDivergencias.Count > 0);
end;

function MensagensDivergencias: String;
var I: Integer;
begin
  Result := '';
  for I := 0 to FDivergencias.Count - 1 do
    Result := Result + #13 + FDivergencias[I];
end;
{$endRegion}

{$Region 'Comparacoes internas'}

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

function Arredondar(pValor: Currency; pCasas: Integer): Currency;
var lFator: Currency;
  I: Integer;
begin
  lFator := 1;
  for I := 1 to pCasas do
    lFator := lFator * 10;

  Result := Round(pValor * lFator) / lFator;
end;

function AplicarOperacaoNumerica(pOperacao: Integer; pValorReal, pValorEsperado: Currency): Boolean;
begin
  Result := False;

  if pOperacao = cOperacaoIgual then
    Result := (Arredondar(pValorReal, 2) = Arredondar(pValorEsperado, 2))
  else if pOperacao = cOperacaoMaior then
    Result := (pValorReal > pValorEsperado)
  else if pOperacao = cOperacaoMenor then
    Result := (pValorReal < pValorEsperado);
end;

function OperacaoDescricao(pOperacao: Integer): String;
begin
  if pOperacao = cOperacaoIgual then
    Result := 'igual a'
  else if pOperacao = cOperacaoMaior then
    Result := 'maior que'
  else if pOperacao = cOperacaoMenor then
    Result := 'menor que'
  else
    Result := '(operacao invalida)';
end;

function ValorCurrencyTag(pJSON, pTag: String; pDefault: Currency): Currency;
var lValor: String;
begin
  lValor := GetValueJsonDef(pJSON, pTag, '');
  if lValor = '' then
    Result := pDefault
  else
    Result := StrToCurr(Troca(lValor, '.', ','));
end;
{$endRegion}

{$Region 'Comparacao por secao do JSON'}

function CompararQuantidadeErros(pJSON: String): Boolean;
var
  lSecaoErro: String;
  lQtdEsperada: Integer;
  lOperacao: Integer;
begin
  Result := True;

  lSecaoErro := GetObjectJson(pJSON, 'erro');
  if lSecaoErro = '' then
    Exit;

  lQtdEsperada := StrToIntDef(GetValueJsonDef(lSecaoErro, 'quantidade', '-1'), -1);
  lOperacao    := GetOperacao(GetValueJson(lSecaoErro, 'operacao'));

  if lQtdEsperada < 0 then
    Exit;

  Result := AplicarOperacaoNumerica(lOperacao, FErrosReais, lQtdEsperada);

  if not Result then
    RegistrarDivergencia('Quantidade de erros: esperado ' + OperacaoDescricao(lOperacao) + ' ' +
      IntToStr(lQtdEsperada) + ', obtido ' + IntToStr(FErrosReais) + '.');
end;

function CompararValorItem(pJSONItem: String): Boolean;
var
  lCDSNome, lCampo: String;
  lOperacao: Integer;
  lResultado, lReal: Currency;
  lCDS: TClientDataSet;
begin
  Result := True;

  lCDSNome  := GetValueJsonDef(pJSONItem, 'cds', cCDSDefault);
  lCampo    := GetValueJsonDef(pJSONItem, 'campo', '');
  lOperacao := GetOperacao(GetValueJson(pJSONItem, 'operacao'));
  lResultado := ValorCurrencyTag(pJSONItem, 'resultado', 0);

  if lCampo = '' then
  begin
    RegistrarDivergencia('Valor: campo nao informado.');
    Result := False;
    Exit;
  end;

  lCDS := ObterCDS(lCDSNome);
  if lCDS = nil then
  begin
    RegistrarDivergencia('Valor: CDS "' + lCDSNome + '" nao registrado.');
    Result := False;
    Exit;
  end;

  if (not lCDS.Active) or lCDS.IsEmpty then
  begin
    RegistrarDivergencia('Valor: CDS "' + lCDSNome + '" vazio ou inativo.');
    Result := False;
    Exit;
  end;

  try
    lReal := lCDS.FieldByName(lCampo).AsCurrency;
    Result := AplicarOperacaoNumerica(lOperacao, lReal, lResultado);

    if not Result then
      RegistrarDivergencia(lCDSNome + '.' + lCampo + ': esperado ' +
        OperacaoDescricao(lOperacao) + ' ' + CurrToStr(lResultado) +
        ', obtido ' + CurrToStr(lReal) + '.');
  except
    on E: Exception do
    begin
      RegistrarDivergencia(lCDSNome + '.' + lCampo + ': erro ao obter valor (' + E.Message + ').');
      Result := False;
    end;
  end;
end;

function CompararValores(pJSON: String): Boolean;
var
  lArrayValor: String;
  I: Integer;
  lItemJSON: String;
  lOkGeral: Boolean;
begin
  Result := True;
  lOkGeral := True;

  lArrayValor := GetArrayJsonOrEmpty(pJSON, 'valor');
  if lArrayValor = '' then
    Exit;

  // Processa cada item do array usando indices
  I := 0;
  while True do
  begin
    lItemJSON := GetArrayJsonItem(lArrayValor, I);
    if lItemJSON = '' then
      Break;

    if not CompararValorItem(lItemJSON) then
      lOkGeral := False;

    I := I + 1;
  end;

  Result := lOkGeral;
end;

function CompararTempo(pJSON: String): Boolean;
var
  lSecaoTempo: String;
  lLimite: Integer;
  lTipoRegistro: String;
  lFatorMs: Double;
  S: String;
begin
  Result := True;

  if FDTInicioCronometro = 0 then
    Exit;

  lSecaoTempo := GetObjectJson(pJSON, 'tempo');
  if lSecaoTempo = '' then
    Exit;

  lLimite       := StrToIntDef(GetValueJsonDef(lSecaoTempo, 'tempo_total', '-1'), -1);
  lTipoRegistro := GetValueJson(lSecaoTempo, 'tipo_registo');

  if (lLimite <= 0) or (FTempoExecucaoMs <= 0) then
    Exit;

  // Converte o limite para milissegundos (testar substrings maiores primeiro).
  lFatorMs := 1;
  S := LowerCase(Trim(lTipoRegistro));

  if Pos('milisegundo', S) > 0 then
    lFatorMs := 1
  else if Pos('minuto', S) > 0 then
    lFatorMs := 60000
  else if Pos('segundo', S) > 0 then
    lFatorMs := 1000;

  Result := (FTempoExecucaoMs <= (lLimite * lFatorMs));

  if not Result then
    RegistrarDivergencia('Tempo de execucao: limite de ' +
      FloatToStr(lLimite * lFatorMs) + ' ms, obtido ' + FloatToStr(FTempoExecucaoMs) + ' ms.');
end;
{$endRegion}

{$Region 'Orquestracao principal'}

procedure FinalizarComparacao(pIDCasoTeste: Integer; pValidado: Boolean);
begin
  LogDoProcessamentoAdd('==================================================');

  if pValidado then
    LogDoProcessamentoAdd('Caso de Teste [' + IntToStr(pIDCasoTeste) + ']: resultado esperado VALIDADO sem divergencias.')
  else
  begin
    LogDoProcessamentoAdd('Caso de Teste [' + IntToStr(pIDCasoTeste) + ']: DIVERGENCIAS ENCONTRADAS');
    LogDoProcessamentoAdd(MensagensDivergencias);

    EnviarMensagemInterna(Nome_Usuario_Atual,
      'Teste Automatizado - Divergencias!',
      'Caso de Teste [' + IntToStr(pIDCasoTeste) + ']:' + #13 + MensagensDivergencias);
  end;

  LogDoProcessamentoAdd('==================================================');
end;

function CompararComJSON(pIDCasoTeste: Integer; pJSON: String): Boolean;
begin
  Result := False;
  ZerarDivergencias;

  if Trim(pJSON) = '' then
  begin
    RegistrarDivergencia('JSON de resultado esperado vazio para o caso de teste [' +
      IntToStr(pIDCasoTeste) + '].');
    FinalizarComparacao(pIDCasoTeste, False);
    Exit;
  end;

  CompararQuantidadeErros(pJSON);
  CompararValores(pJSON);
  CompararTempo(pJSON);

  Result := not HaDivergencias;
  FinalizarComparacao(pIDCasoTeste, Result);
end;

function CompararResultadoEsperado(pIDCasoTeste: Integer): Boolean;
var lJSON: String;
begin
  InicializarMapa;

  // Busca o JSON no CDSResultadoEsperado (indexado por ID).
  lJSON := '';
  if CDSResultadoEsperado.FindKey([pIDCasoTeste]) then
    lJSON := CDSResultadoEsperado.FieldByName('RESULTADO_ESPERADO').AsString;

  Result := CompararComJSON(pIDCasoTeste, lJSON);
end;
{$endRegion}
