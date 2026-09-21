// Herdado: P39_TDD_ODBC -> P39_TDD_CONSTANTES;
uses P39_TDD_ODBC;

var
  CDSModulos, CDSAreas: TClientDataSet;
  FCacheCarregado: Boolean; 

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
  CDSModulos.Free;
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
    raise Exception.Create(MensagemPersonalizada + 'Ãrea ' + pArea + ' nÃ£o encontrada.');
   
  Result := CDSAreas.FieldByName('AUTOINC_AREA').AsInteger;
end;

function GetArea(pCodArea: Integer): Integer;
begin
  ValidarArea;
  CDSAreas.IndexFieldNames := 'AUTOINC_AREA';

  if not CDSAreas.FindKey([pCodArea]) then
    raise Exception.Create(MensagemPersonalizada + 'Ãrea ' + IntToStr(pCodArea) + ' nÃ£o encontrada.');
   
  Result := CDSAreas.FieldByName('AUTOINC_AREA').AsInteger; 
end;

procedure ValidarArea;
begin
  VerificaCarregamentoCache;  
  if not assigned(CDSAreas)then
    raise exception.create(MensagemPersonalizada + 'Cache Areas NÃ£o Carregadas.');

  if CDSAreas.IsEmpty then
    raise exception.create(MensagemPersonalizada + 'Areas NÃ£o Carregadas.');
end;

function ModuloPeloNome(pModulo: String): Integer;
begin
  ValidarModulo;
  CDSModulos.IndexFieldNames := 'DESCRICAO_MODULO'; 
  if not CDSModulos.FindKey([pModulo]) then
    raise Exception.Create(MensagemPersonalizada + 'MÃ³dulo ' + pModulo + ' nÃ£o encontrado.');
    
  Result := CDSModulos.FieldByName('CODIGO_MODULO').AsInteger;
  
end;

function GetModulo(pCodModulo: Integer):Integer;
begin
  ValidarModulo;
  CDSModulos.IndexFieldNames := 'CODIGO_MODULO'; 
  if not CDSModulos.FindKey([pCodModulo]) then
    raise Exception.Create(MensagemPersonalizada + 'MÃ³dulo ' + IntToStr(pCodModulo) + ' nÃ£o encontrado.');
    
  Result := CDSModulos.FieldByName('CODIGO_MODULO').AsInteger;
end;

procedure ValidarModulo;
begin
  VerificaCarregamentoCache;
  if not assigned(CDSModulos)then
    raise exception.create(MensagemPersonalizada + 'Cache Modulos NÃ£o Carregados.');

  if CDSModulos.IsEmpty then
    raise exception.create(MensagemPersonalizada + 'Modulos NÃ£o Carregados.');
end;
