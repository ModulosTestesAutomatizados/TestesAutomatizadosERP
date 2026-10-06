unit P39_PROCESSAMENTO_TDD_FINANCEIRO;

uses TDD_RUNNER;

procedure Main();
begin
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
