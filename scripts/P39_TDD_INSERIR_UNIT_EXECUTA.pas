uses P39_TDD_ODBC, P39_TDD_CONSTANTES;

procedure Main;
var lSql: String;
    lCodificacao: String;
begin
  // NOTA: Esta unit deve ser incluída no banco que EXECUTA (DADOSMC.FDB),
  // na tabela GR_UNIDADE_CODIFICACAO (tabela de units do banco que executa).

  // O código da chave (CODIGO_UNIT) é gerado automaticamente pelo banco
  // (AUTOINCREMENTOS / generator da tabela), conforme regra dos bancos dedicados.

  // Montar o conteúdo da unit (escaping de aspas simples)
  lCodificacao := 
    'uses P39_TDD_CONSTANTES, P39_TDD_ODBC, P39_TDD_FUNCOES_JSON, P39_TDD_ASSERTS;' + #13 + #13 +
    'procedure Main;' + #13 +
    'var lInstrucoes: String;' + #13 +
    'begin' + #13 +
    '  lInstrucoes := ''Unit genérica para validação de resultados de casos de teste.'' + #13 +' + #13 +
    '    ''Fornece funções de comparação por tipo de campo e orquestração de asserts.'' + #13 + #13 +' + #13 +
    '    ''Métodos disponíveis:'' + #13 +' + #13 +
    '    '' - function CompararCampoPorTipo(pTipoCampo, pValorReal, pValorEsperado, pOperacao, pCampoNome: String): Boolean;'' + #13 +' + #13 +
    '    ''   + Compara valores de acordo com o tipo do campo (String, Integer, Currency, DateTime, Boolean).'' + #13 +' + #13 +
    '    '' - function ObterValorCampoFormatado(pCDS: TClientDataSet; pCampo: String; pTipoCampo: String): String;'' + #13 +' + #13 +
    '    ''   + Obtém o valor do campo formatado como String de acordo com o tipo.'' + #13 +' + #13 +
    '    '' - function ConverterParaCurrency(pValor: String; pTipoCampo: String): Currency;'' + #13 +' + #13 +
    '    ''   + Converte String para Currency de acordo com o tipo do campo.'';' + #13 +
    '  MostrarLogTexto(lInstrucoes, ''Instruções TDD_VALIDAR_GENERICO'');' + #13 +
    'end;' + #13 + #13 +
    'function CompararCampoPorTipo(pTipoCampo: String; pValorReal: String; pValorEsperado: String; pOperacao: Integer; pCampoNome: String): Boolean;' + #13 +
    'var' + #13 +
    '  lRealInt, lEsperadoInt: Integer;' + #13 +
    '  lRealCurr, lEsperadoCurr: Currency;' + #13 +
    '  lRealDate, lEsperadoDate: TDateTime;' + #13 +
    '  lRealBool, lEsperadoBool: Boolean;' + #13 +
    '  lMensagem: String;' + #13 +
    'begin' + #13 +
    '  Result := True;' + #13 +
    '  lMensagem := pCampoNome + '': esperado '' + OperacaoDescricao(pOperacao) + '' '' + pValorEsperado + '', obtido '' + pValorReal + ''.'';' + #13 +
    '  try' + #13 +
    '    if pTipoCampo = ''ftString'' then' + #13 +
    '    begin' + #13 +
    '      if pOperacao = cOperacaoIgual then' + #13 +
    '        AssertIgual(pValorEsperado, pValorReal, lMensagem)' + #13 +
    '      else' + #13 +
    '      begin' + #13 +
    '        AssertFalhou(''CompararCampoPorTipo'', ''ftString não suporta operação Maior/Menor.'');' + #13 +
    '        Result := False;' + #13 +
    '      end;' + #13 +
    '    end' + #13 +
    '    else if pTipoCampo = ''ftInteger'' then' + #13 +
    '    begin' + #13 +
    '      lRealInt := StrToIntDef(pValorReal, 0);' + #13 +
    '      lEsperadoInt := StrToIntDef(pValorEsperado, 0);' + #13 +
    '      if pOperacao = cOperacaoIgual then' + #13 +
    '        AssertIgualInteiro(lEsperadoInt, lRealInt, lMensagem)' + #13 +
    '      else if pOperacao = cOperacaoMaior then' + #13 +
    '        AssertVerdadeiro(lEsperadoInt > lRealInt, lMensagem)' + #13 +
    '      else if pOperacao = cOperacaoMenor then' + #13 +
    '        AssertVerdadeiro(lEsperadoInt < lRealInt, lMensagem);' + #13 +
    '    end' + #13 +
    '    else if pTipoCampo = ''ftCurrency'' then' + #13 +
    '    begin' + #13 +
    '      lRealCurr := ConverterParaCurrency(pValorReal, pTipoCampo);' + #13 +
    '      lEsperadoCurr := ConverterParaCurrency(pValorEsperado, pTipoCampo);' + #13 +
    '      if pOperacao = cOperacaoIgual then' + #13 +
    '        AssertIgualMoeda(lEsperadoCurr, lRealCurr, lMensagem)' + #13 +
    '      else if pOperacao = cOperacaoMaior then' + #13 +
    '        AssertVerdadeiro(lEsperadoCurr > lRealCurr, lMensagem)' + #13 +
    '      else if pOperacao = cOperacaoMenor then' + #13 +
    '        AssertVerdadeiro(lEsperadoCurr < lRealCurr, lMensagem);' + #13 +
    '    end' + #13 +
    '    else if pTipoCampo = ''ftDateTime'' then' + #13 +
    '    begin' + #13 +
    '      lRealDate := StrToDateTimeDef(pValorReal, 0);' + #13 +
    '      lEsperadoDate := StrToDateTimeDef(pValorEsperado, 0);' + #13 +
    '      if pOperacao = cOperacaoIgual then' + #13 +
    '        AssertVerdadeiro(lEsperadoDate = lRealDate, lMensagem)' + #13 +
    '      else if pOperacao = cOperacaoMaior then' + #13 +
    '        AssertVerdadeiro(lEsperadoDate > lRealDate, lMensagem)' + #13 +
    '      else if pOperacao = cOperacaoMenor then' + #13 +
    '        AssertVerdadeiro(lEsperadoDate < lRealDate, lMensagem);' + #13 +
    '    end' + #13 +
    '    else if pTipoCampo = ''ftBoolean'' then' + #13 +
    '    begin' + #13 +
    '      lRealBool := (LowerCase(Trim(pValorReal)) = ''true'') or (LowerCase(Trim(pValorReal)) = ''s'');' + #13 +
    '      lEsperadoBool := (LowerCase(Trim(pValorEsperado)) = ''true'') or (LowerCase(Trim(pValorEsperado)) = ''s'');' + #13 +
    '      if pOperacao = cOperacaoIgual then' + #13 +
    '        AssertVerdadeiro(lEsperadoBool = lRealBool, lMensagem)' + #13 +
    '      else' + #13 +
    '      begin' + #13 +
    '        AssertFalhou(''CompararCampoPorTipo'', ''ftBoolean não suporta operação Maior/Menor.'');' + #13 +
    '        Result := False;' + #13 +
    '      end;' + #13 +
    '    end' + #13 +
    '    else' + #13 +
    '    begin' + #13 +
    '      AssertFalhou(''CompararCampoPorTipo'', ''Tipo de campo não suportado: '' + pTipoCampo);' + #13 +
    '      Result := False;' + #13 +
    '    end;' + #13 +
    '  except' + #13 +
    '    on E: Exception do' + #13 +
    '    begin' + #13 +
    '      AssertFalhou(''CompararCampoPorTipo'', ''Erro ao comparar campo '' + pCampoNome + '': '' + E.Message);' + #13 +
    '      Result := False;' + #13 +
    '    end;' + #13 +
    '  end;' + #13 +
    'end;' + #13 + #13 +
    'function ObterValorCampoFormatado(pCDS: TClientDataSet; pCampo: String; pTipoCampo: String): String;' + #13 +
    'begin' + #13 +
    '  Result := '''';' + #13 +
    '  if not Assigned(pCDS) then' + #13 +
    '    Exit;' + #13 +
    '  if pCDS.FindField(pCampo) = nil then' + #13 +
    '    Exit;' + #13 +
    '  if pTipoCampo = ''ftString'' then' + #13 +
    '    Result := pCDS.FieldByName(pCampo).AsString' + #13 +
    '  else if pTipoCampo = ''ftInteger'' then' + #13 +
    '    Result := IntToStr(pCDS.FieldByName(pCampo).AsInteger)' + #13 +
    '  else if pTipoCampo = ''ftCurrency'' then' + #13 +
    '    Result := CurrToStr(pCDS.FieldByName(pCampo).AsCurrency)' + #13 +
    '  else if pTipoCampo = ''ftDateTime'' then' + #13 +
    '  begin' + #13 +
    '    if pCDS.FieldByName(pCampo).IsNull then' + #13 +
    '      Result := ''''' + #13 +
    '    else' + #13 +
    '      Result := FormatDateTime(''yyyy-mm-dd hh:nn:ss'', pCDS.FieldByName(pCampo).AsDateTime);' + #13 +
    '  end' + #13 +
    '  else if pTipoCampo = ''ftBoolean'' then' + #13 +
    '  begin' + #13 +
    '    if pCDS.FieldByName(pCampo).AsBoolean then' + #13 +
    '      Result := ''true''' + #13 +
    '    else' + #13 +
    '      Result := ''false'';' + #13 +
    '  end' + #13 +
    '  else' + #13 +
    '    Result := pCDS.FieldByName(pCampo).AsString;' + #13 +
    'end;' + #13 + #13 +
    'function ConverterParaCurrency(pValor: String; pTipoCampo: String): Currency;' + #13 +
    'begin' + #13 +
    '  Result := 0;' + #13 +
    '  try' + #13 +
    '    if pTipoCampo = ''ftCurrency'' then' + #13 +
    '      Result := StrToCurrDef(StringReplace(pValor, ''.'', '','',[rfReplaceAll]), 0)' + #13 +
    '    else if pTipoCampo = ''ftInteger'' then' + #13 +
    '      Result := StrToIntDef(pValor, 0)' + #13 +
    '    else if pTipoCampo = ''ftBoolean'' then' + #13 +
    '    begin' + #13 +
    '      if (LowerCase(Trim(pValor)) = ''true'') or (LowerCase(Trim(pValor)) = ''s'') then' + #13 +
    '        Result := 1' + #13 +
    '      else' + #13 +
    '        Result := 0;' + #13 +
    '    end' + #13 +
    '    else' + #13 +
    '      Result := StrToCurrDef(StringReplace(pValor, ''.'', '','',[rfReplaceAll]), 0);' + #13 +
    '  except' + #13 +
    '    Result := 0;' + #13 +
    '  end;' + #13 +
    'end;' + #13 + #13 +
    'function StrToDateTimeDef(pValor: String; pDefault: TDateTime): TDateTime;' + #13 +
    'begin' + #13 +
    '  Result := pDefault;' + #13 +
    '  try' + #13 +
    '    if Trim(pValor) <> '''' then' + #13 +
    '      Result := StrToDateTime(pValor);' + #13 +
    '  except' + #13 +
    '    Result := pDefault;' + #13 +
    '  end;' + #13 +
    'end;';

  // Montar o INSERT na tabela GR_UNIDADE_CODIFICACAO (banco que executa)
  // Substitua os valores de GRUPO_UNIT / TIPO_UNIT / ORIGEM_UNIT / AUTOR_UNIT
  // pelos domínios corretos conforme a estrutura da tabela.
  lSql := 'INSERT INTO GR_UNIDADE_CODIFICACAO (' +
          'NOME_UNIT, PADRAOTEKSYSTEM_UNIT, AUTOR_UNIT, GRUPO_UNIT, TIPO_UNIT, ' +
          'ARMAZENAMENTO_UNIT, ORIGEM_UNIT, CODIFICACAO_UNIT, OBSERVACAO_UNIT) VALUES (' +
          QuotedStr('P39_TDD_VALIDAR_GENERICO') + ', ' +
          QuotedStr('N') + ', ' +
          QuotedStr('') + ', ' +            // AUTOR_UNIT
          '1371' + ', ' +                    // GRUPO_UNIT (núcleo TDD, se aplicável)
          '0' + ', ' +                       // TIPO_UNIT (Pascal Script)
          '0' + ', ' +                       // ARMAZENAMENTO_UNIT (no banco)
          '20' + ', ' +                      // ORIGEM_UNIT (módulo BI)
          QuotedStr(lCodificacao) + ', ' +
          QuotedStr('Unit genérica para validação de resultados de casos de teste. Fornece funções de comparação por tipo de campo (String, Integer, Currency, DateTime, Boolean) e orquestração de asserts.') + ')';

  // Executar INSERT
  TDDCommandODBC(lSql, null);

  // Confirmar inserção
  MostrarLogTexto('Unit P39_TDD_VALIDAR_GENERICO inserida com sucesso no banco que EXECUTA (GR_UNIDADE_CODIFICACAO)!');
end;
