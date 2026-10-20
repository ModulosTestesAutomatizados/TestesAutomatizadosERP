# Inventário estático da tela de Carga

**Origem:** executável FaturamentoMC.exe do ambiente de testes, modificado em 2026-10-13 03:12:12, 17.967.104 bytes, SHA-256 `AAEF4CAEB241D6AA3059D9A39CE1674F3C6F5FB455223CC4F31F968C10C6EBFE`.

O executável está compactado com UPX. A análise usou uma cópia temporária, validada por `upx -t` e descompactada por UPX 5.2.1. O original não foi executado nem modificado. Os recursos `RT_RCDATA/TFCADCARGA` e `RT_RCDATA/TDMCADCARGA` começam por `TPF0`; o parser local consumiu integralmente os 46.440 e 4.907 bytes de cada recurso. Scripts de reprodução: `evidencias/recursos_pe.py` e `evidencias/ler_dfm.py`. O recurso do menu `TFPRINCIPAL` contém a sequência estática `CadastrodeCarga1` / `Cadastro de Carga` / `CadastrodeCarga1Click`.

## Formulário e módulo de dados

| Papel | Nome observado | Evidência |
| --- | --- | --- |
| Form | `FCadCarga` (`TFCadCarga`) | Recurso `TFCADCARGA` |
| DataModule | `DMCadCarga` (`TDMCadCarga`) | Recurso `TDMCADCARGA` |
| Evento de menu candidato | `CadastrodeCarga1Click` | Recurso `TFPRINCIPAL`; validar abertura no ERP |
| CDS principal | `CDSCadastro` | Recurso `TDMCADCARGA` |
| CDS dos documentos | `CDSDocumentos` | Recurso `TDMCADCARGA` |
| CDS dos itens | `CDSItens` | Recurso `TDMCADCARGA` |
| CDS adicionais | `CDSConferencia`, `CDSOutrosFretes`, `CDSEntregas`, `CDSOpRCPE`, `CDSResumo` | Recurso `TDMCADCARGA` |

`CDSCadastro` declara o parâmetro de consulta `COD`. `CDSDocumentos` declara eventos `BeforeInsert`, `BeforePost` e `OnNewRecord`, o que sustenta uma tentativa de inclusão pelo dataset, mas não revela as regras desses eventos. As strings `CODIGO_CARGA`, `CARGA_DOCFAT` e `CODIGO_DOCFAT` aparecem no binário descompactado. A presença das strings não prova que `CODIGO_DOCFAT` seja um campo do dataset `CDSDocumentos`.

## Confronto com o banco de teste

Consulta somente leitura no banco dedicado de testes: `CARGA_DOCUMENTOS` contém `CARGA_CARDOC` e `DOCUMENTO_CARDOC`; `DOCUMENTO_FATURA` contém `CODIGO_DOCFAT`, `TIPO_DOCFAT`, `EMPRESA_DOCFAT` e `CARGA_DOCFAT`; `CARGA` contém `CODIGO_CARGA`, `DTEMISSAO_CARGA` e `SERVICODEENVIO_CARGA`. Os dois últimos são NOT NULL. O pedido `843172`, indicado pelo usuário, é tipo 1, empresa 1, `STATUS_DOCFAT=0`, `SITUACAO_DOCFAT=0`, `CARGA_DOCFAT=0` e tinha zero vínculos em `CARGA_DOCUMENTOS` na leitura. O esquema corrige o campo de vínculo pretendido para `DOCUMENTO_CARDOC`, mas a projeção efetiva de `CDSDocumentos` segue pendente da tela em execução.

## Abas de `FCadCarga`

O recurso contém **28 `TTabSheet` em 5 `TPageControl`**. Captions foram normalizadas apenas para remover espaços de borda.

| Controle | Aba | Caption |
| --- | --- | --- |
| `PageControl1` | `TabSheet1` | Dados Principais |
| `PageControl1` | `TSDocumentos` | Documentos |
| `PageControl1` | `tbsOutrosFretes` | Outros Fretes |
| `PageControl1` | `tbsOrdemRecolhimento` | Rec. Assistência |
| `PageControl1` | `TabSheet6` | Transporte |
| `PageControl1` | `TSConferencia` | Carregamento |
| `PageControl1` | `tbsRCPE` | OP / RCPE |
| `PageControl1` | `tsResumo` | Resumo |
| `TSDocumentos/PageControl2` | `TSProdutos` | Produtos |
| `TSDocumentos/PageControl2` | `TSOutros` | Outros |
| `TSDocumentos/PageControl2` | `TabSheet2` | Prazos |
| `TSDocumentos/PageControl2` | `TabSheet3` | Observação do Ped./Assist. |
| `TSDocumentos/PageControl2` | `tbsObsNF` | Observação p/ NF |
| `TSDocumentos/PageControl2` | `tbsVendaOrdem` | Nota Fiscal do Adquirente |
| `TSDocumentos/PageControl2` | `TSInfRastreio` | Informações de Rastreio |
| `tbsOrdemRecolhimento/PgcRecolhimento` | `TbsRecolhimento` | Assistências para Recolhimento |
| `tbsOrdemRecolhimento/PgcRecolhimento` | `TbsCliente` | Cliente |
| `tbsOrdemRecolhimento/PgcRecolhimento` | `TbsRegiao` | Região |
| `tbsOrdemRecolhimento/PgcRecolhimento` | `TbsCidade` | Cidade |
| `tbsOrdemRecolhimento/PgcRecolhimento` | `TbsUF` | UF |
| `tbsOrdemRecolhimento/PgcRecolhimento` | `TbsAssistencia` | Assistencia |
| `tbsOrdemRecolhimento/PgcRecolhimento` | `TbsEmpresa` | Empresa |
| `tbsOrdemRecolhimento/PgcRecolhimento` | `TbsStatusAssistencia` | Status da Assistência |
| `TabSheet6/PageControl3` | `TabSheet4` | Transporte (Veículo / Reboque / Outros) |
| `TabSheet6/PageControl3` | `TSRastreio` | Informações de Rastreio |
| `TSConferencia/PageControl4` | `TSDadosConf` | Sep./Conferência |
| `TSConferencia/PageControl4` | `TSDadosSumario` | Itens |
| `TSConferencia/PageControl4` | `TabSheet7` | Inconsistências / Informações |

## Componentes relevantes ao primeiro cenário

| Área | Componente | Ligação observada |
| --- | --- | --- |
| Dados Principais | `EdtDescCarga` | `DESCRICAO_CARGA` / `DS` |
| Dados Principais | `edtDataEmissao` | `DTEMISSAO_CARGA` / `DS` |
| Dados Principais | `JvDBDateEdit2` | `DTPREVISAOFATURAMENTO_CARGA` / `DS` |
| Documentos | `GradeDocumentos` | `DSDocumentos` |
| Documentos | `btnFiltro` (`&Adicionar`) | `btnFiltroClick` |
| Documentos/Produtos | `GradeItens` | `DSItens` |
| Transporte | `edtTransportador` | `TRANSPORTADOR_CARGA` / `DS` |
| Transporte | `edtMotorista` | `MOTORISTA_CARGA` / `DS` |
| Carregamento/Itens | `GradeConferencia` | `DSConferencia` |

**Limite da evidência:** o DFM confirma componentes e ligações declarativas desta versão do executável. Ele não revela quais campos a lógica exige para gravar, a elegibilidade dos pedidos de venda, o estado após gravação, as abas criadas dinamicamente ou o comportamento real do evento de menu. Essas regras devem ser observadas no ERP e registradas antes de fechar o JSON e os critérios de execução.
