unit ProcessamentoEspecifico;

uses TDD_RUNNER;

procedure Main();
begin
  {TDD_LOGS.}FModoDebug := False;
  TesteRunner;
end;

procedure TesteRunner;
begin
  {TDD_IRUNNER.}AddUnit('REFACTOR_TDD_FINANCEIRO_PILOTO');
  {TDD_IRUNNER.}Add('ExecutarFluxoCompletoFinanceiro');
  {TDD_RUNNER.}Run('FINANCEIRO', 'FINANCEIRO', 'TDD_FINANCEIRO');  
end;

procedure TesteIRunner;
begin
  AddUnit('TDD_TESTE_RUNNER');
  Add('_Setup');
  Add('_Teste');
  Executar;
end;

end.