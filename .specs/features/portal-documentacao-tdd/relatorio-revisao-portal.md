# Revisão do portal de documentação

## Realização

Removidos os textos solicitados do header e drawer. Adicionadas busca local por relevância, oito documentações individuais de units e citações reutilizáveis com redirecionamento automático por nome e aliases. Os cards inteiros são navegáveis e o conteúdo permanece aberto, com sumário hierárquico que acompanha a leitura e códigos apresentados como terminal.

Os diagramas ativos agora são lidos exclusivamente de Markdown em `docs/MAPEAMENTO_AST_USES_UNITS/<slug>/`, incluindo o mapa sintático de uses do Runner. Cada documentação mantém seus próprios diagramas. A visualização oferece ajuste de escala, zoom e orientação, preservando a fonte canônica. Os 13 snippets cobrem páginas, seções, units, métodos, estados, blocos e arquivos Mermaid.

Testes, ferramentas, dependências npm e saídas locais estão ignorados pelo Git. O portal continua estático, via CDN e rotas hash, com `.nojekyll` na raiz. TDD_ASSERTS permanece pendente. Nenhuma publicação remota foi realizada.

Verificação executada: catálogo com 16 documentos e 194 seções, fontes e 13 snippets conferidos, incluindo expansão dos modelos de página e unit. Verificação breve no navegador passou para busca com/sem acentos, navegação e recarga de units, links em texto e diagramas, zoom/orientação, sumário ativo e layout mobile. O mesmo cenário passou sobre o artefato estático de 63 arquivos, servido sob `/TestesAutomatizadosERP/`, sem erros JavaScript ou assets locais ausentes. Screenshots foram revisadas; os recursos dessa verificação são locais e não versionados.

## Fontes modificados

- `.gitignore`
- `.nojekyll`
- `.vscode/documentacao.code-snippets`
- `Documentacoes/01-Processo-Runner-Orquestrador/index.html`
- `Documentacoes/02-Caso-de-Teste/index.html`
- `Documentacoes/03-Parametro/index.html`
- `Documentacoes/04-Documento-Fatura/index.html`
- `Documentacoes/README.md`
- `Documentacoes/app/bootstrap.js`
- `Documentacoes/app/components/AppLayout.js`
- `Documentacoes/app/components/CodeBlock.js`
- `Documentacoes/app/components/DocBlocks.js`
- `Documentacoes/app/components/DocNotice.js`
- `Documentacoes/app/components/DocSection.js`
- `Documentacoes/app/components/DocTable.js`
- `Documentacoes/app/components/DocumentSearch.js`
- `Documentacoes/app/components/DocumentToc.js`
- `Documentacoes/app/components/MermaidDiagram.js`
- `Documentacoes/app/components/RedirectCard.js`
- `Documentacoes/app/components/ReferenceText.js`
- `Documentacoes/app/components/UnitReference.js`
- `Documentacoes/app/composables/useDocumentSections.js`
- `Documentacoes/app/config.js`
- `Documentacoes/app/content/catalogo.js`
- `Documentacoes/app/content/documentos/casos-de-teste.js`
- `Documentacoes/app/content/documentos/parametros.js`
- `Documentacoes/app/content/estrutura/runner.js`
- `Documentacoes/app/content/guias/autoria.js`
- `Documentacoes/app/content/legado/casos-de-teste.js`
- `Documentacoes/app/content/legado/documento-fatura.js`
- `Documentacoes/app/content/legado/parametros.js`
- `Documentacoes/app/content/legado/runner-legado.js`
- `Documentacoes/app/content/units/catalogo.js`
- `Documentacoes/app/content/units/criarDocumentoUnit.js`
- `Documentacoes/app/content/units/p39-tdd-casos-de-teste.js`
- `Documentacoes/app/content/units/p39-tdd-parametro.js`
- `Documentacoes/app/content/units/tdd-base-unit-irunner.js`
- `Documentacoes/app/content/units/tdd-finished.js`
- `Documentacoes/app/content/units/tdd-irunner.js`
- `Documentacoes/app/content/units/tdd-logs.js`
- `Documentacoes/app/content/units/tdd-runner.js`
- `Documentacoes/app/content/units/tdd-started.js`
- `Documentacoes/app/content/validarCatalogo.js`
- `Documentacoes/app/diagrams.js`
- `Documentacoes/app/main.js`
- `Documentacoes/app/pages/DocumentPage.js`
- `Documentacoes/app/pages/HomePage.js`
- `Documentacoes/app/pages/NotFoundPage.js`
- `Documentacoes/app/router.js`
- `Documentacoes/app/search.js`
- `Documentacoes/app/styles/portal.css`
- `Documentacoes/app/templates/novo-documento.js`
- `Documentacoes/app/unitReferences.js`
- `Documentacoes/legado-originais/01-Processo-Runner-Orquestrador/index.html`
- `Documentacoes/legado-originais/02-Caso-de-Teste/index.html`
- `Documentacoes/legado-originais/03-Parametro/index.html`
- `Documentacoes/legado-originais/04-Documento-Fatura/index.html`
- `Documentacoes/legado-originais/index-raiz.html`
- `Documentacoes/migracao.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/casos-de-teste/cadastro.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/casos-de-teste/datasets.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/parametros/aplicacao.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/parametros/escopo.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/parametros/preparacao.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_IRUNNER.ast.js`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_IRUNNER.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/estado.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/falhas.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/lote.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/metricas.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/responsabilidades.md`
- `index.html`

## p/ teste

1. Abra o portal em um servidor HTTP estático. A página inicial apresenta cards clicáveis; o header contém a busca e o drawer contém o grupo Units.
2. Busque `TDD_LOGS` e confira sua documentação individual. Busque `parametros`, sem acento, para encontrar Parâmetros do ERP.
3. Abra Estrutura e fluxo de IRunner.Executar. Clique em uma citação de TDD_STARTED ou em seu nó no diagrama: a página individual deve abrir.
4. Use o sumário para ir até Estados globais. O conteúdo deve permanecer aberto, com o título ativo destacado.
5. Experimente ampliar, reduzir, ajustar e trocar a orientação de um fluxograma. Copie um código e confira que o texto permanece literal.
6. Recarregue uma rota de unit e repita a busca em tela estreita. Os resultados devem ficar visíveis abaixo do header.
7. No VS Code, consulte o guia de autoria e os snippets docpagina, docsecao e docunit. Os registros no catálogo devem gerar navegação e busca automaticamente.

## O que há de novo

Busca por relevância e referências clicáveis levam diretamente às responsabilidades, estados e métodos de cada unit. Diagramas ajustáveis e snippets completos facilitam a leitura e a manutenção das próximas documentações.
