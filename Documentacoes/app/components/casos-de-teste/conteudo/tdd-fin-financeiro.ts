import { criarDocumentoUnit } from '../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_FIN_FINANCEIRO",
  "resumo": "Executar duplicata receber/pagar e borderô receber/pagar para o registro corrente.",
  "responsabilidade": "Executar duplicata receber/pagar e borderô receber/pagar para o registro corrente.",
  "problema": "Exercitar o financeiro com captura de dados antes do fechamento e deixar a comparação para ASSERTS.",
  "fonte": "docs/assets/casosTestesFinanceiro/TDD_FIN_FINANCEIRO.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_FIN_PAGAMENTO_RECEBIMENTO",
    "TDD_FINANCEIRO",
    "REFACTOR_TDD_FINANCEIRO_PILOTO"
  ],
  "navegacao": {
    "grupo": "casos",
    "ordem": 1
  },
  "estados": [
    [
      "FCasoTesteInvalido: Boolean",
      "Sinalização da validação financeira corrente.",
      "ValidarCasoTeste reinicia e preenche antes das operações."
    ],
    [
      "FMsgCasoTesteInvalido: String",
      "Diagnóstico dos dados financeiros rejeitados.",
      "Reiniciada e construída em ValidarCasoTeste."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta instruções; a entrada do cenário é Teste.",
      "Declaração no fonte atual, linha 13. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure ValidarCasoTeste;",
      "Validação específica do financeiro; usa o JSON preparado por Started sem carregar casos. EMPRESA_DUP deve corresponder à empresa atual; TIPODOC_DUP mantém a validação existente. PESSOA_DUP, VALOR_DUP, GRUPORESULTADO_DUPGR e CONTA_BORD não usam configuração padrão. QUALIFICACAO_DUP, PESSOANOTACREDITO_BORD e PRAZOVENCIMENTO_DUP continuam opcionais.",
      "Declaração no fonte atual, linha 45. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure Teste;",
      "Valida o JSON e executa duplicata receber, duplicata pagar, borderô receber e borderô pagar.",
      "Declaração no fonte atual, linha 79. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure _IncluirDuplicata(pTipo: Integer);",
      "Tipo 0: duplicata receber. Tipo 1: duplicata pagar.",
      "Declaração no fonte atual, linha 106. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure _IncluirBordero(pTipo: Integer);",
      "Tipo 0: recebimento. Tipo 1: pagamento, incluindo a seleção da pessoa. Mantém os mapeamentos, filtros, totalização e gravação próprios de cada tipo.",
      "Declaração no fonte atual, linha 177. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure TearDown_DestruirObjetos;",
      "Declarada no final; cancela edições e fecha telas sem destruir CDS compartilhados.",
      "Declaração no fonte atual, linha 338. Consulte a implementação canônica vinculada."
    ]
  ],
  "implementacao": [
    "ValidarCasoTeste exige a empresa corrente e os dados financeiros do JSON preparado por Started. Não recarrega casos nem move o cursor do lote.",
    "Teste executa quatro operações: duplicata receber, duplicata pagar, borderô receber e borderô pagar. Captura CDSCadastro por DataSet|DM depois de gravar e antes de TearDown_DestruirObjetos.",
    "O finally marca FNomeMetodoAtual como TEARDOWN e fecha recursos financeiros/cancela edições pendentes. CDS compartilhados continuam pertencendo ao lote. ASSERTS é executado pela casca após o retorno do Teste.",
    "A abertura é delegada a TDD_RUN_APPLICATION.AbrirTela, disponível pela cadeia de uses do runner. Duplicatas usam DuplicatasaReceber1Click e DuplicatasaPagar1Click; borderôs usam BorderdeAcerto1Click e BorderdePagamento1Click. São os eventos configurados neste fonte, a conferir no módulo do ERP.",
    "O cenário conserva a localização dos DMs/componentes, filtros, totalização, gravação e foco dos campos. TearDown_DestruirObjetos cancela edições e fecha Forms; não libera datasets pertencentes ao ERP.",
    "A fonte única do caso é docs/assets/casosTestesFinanceiro/TDD_FIN_FINANCEIRO_JSON.json, carregada na sincronização como TDD_FIN_FINANCEIRO_JSON (com P39_ conforme a origem). parametros é opcional; camposDisponiveis e resultadoEsperado são resolvidos e preservados na raiz pelo registro."
  ],
  "dependencias": [
    "P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO: cláusula uses do fonte.",
    "P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria."
  ],
  "jsonBase": {
    "exemplo": {
      "EMPRESA_DUP": 1,
      "TIPODOC_DUP": 11,
      "QUALIFICACAO_DUP": 1,
      "PESSOA_DUP": 0,
      "VALOR_DUP": 0,
      "GRUPORESULTADO_DUPGR": 0,
      "CONTA_BORD": 5,
      "PESSOANOTACREDITO_BORD": 3256,
      "PRAZOVENCIMENTO_DUP": 30,
      "parametros": {
        "NecessarioAutorizarPagamentos": false,
        "NecessarioAutorizarAdiantamentos": false,
        "ObrigatorioGrupoResultadoDiferenteDeZeroNaDuplicata": true,
        "OcultarDuplicataPagarSalario": false,
        "BloquearLancamentoBorderoQualificacao0Todas": false,
        "BorderoExigirPreenchimentoRegraIntegracaoContabil": false
      }
    },
    "campos": [
      [
        "EMPRESA_DUP",
        "número",
        "Empresa do ambiente.",
        "Precisa corresponder à empresa atual."
      ],
      [
        "TIPODOC_DUP",
        "número",
        "Tipo de documento.",
        "Segue validação já existente no financeiro."
      ],
      [
        "QUALIFICACAO_DUP",
        "número",
        "Qualificação opcional da duplicata.",
        "Lida como tag opcional pelo cenário."
      ],
      [
        "PESSOA_DUP",
        "número",
        "Pessoa/fornecedor da duplicata.",
        "Preencher ID válido; zero do modelo é rejeitado."
      ],
      [
        "VALOR_DUP",
        "número",
        "Valor da duplicata.",
        "Preencher valor positivo; zero não é massa válida."
      ],
      [
        "GRUPORESULTADO_DUPGR",
        "número",
        "Grupo de resultado.",
        "Preencher ID válido segundo as regras do teste."
      ],
      [
        "CONTA_BORD",
        "número",
        "Conta do borderô.",
        "Obrigatória para operações; não usa configuração padrão do módulo."
      ],
      [
        "PESSOANOTACREDITO_BORD",
        "número",
        "Pessoa opcional da nota de crédito.",
        "Aplicada quando o valor é positivo; conferir massa do ambiente."
      ],
      [
        "PRAZOVENCIMENTO_DUP",
        "número",
        "Prazo opcional de vencimento.",
        "Usado no cálculo da data pelo cenário."
      ],
      [
        "parametros",
        "objeto",
        "Ajustes do ERP antes do Teste.",
        "Started aplica o objeto; não há restauração automática."
      ],
      [
        "parametros.NecessarioAutorizarPagamentos",
        "booleano",
        "Parâmetro ERP por nome.",
        "VerificarParametros altera o ambiente conforme o caso; conferir escopo e permissões do ERP."
      ],
      [
        "parametros.NecessarioAutorizarAdiantamentos",
        "booleano",
        "Parâmetro ERP por nome.",
        "VerificarParametros altera o ambiente conforme o caso; conferir escopo e permissões do ERP."
      ],
      [
        "parametros.ObrigatorioGrupoResultadoDiferenteDeZeroNaDuplicata",
        "booleano",
        "Parâmetro ERP por nome.",
        "VerificarParametros altera o ambiente conforme o caso; conferir escopo e permissões do ERP."
      ],
      [
        "parametros.OcultarDuplicataPagarSalario",
        "booleano",
        "Parâmetro ERP por nome.",
        "VerificarParametros altera o ambiente conforme o caso; conferir escopo e permissões do ERP."
      ],
      [
        "parametros.BloquearLancamentoBorderoQualificacao0Todas",
        "booleano",
        "Parâmetro ERP por nome.",
        "VerificarParametros altera o ambiente conforme o caso; conferir escopo e permissões do ERP."
      ],
      [
        "parametros.BorderoExigirPreenchimentoRegraIntegracaoContabil",
        "booleano",
        "Parâmetro ERP por nome.",
        "VerificarParametros altera o ambiente conforme o caso; conferir escopo e permissões do ERP."
      ],
      [
        "camposDisponiveis",
        "objeto",
        "Campos disponíveis para consulta.",
        "Ausente ou {} usa P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO na sincronização."
      ],
      [
        "resultadoEsperado",
        "objeto",
        "Critérios de erro, valor e tempo.",
        "Ausente usa P39_TDD_ASSERTS_JSON_MINIMO; {} explícito dispensa validação automática e registra SEM_VALIDACAO."
      ]
    ],
    "observacoes": [
      "Modelo fornecido para preenchimento, não massa positiva pronta. PESSOA_DUP, VALOR_DUP e GRUPORESULTADO_DUPGR estão zerados e ValidarCasoTeste os rejeita.",
      "Números e IDs dos demais campos são exemplos do modelo; validar valores no ambiente antes de executar.",
      "O exemplo não define resultadoEsperado: a sincronização usa o mínimo remoto. Definir resultadoEsperado: {} explicitamente desativa esse fallback e mantém apenas as verificações explícitas.",
      "Este modelo JSON está versionado junto dos artefatos; preencha a massa do ambiente. Os mínimos de asserts e campos disponíveis têm moldes canônicos em docs/assets/snippets e são lidos pelas respectivas units remotas durante a sincronização."
    ],
    "fontes": [
      "docs/assets/casosTestesFinanceiro/TDD_FIN_FINANCEIRO_JSON.json"
    ]
  }
});
