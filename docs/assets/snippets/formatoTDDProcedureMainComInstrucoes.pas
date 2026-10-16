procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes := 'Unit responsável pelo(a) ... (responsabilidade da unit de forma resumida).'                               + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'Variável global e o seu tipo.'                                                                                         + #13 +
    '  - Explicação da responsabilidade desse estado.'                                                                      + #13 +
    '  - Explicação da responsabilidade desse estado.'                                                                      + #13 +
    '===================================================================================================================='  + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                   + #13 +
    'Assinatura do método (procedure ou function) com nome, parâmetros, tipos e retornos.'                                  + #13 +
    '  - Explicação sobre a finalidade do método.'                                                                          + #13 +
    '  - Explicação sobre a finalidade do método.'                                                                          + #13 +
    '===================================================================================================================='  + #13 +    
    'Comentário geral ou observações pontuais da unit.'                                                                     + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('NOME_UNIT', lInstrucoes);
end;
