# Portal Vite: tarefas

## Execution Protocol

Usar tlc-spec-driven; tarefas sequenciais, gates e commit local por entrega. Usuário aprovou spec e autorizou implementação. Sem push/deploy nesta autorização. Oito entregas coesas, executadas inline; migração do grafo SFC e bundler precisa ser atômica para que o app compile sem dois runtimes.

**Design:** design.md. **Status:** Complete local; revisão independente PASS em validation.md, sem publicação.

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

### Phase 2: Autoria independente

T7

### Phase 3: Conteúdo canônico e entrega

T4 → T5 → T6 → T8

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
- [x] Fontes reconciliados, conteúdo/asserts/estados/métricas cobertos por evidência; check e gate editorial passam sem alterar Pascal.
**Tests**: integration
**Gate**: full
**Commit**: docs: atualiza responsabilidades do runner estabilizado

### T5: Atualizar fonte única JSON e defaults

**Where**: Documentacoes/app/components/helpers/sincronizacao/
**What**: Documentar sincronização atual, seus seis argumentos, falhas e três modelos JSON portáteis, sem duplicar páginas.
**Depends on**: T4
**Requirement**: TDD-02, TDD-04; DOC-10..13.
**Done when**:
- [x] Tabela cobre ausente/vazio/tipo inválido; exemplos completos são copiáveis, versionados e não dependem de massa ignorada; check e teste editorial passam.
**Tests**: integration
**Gate**: full
**Commit**: docs: documenta fonte json unica e defaults da sincronizacao

### T6: Integrar fontes canônicas ao build e Pages

**Where**: Documentacoes/config/
**What**: Validar/copiar Mermaid e AST reconciliados pelo build Vite e integrar o workflow existente sem perder as validações editoriais.
**Depends on**: T5
**Requirement**: VITE-05, VITE-06, VITE-08, TDD-05; DOC-15, DOC-18.
**Done when**:
- [x] Check/build completo passam; rejeição de fonte/hash incorreto demonstrada em cópia; recursos servem sob prefixo, nenhum conteúdo privado copiado.
**Tests**: integration
**Gate**: build
**Commit**: build(docs): valida fontes canonicas no portal vite

### T7: Entregar autoria e skill do projeto

**Where**: .agents/skills/contribuir-documentacao/
**What**: Criar skill e alinhar guia/snippets à estrutura final, com expansão de exemplos representativos.
**Depends on**: T3
**Requirement**: AUTHOR-01, AUTHOR-02, AUTHOR-03, AUTHOR-04.
**Done when**:
- [x] Exemplos de SFC, documento/unit, grupo/estado/JSON/diagrama passam pelos contratos e tipos; guia e skill usam paths reais sem APIs CDN.
**Tests**: integration
**Gate**: build
**Commit**: docs: ensina contribuicao com slices sfc e snippets

### T8: Verificar entrega e registrar evidências

**Where**: .specs/features/portal-vite-slices/
**What**: Consolidar cobertura/evidências e conferir artefato Pages desktop/mobile, contratos e preservação dos fontes antes do verificador independente.
**Depends on**: T6, T7
**Requirement**: AUTHOR-05 e integração dos 32 critérios/DOC-01..18.
**Done when**:
- [x] Gates finais registrados sem tools/testes versionados; relatório e handoff fiéis ao resultado, seguidos por revisão independente e sensor.
**Tests**: integration
**Gate**: build
**Commit**: docs: registra verificacao da migracao do portal

## Diagram-Definition Cross-Check

T1→T2→T3; T4→T5→T6→T8 conferem com Depends on. T7 depende de T3; T8 também depende de T7. Autoria foi antecipada porque independe dos fontes Pascal pendentes; o bundle da tarefa não declara verificação editorial de T6.

## Granularidade e compilação

T2 é uma única transformação do registro editorial, preservada por comparação de baseline. T3 é a migração do grafo compilável da aplicação; separar componentes de seu compilador deixaria o portal sem entry point utilizável. T4/T5 são mudanças editoriais coesas, preservando o leitor. Caminhos Where indicam donos; arquivos consumidores necessários à integração são listados no diário de execução de cada tarefa. Não se trata de oito componentes independentes.

## Evidência T6

Check e build Vite passaram. Asset-gate local rejeita alteração de hash, caminho com capitalização errada e fonte ausente, publicando somente assets permitidos. Smoke do artefato no prefixo Pages carrega os Mermaids canônicos, renderiza todos os diagramas do fluxo, links e controles sem CDN. O workflow existente já chama check/build e usa a saída Vite; suas restrições de publicação permanecem.

Inventários runner e sincronização foram regenerados com linhas, hashes e uses locais. Referências remotas não resolvidas e carga dinâmica são explícitas. Atualização posterior de TDD_RUN_LOGS fornecida pelo usuário foi incorporada sem alterar seus bytes: RegistrarLog acumula sempre e FModoDebug controla exibição. Chamadas antigas nos demais Pascal são limitações documentadas.

| Critério | Evidência local e asserção | Resultado |
| --- | --- | --- |
| T6: integridade e cópia restrita | tools/vite-migration/asset-gate.mjs:25, assert.rejects por hash; linhas 27/29 por capitalização/ausência; linha 23 compara chaves publicadas | Passou |
| T6: recursos sob base | tools/vite-migration/native.mjs:64, SVGs renderizados = diagramas registrados; linha 65 fallback = 0; linha 76 requisições externas/erros = [] | Passou |
| T6: compilação | npm run check e npm run build --prefix Documentacoes, saídas zero | Passou |

As verificações derivam de VITE-05/08, TDD-05 e done-when T6; não executam ERP. Os scripts citados permanecem ignorados conforme instrução do usuário. A revisão independente T8 ainda deve confrontar os 32 critérios.

## Evidência T8 e requisitos adicionais

Gates locais: ESLint/vue-tsc/tsc-config, build Vite completo, editorial.mjs, sync-check.mjs, asset-gate.mjs e snippets.mjs passaram. native.mjs executa um smoke integrado do artefato no prefixo Pages com requests externas bloqueadas: skeleton/inert, 27 cards, rota e refresh, busca, clearable, tema salvo, terminal, mobile/movimento reduzido, 404 interna e falha inicial. Na mesma passagem confere quatro moldes, recuperação de leitura, todos os diagramas do fluxo, links, orientação e zoom. Esses testes não são versionados nem executam o ERP.

O contrato novo de LOGS tem assinatura conferida contra Pascal e símbolos; RegistrarLog encontra TDD_RUN_LOGS como primeiro resultado. FModoDebug encontra a página proprietária. O manifesto de bytes recebido permanece idêntico, exceto LOGS atualizado pelo próprio usuário e incorporado após leitura.

Requisitos simples posteriores foram aplicados diretamente: temas claro/escuro Vuetify, persistência guardada e preferência do sistema; busca VTextField clearable com null tratado. Vuetify foi atualizado à versão estável 4.2.6 conforme pedido de latest, com check e smoke aprovados. Mermaid acompanha o tema; tipografia e identidade foram preservadas.

O artefato contém apenas entrada/chunks/fontes/favicon, diagramas/inventários e os quatro moldes selecionados. Não inclui .specs nem árvore Pascal privada. O workflow existente já valida e publica a saída correta. Não houve execução do Actions ou homologação Linux nesta sessão; capitalização por segmentos e hashes CRLF/LF são validados localmente. Revisão TLC independente inicia após este commit; status de implementação não equivale a parecer PASS.

Fechamento: revisão independente PASS em validation.md, range 5999145..a8a2a0d. Check/build, sete scripts e sensor 1/1 passaram. validate_state retornou zero erros. Limites Linux/Actions/ERP e observação cosmética constam no parecer. Nenhum tool/teste foi versionado.
