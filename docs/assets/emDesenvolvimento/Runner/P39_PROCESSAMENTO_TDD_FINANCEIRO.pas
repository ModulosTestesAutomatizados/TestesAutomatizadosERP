unit P39_PROCESSAMENTO_TDD_FINANCEIRO;

uses TDD_IRUNNER;

procedure Main;
var lInstrucoes :string;
begin
  {P39_TDD_LOGS.}FExibirInstrucoes := False;
  lInstrucoes := 'Entrada do processamento financeiro que configura a unit e inicia o lote IRunner.'                       + #13 +
    '====================================================================================================================' + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                  + #13 +
    'procedure ExecutarIRunner'                                                                                            + #13 +
    '  - Configura REFACTOR_TDD_FINANCEIRO_PILOTO e os literais FINANCEIRO/FINANCEIRO.'                                    + #13 +
    '  - Chama Executar para montar e interpretar o fluxo, sem registrar métodos.'                                         + #13 +
    '====================================================================================================================' + #13 +
    'Controles de exibição:'                                                                                               + #13 +
    'Main mantém FModoDebug ativo conforme configuração existente.'                                                        + #13 +
    'As instruções são exibidas somente se FExibirInstrucoes estiver ativo.'                                               + #13 +
    '====================================================================================================================';
  {P39_TDD_LOGS.}MostrarInstrucoesUnit('P39_PROCESSAMENTO_TDD_FINANCEIRO', lInstrucoes);
  {P39_TDD_LOGS.}FModoDebug := True;
  ExecutarIRunner;
end;

procedure ExecutarIRunner;
begin
  {P39_TDD_IRUNNER.}SetTDDUnit('REFACTOR_TDD_FINANCEIRO_PILOTO');
  {P39_TDD_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_IRUNNER.}Executar;
end;

end.
