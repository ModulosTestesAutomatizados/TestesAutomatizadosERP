uses P39_TDD_ODBC;

type
  TCasoTeste = record
    Modulo            :integer;
    Area              :integer;
    Descricao         :string;
    CasoTeste         :string;
    CamposDisponiveis :string;
    ResultadoEsperado :string;
  end;
  
var FCasoTeste :TCasoTeste;

procedure Main;
var lInstrucoes :string;
begin
  P39_TDD_ODBC.Main; // Documentacao!
  
  lInstrucoes := 'Essa Unit foi desenvolvida para registrar/sincronizar os casos de teste no banco dedicado, com fallback automÃ¡tico de MÃ³dulo e Ãrea.'                           + #13 +
    'Os seguintes mÃ©todos foram disponibilizados:'                                                                                                                                + #13 +
    ' - procedure RegistrarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste, pUnitJsonCasoTeste, pUnitJsonCamposDisponiveis, pUnitJsonResultadoEsperado :string)'  + #13 +
    '   + Registra/sincroniza o caso de teste, criando Modulo e Area caso nao existam (fallback).'                                                                                + #13 +
    ' - function RegistroFallbackModulo(pDescricaoModulo :string; pAtivarFallback :boolean) :integer'                                                                             + #13 +
    '   + Retorna o codigo do Modulo, criando-o quando nao existe e pAtivarFallback = true.'                                                                                      + #13 +
    ' - function RegistroFallbackArea(pCodigoModulo :integer; pDescricaoArea :string; pAtivarFallback :boolean) :integer'                                                         + #13 +
    '   + Retorna o codigo da Area, criando-a quando nao existe e pAtivarFallback = true.';
  MostrarLogTexto(lInstrucoes, 'Instrucoes P39_TDD_REGISTRAR_CASO_TESTE');
end;

function CarregarConteudoUnitJson(pUnitJson :string) :string;
begin
  if Trim(pUnitJson) <> '' then
    Result := CodificacaoUnit(pUnitJson)
  else
    Result := '{}';
end;

procedure RegistrarCasoTeste(
  pDescricaoModulo,
  pDescricaoArea,
  pDescricaoCasoTeste,
  pUnitJsonCasoTeste,
  pUnitJsonCamposDisponiveis,
  pUnitJsonResultadoEsperado      :string;
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
    lJsonCasoTeste.Text         := CarregarConteudoUnitJson(pUnitJsonCasoTeste);
    lJsonCamposDisponiveis.Text := CarregarConteudoUnitJson(pUnitJsonCamposDisponiveis);
    lJsonResultadoEsperado.Text := CarregarConteudoUnitJson(pUnitJsonResultadoEsperado);

    // MostrarLogTexto(JSONFormatado(lJsonCasoTeste.Text), 'Retorno da leitura da Codificacao Json'); // Debug

    lCodigoModulo := RegistroFallbackModulo(pDescricaoModulo, true);
    lCodigoArea   := RegistroFallbackArea(lCodigoModulo, pDescricaoArea, true);

    FCasoTeste.Modulo            := lCodigoModulo;
    FCasoTeste.Area              := lCodigoArea;
    FCasoTeste.Descricao         := pDescricaoCasoTeste;
    FCasoTeste.CasoTeste         := lJsonCasoTeste.Text;
    FCasoTeste.CamposDisponiveis := lJsonCamposDisponiveis.Text;
    FCasoTeste.ResultadoEsperado := lJsonResultadoEsperado.Text;

    // MostrarLogTexto(JSONFormatado(FCasoTeste.CasoTeste), 'Valor atribuido ao Caso de Teste'); // Debug 

    try
      SincronizarCasoTeste;
    except on ex: Exception do
      raise Exception.Create(ex.Message);
    end;

    // MostrarLogTexto('Novo Caso de Teste Registrado com Sucesso!', 'Resultado do Cadastro'); // Debug - Unit P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS ja mostra Log de conclusao!
  finally
    lJsonCasoTeste.Free;
    lJsonCamposDisponiveis.Free;
    lJsonResultadoEsperado.Free;  
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

  lCodigoCasoTeste := {P39_TDD_ODBC}TDDScalarODBCP(lSqlCasoTeste, [
    FCasoTeste.Descricao,
    FCasoTeste.Modulo,
    FCasoTeste.Area    
  ]);

  if lCodigoCasoTeste > 0 then
    QuestionarParaRodarUpdateCasoTeste(lCodigoCasoTeste)
  else
    InsertCasoTeste;
end;

procedure InsertCasoTeste;
var lSqlInsertCasoTeste :string;
begin
  // AUTOINC_CT e gen_id(GEN_CASO_TESTE, 1) removidos, Trigger no banco cuida do autoinc!
  lSqlInsertCasoTeste := 'insert into CASO_TESTE ('   + #13 +  
    '    MODULO_CT,'                                  + #13 +
    '    AREA_CT,'                                    + #13 +
    '    DESCRICAO_CASO_TESTE_CT,'                    + #13 +
    '    CASO_TESTE_CT,'                            + #13 +    
    '    CAMPOS_DISPONIVEIS_CT,'                      + #13 +
    '    RESULTADO_ESPERADO_CT'                       + #13 +
    ')'                                               + #13 +
    'values ('                                        + #13 +
    '    :pModulo,'                                   + #13 +
    '    :pArea,'                                     + #13 +
    '    :pDescricao,'                                + #13 +
    '    :pCasoTeste,'                                + #13 + 
    '    :pCamposDisponiveis,'                        + #13 + 
    '    :pResultadoEsperado'                         + #13 + 
    ');';

  // Comando parametrizado: NÃO usar QuotedStr (aspas literais corrompem o JSON no banco).
  {P39_TDD_ODBC}TDDCommandODBCP(lSqlInsertCasoTeste, [
    FCasoTeste.Modulo,
    FCasoTeste.Area,
    FCasoTeste.Descricao,
    FCasoTeste.CasoTeste,
    FCasoTeste.CamposDisponiveis,
    FCasoTeste.ResultadoEsperado
  ]);
end;

procedure QuestionarParaRodarUpdateCasoTeste(pCodigoCasoTeste :integer);
var
  lRespostaUsuario    :integer;
  lSqlUpdateCasoTeste :string;
begin
  lRespostaUsuario := MessageDlg(
    Format(
      'Registro para o caso de teste: %s jÃ¡ existe!' + #13 + 'A operaÃ§Ã£o de sincronizaÃ§Ã£o serÃ¡ realizada via update.' + #13 + 'Confirmar esta operaÃ§Ã£o?',
      [FCasoTeste.Descricao]
    ), mtConfirmation, [mbYes, mbNo], 0
  );

  if lRespostaUsuario = mrYes then
  begin
    lSqlUpdateCasoTeste := 'update CASO_TESTE CT'                         + #13 +
      'set CT.MODULO_CT                           = :pModulo,'            + #13 +
      '    CT.AREA_CT                             = :pArea,'              + #13 +
      '    CT.DESCRICAO_CASO_TESTE_CT             = :pDescricao,'         + #13 +
      '    CT.CASO_TESTE_CT                       = :pCasoTest,'          + #13 +
      '    CT.CAMPOS_DISPONIVEIS_CT               = :pCamposDisponiveis,' + #13 +
      '    CT.RESULTADO_ESPERADO_CT               = :pResultadoEsperado'  + #13 +
      'where CT.AUTOINC_CT                        = :pCodigoCasoTeste';

    // Comando parametrizado: NÃO usar QuotedStr (aspas literais corrompem o JSON no banco).
    {P39_TDD_ODBC}TDDCommandODBCP(lSqlUpdateCasoTeste, [
      FCasoTeste.Modulo,
      FCasoTeste.Area,
      FCasoTeste.Descricao,
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

function RegistroFallbackBase(pSqlSelect, pSqlInsert :string; pParametrosSql :OleVariant; pAtivarFallback :boolean) :integer;
var 
  lRetornoODBC   :OleVariant;
  lRetornoString :string;
begin
  // Recebe o resultado num tipo Variant para nÃ£o corromper a memÃ³ria.
  lRetornoODBC := {P39_TDD_ODBC}TDDScalarODBCP(pSqlSelect, pParametrosSql);  
  
  // Converte para string. Se for Null, VarToStr transforma em string vazia ''.
  lRetornoString := VarToStr(lRetornoODBC);
  
  // Checa se veio vazio ou zerado.
  if (lRetornoString = '') or (lRetornoString = '0') then
  begin
    // Verifica se deve usar o fallback.
    if (pAtivarFallback = true) then
    begin
      // Faz o insert
      {P39_TDD_ODBC}TDDCommandODBCP(pSqlInsert, pParametrosSql);
      
      // Consulta o ID novamente apÃ³s inserir
      lRetornoODBC := {P39_TDD_ODBC}TDDScalarODBCP(pSqlSelect, pParametrosSql);    
      lRetornoString := VarToStr(lRetornoODBC);      
    end
    else
      // Se nÃ£o usar o fallback, disparar um erro de 'recurso nÃ£o encontrado'.
      raise Exception.Create('Recurso nÃ£o encontrado. ');
  end;
  // Converte o valor final de forma segura
  Result := StrToInt(lRetornoString);     
end;

function RegistroFallbackModulo(pDescricaoModulo :string; pAtivarFallback :boolean) :integer;
var lSqlSelectModulo, lSqlInsertModulo :string;
begin
  lSqlSelectModulo := 'select MD.CODIGO_MODULO from MODULO MD where MD.DESCRICAO_MODULO = :pDescricao;';
  lSqlInsertModulo := 'insert into MODULO (DESCRICAO_MODULO) values (:pDescricao);';
  try
    Result := RegistroFallbackBase(
      lSqlSelectModulo,
      lSqlInsertModulo,
      [pDescricaoModulo],
      pAtivarFallback
    );
  except on ex: Exception do 
    raise Exception.Create(ex.Message + 'Nenhum mÃ³dulo corresponde aos parÃ¢metros de consulta! ');
  end;
end;

function RegistroFallbackArea(pCodigoModulo :integer; pDescricaoArea :string; pAtivarFallback :boolean) :integer;
var lSqlSelectArea, lSqlInsertArea :string;
begin
  lSqlSelectArea := 'select AREA.AUTOINC_AREA from AREA where AREA.DESCRICAO_AREA = :pDescricao and AREA.modulo_area = :pModulo;';
  lSqlInsertArea := 'insert into AREA (DESCRICAO_AREA, MODULO_AREA) values (:pDescricao, :pModulo);';
  try
    Result := RegistroFallbackBase(
      lSqlSelectArea,
      lSqlInsertArea,
      [pDescricaoArea, pCodigoModulo],
      pAtivarFallback
    );  
  except on ex: Exception do 
    raise Exception.Create(ex.Message + 'Nenhuma Ã¡rea corresponde aos parÃ¢metros de consulta! ');
  end;
end;
