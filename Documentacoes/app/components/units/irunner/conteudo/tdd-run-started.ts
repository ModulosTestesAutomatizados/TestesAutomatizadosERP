import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_STARTED",
  "resumo": "Validar a versão requerida e aplicar os parâmetros do caso corrente antes de Teste.",
  "responsabilidade": "Validar a versão requerida e aplicar os parâmetros do caso corrente antes de Teste.",
  "problema": "Preparar a execução com o JSON e a identidade já definidos no registro corrente.",
  "fonte": "docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_STARTED.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_STARTED",
    "P39_TDD_RUN_STARTED",
    "TDD_STARTED"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 3
  },
  "estados": [
    [
      "FCasoTesteAtualId: integer",
      "Estado compartilhado declarado nesta unit.",
      "Gerenciado pelos métodos do fonte e consumido no contexto interpretado."
    ],
    [
      "FCasoTesteAtualJson: string",
      "Estado compartilhado declarado nesta unit.",
      "Gerenciado pelos métodos do fonte e consumido no contexto interpretado."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções da unit conforme FExibirInstrucoes.",
      "Declaração no fonte atual, linha 19. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure AplicarParametrosDoCasoTeste;",
      "Aplica a seção opcional de parâmetros; ausência ou objeto vazio não altera o sistema. Lê somente a seção de parâmetros da raiz e rejeita JSON ou seção inválidos.",
      "Declaração no fonte atual, linha 50. Consulte a implementação canônica vinculada."
    ],
    [
      "function ValidarVersaoRequisito :boolean;",
      "Aceita requisito vazio; valida a versão mínima quando informada e registra incompatibilidade.",
      "Declaração no fonte atual, linha 103. Consulte a implementação canônica vinculada."
    ],
    [
      "procedure Started;",
      "Obtém ID, descrição e JSON do registro corrente, sem carregar casos ou mover o cursor.",
      "Declaração no fonte atual, linha 138. Consulte a implementação canônica vinculada."
    ]
  ],
  "implementacao": [
    "Started valida a versão requerida e aplica parâmetros do caso já selecionado. parametros ausente ou {} não aplica alterações; tipo diferente de objeto é configuração inválida.",
    "AplicarParametrosDoCasoTeste usa TJSONObject e GetPair/GetPairName/GetPairValue da cadeia de uses. Não usar GetValueJson para extrair objeto inteiro: a limitação nativa observada é Conversion from TJSONObject to string is not supported; propriedade ausente também pode lançar.",
    "Aplicar parâmetros altera a configuração do ERP. Liberar datasets não restaura os valores anteriores."
  ],
  "dependencias": [
    "P39_TDD_CASOS_DE_TESTE: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria."
  ]
});
