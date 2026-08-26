unit ProcessamentoEspecifico;
 
uses P39_TDD_FIN_CONTAS_RECEBER, P39_TDD_FIN_CONTAS_PAGAR, P39_TDD_FIN_INCLUIR_BORDERO_PAGAMENTO, P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO;
 
procedure Main;
begin
  if not ConfirmarFiltros then
    exit;
  case Filtro('Tipo de Teste') of
    0: P39_TDD_FIN_CONTAS_RECEBER.CriarContasaReceber;
    1: P39_TDD_FIN_CONTAS_PAGAR.CriarContasAPagar;
    2: P39_TDD_FIN_INCLUIR_BORDERO_PAGAMENTO.IncluirBorderoPagamento;
    3: P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO.IncluirBorderoRecebimento;
  end;
end;
 
function ConfirmarFiltros: Boolean;
var CDSFiltros: TClientDataSet;
begin
  CDSFiltros := TClientDataSet.Create;
  try
    CDSFiltros.Data := EstruturaDeFiltrosDinamicos;
 
    {01} IncluirFiltroDinamico(CDSFiltros, 'Tipo de Teste', cTipoFiltro_Opcao, '0', '', '', 'Incluir Duplicata A Receber'#13'Incluir Duplicata A Pagar'#13'Incluir Borderô de Pagamento'#13'Incluir Borderô Recebimento');
 
    CDSFiltros.Data := ExecutarFiltroDinamico(CDSFiltros.Data);
 
    Result := (not CDSFiltros.IsEmpty);
  finally
    CDSFiltros.Free;
  end;
end;
 
end.