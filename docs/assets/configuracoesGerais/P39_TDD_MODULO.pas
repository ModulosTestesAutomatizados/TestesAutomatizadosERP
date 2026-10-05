uses P39_TDD_CASOS_DE_TESTE;

const
  cFP = 'FPrincipal';

var
  FDescModulo: String;
  FP: TForm;
  FMenuName: String;
  
  FModuloDefinido: Boolean;
  
procedure SetModulo(pModulo: String);
begin
  FDescModulo := pModulo;
  {P39_TDD_CASOS_DE_TESTE}Setup_Inicializar_CasosTeste;
  P39_TDD_CASOS_DE_TESTE.SetModulo(pModulo);
  CarregarConfiguracoes;
  CarregarCasosTeste;
  
  FModuloDefinido := True;
end;
  
procedure AbrirTela(pEventoClickMenu:String);
begin
  if not FModuloDefinido then
    raise exception.Create(MensagemPersonalizada + 'Modulo NÃ£o informado!');
    
  FP := FormCriadoPeloNome(cFP);
  
  ExecutarMetodoDeObjeto(FP, pEventoClickMenu, [FP]);  
end;  
  
procedure FocarModulo;
begin
  ExecutarMetodoDeObjeto(FP, 'SetFocus');
  ExecutarMetodoDeObjeto(FP, 'Repaint');   
end; 

procedure TrazerParaFrente;
begin
  ExecutarMetodoDeObjeto(FP, 'BringToFront'); 
end;