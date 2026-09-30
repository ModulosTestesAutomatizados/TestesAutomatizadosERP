var FModoDebug, FExibirInstrucoes :Boolean;

{ ================================================================
  MAIN / INSTRUÇÕES
  ================================================================ }
procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit Responsável pelo Controle do Modo Debug, disponibilizado uma variável global "FModoDebug :Boolean" que pode ter seu valor setado diretamente pela unit que possui uses em TDD_LOGS.' + #13 +
    'Ainda foi adicionado mais um Controle de Exibição das Instruções das units por meio de "FExibirInstrucoes :Boolean" e um método auxiliar. Seu valor também é setado diretamente por outra unit.'       + #13 +
    '=====================================================================================================================================================================================================' + #13 +
    'Métodos do Controle de Debug disponibilizados pela Unit:'                                                                                                                                              + #13 +
    'procedure MostrarLogTextoEmModoDebug(pTexto :string)'                                                                                                                                                  + #13 +
    '  - A unit mostra um log texto com a mensagem enviada no parâmetro.'                                                                                                                                   + #13 +
    'procedure MostrarLogTextoEmModoDebugT(pTexto, pTitulo :string)'                                                                                                                                        + #13 +
    '  - Uma variante de log texto com título personalizado.'                                                                                                                                               + #13 +
    'procedure MostrarCDSEmModoDebug(CDSDebug: TClientDataSet)'                                                                                                                                             + #13 +
    '  - Outra variant, porém destinada à exibição de um CDS.'                                                                                                                                              + #13 +
    'procedure MostrarCDSEmModoDebugT(pCDSDebug: TClientDataSet, pTitulo :string)'                                                                                                                          + #13 +
    '  - Variante da exibição de CDS com titulo personalizado.'                                                                                                                                             + #13 +
    '=====================================================================================================================================================================================================' + #13 +
    'O comportamento descrito de todas as units depende de FModoDebug ser "True"!'                                                                                                                          + #13 +
    'As variantes "T" fazem uma validação se o parâmetro título não é vazio e todas as units adotam "[DEBUG]" como título padrão quando aplicável!'                                                         + #13 +
    'MostrarCDSEmModoDebugT mantém o valor True para o parâmetro de Modal.'                                                                                                                                 + #13 +
    '=====================================================================================================================================================================================================' + #13 +
    'Métodos do Controle de Exibição das Instruções disponibilizados pela Unit:'                                                                                                                            + #13 +
    'procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes :string)'                                                                                                                              + #13 +
    '  - Semelhante aos outros métodos do Controle de Modo Debug, mas a sua controladora para o MostrarLogTexto é diferente e não tem variação "T", o título aqui é o nome da unit validado e obrigatório!' + #13 +
    '=====================================================================================================================================================================================================' + #13 +
    'O comportamento descrito de todas as units depende de FExibirInstrucoes ser "True"!';
  MostrarInstrucoesUnit('TDD_LOGS', lInstrucoes);
end;

{$region MostrarLogs}
procedure MostrarLogTextoEmModoDebug(pTexto :string);
begin
  if FModoDebug then MostrarLogTexto(pTexto, '[DEBUG]');
end;

procedure MostrarLogTextoEmModoDebugT(pTexto, pTitulo :string);
begin
  if FModoDebug then MostrarLogTexto(pTexto, iif(Trim(pTitulo) <> '', pTitulo, '[DEBUG]'));
end;

procedure MostrarCDSEmModoDebug(CDSDebug :TClientDataSet);
begin
  if FModoDebug then MostrarCDS(CDSDebug);
end;

procedure MostrarCDSEmModoDebugT(pCDSDebug :TClientDataSet; pTitulo :string);
begin
  if FModoDebug then MostrarCDS(pCDSDebug, True, iif(Trim(pTitulo) <> '', pTitulo, '[DEBUG]'));
end;

procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes :string);
begin
  if Trim(pNomeUnitInstrucao) = '' then raise Exception.Create('Nome da unit não informado para exibir as instruções.');
  if FExibirInstrucoes then MostrarLogTexto(pInstrucoes, 'Instruções ' + pNomeUnitInstrucao);
end;
{$endregion}