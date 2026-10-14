import type { IDocumento } from '../../models/documentacao.ts';

import referencia from '../historico/casos-de-teste.ts';
import { obterBlocos } from '../historico/obterBlocos.ts';

export default {
  slug: 'casos-de-teste', categoria: 'documentos', titulo: 'Casos de teste', estado: 'em-uso',
  resumo: 'Como os registros do banco dedicado alimentam o lote do IRunner e o contexto de cada execução.',
  referenciaAnterior: '/documentos/casos-de-teste-referencia-anterior',
  fontes: [
    { caminho: 'docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas' },
    { caminho: 'docs/assets/configuracoesGerais/sincronizar/persistenciasODBC/P39_TDD_REGISTRAR_CASO_TESTE.pas' },
    { caminho: 'docs/assets/configuracoesGerais/sincronizar/persistenciasODBC/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas' },
    { caminho: 'docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas' },
    { caminho: 'docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas' },
    { caminho: 'docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas' },
    { caminho: 'docs/MER.md' }
  ],
  secoes: [
    { id: 'conceito', titulo: 'O caso de teste no IRunner', blocos: [
      { tipo: 'paragrafo', texto: 'Um caso de teste reúne identificação, entrada JSON, requisito de versão e dados de referência no banco dedicado. A unit P39_TDD_CASOS_DE_TESTE está em uso no fluxo atual: é herdada por TDD_STARTED e disponibiliza os datasets usados pelo Runner.' },
      { tipo: 'paragrafo', texto: 'No contrato por lote, módulo e área selecionam os casos ativos. A descrição vem de cada registro corrente; o ID liga o caso ao histórico. A unit Teste não precisa informar a descrição de um cenário nem carregar ou avançar o lote.' }
    ] },
    { id: 'cadastro', titulo: 'Do cadastro à execução', blocos: [
      { tipo: 'mermaid', titulo: 'Preparar dados e iniciar o lote', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/casos-de-teste/cadastro.md' },
      { tipo: 'paragrafo', texto: 'O cadastro e a sincronização são preparação dos dados; não acontecem a cada Run. SetupCasosTestes configura módulo e área e carrega o conjunto uma vez. A validação dos nomes usa o cache para obter os códigos internos.' }
    ] },
    { id: 'registro', titulo: 'Registro no banco dedicado', nivel: 3, blocos: [
      ...obterBlocos(referencia, 'secao-3'),
      { tipo: 'paragrafo', texto: 'CASO_TESTE_CT guarda a entrada do cenário. RESULTADO_ESPERADO_CT e os demais dados de referência são preparados para as comparações do caso; a existência desses dados não significa que a etapa TDD_ASSERTS já esteja implementada no novo Runner.' }
    ] },
    { id: 'datasets', titulo: 'Carga dos datasets', blocos: [
      { tipo: 'mermaid', titulo: 'Da seleção ao estado compartilhado', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/casos-de-teste/datasets.md' },
      { tipo: 'paragrafo', texto: 'Os datasets são indexados por ID. O preenchimento inicial define EXECUTADO e COMPARADO como N; o fluxo atual de Run não deve ser descrito como responsável por marcar automaticamente esses campos como S. O resultado da tentativa é registrado em FHistoricoExecucao e persistido por Finished.' }
    ] },
    { id: 'cursor', titulo: 'Quem controla o cursor', nivel: 3, blocos: [
      { tipo: 'paragrafo', texto: 'ExecutarLote, no molde, é o dono de First e Next. Run usa o registro corrente; Started obtém ID, descrição, requisito e JSON sem mover o cursor. Ao terminar uma tentativa que permite continuidade, o molde avança para o próximo registro.' },
      { tipo: 'codigo', linguagem: 'pascal', codigo: 'SetupCasosTestes(pDescricaoModulo, pDescricaoArea);\nCDSCasosTestes.First;\nwhile not CDSCasosTestes.Eof do\nbegin\n  Run;\n  CDSCasosTestes.Next;\nend;' }
    ] },
    { id: 'entrada', titulo: 'Entrada e resultado esperado', blocos: [
      { tipo: 'paragrafo', texto: 'Cada módulo define o conteúdo consumido por sua unit Teste. Documento Fatura trabalha com blocos de documento e itens; o piloto financeiro lê tags como EMPRESA_DUP, TIPODOC_DUP, PESSOA_DUP e VALOR_DUP. O bloco parametros é preparado por Started antes do Teste.' },
      { tipo: 'aviso', severidade: 'info', texto: 'Casos de teste é uma dependência em uso no IRunner. Isso descreve a integração atual, não uma homologação funcional. TDD_ASSERTS e sua persistência continuam pendentes.' }
    ] },
    { id: 'encerramento', titulo: 'Encerramento do lote', blocos: [
      { tipo: 'paragrafo', texto: 'A limpeza do molde encerra métricas, parâmetros, cache, datasets de casos e logs. TearDown_Finalizar_CasosTeste tenta liberar os quatro datasets e agrega erros de liberação; FEstruturaCasoTesteIniciada volta para False. Falhas de limpeza propagam para o chamador.' }
    ] }
  ]
} satisfies IDocumento;
