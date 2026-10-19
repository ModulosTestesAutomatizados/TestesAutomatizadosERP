uses P39_TDD_RUN_ASSERTS;

const
  cOperacaoIgual = 0;
  cOperacaoMaior = 1;
  cOperacaoMenor = 2;

procedure Main;
var lInstrucoes :String;
begin
  lInstrucoes := 'Unit responsável por interpretar o JSON de resultado esperado e validar erros, datasets e tempo.'          + #13 +
    '===================================================================================================================='   + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                    + #13 +
    'function GetOperacao(pOperacao :String) :Integer'                                                                       + #13 +
    '  - Traduz o nome da operação ("Igual", "Maior", "Menor") para a constante numérica correspondente (0, 1 ou 2).'        + #13 +
    'function AplicarOperacaoNumerica(pOperacao :Integer; pValorReal, pValorEsperado :Double) :Boolean'                      + #13 +
    '  - Efetua a comparação relacional (=, >, <) entre dois valores numéricos com base no código da operação.'              + #13 +
    'function OperacaoDescricao(pOperacao :Integer) :String'                                                                 + #13 +
    '  - Retorna o texto legível da operação ("igual a", "maior que", "menor que") para compor mensagens de log/assert.'     + #13 +
    'function ConverterParaCurrency(pValor :String; pTipoCampo :String) :Double'                                             + #13 +
    '  - Converte string numérica para Double, trocando ponto por vírgula para adequação ao padrão decimal do ERP.'          + #13 +
    'procedure CompararQuantidadeErros(pJSON :String)'                                                                       + #13 +
    '  - Valida a seção "erro" do JSON, confrontando FErrosReais com a quantidade e operação esperadas.'                     + #13 +
    'procedure CompararCampoPorTipo(pTipoCampo, pValorReal, pValorEsperado :String; pOperacao :Integer; pCampoNome :String)' + #13 +
    '  - Realiza o cast e a comparação do campo conforme seu tipo (String, Boolean, Integer, Currency, DateTime).'           + #13 +
    'procedure CompararValor(pJSONItem :String)'                                                                             + #13 +
    '  - Localiza o campo nos datasets capturados em FDataSets (filtrando por cds/dm) e aciona CompararCampoPorTipo.'        + #13 +
    'procedure CompararValores(pJSON :String)'                                                                               + #13 +
    '  - Faz o parse do array JSON da seção "valor" e executa CompararValor para cada item configurado.'                     + #13 +
    'procedure CompararTempo(pJSON :String)'                                                                                 + #13 +
    '  - Valida a seção "tempo" do JSON, verificando se FTempoExecucaoMs respeita o limite na unidade informada.'            + #13 +
    'procedure FinalizarComparacao(pValidado :Boolean)'                                                                      + #13 +
    '  - Grava no log em modo debug o resumo consolidado das asserções (AssertsResumo).'                                     + #13 +
    'procedure CompararComJSON(pJSON :String)'                                                                               + #13 +
    '  - Faz o parse do objeto JSON principal, distribui as validações por seção (erro, valor, tempo) e finaliza o resumo.'  + #13 +
    'procedure CompararResultadoEsperado'                                                                                    + #13 +
    '  - Ponto de entrada que busca o JSON do caso atual em CDSResultadoEsperado e dispara CompararComJSON.'                 + #13 +
    '===================================================================================================================='   + #13 +
    'Toda falha de estrutura JSON, conversão de tipo ou regra de negócio é capturada e registrada via AssertsFalhou.'        + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_RUN_VALIDAR_RESULTADO', lInstrucoes);
end;

function GetOperacao(pOperacao :String): Integer;
begin
  Result := -1;
  if pOperacao      = 'Igual' then Result := cOperacaoIgual
  else if pOperacao = 'Maior' then Result := cOperacaoMaior
  else if pOperacao = 'Menor' then Result := cOperacaoMenor;
end;

function AplicarOperacaoNumerica(pOperacao: Integer; pValorReal, pValorEsperado: Double): Boolean;
begin
  Result := False;
  if pOperacao = cOperacaoIgual then Result := pValorReal = pValorEsperado
  else if pOperacao = cOperacaoMaior then Result := pValorReal > pValorEsperado
  else if pOperacao = cOperacaoMenor then Result := pValorReal < pValorEsperado;
end;

function OperacaoDescricao(pOperacao :Integer) :String;
begin
  Result                                         := 'operação inválida';
  if pOperacao      = cOperacaoIgual then Result := 'igual a'
  else if pOperacao = cOperacaoMaior then Result := 'maior que'
  else if pOperacao = cOperacaoMenor then Result := 'menor que';
end;

function ConverterParaCurrency(pValor :String; pTipoCampo :String) :Double;
begin
  // Valores monetários sem separador de milhar; ambiente ERP usa decimal vírgula.
  Result := StrToFloat(Troca(Trim(pValor), '.', ','));
end;

procedure CompararQuantidadeErros(pJSON :String);
var lQuantidade, lOperacao: Integer;
begin
  lQuantidade := StrToInt(GetValueJson(pJSON, 'quantidade'));
  lOperacao := GetOperacao(GetValueJson(pJSON, 'operacao'));

  if (lQuantidade < 0) or (lOperacao < 0) then
    AssertsFalhou('erro.quantidade', 'Quantidade ou operação inválida.')
  else
    RegistrarResultado(AplicarOperacaoNumerica(lOperacao, FErrosReais, lQuantidade),
      'erro.quantidade: esperado ' + OperacaoDescricao(lOperacao) + ' ' +
      IntToStr(lQuantidade) + ', obtido ' + IntToStr(FErrosReais));
end;

procedure CompararCampoPorTipo(pTipoCampo, pValorReal, pValorEsperado :String; pOperacao :Integer; pCampoNome :String);
var
  lReal,
  lEsperado      :Double;
  lRealBool,
  lEsperadoBool  :Boolean;
  lMensagem,
  lRealTexto,
  lEsperadoTexto :String;
begin
  lMensagem := pCampoNome + ': esperado ' + OperacaoDescricao(pOperacao) + ' ' +
    pValorEsperado + ', obtido ' + pValorReal;

  try
    if (pOperacao < 0) or (pOperacao > 2) then
      raise Exception.Create('Operação inválida.');

    if pTipoCampo = 'ftString' then
    begin
      if pOperacao <> cOperacaoIgual then
        raise Exception.Create('Texto suporta somente Igual.');
      RegistrarResultado(pValorReal = pValorEsperado, lMensagem);
    end
    else if pTipoCampo = 'ftBoolean' then
    begin
      if pOperacao <> cOperacaoIgual then
        raise Exception.Create('Booleano suporta somente Igual.');

      lRealTexto := LowerCase(Trim(pValorReal));
      lEsperadoTexto := LowerCase(Trim(pValorEsperado));

      if (lRealTexto <> 'true') and (lRealTexto <> 'false') and
         (lRealTexto <> 's') and (lRealTexto <> 'n') and
         (lRealTexto <> '1') and (lRealTexto <> '0') then
        raise Exception.Create('Valor booleano obtido inválido.');

      if (lEsperadoTexto <> 'true') and (lEsperadoTexto <> 'false') and
         (lEsperadoTexto <> 's') and (lEsperadoTexto <> 'n') and
         (lEsperadoTexto <> '1') and (lEsperadoTexto <> '0') then
        raise Exception.Create('Valor booleano esperado inválido.');

      lRealBool     := (lRealTexto = 'true') or (lRealTexto = 's') or (lRealTexto = '1');
      lEsperadoBool := (lEsperadoTexto = 'true') or (lEsperadoTexto = 's') or (lEsperadoTexto = '1');
      RegistrarResultado(lRealBool = lEsperadoBool, lMensagem);
    end
    else
    begin
      if pTipoCampo = 'ftInteger' then
      begin
        lReal     := StrToInt(pValorReal);
        lEsperado := StrToInt(pValorEsperado);
      end
      else if pTipoCampo = 'ftCurrency' then
      begin
        lReal     := ConverterParaCurrency(pValorReal, pTipoCampo);
        lEsperado := ConverterParaCurrency(pValorEsperado, pTipoCampo);
      end
      else if pTipoCampo = 'ftDateTime' then
      begin
        lReal     := StrToDateTime(pValorReal);
        lEsperado := StrToDateTime(pValorEsperado);
      end
      else
        raise Exception.Create('Tipo de campo não suportado: ' + pTipoCampo);
      RegistrarResultado(AplicarOperacaoNumerica(pOperacao, lReal, lEsperado), lMensagem);
    end;
  except
    on Ex: Exception do
      AssertsFalhou(lMensagem, Ex.Message);
  end;
end;

procedure CompararValor(pJSONItem :String);
var
  lCampo,
  lTipo,
  lEsperado,
  lNomeCDS,
  lNomeDM,
  lChave            :String;
  lOperacao,
  lIndice,
  lEncontrados,
  lIndiceEncontrado :Integer;
  lCDS              :TClientDataSet;
begin
  lCampo    := GetValueJson(pJSONItem, 'campo');
  lTipo     := GetValueJsonDef(pJSONItem, 'tipo_campo', 'ftString');
  lEsperado := GetValueJson(pJSONItem, 'resultado');
  lOperacao := GetOperacao(GetValueJson(pJSONItem, 'operacao'));
  lNomeCDS  := GetValueJsonDef(pJSONItem, 'cds', '');
  lNomeDM   := GetValueJsonDef(pJSONItem, 'dm', '');

  if Trim(lCampo) = '' then
  begin
    AssertsFalhou('valor', 'Campo não informado.');
    Exit;
  end;

  InicializarAcumulo;
  lEncontrados := 0;
  lIndiceEncontrado := -1;

  for lIndice := 0 to FDataSets.Count - 1 do
  begin
    lChave := FDataSets[lIndice];
    if ((lNomeCDS = '') or (UpperCase(CorteAte(lChave, '|')) = UpperCase(lNomeCDS))) and
       ((lNomeDM = '') or (UpperCase(CorteApos(lChave, '|')) = UpperCase(lNomeDM))) then
    begin
      lCDS := TClientDataSet(FDataSets.Objects[lIndice]);
      if lCDS.Active then
      begin
        if Assigned(lCDS.FindField(lCampo)) then
        begin
          lEncontrados := lEncontrados + 1;
          lIndiceEncontrado := lIndice;
        end;
      end;
    end;
  end;

  if lEncontrados <> 1 then
  begin
    AssertsFalhou(lCampo, 'Esperada uma captura com o campo; encontradas: ' + IntToStr(lEncontrados));
    Exit;
  end;

  lCDS := TClientDataSet(FDataSets.Objects[lIndiceEncontrado]);
  if lCDS.FieldByName(lCampo).IsNull then
    AssertsFalhou(lCampo, 'Valor obtido NULL; esperado ' + lEsperado)
  else
    CompararCampoPorTipo(lTipo, lCDS.FieldByName(lCampo).AsString, lEsperado, lOperacao, lCampo);
end;

procedure CompararValores(pJSON :String);
var lArray: TJSONArray;
  lIndice: Integer;
begin
  if Copy(Trim(pJSON), 1, 1) <> '[' then
    raise Exception.Create('A seção valor deve ser um array.');

  lArray := TJSONArray(TJSONObject.ParseJSONValue(pJSON));
  if not Assigned(lArray) then
    raise Exception.Create('Array de valores inválido.');

  try
    if lArray.Count = 0 then
      AssertsFalhou('valor', 'Nenhuma verificação configurada.');

    for lIndice := 0 to lArray.Count - 1 do
      CompararValor(lArray.Items(lIndice).ToJson);
  finally
    lArray.Free;
  end;
end;

procedure CompararTempo(pJSON :String);
var lLimite, lFator: Double;
  lUnidade: String;
begin
  lLimite := StrToInt(GetValueJson(pJSON, 'tempo_total'));

  if lLimite <= 0 then
    raise Exception.Create('Limite de tempo inválido.');

  lUnidade := LowerCase(GetValueJson(pJSON, 'tipo_registo'));
  lFator   := 1;

  if Pos('milisegundo', lUnidade)  > 0 then lFator := 1
  else if Pos('minuto', lUnidade)  > 0 then lFator := 60000
  else if Pos('segundo', lUnidade) > 0 then lFator := 1000
  else raise Exception.Create('Unidade de tempo inválida.');

  RegistrarResultado(FTempoExecucaoMs <= lLimite * lFator,
    'tempo: esperado até ' + FloatToStr(lLimite * lFator) +
    ' ms, obtido ' + FloatToStr(FTempoExecucaoMs) + ' ms');
end;

procedure FinalizarComparacao(pValidado: Boolean);
begin
  {P39_TDD_RUN_LOGS.}RegistrarLog(AssertsResumo);
end;

procedure CompararComJSON(pJSON :String);
var
  lObjeto, lConfiguracao :TJSONObject;
  lPar                   :TJSONPair;
  lIndice, lTotalAntes   :Integer;
  lNome, lValor          :String;
begin
  lTotalAntes := AssertsTotal;
  try
    if Copy(Trim(pJSON), 1, 1) <> '{' then
      raise Exception.Create('Resultado esperado deve ser um objeto.');

    lObjeto := TJSONObject.ParseJSONValue(pJSON);
    if not Assigned(lObjeto) then
      raise Exception.Create('Resultado esperado inválido.');

    try
      // Registros novos preservam a tag; registros anteriores têm as seções na raiz.
      for lIndice := 0 to lObjeto.Count - 1 do
      begin
        lPar := ExecutarMetodoDeObjeto(lObjeto, 'GetPair', [lIndice]);
        if GetPairName(lPar) = 'resultadoEsperado' then
        begin
          lValor := GetPairValue(lPar);
          if Copy(Trim(lValor), 1, 1) <> '{' then
            raise Exception.Create('A propriedade resultadoEsperado deve ser um objeto.');

          lConfiguracao := TJSONObject.ParseJSONValue(lValor);
          if not Assigned(lConfiguracao) then
            raise Exception.Create('Objeto resultadoEsperado inválido.');

          lObjeto.Free;
          lObjeto := lConfiguracao;
          Break;
        end;
      end;

      if lObjeto.Count = 0 then
      begin
        {P39_TDD_RUN_LOGS.}RegistrarLog('SEM_VALIDACAO: objeto de resultado esperado vazio.');
        Exit;
      end;

      for lIndice := 0 to lObjeto.Count - 1 do
      begin
        lPar   := ExecutarMetodoDeObjeto(lObjeto, 'GetPair', [lIndice]);
        lNome  := GetPairName(lPar);
        lValor := GetPairValue(lPar);

        if lNome = 'erro' then CompararQuantidadeErros(lValor)
        else if lNome = 'valor' then CompararValores(lValor)
        else if lNome = 'tempo' then CompararTempo(lValor)
        else AssertsFalhou('Resultado esperado', 'Seção desconhecida: ' + lNome);
      end;

      if AssertsTotal = lTotalAntes then
        AssertsFalhou('Resultado esperado', 'Nenhuma verificação configurada.');
    finally
      lObjeto.Free;
    end;
  except
    on Ex: Exception do
      AssertsFalhou('Resultado esperado', Ex.Message);
  end;
  FinalizarComparacao(AssertsOk);
end;

procedure CompararResultadoEsperado;
begin
  FResultadoEsperadoCaso := '';
  if CDSResultadoEsperado.FindKey([FCasoTesteAtualId]) then
    FResultadoEsperadoCaso := CDSResultadoEsperado.FieldByName('RESULTADO_ESPERADO').AsString;
  if Trim(FResultadoEsperadoCaso) = '' then
    {P39_TDD_RUN_LOGS.}RegistrarLog('SEM_VALIDACAO: resultado esperado não configurado para o caso.')
  else
    CompararComJSON(FResultadoEsperadoCaso);
end;
