import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "P39_TDD_RUN_MODULO",
  "resumo": "Abrir telas pelo evento de menu e controlar foco do formulário principal.",
  "responsabilidade": "Abrir telas pelo evento de menu e controlar foco do formulário principal.",
  "problema": "Resolver FPrincipal por operação usando o módulo já definido em P39_TDD_CASOS_DE_TESTE.",
  "fonte": "docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_MODULO.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [
    "P39_TDD_MODULO",
    "TDD_RUN_MODULO",
    "TDD_MODULO"
  ],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "irunner",
    "ordem": 7
  },
  "estados": [
    [
      "FP: TForm",
      "Referência do formulário principal.",
      "Resolvida novamente em cada operação visual; estado do formulário não pertence a esta unit."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções conforme FExibirInstrucoes; quando é entrada do molde/processamento, executa também a orquestração descrita abaixo.",
      "Implementação no fonte, linha 17. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure AbrirTela(pEventoClickMenu:String);",
      "Valida se o módulo foi informado, localiza o FPrincipal e executa dinamicamente o evento de menu recebido.",
      "Implementação no fonte, linha 39. Operações chamadas: if, or, Trim, Create, FormCriadoPeloNome, Assigned."
    ],
    [
      "procedure FocarModulo;",
      "Localiza o FPrincipal e aciona SetFocus e Repaint para garantir o foco e a atualização visual da tela.",
      "Implementação no fonte, linha 52. Operações chamadas: or, Trim, Create, FormCriadoPeloNome, Assigned, ExecutarMetodoDeObjeto."
    ],
    [
      "procedure TrazerParaFrente;",
      "Localiza o FPrincipal e executa o método BringToFront para colocar a janela do módulo em primeiro plano.",
      "Implementação no fonte, linha 66. Operações chamadas: or, Trim, Create, FormCriadoPeloNome, Assigned, ExecutarMetodoDeObjeto."
    ]
  ],
  "implementacao": [
    "AbrirTela exige FModulo e FDescModulo previamente configurados, resolve FPrincipal com FormCriadoPeloNome e executa o evento de menu recebido.",
    "FocarModulo e TrazerParaFrente resolvem FP novamente para SetFocus/Repaint e BringToFront. SetModulo e a carga do lote pertencem a P39_TDD_CASOS_DE_TESTE; não existem aqui os antigos FModuloDefinido/FMenuName redundantes."
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
