import type { IDocumento } from '../../models/documentacao.ts';

import modelo from '../../templates/novo-documento.ts';

export default {
  slug: 'autoria', categoria: 'guias', titulo: 'Como escrever uma documentação',
  resumo: 'Crie uma página com os snippets da IDE e registre uma vez no catálogo. Layout, cards e navegação são compartilhados.',
  estado: 'em-desenvolvimento', fontes: [{ caminho: 'Documentacoes/app/README.md' }, { caminho: '.vscode/documentacao.code-snippets' }],
  secoes: [
    { id: 'passos', titulo: '01 · Incluir uma nova página', blocos: [
      { tipo: 'lista', itens: [
        'Crie um arquivo .ts em Documentacoes/app/content/documentos/ com nome representativo do assunto.',
        'No VS Code, use docpagina e preencha os campos. Se as sugestões não aparecerem, acione Inserir Snippet na paleta de comandos.',
        'Preencha objetivo, pré-requisitos, entradas, fluxo, resultados esperados, dependências e limitações com evidência nos fontes.',
        'No catalogo.ts, importe o novo módulo e acrescente-o à lista documentos. docregistro auxilia o import. Não altere router, layout ou componentes.',
        'Execute npm run check e npm run build em Documentacoes; abra o artefato com npm run preview.',
        'Inclua a documentação na mesma entrega do caso e regenere o mapa de uses quando os fontes do Runner mudarem.'
      ] }
    ] },
    { id: 'modelo', titulo: '02 · Modelo de documento', blocos: [
      { tipo: 'codigo', linguagem: 'typescript', codigo: modelo },
      { tipo: 'paragrafo', texto: 'O slug deve ser único no catálogo, com letras minúsculas, números e hífens. Categorias: estrutura, documentos ou guias. A rota é derivada como /categoria/slug. Cada seção possui um ID único dentro do documento. O preenchimento das fontes deve usar caminhos reais relativos à raiz do repositório.' }
      ,{ tipo: 'paragrafo', texto: 'O conteúdo é exibido inteiro, sem seções expansíveis. Use nivel: 2 para o título principal da seção e nivel: 3 ou 4 para subtítulos. Esses níveis também definem a indentação do sumário lateral. Os links usam ?secao=ID dentro da rota hash, por isso continuam compartilháveis no GitHub Pages.' }
      ,{ tipo: 'paragrafo', texto: 'As categorias de Explorar são grupos expansíveis. Para incluir uma página em Casos de teste, acrescente navegacao: { grupo: "casos", subgrupo: "legado" ou "irunner", ordem: 0 } ao documento. O metadado muda seu lugar no drawer, preservando a rota definida por categoria e slug. Cada subgrupo pode conter novas páginas; ordem é opcional e valores menores aparecem primeiro.' }
    ] },
    { id: 'snippets', titulo: '03 · Snippets e blocos reutilizáveis', blocos: [
      { tipo: 'tabela', colunas: ['Prefixo', 'Conteúdo'], linhas: [
        ['docpagina', 'Documento completo com metadados, fontes e primeira seção'],
        ['docsecao', 'Seção com ID, título e lista de blocos'],
        ['doccodigo', 'Código literal: Pascal, JSON, JavaScript ou outra linguagem'],
        ['doctabela', 'Cabeçalhos e linhas da tabela de referência'],
        ['docdiagrama', 'Bloco Mermaid com fonte Markdown canônica'],
        ['docregistro', 'Import do módulo e lembrete de inclusão no catálogo'],
        ['docunit', 'Documento individual com responsabilidades, estados, métodos, implementação e limites'],
        ['docunitmetodo', 'Assinatura, contrato e implementação de uma procedure/function'],
        ['docunitestado', 'Nome, finalidade e ciclo de vida de um estado global'],
        ['docregistrounit', 'Registro no catálogo único de units e habilitação dos links'],
        ['docaviso', 'Aviso visível com severidade'],
        ['doclista', 'Lista de etapas, responsabilidades ou dependências'],
        ['docmermaid', 'Arquivo Markdown canônico com um fluxograma Mermaid']
      ] },
      { tipo: 'paragrafo', texto: 'Os blocos suportados são paragrafo, lista, tabela, codigo, aviso e mermaid. Conteúdo é texto, não HTML executável. Para strings JavaScript com várias linhas, use crases; escape crases e interpolação quando forem conteúdo do exemplo. O CodeBlock mantém o código literal e selecionável se a cópia automática não estiver disponível.' },
      { tipo: 'codigo', linguagem: 'typescript', codigo: "{ tipo: 'tabela', colunas: ['Unit', 'Responsabilidade'],\n  linhas: [['TDD_STARTED', 'Preparar o caso corrente']] },\n{ tipo: 'mermaid', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_IRUNNER.md',\n  titulo: 'Uses diretos e transitivos' },\n{ tipo: 'aviso', severidade: 'warning', texto: 'Asserts pendentes.' }" }
    ] },
    { id: 'evidencias', titulo: '04 · Estado documental e evidências', blocos: [
      { tipo: 'tabela', colunas: ['Estado', 'Uso'], linhas: [
        ['legado', 'Contrato anterior preservado para referência; não assumir compatibilidade com o molde novo'],
        ['em-uso', 'Dependência utilizada pelo fluxo atual do IRunner; não é uma declaração de homologação'],
        ['em-desenvolvimento', 'Fonte e estrutura descritos; sem homologação comprovada no ERP'],
        ['validado-no-erp', 'Exige evidenciaValidacao com data, versaoERP e referencia identificável']
      ] },
      { tipo: 'aviso', severidade: 'warning', texto: 'Não use SUCESSO como evidência de asserts no Runner desta iteração. Não prometa restauração de parâmetros ou chamadas reentrantes sem evidência funcional.' }
    ] },
    { id: 'unit', titulo: '05 · Documentar uma única unit', blocos: [
      { tipo: 'lista', itens: [
        'Crie content/units/nome-da-unit.ts com docunit. O modelo compartilhado gera seções de responsabilidade, problema resolvido, estado global, procedures/functions, implementação, dependências e limites.',
        'Use docunitestado e docunitmetodo para ampliar as listas. Descreva tipos, entradas, retornos, erros, efeitos sobre o contexto global e o ciclo de vida de cada artefato com base no fonte.',
        'Registre a página em content/units/catalogo.ts com docregistrounit. O catálogo principal, o drawer e a busca passam a incluir a unit automaticamente.',
        'A rota segue /units/nome-da-unit: nome em minúsculas com sublinhados convertidos em hífens. Declare aliases para variantes identificadas no fonte; eles não significam equivalência de implementação.',
        'ReferenceText identifica nomes e aliases por tokens de identificadores e usa UnitReference para gerar os links. Escreva os nomes normalmente em parágrafos, listas, tabelas e códigos; o texto copiado continua literal. Os nós Mermaid também recebem links quando citam uma unit cadastrada.'
        ,'Estados e assinaturas preenchidos com docunitestado e docunitmetodo geram automaticamente símbolos para a busca. A unit que declara um estado, procedure ou function recebe prioridade sobre as páginas que apenas o citam. aliasesArtefatos: { CDSCasosTestes: ["FCDSCasosTestes"] } pode registrar variantes de pesquisa sem alterar o nome declarado no fonte.'
      ] }
    ] },
    { id: 'uses', titulo: '06 · Manter os diagramas canônicos', blocos: [
      { tipo: 'paragrafo', texto: 'Todos os diagramas ativos do portal são lidos de docs/MAPEAMENTO_AST_USES_UNITS/<slug-da-documentacao>/. Cada documentação mantém seu subdiretório, por exemplo runner, casos-de-teste ou parametros. Use docmermaid em um arquivo .md e docdiagrama na página para referenciá-lo. Não duplique o Mermaid em strings TypeScript.' },
      { tipo: 'paragrafo', texto: 'O mapa de uses do Runner está em runner/TDD_IRUNNER.md; o inventário sintático, em runner/TDD_IRUNNER.ast.json. Ele registra dependências declaradas, linhas e alcance transitivo, preservando units externas e marcadores dinâmicos. Não é uma AST completa de Delphi.' },
      { tipo: 'paragrafo', texto: 'Ajustar, ampliar, reduzir e mudar a orientação alteram apenas a visualização. O Markdown é a fonte de verdade. Testes e ferramentas auxiliares da LLM são locais e ignorados pelo Git; a manutenção manual dos arquivos Markdown e a execução do portal não dependem desses recursos.' }
    ] }
  ]
} satisfies IDocumento;
