uses P39_TDD_ODBC, P39_TDD_FUNCOES_JSON;

type
  TCasoTeste = record
    Modulo            :integer;
    Area              :integer;
    Descricao         :string;
    RequisitoVersao   :string;
    CasoTeste         :string;
    CamposDisponiveis :string;
    ResultadoEsperado :string;
  end;
  
var FCasoTeste :TCasoTeste;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit responsável pelo registro dos casos de teste no banco de dados dedicado ao TDD.'                        + #13 +
    '===================================================================================================================='     + #13 +
    'Estado compartilhado:'                                                                                                    + #13 +
    'FCasoTeste :TCasoTeste'                                                                                                   + #13 +
    '  - TCasoTeste é um type record onde todos os atributos para o insert de um caso de teste foram declarados.'              + #13 +
    '===================================================================================================================='     + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                      + #13 +
    'procedure RegistrarCasoTeste('                                                                                            + #13 +
    '                                pDescricaoModulo,'                                                                        + #13 +
    '                                pDescricaoArea,'                                                                          + #13 +
    '                                pDescricaoCasoTeste,'                                                                     + #13 +
    '                                pRequisitoVersao,'                                                                        + #13 +
    '                                pUnitJsonCasoTeste :string;'                                                              + #13 +
    '                                pSincRemoto :boolean'                                                                     + #13 +
    '                             )'                                                                                           + #13 +
    '  - Orquestra o registro de um caso de teste.'                                                                            + #13 +
    'function CarregarConteudoUnit(pNomeUnit :string; pSincRemoto :boolean) :string'                                           + #13 +
    '  - Trata o controle de sincronizar com fontes do remoto ou locais.'                                                      + #13 +
    '  - Carrega o conteúdo obrigatório; falhas de leitura não são convertidas em json vazio.'                                 + #13 +
    'function ObterObjetoConfiguracao(pJson, pPropriedade, pUnitFallback :string; pFallbackSeVazio :boolean) :string'          + #13 +
    '  - Resolve objetos explícitos ou a propriedade de uma unit remota mínima, conforme a política de vazio.'                 + #13 +
    'function SincronizarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string) :integer'                    + #13 +
    '  - Camada de validação se o caso de teste já existe no banco de dados.'                                                  + #13 +
    '  - Confirma antes de carregar fontes; retorna -1 para recusa, 0 para novo ou o código para atualização.'                 + #13 +
    'procedure AtualizarCasoTeste(pCodigoCasoTeste :integer)'                                                                  + #13 +
    '  - SQL de update do caso de teste e execução de {P39_TDD_ODBC.}TDDCommandODBCP passando os parâmetros via FCasoTeste.'   + #13 +
    'procedure InsertCasoTeste'                                                                                                + #13 +
    '  - SQL de insert do caso de teste e execução de {P39_TDD_ODBC.}TDDCommandODBCP passando os parâmetros via FCasoTeste.'   + #13 +
    'function RegistroFallbackBase('                                                                                           + #13 +
    '                                 pSqlSelect,'                                                                             + #13 +
    '                                 pSqlInsert :string;'                                                                     + #13 +
    '                                 pParametrosSql :OleVariant;'                                                             + #13 +
    '                                 pAtivarFallback :boolean'                                                                + #13 +
    '                             ) :integer'                                                                                  + #13 +
    '  - Orquestra execuções de consulta que podem vir a gerar um registro de insert.'                                         + #13 +
    '  - Depende de que as SQLs de insert contenha a cláusula returning ao final da sql.'                                      + #13 +
    '  - Quando pAtivarFallback for false, essa unit apenas encontra o que já existe e retorna raise se não encontrar.'        + #13 +
    'function RegistroFallbackModulo(pDescricaoModulo :string; pAtivarFallback :boolean) :integer'                             + #13 +
    '  - Monta as SQLs de select e insert com returning para chamar RegistroFallbackBase com fallback ativado.'                + #13 +
    'function RegistroFallbackArea(pCodigoModulo :integer; pDescricaoArea :string; pAtivarFallback :boolean) :integer'         + #13 +
    '  - Monta as SQLs de select e insert com returning para chamar RegistroFallbackBase com fallback ativado.'                + #13 +
    '====================================================================================================================';
  {P39_TDD_ODBC -> P39_TDD_CONSTANTES -> P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_REGISTRAR_CASO_TESTE', lInstrucoes);
end;

procedure RegistrarCasoTeste(
  pDescricaoModulo,
  pDescricaoArea,
  pDescricaoCasoTeste,
  pRequisitoVersao,
  pUnitJsonCasoTeste :string;
  pSincRemoto        :boolean
);
var
  lIndice,
  lCodigoModulo,
  lCodigoCasoTeste,
  lCodigoArea        :integer;
  lFonte,
  lJsonCasoTeste,
  lJsonCamposDisponiveis,
  lJsonResultadoEsperado,
  lNome,
  lSeparador         :string;
  lObjeto            :TJSONObject;
  lPar               :TJSONPair;
begin
  lCodigoCasoTeste := SincronizarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste);
  if lCodigoCasoTeste < 0 then
    Exit;

  lFonte                 := CarregarConteudoUnit(pUnitJsonCasoTeste, pSincRemoto);
  lJsonResultadoEsperado := ObterObjetoConfiguracao(lFonte, 'resultadoEsperado', 'P39_TDD_ASSERTS_JSON_MINIMO', false);
  lJsonCamposDisponiveis := ObterObjetoConfiguracao(lFonte, 'camposDisponiveis', 'P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO', true);
  lObjeto                := TJSONObject.ParseJSONValue(lFonte);

  if not Assigned(lObjeto) then
    raise Exception.Create('JSON do caso de teste inválido.');

  try
    lJsonCasoTeste := '{';
    lSeparador     := '';

    for lIndice := 0 to lObjeto.Count - 1 do
    begin
      lPar  := ExecutarMetodoDeObjeto(lObjeto, 'GetPair', [lIndice]);
      lNome := GetPairName(lPar);

      if (lNome <> 'resultadoEsperado') and (lNome <> 'camposDisponiveis') then
      begin
        lJsonCasoTeste := lJsonCasoTeste + lSeparador + ExecutarMetodoDeObjeto(lPar, 'ToJSON');
        lSeparador     := ',';
      end;
    end;

    // Os objetos resolvidos permanecem na raiz, inclusive quando vierem dos mínimos.
    lJsonCasoTeste := lJsonCasoTeste + lSeparador +
      Copy(lJsonCamposDisponiveis, 2, Length(lJsonCamposDisponiveis) - 2) + ',' +
      Copy(lJsonResultadoEsperado, 2, Length(lJsonResultadoEsperado) - 2) + '}';
  finally
    lObjeto.Free;
  end;

  lCodigoModulo := RegistroFallbackModulo(pDescricaoModulo, true);
  lCodigoArea   := RegistroFallbackArea(lCodigoModulo, pDescricaoArea, true);
  
  FCasoTeste.Modulo            := lCodigoModulo;
  FCasoTeste.Area              := lCodigoArea;
  FCasoTeste.Descricao         := pDescricaoCasoTeste;
  FCasoTeste.RequisitoVersao   := pRequisitoVersao;
  FCasoTeste.CasoTeste         := JSONFormatado(lJsonCasoTeste);
  FCasoTeste.CamposDisponiveis := JSONFormatado(lJsonCamposDisponiveis);
  FCasoTeste.ResultadoEsperado := JSONFormatado(lJsonResultadoEsperado);

  // Debug fora do IRunner, se utilizado precisa implementar o .Free no estado dos logs mantidos por FLogsCasoTeste.
  // {P39_TDD_RUN_LOGS.}RegistrarLog('Valor atribuido ao Caso de Teste:' + #13 + JSONFormatado(FCasoTeste.CasoTeste));

  try
    if lCodigoCasoTeste > 0 then
      AtualizarCasoTeste(lCodigoCasoTeste)
    else
      InsertCasoTeste;
  except on ex: Exception do
    raise Exception.Create(ex.Message);
  end;
end;

function CarregarConteudoUnit(pNomeUnit :string; pSincRemoto :boolean) :string;
begin
  pNomeUnit := Trim(pNomeUnit);
  if Trim(pNomeUnit) = '' then
    raise Exception.Create('Nome da unit JSON não informado.');

  if pSincRemoto and (UpperCase(Copy(pNomeUnit, 1, 4)) <> 'P39_') then
    pNomeUnit := 'P39_' + pNomeUnit;

  try
    Result := CodificacaoUnit(pNomeUnit);
  except on Ex: Exception do
    raise Exception.Create('Falha ao carregar a unit JSON ' + pNomeUnit + ': ' + #13 + Ex.Message);
  end;

  if Trim(Result) = '' then
    raise Exception.Create('Conteúdo vazio na unit JSON ' + pNomeUnit + '.');
end;

function ObterObjetoConfiguracao(pJson, pPropriedade, pUnitFallback :string; pFallbackSeVazio :boolean) :string;
var
  lObjeto, lValorObjeto :TJSONObject;
  lPar                  :TJSONPair;
  lIndice, lTentativa   :integer;
  lFonte, lValor        :string;
  lUsandoFallback       :boolean;
begin
  lFonte          := pJson;
  lUsandoFallback := false;

  // Uma tentativa para a fonte e outra, se necessária, para o mínimo remoto.
  for lTentativa := 1 to 2 do
  begin
    if Copy(Trim(lFonte), 1, 1) <> '{' then
      raise Exception.Create('JSON de configuração deve ser um objeto: ' + pPropriedade);

    lObjeto := TJSONObject.ParseJSONValue(lFonte);

    if not Assigned(lObjeto) then
      raise Exception.Create('JSON inválido para a configuração: ' + pPropriedade);

    lValor := '';
    try
      // O mínimo de campos atualmente é apenas {}. Resultado exige objeto nomeado.
      if lUsandoFallback and pFallbackSeVazio and (lObjeto.Count = 0) then
      begin
        Result := '{"' + pPropriedade + '":{}}';
        Exit;
      end;

      for lIndice := 0 to lObjeto.Count - 1 do
      begin
        lPar := ExecutarMetodoDeObjeto(lObjeto, 'GetPair', [lIndice]);
        if GetPairName(lPar) = pPropriedade then
          lValor := GetPairValue(lPar);
      end;

      if lValor <> '' then
      begin
        if Copy(Trim(lValor), 1, 1) <> '{' then
          raise Exception.Create('A propriedade ' + pPropriedade + ' deve ser um objeto.');

        lValorObjeto := TJSONObject.ParseJSONValue(lValor);

        if not Assigned(lValorObjeto) then
          raise Exception.Create('Objeto JSON inválido: ' + pPropriedade);

        try
          if lUsandoFallback and (lValorObjeto.Count = 0) and not pFallbackSeVazio then
            raise Exception.Create('Fallback sem configurações: ' + pUnitFallback);

          if (lValorObjeto.Count > 0) or not pFallbackSeVazio or lUsandoFallback then
          begin
            Result := '{"' + pPropriedade + '":' + lValor + '}';
            Exit;
          end;
        finally
          lValorObjeto.Free;
        end;
      end;
    finally
      lObjeto.Free;
    end;

    if lUsandoFallback then
      raise Exception.Create('Propriedade ' + pPropriedade + ' não encontrada na unit ' + pUnitFallback);

    if pUnitFallback = '' then
    begin
      Result := '{"' + pPropriedade + '":{}}';
      Exit;
    end;

    // O fallback tem nome remoto exato e independe da origem local/remota do caso.
    lFonte := CarregarConteudoUnit(pUnitFallback, false);
    lUsandoFallback := true;
  end;
end;

function SincronizarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string) :integer;
var
  lRespostaUsuario :integer;
  lSqlCasoTeste    :string;
begin
  lSqlCasoTeste := 'select CT.AUTOINC_CT'                          + #13 +
    'from CASO_TESTE CT'                                           + #13 +
    'join MODULO MD on MD.CODIGO_MODULO = CT.MODULO_CT'             + #13 +
    'join AREA AR on AR.AUTOINC_AREA = CT.AREA_CT'                  + #13 +
    'where CT.DESCRICAO_CASO_TESTE_CT = :pDescricao and'            + #13 +
    '      MD.DESCRICAO_MODULO        = :pModulo    and'            + #13 +
    '      AR.DESCRICAO_AREA          = :pArea;';

  Result := StrToIntDef(VarToStr({P39_TDD_ODBC.}TDDScalarODBCP(lSqlCasoTeste, [
    pDescricaoCasoTeste,
    pDescricaoModulo,
    pDescricaoArea
  ])), 0);

  if Result <= 0 then
    Exit;

  lRespostaUsuario := MessageDlg(
    Format(
      'Registro para o caso de teste: %s já existe!' + #13 + 'A operação de sincronização será realizada via update.' + #13 + 'Confirmar esta operação?',
      [pDescricaoCasoTeste]
    ), mtConfirmation, [mbYes, mbNo], 0
  );

  if lRespostaUsuario <> mrYes then
    Result := -1;
end;

procedure AtualizarCasoTeste(pCodigoCasoTeste :integer);
var lSqlUpdateCasoTeste :string;
begin
  lSqlUpdateCasoTeste := 'update CASO_TESTE CT'                         + #13 +
    'set CT.MODULO_CT                           = :pModulo,'            + #13 +
    '    CT.AREA_CT                             = :pArea,'              + #13 +
    '    CT.DESCRICAO_CASO_TESTE_CT             = :pDescricao,'         + #13 +
    '    CT.REQUISITO_VERSAO_CT                 = :pRequisitoVersao,'   + #13 +
    '    CT.CASO_TESTE_CT                       = :pCasoTest,'          + #13 +
    '    CT.CAMPOS_DISPONIVEIS_CT               = :pCamposDisponiveis,' + #13 +
    '    CT.RESULTADO_ESPERADO_CT               = :pResultadoEsperado'  + #13 +
    'where CT.AUTOINC_CT                        = :pCodigoCasoTeste';

  // Comando parametrizado: NÃO usar QuotedStr (aspas literais corrompem o JSON no banco).
  {P39_TDD_ODBC.}TDDCommandODBCP(lSqlUpdateCasoTeste, [
    FCasoTeste.Modulo,
    FCasoTeste.Area,
    FCasoTeste.Descricao,
    FCasoTeste.RequisitoVersao,
    FCasoTeste.CasoTeste,
    FCasoTeste.CamposDisponiveis,
    FCasoTeste.ResultadoEsperado,
    pCodigoCasoTeste
  ]);
end;

procedure InsertCasoTeste;
var lSqlInsertCasoTeste :string;
begin
  // AUTOINC_CT e gen_id(GEN_CASO_TESTE, 1) removidos, Trigger no banco cuida do autoinc!
  lSqlInsertCasoTeste := 'insert into CASO_TESTE ('   + #13 +  
    '    MODULO_CT,'                                  + #13 +
    '    AREA_CT,'                                    + #13 +
    '    DESCRICAO_CASO_TESTE_CT,'                    + #13 +
    '    REQUISITO_VERSAO_CT,'                        + #13 +    
    '    CASO_TESTE_CT,'                              + #13 +    
    '    CAMPOS_DISPONIVEIS_CT,'                      + #13 +
    '    RESULTADO_ESPERADO_CT'                       + #13 +
    ')'                                               + #13 +
    'values ('                                        + #13 +
    '    :pModulo,'                                   + #13 +
    '    :pArea,'                                     + #13 +
    '    :pDescricao,'                                + #13 +
    '    :pRequisitoVersao,'                          + #13 +
    '    :pCasoTeste,'                                + #13 + 
    '    :pCamposDisponiveis,'                        + #13 + 
    '    :pResultadoEsperado'                         + #13 + 
    ');';

  // Comando parametrizado: NÃO usar QuotedStr (aspas literais corrompem o JSON no banco).
  {P39_TDD_ODBC.}TDDCommandODBCP(lSqlInsertCasoTeste, [
    FCasoTeste.Modulo,
    FCasoTeste.Area,
    FCasoTeste.Descricao,
    FCasoTeste.RequisitoVersao,
    FCasoTeste.CasoTeste,
    FCasoTeste.CamposDisponiveis,
    FCasoTeste.ResultadoEsperado
  ]);
end;

function RegistroFallbackBase(pSqlSelect, pSqlInsert :string; pParametrosSql :OleVariant; pAtivarFallback :boolean) :integer;
var
  lRetornoODBC   :OleVariant;
  lRetornoString :string;
begin
  lRetornoODBC := {P39_TDD_ODBC.}TDDScalarODBCP(pSqlSelect, pParametrosSql);
  lRetornoString := VarToStr(lRetornoODBC);

  // Checa se veio vazio ou zerado.
  if (lRetornoString = '') or (lRetornoString = '0') then
  begin
    // Verifica se deve usar o fallback.
    if (pAtivarFallback = true) then
    begin
      // Faz o INSERT e já captura o ID gerado na mesma viagem ao banco via RETURNING
      lRetornoODBC := {P39_TDD_ODBC.}TDDScalarODBCP(pSqlInsert, pParametrosSql);
      lRetornoString := VarToStr(lRetornoODBC);
    end
    else
      // Se não usar o fallback, disparar um erro de 'recurso não encontrado'.
      raise Exception.Create('Recurso não encontrado. ');
  end;
  // Converte o valor final de forma segura
  Result := StrToIntDef(lRetornoString, 0);
end;

function RegistroFallbackModulo(pDescricaoModulo :string; pAtivarFallback :boolean) :integer;
var lSqlSelectModulo, lSqlInsertModulo :string;
begin
  lSqlSelectModulo := 'select MD.CODIGO_MODULO from MODULO MD where MD.DESCRICAO_MODULO = :pDescricao;';
  lSqlInsertModulo := 'insert into MODULO (DESCRICAO_MODULO) values (:pDescricao) returning CODIGO_MODULO;';
  try
    Result := RegistroFallbackBase(
      lSqlSelectModulo,
      lSqlInsertModulo,
      [pDescricaoModulo],
      pAtivarFallback
    );
  except on ex: Exception do 
    raise Exception.Create(ex.Message + 'Nenhum módulo corresponde aos parâmetros de consulta! ');
  end;
end;

function RegistroFallbackArea(pCodigoModulo :integer; pDescricaoArea :string; pAtivarFallback :boolean) :integer;
var lSqlSelectArea, lSqlInsertArea :string;
begin
  lSqlSelectArea := 'select AREA.AUTOINC_AREA from AREA where AREA.DESCRICAO_AREA = :pDescricao and AREA.modulo_area = :pModulo;';
  lSqlInsertArea := 'insert into AREA (DESCRICAO_AREA, MODULO_AREA) values (:pDescricao, :pModulo) returning AUTOINC_AREA;';
  try
    Result := RegistroFallbackBase(
      lSqlSelectArea,
      lSqlInsertArea,
      [pDescricaoArea, pCodigoModulo],
      pAtivarFallback
    );  
  except on ex: Exception do 
    raise Exception.Create(ex.Message + 'Nenhuma área corresponde aos parâmetros de consulta! ');
  end;
end;
