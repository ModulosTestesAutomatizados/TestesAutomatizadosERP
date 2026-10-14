import { criarDocumentoUnit } from './criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  navegacao: { grupo: 'units', subgrupo: 'irunner' },
  nome: 'P39_TDD_STARTED', resumo: 'Preparação do caso corrente: identidade, versão e parâmetros.',
  fonte: 'docs/assets/emDesenvolvimento/Runner/P39_TDD_STARTED.pas',
  responsabilidade: 'Preparar os dados usados pela unit Teste depois que Run define o contexto da tentativa.',
  problema: 'Garante que o Teste receba o JSON e a configuração do registro corrente, com validação de versão antes de executar as operações de negócio.',
  estados: [
    ['FCasoTesteAtualId: integer', 'ID do registro corrente', 'Reiniciado por tentativa e preenchido por Started'],
    ['FCasoTesteAtualJson: string', 'Entrada consumida pelo Teste e pela aplicação de parâmetros', 'Reiniciada por tentativa e preenchida por Started']
  ],
  metodos: [
    ['procedure Main', 'Exibir instruções.', 'Usa MostrarInstrucoesUnit conforme FExibirInstrucoes.'],
    ['procedure Started', 'Preparar o registro corrente.', 'Valida contexto e dataset, obtém ID/JSON/descrição e chama ValidarVersaoRequisito e AplicarParametrosDoCasoTeste com medição de tempo. Não carrega o lote nem move o cursor.'],
    ['function ValidarVersaoRequisito: Boolean', 'Exigir versão igual ou superior quando há requisito.', 'Requisito vazio é aceito. Preenche versão no histórico e, se incompatível, marca VERSAO_INCOMPATIVEL e levanta exceção.'],
    ['procedure AplicarParametrosDoCasoTeste', 'Aplicar o bloco parametros do JSON corrente.', 'Ignora blocos vazios, faz parse e chama P39_TDD_PARAMETROS.VerificarParametros. Libera o objeto JSON no finally.']
  ],
  implementacao: ['Lê CDSCasosTestes e escreve o contexto e histórico compartilhados de P39_TDD_RUNNER.', 'A preparação é chamada uma vez por Run; o lote já foi carregado no setup.', 'A aplicação dos parâmetros acontece depois da verificação de versão.'],
  dependencias: ['Uses direto: P39_TDD_CASOS_DE_TESTE.', 'Recebe PARAMETRO, CACHE, ODBC, JSON e CONSTANTES por herança de uses.'],
  limites: ['Erros de preparação propagam; a casca decide se pode continuar.', 'Não restaura valores antigos dos parâmetros ao terminar.']
});
