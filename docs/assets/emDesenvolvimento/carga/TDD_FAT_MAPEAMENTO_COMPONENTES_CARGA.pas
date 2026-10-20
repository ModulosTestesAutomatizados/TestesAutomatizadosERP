var
  FCadCarga                    :TForm;
  DMCadCarga                   :TDataModule;
  CDSCadastroCarga             :TClientDataSet;
  CDSDocumentosCarga           :TClientDataSet;
  BotaoIncluirCarga            :TComponent;
  BotaoGravarCarga             :TComponent;
  EdtDescCarga                 :TComponent;
  EdtDataEmissaoCarga          :TComponent;
  GradeDocumentosCarga         :TComponent;
  BtnAdicionarDocumentoCarga   :TComponent;
  PageControlPrincipalCarga    :TPageControl;
  PageControlDocumentosCarga   :TPageControl;
  PageControlRecolhimentoCarga :TPageControl;
  PageControlTransporteCarga   :TPageControl;
  PageControlConferenciaCarga  :TPageControl;

procedure Main;
var lInstrucoes :String;
begin
  lInstrucoes := 'Unit responsavel por mapear o cadastro de Carga e seus componentes usados no teste.'                      + #13 +
    '===================================================================================================================='  + #13 +
    'Estado compartilhado:'                                                                                                 + #13 +
    'FCadCarga: TForm; DMCadCarga: TDataModule'                                                                             + #13 +
    '  - Referencias ao formulario e ao DataModule do cadastro de Carga.'                                                   + #13 +
    'CDSCadastroCarga, CDSDocumentosCarga: TClientDataSet'                                                                  + #13 +
    '  - Datasets do cabecalho e dos documentos vinculados.'                                                                + #13 +
    'BotaoIncluirCarga, BotaoGravarCarga e controles de edicao: TComponent'                                                 + #13 +
    '  - Componentes usados na inclusao e gravacao.'                                                                        + #13 +
    'PageControlPrincipalCarga e demais controles de abas: TPageControl'                                                    + #13 +
    '  - Cinco controles que organizam as abas do formulario.'                                                              + #13 +
    '===================================================================================================================='  + #13 +
    'Metodos disponibilizados pela Unit:'                                                                                   + #13 +
    'function ExigirComponenteCarga(pDono: TComponent; pNome: String): TComponent'                                          + #13 +
    '  - Localiza um componente obrigatorio e falha se estiver ausente.'                                                    + #13 +
    'procedure RegistrarAbaCarga(pNome: String)'                                                                            + #13 +
    '  - Confirma a existencia de uma aba do formulario.'                                                                   + #13 +
    'function AbaCarga(pNome: String): TTabSheet'                                                                           + #13 +
    '  - Localiza uma aba pelo nome no formulario aberto.'                                                                  + #13 +
    'procedure MapearCarga'                                                                                                 + #13 +
    '  - Localiza formulario, DataModule, datasets, acoes, cinco controles e 28 abas.'                                      + #13 +
    '===================================================================================================================='  + #13 +
    'As abas e os componentes pertencem ao formulario do ERP.'                                                              + #13 +
    '====================================================================================================================';
  {P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('TDD_FAT_MAPEAMENTO_COMPONENTES_CARGA', lInstrucoes);
end;

function ExigirComponenteCarga(pDono: TComponent; pNome: String): TComponent;
begin
  if not Assigned(pDono) then
    raise Exception.Create('Carga: dono ausente para ' + pNome);
  Result := pDono.FindComponent(pNome);

  if not Assigned(Result) then
    raise Exception.Create('Carga: componente ausente: ' + pNome);
end;

function AbaCarga(pNome: String): TTabSheet;
begin
  Result := TTabSheet(ExigirComponenteCarga(FCadCarga, pNome));
end;

procedure RegistrarAbaCarga(pNome: String);
var lAba: TTabSheet;
begin
  lAba := AbaCarga(pNome);
end;

procedure MapearCarga;
begin
  FCadCarga   := FormCriadoPeloNome('FCadCarga');
  if not Assigned(FCadCarga) then
    raise Exception.Create('Carga: FCadCarga nao foi aberta.');

  DMCadCarga := FCadCarga.FindComponent('DMCadCarga');
  if not Assigned(DMCadCarga) then
    DMCadCarga := DMCriadoPeloNome('DMCadCarga');

  if not Assigned(DMCadCarga) then
    raise Exception.Create('Carga: DMCadCarga ausente.');

  CDSCadastroCarga             := ExigirComponenteCarga(DMCadCarga, 'CDSCadastro');
  CDSDocumentosCarga           := ExigirComponenteCarga(DMCadCarga, 'CDSDocumentos');
  BotaoIncluirCarga            := ExigirComponenteCarga(FCadCarga, 'BotaoIncluir');
  BotaoGravarCarga             := ExigirComponenteCarga(FCadCarga, 'BotaoGravar');
  EdtDescCarga                 := ExigirComponenteCarga(FCadCarga, 'EdtDescCarga');
  EdtDataEmissaoCarga          := ExigirComponenteCarga(FCadCarga, 'edtDataEmissao');
  GradeDocumentosCarga         := ExigirComponenteCarga(FCadCarga, 'GradeDocumentos');
  BtnAdicionarDocumentoCarga   := ExigirComponenteCarga(FCadCarga, 'btnFiltro');

  PageControlPrincipalCarga    := ExigirComponenteCarga(FCadCarga, 'PageControl1');
  PageControlDocumentosCarga   := ExigirComponenteCarga(FCadCarga, 'PageControl2');
  PageControlRecolhimentoCarga := ExigirComponenteCarga(FCadCarga, 'PgcRecolhimento');
  PageControlTransporteCarga   := ExigirComponenteCarga(FCadCarga, 'PageControl3');
  PageControlConferenciaCarga  := ExigirComponenteCarga(FCadCarga, 'PageControl4');

  RegistrarAbaCarga('TabSheet1');
  RegistrarAbaCarga('TSDocumentos');
  RegistrarAbaCarga('tbsOutrosFretes');
  RegistrarAbaCarga('tbsOrdemRecolhimento');
  RegistrarAbaCarga('TabSheet6');
  RegistrarAbaCarga('TSConferencia');
  RegistrarAbaCarga('tbsRCPE');
  RegistrarAbaCarga('tsResumo');
  RegistrarAbaCarga('TSProdutos');
  RegistrarAbaCarga('TSOutros');
  RegistrarAbaCarga('TabSheet2');
  RegistrarAbaCarga('TabSheet3');
  RegistrarAbaCarga('tbsObsNF');
  RegistrarAbaCarga('tbsVendaOrdem');
  RegistrarAbaCarga('TSInfRastreio');
  RegistrarAbaCarga('TbsRecolhimento');
  RegistrarAbaCarga('TbsCliente');
  RegistrarAbaCarga('TbsRegiao');
  RegistrarAbaCarga('TbsCidade');
  RegistrarAbaCarga('TbsUF');
  RegistrarAbaCarga('TbsAssistencia');
  RegistrarAbaCarga('TbsEmpresa');
  RegistrarAbaCarga('TbsStatusAssistencia');
  RegistrarAbaCarga('TabSheet4');
  RegistrarAbaCarga('TSRastreio');
  RegistrarAbaCarga('TSDadosConf');
  RegistrarAbaCarga('TSDadosSumario');
  RegistrarAbaCarga('TabSheet7');
end;
