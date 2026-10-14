var
  FModoDebug, FExibirInstrucoes :Boolean;
  // Registro em memoria; Run controlara Clear por caso e o lote liberara a lista.
  FLogsCasoTeste :TStringList;

{ ================================================================
  MAIN / INSTRUÇÕES
  ================================================================ }
procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit responsável pelo registro de mensagens em memória e pela exibição condicionada de instruções.'      + #13 +
    '====================================================================================================================' + #13 +
    'Estado compartilhado:'                                                                                                + #13 +
    'FModoDebug :Boolean'                                                                                                  + #13 +
    '  - Habilita somente o registro de mensagens em FLogsCasoTeste.'                                                      + #13 +
    'FExibirInstrucoes :Boolean'                                                                                           + #13 +
    '  - Habilita a exibição das instruções, independentemente de FModoDebug.'                                             + #13 +
    'FLogsCasoTeste :TStringList'                                                                                          + #13 +
    '  - Armazena mensagens do caso corrente; Run limpa por tentativa e o lote libera a lista.'                            + #13 +
    '====================================================================================================================' + #13 +
    'Métodos de registro:'                                                                                                 + #13 +
    'procedure RegistrarLogEmModoDebug(pLog :string)'                                                                      + #13 +
    '  - Cria a lista se necessário; com debug ativo adiciona pLog + #13, sem log nativo.'                                 + #13 +
    'procedure DelimitadorLog(pTitulo :string)'                                                                            + #13 +
    '  - Registra separador, título e separador para agrupar mensagens da etapa.'                                          + #13 +
    '====================================================================================================================' + #13 +
    'Método de instruções:'                                                                                                + #13 +
    'procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes :string)'                                             + #13 +
    '  - Exige o nome da unit e exibe as instruções apenas quando FExibirInstrucoes está ativo.'                           + #13 +
    '====================================================================================================================';
  {P39_TDD_LOGS.}MostrarInstrucoesUnit('P39_TDD_LOGS', lInstrucoes);
end;

{$region RegistroLogs}
procedure DelimitadorLog(pTitulo :string);
begin
  RegistrarLogEmModoDebug(
    '====================================================================================================================' + #13 +
    pTitulo                                                                                                                + #13 +
    '====================================================================================================================' + #13
  );
end;

procedure RegistrarLogEmModoDebug(pLog :string);
begin
  if not Assigned(FLogsCasoTeste) then
    FLogsCasoTeste := TStringList.Create;

  if FModoDebug then
  begin
    FLogsCasoTeste.Add(pLog + #13);
  end;
end;
{$endregion}

{$region Mostrar Instruções}
procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes :string);
begin
  if Trim(pNomeUnitInstrucao) = '' then raise Exception.Create('Nome da unit não informado para exibir as instruções.');
  if FExibirInstrucoes then MostrarLogTexto(pInstrucoes, 'Instruções ' + pNomeUnitInstrucao);
end;
{$endregion}
