import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  nome: 'P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS',
  navegacao: { grupo: 'helpers', subgrupo: 'sincronizacao', ordem: 1 },
  resumo: 'Mantém a seleção local/remota e a lista de casos enviados ao registrador.',
  fonte: 'docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas',
  responsabilidade: 'Percorrer as chamadas de registro definidas em código e apresentar feedback do processo de sincronização.',
  problema: 'Concentrar a relação de casos e o ambiente de origem sem reproduzir o SQL de cadastro.',
  estados: [
    ['FSincRemoto: Boolean', 'Seleciona leitura remota quando true; false seleciona os nomes locais.', 'Declarado nesta unit e consumido por Sincronizar. O fonte não o inicializa explicitamente nem o restaura ao encerrar. P39_TDD_PROCESSAMENTO_SINCRONIZACAO atribui True antes de chamar Sincronizar.']
  ],
  metodos: [
    ['procedure Main', 'Mostrar as instruções do sincronizador.', 'Chama MostrarInstrucoesUnit com o contrato de FSincRemoto e das duas rotinas de sincronização. Não chama Sincronizar.'],
    ['procedure Sincronizar', 'Executar a lista com feedback visual.', 'Abre o callback, informa o carregamento e chama RegistrosCasosTestes(FSincRemoto). Fecha a tela de callback em finally. Depois apresenta a mensagem de conclusão; uma exceção propaga e impede essa mensagem.'],
    ['procedure RegistrosCasosTestes(pSincRemoto: boolean)', 'Definir e registrar os quatro casos atuais.', 'Chama P39_TDD_REGISTRAR_CASO_TESTE.RegistrarCasoTeste em sequência para Financeiro e três cenários de pedido de venda. Encaminha pSincRemoto para cada chamada. Os nomes das units JSON são informados sem o prefixo remoto.']
  ],
  implementacao: [
    'A lista atual contém TDD_FINANCEIRO com requisito 160.00 e três pedidos: desconto percentual, unidade fabril e sequência nos itens.',
    'Os pedidos usam TDD_JSON_BASE_RESULTADO_ESPERADO. Campos disponíveis são informados como nome vazio nos quatro registros e se tornam {} no registrador.',
    'O formato de requisito de versão xxx.yy aparece nas instruções. A lista usa string vazia nos três pedidos; o sincronizador não valida esse formato.',
    'cPrefixoSincRemoto é acrescentado somente por CarregarConteudoUnit no registrador; não altere os nomes JSON da lista para repetir esse prefixo.',
    'A mensagem final não distingue inserts, updates confirmados e updates recusados. Recusar um update permite continuar a lista; uma exceção interrompe as chamadas restantes.',
    'FSincRemoto continua com o último valor atribuído. Não há transação global nem reversão dos casos já sincronizados.'
  ],
  dependencias: ['Uses direto: P39_TDD_REGISTRAR_CASO_TESTE, que resolve JSONs e persistência via P39_TDD_ODBC.', 'CallBack_AbreTela, CallBack_Mensagem, CallBack_FechaTela e ClassOwner são recursos do host ERP.', 'P39_TDD_PROCESSAMENTO_SINCRONIZACAO configura o estado e inicia a execução.'],
  limites: ['A lista é explícita no Pascal; esta documentação não adiciona nem sincroniza registros.', 'Não há isolamento de FSincRemoto entre execuções no mesmo contexto.', 'A disponibilidade das units JSON e os nomes cadastrados no ERP/TekStore exigem validação no ambiente de execução.']
});
