type
  TVersao = record
    Versao: Currency;
    Codigo: Integer;
    Numero: Integer;
  end;

const
  cDataBase = 'DBTESTESAUTOMATIZADOS';
  //cDataBase = 'DSN=DBTESTESAUTOMATIZADOS;';

  cConexaoODBCPadrao = 'TESTE_AUTOMATIZADO_32B'; // Adicionado com duplicidade para não quebrar testes antigos ao remover cDataBase

var
  CDSModulos, CDSAreas: TClientDataSet;
  FCacheCarregado: Boolean;

function GetVersao:TVersao;
var 
  V: TVersao;
  CDS: TClientDataSet;
begin
  CDS := TClientDataSet.Create; 
  try
  	CDS.Data := ExecuteReaderODBCServ(cDataBase, 'select * from VERSAO_CTRL');
    V.Versao := CDS.FieldByName('VERSAO').AsCurrency;
    V.Codigo := CDS.FieldByName('CODIGO').AsInteger;
    V.Numero := CDS.FieldByName('NUMERO').AsInteger;
    Result := V; 
  finally
    CDS.Free;
  end;
end;

procedure Setup_CarregarCacheInformacoes;
begin
  if not Assigned(CDSModulos) then
    CDSModulos := TClientDataSet.Create;
  
  if not Assigned(CDSAreas) then
    CDSAreas := TClientDataSet.Create;

  CDSModulos.Data := ExecuteReaderODBCServ(cDataBase, SQLModulos);
  CDSAreas.Data   := ExecuteReaderODBCServ(cDataBase, SQLAreas);
  FCacheCarregado := True;
end;

procedure TearDown_LimparCacheInformacoes;
begin
  CDSModulos.Free;
  CDSAreas.Free;
  FCacheCarregado := False;  
end;

procedure VerificaCarregamentoCache;
begin
  if not FCacheCarregado then
    Setup_CarregarCacheInformacoes;  
end;

function GetSQLConfigFaturamento:String;
var LS: TStringList;
begin
  LS := TStringList.Create; 
  try
    LS.Add('select');
    LS.Add('   PEDIDO_VENDA_FATCONFIG,');
    LS.Add('   ASSISTENCIA_FATCONFIG,');
    LS.Add('   CONSIGNACAO_FATCONFIG,');
    LS.Add('   PEDIDO_NFCE_FATCONFIG,');
    LS.Add('   PRODUTO_COMUM_FATCONFIG,');
    LS.Add('   PRODUTO_ST_FATCONFIG,');
    LS.Add('   PRODUTO_DIFERIMENTO_FATCONFIG,');
    LS.Add('   ITEM_ASSISTENCIA_FATCONFIG,');
    LS.Add('   QTD_FIXA_ITEM_FATCONFIG,');
    LS.Add('   QTD_MAX_ITEM_FATCONFIG,');
    LS.Add('   VALOR_ITEM_FIXO_FATCONFIG,');
    LS.Add('   VLR_MAX_ITEM_FATCONFIG,');
    LS.Add('   TRANSPORTADOR_FATCONFIG,');
    LS.Add('   MOTORISTA_FATCONFIG,');
    LS.Add('   TIPO_VEICULO_FATCONFIG,');
    LS.Add('   VEICULO_FATCONFIG,');
    LS.Add('   CLASSIFICACAO_NFCE_FATCONFIG,');
    LS.Add('   MODELO_NFCE_FATCONFIG,');
    LS.Add('   PESSOA_GERAL_FATCONFIG,');
    LS.Add('   PESSOA_SUFRAMA_FATCONFIG,');
    LS.Add('   PESSOA_CONSUMIDOR_FATCONFIG,');
    LS.Add('   PESSOA_CONS_NFCE_FATCONFIG');
    LS.Add('from FATURAMENTO_CONFIGURACAO'); 
    Result := LS.Text;
  finally
    LS.Free;
  end;
end;

function GetSQLConfigFinanceiro:String;
var LS: TStringList;
begin
  LS := TStringList.Create; 
  try
    LS.Add('select');
    LS.Add('   CLIENTE_FINCONFIG,');
    LS.Add('   FORNECEDOR_FINCONFIG,');
    LS.Add('   TIPO_FINCONFIG,');
    LS.Add('   SITUACAO_FINCONFIG,');
    LS.Add('   BANCO_FINCONFIG,');
    LS.Add('   FORMA_PAGTO_FINCONFIG,');
    LS.Add('   PROJETO_FINCONFIG,');
    LS.Add('   FINANCEIRA_FINCONFIG,');
    LS.Add('   INTERMEDIADOR_FINCONFIG,');
    LS.Add('   GR_CONTAS_RECEBER_FINCONFIG,');
    LS.Add('   GR_CONTAS_PAGAR_FINCONFIG,');
    LS.Add('   VALOR_PADRAO_RECEBER_FINCONFIG,');
    LS.Add('   VALOR_PADRAO_PAGAR_FINCONFIG,');
    LS.Add('   CONTA_PRINCIPAL_FINCONFIG');
    LS.Add('from FINANCEIRO_CONFIGURACAO'); 
    Result := LS.Text;
  finally
    LS.Free;
  end;
end;

function AreaPeloNome(pArea: String):Integer;
begin
  ValidarArea;  
  CDSAreas.IndexFieldNames := 'DESCRICAO_AREA';

  if not CDSAreas.FindKey([pArea]) then
    raise Exception.Create(MensagemPersonalizada + 'Área ' + pArea + ' não encontrada.');
   
  Result := CDSAreas.FieldByName('AUTOINC_AREA').AsInteger;
end;

function GetArea(pCodArea: Integer): Integer;
begin
  ValidarArea;
  CDSAreas.IndexFieldNames := 'AUTOINC_AREA';

  if not CDSAreas.FindKey([pCodArea]) then
    raise Exception.Create(MensagemPersonalizada + 'Área ' + IntToStr(pCodArea) + ' não encontrada.');
   
  Result := CDSAreas.FieldByName('AUTOINC_AREA').AsInteger; 
end;

procedure ValidarArea;
begin
  VerificaCarregamentoCache;  
  if not assigned(CDSAreas)then
    raise exception.create(MensagemPersonalizada + 'Cache Areas Não Carregadas.');

  if CDSAreas.IsEmpty then
    raise exception.create(MensagemPersonalizada + 'Areas Não Carregadas.');
end;

function ModuloPeloNome(pModulo: String): Integer;
begin
  ValidarModulo;
  CDSModulos.IndexFieldNames := 'DESCRICAO_MODULO'; 
  if not CDSModulos.FindKey([pModulo]) then
    raise Exception.Create(MensagemPersonalizada + 'Módulo ' + pModulo + ' não encontrado.');
    
  Result := CDSModulos.FieldByName('CODIGO_MODULO').AsInteger;
  
end;

function GetModulo(pCodModulo: Integer):Integer;
begin
  ValidarModulo;
  CDSModulos.IndexFieldNames := 'CODIGO_MODULO'; 
  if not CDSModulos.FindKey([pCodModulo]) then
    raise Exception.Create(MensagemPersonalizada + 'Módulo ' + IntToStr(pCodModulo) + ' não encontrado.');
    
  Result := CDSModulos.FieldByName('CODIGO_MODULO').AsInteger;
end;

procedure ValidarModulo;
begin
  VerificaCarregamentoCache;
  if not assigned(CDSModulos)then
    raise exception.create(MensagemPersonalizada + 'Cache Modulos Não Carregados.');

  if CDSModulos.IsEmpty then
    raise exception.create(MensagemPersonalizada + 'Modulos Não Carregados.');
end;

function SQLCasosTestes: String;
var LS: TStringList;
begin
  LS := TStringList.Create; 
  try
    LS.Add('SELECT');
    LS.Add('    AUTOINC_CT,');
    LS.Add('    DESCRICAO_CASO_TESTE_CT,');
    LS.Add('    CASO_TESTE_CT,');
    LS.Add('    CAMPOS_DISPONIVEIS_CT,');
    LS.Add('    RESULTADO_ESPERADO_CT');
    LS.Add('FROM CASO_TESTE');
    
    {
    LS.Add('where ATIVO_CT = ' + QuotedStr('S'));
    LS.Add('  and AREA_CT = ' + IntToStr(GetArea(cArea)));
    LS.Add('  and MODULO_CT = ' + IntToStr(GetModulo(cModulo)));
    }
    Result := LS.Text;   
  finally
    LS.Free;
  end;
end; 

function SQLModulos:String;
begin
  Result := 
    'select' + #13 +
    '  CODIGO_MODULO, DESCRICAO_MODULO' + #13 +
    'from MODULO'; 
end;

function SQLAreas:String;
begin
  Result := 
    'select' + #13 +
    '  AREA.AUTOINC_AREA, AREA.DESCRICAO_AREA, AREA.MODULO_AREA, MODULO.DESCRICAO_MODULO' + #13 +
    'from AREA' + #13 + 
    'left join MODULO on (MODULO.CODIGO_MODULO = AREA.MODULO_AREA)'; 
end;