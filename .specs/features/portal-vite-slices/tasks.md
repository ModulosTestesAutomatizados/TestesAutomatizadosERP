# Portal Vite: tarefas

## Execution Protocol

Usar tlc-spec-driven; tarefas sequenciais, gates e commit local por entrega. Usuário aprovou spec e autorizou implementação. Sem push/deploy nesta autorização. Oito entregas coesas, executadas inline; migração do grafo SFC e bundler precisa ser atômica para que o app compile sem dois runtimes.

**Design:** design.md. **Status:** In Progress.

## Test Coverage Matrix

Diretrizes: usuário pediu testes proporcionais e não versionados; .gitignore ignora Documentacoes/tools e tests. ESLint e TypeScript existentes são baseline. Testes locais existentes incluem browser-loading.mjs e check.mjs; os cenários de CDN legados não são contrato da aplicação sem CDN.

| Code Layer | Required Test Type | Coverage Expectation | Location Pattern | Run Command |
| --- | --- | --- | --- | --- |
| Planejamento e baseline | none | Spec e tasks estruturalmente válidas, fontes locais preservadas | .specs/features/portal-vite-slices | validadores TLC |
| Contratos/catálogo | unit | Identidade, unicidade, registro/menu, referência e relevância | Documentacoes/tools/vite-migration | node contratos.mjs |
| SFC e infraestrutura | integration | SFC tipado, bundle sem CDN, falha/recuperação | Documentacoes/tools/vite-migration | check e smoke local |
| Conteúdo editorial | integration | Matriz DOC-01..18 com fonte/evidência, modelos portáteis | Documentacoes/tools/vite-migration | editorial.mjs e revisão de fontes |
| Diagramas/build | integration | Fontes/hash/paths válidos, asset publicado sob base | Documentacoes/tools/vite-migration | npm run build --prefix Documentacoes |
| Autoria | integration | Snippets expandidos tipados e orientação coerente | Documentacoes/tools/vite-migration | snippets.mjs |

## Gate Check Commands

| Gate Level | When to Use | Command |
| --- | --- | --- |
| quick | Contratos/planejamento | python validate_spec.py e validate_tasks.py da skill; node Documentacoes/tools/vite-migration/contratos.mjs para contratos |
| full | Infraestrutura ou conteúdo | npm run check --prefix Documentacoes; bundle Vite ou teste editorial relativo à tarefa; smoke nos componentes alterados |
| build | Integração final | npm run check --prefix Documentacoes; npm run build --prefix Documentacoes; smoke Pages e snippets locais |

## Execution Plan

### Phase 1: Fundação

T1 → T2 → T3

### Phase 2: Conteúdo canônico

T4 → T5 → T6

### Phase 3: Autoria e entrega

T7 → T8

## Task Breakdown

### T1: Registrar baseline e contratos arquiteturais

**Where**: .specs/features/portal-vite-slices/
**What**: Registrar design, plano, baseline de identidade/rotas e manifesto de preservação dos fontes locais em scratch ignorado.
**Depends on**: None
**Requirement**: ARCH-03, ARCH-08, TDD-01.
**Done when**:
- [x] Spec/tasks sem erro; baseline e manifesto de fontes disponíveis sem modificar Pascal.
**Tests**: none
**Gate**: quick
**Commit**: docs: registra plano aprovado da migracao do portal

### T2: Extrair registro editorial por slices

**Where**: Documentacoes/app/
**What**: Reorganizar os documentos/contratos e os exports públicos preservando catálogo, identidade, menu e ranking atuais.
**Depends on**: T1
**Requirement**: ARCH-01, ARCH-02, ARCH-04, ARCH-05, ARCH-07, UX-04.
**Done when**:
- [x] Teste local compara baseline e verifica referências, menu e relevância; tipos aprovados para o grafo atual.
**Tests**: unit
**Gate**: quick
**Commit**: refactor(docs): organiza registro editorial em slices

### T3: Migrar aplicação para SFC e Vite

**Where**: Documentacoes/
**What**: Substituir o grafo compilável da UI e inicialização por SFC script setup com Vite/npm e portas de composição. index.html raiz participa da mesma entrada.
**Depends on**: T2
**Requirement**: VITE-01, VITE-02, VITE-03, VITE-04, VITE-07, ARCH-06, UX-01, UX-02, UX-03, UX-05.
**Done when**:
- [x] Check e bundle Vite passam; smoke do grafo SFC preserva UX sem CDN; verificação de fontes editoriais continua pendente de T4..T6, não é declarada aprovada neste bundle.
**Tests**: integration
**Gate**: full
**Commit**: feat(docs): migra interface para vue sfc e vite

### T4: Atualizar contrato documental do runner

**Where**: Documentacoes/app/components/units/irunner/
**What**: Publicar documentação atual do runner e validador, com fluxo e caso atualizados nas slices proprietárias e tabela de reconciliação.
**Depends on**: T3
**Requirement**: TDD-01, TDD-02, TDD-03, TDD-06; DOC-01..09, DOC-14, DOC-16..17.
**Done when**:
- [ ] Fontes reconciliados, conteúdo/asserts/estados/métricas cobertos por evidência; check e gate editorial passam sem alterar Pascal.
**Tests**: integration
**Gate**: full
**Commit**: docs: atualiza responsabilidades do runner estabilizado

### T5: Atualizar fonte única JSON e defaults

**Where**: Documentacoes/app/components/helpers/sincronizacao/
**What**: Documentar sincronização atual, seus seis argumentos, falhas e três modelos JSON portáteis, sem duplicar páginas.
**Depends on**: T4
**Requirement**: TDD-02, TDD-04; DOC-10..13.
**Done when**:
- [ ] Tabela cobre ausente/vazio/tipo inválido; exemplos completos são copiáveis, versionados e não dependem de massa ignorada; check e teste editorial passam.
**Tests**: integration
**Gate**: full
**Commit**: docs: documenta fonte json unica e defaults da sincronizacao

### T6: Integrar fontes canônicas ao build e Pages

**Where**: Documentacoes/config/
**What**: Validar/copiar Mermaid e AST reconciliados pelo build Vite e integrar o workflow existente sem perder as validações editoriais.
**Depends on**: T5
**Requirement**: VITE-05, VITE-06, VITE-08, TDD-05; DOC-15, DOC-18.
**Done when**:
- [ ] Check/build completo passam; rejeição de fonte/hash incorreto demonstrada em cópia; recursos servem sob prefixo, nenhum conteúdo privado copiado.
**Tests**: integration
**Gate**: build
**Commit**: build(docs): valida fontes canonicas no portal vite

### T7: Entregar autoria e skill do projeto

**Where**: .agents/skills/contribuir-documentacao/
**What**: Criar skill e alinhar guia/snippets à estrutura final, com expansão de exemplos representativos.
**Depends on**: T6
**Requirement**: AUTHOR-01, AUTHOR-02, AUTHOR-03, AUTHOR-04.
**Done when**:
- [ ] Exemplos de SFC, documento/unit, grupo/estado/JSON/diagrama passam pelos contratos e tipos; guia e skill usam paths reais sem APIs CDN.
**Tests**: integration
**Gate**: build
**Commit**: docs: ensina contribuicao com slices sfc e snippets

### T8: Verificar entrega e registrar evidências

**Where**: .specs/features/portal-vite-slices/
**What**: Consolidar cobertura/evidências e conferir artefato Pages desktop/mobile, contratos e preservação dos fontes antes do verificador independente.
**Depends on**: T7
**Requirement**: AUTHOR-05 e integração dos 32 critérios/DOC-01..18.
**Done when**:
- [ ] Gates finais registrados sem tools/testes versionados; relatório e handoff fiéis ao resultado, seguidos por revisão independente e sensor.
**Tests**: integration
**Gate**: build
**Commit**: docs: registra verificacao da migracao do portal

## Diagram-Definition Cross-Check

T1→T2→T3; T4→T5→T6; T7→T8 conferem com Depends on. Dependências entre fases T3→T4 e T6→T7 respeitam a ordem.

## Granularidade e compilação

T2 é uma única transformação do registro editorial, preservada por comparação de baseline. T3 é a migração do grafo compilável da aplicação; separar componentes de seu compilador deixaria o portal sem entry point utilizável. T4/T5 são mudanças editoriais coesas, preservando o leitor. Caminhos Where indicam donos; arquivos consumidores necessários à integração são listados no diário de execução de cada tarefa. Não se trata de oito componentes independentes.
