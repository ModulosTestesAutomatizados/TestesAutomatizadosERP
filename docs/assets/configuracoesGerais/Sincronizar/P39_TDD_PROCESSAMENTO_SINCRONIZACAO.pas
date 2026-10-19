unit P39_TDD_PROCESSAMENTO_SINCRONIZACAO;

uses P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS, P39_TDD_LOGS;

procedure Main;
begin
  // Alterar a fonte de sincronização entre local (false, opção default) e remoto (true)
  {P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.}FSincRemoto := True;
  // P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.Main; // Instruções!
  Sincronizar;
end;

end.
