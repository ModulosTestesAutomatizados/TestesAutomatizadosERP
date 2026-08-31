uses P39_TDD_CONSTANTES, P39_TDD_ODBC;

procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes := 'Unit responsável por registrar a execução dos casos de teste na tabela CASO_TESTE_EXECUCAO.' + #13 +
    'Banco: TESTEAUTOMATIZADOMC.FDB (banco que REGISTRA os casos de teste).' + #13 + #13 +
    'Métodos disponíveis:' + #13 +
    ' - procedure RegistrarExecucaoCasoTeste(pCasoTeste, pStatus, pVersao: String; pTempo: TDateTime; pLog: String);' + #13 +
    '   + Insere um registro de execução de caso de teste.' + #13 +
    '   + Parâmetros:' + #13 +
    '     * pCasoTeste: Código do caso de teste (FK para CASO_TESTE.AUTOINC_CT)' + #13 +
    '     * pStatus: Status da execução (0 = Sucesso, 1 = Erro)' + #13 +
    '     * pVersao: Versão do sistema executado' + #13 +
    '     * pTempo: Data/hora da execução' + #13 +
    '     * pLog: Mensagem de erro (opcional, apenas quando status = 1)' + #13 + #13 +
    'Geração de chave: utiliza o generator GEN_CASO_TESTE_EXECUCAO_ID.';
  MostrarLogTexto(lInstrucoes, 'Instruções TDD_REGISTRAR_CASO_TESTE_EXECUCAO');
end;

procedure RegistrarExecucaoCasoTeste(pCasoTeste: String; pStatus: Integer; pVersao: String; pTempo: TDateTime; pLog: String);
var lSql: String;
    lId: OleVariant;
begin
  lId := TDDScalarODBC('SELECT NEXT VALUE FOR GEN_CASO_TESTE_EXECUCAO_ID FROM RDB$DATABASE', null);

  lSql := 'INSERT INTO CASO_TESTE_EXECUCAO (' +
          'AUTOINC_CTE, ' +
          'DATA_CTE, ' +
          'TEMPO_CTE, ' +
          'STATUS_CTE, ' +
          'CASO_TESTE_CTE, ' +
          'LOG_CTE, ' +
          'VERSAO_CTE' +
          ') VALUES (' +
          IntToStr(lId) + ', ' +
          'CURRENT_TIMESTAMP, ' +
          QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', pTempo)) + ', ' +
          IntToStr(pStatus) + ', ' +
          pCasoTeste + ', ' +
          QuotedStr(pLog) + ', ' +
          QuotedStr(pVersao) +
          ')';

  TDDCommandODBC(lSql, null);
end;
