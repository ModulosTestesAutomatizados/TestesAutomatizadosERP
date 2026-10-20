{ ================================================================
  Herda via P39_TDD_CASOS_DE_TESTE:
  - P39_TDD_CONSTANTES (constantes, cache, SQL)
  - P39_TDD_ODBC (TDDCommandODBC, TDDReaderODBC, TDDScalarODBC)
  - P39_TDD_FUNCOES_JSON (GetValueJson, ValorCurrencyTag, etc.)
  - P39_TDD_CACHE (CDSModulos, CDSAreas, AreaPeloNome, ModuloPeloNome)
  - P39_TDD_PARAMETRO (Setup_Inicializar_Parametros, SetParametro, etc.)
  - Estados como FModulo, FDescModulo, FArea, FDescArea, etc.
  ================================================================ }

uses P39_TDD_CASOS_DE_TESTE;

const cFP = 'FPrincipal';

var FP: TForm;

procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes := 'Unit responsável pela abertura de telas via menu e controle de foco/exibição do formulário principal.'    + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'FP :TForm'                                                                                                             + #13 +
    '  - Referência para a instância ativa do formulário principal da aplicação (FPrincipal).'                              + #13 +
    '===================================================================================================================='  + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                   + #13 +
    'procedure AbrirTela(pTela :string)'                                                                                   + #13 +
    '  - Aceita Caption ou Form do catálogo do módulo, ou um evento do principal diretamente.'                             + #13 +
    '  - O catálogo remoto P39_TDD_RUN_APPLICATION_MAPEAMENTO_JSON relaciona Form, caption e evento.'                       + #13 +
    'procedure FocarModulo'                                                                                                 + #13 +
    '  - Localiza o FPrincipal e aciona SetFocus e Repaint para garantir o foco e a atualização visual da tela.'            + #13 +
    'procedure TrazerParaFrente'                                                                                            + #13 +
    '  - Localiza o FPrincipal e executa o método BringToFront para colocar a janela do módulo em primeiro plano.'          + #13 +
    '===================================================================================================================='  + #13 +
    'Exige que FModulo e FDescModulo estejam previamente preenchidos; caso contrário, dispara exceção.'                     + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('P39_TDD_RUN_APPLICATION', lInstrucoes);
end;
  
procedure AbrirTela(pTela :string);
var
  lCatalogo, lModulo, lRegistro :TJSONObject;
  lPar                         :TJSONPair;
  lIndice, lEncontrados        :integer;
  lJson, lJsonModulo, lAlias,
  lNome, lCaption, lEvento,
  lNomeForm, lEventoResolvido   :string;
  lForm                        :TForm;
  lMetodos                     :TStringList;
  lEventoDireto                :boolean;
begin
  if (FModulo <= 0) or (Trim(FDescModulo) = '') then
    raise Exception.Create('Módulo não informado para abrir a tela.');

  pTela := Trim(pTela);
  if pTela = '' then
    raise Exception.Create('Tela não informada.');

  FP := FormCriadoPeloNome(cFP);

  if not Assigned(FP) then
    raise Exception.Create('Tela principal não encontrada.');
  
  // Consultar métodos não os executa. O nome não precisa terminar em Click.
  lEventoDireto := false;
  lMetodos := TStringList.Create;
  try
    lMetodos.Text := MetodosDeObjeto(FP);
    for lIndice := 0 to lMetodos.Count - 1 do
      if UpperCase(Trim(CorteAte(lMetodos[lIndice], '('))) = UpperCase(pTela) then
        lEventoDireto := true;
  finally
    lMetodos.Free;
  end;
  if lEventoDireto then
  begin
    {P39_TDD_RUN_LOGS.}RegistrarLog('Abrindo pelo evento: ' + pTela);
    TrazerParaFrente;
    FocarModulo;
    ExecutarMetodoDeObjeto(FP, pTela, [FP]);
    Exit;
  end;

  lAlias := UpperCase(Trim(Troca(pTela, '&', '')));
  lJson := CodificacaoUnit('P39_TDD_RUN_APPLICATION_MAPEAMENTO_JSON');
  if Copy(Trim(lJson), 1, 1) <> '{' then
    raise Exception.Create('Catálogo de telas deve ser um objeto JSON.');
  lCatalogo := TJSONObject.ParseJSONValue(lJson);
  if not Assigned(lCatalogo) then
    raise Exception.Create('Catálogo de telas inválido.');
  try
    lJsonModulo := '';
    for lIndice := 0 to lCatalogo.Count - 1 do
    begin
      lPar := ExecutarMetodoDeObjeto(lCatalogo, 'GetPair', [lIndice]);
      if UpperCase(Trim(GetPairName(lPar))) = UpperCase(Trim(FDescModulo)) then
      begin
        if lJsonModulo <> '' then
          raise Exception.Create('Módulo duplicado no catálogo de telas: ' + FDescModulo);
        lJsonModulo := GetPairValue(lPar);
      end;
    end;
  finally
    lCatalogo.Free;
  end;

  if Copy(Trim(lJsonModulo), 1, 1) <> '{' then
    raise Exception.Create('Módulo ausente ou inválido no catálogo de telas: ' + FDescModulo);
  lModulo := TJSONObject.ParseJSONValue(lJsonModulo);
  if not Assigned(lModulo) then
    raise Exception.Create('Catálogo do módulo inválido: ' + FDescModulo);
  lEncontrados := 0;
  lNomeForm := '';
  lEventoResolvido := '';
  try
    for lIndice := 0 to lModulo.Count - 1 do
    begin
      lPar := ExecutarMetodoDeObjeto(lModulo, 'GetPair', [lIndice]);
      lNome := Trim(GetPairName(lPar));
      lJson := GetPairValue(lPar);
      if (lNome = '') or (Copy(Trim(lJson), 1, 1) <> '{') then
        raise Exception.Create('Entrada inválida no catálogo de telas: ' + lNome);
      lRegistro := TJSONObject.ParseJSONValue(lJson);
      if not Assigned(lRegistro) then
        raise Exception.Create('Registro de tela inválido: ' + lNome);
      try
        lCaption := GetValueJson(lJson, 'caption');
        lEvento := Trim(GetValueJson(lJson, 'evento'));
        if (lAlias = UpperCase(lNome)) or
           ((Trim(lCaption) <> '') and (lAlias = UpperCase(Trim(Troca(lCaption, '&', ''))))) then
        begin
          lEncontrados := lEncontrados + 1;
          lNomeForm := lNome;
          lEventoResolvido := lEvento;
        end;
      finally
        lRegistro.Free;
      end;
    end;
  finally
    lModulo.Free;
  end;
  if lEncontrados = 0 then
    raise Exception.Create('Tela não mapeada no módulo ' + FDescModulo + ': ' + pTela);
  if lEncontrados > 1 then
    raise Exception.Create('Tela ambígua no módulo ' + FDescModulo + ': ' + pTela);

  lForm := FormCriadoPeloNome(lNomeForm);
  if not Assigned(lForm) then
  begin
    {P39_TDD_RUN_LOGS.}RegistrarLog('Abrindo tela: ' + pTela + ' | Form: ' + lNomeForm + ' | Evento: ' + lEventoResolvido);
    TrazerParaFrente;
    FocarModulo;
    if lEventoResolvido <> '' then
    begin
      ExecutarMetodoDeObjeto(FP, lEventoResolvido, [FP]);
      lForm := FormCriadoPeloNome(lNomeForm);
    end
    else
      lForm := CriarFormPeloNome(lNomeForm);
  end;
  if not Assigned(lForm) then
    raise Exception.Create('Formulário não aberto: ' + lNomeForm + ' | Evento: ' + lEventoResolvido);
  lForm.Show;
end;  
  
procedure FocarModulo;
begin
  if (FModulo <= 0) or (Trim(FDescModulo) = '') then
    raise Exception.Create('Módulo não informado para focar a tela.');

  FP := FormCriadoPeloNome(cFP);

  if not Assigned(FP) then
    raise Exception.Create('Tela principal não encontrada.');

  ExecutarMetodoDeObjeto(FP, 'SetFocus');
  ExecutarMetodoDeObjeto(FP, 'Repaint');
end; 

procedure TrazerParaFrente;
begin
  if (FModulo <= 0) or (Trim(FDescModulo) = '') then
    raise Exception.Create('Módulo não informado para trazer a tela à frente.');

  FP := FormCriadoPeloNome(cFP);

  if not Assigned(FP) then
    raise Exception.Create('Tela principal não encontrada.');

  ExecutarMetodoDeObjeto(FP, 'BringToFront');
end;
