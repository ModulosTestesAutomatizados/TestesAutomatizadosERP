unit P39_PROCESSAMENTO_TDD_FINANCEIRO;

uses TDD_RUNNER;

procedure Main();
begin
  {P39_TDD_LOGS.}FModoDebug := True;
  TesteIRunner;
end;

procedure TesteIRunner;
begin
  {P39_TDD_IRUNNER.}AddUsesUnit('REFACTOR_TDD_FINANCEIRO_PILOTO');
  {P39_TDD_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_IRUNNER.}AddParamsRun('''TDD_FINANCEIRO''');
  {P39_TDD_IRUNNER.}AddMetodo('{REFACTOR_TDD_FINANCEIRO_PILOTO.}ExecutarFluxoCompletoFinanceiro');  
  {P39_TDD_IRUNNER.}Executar;  
end;

end.
