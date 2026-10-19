import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-fin-mapeamento-componentes-bordero-recebimento",
  "categoria": "units",
  "titulo": "P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO",
  "unit": "P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_FIN_MAPEAMENTO_BORDERO_RECEBIMENTO"
  ],
  "resumo": "Mapeia a tela de acerto e expõe comandos e datasets do borderô de recebimento.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "mapeamentos",
    "subgrupo": "financeiro",
    "ordem": 1
  },
  "fontes": [
    {
      "caminho": "docs/assets/casosTestesFinanceiro/P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "FCadBorderoAcerto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "DMCadBorderoAcerto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSCadastroRecebimento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSReceberRecebimento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSProrrogacoesRecebimento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSPagarRecebimento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSOrdemPagto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSGrupoResultadoRecebimento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSComplementosRecebimento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSChequeSaida",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSCheques",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSMovCartao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "EditCodigo",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtCliente",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "PageControl1",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "cbSubTipo",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "cbQualificacaoRecebimento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "cbCalcJuroDesconto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtDiasDescarga",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtNovoBanco",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtNovaSituacao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtNovaConta",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtTaxaMensal",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtCaracteristica",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "DataAcerto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "mmObs",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TotalCredito",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "GRManuais",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "Prorrogacoes",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CreditoNaoUtilizado",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TotalDebito",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "VlrNominalBaixado",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "VlrAindaAberto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TotalDebitosAtualizados",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "JurosCalculados",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "DescontosCalculados",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "Diferenca",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "PrazosMediosDebito",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "PrazosMediosCredito",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "PrazosMediosGeral",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ExibirContasReceberDescontadas",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ExibirContasReceberDesconsideradas",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ExibirContasAPagar",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ExibirMovCartao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "chkDataFinalVencimentoDuplicatas",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "DataIniPagar",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "DataFimPagar",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "DataIniCartao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "DataFimCartao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "DtFinalVenc",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtOperacao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtIntegracaoCTB",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtCodigoImportacao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtDataInicial",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "edtDataFinal",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TabSheet1",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSContabilidade",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSDados",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSEmpresa",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSChequeSaida",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSOrdemPgto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSMovCartao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSCheque",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSComplementos",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSGrupoResultado",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSCarga",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSSituacao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSFormaPagamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSProrrogacoes",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSReceber",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "TSPagar",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "Main",
      "tipo": "metodo",
      "assinatura": "procedure Main"
    },
    {
      "nome": "MapearBordero",
      "tipo": "metodo",
      "assinatura": "procedure MapearBordero"
    },
    {
      "nome": "AbrirBordero",
      "tipo": "metodo",
      "assinatura": "procedure AbrirBordero(Codigo: Integer; AbreMovCx: Boolean)"
    },
    {
      "nome": "Calcular",
      "tipo": "metodo",
      "assinatura": "procedure Calcular"
    },
    {
      "nome": "IncluirBordero",
      "tipo": "metodo",
      "assinatura": "procedure IncluirBordero"
    },
    {
      "nome": "GravarBordero",
      "tipo": "metodo",
      "assinatura": "procedure GravarBordero"
    },
    {
      "nome": "Excluir",
      "tipo": "metodo",
      "assinatura": "procedure Excluir"
    },
    {
      "nome": "Filtrar",
      "tipo": "metodo",
      "assinatura": "procedure Filtrar"
    },
    {
      "nome": "Fechar",
      "tipo": "metodo",
      "assinatura": "procedure Fechar"
    },
    {
      "nome": "MapearTSFiltros",
      "tipo": "metodo",
      "assinatura": "procedure MapearTSFiltros"
    },
    {
      "nome": "MapearTotalizacao",
      "tipo": "metodo",
      "assinatura": "procedure MapearTotalizacao"
    },
    {
      "nome": "MapearContabilidade",
      "tipo": "metodo",
      "assinatura": "procedure MapearContabilidade"
    },
    {
      "nome": "MapearTabSheets",
      "tipo": "metodo",
      "assinatura": "procedure MapearTabSheets"
    },
    {
      "nome": "MapearPrincipal",
      "tipo": "metodo",
      "assinatura": "procedure MapearPrincipal"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Localizar o formulário de recebimento e centralizar o acesso a seus componentes e eventos."
        },
        {
          "tipo": "paragrafo",
          "texto": "Permitir que cenários usem o borderô sem repetir os nomes concretos de componentes em cada teste."
        }
      ]
    },
    {
      "id": "estados",
      "titulo": "Estados globais",
      "blocos": [
        {
          "tipo": "tabela",
          "colunas": [
            "Estado / tipo",
            "Finalidade",
            "Ciclo de vida"
          ],
          "linhas": [
            [
              "FCadBorderoAcerto: TForm",
              "Tela de borderô de recebimento.",
              "Obtida ou criada em MapearBordero; Fechar chama Close, sem liberar a referência."
            ],
            [
              "DMCadBorderoAcerto: TDataModule",
              "Módulo de dados do formulário.",
              "Obtido por FindComponent; não é criado nem liberado diretamente pelo helper."
            ],
            [
              "CDSCadastroRecebimento, CDSReceberRecebimento, CDSProrrogacoesRecebimento, CDSPagarRecebimento, CDSOrdemPagto, CDSGrupoResultadoRecebimento, CDSComplementosRecebimento, CDSChequeSaida, CDSCheques, CDSMovCartao: TClientDataSet",
              "Datasets vinculados ao módulo de dados.",
              "Referências atribuídas no mapeamento; AbrirBordero reabre CDSCadastroRecebimento para o código informado."
            ],
            [
              "EditCodigo: TJvCalcEdit",
              "Código do borderô exibido.",
              "Mapeado no formulário e atualizado por AbrirBordero."
            ],
            [
              "edtCliente: TJvDBCalcEdit",
              "Campo de cliente.",
              "Mapeado por FindComponent."
            ],
            [
              "PageControl1: TPageControl",
              "Controle de abas.",
              "Referência pertencente à tela."
            ],
            [
              "cbSubTipo, cbQualificacaoRecebimento, cbCalcJuroDesconto: TJvDBComboBox",
              "Seletores principais do acerto.",
              "Atribuídos em MapearPrincipal."
            ],
            [
              "edtDiasDescarga: TJvDBCalcEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtNovoBanco: TJvDBCalcEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtNovaSituacao: TJvDBCalcEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtNovaConta: TJvDBCalcEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtTaxaMensal: TJvDBCalcEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtCaracteristica: TJvDBCalcEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "DataAcerto: TJvDBDateEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "mmObs: TDBMemo",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TotalCredito: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "GRManuais: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "Prorrogacoes: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "CreditoNaoUtilizado: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TotalDebito: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "VlrNominalBaixado: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "VlrAindaAberto: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TotalDebitosAtualizados: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "JurosCalculados: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "DescontosCalculados: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "Diferenca: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "PrazosMediosDebito: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "PrazosMediosCredito: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "PrazosMediosGeral: TLabel",
              "Labels de totaliza??o da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "ExibirContasReceberDescontadas: TCheckBox",
              "Filtros e op??es da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "ExibirContasReceberDesconsideradas: TCheckBox",
              "Filtros e op??es da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "ExibirContasAPagar: TCheckBox",
              "Filtros e op??es da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "ExibirMovCartao: TCheckBox",
              "Filtros e op??es da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "chkDataFinalVencimentoDuplicatas: TCheckBox",
              "Filtros e op??es da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "DataIniPagar: TJvDateEdit",
              "Intervalos de datas dos filtros.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "DataFimPagar: TJvDateEdit",
              "Intervalos de datas dos filtros.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "DataIniCartao: TJvDateEdit",
              "Intervalos de datas dos filtros.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "DataFimCartao: TJvDateEdit",
              "Intervalos de datas dos filtros.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "DtFinalVenc: TJvDateEdit",
              "Intervalos de datas dos filtros.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtOperacao: TDBEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtIntegracaoCTB: TJvDBCalcEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtCodigoImportacao: TDBEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtDataInicial: TJvDBDateEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "edtDataFinal: TJvDBDateEdit",
              "Refer?ncias adicionais aos controles do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TabSheet1: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSContabilidade: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSDados: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSEmpresa: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSChequeSaida: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSOrdemPgto: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSMovCartao: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSCheque: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSComplementos: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSGrupoResultado: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSCarga: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSSituacao: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSFormaPagamento: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSProrrogacoes: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSReceber: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "TSPagar: TTabSheet",
              "Abas espec?ficas do formul?rio.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ]
          ]
        }
      ]
    },
    {
      "id": "metodos",
      "titulo": "Procedures e functions",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "As assinaturas abaixo pertencem ao fonte referenciado. Cada entrada descreve sua responsabilidade e a forma de implementação."
        }
      ]
    },
    {
      "id": "main",
      "titulo": "Main",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Main;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Iniciar o mapeamento."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama MapearBordero."
        }
      ]
    },
    {
      "id": "mapearbordero",
      "titulo": "MapearBordero",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure MapearBordero;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Obter tela, datasets e controles."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém ou cria a tela, encontra o módulo e chama os mapeamentos; erro mostra mensagem e libera FCadBorderoAcerto."
        }
      ]
    },
    {
      "id": "abrirbordero",
      "titulo": "AbrirBordero",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure AbrirBordero(Codigo: Integer; AbreMovCx: Boolean);"
        },
        {
          "tipo": "paragrafo",
          "texto": "Carregar um borderô pelo código."
        },
        {
          "tipo": "paragrafo",
          "texto": "Fecha o cadastro, define CodigoAtual, reabre, atualiza EditCodigo e calcula; opcionalmente chama MovBordero."
        }
      ]
    },
    {
      "id": "calcular",
      "titulo": "Calcular",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Calcular;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Calcular valores do borderô."
        },
        {
          "tipo": "paragrafo",
          "texto": "Executa BotaoCalcularClick no formulário."
        }
      ]
    },
    {
      "id": "incluirbordero",
      "titulo": "IncluirBordero",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure IncluirBordero;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Iniciar inclusão."
        },
        {
          "tipo": "paragrafo",
          "texto": "Executa BotaoIncluirClick."
        }
      ]
    },
    {
      "id": "gravarbordero",
      "titulo": "GravarBordero",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure GravarBordero;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Gravar o acerto."
        },
        {
          "tipo": "paragrafo",
          "texto": "Executa BotaoGravarClick."
        }
      ]
    },
    {
      "id": "excluir",
      "titulo": "Excluir",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Excluir;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Excluir o registro corrente."
        },
        {
          "tipo": "paragrafo",
          "texto": "Executa ExcluirRegistro no módulo de dados com os argumentos do fonte."
        }
      ]
    },
    {
      "id": "filtrar",
      "titulo": "Filtrar",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Filtrar;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Aplicar os filtros da tela."
        },
        {
          "tipo": "paragrafo",
          "texto": "Executa BotaoFiltrarClick."
        }
      ]
    },
    {
      "id": "fechar",
      "titulo": "Fechar",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Fechar;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Fechar a tela."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama Close no formulário."
        }
      ]
    },
    {
      "id": "mapeartsfiltros",
      "titulo": "MapearTSFiltros",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure MapearTSFiltros;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Mapear filtros e intervalos de datas."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém checkboxes e editores pelos nomes concretos."
        }
      ]
    },
    {
      "id": "mapeartotalizacao",
      "titulo": "MapearTotalizacao",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure MapearTotalizacao;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Mapear os resultados de totalização."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém labels de créditos, débitos, juros, descontos e prazos."
        }
      ]
    },
    {
      "id": "mapearcontabilidade",
      "titulo": "MapearContabilidade",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure MapearContabilidade;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Mapear campos contábeis."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém operação, integração, código de importação e intervalo de datas."
        }
      ]
    },
    {
      "id": "mapeartabsheets",
      "titulo": "MapearTabSheets",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure MapearTabSheets;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Mapear as abas da tela."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém as TabSheets usadas nas operações."
        }
      ]
    },
    {
      "id": "mapearprincipal",
      "titulo": "MapearPrincipal",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure MapearPrincipal;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Mapear os controles principais."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém seletores, código, cliente, conta e demais campos principais."
        }
      ]
    },
    {
      "id": "implementacao",
      "titulo": "Como a unit é implementada",
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Também mantém referências a campos principais, labels de totalização, filtros, controles contábeis e abas, todas pertencentes à tela.",
            "Não cria datasets temporários próprios como o mapeamento de pagamento."
          ]
        }
      ]
    },
    {
      "id": "dependencias",
      "titulo": "Dependências e integração",
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "MOVIMENTO_CAIXA aparece somente em uses comentado; MovBordero depende do contexto fornecido pelo host.",
            "O piloto financeiro usa P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO."
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "O nome canônico identifica o arquivo Pascal e a página. O fonte vinculado é a evidência local; confira o cadastro e a versão da unit instalada no ERP antes de executar."
        }
      ]
    },
    {
      "id": "limites",
      "titulo": "Limites e observações",
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Confira o cadastro externo e a versão do fonte instalada no ERP após a renomeação.",
            "O bloco de erro libera a tela, mas não relança a exceção nem zera as referências globais.",
            "O consumidor deve mapear a tela antes de chamar operações; o fonte não valida todas as referências."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
