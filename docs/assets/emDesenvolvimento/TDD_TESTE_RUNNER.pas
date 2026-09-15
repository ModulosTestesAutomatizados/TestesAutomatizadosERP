uses TDD_RUNNER;

procedure Main;
begin
  {TDD_RUNNER.}FModoDebug := True;
  // Substitua pelos identificadores do caso que sera executado.
  {TDD_RUNNER.}ConfigurarCasoTeste('Modulo', 'Area', 'Descricao do caso de teste');
  {TDD_RUNNER.}Run(_Setup, _Teste);
end;

procedure _Setup;
begin
  ShowMessage('Runner Setup');
end;

procedure _Teste;
begin
  ShowMessage('Runner Teste');
end;
