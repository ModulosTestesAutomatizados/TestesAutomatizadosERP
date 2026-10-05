uses P39_TDD_FAT_DOCUMENTO_FATURA, P39_TDD_ASSERTS;

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
  FDTInicioCronometro: TDateTime;
  FTempoExecucaoMs: Double;
  FErrosReais: Integer;
  
  {$Region 'VariÃ¡veis de ValidaÃ§Ã£o'}
    lResultadoString: String;
    lResultadoInteger: Integer;
    lResultadoCurrency: Currency;
    lResultadoData: TDateTime;
    lResultadoBoolean: Boolean;
  {$endRegion}
  
{$endRegion}

procedure Main;
begin
 
end;

{$Region 'Cronometro'}

procedure Cronometro_Iniciar;
begin
  FDTInicioCronometro := Now;
  FTempoExecucaoMs    := 0;
  FErrosReais         := 0;
  AssertsZerar;
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

function AplicarOperacaoNumerica(pOperacao: Integer; pValorReal, pValorEsperado: Currency): Boolean;
begin
  Result := False;

  if pOperacao = cOperacaoIgual then
    Result := (pValorReal = pValorEsperado)
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
{$endRegion}

{$Region 'Comparacao por secao do JSON'}

procedure CompararQuantidadeErros(pJSON: String);
var
  lSecaoErro: String;
  lQtdEsperada: Integer;
  lOperacao: Integer;
  lMensagem: String;
begin
  lQtdEsperada := StrToIntDef(GetValueJsonDef(lSecaoErro, 'quantidade', '-1'), -1);
  lOperacao    := GetOperacao(GetValueJson(lSecaoErro, 'operacao'));

  if lQtdEsperada < 0 then
    Exit;

  lMensagem := 'erro.quantidade: esperado ' + OperacaoDescricao(lOperacao) + ' ' +
    IntToStr(lQtdEsperada) + ', obtido ' + IntToStr(FErrosReais) + '.';

  if lOperacao = cOperacaoIgual then
    AssertIgualInteiro(lQtdEsperada, FErrosReais, 'erro.quantidade')
  else
    AssertVerdadeiro(AplicarOperacaoNumerica(lOperacao, FErrosReais, lQtdEsperada), lMensagem);
end;

procedure LimparVariaveis;
begin
  lResultadoString := '';
  lResultadoInteger := 0;
  lResultadoCurrency := 0;
  lResultadoData := 0;
  lResultadoBoolean := False;
end;

procedure CompararValor(pJSONItem: String);
var
  lCDSNome, lCampo, lDataSetName, lDMNome: String;
  lOperacao, I: Integer;
  lResultado, lTipoCampo: String;
  lCDS: TClientDataSet;
  lReal: Currency;
  lMensagem: String;
  lDM: TDataModule;
begin
  LogDoProcessamentoAdd('Comparando Item'); 
  LimparVariaveis;
  
  lCampo     := GetValueJsonDef(pJSONItem, 'campo', '');
  lOperacao  := GetOperacao(GetValueJsonDef(pJSONItem, 'operacao', '-1'));
  lTipoCampo := GetValueJsonDef(pJSONItem, 'tipo_campo', 'ftString');
  lResultadoString := {P39_TDD_FUNCOES_JSON}ValorStringTag(pJSONItem, 'resultado');
  
  if lCampo = '' then
  begin
    AssertFalhou('Valor', '(campo nao informado).');
    Exit;
  end;

  if lTipoCampo = '' then
  begin
    AssertFalhou('Tipo Campo', '(tipo do campo nao informado).');
    Exit;
  end;
  
  if (lTipoCampo = 'ftString') and (lOperacao <> cOperacaoIgual) then
  begin
    AssertFalhou('tipo Campo', 'Campo String a operaÃ§Ã£o deve ser Igual');
    Exit;
  end;

  if lOperacao = -1 then
  begin
    AssertFalhou('Valor', '(OperaÃ§Ã£o -1 InvÃ¡lida).');
    Exit;
  end;  

  for I := 0 to FDataSets.Count -1 do
  begin
    lDataSetName := FDataSets[I];
    lDMNome := CorteApos(lDataSetName, '|');
    lCDSNome := CorteAte(lDataSetName, '|');
    
    if lDMNome <> '' then
      lDM := DMCriadoPeloNome(lDMNome);
      
    if Assigned(lDM) then
      lCDS := lDM.FindComponent(lCDSNome)
    else
      lCDS := FonteDeDados(lCDS);
      
    if Assigned(lCDS) then
    begin
      // Campo nÃ£o estÃ¡ neste CDS
      if lCDS.FindField(lCampo) = Nil then
        Continue;
      
      if lOperacao = cOperacaoIgual then
        AssertIgual(lResultadoString, 
                    lCDS.FieldByName(lCampo).AsString, 
                    lCDS.FieldByName(lCampo).FieldName + '(' +  lCDS.FieldByName(lCampo).AsString + ' = (' + lResultado + ')')
      else
        CompararCampoPorTipo(lTipoCampo, 
                             lCDS.FieldByName(lCampo).AsString,
                             lResultadoString,
                             lOperacao,
                             lCampo);                   
       
    end;      
   
  end;
end;

procedure CompararValores(pJSON: String);
var
  lArrayValor: TJSONArray;
  I: Integer;
  lItemJSON: String;
begin  
  lArrayValor := TJSONArray(TryParseJSONValue(GetArrayJsonOrEmpty(pJSON, '')));
  if lArrayValor.Count = 0 then
  begin
    AssertFalhou('Valor','Valores de Resultado esperÃ¡do nÃ£o informados.');  
    Exit;
  end;
  
  for I := 0 to lArrayValor.Count -1 do
    CompararValor(lArrayValor.Items(I).ToJson); 
end;

procedure CompararTempo(pJSON: String);
var
  lSecaoTempo: String;
  lLimite: Integer;
  lTipoRegistro: String;
  lFatorMs: currency;
  S: String;
begin
  if FDTInicioCronometro = 0 then
    Exit;

  lSecaoTempo := GetObjectJson(pJSON, 'tempo');
  if lSecaoTempo = '' then
    Exit;

  lLimite       := StrToIntDef(GetValueJsonDef(lSecaoTempo, 'tempo_total', '-1'), -1);
  lTipoRegistro := GetValueJson(lSecaoTempo, 'tipo_registo');

  if (lLimite <= 0) or (FTempoExecucaoMs <= 0) then
    Exit;

  lFatorMs := 1;
  S := LowerCase(Trim(lTipoRegistro));

  if Pos('milisegundo', S) > 0 then
    lFatorMs := 1
  else if Pos('minuto', S) > 0 then
    lFatorMs := 60000
  else if Pos('segundo', S) > 0 then
    lFatorMs := 1000;

  AssertVerdadeiro(FTempoExecucaoMs <= (lLimite * lFatorMs),
    'tempo: limite de ' + CurrToStr(lLimite * lFatorMs) + ' ms, obtido ' +
    CurrToStr(FTempoExecucaoMs) + ' ms.');
end;
{$endRegion}

{$Region 'Orquestracao principal'}

procedure FinalizarComparacao(pValidado: Boolean);
begin
  LogDoProcessamentoAdd('==================================================');

  if pValidado then
    LogDoProcessamentoAdd('Caso de Teste [' + CDSCasosTestes.FieldByName('ID').AsString +
      ']: resultado esperado VALIDADO sem divergencias.')
  else
  begin
    LogDoProcessamentoAdd('Caso de Teste [' + CDSCasosTestes.FieldByName('ID').AsString +
      ']: DIVERGENCIAS ENCONTRADAS');
    LogDoProcessamentoAdd(AssertsResumo);

    //EnviarMensagemInterna(Nome_Usuario_Atual,
    //  'Teste Automatizado - Divergencias!',
    //  'Caso de Teste [' + CDSCasosTestes.FieldByName('CASOTESTE').AsString + ']:' + #13 + AssertsResumo);
  end;

  LogDoProcessamentoAdd('==================================================');
  MostrarLogTexto(LogDoProcessamento);
end;

procedure CompararComJSON(pJSON: String);
var 
  LObj: TJSONObject;
  LErro, LValor, LTempo: String;
  LAsserts: Boolean;
begin
  AssertsZerar;

  LAsserts := AssertsOk;
  
  try
      if Trim(pJSON) = '' then
    begin
      AssertFalhou('JSON', 'de resultado esperado vazio para o caso de teste [' +
        CDSCasosTestes.FieldByName('ID').AsString + '].');
      Exit;
    end;

    //MostrarLogTexto(pJSON);

    if TagExiste(pJSON, 'erro') then
    begin
      LErro := GetObjectJson(pJSON, 'erro');
      MostrarLogTexto(LErro);
      CompararQuantidadeErros(LErro);
    end;
           
    LValor := GetArrayJsonOrEmpty(pJSON, 'valor');
  
    //MostrarLogTexto(LValor);
    if LValor <> '[]' then
      CompararValores(LValor);
  
  
    if TagExiste(pJSON, 'tempo') then
    begin
      LTempo := GetObjectJson(pJSON, 'erro');
      MostrarLogTexto(LTempo);
      //CompararTempo(LTempo);
    end;  
  
  finally
    FinalizarComparacao(AssertsOk);
  end;
end;

Procedure CompararResultadoEsperado;
var lJSON: String;
begin
  lJSON := '';
  if CDSResultadoEsperado.FindKey([CDSCasosTestes.FieldByName('ID').AsInteger]) then
    lJSON := CDSResultadoEsperado.FieldByName('RESULTADO_ESPERADO').AsString;

  ShowMessage('Passou Aqui!');
  MostrarCDS(CDSResultadoEsperado);
  CompararComJSON(lJSON);
end;
{$endRegion}