import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_RUN_STARTED",
  "resumo": "Validar a versão requerida e aplicar os parâmetros do caso corrente antes de Teste.",
  "responsabilidade": "Validar a versão requerida e aplicar os parâmetros do caso corrente antes de Teste.",
  "problema": "Preparar a execução com o JSON e a identidade já definidos no registro corrente.",
  "fonte": "docs/assets/emDesenvolvimento/Runner/TDD_RUN_STARTED.pas",
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
      "Apresenta as instruções conforme FExibirInstrucoes; quando é entrada do molde/processamento, executa também a orquestração descrita abaixo.",
      "Implementação no fonte, linha 19. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure AplicarParametrosDoCasoTeste;",
      "Aplica a seção opcional de parâmetros; ausência ou objeto vazio não altera o sistema. Lê somente a seção de parâmetros da raiz e rejeita JSON ou seção inválidos.",
      "Implementação no fonte, linha 50. Operações chamadas: Copy, Create, ParseJSONValue, Assigned, ExecutarMetodoDeObjeto, if."
    ],
    [
      "function ValidarVersaoRequisito :boolean;",
      "Aceita requisito vazio; valida a versão mínima quando informada e registra incompatibilidade.",
      "Implementação no fonte, linha 103. Operações chamadas: IntToStr, if, Trim, FieldByName, VersaoSistemaIgualOuSuperior, Create."
    ],
    [
      "procedure Started;",
      "Obtém ID, descrição e JSON do registro corrente, sem carregar casos ou mover o cursor.",
      "Implementação no fonte, linha 138. Operações chamadas: Trim, or, Create, Assigned, FieldByName, RegistrarLogEmModoDebug."
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
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "A casca atual libera FLogsCasoTeste no encerramento sem atribuir nil. A reexecução no mesmo contexto permanece uma limitação conhecida; não declarar a suíte toda aprovada.",
    "O uses TDD_VALIDAR_RESULTADO em TDD_RUN_RUNNER ainda difere do arquivo P39_TDD_RUN_VALIDAR_RESULTADO. A citação documental resolve o assunto, mas não comprova que esse identificador está instalado no interpretador."
  ]
});
