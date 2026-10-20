unit P39_TDD_PROCESSAMENTO_SINCRONIZACAO;

uses P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS, P39_TDD_FILTROS;

procedure Main;
begin
  // Alterar a fonte de sincronização entre local (false, opção default) e remoto (true)
  {P39_TDD_FILTROS.}FiltroLogicoEmBoolean('Sincronizar Remoto?', {P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.}FSincRemoto);
  
  {P39_TDD_FILTROS.}FiltroLogicoEmBoolean('Exibir Instruções?', {P39_TDD_RUN_LOGS.}FExibirInstrucoes);
  P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.Main; // Instruções!
  Sincronizar;
end;

end.
