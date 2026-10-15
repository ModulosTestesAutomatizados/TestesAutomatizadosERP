uses P39_TDD_ODBC;

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
    '                                pUnitJsonCasoTeste,'                                                                      + #13 +
    '                                pUnitJsonCamposDisponiveis,'                                                              + #13 +
    '                                pUnitJsonResultadoEsperado :string;'                                                      + #13 +
    '                                pSincRemoto :boolean'                                                                     + #13 +
    '                             )'                                                                                           + #13 +
    '  - Orquestra o registro de um caso de teste.'                                                                            + #13 +
    'function CarregarConteudoUnit(pNomeUnit :string; pSincRemoto :boolean) :string'                                           + #13 +
    '  - Trata o controle de sincronizar com fontes do remoto ou locais.'                                                      + #13 +
    '  - Carrega o conteúdo de uma unidade de codificação como string, garante json vazio.'                                    + #13 +
    'procedure SincronizarCasoTeste'                                                                                           + #13 +
    '  - Camada de validação se o caso de teste já existe no banco de dados.'                                                  + #13 +
    '  - Chamada ao questionamento/confirmação para sobreescrita quando o caso de teste já estiver registrado.'                + #13 +
    'procedure QuestionarParaRodarUpdateCasoTeste(pCodigoCasoTeste :integer)'                                                  + #13 +
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
  {P39_TDD_ODBC -> P39_TDD_CONSTANTES -> P39_TDD_LOGS.}MostrarInstrucoesUnit('TDD_REGISTRAR_CASO_TESTE', lInstrucoes);
end;

procedure RegistrarCasoTeste(
  pDescricaoModulo,
  pDescricaoArea,
  pDescricaoCasoTeste,
  pRequisitoVersao,
  pUnitJsonCasoTeste,
  pUnitJsonCamposDisponiveis,
  pUnitJsonResultadoEsperado  :string;
  pSincRemoto                 :boolean
);
var
  lCodigoModulo,
  lCodigoArea,
  lSqlCasoTeste           :string;
  lJsonCasoTeste,
  lJsonCamposDisponiveis,
  lJsonResultadoEsperado  :TStringList;
begin
  lJsonCasoTeste         := TStringList.Create;
  lJsonCamposDisponiveis := TStringList.Create;
  lJsonResultadoEsperado := TStringList.Create;

  try  
    lJsonCasoTeste.Text         := CarregarConteudoUnit(pUnitJsonCasoTeste,         pSincRemoto);
    lJsonCamposDisponiveis.Text := CarregarConteudoUnit(pUnitJsonCamposDisponiveis, pSincRemoto);
    lJsonResultadoEsperado.Text := CarregarConteudoUnit(pUnitJsonResultadoEsperado, pSincRemoto);

    // RegistrarLogEmModoDebug('Retorno da leitura da Codificacao Json:' + #13 + JSONFormatado(lJsonCasoTeste.Text)); // Debug

    lCodigoModulo := RegistroFallbackModulo(pDescricaoModulo, true);
    lCodigoArea   := RegistroFallbackArea(lCodigoModulo, pDescricaoArea, true);

    FCasoTeste.Modulo            := lCodigoModulo;
    FCasoTeste.Area              := lCodigoArea;
    FCasoTeste.Descricao         := pDescricaoCasoTeste;
    FCasoTeste.RequisitoVersao   := pRequisitoVersao;
    FCasoTeste.CasoTeste         := lJsonCasoTeste.Text;
    FCasoTeste.CamposDisponiveis := lJsonCamposDisponiveis.Text;
    FCasoTeste.ResultadoEsperado := lJsonResultadoEsperado.Text;

    // RegistrarLogEmModoDebug('Valor atribuido ao Caso de Teste:' + #13 + JSONFormatado(FCasoTeste.CasoTeste)); // Debug 

    try
      SincronizarCasoTeste;
    except on ex: Exception do
      raise Exception.Create(ex.Message);
    end;
  finally
    lJsonCasoTeste.Free;
    lJsonCamposDisponiveis.Free;
    lJsonResultadoEsperado.Free;  
  end;    
end;

function CarregarConteudoUnit(pNomeUnit :string; pSincRemoto :boolean) :string;
begin
  Result := '{}';

  if Trim(pNomeUnit) = '' then
    Exit;

  if pSincRemoto then
    pNomeUnit := {P39_TDD_CONSTANTES.}cPrefixoSincRemoto + pNomeUnit;

  try
    Result := CodificacaoUnit(pNomeUnit);
  except
    // Silencia o erro e mantém o Result padrão ('{}')
  end;
end;

procedure SincronizarCasoTeste;
var
  lCodigoCasoTeste :integer;
  lSqlCasoTeste    :string;
begin
  lSqlCasoTeste := 'select CT.AUTOINC_CT'                + #13 +
    'from CASO_TESTE CT'                                 + #13 +
    'where CT.DESCRICAO_CASO_TESTE_CT = :pDescricao and' + #13 +
    '      CT.MODULO_CT               = :pModulo    and' + #13 +
    '      CT.AREA_CT                 = :pArea;';

  lCodigoCasoTeste := {P39_TDD_ODBC.}TDDScalarODBCP(lSqlCasoTeste, [
    FCasoTeste.Descricao,
    FCasoTeste.Modulo,
    FCasoTeste.Area    
  ]);

  if lCodigoCasoTeste > 0 then
    QuestionarParaRodarUpdateCasoTeste(lCodigoCasoTeste)
  else
    InsertCasoTeste;
end;

procedure QuestionarParaRodarUpdateCasoTeste(pCodigoCasoTeste :integer);
var
  lRespostaUsuario    :integer;
  lSqlUpdateCasoTeste :string;
begin
  lRespostaUsuario := MessageDlg(
    Format(
      'Registro para o caso de teste: %s já existe!' + #13 + 'A operação de sincronização será realizada via update.' + #13 + 'Confirmar esta operação?',
      [FCasoTeste.Descricao]
    ), mtConfirmation, [mbYes, mbNo], 0
  );

  if lRespostaUsuario = mrYes then
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
  end
  else
  begin
    Exit;
  end;
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
