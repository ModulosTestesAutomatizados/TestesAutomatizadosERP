unit ProcessamentoEspecifico;

uses TDD_RUNNER;

procedure Main();
begin
  {TDD_LOGS.}FModoDebug := False;
  TesteRunner;
end;

procedure TesteRunner;
begin
  {TDD_IRUNNER.}AddUsesUnit('REFACTOR_TDD_FINANCEIRO_PILOTO');
  {TDD_IRUNNER.}AddMetodo('ExecutarFluxoCompletoFinanceiro');
  {TDD_RUNNER.}Run('FINANCEIRO', 'FINANCEIRO', 'TDD_FINANCEIRO');  
end;

procedure TesteIRunner;
begin
  AddUsesUnit('TDD_TESTE_RUNNER');
  AddMetodo('_Setup');
  AddMetodo('_Teste');
  Executar;
end;

end.