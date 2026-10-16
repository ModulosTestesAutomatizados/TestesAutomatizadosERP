import type { IDocumento } from '../../../contracts/documentacao.ts';

import modelo from '../../../templates/novo-documento.ts';

export default {
  slug: 'autoria', categoria: 'guias', titulo: 'Como escrever uma documentação',
  resumo: 'Crie e mantenha páginas, seções, documentações de units, estados e diagramas com TypeScript e snippets.',
  estado: 'em-uso', fontes: [
    'Documentacoes/app/README.md', '.vscode/documentacao.code-snippets',
    'Documentacoes/app/models/documentacao.ts', 'Documentacoes/app/navigation.ts', 'Documentacoes/app/content/navegacao.ts',
    'Documentacoes/app/content/validarCatalogo.ts', 'Documentacoes/config/README.md'
  ].map(pCaminho => ({ caminho: pCaminho })),
  secoes: [
    { id: 'organizacao', titulo: 'Onde cada alteração deve ser feita', blocos: [
      { tipo: 'lista', itens: [
        'Grupo de navegação: Arquitetura, Units, Casos de teste, Mapeamentos, Helpers e Contribuir no drawer. A categoria ou navegacao da página define em qual grupo ela aparece.',
        'Página: um documento exportado por um arquivo TypeScript em content e registrado no catálogo. Possui título, resumo, estado e uma rota própria.',
        'Seção: um item de secoes dentro da página. Possui id, titulo, nivel e blocos; aparece no sumário e não exige registro no catálogo.',
        'Bloco: um parágrafo, lista, tabela, código, aviso ou referência Mermaid dentro de uma seção. Não cria uma rota nem possui um estado próprio.',
        'Unit: uma página criada com criarDocumentoUnit e registrada em content/units/catalogo.ts. Suas seções e seus símbolos de busca são gerados das listas estados e metodos.'
      ] },
      { tipo: 'paragrafo', texto: 'Os exemplos usam caminhos relativos à raiz do repositório. Edite o módulo de conteúdo da página desejada; não copie index.html nem crie um novo HTML. Conteúdo, navegação, busca e citações são derivados dos catálogos.' }
    ] },
    { id: 'passos', titulo: '01 · Incluir uma nova página', blocos: [
      { tipo: 'lista', itens: [
        'Crie um arquivo .ts em Documentacoes/app/content/estrutura/ com nome representativo do assunto.',
        'No VS Code, use docpagina e preencha os campos. Se as sugestões não aparecerem, acione Inserir Snippet na paleta de comandos.',
        'Preencha objetivo, pré-requisitos, entradas, fluxo, resultados esperados, dependências e limitações com evidência nos fontes.',
        'No catalogo.ts, importe o novo módulo e acrescente-o à lista documentos. docregistro auxilia o import. Não altere router, layout ou componentes.',
        'Na raiz, execute npm run check --prefix Documentacoes e npm run dev --prefix Documentacoes; abra o endereço informado no terminal. Se a porta 8080 estiver ocupada, o preview seleciona uma porta livre.',
        'Inclua a documentação na mesma entrega do caso e regenere o mapa de uses quando os fontes do Runner mudarem.'
      ] }
    ] },
    { id: 'modelo', titulo: '02 · Modelo de documento', blocos: [
      { tipo: 'codigo', linguagem: 'typescript', codigo: modelo },
      { tipo: 'paragrafo', texto: 'O slug deve ser único no catálogo, com letras minúsculas, números e hífens. Categorias de páginas comuns: estrutura, documentos ou guias; units usa seu criador específico. A rota é derivada como /categoria/slug. Cada seção possui um ID único dentro do documento. O preenchimento das fontes deve usar caminhos reais relativos à raiz do repositório.' }
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
        ['docunitjson', 'JSON base de um caso, tabela de objetos/campos e fontes consumidoras'],
        ['docregistrounit', 'Registro no catálogo único de units e habilitação dos links'],
        ['docaviso', 'Aviso visível com severidade'],
        ['doclista', 'Lista de etapas, responsabilidades ou dependências'],
        ['docmermaid', 'Arquivo Markdown canônico com um fluxograma Mermaid'],
        ['docestado', 'Campo estado com opções; substitui o campo existente'],
        ['docvalidacao', 'Evidência obrigatória para validado-no-erp, em página ou unit'],
        ['doccaso', 'Agrupamento em Casos de teste → Legado ou IRunner'],
        ['docgrupo', 'Novo grupo no registro central de navegação'],
        ['docsubgrupo', 'Novo subgrupo dentro de um grupo registrado'],
        ['docnavegacao', 'Posicionamento de página ou unit por grupo, subgrupo e ordem'],
        ['docfonte', 'Entrada da lista fontes com caminho relativo à raiz'],
        ['docaliasartefato', 'Variante de pesquisa para um estado declarado pela unit']
      ] },
      { tipo: 'paragrafo', texto: 'Os 22 snippets ficam em .vscode/documentacao.code-snippets. Use os prefixos em arquivos TypeScript; docmermaid usa Markdown. Os blocos suportados são paragrafo, lista, tabela, codigo, aviso e mermaid. Conteúdo é texto, não HTML executável. Para strings TypeScript com várias linhas, use crases; escape crases e interpolação quando forem conteúdo do exemplo. O CodeBlock mantém o código literal e selecionável se a cópia automática não estiver disponível.' },
      { tipo: 'codigo', linguagem: 'typescript', codigo: "{ tipo: 'tabela', colunas: ['Unit', 'Responsabilidade'],\n  linhas: [['P39_TDD_STARTED', 'Preparar o caso corrente']] },\n{ tipo: 'mermaid', fonte: 'docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.md',\n  titulo: 'Uses diretos e transitivos' },\n{ tipo: 'aviso', severidade: 'warning', texto: 'Asserts pendentes.' }" }
    ] },
    { id: 'evidencias', titulo: '04 · Estado documental e evidências', blocos: [
      { tipo: 'tabela', colunas: ['Estado', 'Uso'], linhas: [
        ['legado', 'Contrato anterior preservado para referência; não assumir compatibilidade com o molde novo'],
        ['em-uso', 'Recurso ou guia utilizado no fluxo documentado; não é uma declaração de homologação nem exige uso pelo IRunner'],
        ['em-desenvolvimento', 'Implementação em evolução ou contrato com pendências; descreva essas pendências na página'],
        ['validado-no-erp', 'Exige evidenciaValidacao com data, versaoERP e referencia identificável']
      ] },
      { tipo: 'paragrafo', texto: 'A etiqueta pertence à página inteira e descreve o estado do recurso documentado. Ela não mede a completude do texto, não é alterada automaticamente por commits e não existe por seção. Uma seção pode registrar uma pendência com docaviso mesmo quando a página está em uso.' },
      { tipo: 'lista', itens: [
        'Abra o arquivo da página em content ou o arquivo da unit em content/units.',
        'Substitua o valor de estado no objeto exportado ou nos argumentos de criarDocumentoUnit. Use docestado para escolher uma opção; não adicione um segundo campo estado.',
        'Para em-uso, descreva qual fluxo utiliza o recurso. Use legado para contratos anteriores preservados; estar fora do IRunner não torna uma dependência automaticamente obsoleta.',
        'Para validado-no-erp, adicione evidenciaValidacao com docvalidacao e preencha data, versaoERP e referencia com os dados reais da homologação.',
        'Atualize limites, avisos, fontes e diagramas afetados. Execute check e build e confira a etiqueta no card e na página antes de incluir a alteração no PR.'
      ] },
      { tipo: 'codigo', linguagem: 'typescript', codigo: "// Página comum ou argumentos de criarDocumentoUnit:\nestado: 'em-uso'," },
      { tipo: 'codigo', linguagem: 'typescript', codigo: "// Após homologação comprovada, substitua o estado e preencha dados reais:\nestado: 'validado-no-erp',\nevidenciaValidacao: {\n  data: 'AAAA-MM-DD',\n  versaoERP: 'Versão efetivamente validada',\n  referencia: 'Link do relatório ou registro de homologação'\n}," },
      { tipo: 'paragrafo', texto: 'Os dois exemplos representam alternativas: mantenha somente um campo estado. O build rejeita validado-no-erp sem os três campos de evidência preenchidos. O criador de units também repassa essa evidência ao documento gerado.' },
      { tipo: 'aviso', severidade: 'warning', texto: 'Não use SUCESSO como evidência de asserts no Runner desta iteração. Não prometa restauração de parâmetros ou chamadas reentrantes sem evidência funcional.' }
    ] },
    { id: 'unit', titulo: '05 · Documentar uma única unit', blocos: [
      { tipo: 'paragrafo', texto: 'Os cards exibem grupo/subgrupo do registro de navegação e o tipo do artefato. criarDocumentoUnit usa tipoArtefato unit como padrão; defina tipoArtefato: processamento para uma entrada de processamento. Essa classificação é explícita e não transforma o nome da unit.' },
      { tipo: 'lista', itens: [
        'Crie content/units/nome-da-unit.ts com docunit. O modelo compartilhado gera seções de responsabilidade, problema resolvido, estado global, procedures/functions, implementação, dependências e limites.',
        'Use docunitestado e docunitmetodo para ampliar as listas. Descreva tipos, entradas, retornos, erros, efeitos sobre o contexto global e o ciclo de vida de cada artefato com base no fonte.',
        'Registre a página em content/units/catalogo.ts com docregistrounit. O catálogo principal, o drawer e a busca passam a incluir a unit automaticamente.',
        'A rota segue /units/nome-da-unit: nome em minúsculas com sublinhados convertidos em hífens. Use o mesmo nome canônico no arquivo Pascal, em nome e no título: P39_TDD_ seguido da responsabilidade, com FIN_ ou FAT_ para artefatos do módulo. Não crie nomes alternativos de exibição.',
        'ReferenceText identifica nomes e aliases por tokens de identificadores e usa UnitReference para gerar os links. Escreva os nomes normalmente em parágrafos, listas, tabelas e códigos; o texto copiado continua literal. Os nós Mermaid também recebem links quando citam uma unit cadastrada.'
        ,'Estados e assinaturas preenchidos com docunitestado e docunitmetodo geram automaticamente símbolos para a busca. A unit que declara um estado, procedure ou function recebe prioridade sobre as páginas que apenas o citam. aliasesArtefatos: { CDSCasosTestes: ["FCDSCasosTestes"] } pode registrar variantes de pesquisa sem alterar o nome declarado no fonte.'
      ] }
    ] },
    { id: 'nomenclatura', titulo: 'Nomes canônicos e cadastro no ERP', blocos: [
      { tipo: 'paragrafo', texto: 'Arquivo Pascal, identidade da unit, título e nome no menu devem ser iguais. Exemplo: P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas, nome P39_TDD_FIN_PAGAMENTO_RECEBIMENTO e rota /units/p39-tdd-fin-pagamento-recebimento. O build rejeita título ou nome de arquivo divergentes.' },
      { tipo: 'lista', itens: [
        'Em uma renomeação, atualize arquivo, declaração unit quando existir, uses, qualificações e nomes em SetTDDUnit ou CodificacaoUnit. Não altere procedimentos ou regras de negócio para mudar a nomenclatura.',
        'Atualize o módulo TypeScript, o catálogo de units, referências de fonte, snippets e diagramas canônicos. Revise linhas e hashes do inventário AST.',
        'Antes de executar os fontes renomeados, atualize os nomes cadastrados no ERP e na TekStore, inclusive o molde carregado por CodificacaoUnit e a unit selecionada por SetTDDUnit. Alterar os arquivos locais não publica esses cadastros.',
        'Esta documentação não executa sincronização nem atualiza cadastros externos. Confira as versões e os nomes do ambiente antes de executar.'
      ] }
    ] },
    { id: 'uses', titulo: '06 · Manter os diagramas canônicos', blocos: [
      { tipo: 'paragrafo', texto: 'Todos os diagramas ativos do portal são lidos de docs/MAPEAMENTO_AST_USES_UNITS/<slug-da-documentacao>/. Cada documentação mantém seu subdiretório, por exemplo runner ou p39-tdd-fin-pagamento-recebimento. Use docmermaid em um arquivo .md e docdiagrama na página para referenciá-lo. Não duplique o Mermaid em strings TypeScript.' },
      { tipo: 'paragrafo', texto: 'O mapa de uses do Runner está em runner/P39_TDD_IRUNNER.md; o inventário sintático, em runner/P39_TDD_IRUNNER.ast.json. Ele registra dependências declaradas, linhas e alcance transitivo, preservando units externas e marcadores dinâmicos. Não é uma AST completa de Delphi.' },
      { tipo: 'paragrafo', texto: 'Ajustar, ampliar, reduzir e mudar a orientação alteram apenas a visualização. O Markdown é a fonte de verdade. Testes e ferramentas auxiliares da LLM são locais e ignorados pelo Git; a manutenção manual dos arquivos Markdown e a execução do portal não dependem desses recursos.' },
      { tipo: 'paragrafo', texto: 'Quando um fonte do inventário AST mudar, revise dependências, linhas e hashes antes de publicar. Os hashes SHA-256 normalizam CRLF para LF. O build detecta mapas desatualizados. Não ignore a falha nem copie hashes de uma versão diferente do fonte.' }
    ] },
    { id: 'json-base', titulo: 'JSON base de uma unit de caso de teste', blocos: [
      { tipo: 'paragrafo', texto: 'Em criarDocumentoUnit, acrescente jsonBase com docunitjson quando a unit representar um caso de teste. exemplo contém um objeto JSON, campos contém linhas com caminho, tipo, finalidade e impacto, observacoes explica preenchimento e limites, e fontes identifica os fontes que consomem as tags. A seção JSON base do caso de teste aparece automaticamente no sumário.' },
      { tipo: 'codigo', linguagem: 'typescript', codigo: "jsonBase: {\n  exemplo: { documento: { cliente_docfat: 0 }, parametros: {} },\n  campos: [\n    ['documento', 'objeto', 'Dados do documento', 'Consumido pelo núcleo de faturamento.'],\n    ['documento.cliente_docfat', 'inteiro', 'Código do cliente', 'Substitua zero por um cliente da base.'],\n    ['parametros', 'objeto', 'Ajustes do ERP', 'Vazio não solicita alteração de parâmetros.']\n  ],\n  observacoes: ['Fragmento ilustrativo; preencha o contrato completo com base nos fontes.'],\n  fontes: ['docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA.pas']\n}," },
      { tipo: 'paragrafo', texto: 'O criador usa os blocos codigo e tabela existentes: o JSON é formatado com indentação, exibido no terminal e copiado sem comentários ou conteúdo HTML. A tabela deve explicar cada objeto e os campos que alteram o cenário, incluindo obrigatoriedade, padrões, precedência, erros e efeitos sobre os parâmetros.' },
      { tipo: 'paragrafo', texto: 'Pedido de Venda usa documento, item, item.itens e parametros; o piloto P39_TDD_FIN_PAGAMENTO_RECEBIMENTO lê as tags financeiras na raiz e recebe parametros pelo Started. Não reutilize o formato de um caso em outro sem conferir as rotinas consumidoras. Modelos com códigos zero precisam ser preenchidos antes da execução.' }
    ] },
    { id: 'manutencao', titulo: '07 · Criar e modificar seções de uma página', blocos: [
      { tipo: 'lista', itens: [
        'Localize a página pelo slug ou título em content. Exemplo: o fluxo do Runner está em content/estrutura/runner.ts; Pedido de Venda está em content/casos/pedido-venda.ts.',
        'Para uma nova seção, insira docsecao dentro de secoes, separado por vírgula dos demais itens. Preencha um id exclusivo, o título e os blocos.',
        'Para editar, altere titulo ou blocos da seção existente. Preserve id para manter os links compartilhados com ?secao=ID. Reordenar os itens altera a ordem de leitura e do sumário.',
        'Use nivel: 2 para uma seção principal e nivel: 3 ou 4 para um subtítulo. A seção continua visível; somente o menu lateral usa grupos expansíveis.',
        'Em uma documentação de unit, modifique responsabilidade, problema, estados, metodos, implementacao, dependencias e limites em criarDocumentoUnit. O nome do método determina o ID de sua subseção.',
        'Se adicionar um Mermaid, crie docs/MAPEAMENTO_AST_USES_UNITS/<slug>/nome.md e referencie com docdiagrama. Não é necessário registrar a seção no catálogo.'
      ] },
      { tipo: 'codigo', linguagem: 'typescript', codigo: "// Acrescente dentro da lista secoes da página:\n{\n  id: 'tratamento-de-erros', titulo: 'Tratamento de erros', nivel: 2,\n  blocos: [\n    { tipo: 'paragrafo', texto: 'Descreva o comportamento observado no fonte.' },\n    { tipo: 'aviso', severidade: 'warning', texto: 'Registre a pendência existente.' }\n  ]\n}," }
    ] },
    { id: 'navegacao', titulo: '08 · Posicionar páginas no menu e registrar no catálogo', blocos: [
      { tipo: 'paragrafo', texto: 'O registro content/navegacao.ts define os seis grupos e seus subgrupos. Arquitetura recebe estrutura; Contribuir recebe guias; units usa Setup como padrão. Prefira navegacao explícita com docnavegacao. Casos de teste não possui subgrupos: use doccaso na documentação individual do cenário. Mapeamentos → Financeiro recebe os dois borderôs; Helpers contém Gerais e Sincronização.' },
      { tipo: 'codigo', linguagem: 'typescript', codigo: "// Metadado da unit de cenário; mantém sua rota /units/p39-tdd-fin-meu-caso:\nnavegacao: { grupo: 'casos', ordem: 10 },\n\n// Em content/catalogo.ts, fora do objeto da página:\nimport meuCaso from './units/p39-tdd-fin-meu-caso.ts';\n// Acrescente meuCaso à lista documentos existente.\n\n// Para uma unit, use content/units/catalogo.ts:\nimport novaUnit from './p39-tdd-nova-unit.ts';\n// Acrescente novaUnit à lista units existente." },
      { tipo: 'paragrafo', texto: 'Os snippets de registro criam o import e um lembrete; a inclusão do identificador na lista ainda deve ser feita pelo autor. Inserir a mesma página ou alias duas vezes causa falha no catálogo. Criar um grupo não exige criar uma nova categoria nem alterar o router: use docgrupo no array GRUPOS_NAVEGACAO de content/navegacao.ts, docsubgrupo no array subgrupos e docnavegacao na página ou em criarDocumentoUnit.' },
      { tipo: 'codigo', linguagem: 'typescript', codigo: "// Em content/navegacao.ts, dentro de GRUPOS_NAVEGACAO:\n{ id: 'apoio', titulo: 'Apoio', icone: 'mdi-tools',\n  subgrupos: [{ id: 'consultas', titulo: 'Consultas' }] },\n\n// Na página ou nos argumentos de criarDocumentoUnit:\nnavegacao: { grupo: 'apoio', subgrupo: 'consultas', ordem: 10 }," },
      { tipo: 'paragrafo', texto: 'IDs de grupo devem ser únicos; IDs de subgrupo são únicos dentro do grupo. Use os IDs, não os títulos, nos metadados. O build rejeita grupos ou subgrupos inexistentes. A classificação muda somente o drawer: uma unit em Helpers continua com rota /units/nome-da-unit e mantém busca e links de citação.' },
      { tipo: 'paragrafo', texto: 'Units → Setup contém casos, cache, parâmetros, mapeamento de parâmetros e módulo. Constantes e Persistência contêm suas dependências compartilhadas. IRunner contém as seis units do contrato e o processamento financeiro. Casos de teste contém somente as duas units de cenário. Mapeamentos → Financeiro contém os borderôs; Helpers → Gerais contém funções JSON; Helpers → Sincronização contém registro, lista e processamento da sincronização.' }
    ] },
    { id: 'revisao-publicacao', titulo: '09 · Revisar e publicar uma alteração', blocos: [
      { tipo: 'codigo', linguagem: 'powershell', codigo: 'npm ci --prefix Documentacoes\nnpm run check --prefix Documentacoes\nnpm run dev --prefix Documentacoes' },
      { tipo: 'paragrafo', texto: 'Instale dependências ao preparar o ambiente ou quando o lockfile mudar. Após editar os fontes, refaça o build: o preview serve o artefato compilado e não tem atualização automática. Encerre o servidor com Ctrl+C antes de executar dev novamente, ou execute build enquanto o preview atual continua ativo.' },
      { tipo: 'lista', itens: [
        'Confira título, resumo, status, menu, sumário e links da página. Teste a busca por nomes de estados e métodos de uma unit.',
        'Preserve IDs das seções que continuam válidas. Nesta migração, páginas fora do mapa e rotas dos nomes anteriores foram excluídas, sem redirecionamentos. Antes de futuras remoções, revise os links internos afetados.',
        'Inclua no PR os fontes TypeScript, snippets, referências necessárias e mapas canônicos. tests, tools, dependências instaladas e saídas geradas permanecem ignorados.',
        'O workflow verifica lint, tipos e build no PR. Após o merge ou push em master, publica automaticamente quando houver alterações em index.html, Documentacoes/**, docs/MAPEAMENTO_AST_USES_UNITS/**, docs/assets/** ou no próprio workflow. A execução manual continua disponível em master, com Pages configurado para GitHub Actions. O site usa o artefato estático, não o servidor local.'
      ] }
    ] }
  ]
} satisfies IDocumento;
