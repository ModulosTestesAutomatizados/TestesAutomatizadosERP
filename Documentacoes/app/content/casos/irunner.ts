import type { IDocumento } from '../../models/documentacao.ts';
export default {
  slug: 'casos-irunner', categoria: 'documentos', titulo: 'Casos de teste — IRunner',
  resumo: 'Inventário do piloto financeiro e contrato de execução de registros por módulo e área no fluxo novo.',
  navegacao: { grupo: 'casos', subgrupo: 'irunner', ordem: 0 }, estado: 'em-desenvolvimento',
  fontes: [
    'docs/assets/emDesenvolvimento/Runner/P39_TDD_FIN_PROCESSAMENTO.pas',
    'docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas',
    'docs/assets/emDesenvolvimento/Runner/P39_TDD_BASE_UNIT_IRUNNER.pas',
    'docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas',
    'docs/MAPEAMENTO_AST_USES_UNITS/casos-irunner/lote.md'
  ].map(pCaminho => ({ caminho: pCaminho })),
  secoes: [
    { id: 'inventario', titulo: 'Casos disponíveis no fluxo novo', blocos: [
      { tipo: 'paragrafo', texto: 'O fonte P39_TDD_FIN_PROCESSAMENTO configura P39_TDD_FIN_PAGAMENTO_RECEBIMENTO e os literais FINANCEIRO/FINANCEIRO. Essa é a entrada de cenário integrada ao novo contrato presente nos fontes de referência. O inventário descreve o código disponível; a quantidade de registros ativos cadastrados no banco varia por ambiente.' },
      { tipo: 'lista', itens: [
        'Unit de cenário: P39_TDD_FIN_PAGAMENTO_RECEBIMENTO, entrada procedure Teste sem parâmetros.',
        'Para cada registro: validar o JSON, incluir duplicata a receber, incluir duplicata a pagar, incluir borderô de recebimento e incluir borderô de pagamento.',
        'Os dados do cenário vêm de FCasoTesteAtualJson, preparado por P39_TDD_STARTED. A mesma unit é reutilizada para diferentes registros do lote.',
        'O piloto encerra com TearDown_DestruirObjetos. Resultados e comparações de asserts permanecem pendentes nesta iteração.'
      ] }
    ] },
    { id: 'lote', titulo: 'Da configuração ao registro corrente', blocos: [
      { tipo: 'mermaid', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/casos-irunner/lote.md', titulo: 'Entrada do processamento e execução por registro' },
      { tipo: 'paragrafo', texto: 'P39_TDD_IRUNNER monta o código do P39_TDD_BASE_UNIT_IRUNNER. O molde chama SetupCasosTestes uma vez e percorre CDSCasosTestes com First, Run e Next. P39_TDD_STARTED lê o registro corrente, verifica a versão e aplica parâmetros antes da chamada Teste.' }
    ] },
    { id: 'entrada', titulo: 'Configurar uma unit de cenário', blocos: [
      { tipo: 'codigo', linguagem: 'pascal', codigo: "SetTDDUnit('P39_TDD_FIN_PAGAMENTO_RECEBIMENTO');\nAddParamsRun('''FINANCEIRO''');\nAddParamsRun('''FINANCEIRO''');\nExecutar;" },
      { tipo: 'paragrafo', texto: 'Os dois AddParamsRun contêm literais Pascal: módulo e área, nessa ordem. A unit configurada deve fornecer Teste sem parâmetros e operar sobre o contexto do caso corrente. Ela não deve recarregar o lote nem avançar CDSCasosTestes.' }
    ] },
    { id: 'registros', titulo: 'Cadastro e estados compartilhados', blocos: [
      { tipo: 'paragrafo', texto: 'P39_TDD_CASOS_DE_TESTE mantém os datasets e a seleção por módulo/área. O carregamento considera registros ativos. O requisito de versão pode impedir uma tentativa; o JSON do registro fornece dados e o bloco parametros. As páginas Casos de teste e Parâmetros do ERP detalham esses contratos de cadastro e preparação.' },
      { tipo: 'paragrafo', texto: 'P39_TDD_RUNNER reinicia FHistoricoExecucao, o contexto, a etapa e as métricas por tentativa. A casca limpa FLogsCasoTeste, mantida por P39_TDD_LOGS, antes de cada caso; P39_TDD_FINISHED persiste histórico e tempos. O encerramento do lote libera os artefatos compartilhados.' }
    ] },
    { id: 'limites', titulo: 'Status e limites do inventário', blocos: [
      { tipo: 'aviso', severidade: 'warning', texto: 'TDD_ASSERTS e a persistência das métricas de asserts estão pendentes. SUCESSO representa o encerramento sem exceção do caminho implementado. O inventário não afirma homologação nem conversão dos cenários anteriores de faturamento para o contrato Teste.' },
      { tipo: 'paragrafo', texto: 'EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR é uma referência de código interpretado; não representa uma segunda unit de cenário configurada pelo processamento atual. Novos cenários precisam ser cadastrados e documentados com sua própria entrada e fontes.' }
    ] }
  ]
} satisfies IDocumento;
