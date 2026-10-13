import type { IDocumento } from '../../models/documentacao.ts';

import { obterBlocos } from '../historico/obterBlocos.ts';
import referencia from '../historico/parametros.ts';

export default {
  slug: 'parametros', categoria: 'documentos', titulo: 'Parâmetros do ERP', estado: 'em-uso',
  resumo: 'Preparação e aplicação do bloco parametros em Started, antes da execução de cada caso do IRunner.',
  referenciaAnterior: '/documentos/parametros-referencia-anterior',
  fontes: [
    { caminho: 'docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO.pas' },
    { caminho: 'docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO_MAPEAMENTO.pas' },
    { caminho: 'docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas' },
    { caminho: 'docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas' },
    { caminho: 'docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas' }
  ],
  secoes: [
    { id: 'papel', titulo: 'Parâmetros no fluxo atual', blocos: [
      { tipo: 'paragrafo', texto: 'P39_TDD_PARAMETRO e P39_TDD_PARAMETRO_MAPEAMENTO são dependências em uso no IRunner. Started lê parametros do JSON do caso corrente e aplica as alterações antes de chamar Teste. Não é necessário iniciar um processamento separado para cada caso.' },
      { tipo: 'paragrafo', texto: 'Os parâmetros alteram a configuração do ERP, enquanto os casos e históricos pertencem ao banco dedicado de testes. Esse mecanismo permite variar a configuração entre registros do mesmo lote.' }
    ] },
    { id: 'preparacao', titulo: 'Preparação do lote', blocos: [
      { tipo: 'mermaid', titulo: 'Inicializar o mapeamento e a leitura da configuração', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/parametros/preparacao.md' },
      { tipo: 'paragrafo', texto: 'O setup registra o mapeamento e lê a configuração da empresa atual. O dataset de parâmetros permanece disponível durante o lote; a preparação de cada caso decide quais valores precisam mudar.' }
    ] },
    { id: 'aplicacao', titulo: 'Aplicação por caso', blocos: [
      { tipo: 'mermaid', titulo: 'Do JSON até a configuração usada por Teste', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/parametros/aplicacao.md' },
      { tipo: 'paragrafo', texto: 'VerificarParametros prepara um dataset temporário com as chaves que divergem do estado atual. AtualizarParametros percorre essas diferenças, identifica campo e tabela pelo mapeamento e executa os comandos. O tempo de AplicarParametrosDoCasoTeste é registrado por Started.' }
    ] },
    { id: 'exemplo', titulo: 'Bloco parametros no JSON', nivel: 3, blocos: [
      ...obterBlocos(referencia, 'secao-7').filter(pB => pB.tipo === 'codigo'),
      { tipo: 'paragrafo', texto: 'Use chaves cadastradas em MapearParametros. O tipo do valor é inferido pelo conteúdo: string com aspas, lógico true/false, moeda com ponto decimal ou inteiro. Antes de acrescentar uma chave, confira seu campo, tabela e tipo no fonte.' }
    ] },
    { id: 'mapeamento', titulo: 'Mapeamento de chaves', nivel: 3, blocos: [
      ...obterBlocos(referencia, 'secao-5'),
      { tipo: 'paragrafo', texto: 'A tabela acima é uma referência de campos, não uma sequência de execução. O fluxo da aplicação está no diagrama anterior.' }
    ] },
    { id: 'escopo', titulo: 'Configuração global e por empresa', blocos: [
      { tipo: 'mermaid', titulo: 'Escopo do UPDATE por tabela', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/parametros/escopo.md' },
      { tipo: 'paragrafo', texto: 'Não se deve afirmar que todo UPDATE está restrito à empresa atual: CONFIG_SISTEMA é global. A configuração por empresa recebe o filtro específico das outras duas tabelas.' }
    ] },
    { id: 'falhas', titulo: 'Erros e persistência da configuração', nivel: 3, blocos: [
      { tipo: 'paragrafo', texto: 'O tratamento de AtualizarParametros relança a exceção de ExecuteCommand. Portanto uma falha de gravação propaga por Started e interrompe o lote; o erro não é silenciosamente ignorado.' },
      { tipo: 'aviso', severidade: 'warning', texto: 'Finalizar os datasets não restaura a configuração anterior do ERP. Os valores aplicados permanecem no banco. O fonte não mostra rollback automático de todos os comandos se uma alteração posterior falhar.' }
    ] },
    { id: 'reuso', titulo: 'Reutilização entre casos', blocos: [
      { tipo: 'paragrafo', texto: 'O mesmo Runner e a mesma unit Teste podem atender casos com configurações diferentes. A cada registro, Started lê o JSON corrente e reaplica somente as alterações necessárias. A limpeza do lote chama TearDown_FinalizarParametros para liberar o dataset de parâmetros.' }
    ] }
  ]
} satisfies IDocumento;
