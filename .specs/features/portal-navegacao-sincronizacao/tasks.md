# Implementação da iteração

## Execution Protocol

Usar tlc-spec-driven: uma entrega verificável por commit, atualizar este registro antes de cada commit. Aprovação do usuário autoriza implementação e commits locais. Nenhum push ou deploy nesta etapa. Implementação sequencial neste worktree; verificador independente no encerramento.

## Test Coverage Matrix

Diretrizes: especificação aprovada, pedido de verificações proporcionais e proibição de versionar testes/tools. Comandos de qualidade extraídos de `Documentacoes/package.json`.

| Code Layer | Required Test Type | Coverage Expectation | Location Pattern | Run Command |
| --- | --- | --- | --- | --- |
| Identidades e referências | integration | Tabela de migração, integridade dos nomes dinâmicos e preservação da lógica | tools locais ignorados | python Documentacoes/tools/portal-iteration/migrate.py --check |
| Catálogo e navegação | integration | Árvore exata, páginas removidas, unicidade e ancestrais | tools locais ignorados | node Documentacoes/tools/portal-iteration/check.mjs catalog |
| Helpers | integration | Contratos dos três fontes, símbolos buscáveis e links | tools locais ignorados | node Documentacoes/tools/portal-iteration/check.mjs helpers |
| Apresentação | e2e | Loading/pronto/erro, truncamento, foco, mobile e scroll | tools locais ignorados | node Documentacoes/tools/portal-iteration/browser.mjs |
| Autoria e publicação estática | integration | Snippets válidos, catálogo compilado e prefixo Pages | tools locais ignorados | node Documentacoes/tools/portal-iteration/check.mjs final |

## Gate Check Commands

| Gate Level | When to Use | Command |
| --- | --- | --- |
| Quick | Migração antes da retirada de documentos obsoletos | python Documentacoes/tools/portal-iteration/migrate.py --check + npm run typecheck --prefix Documentacoes |
| Full | Catálogo e helpers | npm run build --prefix Documentacoes + comando da camada na matriz |
| Build | Apresentação e encerramento | npm run check --prefix Documentacoes + npm run build --prefix Documentacoes + verificação local da tarefa |

## Execution Plan

### Phase 1: Migração e conteúdo

```text
T1 → T2 → T3
```

### Phase 2: Apresentação e autoria

```text
T3 → T4 → T5 → T6 → T7
```

## Task Breakdown

### T1: Migrar identidades dos artefatos

**What**: Aplicar a tabela de nomes em fontes, referências editoriais e grafos, sem mudar lógica.
**Where**: inventário de artefatos e referências da migração em design.md
**Depends on**: None
**Requirement**: PORTAL-26, PORTAL-27, PORTAL-28, PORTAL-30
**Tools**: filesystem, Git; skills TLC e Vue nas referências editoriais.
**Done when**:
- [x] Nomes antigos migrados e literais dinâmicos coerentes; diff Pascal limitado à nomenclatura.
- [x] Inventário AST e hashes correspondem aos arquivos atuais; verificação de migração e typecheck passam.
**Tests**: integration
**Gate**: quick
**Commit**: refactor(docs): padroniza identidades dos artefatos TDD

### T2: Aplicar a árvore e remover páginas antigas

**What**: Substituir a navegação pelo mapa aprovado e excluir documentos e rotas obsoletos.
**Where**: catálogo de documentação e registro central de navegação
**Depends on**: T1
**Requirement**: PORTAL-06, PORTAL-07, PORTAL-08, PORTAL-09, PORTAL-10, PORTAL-22, PORTAL-29
**Tools**: filesystem, Git; TLC.
**Done when**:
- [x] Árvore e ordem correspondem ao mapa para as 19 units existentes; três helpers entram em T3.
- [x] Páginas antigas e redirecionamentos excluídos; catálogo e rotas de unit canônicas coerentes.
- [x] Build e verificação de catálogo passam.
**Tests**: integration
**Gate**: full
**Commit**: refactor(docs): reorganiza navegacao e remove paginas obsoletas

### T3: Documentar o contrato de sincronização

**What**: Integrar as três documentações individuais de sincronização e os fontes fornecidos.
**Where**: contrato editorial de units de sincronização
**Depends on**: T2
**Requirement**: PORTAL-11, PORTAL-12, PORTAL-13, PORTAL-14, PORTAL-15, PORTAL-16, PORTAL-24
**Tools**: filesystem, Git; TLC.
**Done when**:
- [x] Três páginas descrevem estados, assinaturas, efeitos e limites conforme os fontes, sem executar Pascal.
- [x] Busca e citações resolvem os símbolos; catálogo final de 24 documentos e build passam.
**Tests**: integration
**Gate**: full
**Commit**: docs: documenta helpers de sincronizacao de casos

### T4: Apresentar loading de tela inteira

**What**: Substituir o status do artefato por overlay com estados loading, pronto e erro.
**Where**: inicialização estática do portal
**Depends on**: T3
**Requirement**: PORTAL-01, PORTAL-02, PORTAL-03, PORTAL-04, PORTAL-05
**Tools**: filesystem, navegador local; TLC e Vue.
**Done when**:
- [ ] Overlay cobre viewport sem depender de CDN, some após montagem e oferece recarga em erro.
- [ ] Movimento reduzido e instrução do índice fonte preservados; checks locais passam.
**Tests**: e2e
**Gate**: build
**Commit**: feat(docs): adiciona overlay de carregamento inicial

### T5: Ajustar a leitura do drawer

**What**: Truncar nomes com texto completo acessível e adicionar respiro inferior.
**Where**: apresentação do componente NavigationGroup
**Depends on**: T4
**Requirement**: PORTAL-17, PORTAL-18, PORTAL-19
**Tools**: filesystem, navegador local; TLC e Vue.
**Done when**:
- [ ] Nomes em uma linha com ellipsis e tooltip em hover/foco; pelo menos 48 px após o último item.
- [ ] Verificação desktop/mobile e qualidade passam.
**Tests**: e2e
**Gate**: build
**Commit**: fix(docs): melhora leitura e espaco final do drawer

### T6: Ocultar barras mantendo rolagem

**What**: Ocultar scrollbar e preservar rolagem e foco dos contêineres.
**Where**: estilos de rolagem do portal
**Depends on**: T5
**Requirement**: PORTAL-20, PORTAL-21
**Tools**: filesystem, navegador local; TLC.
**Done when**:
- [ ] Página, drawer, terminal, tabelas e diagramas rolam sem barras visuais.
- [ ] Roda/teclado e rolagem horizontal continuam funcionais; verificação local passa.
**Tests**: e2e
**Gate**: build
**Commit**: style(docs): oculta barras preservando a rolagem

### T7: Atualizar autoria e concluir validação estática

**What**: Alinhar guia, exemplos e snippets à nomenclatura e navegação novas.
**Where**: guia de contribuição e seus snippets
**Depends on**: T6
**Requirement**: PORTAL-23, PORTAL-25, PORTAL-31
**Tools**: filesystem, navegador local; TLC e entregas.
**Done when**:
- [ ] Guia e snippets usam nomes canônicos e grupos válidos; guia explica atualização dos cadastros externos.
- [ ] Lint, tipos, build e navegação sob prefixo Pages passam; iniciar revisão independente TLC.
**Tests**: integration
**Gate**: build
**Commit**: docs: atualiza autoria para o catalogo canonico

## Diagram-Definition Cross-Check

| Task | Depends On | Diagram Shows | Status |
| --- | --- | --- | --- |
| T1 | None | início | Match |
| T2 | T1 | T1 → T2 | Match |
| T3 | T2 | T2 → T3 | Match |
| T4 | T3 | início da fase após T3 | Match |
| T5 | T4 | T4 → T5 | Match |
| T6 | T5 | T5 → T6 | Match |
| T7 | T6 | T6 → T7 | Match |

## Test Co-location Validation

T1–T3 e T7 usam integration; T4–T6 usam e2e. Todas as verificações são locais, ignoradas e acompanham a tarefa correspondente. Não há suíte versionada nem alterações nos scripts npm de produto.

## Evidências por tarefa

Registrar comando, resultado e localização das verificações ao concluir cada tarefa. A validação independente final terá relatório próprio em validation.md.

### T1 concluída

`python Documentacoes/tools/portal-iteration/migrate.py --check`: PASS, 21 fontes alterados apenas por nomes; baseline dos fontes fornecidos preservado localmente. `npm run typecheck --prefix Documentacoes`: PASS. Asserções locais em `migrate.py:38` comparam conteúdo normalizado contra a migração aprovada; os literais dinâmicos são verificados nas linhas seguintes. Cobertura: PORTAL-26/27/28/30; nenhuma alteração de regra Pascal. Os três fontes novos e a retirada dos fontes antigos de sincronização integram esta migração de identidade; suas páginas entram em T3.

### T2 concluída

Build: PASS, 21 documentos antes dos helpers. check.mjs catalog: PASS; assertions em check.mjs:12-40 comparam grupos, ordem, unicidade, nomes, caminhos e ausencia de paginas e redirecionamentos. PORTAL-09 e PORTAL-29 tambem recebem prova no navegador nas tarefas visuais. Nenhum teste versionado.

### T3 concluída

Build: PASS, 24 documentos. check.mjs helpers: PASS; assertions em check.mjs:41-60 verificam os tres helpers, ordem, caminhos com Sincronizar, busca por seis simbolos, citacoes e ausencia de propriedade de FSincRemoto no processamento. Contratos conferidos por leitura integral dos tres fontes fornecidos, sem execucao de ERP.
