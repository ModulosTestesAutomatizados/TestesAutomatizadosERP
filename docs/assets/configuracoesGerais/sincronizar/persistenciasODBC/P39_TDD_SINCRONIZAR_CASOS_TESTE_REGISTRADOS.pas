uses P39_TDD_REGISTRAR_CASO_TESTE;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Essa Unit foi desenvolvida para sincronizar no banco dedicado os casos de teste mapeados em seu corpo.' + #13 +
    'Realiza a sincronização de todos os casos de teste presentes em RegistrosCasosTestes.'                               + #13 + #13 +
    'Métodos disponibilizado:'                                                                                            + #13 +
    ' - procedure Sincronizar'                                                                                            + #13 +
    '   + Sincroniza os casos de teste definidos no corpo da rotina. Utiliza {P39_TDD_REGISTRAR_CASO_TESTE.}RegistrarCasoTeste';
  {P39_TDD_REGISTRAR_CASO_TESTE -> P39_TDD_ODBC -> P39_TDD_CONSTANTES -> P39_TDD_LOGS.}MostrarInstrucoesUnit('TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS', lInstrucoes);
end;

procedure Sincronizar;
begin
  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, '[SINCRONIZANDO] Carregando registros...');
    RegistrosCasosTestes;
  finally
    CallBack_FechaTela(ClassOwner);
  end;
  MostrarLogTexto('Os casos de teste foram sincronizados no banco de dados!', 'Sincronização Concluída');
end;

procedure RegistrosCasosTestes;
begin
  // --------------- DESCRIÇÃO DO MÓDULO ------ DESCRIÇÃO DA AREA ------ DESCRIÇÃO CASO TESTE -------------------- UNIT TIPO JSON COM OS DADOS DO CASOS DE TESTE ------ CAMPOS DISPONÍVEIS ------ RESULTADO ESPERADO.
  RegistrarCasoTeste('FINANCEIRO',              'BORDERÔ',               'CADASTRAR DUPLICATA A RECEBER',          'P39_TDD_JSON_FINANCEIRO',                           '',                       '');
  RegistrarCasoTeste('FATURAMENTO',             'PEDIDO DE VENDA',       'PEDIDO COM DESCONTO PERCENTUAL',         'P39_TDD_JSON_PEDIDO_DESCONTO_PERCENTUAL',           '',                       'P39_TDD_JSON_BASE_RESULTADO_ESPERADO');
  RegistrarCasoTeste('FATURAMENTO',             'PEDIDO DE VENDA',       'PEDIDO POR UNIDADE FABRIL',              'P39_TDD_JSON_PEDIDO_UNIDADE_FABRIL',                '',                       'P39_TDD_JSON_BASE_RESULTADO_ESPERADO');
  RegistrarCasoTeste('FATURAMENTO',             'PEDIDO DE VENDA',       'PEDIDO COM SEQUENCIA NOS ITENS',         'P39_TDD_JSON_PEDIDO_SEQUENCIA_ITENS',               '',                       'P39_TDD_JSON_BASE_RESULTADO_ESPERADO');
end;
