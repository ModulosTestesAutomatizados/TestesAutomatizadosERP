uses P39_TDD_REGISTRAR_CASO_TESTE;

procedure Main;
var lInstrucoes :string;
begin
  P39_TDD_REGISTRAR_CASO_TESTE.Main; // Documentação!
  
  lInstrucoes := 'Essa Unit foi desenvolvida para sincronizar no banco dedicado os casos de teste mapeados em seu corpo.' + #13 +
    'Para cada caso, ela chama P39_TDD_REGISTRAR_CASO_TESTE.Main, que registra/atualiza o caso na tabela CASO_TESTE.'     + #13 + #13 +
    'Métodos disponibilizado:'                                                                                            + #13 +
    ' - procedure Sincronizar'                                                                                            + #13 +
    '   + Sincroniza os casos de teste definidos no corpo da rotina.';
  
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS');
end;

procedure Sincronizar;
begin  
  // --------------- DESCRIÇÃO DO MÓDULO ------ DESCRIÇÃO DA AREA ------ DESCRIÇÃO CASO TESTE -------------------- UNIT TIPO JSON COM OS DADOS DO CASOS DE TESTE ---------- CAMPOS DISPONÍVEIS ------ RESULTADO ESPERADO.
  RegistrarCasoTeste('FINANCEIRO',              'BORDERÔ',               'CADASTRAR DUPLICATA A RECEBER',          'P39_TDD_JSON_BASE_CADASTRO_DUPLICATAS_RECEBER',         '',                       '');
  
  MostrarLogTexto('Os casos de teste foram sincronizados no banco de dados!', 'Sincronização Concluída');
end;
