uses P39_TDD_FAT_DOCUMENTO_FATURA;

const
  cArea = 'PEDIDO DE VENDA';

procedure main;
begin
  Setup;
  Teste;  
end;

Procedure Setup;
begin
  //CallBack_AbreTela(ClassOwner);
  try
  //  CallBack_Mensagem(ClassOwner, '[SETUP] Inicializando....');
    FCadastro := 'FCadPedidoVenda';
    FDM       := 'DMCadPedidoVenda';
    SetArea(cArea);
    Setup_Inicializar;
  Finally
  //  CallBack_FechaTela(ClassOwner);  
  end;  
end;

procedure Teste;
begin
//  CallBack_AbreTela(ClassOwner);
  try
 //   CallBack_Mensagem(ClassOwner, 'Executando Teste.....');
    Teste_Executar;       
  finally
 //   CallBack_FechaTela(ClassOwner);
  end;
end;