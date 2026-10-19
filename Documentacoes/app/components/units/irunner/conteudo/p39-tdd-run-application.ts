import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';

const documento = criarDocumentoUnit({
  nome: 'P39_TDD_RUN_APPLICATION', aliases: ['TDD_RUN_APPLICATION', 'P39_TDD_RUN_MODULO', 'TDD_RUN_MODULO', 'P39_TDD_MODULO', 'TDD_MODULO'],
  resumo: 'Abrir telas por Caption, Form ou evento e controlar o principal da aplicação.',
  responsabilidade: 'Resolver os aliases de telas do módulo corrente e apresentar o Form correspondente, reutilizando instâncias existentes.',
  problema: 'Permitir AbrirTela com um título amigável sem exigir que o autor do teste memorize os handlers dos menus.',
  fonte: 'docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_APPLICATION.pas',
  estado: 'em-desenvolvimento', navegacao: { grupo: 'units', subgrupo: 'irunner', ordem: 7 },
  estados: [['FP: TForm', 'Referência emprestada ao FPrincipal.', 'Resolvida por operação; a unit não destrói o principal. FModulo e FDescModulo pertencem a P39_TDD_CASOS_DE_TESTE.']],
  metodos: [
    ['procedure Main;', 'Apresentar instruções.', 'Usa MostrarInstrucoesUnit conforme FExibirInstrucoes. Não abre telas.'],
    ['procedure AbrirTela(pTela :string);', 'Abrir ou reutilizar a tela indicada.', 'Eventos encontrados por MetodosDeObjeto mantêm o caminho direto, mesmo sem sufixo Click. Caption e Form são procurados no catálogo do módulo. Se a entrada tem evento, ele é priorizado; sem evento, cria-se o Form registrado. Uma instância já aberta é exibida sem nova abertura.'],
    ['procedure FocarModulo;', 'Focar e atualizar o principal.', 'Valida o contexto e resolve FPrincipal antes de SetFocus e Repaint, omitindo o argumento opcional de parâmetros.'],
    ['procedure TrazerParaFrente;', 'Trazer o principal à frente.', 'Valida contexto e principal antes de BringToFront, sem array vazio.']
  ],
  implementacao: [
    'Catálogo canônico versionado: docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_APPLICATION_MAPEAMENTO_JSON.json; cadastrar esse conteúdo na unit remota P39_TDD_RUN_APPLICATION_MAPEAMENTO_JSON.',
    'Estrutura: módulo → nome do Form → caption e evento, ambos strings. Caption ou evento vazios não criam aliases. Evento vazio seleciona a abertura direta pelo Form conhecido.',
    'A comparação de módulo e aliases ignora caixa e espaços externos; captions também desconsideram & de atalhos. Acentos permanecem significativos. O catálogo é lido por chamada e seus objetos JSON são liberados no finally.',
    'O vínculo Contas a Receber → FCadReceber → Receber1Click foi informado pelo usuário. Os demais Forms financeiros estão cadastrados sem Caption ou Evento presumidos.',
    'Quando precisa abrir, registra destino, traz o principal à frente e aplica foco antes do evento/criação. O foco dos campos específicos continua pertencendo ao teste.',
    'P39_TDD_RUN_MODULO é nome anterior para busca e redirecionamento. O uses executável passa a consumir TDD_RUN_APPLICATION; não existe wrapper Pascal com o nome antigo.'
  ],
  dependencias: ['P39_TDD_CASOS_DE_TESTE e seu contexto herdado.', 'Carga dinâmica de P39_TDD_RUN_APPLICATION_MAPEAMENTO_JSON; não é um uses Pascal.', 'TDD_MAPEAMENTO_EVENTOS auxilia a coleta manual; não é chamado por AbrirTela.'],
  limites: ['Cadastro remoto e comportamento no ERP precisam de validação própria; o build não constitui homologação.', 'Alias ausente ou ambíguo falha antes de abrir telas. Se o evento mapeado não abrir o Form esperado, não existe fallback que esconda a falha.', 'Evento direto não possui Form esperado no contrato e não depende do catálogo. Form e Caption exigem registro no módulo corrente.']
});
documento.fontes.push({ caminho: 'docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_APPLICATION_MAPEAMENTO_JSON.json' });
documento.secoes.push({ id: 'exemplos', titulo: 'As três formas de chamada', blocos: [{ tipo: 'codigo', linguagem: 'pascal', codigo: "{P39_TDD_RUN_APPLICATION.}AbrirTela('Contas a Receber');\n{P39_TDD_RUN_APPLICATION.}AbrirTela('FCadReceber');\n{P39_TDD_RUN_APPLICATION.}AbrirTela('Receber1Click');" }] });
export default documento;
