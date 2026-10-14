import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  navegacao: { grupo: 'casos', ordem: 1 },
  nome: 'P39_TDD_FIN_PAGAMENTO_RECEBIMENTO', estado: 'em-desenvolvimento',
  resumo: 'Caso financeiro que valida o registro corrente e executa duplicatas e borderôs na casca IRunner.',
  fonte: 'docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas',
  responsabilidade: 'Executar quatro operações financeiras para o registro preparado por P39_TDD_STARTED, sem carregar nem avançar o cursor de casos.',
  problema: 'Concentrar o cenário financeiro por registro e reutilizar o contexto global do IRunner, preservando a limpeza das telas após sucesso ou erro.',
  jsonBase: {
    fontes: ['docs/assets/emDesenvolvimento/Runner/P39_TDD_STARTED.pas'],
    exemplo: {
      EMPRESA_DUP: 0, TIPODOC_DUP: 0, PESSOA_DUP: 0, VALOR_DUP: 100,
      GRUPORESULTADO_DUPGR: 0, CONTA_BORD: 0, QUALIFICACAO_DUP: 0,
      PRAZOVENCIMENTO_DUP: 30, PESSOANOTACREDITO_BORD: 0, parametros: {}
    },
    campos: [
      ['$', 'objeto', 'Dados financeiros do registro CASOTESTE.', 'P39_TDD_STARTED entrega este objeto em FCasoTesteAtualJson; os campos financeiros ficam na raiz.'],
      ['EMPRESA_DUP', 'inteiro', 'Empresa usada na inclusão da duplicata.', 'ValidarCasoTeste exige valor positivo; a correspondência com a empresa atual é indicada nas instruções, mas não comparada nesta validação.'],
      ['TIPODOC_DUP', 'inteiro', 'Tipo de documento da duplicata.', 'Deve ser positivo; é informado no cadastro das duplicatas.'],
      ['PESSOA_DUP', 'inteiro', 'Pessoa do documento financeiro.', 'Zero ou ausência interrompem a validação; também participa dos filtros e da seleção de fornecedor.'],
      ['VALOR_DUP', 'número', 'Valor das duplicatas.', 'Zero ou ausência geram erro; o mesmo registro alimenta as operações financeiras.'],
      ['GRUPORESULTADO_DUPGR', 'inteiro', 'Grupo de resultado financeiro.', 'Zero ou ausência geram erro; compõe os dados da duplicata.'],
      ['CONTA_BORD', 'inteiro', 'Conta financeira dos borderôs.', 'Zero ou ausência geram erro; é atribuída ao cadastro e aos complementos dos borderôs.'],
      ['QUALIFICACAO_DUP', 'inteiro', 'Qualificação da duplicata.', 'Opcional; a leitura usa zero quando não informado.'],
      ['PRAZOVENCIMENTO_DUP', 'inteiro', 'Prazo em dias para vencimento.', 'Opcional; a inclusão calcula o vencimento a partir do prazo lido, com padrão zero.'],
      ['PESSOANOTACREDITO_BORD', 'inteiro', 'Pessoa da nota de crédito no pagamento.', 'Opcional; orienta o preenchimento correspondente no borderô de pagamento.'],
      ['parametros', 'objeto', 'Ajustes de configuração anteriores ao cenário.', 'Consumido por P39_TDD_STARTED e P39_TDD_PARAMETROS, antes da chamada Teste; vazio não solicita ajustes.']
    ],
    observacoes: [
      'Os identificadores zero são espaços de preenchimento. Substitua-os por códigos existentes na base de testes antes de executar; o modelo ainda vazio é rejeitado por ValidarCasoTeste.',
      'O valor e o prazo são ilustrativos; não representam um caso homologado. Não acrescente um objeto financeiro ao redor dos campos: este piloto lê as tags diretamente da raiz.',
      'A comparação funcional por TDD_ASSERTS continua pendente.'
    ]
  },
  estados: [
    ['FCasoTesteInvalido: Boolean', 'Indica problemas específicos dos dados financeiros.', 'Redefinido por ValidarCasoTeste em cada chamada.'],
    ['FMsgCasoTesteInvalido: String', 'Agrega os erros de validação das tags.', 'Limpo e recomposto antes de levantar a exceção.']
  ],
  metodos: [
    ['procedure Teste', 'Executar o cenário do registro corrente.', 'Valida o JSON e executa duplicata a receber, a pagar, borderô de recebimento e de pagamento, com teardown em finally.'],
    ['procedure ValidarCasoTeste', 'Validar as tags consumidas pelo piloto.', 'Lê FCasoTesteAtualJson e agrega os campos ausentes, inválidos ou zerados antes de lançar erro.'],
    ['procedure TearDown_DestruirObjetos', 'Encerrar os recursos financeiros utilizados.', 'Cancela edições e fecha as telas; os datasets compartilhados do lote não pertencem ao piloto.']
  ],
  implementacao: ['O cursor e a liberação dos artefatos compartilhados pertencem a P39_TDD_BASE_UNIT_IRUNNER.', 'Cada operação possui registro de tempo no contexto de P39_TDD_RUNNER; o teardown é executado mesmo quando uma operação falha.'],
  dependencias: ['P39_TDD_STARTED prepara o caso e seus parâmetros.', 'P39_TDD_FIN_BORDERO_RECEBIMENTO e P39_TDD_FIN_BORDERO_PAGAMENTO fornecem o acesso às telas.'],
  limites: ['O fonte é de desenvolvimento, sem evidência de homologação no ERP.']
});
