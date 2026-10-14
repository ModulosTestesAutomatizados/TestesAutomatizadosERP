# Organização e padrões do portal

## Realização

Conteúdo, componentes e referências históricas concentrados em `Documentacoes/app`. Os HTMLs anteriores ficam em `app/arquivo/html`, os módulos de conteúdo anterior em `app/content/historico` e os redirecionamentos em `app/redirecionamentos`, com nomes por assunto. As pastas numeradas foram removidas da raiz dos fontes; suas URLs são mantidas no artefato por um manifesto de compatibilidade.

Todos os módulos da aplicação foram convertidos para TypeScript, com tipos compartilhados, modo strict e nomenclatura conforme o padrão do projeto. A configuração de ESLint é uma cópia idêntica do arquivo indicado em k6; o comando lint também verifica os templates Vue inline com as mesmas regras de atributos e formatação. Os snippets foram adaptados ao escopo TypeScript e os modelos de página e unit foram conferidos pelo compilador.

Configuração e scripts de build ficam em `Documentacoes/config`. O pacote e lockfile agora são versionados porque definem compilação e qualidade; não contêm dependências ou comandos de testes. Testes, tools e saídas locais continuam ignorados. Vue, Router, Vuetify e Mermaid permanecem via CDN. A aplicação publicada continua estática; o build converte TypeScript para JavaScript e monta somente os assets necessários ao GitHub Pages.

Os Mermaids permanecem em `docs/MAPEAMENTO_AST_USES_UNITS`, organizados por documentação. Mapas anteriores foram movidos para `historico/` por assunto. O mapa atual do piloto foi corrigido contra os fontes e o inventário sintático foi regenerado, incluindo o processamento financeiro: 19 nós e 22 arestas. O inventário passou a JSON e o build confere seus hashes para detectar fontes alterados sem revisão dos mapas. TDD_ASSERTS permanece pendente.

Verificações executadas: instalação reproduzível com npm ci; lint de TypeScript e templates sem erros ou avisos; typecheck strict; build estático com catálogo de 19 documentos e 208 seções; snippets de página/unit; conferência do inventário sintático; navegação breve no navegador sobre o artefato compilado com prefixo do Pages, incluindo busca, units, grupos, diagramas, zoom/orientação, mobile, recarga e todas as quatro URLs numeradas anteriores. Nenhuma publicação remota foi realizada. O workflow preparado verifica PRs e permite publicação manual na branch padrão após configurar GitHub Actions como origem do Pages.

## Fontes modificados

- `.agents/AGENTS.md`
- `.agents/Agents.md`
- `.gitignore`
- `.github/workflows/documentacao-pages.yml`
- `.vscode/documentacao.code-snippets`
- `.vscode/settings.json`
- `Documentacoes/app/README.md`
- `Documentacoes/app/arquivo/README.md`
- `Documentacoes/app/arquivo/html/casos-de-teste/index.html`
- `Documentacoes/app/arquivo/html/documento-fatura/index.html`
- `Documentacoes/app/arquivo/html/parametros/index.html`
- `Documentacoes/app/arquivo/html/portal-anterior.html`
- `Documentacoes/app/arquivo/html/runner-orquestrador/index.html`
- `Documentacoes/app/arquivo/migracao.md`
- `Documentacoes/app/bootstrap.ts`
- `Documentacoes/app/components/AppLayout.ts`
- `Documentacoes/app/components/CodeBlock.ts`
- `Documentacoes/app/components/DocBlocks.ts`
- `Documentacoes/app/components/DocNotice.ts`
- `Documentacoes/app/components/DocSection.ts`
- `Documentacoes/app/components/DocTable.ts`
- `Documentacoes/app/components/DocumentSearch.ts`
- `Documentacoes/app/components/DocumentToc.ts`
- `Documentacoes/app/components/MermaidDiagram.ts`
- `Documentacoes/app/components/NavigationGroup.ts`
- `Documentacoes/app/components/RedirectCard.ts`
- `Documentacoes/app/components/ReferenceText.ts`
- `Documentacoes/app/components/UnitReference.ts`
- `Documentacoes/app/composables/useDocumentSections.ts`
- `Documentacoes/app/config.ts`
- `Documentacoes/app/content/casos/irunner.ts`
- `Documentacoes/app/content/casos/legado.ts`
- `Documentacoes/app/content/casos/piloto-financeiro.ts`
- `Documentacoes/app/content/catalogo.ts`
- `Documentacoes/app/content/documentos/casos-de-teste.ts`
- `Documentacoes/app/content/documentos/parametros.ts`
- `Documentacoes/app/content/estrutura/runner.ts`
- `Documentacoes/app/content/guias/autoria.ts`
- `Documentacoes/app/content/historico/casos-de-teste.ts`
- `Documentacoes/app/content/historico/documento-fatura.ts`
- `Documentacoes/app/content/historico/obterBlocos.ts`
- `Documentacoes/app/content/historico/parametros.ts`
- `Documentacoes/app/content/historico/runner-legado.ts`
- `Documentacoes/app/content/units/catalogo.ts`
- `Documentacoes/app/content/units/criarDocumentoUnit.ts`
- `Documentacoes/app/content/units/p39-tdd-casos-de-teste.ts`
- `Documentacoes/app/content/units/p39-tdd-parametro.ts`
- `Documentacoes/app/content/units/tdd-base-unit-irunner.ts`
- `Documentacoes/app/content/units/tdd-finished.ts`
- `Documentacoes/app/content/units/tdd-irunner.ts`
- `Documentacoes/app/content/units/tdd-logs.ts`
- `Documentacoes/app/content/units/tdd-runner.ts`
- `Documentacoes/app/content/units/tdd-started.ts`
- `Documentacoes/app/content/validarCatalogo.ts`
- `Documentacoes/app/diagrams.ts`
- `Documentacoes/app/main.ts`
- `Documentacoes/app/models/documentacao.ts`
- `Documentacoes/app/navigation.ts`
- `Documentacoes/app/pages/DocumentPage.ts`
- `Documentacoes/app/pages/HomePage.ts`
- `Documentacoes/app/pages/NotFoundPage.ts`
- `Documentacoes/app/redirecionamentos/casos-de-teste/index.html`
- `Documentacoes/app/redirecionamentos/documento-fatura/index.html`
- `Documentacoes/app/redirecionamentos/manifesto.ts`
- `Documentacoes/app/redirecionamentos/parametros/index.html`
- `Documentacoes/app/redirecionamentos/runner-orquestrador/index.html`
- `Documentacoes/app/router.ts`
- `Documentacoes/app/search.ts`
- `Documentacoes/app/styles/portal.css`
- `Documentacoes/app/templates/novo-documento.ts`
- `Documentacoes/app/types/runtime.d.ts`
- `Documentacoes/app/unitReferences.ts`
- `Documentacoes/config/README.md`
- `Documentacoes/config/build.mjs`
- `Documentacoes/config/eslint.config.js`
- `Documentacoes/config/lint-templates.mjs`
- `Documentacoes/config/preview.mjs`
- `Documentacoes/package-lock.json`
- `Documentacoes/package.json`
- `Documentacoes/tsconfig.json`
- `docs/MAPEAMENTO_AST_USES_UNITS/README.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_IRUNNER.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_IRUNNER.ast.json`
- `docs/MAPEAMENTO_AST_USES_UNITS/piloto-financeiro/dependencias.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/`

## p/ teste

1. Na raiz, execute `npm ci --prefix Documentacoes`, `npm run check --prefix Documentacoes` e `npm run build --prefix Documentacoes`.
2. Execute `npm run preview --prefix Documentacoes` e abra `http://127.0.0.1:8080/`.
3. Confira os grupos do drawer, procure RegistrarTick e FCDSCasosTestes e abra as units encontradas.
4. Abra Casos de teste → IRunner → Piloto financeiro. Confira as sequências e o mapa de dependências atualizado.
5. Recarregue uma página e confira o portal em tela estreita. As rotas hash e grupos devem continuar funcionando.
6. Abra `http://127.0.0.1:8080/Documentacoes/04-Documento-Fatura/`: a URL anterior deve redirecionar para a documentação atual.
7. Consulte `Documentacoes/app/README.md` para criar páginas e units em TypeScript. Os HTMLs do arquivo histórico servem como referência editorial e não são publicados.

## O que há de novo

Documentação organizada em uma única área, com histórico identificado e código TypeScript verificado pelo padrão de ESLint do projeto. O GitHub Pages recebe um artefato compilado, e mapas desatualizados são detectados durante o build.
