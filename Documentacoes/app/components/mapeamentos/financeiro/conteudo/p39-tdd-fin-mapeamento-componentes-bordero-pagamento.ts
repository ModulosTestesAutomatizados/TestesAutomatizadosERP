import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-fin-mapeamento-componentes-bordero-pagamento",
  "categoria": "units",
  "titulo": "P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO",
  "unit": "P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_FIN_MAPEAMENTO_BORDERO_PAGAMENTO"
  ],
  "resumo": "Mapeia a tela de borderô de pagamento e mantém referências aos componentes, datasets e seletores.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "mapeamentos",
    "subgrupo": "financeiro",
    "ordem": 0
  },
  "fontes": [
    {
      "caminho": "docs/assets/casosTestesFinanceiro/P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "fBorderoPagamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "PageControl",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "PageControl2",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "cbTipoBordero",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "cbQualificacaoPagamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "cbCalculoJuros",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ceCodBordero",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ceConta",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ceDataAcerto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ceTaxaJuros",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "btnIncluir",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "btnExcluir",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "btnGravar",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "btnCancelar",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "sbUltimo",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSPagarPagamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSProrrogacaoPagamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSChqDevolvido",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSChqTerceiro",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSChqProprio",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSComplementoPagamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSReceberPagamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSAdiantamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSGrupoResultadoPagamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSCadastroPagamento",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSCadastroTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSProrrogacaoTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSChqDevolvidoTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSChqTerceiroTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSChqProprioTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSComplementoTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSReceberTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSAdiantamentoTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSGrupoResultadoTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSPagarTemp",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "SPessoa",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "CDSSelecao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "rgPessoa",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ckProrrogacao",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ckChequesDev",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ckDuplicReceber",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ckExibirBaixados",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ckConPromessaPag",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ckExibirDevolvidos",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ckExibirChequeRecParc",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "ckExibirDupRecParc",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditProrrogacoesIni",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditProrrogacoesFim",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditchequeDevEntreIni",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditchequeDevEntreFim",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditContasPgEntreIni",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditContasPgEntreFim",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditChequeTerceiroIni",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditChequeTerceiroFim",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditDupReceberEntreIni",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "dtEditDupReceberEntreFim",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelPMC",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelPMD",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelPMG",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelTotCredito",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelGRManuais",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelProrrogacoes",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelChequeDev",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelTotDebito",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelNominalABaixar",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelAindaAberto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "lblTotDebitoAtualizado",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelJurosCalculados",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelDescontosCalculados",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelPreDesconto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "LabelDiferenca",
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
      "nome": "CriarObjetos",
      "tipo": "metodo",
      "assinatura": "procedure CriarObjetos"
    },
    {
      "nome": "MapearComponentesBorderoPagamento",
      "tipo": "metodo",
      "assinatura": "procedure MapearComponentesBorderoPagamento"
    },
    {
      "nome": "IniciarCDSCadastroBordero",
      "tipo": "metodo",
      "assinatura": "procedure IniciarCDSCadastroBordero"
    },
    {
      "nome": "DestruirObjetos",
      "tipo": "metodo",
      "assinatura": "procedure DestruirObjetos"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Localizar a tela e seus componentes e preparar os datasets temporários utilizados pelo cenário financeiro."
        },
        {
          "tipo": "paragrafo",
          "texto": "Separar os nomes concretos de componentes do fluxo de teste; o helper pode atender consumidores além do IRunner."
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
              "fBorderoPagamento: TForm",
              "Referência a FCadBorderoPagamento.",
              "Obtida ou criada em CriarObjetos; Show abre a tela."
            ],
            [
              "PageControl, PageControl2: TPageControl",
              "Abas usadas pelo cenário.",
              "Mapeadas por FindComponent; pertencem ao formulário."
            ],
            [
              "cbTipoBordero, cbQualificacaoPagamento, cbCalculoJuros: TJvDBComboBox",
              "Seleção de tipo, qualificação e juros.",
              "Mapeadas a partir dos componentes da tela."
            ],
            [
              "ceCodBordero, ceConta, ceDataAcerto, ceTaxaJuros: TJvDBCalcEdit",
              "Referências aos campos de código, conta, data e taxa.",
              "Tipos e nomes são os declarados no fonte; pertencem à tela."
            ],
            [
              "btnIncluir, btnExcluir, btnGravar, btnCancelar, sbUltimo: TNewBtn",
              "Referências a comandos da tela.",
              "Os quatro botões principais são mapeados; sbUltimo é declarado, sem atribuição no mapeamento."
            ],
            [
              "CDSPagarPagamento, CDSProrrogacaoPagamento, CDSChqDevolvido, CDSChqTerceiro, CDSChqProprio, CDSComplementoPagamento, CDSReceberPagamento, CDSAdiantamento, CDSGrupoResultadoPagamento, CDSCadastroPagamento: TClientDataSet",
              "Datasets reais de DMCadBorderoPagamento.",
              "Obtidos em IniciarCDSCadastroBordero; não são liberados por DestruirObjetos."
            ],
            [
              "CDSCadastroTemp, CDSProrrogacaoTemp, CDSChqDevolvidoTemp, CDSChqTerceiroTemp, CDSChqProprioTemp, CDSComplementoTemp, CDSReceberTemp, CDSAdiantamentoTemp, CDSGrupoResultadoTemp, CDSPagarTemp: TClientDataSet",
              "Datasets temporários próprios.",
              "Criados em CriarObjetos e liberados por DestruirObjetos."
            ],
            [
              "SPessoa: TSelecao",
              "Componente de seleção de pessoa.",
              "Obtido no formulário; fornece CDSSelecao e rgPessoa."
            ],
            [
              "CDSSelecao: TClientDataSet",
              "Dataset do seletor de pessoa.",
              "Referência ao componente filho de SPessoa; não é criado pelo helper."
            ],
            [
              "rgPessoa: TRadioGroup",
              "Opções de pessoa no seletor.",
              "Mapeado por SPessoa.FindComponent."
            ],
            [
              "ckProrrogacao, ckChequesDev, ckDuplicReceber, ckExibirBaixados, ckConPromessaPag, ckExibirDevolvidos, ckExibirChequeRecParc, ckExibirDupRecParc: TCheckBox",
              "Filtros e op??es da tela.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "dtEditProrrogacoesIni, dtEditProrrogacoesFim, dtEditchequeDevEntreIni, dtEditchequeDevEntreFim, dtEditContasPgEntreIni, dtEditContasPgEntreFim, dtEditChequeTerceiroIni, dtEditChequeTerceiroFim, dtEditDupReceberEntreIni, dtEditDupReceberEntreFim: TJvDateEdit",
              "Intervalos de datas dos filtros.",
              "Atribu?das pelas rotinas de mapeamento; pertencem ao formul?rio e n?o s?o liberadas separadamente."
            ],
            [
              "LabelPMC, LabelPMD, LabelPMG, LabelTotCredito, LabelGRManuais, LabelProrrogacoes, LabelChequeDev, LabelTotDebito, LabelNominalABaixar, LabelAindaAberto, lblTotDebitoAtualizado, LabelJurosCalculados, LabelDescontosCalculados, LabelPreDesconto, LabelDiferenca: TLabel",
              "Labels de totaliza??o da tela.",
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
          "texto": "Preparar os objetos e datasets da tela."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama CriarObjetos e IniciarCDSCadastroBordero; a chamada de limpeza no finally está comentada."
        }
      ]
    },
    {
      "id": "criarobjetos",
      "titulo": "CriarObjetos",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure CriarObjetos;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Obter a tela e preparar temporários."
        },
        {
          "tipo": "paragrafo",
          "texto": "Obtém ou cria FCadBorderoPagamento, mostra a tela, cria dez datasets temporários e mapeia componentes."
        }
      ]
    },
    {
      "id": "mapearcomponentesborderopagamento",
      "titulo": "MapearComponentesBorderoPagamento",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure MapearComponentesBorderoPagamento;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Resolver componentes pelos nomes da tela."
        },
        {
          "tipo": "paragrafo",
          "texto": "Atribui abas, controles, filtros, labels, botões e componentes da seleção de pessoa via FindComponent."
        }
      ]
    },
    {
      "id": "iniciarcdscadastrobordero",
      "titulo": "IniciarCDSCadastroBordero",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure IniciarCDSCadastroBordero;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Obter os datasets reais do módulo de dados."
        },
        {
          "tipo": "paragrafo",
          "texto": "Localiza DMCadBorderoPagamento e atribui os datasets ao contexto global do helper."
        }
      ]
    },
    {
      "id": "destruirobjetos",
      "titulo": "DestruirObjetos",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure DestruirObjetos;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Liberar os datasets temporários."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama Free nos dez temporários; a liberação do formulário está comentada."
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
            "As constantes cAbaPrincipal até cAbaTotalizacao identificam índices de abas.",
            "Também declara checkboxes de filtros, intervalos de datas e labels de totalização, mapeados por nomes concretos do formulário."
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
            "Sem uses ativo no fonte; tipos e métodos de localização são fornecidos pelo host.",
            "O piloto P39_TDD_FIN_FINANCEIRO referencia P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO no uses."
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
            "O nome do cadastro externo precisa acompanhar a renomeação local; a versão instalada no ERP exige conferência.",
            "FindComponent pode retornar referência ausente; o fonte não valida todas as atribuições.",
            "CriarObjetos cria novos temporários em cada chamada; Main não executa a limpeza comentada no finally."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
