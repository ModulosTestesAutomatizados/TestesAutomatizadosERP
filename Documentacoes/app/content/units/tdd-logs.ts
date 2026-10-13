import { criarDocumentoUnit } from './criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  nome: 'TDD_LOGS', aliases: ['P39_TDD_LOGS'], resumo: 'Registro em memória das mensagens e exibição independente de instruções.',
  fonte: 'docs/assets/emDesenvolvimento/Runner/TDD_LOGS.pas',
  responsabilidade: 'Oferecer uma forma comum de registrar mensagens do caso e apresentar instruções das units.',
  problema: 'Evita espalhar a política de debug por todos os passos e permite persistir um snapshot das mensagens junto do histórico.',
  estados: [
    ['FModoDebug: Boolean', 'Habilita adicionar mensagens à lista', 'Configurado pela entrada do processamento'],
    ['FExibirInstrucoes: Boolean', 'Habilita exibir as instruções', 'Independente de FModoDebug'],
    ['FLogsCasoTeste: TStringList', 'Acumula mensagens do caso corrente', 'Run limpa por tentativa; o lote libera a lista']
  ],
  metodos: [
    ['procedure Main', 'Apresentar a descrição dos recursos de logs.', 'Usa MostrarInstrucoesUnit com o nome TDD_LOGS.'],
    ['procedure DelimitadorLog(pTitulo: string)', 'Separar visualmente mensagens de uma etapa.', 'Monta separador, título e separador e encaminha a RegistrarLogEmModoDebug.'],
    ['procedure RegistrarLogEmModoDebug(pLog: string)', 'Adicionar uma mensagem em memória.', 'Cria FLogsCasoTeste quando necessário e só adiciona pLog + #13 quando FModoDebug está ativo.'],
    ['procedure MostrarInstrucoesUnit(pNomeUnitInstrucao, pInstrucoes: string)', 'Exibir instruções de uma unit.', 'Exige nome não vazio e chama MostrarLogTexto somente quando FExibirInstrucoes está ativo.']
  ],
  implementacao: ['Sem uses declarados no fonte.', 'Run recebe os logs da tentativa e copia o texto para o histórico antes de TDD_FINISHED.', 'O resumo do lote é produzido fora do snapshot individual já persistido.'],
  dependencias: ['Consome os recursos de TStringList e exibição disponibilizados pelo interpretador.'],
  limites: ['Mensagens com FModoDebug desativado não entram no snapshot.', 'A lista é compartilhada pelo contexto; não representa um logger isolado por thread.']
});
