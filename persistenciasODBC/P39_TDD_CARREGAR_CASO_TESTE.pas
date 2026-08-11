uses P39_TDD_REGISTRAR_CASO_TESTE;

type
  TCasoTeste = record
    Modulo            :integer;
    Area              :integer;
    Descricao         :string;
    CasoTeste         :string;
    CamposDisponiveis :string;
    ResultadoEsperado :string;
  end;

var gCasoTeste :TCasoTeste;

procedure Main;
var lInstrucao :string;
begin
  P39_TDD_REGISTRAR_CASO_TESTE.Main; // Documentação!
  
  lInstrucao := 'Assinatura do método de carregar teste:'                                                                           + #13 +
    ' - procedure CarregarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string; pCDSCasoTeste :TClientDataSet);' + #13 +
    '   + O caso de teste carregado é um conjunto de dados da tabela CASO_TESTE para ser utilizado nas units!'                      + #13 +
    'É necessário criar um CDS e usar o parâmetro de passagem por referência';

  MostrarLogTexto(lInstrucao, 'Instruções P39_TDD_CARREGAR_CASO_TESTE');
end;

procedure CarregarCasoTeste(
  pDescricaoModulo,
  pDescricaoArea,
  pDescricaoCasoTeste :string;
  pCDSCasoTeste       :TClientDataSet;  
);
var
  lCodigoModulo,
  lCodigoArea         :integer; 
  lSqlCasoTeste       :string;
begin
  try
    lCodigoModulo        := RegistroFallbackModulo(pDescricaoModulo, false);
    lCodigoArea          := RegistroFallbackArea(lCodigoModulo, pDescricaoArea, false);

    gCasoTeste.Modulo    := lCodigoModulo;
    gCasoTeste.Area      := lCodigoArea;
    gCasoTeste.Descricao := pDescricaoCasoTeste;

    lSqlCasoTeste        := 'select CT.AUTOINC_CT,'      + #13 +
    '       CT.MODULO_CT,'                               + #13 +
    '       CT.AREA_CT,'                                 + #13 +
    '       CT.DESCRICAO_CASO_TESTE_CT,'                 + #13 +    
    '       CT.JSON_CASO_TESTE,'                         + #13 +
    '       CT.CAMPOS_DISPONIVEIS_CT,'                   + #13 +
    '       CT.RESULTADO_ESPERADO_CT'                    + #13 +
    'from CASO_TESTE CT'                                 + #13 +
    'where CT.DESCRICAO_CASO_TESTE_CT = :pDescricao and' + #13 +
    '      CT.MODULO_CT               = :pModulo    and' + #13 +
    '      CT.AREA_CT                 = :pArea      and' + #13 +
    '      CT.ATIVO_CT = ' + QuotedStr('S') + ';';  

    pCDSCasoTeste.Close;
    pCDSCasoTeste.Data   := TDDReaderODBC(lSqlCasoTeste, [
      gCasoTeste.Descricao,
      gCasoTeste.Modulo,
      gCasoTeste.Area    
    ]);
    pCDSCasoTeste.LogChanges := False;

    if pCDSCasoTeste.IsEmpty then
      raise Exception.Create(MensagemPersonalizada + 'Caso de teste não encontrado ou inativo.');  
  except on ex: Exception do
    raise Exception.Create(MensagemPersonalizada + 'Erro ao carregar o caso de teste! ' + ex.Message);
  end;
end;
