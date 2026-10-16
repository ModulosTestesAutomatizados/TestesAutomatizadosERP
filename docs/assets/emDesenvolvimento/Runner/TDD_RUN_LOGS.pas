var
  FModoDebug, FExibirInstrucoes :Boolean;
  // Registro em memoria; Run controlara Clear por caso e o lote liberara a lista.
  FLogsCasoTeste :TStringList;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit responsável pelo registro de mensagens em memória e pela exibição condicionada de instruções.'      + #13 +
    '====================================================================================================================' + #13 +
    'Estado compartilhado:'                                                                                                + #13 +
    'FModoDebug :Boolean'                                                                                                  + #13 +
    '  - Habilita a exibição das mensagens; o registro em FLogsCasoTeste ocorre sempre.'                                   + #13 +
    'FExibirInstrucoes :Boolean'                                                                                           + #13 +
    '  - Habilita a exibição das instruções, independentemente de FModoDebug.'                                             + #13 +
    'FLogsCasoTeste :TStringList'                                                                                          + #13 +
    '  - Armazena mensagens do caso corrente; Run limpa por tentativa e o lote libera a lista.'                            + #13 +
    '====================================================================================================================' + #13 +
    'Métodos de registro:'                                                                                                 + #13 +
    'procedure RegistrarLog(pLog :string)'                                                                                 + #13 +
    '  - Sempre adiciona pLog + #13; com debug ativo também exibe a mensagem na tela.'                                     + #13 +
    'procedure DelimitadorLog(pTitulo :string)'                                                                            + #13 +
    '  - Registra separador, título e separador para agrupar mensagens da etapa.'                                          + #13 +
    '====================================================================================================================' + #13 +
    'Método de instruções:'                                                                                                + #13 +
    'procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes :string)'                                             + #13 +
    '  - Exige o nome da unit e exibe as instruções apenas quando FExibirInstrucoes está ativo.'                           + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_RUN_LOGS', lInstrucoes);
end;

{$region RegistroLogs}
procedure DelimitadorLog(pTitulo :string);
begin
  RegistrarLog(
    '====================================================================================================================' + #13 +
    pTitulo                                                                                                                + #13 +
    '====================================================================================================================' + #13
  );
end;

procedure RegistrarLog(pLog :string);
begin
  if not Assigned(FLogsCasoTeste) then
    FLogsCasoTeste := TStringList.Create;

  FLogsCasoTeste.Add(pLog + #13);

  if FModoDebug then
    MostrarLogTexto('[DEBUG]' + #13 + pLog);
end;
{$endregion}

{$region Mostrar Instruções}
procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes :string);
begin
  if Trim(pNomeUnitInstrucao) = '' then
  	raise Exception.Create('Nome da unit não informado para exibir as instruções.');

  if FExibirInstrucoes then
  	MostrarLogTexto(pInstrucoes, 'Instruções ' + pNomeUnitInstrucao);
end;
{$endregion}
