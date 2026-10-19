// Helper manual para coletar candidatos ao DE -> PARA de telas do módulo atual.
// Catálogo: docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_APPLICATION_MAPEAMENTO_JSON.json.
// Unit remota do catálogo: P39_TDD_RUN_APPLICATION_MAPEAMENTO_JSON.
// Documentação: Helpers -> Gerais -> TDD_MAPEAMENTO_EVENTOS no portal.
// Execute somente no ambiente de testes: o evento selecionado realmente é chamado.
// Revise os candidatos antes de atualizar o catálogo; a coleta não publica nem grava dados.

const
  cFP             = 'FPrincipal';
  cEvento         = 'Receber1Click';
  // Confira o nome real do componente de menu no ambiente antes de executar.
  cComponenteMenu = 'Receber1';

var
  FP                         :TForm;
  RE                         :TRichEdit;
  FFormsAbertos, FFormsAntes  :TStringList;
  FCaptionMenu               :string;
  CDS                        :TClientDataSet;

procedure Main;
var
  lIndice                  :integer;
  lNome, lTextoAnterior     :string;
  lMenu                    :TComponent;
begin
  FP := FormCriadoPeloNome(cFP);
  if not Assigned(FP) then
    raise Exception.Create('Tela principal não encontrada.');
  lMenu := FP.FindComponent(cComponenteMenu);
  if not Assigned(lMenu) then
    raise Exception.Create('Componente de menu não encontrado: ' + cComponenteMenu);
  FCaptionMenu := ValorPropriedadeDeObjeto(lMenu, 'Caption');
  if Trim(FCaptionMenu) = '' then
    raise Exception.Create('Caption do menu não informado.');
  RE := FP.FindComponent('RichEdit1');
  if not Assigned(RE) then
    raise Exception.Create('RichEdit1 não encontrado para listar os formulários.');

  lTextoAnterior := RE.Lines.Text;
  CDS := TClientDataSet.Create;
  FFormsAbertos := TStringList.Create;
  FFormsAntes := TStringList.Create;
  try
    CDS.FieldDefs.Clear;
    CDS.FieldDefs.Add('EVENTO', ftString, 120, false);
    CDS.FieldDefs.Add('FORM', ftString, 120, false);
    CDS.FieldDefs.Add('CAPTION', ftString, 250, false);
    CDS.CreateDataSet;
    CDS.LogChanges := false;

    ListarFormsAbertos;
    for lIndice := 0 to FFormsAbertos.Count - 1 do
    begin
      lNome := Trim(CorteEntre(FFormsAbertos[lIndice], '-', '('));
      if lNome <> '' then
        FFormsAntes.Add(lNome);
    end;

    // A seleção é explícita: não percorrer e executar MetodosDeObjeto(FP).
    ExecutarMetodoDeObjeto(FP, cEvento, [FP]);
    ListarFormsAbertos;
    PegarConfiguracoesForm(cEvento);
    if CDS.IsEmpty then
      MostrarLogTexto('Nenhum Form novo identificado. A tela pode já estar aberta ou o formato da listagem mudou.');
    MostrarCDS(CDS);
  finally
    RE.Lines.Text := lTextoAnterior;
    FFormsAntes.Free;
    FFormsAntes := nil;
    FFormsAbertos.Free;
    FFormsAbertos := nil;
    CDS.Free;
    CDS := nil;
  end;
end;

procedure PegarConfiguracoesForm(pMetodo :string);
var
  lIndice :integer;
  lNome   :string;
  lForm   :TForm;
begin
  for lIndice := 0 to FFormsAbertos.Count - 1 do
  begin
    lNome := Trim(CorteEntre(FFormsAbertos[lIndice], '-', '('));
    if (lNome = '') or (FFormsAntes.IndexOf(lNome) >= 0) or
       (lNome = cFP) or (lNome = 'TParentForm') or
       (lNome = 'FMenuEdit_PopUp') or (lNome = 'FCadTI_Processamentos') or
       (UpperCase(Copy(lNome, 1, 2)) = 'DM') then
      Continue;
    lForm := FormCriadoPeloNome(lNome);
    if not Assigned(lForm) then
      Continue;
    try
      // CAPTION vem do menu selecionado, não do título do formulário.
      CDS.InsertRecord([pMetodo, lNome, FCaptionMenu]);
    finally
      // Fechar somente Forms novos. Nunca liberar Forms/DMs compartilhados com Free.
      lForm.Close;
    end;
  end;
end;

procedure ListarFormsAbertos;
begin
  RE.Lines.Clear;
  ExecutarMetodoDeObjeto(FP, 'ListarFormulriosAbertos1Click', [FP]);
  FFormsAbertos.Text := RE.Lines.Text;
end;
