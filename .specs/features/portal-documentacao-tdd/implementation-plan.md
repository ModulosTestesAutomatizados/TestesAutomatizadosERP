# Plano de implementação — portal Vue/Vuetify

**Objetivo:** entregar documentação modular para GitHub Pages com mapa sintático dos uses e fluxo de IRunner.
**Design:** [design-vuetify.md](design-vuetify.md), aprovado pelo usuário em 2026-10-13 com autorização explícita de implementação.
**Execução:** nesta sessão; preservar alterações existentes, sem push ou publicação remota.

## Restrições e decisões

- Vue, Vuetify e Router por CDN com versões exatas; módulos JavaScript sem build.
- Índice raiz somente como entrada; catálogo único gera cards/menu/rotas genéricas hash.
- Fontes Pascal e banco de dados permanecem como evidência, sem alteração funcional.
- Preservar originais antes da migração; APIs antigas recebem estado Legado.
- Execução no workspace solicitado para incorporar os HTMLs ainda não rastreados. Não criar worktree que os omita.
- Inventário sintático em JavaScript e Markdown: o repositório ignora JSON globalmente.

## Tarefas

- [x] 1. Extrator e mapa: `Documentacoes/tools/uses_graph.py`, `Documentacoes/tests/test_uses_graph.py` e `docs/mapeamentoUses/TDD_IRUNNER.{md,ast.js}`. Interface `parse_uses(text)` retorna cláusulas com nomes/linhas; `build_graph(root)` resolve arquivos, arestas estáticas e montagem dinâmica. Testar comentários, strings, multilinha, externos, ciclos e marcadores antes de implementar. CLI `--check` confere artefatos atuais.
- [x] 2. Catálogo e conteúdo: `Documentacoes/app/content/`, `content/validarCatalogo.js`, `tests/catalog.test.mjs`. Interface `validarCatalogo(documentos)` retorna erros com slug/campo; `rotaDocumento(documento)` deriva destino. Testar duplicidade, vazio, categoria, tabelas e evidência antes de implementar.
- [x] 3. Portal: `index.html`, `app/main.js`, `router.js`, `components/`, `pages/`, `styles/portal.css`. Provar combinação CDN no navegador. Verificar rotas genéricas, histórico, mobile, erros e cópia. Mermaid usa fallback textual e descarte de renderizações antigas.
- [x] 4. Migração: preservar HTMLs em `Documentacoes/legado-originais/`; converter seções em blocos escapados e criar manifesto `Documentacoes/migracao.md`. Índices anteriores viram redirecionamentos após conferir cobertura de headings. Conteúdo legado não é anunciado como contrato refatorado.
- [x] 5. Autoria/Pages: `.vscode/documentacao.code-snippets`, `Documentacoes/README.md`, `tools/validate.mjs` e `tools/prepare_pages.py`. Preparar artefato estático por allowlist e validar caminhos; publicação remota fica fora desta execução.
- [x] 6. Verificação: testes Python/Node, navegador na raiz e subpath, fonte regenerável, snippet novo, falha de Mermaid/CDN, revisão do diff e relatório.

## Condições de revisão

1. Comentários ou strings com uses não geram dependência.
2. Prefixos locais/remotos não são fundidos e dependências dinâmicas recebem legenda.
3. Recarregar uma rota sob prefixo mantém conteúdo e assets.
4. HTML legado vira dados; nenhum script/onclick legado é executado.
5. Falha de Mermaid/clipboard não impede a leitura do documento.

## Evidências de execução

Verificações concluídas: 8 testes Python, 6 testes Node e navegador no artefato final na raiz e sob prefixo Pages. Fontes, snippets, mapa regenerável e acentuação conferidos. Evidências e arquivos estão no [relatório de implementação](relatorio-implementacao.md). Publicação remota não executada.
