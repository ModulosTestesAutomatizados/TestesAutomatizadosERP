{ ================================================================
  Herda via P39_TDD_CASOS_DE_TESTE:
  - P39_TDD_CONSTANTES (constantes, cache, SQL)
  - P39_TDD_ODBC (TDDCommandODBC, TDDReaderODBC, TDDScalarODBC)
  - P39_TDD_FUNCOES_JSON (GetValueJson, ValorCurrencyTag, etc.)
  - P39_TDD_CACHE (CDSModulos, CDSAreas, AreaPeloNome, ModuloPeloNome)
  - P39_TDD_PARAMETRO (Setup_Inicializar_Parametros, SetParametro, etc.)
  - Estados como FModulo, FDescModulo, FArea, FDescArea, etc.
  ================================================================ }

uses P39_TDD_CASOS_DE_TESTE;

const cFP = 'FPrincipal';

var FP: TForm;

procedure Main;
var lInstrucoes: String;
begin
  lInstrucoes := 'Unit responsável pela abertura de telas via menu e controle de foco/exibição do formulário principal.'    + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'FP :TForm'                                                                                                             + #13 +
    '  - Referência para a instância ativa do formulário principal da aplicação (FPrincipal).'                              + #13 +
    '===================================================================================================================='  + #13 +
    'Métodos disponibilizados pela Unit:'                                                                                   + #13 +
    'procedure AbrirTela(pEventoClickMenu:String)'                                                                          + #13 +
    '  - Valida se o módulo foi informado, localiza o FPrincipal e executa dinamicamente o evento de menu recebido.'        + #13 +
    'procedure FocarModulo'                                                                                                 + #13 +
    '  - Localiza o FPrincipal e aciona SetFocus e Repaint para garantir o foco e a atualização visual da tela.'            + #13 +
    'procedure TrazerParaFrente'                                                                                            + #13 +
    '  - Localiza o FPrincipal e executa o método BringToFront para colocar a janela do módulo em primeiro plano.'          + #13 +
    '===================================================================================================================='  + #13 +
    'Exige que FModulo e FDescModulo estejam previamente preenchidos; caso contrário, dispara exceção.'                     + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_RUN_MODULO', lInstrucoes);
end;
  
procedure AbrirTela(pEventoClickMenu:String);
begin
  if (FModulo <= 0) or (Trim(FDescModulo) = '') then
    raise Exception.Create('Módulo não informado para abrir a tela.');
    
  FP := FormCriadoPeloNome(cFP);

  if not Assigned(FP) then
    raise Exception.Create('Tela principal não encontrada.');
  
  ExecutarMetodoDeObjeto(FP, pEventoClickMenu, [FP]);  
end;  
  
procedure FocarModulo;
begin
  if (FModulo <= 0) or (Trim(FDescModulo) = '') then
    raise Exception.Create('Módulo não informado para focar a tela.');

  FP := FormCriadoPeloNome(cFP);

  if not Assigned(FP) then
    raise Exception.Create('Tela principal não encontrada.');

  ExecutarMetodoDeObjeto(FP, 'SetFocus', []);
  ExecutarMetodoDeObjeto(FP, 'Repaint', []);
end; 

procedure TrazerParaFrente;
begin
  if (FModulo <= 0) or (Trim(FDescModulo) = '') then
    raise Exception.Create('Módulo não informado para trazer a tela à frente.');

  FP := FormCriadoPeloNome(cFP);

  if not Assigned(FP) then
    raise Exception.Create('Tela principal não encontrada.');

  ExecutarMetodoDeObjeto(FP, 'BringToFront', []);
end;
