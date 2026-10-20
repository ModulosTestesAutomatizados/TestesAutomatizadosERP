unit P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO;

uses TDD_RUN_IRUNNER, TDD_FILTROS;

procedure Main;
var lInstrucoes :string;
begin
  {TDD_FILTROS.}FiltroLogicoEmBoolean('Exibir Instruções?', {P39_TDD_RUN_LOGS.}FExibirInstrucoes);
  lInstrucoes := 'Unit responsavel por configurar as flags e iniciar o lote IRunner do financeiro.'                         + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'FExibirInstrucoes, FModoDebug: Boolean (P39_TDD_RUN_LOGS)'                                                             + #13 +
    '  - Controlam a exibicao das instrucoes e dos logs durante o processamento.'                                           + #13 +
    '===================================================================================================================='  + #13 +
    'Metodos disponibilizados pela Unit:'                                                                                   + #13 +
    'procedure ExecutarIRunner'                                                                                             + #13 +
    '  - Configura TDD_FIN_FINANCEIRO e os literais FINANCEIRO/FINANCEIRO.'                                                 + #13 +
    '  - Chama Executar para montar e interpretar o fluxo.'                                                                 + #13 +
    '===================================================================================================================='  + #13 +
    'Main pergunta se exibe as instrucoes e os logs antes de iniciar o lote.'                                               + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO', lInstrucoes);
  {TDD_FILTROS.}FiltroLogicoEmBoolean('Modo Debug?', {P39_TDD_RUN_LOGS.}FModoDebug);
  ExecutarIRunner;
end;

procedure ExecutarIRunner;
begin
  {P39_TDD_RUN_IRUNNER.}SetTDDUnit('TDD_FIN_FINANCEIRO');
  {P39_TDD_RUN_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_RUN_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_RUN_IRUNNER.}Executar;
end;

end.
