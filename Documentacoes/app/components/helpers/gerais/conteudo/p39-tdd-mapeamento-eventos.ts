import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';

const documento = criarDocumentoUnit({
  nome: 'P39_TDD_MAPEAMENTO_EVENTOS', tipoArtefato: 'processamento',
  resumo: 'Coleta manual de Evento, Form e Caption de menu para o catálogo de P39_TDD_RUN_APPLICATION.',
  responsabilidade: 'Comparar os Forms abertos antes e depois de um evento escolhido e apresentar candidatos ao DE → PARA de telas.',
  problema: 'O Caption amigável do menu pode diferir do título do Form e do nome do handler. O helper auxilia o levantamento; a revisão dos vínculos continua necessária.',
  fonte: 'docs/assets/snippets/P39_TDD_MAPEAMENTO_EVENTOS.pas', estado: 'em-desenvolvimento',
  navegacao: { grupo: 'helpers', subgrupo: 'gerais', ordem: 1 },
  estados: [
    ['FP: TForm / RE: TRichEdit', 'Referências emprestadas do principal e de RichEdit1.', 'Resolvidas no início; não são destruídas. O texto do RichEdit é restaurado no finally.'],
    ['FFormsAbertos, FFormsAntes: TStringList', 'Listagem corrente e nomes presentes antes da coleta.', 'Criadas por Main e liberadas no finally.'],
    ['FCaptionMenu: string', 'Caption lido do componente de menu selecionado.', 'Usado nas linhas candidatas desta execução.'],
    ['CDS: TClientDataSet', 'Colunas EVENTO, FORM e CAPTION.', 'Criado por Main, exibido por MostrarCDS e liberado no finally.']
  ],
  metodos: [
    ['procedure Main;', 'Executar uma coleta manual.', 'Valida principal, componente de menu e RichEdit1; captura a listagem anterior, chama somente cEvento, compara Forms e apresenta os candidatos.'],
    ['procedure ListarFormsAbertos;', 'Consultar o diagnóstico de Forms do principal.', 'Invoca ListarFormulriosAbertos1Click e copia RichEdit1.Lines para a lista de trabalho. Esse método de diagnóstico também é executado durante a coleta.'],
    ['procedure PegarConfiguracoesForm(pMetodo :string);', 'Registrar candidatos novos.', 'Descarta nomes anteriores, principal e datamodules; usa FCaptionMenu em vez de Form.Caption. Fecha somente Forms novos identificados, sem Free.']
  ],
  implementacao: [
    'Configure cEvento e cComponenteMenu no molde antes de executar no módulo desejado. Receber1Click foi informado pelo usuário; o nome do componente Receber1 deve ser conferido no ambiente.',
    'O helper realmente executa o evento selecionado: use ambiente isolado de testes e escolha um evento de abertura conhecido. Não executa todos os resultados de MetodosDeObjeto.',
    'CAPTION mantém o texto real do menu, inclusive & de atalhos. AbrirTela normaliza esse marcador ao procurar o alias.',
    'Transcreva somente linhas revisadas para TDD_RUN_APPLICATION_MAPEAMENTO_JSON: módulo → nome do Form → caption e evento. O helper não publica nem altera esse arquivo automaticamente.',
    'A fonte canônica copiável está abaixo; não existe outra cópia editável do processamento no portal.'
  ],
  dependencias: ['APIs do host: FormCriadoPeloNome, ValorPropriedadeDeObjeto, ExecutarMetodoDeObjeto, CorteEntre e MostrarCDS.'],
  limites: [
    'Execução e correlação nativas ainda não homologadas. Testes locais substituem APIs e não comprovam o funcionamento de menus do ERP.',
    'A extração do nome depende do formato de ListarFormulriosAbertos1Click: texto entre hífen e parêntese. Confira a listagem do ambiente.',
    'Tela já aberta antes da coleta não gera uma nova linha. Nenhum Form novo pode significar reutilização ou mudança no formato da listagem.',
    'Um evento pode abrir múltiplas janelas ou diálogos. As linhas são candidatos a revisão; a coleta não prova que todas as janelas correspondem ao item de menu.',
    'Fechar uma janela pode executar lógica do ERP. O helper não promete ausência de efeitos internos do evento escolhido e não deve ser incorporado à execução automática do IRunner.'
  ]
});
documento.fontes.push({ caminho: 'docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_APPLICATION_MAPEAMENTO_JSON.json' });
documento.secoes.push({ id: 'molde', titulo: 'Processamento copiável', blocos: [
  { tipo: 'codigo-fonte', fonte: 'docs/assets/snippets/P39_TDD_MAPEAMENTO_EVENTOS.pas', linguagem: 'pascal' }
] });
export default documento;
