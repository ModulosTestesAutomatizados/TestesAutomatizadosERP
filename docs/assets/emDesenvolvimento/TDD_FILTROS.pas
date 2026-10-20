uses P39_TDD_RUN_LOGS;

procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes := 'Unit responsavel por obter filtros logicos e atribuir seus valores a flags Boolean.'                      + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'Esta unit nao declara estado compartilhado proprio.'                                                                   + #13 +
    '===================================================================================================================='  + #13 +
    'Metodos disponibilizados pela Unit:'                                                                                   + #13 +
    'function ConverterFiltroLogicoEmBoolean(pValorFiltroString: String): Boolean'                                          + #13 +
    '  - Converte o valor logico retornado pelo filtro em Boolean; somente a opcao S ativa True.'                           + #13 +
    'procedure SetarFiltroLogicoEmBoolean(pNomeDoFiltro: String; var pBooleanRecebeFiltro: Boolean)'                        + #13 +
    '  - Le o filtro pelo nome e atribui o valor convertido a flag recebida por referencia.'                                + #13 +
    'procedure FiltroLogicoEmBoolean(pNomeDoFiltro: String; var pBooleanRecebeFiltro: Boolean)'                             + #13 +
    '  - Abre um filtro logico com valor inicial N, atribui a resposta a flag e libera o dataset.'                          + #13 +
    '===================================================================================================================='  + #13 +
    'Cada chamada a FiltroLogicoEmBoolean abre uma selecao independente.'                                                   + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_FILTROS', lInstrucoes);
end;

{$region CAST - CONVERSORES}
function ConverterFiltroLogicoEmBoolean(pValorFiltroString :String) :Boolean;
begin
  Result := UpperCase(Trim(pValorFiltroString)) = QuotedStr('S');
end;
{$endregion}

{$region SETTER DE VALORES DO FILTROS}
procedure SetarFiltroLogicoEmBoolean(pNomeDoFiltro :String; var pBooleanRecebeFiltro :Boolean);
begin
  pBooleanRecebeFiltro := ConverterFiltroLogicoEmBoolean(Filtro(pNomeDoFiltro));
end;
{$endregion}

{$region FILTROS}
procedure FiltroLogicoEmBoolean(pNomeDoFiltro :String; var pBooleanRecebeFiltro :Boolean);
var lCDSFiltro : TClientDataSet;
begin
  lCDSFiltro := TClientDataSet.Create;
  try
    lCDSFiltro.Data := EstruturaDeFiltrosDinamicos;
    IncluirFiltroDinamico(lCDSFiltro, pNomeDoFiltro, cTipoFiltro_Logico, 'N', '', '', '');
    lCDSFiltro.Data := ExecutarFiltroDinamico(lCDSFiltro.Data);

    SetarFiltroLogicoEmBoolean(pNomeDoFiltro, pBooleanRecebeFiltro);
  finally
    lCDSFiltro.Free;
  end;
end;
{$endregion}
