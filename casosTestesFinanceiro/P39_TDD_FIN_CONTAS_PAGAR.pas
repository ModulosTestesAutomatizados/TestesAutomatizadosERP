uses P39_TDD_FIN_CONFIG_FINANCEIRO; 

// ---------------------- Procedure Incluir Contas a Pagar -------------------------- //

procedure CriarContasAPagar;
begin
  CDSConfig := TClientDataSet.Create;

  try
    CDSConfig.Close;
    CDSConfig.Data := ExecuteReaderODBC(ConexaoODBC, GetSQLSelectFinanceiroConfig);  
    
    FDuplicatas := FormCriadoPeloNome('FCadPagar');
    
    if FDuplicatas = nil then
      FDuplicatas := CriarFormPeloNome('FCadPagar');
  
    FDuplicatas.Show(); 
    
    FDuplicatas  := FormCriadoPeloNome('FCadPagar');
    DMDuplicatas := DMCriadoPeloNome('DMCadDuplicata');

    CDSCadastro   := DMDuplicatas.FindComponent('CDSCadastro');
    CDSGrupResult := DMDuplicatas.FindComponent('CDSDuplicata_GrupoResultado');

    cePessoa := FDuplicatas.FindComponent('EditPessoa');

    cePessoa.Value := CDSConfig.FieldByName('FORNECEDOR_FINCONFIG').AsInteger;
    
    ExecutarMetodoDeObjeto(FDuplicatas, 'BotaoAbrirClick', [nil]); 

    ExecutarMetodoDeObjeto(FDuplicatas, 'BotaoIncluirClick', [nil]);

    CDSCadastro.FieldByName('PESSOA_DUP').AsInteger                := CDSConfig.FieldByName('FORNECEDOR_FINCONFIG').AsInteger;
  
    CDSCadastro.FieldByName('DOCUMENTO_DUP').AsString              := 'DUP_' + FormatDateTime('hh_mm_ss_dd_mm_yy', DataHoraServidor);
    CDSCadastro.FieldByName('EMISSAO_DUP').AsDateTime              := DataHoraServidor;
    CDSCadastro.FieldByName('VENCIMENTO_DUP').AsDateTime           := DataHoraServidor;
    CDSCadastro.FieldByName('VALORNOMINALORIGINAL_DUP').AsCurrency := CDSConfig.FieldByName('VALOR_PADRAO_PAGAR_FINCONFIG').AsCurrency;
    CDSCadastro.FieldByName('VALOR_DUP').AsCurrency                := CDSConfig.FieldByName('VALOR_PADRAO_PAGAR_FINCONFIG').AsCurrency;
    CDSCadastro.FieldByName('TIPODOC_DUP').AsInteger               := CDSConfig.FieldByName('TIPO_FINCONFIG').AsInteger;
    CDSCadastro.FieldByName('QUALIFICACAO_DUP').AsInteger          := StrToInt(GetValueJson(SecaoParametroJson, 'QualificacaoExtra'));

    CDSGrupResult.Insert; 
    CDSGrupResult.FieldByName('GRUPORESULTADO_DUPGR').AsInteger := CDSConfig.FieldByName('GR_CONTAS_PAGAR_FINCONFIG').AsInteger;
    CDSGrupResult.FieldByName('VALOR_DUPGR').AsCurrency         := CDSConfig.FieldByName('VALOR_PADRAO_PAGAR_FINCONFIG').AsCurrency;
    CDSGrupResult.Post;

    ExecutarMetodoDeObjeto(FDuplicatas, 'BotaoGravarClick', [nil]);
    
  finally
   // FDuplicatas.Free;
  //  FDuplicatas := nil;
    CDSConfig.Free;    
  end;
  
end;
