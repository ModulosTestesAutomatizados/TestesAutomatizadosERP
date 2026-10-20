uses P39_TDD_REGISTRAR_CASO_TESTE, P39_TDD_FILTROS;

var FSincRemoto :Boolean;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit responsável pela sincronização de casos de teste remotos/locais e banco de dados.'                      + #13 +
    '===================================================================================================================='     + #13 +
    'Estado compartilhado:'                                                                                                    + #13 +
    'FSincRemoto :Boolean'                                                                                                     + #13 +
    '  - Quando ativado, busca fontes da Tek Store utilizando o prefixo {TDD_CONSTANTES.}cPrefixoSincRemoto.'                  + #13 +
    '===================================================================================================================='     + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                      + #13 +
    'procedure Sincronizar'                                                                                                    + #13 +
    '  - Adiciona um callback para feedback ao usuário com finalidade de acompanhamento do processo.'                          + #13 +
    '  - Chamada para RegistrosCasosTestes.'                                                                                   + #13 +
    'procedure RegistrosCasosTestes(pSincRemoto :boolean)'                                                                     + #13 +
    '  - Registrar cada um dos casos de teste com suas respectivas informações sem considerar o prefixo do ambiente remoto.'   + #13 +
    '  - Utilização em sequência do método {TDD_REGISTRAR_CASO_TESTE.}RegistrarCasoTeste.'                                     + #13 +
    '===================================================================================================================='     + #13 +
    'O formato esperado do parâmetro de REQUISITO_VERSAO em RegistrosCasosTestes é: ''xxx.yy''.'                               + #13 +
    'RegistrosCasosTestes utiliza CarregarConteudoUnit, o booleano true adiciona o prefixo remoto ao nome das units.'          + #13 +
    '====================================================================================================================';
  {P39_TDD_REGISTRAR_CASO_TESTE -> P39_TDD_ODBC -> P39_TDD_CONSTANTES -> P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS', lInstrucoes);
end;

procedure Sincronizar;
begin
  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, '[SINCRONIZANDO] Carregando registros...');
    {P39_TDD_FILTROS} FiltroLogicoEmBoolean('Sincronizar com Remoto? (Tek Store)', FSincRemoto);
    RegistrosCasosTestes(FSincRemoto);
  finally
    CallBack_FechaTela(ClassOwner);
  end;
  MostrarLogTexto('Os casos de teste foram sincronizados no banco de dados!', 'Sincronização Concluída');
end;

procedure RegistrosCasosTestes(pSincRemoto :boolean);
begin
  // --------------- DESCRIÇÃO DO MÓDULO ------ DESCRIÇÃO DA AREA ------ DESCRIÇÃO CASO TESTE --------------------------------- REQUISITO_VERSAO ------ UNIT TIPO JSON COM OS DADOS DO CASOS DE TESTE ------ CONTROLE PARA SINCRONIZAR COM REMOTO/LOCAL.
  RegistrarCasoTeste('FINANCEIRO',              'FINANCEIRO',            'TDD_FIN_FINANCEIRO',                                  '160.00',               'TDD_FIN_FINANCEIRO_JSON',                           pSincRemoto);
  RegistrarCasoTeste('FATURAMENTO',             'PEDIDO DE VENDA',       'PEDIDO COM DESCONTO PERCENTUAL',                      '',                     'TDD_JSON_PEDIDO_DESCONTO_PERCENTUAL',               pSincRemoto);
  RegistrarCasoTeste('FATURAMENTO',             'PEDIDO DE VENDA',       'PEDIDO POR UNIDADE FABRIL',                           '',                     'TDD_JSON_PEDIDO_UNIDADE_FABRIL',                    pSincRemoto);
  RegistrarCasoTeste('FATURAMENTO',             'PEDIDO DE VENDA',       'PEDIDO COM SEQUENCIA NOS ITENS',                      '',                     'TDD_JSON_PEDIDO_SEQUENCIA_ITENS',                   pSincRemoto);
  RegistrarCasoTeste('FATURAMENTO',             'CARGA',                 'TDD_FAT_CARGA',                                       '',                     'TDD_FAT_CARGA_JSON',                                pSincRemoto);
end;
