// Herdado: P39_TDD_ODBC -> P39_TDD_CONSTANTES -> P39_TDD_RUN_LOGS;
uses P39_TDD_ODBC;

var
  CDSModulos, CDSAreas: TClientDataSet;
  FCacheCarregado: Boolean;

procedure Main;
var lInstrucoes :string;
begin
  lInstrucoes := 'Unit responsável pelo cache de módulos e áreas usados na seleção dos casos de teste.'                     + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'CDSModulos, CDSAreas :TClientDataSet'                                                                                  + #13 +
    '  - Guardam as tabelas de módulos e áreas carregadas do banco dedicado.'                                               + #13 +
    'FCacheCarregado :Boolean'                                                                                              + #13 +
    '  - Indica que os dois datasets foram preenchidos.'                                                                    + #13 +
    '===================================================================================================================='  + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                   + #13 +
    'procedure Cache_Setup_CarregarInformacoes'                                                                             + #13 +
    '  - Cria os datasets quando necessário e carrega módulos e áreas.'                                                     + #13 +
    'procedure Cache_TearDown_LimparInformacoes'                                                                            + #13 +
    '  - Libera os datasets criados, inclusive após setup parcial.'                                                         + #13 +
    'procedure VerificaCarregamentoCache'                                                                                   + #13 +
    '  - Solicita a carga quando o cache ainda não foi preenchido.'                                                         + #13 +
    'function AreaPeloNome(pArea :String) :Integer'                                                                         + #13 +
    '  - Localiza a área pela descrição.'                                                                                   + #13 +
    'function GetArea(pCodArea :Integer) :Integer'                                                                          + #13 +
    '  - Localiza a área pelo código.'                                                                                      + #13 +
    'procedure ValidarArea'                                                                                                 + #13 +
    '  - Garante que o dataset de áreas foi carregado e contém registros.'                                                  + #13 +
    'function ModuloPeloNome(pModulo :String) :Integer'                                                                     + #13 +
    '  - Localiza o módulo pela descrição.'                                                                                 + #13 +
    'function GetModulo(pCodModulo :Integer) :Integer'                                                                      + #13 +
    '  - Localiza o módulo pelo código.'                                                                                    + #13 +
    'procedure ValidarModulo'                                                                                               + #13 +
    '  - Garante que o dataset de módulos foi carregado e contém registros.'                                                + #13 +
    '===================================================================================================================='  + #13 +
    'O cache é compartilhado no lote e liberado no encerramento do fluxo IRunner.'                                          + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('P39_TDD_CACHE', lInstrucoes);
end;

procedure Cache_Setup_CarregarInformacoes;
begin
  if not Assigned(CDSModulos) then
    CDSModulos := TClientDataSet.Create;

  if not Assigned(CDSAreas) then
    CDSAreas := TClientDataSet.Create;

  CDSModulos.Data := TDDReaderODBC(SQLModulos);
  CDSAreas.Data   := TDDReaderODBC(SQLAreas);
  FCacheCarregado := True;
end;

procedure Cache_TearDown_LimparInformacoes;
begin
  if Assigned(CDSModulos) then
    CDSModulos.Free;
  if Assigned(CDSAreas) then
    CDSAreas.Free;
  FCacheCarregado := False;  
end;

procedure VerificaCarregamentoCache;
begin
  if not FCacheCarregado then
    Cache_Setup_CarregarInformacoes;  
end;

function AreaPeloNome(pArea: String):Integer;
begin
  ValidarArea;  
  CDSAreas.IndexFieldNames := 'DESCRICAO_AREA';

  if not CDSAreas.FindKey([pArea]) then
    raise Exception.Create('Área ' + pArea + ' não encontrada.');
   
  Result := CDSAreas.FieldByName('AUTOINC_AREA').AsInteger;
end;

function GetArea(pCodArea: Integer): Integer;
begin
  ValidarArea;
  CDSAreas.IndexFieldNames := 'AUTOINC_AREA';

  if not CDSAreas.FindKey([pCodArea]) then
    raise Exception.Create('Área ' + IntToStr(pCodArea) + ' não encontrada.');
   
  Result := CDSAreas.FieldByName('AUTOINC_AREA').AsInteger; 
end;

procedure ValidarArea;
begin
  VerificaCarregamentoCache;  
  if not assigned(CDSAreas)then
    raise exception.create('Cache Areas Não Carregadas.');

  if CDSAreas.IsEmpty then
    raise exception.create('Areas Não Carregadas.');
end;

function ModuloPeloNome(pModulo: String): Integer;
begin
  ValidarModulo;
  CDSModulos.IndexFieldNames := 'DESCRICAO_MODULO'; 
  if not CDSModulos.FindKey([pModulo]) then
    raise Exception.Create('Módulo ' + pModulo + ' não encontrado.');
    
  Result := CDSModulos.FieldByName('CODIGO_MODULO').AsInteger;
  
end;

function GetModulo(pCodModulo: Integer):Integer;
begin
  ValidarModulo;
  CDSModulos.IndexFieldNames := 'CODIGO_MODULO'; 
  if not CDSModulos.FindKey([pCodModulo]) then
    raise Exception.Create('Módulo ' + IntToStr(pCodModulo) + ' não encontrado.');
    
  Result := CDSModulos.FieldByName('CODIGO_MODULO').AsInteger;
end;

procedure ValidarModulo;
begin
  VerificaCarregamentoCache;
  if not assigned(CDSModulos)then
    raise exception.create('Cache Modulos Não Carregados.');

  if CDSModulos.IsEmpty then
    raise exception.create('Modulos Não Carregados.');
end;
