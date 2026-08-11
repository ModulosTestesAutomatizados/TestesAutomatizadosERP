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
  
var gCasoTeste :TCasoTeste;

procedure Main;
var lInstrucoes :string;
begin
  P39_TDD_ODBC.Main; // Documentação!
  
  lInstrucoes := 'Essa Unit foi desenvolvida para registrar/sincronizar os casos de teste no banco dedicado, '                                                                    + #13 +
    'com fallback automático de Módulo e Área.'                                                                                                                                   + #13 + #13 +
    'Os seguintes métodos foram disponibilizados:'                                                                                                                                + #13 +
    ' - procedure RegistrarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste, pCodificaoUnitJsonBase :string; pCamposDisponiveis, pResultadoEsperado :OleVariant)'  + #13 +
    '   + Registra/sincroniza o caso de teste, criando Módulo e Área caso não existam (fallback).'                                                                                + #13 +
    ' - function RegistroFallbackModulo(pDescricaoModulo :string; pAtivarFallback :boolean) :integer'                                                                             + #13 +
    '   + Retorna o código do Módulo, criando-o quando não existe e pAtivarFallback = true.'                                                                                      + #13 +
    ' - function RegistroFallbackArea(pCodigoModulo :integer; pDescricaoArea :string; pAtivarFallback :boolean) :integer'                                                         + #13 +
    '   + Retorna o código da Área, criando-a quando não existe e pAtivarFallback = true.';
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_REGISTRAR_CASO_TESTE');
end;  

procedure RegistrarCasoTeste(
  pDescricaoModulo,
  pDescricaoArea,
  pDescricaoCasoTeste,
  pCodificaoUnitJsonBase :string;
  pCamposDisponiveis,
  pResultadoEsperado :OleVariant
);
var
  lCodigoModulo,
  lCodigoArea,
  lSqlCasoTeste  :string;
  lJsonCasoTeste :TStringList;
begin
  lJsonCasoTeste := TStringList.Create;

  try  
    lJsonCasoTeste.Text := CodificacaoUnit(pCodificaoUnitJsonBase);
    //MostrarLogTexto(JSONFormatado(lJsonCasoTeste.Text), 'Retorno da leitura da Codificação Json'); // Debug

    lCodigoModulo := RegistroFallbackModulo(pDescricaoModulo, true);
    lCodigoArea   := RegistroFallbackArea(lCodigoModulo, pDescricaoArea, true);

    gCasoTeste.Modulo            := lCodigoModulo;
    gCasoTeste.Area              := lCodigoArea;
    gCasoTeste.Descricao         := pDescricaoCasoTeste;
    gCasoTeste.CasoTeste         := lJsonCasoTeste.Text;
    gCasoTeste.CamposDisponiveis := pCamposDisponiveis;
    gCasoTeste.ResultadoEsperado := pResultadoEsperado;        

    //MostrarLogTexto(JSONFormatado(gCasoTeste.CasoTeste), 'Valor atribuído ao Caso de Teste'); // Debug 

    try
      SincronizarCasoTeste;
    except on ex: Exception do
      raise Exception.Create(ex.Message);
    end;

    // MostrarLogTexto('Novo Caso de Teste Registrado com Sucesso!', 'Resultado do Cadastro'); // Debug - Unit TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS já mostra Log de conclusão!
  finally
    lJsonCasoTeste.Free;  
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

  lCodigoCasoTeste := TDDScalarODBC(lSqlCasoTeste, [
    gCasoTeste.Descricao,
    gCasoTeste.Modulo,
    gCasoTeste.Area    
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
    '    JSON_CASO_TESTE,'                            + #13 +    
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

  TDDCommandODBC(lSqlInsertCasoTeste, [
    gCasoTeste.Modulo,
    gCasoTeste.Area,
    gCasoTeste.Descricao,
    QuotedStr(gCasoTeste.CasoTeste),
    QuotedStr(gCasoTeste.CamposDisponiveis),
    QuotedStr(gCasoTeste.ResultadoEsperado)
  ]);
end;

procedure QuestionarParaRodarUpdateCasoTeste(pCodigoCasoTeste :integer);
var
  lRespostaUsuario    :integer;
  lSqlUpdateCasoTeste :string;
begin
  lRespostaUsuario := MessageDlg(
    Format(
      'Registro para o caso de teste: %s já existe!' + #13 + 'A operação de sincronização será realizada via update.' + #13 + 'Confirmar esta operação?',
      [gCasoTeste.Descricao]
    ), mtConfirmation, [mbYes, mbNo], 0
  );

  if lRespostaUsuario = mrYes then
  begin
    lSqlUpdateCasoTeste := 'update CASO_TESTE CT'                         + #13 +
      'set CT.MODULO_CT                           = :pModulo,'            + #13 +
      '    CT.AREA_CT                             = :pArea,'              + #13 +
      '    CT.DESCRICAO_CASO_TESTE_CT             = :pDescricao,'         + #13 +
      '    CT.JSON_CASO_TESTE                     = :pCasoTest,'          + #13 +
      '    CT.CAMPOS_DISPONIVEIS_CT               = :pCamposDisponiveis,' + #13 +
      '    CT.RESULTADO_ESPERADO_CT               = :pResultadoEsperado'  + #13 +
      'where CT.AUTOINC_CT                        = :pCodigoCasoTeste';

    TDDCommandODBC(lSqlUpdateCasoTeste, [
      gCasoTeste.Modulo,
      gCasoTeste.Area,
      gCasoTeste.Descricao,
      QuotedStr(gCasoTeste.CasoTeste),
      QuotedStr(gCasoTeste.CamposDisponiveis),
      QuotedStr(gCasoTeste.ResultadoEsperado),
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
  // Recebe o resultado num tipo Variant para não corromper a memória.
  lRetornoODBC := TDDScalarODBC(pSqlSelect, pParametrosSql);  
  
  // Converte para string. Se for Null, VarToStr transforma em string vazia ''.
  lRetornoString := VarToStr(lRetornoODBC);
  
  // Checa se veio vazio ou zerado.
  if (lRetornoString = '') or (lRetornoString = '0') then
  begin
    // Verifica se deve usar o fallback.
    if (pAtivarFallback = true) then
    begin
      // Faz o insert
      TDDCommandODBC(pSqlInsert, pParametrosSql);
      
      // Consulta o ID novamente após inserir
      lRetornoODBC := TDDScalarODBC(pSqlSelect, pParametrosSql);    
      lRetornoString := VarToStr(lRetornoODBC);      
    end
    else
      // Se não usar o fallback, disparar um erro de 'recurso não encontrado'.
      raise Exception.Create('Recurso não encontrado!');
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
    raise Exception.Create(ex.Message + 'Nenhum módulo corresponde aos parâmetros de consulta.');
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
    raise Exception.Create(ex.Message + 'Nenhuma área corresponde aos parâmetros de consulta.!');
  end;
end;
