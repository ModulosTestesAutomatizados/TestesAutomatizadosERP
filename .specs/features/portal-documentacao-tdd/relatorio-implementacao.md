# Entrega local — portal de documentação TDD

Data: 2026-10-13. Implementação autorizada pelo usuário após aprovação do design com Vuetify.

## Realização (Interno)

Implementado portal Vue/Vuetify/Router via CDN, sem build obrigatório, com índice de entrada mínimo, catálogo declarativo e componentes reutilizáveis. A documentação atual do Runner descreve montagem, lote, falhas, estado global, logs e métricas, mantendo asserts pendentes. O mapa sintático regenerável registra 18 nós e 21 relações com fontes e linhas. Os HTMLs anteriores foram preservados e migrados como referência legada, com cobertura dos 69 headings originais.

A entrega contém seis páginas, 82 seções e seis snippets de VS Code. O artefato Pages foi preparado com 34 arquivos selecionados. Os acentos do índice e redirecionamentos foram corrigidos em UTF-8; testes também verificam caminhos acentuados na integração Node/Python sob codepage Windows. A publicação remota não foi executada.

Validação concluída:

- 8 testes Python: parser, migração, codificação e preparação do Pages.
- 6 testes Node: contrato do catálogo e seleção de assets.
- Validador: seis documentos, 82 seções, fontes locais e seis snippets válidos.
- Grafo: artefatos regenerados conferidos com `--check`.
- Navegador Chromium no artefato final: raiz e prefixo `/TestesAutomatizadosERP/`, sem erros JavaScript ou 404 locais; navegação, reload, histórico, mobile, teclado, três diagramas, conteúdo copiado, fallback de Mermaid/CDN/clipboard e novo documento a partir de docpagina passaram.
- Revisão independente: corrigidos skip link, diagramas adicionais no artefato, nomes qualificados de units e decodificação UTF-8 da saída Node; testes de regressão reproduziram os problemas antes das correções.
- Conferência visual: home mobile e página Runner em desktop, com acentos corretos.

## Fontes modificados

- `.gitignore`
- `.specs/features/portal-documentacao-tdd/README.md`
- `.specs/features/portal-documentacao-tdd/design-vuetify.md`
- `.specs/features/portal-documentacao-tdd/implementation-plan.md`
- `.specs/features/portal-documentacao-tdd/relatorio-implementacao.md`
- `.specs/features/portal-documentacao-tdd/spec.md`
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
- `Documentacoes/app/components/MermaidDiagram.js`
- `Documentacoes/app/components/RedirectCard.js`
- `Documentacoes/app/config.js`
- `Documentacoes/app/content/catalogo.js`
- `Documentacoes/app/content/estrutura/runner.js`
- `Documentacoes/app/content/guias/autoria.js`
- `Documentacoes/app/content/legado/casos-de-teste.js`
- `Documentacoes/app/content/legado/documento-fatura.js`
- `Documentacoes/app/content/legado/parametros.js`
- `Documentacoes/app/content/legado/runner-legado.js`
- `Documentacoes/app/content/validarCatalogo.js`
- `Documentacoes/app/diagrams.js`
- `Documentacoes/app/main.js`
- `Documentacoes/app/pages/DocumentPage.js`
- `Documentacoes/app/pages/HomePage.js`
- `Documentacoes/app/pages/NotFoundPage.js`
- `Documentacoes/app/router.js`
- `Documentacoes/app/styles/portal.css`
- `Documentacoes/app/templates/novo-documento.js`
- `Documentacoes/legado-originais/01-Processo-Runner-Orquestrador/index.html`
- `Documentacoes/legado-originais/02-Caso-de-Teste/index.html`
- `Documentacoes/legado-originais/03-Parametro/index.html`
- `Documentacoes/legado-originais/04-Documento-Fatura/index.html`
- `Documentacoes/legado-originais/index-raiz.html`
- `Documentacoes/migracao.md`
- `Documentacoes/package-lock.json`
- `Documentacoes/package.json`
- `Documentacoes/tests/browser.mjs`
- `Documentacoes/tests/catalog.test.mjs`
- `Documentacoes/tests/pages-assets.test.mjs`
- `Documentacoes/tests/test_encoding.py`
- `Documentacoes/tests/test_migration.py`
- `Documentacoes/tests/test_pages.py`
- `Documentacoes/tests/test_uses_graph.py`
- `Documentacoes/tools/list_pages_assets.mjs`
- `Documentacoes/tools/migrate_legacy.py`
- `Documentacoes/tools/prepare_pages.py`
- `Documentacoes/tools/uses_graph.py`
- `Documentacoes/tools/validate.mjs`
- `docs/mapeamentoUses/TDD_IRUNNER.ast.js`
- `docs/mapeamentoUses/TDD_IRUNNER.md`
- `index.html`

## p/ teste

1. Abra o endereço local do portal informado pelo desenvolvedor. O roteiro para iniciar a prévia está em Documentacoes/README.md.
2. Na página inicial, clique no card “Estrutura e fluxo de IRunner.Executar”. Expanda as seções de contrato, dependências, fluxo, falhas, estados e métricas.
3. Confira os acentos em “Documentação”, “técnica”, “parâmetros” e “execução”, incluindo as mensagens exibidas antes do carregamento.
4. Recarregue a página e use voltar/avançar; a documentação correspondente deve permanecer acessível.
5. Abra Casos de teste, Parâmetros do ERP e Documento Fatura. As referências anteriores devem estar identificadas como Legado.
6. Abra “Como escrever uma documentação” e siga o exemplo do snippet para incluir uma nova página no catálogo.
7. Em uma janela estreita, abra o menu, escolha uma documentação e confira que somente blocos largos possuem rolagem horizontal.
8. Copie um bloco de código. Se a cópia estiver indisponível, o código deve continuar selecionável e a página deve informar a alternativa.

## O que há de novo

A documentação agora compartilha navegação e apresentação, facilitando adicionar novas páginas com snippets. O Runner tem um mapa de dependências e uma explicação do fluxo e dos estados usados por cada execução. Conteúdo anterior e atual ficam identificados para orientar a manutenção.
