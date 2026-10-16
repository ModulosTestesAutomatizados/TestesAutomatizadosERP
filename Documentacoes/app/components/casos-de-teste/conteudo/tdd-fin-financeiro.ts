import { criarDocumentoUnit } from '../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "TDD_FIN_FINANCEIRO",
  "resumo": "Executar duplicata receber/pagar e borderô receber/pagar para o registro corrente.",
  "responsabilidade": "Executar duplicata receber/pagar e borderô receber/pagar para o registro corrente.",
  "problema": "Exercitar o financeiro com captura de dados antes do fechamento e deixar a comparação para ASSERTS.",
  "fonte": "docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO.pas",
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
      "Apresenta as instruções conforme FExibirInstrucoes; quando é entrada do molde/processamento, executa também a orquestração descrita abaixo.",
      "Implementação no fonte, linha 13. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure ValidarCasoTeste;",
      "Validação específica do financeiro; usa o JSON preparado por Started sem carregar casos. EMPRESA_DUP deve corresponder à empresa atual; TIPODOC_DUP mantém a validação existente. PESSOA_DUP, VALOR_DUP, GRUPORESULTADO_DUPGR e CONTA_BORD não usam configuração padrão. QUALIFICACAO_DUP, PESSOANOTACREDITO_BORD e PRAZOVENCIMENTO_DUP continuam opcionais.",
      "Implementação no fonte, linha 45. Operações chamadas: ValorInteiroTag, ValorCurrencyTag, Create."
    ],
    [
      "procedure Teste;",
      "Valida o JSON e executa duplicata receber, duplicata pagar, borderô receber e borderô pagar.",
      "Implementação no fonte, linha 79. Operações chamadas: _IncluirDuplicata, Create, _IncluirBordero, DelimitadorLog, RegistrarTick."
    ],
    [
      "procedure _IncluirDuplicata(pTipo: Integer);",
      "Tipo 0: duplicata receber. Tipo 1: duplicata pagar.",
      "Implementação no fonte, linha 106. Operações chamadas: FormCriadoPeloNome, CriarFormPeloNome, Create, DMCriadoPeloNome, FindComponent, ValorInteiroTag."
    ],
    [
      "procedure _IncluirBordero(pTipo: Integer);",
      "Tipo 0: recebimento. Tipo 1: pagamento, incluindo a seleção da pessoa. Mantém os mapeamentos, filtros, totalização e gravação próprios de cada tipo.",
      "Implementação no fonte, linha 175. Operações chamadas: ValorInteiroTag, FieldByName, Create, IntToStr, RegistrarDataSet, FormCriadoPeloNome."
    ],
    [
      "procedure TearDown_DestruirObjetos;",
      "Declarada no final; cancela edições e fecha telas sem destruir CDS compartilhados.",
      "Implementação no fonte, linha 336. Operações chamadas: Assigned, DMCriadoPeloNome, FindComponent, if, or."
    ]
  ],
  "implementacao": [
    "ValidarCasoTeste exige a empresa corrente e os dados financeiros do JSON preparado por Started. Não recarrega casos nem move o cursor do lote.",
    "Teste executa quatro operações: duplicata receber, duplicata pagar, borderô receber e borderô pagar. Captura CDSCadastro por DataSet|DM depois de gravar e antes de TearDown_DestruirObjetos.",
    "O finally marca FNomeMetodoAtual como TEARDOWN e fecha recursos financeiros/cancela edições pendentes. CDS compartilhados continuam pertencendo ao lote. ASSERTS é executado pela casca após o retorno do Teste."
  ],
  "dependencias": [
    "P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO: cláusula uses do fonte.",
    "P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "A casca atual libera FLogsCasoTeste no encerramento sem atribuir nil. A reexecução no mesmo contexto permanece uma limitação conhecida; não declarar a suíte toda aprovada.",
    "O uses TDD_VALIDAR_RESULTADO em TDD_RUN_RUNNER ainda difere do arquivo P39_TDD_RUN_VALIDAR_RESULTADO. A citação documental resolve o assunto, mas não comprova que esse identificador está instalado no interpretador."
  ]
});
