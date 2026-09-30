unit P39_PROCESSAMENTO_TDD_FINANCEIRO;

uses P39_TDD_RUNNER;

procedure Main();
begin
  {P39_TDD_LOGS.}FModoDebug := False;
  TesteRunner;
end;

procedure TesteRunner;
begin
  {TDD_IRUNNER.}AddUsesUnit('REFACTOR_TDD_FINANCEIRO_PILOTO');
  {TDD_IRUNNER.}AddMetodo('ExecutarFluxoCompletoFinanceiro');
  {TDD_RUNNER.}Run('FINANCEIRO', 'FINANCEIRO', 'TDD_FINANCEIRO');  
end;

end.