import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  tipoArtefato: 'processamento',
  nome: 'P39_TDD_PROCESSAMENTO_SINCRONIZACAO',
  navegacao: { grupo: 'helpers', subgrupo: 'sincronizacao', ordem: 2 },
  resumo: 'Entrada que seleciona a origem remota e inicia a sincronização dos casos cadastrados em código.',
  fonte: 'docs/assets/configuracoesGerais/Sincronizar/P39_TDD_PROCESSAMENTO_SINCRONIZACAO.pas',
  responsabilidade: 'Definir a origem dos conteúdos e delegar a execução para P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.',
  problema: 'Separar a entrada acionada no ERP da lista de casos e da persistência de cada registro.',
  metodos: [
    ['procedure Main', 'Configurar e disparar a sincronização.', 'Atribui True a FSincRemoto no contexto do sincronizador e chama Sincronizar. A chamada opcional ao Main de instruções está comentada.']
  ],
  implementacao: [
    'Não declara variáveis globais próprias. FSincRemoto pertence a P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS; aqui ocorre somente a atribuição.',
    'O código atual escolhe a origem remota explicitamente com True. Para escolher fontes locais, a atribuição precisa ser false antes da chamada; isso não é uma opção interativa implementada.',
    'A entrada não executa IRunner.Executar e não roda os cenários financeiros ou de faturamento. Ela cadastra os dados que poderão ser consumidos pelos testes.',
    'Não restaura o valor anterior de FSincRemoto e não captura exceções de Sincronizar.'
  ],
  dependencias: ['Uses diretos: P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS e P39_TDD_LOGS.', 'O sincronizador delega a P39_TDD_REGISTRAR_CASO_TESTE e este utiliza P39_TDD_ODBC.'],
  limites: ['Executar esta entrada pode criar módulos, áreas e casos ou solicitar confirmação de atualização no banco dedicado. Nenhuma dessas operações foi executada para produzir esta página.', 'A execução depende dos nomes cadastrados no ERP/TekStore e da configuração de conexão do ambiente.']
});
