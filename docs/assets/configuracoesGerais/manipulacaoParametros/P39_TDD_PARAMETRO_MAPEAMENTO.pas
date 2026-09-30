type
  TMapeamentoParametro = record
    CampoJSON: String;
    CampoDB: String;
    Tabela: String;
  end;

const
  cTipoCampoJSON = 0;
  cTipoCampoDB = 1;
  cTipoTabela = 2;
  cTabelaConfigSistema = 'CONFIG_SISTEMA';
  cTabelaConfigSistemaEmpresa = 'CONFIG_SISTEMA_EMPRESA';
  ctabelaConfigPCP = 'PCP_CONFIG';

var
 FParametroMapeado: boolean;
 FMapeamentoParam: array [0..8] of TMapeamentoParametro; 

procedure Main;
begin
  MapearParametros;
  ShowMessage(GetCampoDBParametro('OrdemImpressaoItemNF'));
  
end;

function GetTabela(pCampo: String): String;
begin
  Result := GetCampo(cTipoTabela, pCampo);    
end;

function GetCampoJsonParametro(pCampoDB: String): String;
begin
  Result := GetCampo(cTipoCampoJSON, pCampoDB);    
end;

function GetCampoDBParametro(pCampoJson: String):String;
begin
  Result := GetCampo(cTipoCampoDB, pCampoJson);
end;

function GetCampo(pTipo: Integer; pCampo: String): String;
var I: Integer;
begin
  Result := '';

  if pCampo = '' then
    Exit;

  for I := Low(FMapeamentoParam) to High(FMapeamentoParam) do
  begin              
    if (pTipo = cTipoCampoJSON) and (pCampo = FMapeamentoParam[I].CampoDB) then
    begin 
      Result := FMapeamentoParam[I].CampoJSON;
      Break;
    end;

    if (pTipo = cTipoCampoDB) and (pCampo = FMapeamentoParam[I].CampoJSON) then
    begin 
      Result := FMapeamentoParam[I].CampoDB;
      Break;
    end;

    if (pTipo = cTipoTabela) and 
       ((pCampo = FMapeamentoParam[I].CampoDB) or
        (pCampo = FMapeamentoParam[I].CampoJSON)) then
    begin 
      Result := FMapeamentoParam[I].Tabela;
      Break;
    end;
  end;
end;

procedure MapearParametros;
begin
  // Incluir Mapeamentos necessários aqui.
  if not FParametroMapeado then
  begin
    AddParamMapped(0, 'Fat_PorUnidadeFabril', 'FAT_PORUNIDADEFABRIL_CFS', cTabelaConfigSistema);
    AddParamMapped(1, 'OrdemImpressaoItemNF', 'FAT_ORDEMIMPRESSAONF_CFSEMP', cTabelaConfigSistemaEmpresa);
    AddParamMapped(2, 'ConsideraDiasParaEntregaDupFrete', 'CONS_DIASENT_DUP_FRETE_CFSEMP', cTabelaConfigSistemaEmpresa);
    AddParamMapped(3, 'NecessarioAutorizarPagamentos', 'NECESSARIOAUTORIZARPAGTO_CFS', cTabelaConfigSistema);
    AddParamMapped(4, 'NecessarioAutorizarAdiantamentos', 'NECESSARIOAUTORIZARDIANT_CFS', cTabelaConfigSistema);
    AddParamMapped(5, 'ObrigatorioGrupoResultadoDiferenteDeZeroNaDuplicata', 'GR_OBRIGATORIO_DUPL_CFS', cTabelaConfigSistema);
    AddParamMapped(6, 'OcultarDuplicataPagarSalario', 'OCULTARDUPLSALARIO_CFS', cTabelaConfigSistema);
    AddParamMapped(7, 'BloquearLancamentoBorderoQualificacao0Todas', 'BLOQLANCQUALIFTODAS_CFS', cTabelaConfigSistema);
    AddParamMapped(8, 'BorderoExigirPreenchimentoRegraIntegracaoContabil', 'EXIGIRREGRAINTEGRACAOCTB_CFS', cTabelaConfigSistema);
    
    FParametroMapeado := True;  
  end;
end;

procedure AddParamMapped(pIdx: Integer; const pChaveJson, pCampoDB, pTabela: string);
begin
  FMapeamentoParam[pIdx].CampoJSON := pChaveJson;
  FMapeamentoParam[pIdx].CampoDB   := pCampoDB;
  FMapeamentoParam[pIdx].Tabela    := pTabela;
end;

end.