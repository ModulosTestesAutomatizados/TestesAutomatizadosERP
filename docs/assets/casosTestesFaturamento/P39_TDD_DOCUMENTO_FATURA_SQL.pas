const
  cTipoSQLPessoaID = 0;
  cTipoSQLPessoaNome = 1;

  cTipoPessoaCliente = 0;
  cTipoPessoaFornecedor = 1;
  cTipoPessoaTransportador = 2;
  cTipoPessoaFinanceira = 3;
  cTipoPessoaIntermediadorVenda = 4;

function _BuscaDadosClientes(iTag: integer): OleVariant;
var
  sSQL: string;
begin
  sSQL := 'select ' #13 +
	'    PESSOA.CODIGO_PESSOA, C.DESCRICAO_CARACT ' #13 +
	'from CARACTERISTICAS C ' #13 +
	'inner join PESSOA_CARACTERISTICAS PC on PC.CARACTERISTICA_PESSOACARAC = C.CODIGO_CARACT ' #13 +
	'left join PESSOA on PESSOA.CODIGO_PESSOA = PC.PESSOA_PESSOACARAC ' #13;
  if iTag > 0 then
   sSQL := sSQL + 'where C.CODIGO_CARACT = ' + IntToStr(iTag);
//  else
//   sSQL := sSQL + 'where C.CODIGO_CARACT in (' + IntToStr(TagPessoaGeral) + ', ' + IntToStr(TagPessoaSuframa) + ', ' + IntToStr(TagPessoaConsumidor) + ')';

  sSQL := sSQL + 'and PC.VALOR_PESSOACARAC = ' + QuotedStr('S');

  Result := ExecuteReader(sSQL);
end;

function _BuscaCliente(iCli: Integer):OleVariant;
var 
  sSQL: String;
begin
  sSQL := 'select CODIGO_PESSOA from PESSOA where CODIGO_PESSOA = ' + IntToStr(iCli);

  Result := ExecuteReader(sSQL);
  if Result = null then
    raise Exception.Create(MensagemPersonalizada + 'Pessoa não encontrada!');
end;

function BuscaDadosProdutos(iTag: integer): OleVariant;
var
  sSQL: string;
begin  
  sSQL := 'select first 5 ' + #13 +
	'	ITEM.CODIGO_ITEM, ' + #13 +
	'	ITEM.DIFERENCIAVARIACAO_ITEM, '+ #13 +
	'	ITEM.DIFERENCIACOR_ITEM, ' + #13 +
	'	ITEM.DIFERENCIAACABAMENTO_ITEM, '+ #13 +
	'	ITEM_DETALHE.VARIACAO_ITEM_DETALHE, '+ #13 + #13 +
	'	ITEM_DETALHE.COR_ITEM_DETALHE, '+ #13 +
	'	ITEM_DETALHE.ACABAMENTO_ITEM_DETALHE, ' + #13 +
  ' cast (0.0 as ESTOQUE) QUANTIDADE,' + #13 + 
  ' cast (0.0 as VALOR04) VALOR,'+ #13 + 
  ' cast (0.0 as ALIQUOTA) DESCONTO'+ #13 + 
	'from ITEM_TAGS ' + #13 +
	'left join ITEM on ITEM.CODIGO_ITEM = ITEM_TAGS.ITEM_ITEMTAG ' + #13 +
	'left join ITEM_DETALHE on ITEM_DETALHE.ITEM_ITEM_DETALHE = ITEM.CODIGO_ITEM ' + #13 +
  'left join VARIACAO on VARIACAO.CODIGO_VARIACAO = ITEM_DETALHE.VARIACAO_ITEM_DETALHE' + #13 +
  'left join COR on COR.CODIGO_COR = ITEM_DETALHE.COR_ITEM_DETALHE' + #13 +
  'left join ACABAMENTO on ACABAMENTO.CODIGO_ACABAMENTO = ITEM_DETALHE.ACABAMENTO_ITEM_DETALHE' + #13;
  
  if iTag > 0 then
    sSQL := sSQL + 'where ITEM_TAGS.TAG_ITEMTAG = ' + IntToStr(iTag)
  else
	  sSQL := sSQL + 'where ITEM_TAGS.TAG_ITEMTAG in (' + IntToStr(TagProdComum) + ', ' + IntToStr(TagProdST) + ', ' + IntToStr(TagProdDiferimento) + ')';
	
  sSQL := sSQL + 
  '   and ITEM_TAGS.VALOR_ITEMTAG = ' + QuotedStr('S') + #13 +
  '	  and ITEM_DETALHE.STATUS_ITEM_DETALHE = 0 '+ #13 +
  '   and VARIACAO.STATUS_VARIACAO = 0' + #13 +
  '   and COR.STATUS_COR = 0' + #13 +
  '   and ACABAMENTO.STATUS_ACABAMENTO = 0';
  Result := ExecuteReader(sSQL);
end;

function SQLPessoa(pTipo: Integer): String;
begin
  Result := 'select CODIGO_PESSOA from PESSOA'; 

  case pTipo of
    cTipoSQLPessoaID: Result := Result + #13 + 'where CODIGO_PESSOA = :CODPESSOA';
    cTipoSQLPessoaNome: Result := Result + #13 + 'where RAZAOSOCIAL_PESSOA = :NOMEPESSOA'
  else
    raise exception.create(MensagemPersonalizada + 'parametro inválido na SQLPESSOA na Unit "TDD_DOCUMENTO_FATURA_SQL.SQLPESSOA"' + #13 + 'Parâmetro Passado: ' + IntToStr(pTipo);  
  end;
end;

function GetPessoaPeloCod(pPessoa: Integer): Integer;
begin
  Result := ExecuteScalarP(SQLPessoa(cTipoSQLPessoaID), VarArrayOf([pPessoa]));
end;

function GetPessoaPeloNome(pNomePessoa: String): Integer;
begin
  Result := ExecuteScalarP(SQLPessoa(cTipoSQLPessoaNome), VarArrayOf([pNomePessoa]));
end;

function ItemPertenceAUnidadeFabril(pItem, pUnidade: Integer):Boolean;
var 
  S: String;
  iUnid: Integer;
begin
  Result := False;
  if (pItem <= 0) then
    Result := False;

  Result := (pUnidade = 0);
  if Result then
    Exit;

  S := 'select UNIDADEPRODUCAO_ITEM from ITEM where CODIGO_ITEM = ' + IntToStr(pItem);
  iUnid := ExecuteScalar(S);

  Result := ((iUnid = pUnidade) or (iUnid = 0));
end;