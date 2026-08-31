{ ---------------------------------------------------------------------------
  CompararValor REFACTORED - Usa a unit P39_TDD_VALIDAR_GENERICO
  
  ANTES (código original com problemas):
  - Variável lDM declarada duas vezes (String e TDataModule)
  - Erro de sintaxe: "else lTipoCampo = 'ftDateTime'" (faltou "if")
  - Lógica repetitiva para cada tipo de campo
  - Tipos não implementados: ftDateTime, ftCurrency, ftBoolean
  
  DEPOIS (código refatorado):
  - Usa CompararCampoPorTipo() para comparação genérica
  - Usa ObterValorCampoFormatado() para obter valor do campo
  - Usa ConverterParaCurrency() para conversão de valores
  - Corrigidos todos os bugs
--------------------------------------------------------------------------- }

{ ---------------------------------------------------------------------------
  Versão ORIGINAL (com problemas) - para referência
--------------------------------------------------------------------------- }
procedure CompararValorORIGINAL(pJSONItem: String);
var
  lCDSNome, lCampo, lDataSetName, lDM: String;  // BUG: lDM String
  lOperacao: Integer;
  lResultado, lTipoCampo: String;
  lCDS: TClientDataSet;
  lReal: Currency;
  lMensagem: String;
  lDM: TDataModule;  // BUG: lDM duplicado (TDataModule)
begin
  ShowMessage('Comparando Valor Do Objeto!');
  
  LimparVariaveis;
  
  lCampo     := GetValueJsonDef(pJSONItem, 'campo', '');
  lOperacao  := GetOperacao(GetValueJsonDef(pJSONItem, 'operacao', '-1'));
  lTipoCampo := GetValueJsonDef(pJSONItem, 'tipo_campo', 'ftString');
  lResultadoString := ValorStringTag(pJSONItem, 'resultado');
  
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
    AssertFalhou('tipo Campo', 'Campo String a operação deve ser Igual');
    Exit;
  end;

  if lOperacao = -1 then
  begin
    AssertFalhou('Valor', '(Operação -1 Inválida).');
    Exit;
  end;  

  for I := 0 to FDataSets.Count -1 do
  begin
    lDataSetName := FDataSets[I];
    lDM := CorteApos(lDataSetName, '|');  // lDM é String aqui
    lCDSNome := CorteAte(lDataSetName, '|');
    
    if lDM <> '' then
      lDM := DMCriadoPeloNome(lDM);  // BUG: lDM agora é TDataModule (conversão implícita)
      
    if Assigned(lDM) then  // lDM é TDataModule
      lCDS := lDM.FindComponent(lCDSNome)
    else
      lCDS := FonteDeDados(lCDS);
      
    if Assigned(lCDS) then
    begin
      if lCDS.FindField(lCampo) = Nil then
        Continue;
      
      if lOperacao = cOperacaoIgual then
        AssertIgual(lResultadoString, 
                    lCDS.FieldByName(lCampo).AsString, 
                    lCDS.FieldByName(lCampo).FieldName + '(' +  lCDS.FieldByName(lCampo).AsString + ' = (' + lResultado + ')')
      else
      begin
        try
          if lTipoCampo = 'ftInteger' then
          begin
              lResultadoInteger := StrToInt(lResultadoString);
              if lOperacao = cOperacaoMaior then
                AssertVerdadeiro(lResultadoInteger > lCDS.FieldByName(lCampo).AsInteger , 
                                 lCampo + ' ' + OperacaoDescricao(lOperacao) + ' ' + lResultadoString)
              else if lOperacao = cOperacaoMenor then
                AssertVerdadeiro(lResultadoInteger < lCDS.FieldByName(lCampo).AsInteger , 
                                 lCampo + ' ' + OperacaoDescricao(lOperacao) + ' ' + lResultadoString)
              else 
                Continue;                                      
          end
          else lTipoCampo = 'ftDateTime'  // BUG: falta "if" - erro de sintaxe
        except
          AssertsFalhou('Validar Valor', E.Message);  
        end;       
   
      end;                    
        
    end;      
  end;
end;

{ ---------------------------------------------------------------------------
  Versão REFACTORED (corrigida e genérica)
--------------------------------------------------------------------------- }
procedure CompararValor(pJSONItem: String);
var
  lCDSNome, lCampo, lDataSetName: String;
  lDMNome: String;
  lOperacao: Integer;
  lTipoCampo: String;
  lValorEsperado: String;
  lValorReal: String;
  lCDS: TClientDataSet;
  lDM: TDataModule;
  I: Integer;
begin
  ShowMessage('Comparando Valor Do Objeto!');
  
  LimparVariaveis;
  
  lCampo        := GetValueJsonDef(pJSONItem, 'campo', '');
  lOperacao     := GetOperacao(GetValueJsonDef(pJSONItem, 'operacao', '-1'));
  lTipoCampo    := GetValueJsonDef(pJSONItem, 'tipo_campo', 'ftString');
  lValorEsperado := ValorStringTag(pJSONItem, 'resultado');
  
  { --- Validações de entrada --- }
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
    AssertFalhou('Tipo Campo', 'Campo String: a operação deve ser Igual.');
    Exit;
  end;

  if lOperacao = -1 then
  begin
    AssertFalhou('Valor', '(Operação -1 Inválida).');
    Exit;
  end;

  { --- Varre os DataSets procurando o campo --- }
  for I := 0 to FDataSets.Count - 1 do
  begin
    lDataSetName := FDataSets[I];
    lDMNome      := CorteApos(lDataSetName, '|');
    lCDSNome     := CorteAte(lDataSetName, '|');

    lDM := nil;
    lCDS := nil;

    { Tenta obter o CDS via DataModule }
    if lDMNome <> '' then
    begin
      lDM := DMCriadoPeloNome(lDMNome);
      if Assigned(lDM) then
        lCDS := lDM.FindComponent(lCDSNome);
    end;

    { Fallback: tenta obter via FonteDeDados }
    if (not Assigned(lCDS)) then
      lCDS := FonteDeDados(lCDSNome);

    if not Assigned(lCDS) then
      Continue;

    { Campo não existe neste CDS → pula para o próximo }
    if lCDS.FindField(lCampo) = nil then
      Continue;

    { --- Obtém o valor real do campo formatado como String --- }
    lValorReal := ObterValorCampoFormatado(lCDS, lCampo, lTipoCampo);

    { --- Chama a função genérica de comparação --- }
    CompararCampoPorTipo(lTipoCampo, lValorReal, lValorEsperado, lOperacao, lCampo);

    { Sai após encontrar e comparar o campo no primeiro CDS que o possui }
    Break;
  end;
end;
