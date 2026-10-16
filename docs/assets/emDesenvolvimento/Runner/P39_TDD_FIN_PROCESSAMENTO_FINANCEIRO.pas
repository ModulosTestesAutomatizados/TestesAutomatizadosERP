unit P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO;

uses TDD_RUN_IRUNNER;

procedure Main;
var lInstrucoes :string;
begin
  {P39_TDD_RUN_LOGS.}FExibirInstrucoes := False;
  lInstrucoes := 'Entrada do processamento financeiro que configura a unit e inicia o lote IRunner.'                       + #13 +
    '====================================================================================================================' + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                  + #13 +
    'procedure ExecutarIRunner'                                                                                            + #13 +
    '  - Configura TDD_FIN_FINANCEIRO e os literais FINANCEIRO/FINANCEIRO.'                                                + #13 +
    '  - Chama Executar para montar e interpretar o fluxo, sem registrar métodos.'                                         + #13 +
    '====================================================================================================================' + #13 +
    'Controles de exibição:'                                                                                               + #13 +
    'Main mantém FModoDebug ativo conforme configuração existente.'                                                        + #13 +
    'As instruções são exibidas somente se FExibirInstrucoes estiver ativo.'                                               + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('P39_TDD_PROCESSAMENTO_FINANCEIRO', lInstrucoes);
  {P39_TDD_RUN_LOGS.}FModoDebug := True;
  ExecutarIRunner;
end;

procedure ExecutarIRunner;
begin
  {P39_TDD_RUN_IRUNNER.}SetTDDUnit('TDD_FIN_FINANCEIRO');
  {P39_TDD_RUN_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_RUN_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_RUN_IRUNNER.}Executar;
end;

end.
