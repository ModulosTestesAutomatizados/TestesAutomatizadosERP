unit TDD_FAT_PROCESSAMENTO_CARGA;

uses TDD_RUN_IRUNNER, TDD_FILTROS;

procedure Main;
var lInstrucoes: String;
begin
  {TDD_FILTROS.}FiltroLogicoEmBoolean('Exibir Instruções?', {P39_TDD_RUN_LOGS.}FExibirInstrucoes);
  lInstrucoes := 'Unit responsavel por iniciar o lote IRunner da area FATURAMENTO/CARGA.'                                   + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'FExibirInstrucoes: Boolean (P39_TDD_RUN_LOGS)'                                                                         + #13 +
    '  - Controla a exibicao das instrucoes herdadas durante o processamento.'                                              + #13 +
    '===================================================================================================================='  + #13 +
    'Metodos disponibilizados pela Unit:'                                                                                   + #13 +
    'procedure ExecutarIRunner'                                                                                             + #13 +
    '  - Configura TDD_FAT_CARGA, FATURAMENTO e CARGA e executa o lote.'                                                    + #13 +
    '===================================================================================================================='  + #13 +
    'Main pergunta se exibe as instrucoes e chama ExecutarIRunner uma vez.'                                                 + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_FAT_PROCESSAMENTO_CARGA', lInstrucoes);
  ExecutarIRunner;
end;

procedure ExecutarIRunner;
begin
  {P39_TDD_RUN_IRUNNER.}SetTDDUnit('TDD_FAT_CARGA');
  {P39_TDD_RUN_IRUNNER.}AddParamsRun('''FATURAMENTO''');
  {P39_TDD_RUN_IRUNNER.}AddParamsRun('''CARGA''');
  {P39_TDD_RUN_IRUNNER.}Executar;
end;

end.
