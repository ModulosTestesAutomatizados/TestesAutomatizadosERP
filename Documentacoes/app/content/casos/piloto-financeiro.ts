import type { IDocumento } from '../../models/documentacao.ts';
export default {
  slug: 'piloto-financeiro', categoria: 'documentos', titulo: 'Piloto financeiro com IRunner',
  resumo: 'Validação, quatro operações financeiras e limpeza por registro em REFACTOR_TDD_FINANCEIRO_PILOTO.',
  navegacao: { grupo: 'casos', subgrupo: 'irunner', ordem: 1 }, estado: 'em-desenvolvimento',
  fontes: [
    'docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas',
    'docs/assets/emDesenvolvimento/Runner/P39_PROCESSAMENTO_TDD_FINANCEIRO.pas',
    'docs/assets/casosTestesFinanceiro/P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.pas',
    'docs/assets/casosTestesFinanceiro/P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.pas',
    'docs/MAPEAMENTO_AST_USES_UNITS/piloto-financeiro/teste.md'
    ,'docs/MAPEAMENTO_AST_USES_UNITS/piloto-financeiro/dependencias.md'
  ].map(pCaminho => ({ caminho: pCaminho })),
  secoes: [
    { id: 'contrato', titulo: 'Contrato da entrada Teste', blocos: [
      { tipo: 'paragrafo', texto: 'REFACTOR_TDD_FINANCEIRO_PILOTO fornece procedure Teste sem parâmetros. TDD_STARTED já preparou FCasoTesteAtualJson e aplicou os parâmetros. A unit valida os dados específicos de Financeiro e executa as quatro operações sequencialmente. Main apenas apresenta instruções; a casca chama Teste.' },
      { tipo: 'mermaid', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/piloto-financeiro/teste.md', titulo: 'Sequência do piloto e limpeza obrigatória' }
    ] },
    { id: 'json', titulo: 'Dados obrigatórios e opcionais', blocos: [
      { tipo: 'lista', itens: [
        'EMPRESA_DUP e TIPODOC_DUP: ValidarCasoTeste exige valores positivos. As instruções do fonte pedem correspondência com a empresa atual, mas essa comparação não está implementada na validação disponível.',
        'PESSOA_DUP, VALOR_DUP, GRUPORESULTADO_DUPGR e CONTA_BORD: ausência, valor inválido ou zero geram erro de validação.',
        'QUALIFICACAO_DUP, PESSOANOTACREDITO_BORD e PRAZOVENCIMENTO_DUP continuam opcionais conforme as leituras do piloto.',
        'FCasoTesteInvalido e FMsgCasoTesteInvalido são redefinidos por ValidarCasoTeste. A mensagem agrega problemas de entrada antes de levantar a exceção.'
      ] }
    ] },
    { id: 'operacoes', titulo: 'Operações executadas por registro', blocos: [
      { tipo: 'lista', itens: [
        '_IncluirDuplicata(0): inclusão da duplicata a receber.',
        '_IncluirDuplicata(1): inclusão da duplicata a pagar.',
        '_IncluirBordero(0): inclusão do borderô de recebimento.',
        '_IncluirBordero(1): inclusão do borderô de pagamento, incluindo a seleção da pessoa.'
      ] },
      { tipo: 'paragrafo', texto: 'As chamadas usam os mapeamentos de componentes para abrir telas, aplicar filtros, totalizar e gravar. Falhas recebem o nome da operação no texto da exceção e interrompem as operações seguintes daquele registro.' }
    ] },
    { id: 'dependencias', titulo: 'Dependências e contexto do piloto', blocos: [
      { tipo: 'mermaid', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/piloto-financeiro/dependencias.md', titulo: 'Uses, montagem dinâmica e estado compartilhado' },
      { tipo: 'paragrafo', texto: 'O processamento usa TDD_IRUNNER diretamente. O molde é carregado por CodificacaoUnit e passa a usar a unit de cenário definida em SetTDDUnit. O piloto declara os dois mapeamentos financeiros; JSON, logs e estado do registro corrente chegam pelo contexto compartilhado do host.' }
    ] },
    { id: 'limpeza', titulo: 'Limpeza, continuidade e métricas', blocos: [
      { tipo: 'paragrafo', texto: 'O finally de Teste marca FNomeMetodoAtual como TEARDOWN, inicia o tick e chama TearDown_DestruirObjetos. A limpeza cancela edições e fecha telas sem destruir os datasets compartilhados. A casca distingue falha de teste de falha de limpeza: TEARDOWN com erro interrompe o lote.' },
      { tipo: 'paragrafo', texto: 'TDD_RUNNER mantém os tempos e o histórico por tentativa. TDD_FINISHED persiste a execução e TDD_LOGS registra diagnósticos conforme FModoDebug. O controle de First/Next e a liberação dos datasets do lote pertencem a TDD_BASE_UNIT_IRUNNER.' },
      { tipo: 'aviso', severidade: 'warning', texto: 'Não há etapa implementada de comparação funcional por TDD_ASSERTS. A documentação do piloto descreve o caminho atual do fonte e não declara homologação no ERP.' }
    ] }
  ]
} satisfies IDocumento;
