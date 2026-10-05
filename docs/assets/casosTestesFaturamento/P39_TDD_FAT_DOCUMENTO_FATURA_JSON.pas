uses P39_TDD_FUNCOES_JSON;

type
TEstrutura = record
  Doc: String;
  Item: String;
  Itens: String;   
end;

var 
  FJSON: TEstrutura;
  FJSONCarregado: Boolean;

procedure SetJSON_Caso_Teste(pJSONDoc, pJSONItem, pItens: String);
begin
  if FJSONCarregado then
    Exit;
    
  FJSON.Doc := pJSONDoc;
  FJSON.Item := pJSONItem;    
  FJSON.Itens := pItens;
  FJSONCarregado := True;
  ValidarCasoTeste;
end;

procedure LimparRegistrosCasoTeste;
begin
    FJSON.Doc := '';
    FJSON.Item := '';    
    FJSON.Itens := '';
    FJSONCarregado := false;    
end;

procedure VerificaArquivoCarregado;
begin
    if not FJSONCarregado then
        raise Exception.Create(MensagemPersonalizada + 'Carregue o JSON chamando o Metodo"SetJSON_Caso_Teste(pJSONDoc, pJSONItem, pItens: String);"' + #13 + 
                               'de caso de teste para Continuar.');   
end;

{$Region 'DOCUMENTO'}

function ValorLogicoTagDoc(pTagName: String): Boolean;
begin
  Result := ValorLogicoTag(FJSON.Doc, pTagName, False); 
end;

function ValorInteiroTagDoc(pTagName: String): Integer;
begin
  Result := ValorInteiroTag(FJSON.Doc, pTagName, 0);   
end;

function ValorDataTagDoc(pTagName: String): TDateTime;
begin
  Result := ValorDataTag(FJSON.Doc, pTagName);   
end;

function ValorCurrencyTagDoc(pTagName: String):Currency;
begin
  Result := ValorCurrencyTag(FJSON.Doc, pTagName, 0);         
end;

function TagDocumentoExiste(pTagName: string): Boolean;
begin
  Result := TagExiste(FJSON.Doc, pTagName);
end;

function ValorStringTagDoc(pTagName: String): String;
begin
  Result := ValorStringTag(FJSON.Doc, pTagName);
end;

{$endRegion}

{$Region 'ItemConfig'}

function TagItemConfigExiste(pTagName: string): Boolean;
begin
  Result := TagExiste(FJSON.Item, pTagName);
end;

function ValorLogicoTagItemConfig(pTagName: String): Boolean;
begin
  Result := ValorLogicoTag(FJSON.Item, pTagName, False); 
end;

function ValorInteiroTagItemConfig(pTagName: String): Integer;
begin
  Result := ValorInteiroTag(FJSON.Item, pTagName, 0);   
end;

function ValorDataTagItemConfig(pTagName: String): TDateTime;
begin
  Result := ValorDataTag(FJSON.Item, pTagName);   
end;

function ValorCurrencyTagItemConfig(pTagName: String):Currency;
begin
  Result := ValorCurrencyTag(FJSON.Item, pTagName, 0);         
end;

function ValorStringTagItemConfig(pTagName: String): String;
begin
  Result := ValorStringTag(FJSON.Item, pTagName);
end;

{$endRegion}


function GetArrayItens:String;
begin
  Result := FJSON.Itens;
end;

procedure ValidarCasoTeste;
begin
  if Trim(FJSON.Doc) = '' then
    raise Exception.Create(MensagemPersonalizada + 'JSON do documento Vazio!'); 
  
  if Trim(FJSON.Item) = '' then
    raise Exception.Create(MensagemPersonalizada + 'JSON de configuraÃ§Ã£o do ITEM Vazio!');
end;