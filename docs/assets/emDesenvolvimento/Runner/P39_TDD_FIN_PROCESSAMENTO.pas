unit P39_TDD_FIN_PROCESSAMENTO;

uses P39_TDD_IRUNNER;

procedure Main;
var lInstrucoes :string;
begin
  {P39_TDD_LOGS.}FExibirInstrucoes := False;
  lInstrucoes := 'Entrada do processamento financeiro que configura a unit e inicia o lote IRunner.'                       + #13 +
    '====================================================================================================================' + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                  + #13 +
    'procedure ExecutarIRunner'                                                                                            + #13 +
    '  - Configura P39_TDD_FIN_PAGAMENTO_RECEBIMENTO e os literais FINANCEIRO/FINANCEIRO.'                                    + #13 +
    '  - Chama Executar para montar e interpretar o fluxo, sem registrar métodos.'                                         + #13 +
    '====================================================================================================================' + #13 +
    'Controles de exibição:'                                                                                               + #13 +
    'Main mantém FModoDebug ativo conforme configuração existente.'                                                        + #13 +
    'As instruções são exibidas somente se FExibirInstrucoes estiver ativo.'                                               + #13 +
    '====================================================================================================================';
  {P39_TDD_LOGS.}MostrarInstrucoesUnit('P39_TDD_FIN_PROCESSAMENTO', lInstrucoes);
  {P39_TDD_LOGS.}FModoDebug := True;
  ExecutarIRunner;
end;

procedure ExecutarIRunner;
begin
  {P39_TDD_IRUNNER.}SetTDDUnit('P39_TDD_FIN_PAGAMENTO_RECEBIMENTO');
  {P39_TDD_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_IRUNNER.}AddParamsRun('''FINANCEIRO''');
  {P39_TDD_IRUNNER.}Executar;
end;

end.
