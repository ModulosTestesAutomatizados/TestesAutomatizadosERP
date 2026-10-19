# Implementação do portal Vue/Vite

## Realização

Portal migrado para Vue SFC/script setup TypeScript, dependências npm e Vite, com organização por feature e leitor compartilhado. Atualizados contratos do IRunner, estados/métricas, sincronização, nomes e referências conforme os fontes recebidos. Moldes canônicos podem ser copiados diretamente da documentação. Temas claro/escuro e limpeza nativa da busca estão disponíveis. Gates locais e revisão independente final passaram: 32 critérios próprios, DOC-01..18 e sensor de integridade 1/1. Parecer completo em validation.md, com limites explícitos.

## Fontes modificados

Lista extraída do diff Git desde 5999145 (inclui remoções e fontes fornecidos pelo usuário):

- `.agents/skills/contribuir-documentacao/SKILL.md`
- `.gitignore`
- `.specs/features/documentacao-estabilizacao-tdd/INICIAR-OUTRA-SESSAO.md`
- `.specs/features/documentacao-estabilizacao-tdd/inventario-fontes.md`
- `.specs/features/documentacao-estabilizacao-tdd/spec.md`
- `.specs/features/portal-vite-slices/arquitetura-proposta.md`
- `.specs/features/portal-vite-slices/context.md`
- `.specs/features/portal-vite-slices/design.md`
- `.specs/features/portal-vite-slices/incorporacao-irunner.md`
- `.specs/features/portal-vite-slices/reconciliacao-fontes.md`
- `.specs/features/portal-vite-slices/referencias/estabilizacao/inventario-fontes.md`
- `.specs/features/portal-vite-slices/referencias/estabilizacao/proveniencia.md`
- `.specs/features/portal-vite-slices/referencias/estabilizacao/spec-origem.md`
- `.specs/features/portal-vite-slices/relatorio-servico.md`
- `.specs/features/portal-vite-slices/spec.md`
- `.specs/features/portal-vite-slices/tasks.md`
- `.vscode/documentacao.code-snippets`
- `Documentacoes/app/App.vue`
- `Documentacoes/app/README.md`
- `Documentacoes/app/catalogo/grupos.ts`
- `Documentacoes/app/catalogo/index.ts`
- `Documentacoes/app/catalogo/redirecionamentos.ts`
- `Documentacoes/app/catalogo/referencias.ts`
- `Documentacoes/app/catalogo/units.ts`
- `Documentacoes/app/catalogo/validarCatalogo.ts`
- `Documentacoes/app/components/AppLayout.ts`
- `Documentacoes/app/components/DocNotice.ts`
- `Documentacoes/app/components/DocSection.ts`
- `Documentacoes/app/components/DocumentSearch.ts`
- `Documentacoes/app/components/DocumentToc.ts`
- `Documentacoes/app/components/ReferenceText.ts`
- `Documentacoes/app/components/UnitReference.ts`
- `Documentacoes/app/components/arquitetura/index.ts`
- `Documentacoes/app/components/arquitetura/irunner/conteudo/runner.ts`
- `Documentacoes/app/components/arquitetura/irunner/index.ts`
- `Documentacoes/app/components/casos-de-teste/conteudo/p39-tdd-fat-pedido-venda.ts`
- `Documentacoes/app/components/casos-de-teste/conteudo/tdd-fin-financeiro.ts`
- `Documentacoes/app/components/casos-de-teste/index.ts`
- `Documentacoes/app/components/contribuir/conteudo/autoria.ts`
- `Documentacoes/app/components/contribuir/conteudo/moldes.ts`
- `Documentacoes/app/components/contribuir/index.ts`
- `Documentacoes/app/components/descoberta/DocumentSearch.vue`
- `Documentacoes/app/components/descoberta/NavigationGroup.vue`
- `Documentacoes/app/components/descoberta/RedirectCard.vue`
- `Documentacoes/app/components/descoberta/index.ts`
- `Documentacoes/app/components/descoberta/navigation.ts`
- `Documentacoes/app/components/descoberta/search.ts`
- `Documentacoes/app/components/helpers/gerais/conteudo/p39-tdd-funcoes-json.ts`
- `Documentacoes/app/components/helpers/gerais/index.ts`
- `Documentacoes/app/components/helpers/index.ts`
- `Documentacoes/app/components/helpers/sincronizacao/conteudo/p39-tdd-processamento-sincronizacao.ts`
- `Documentacoes/app/components/helpers/sincronizacao/conteudo/p39-tdd-registrar-caso-teste.ts`
- `Documentacoes/app/components/helpers/sincronizacao/conteudo/p39-tdd-sincronizar-casos-teste-registrados.ts`
- `Documentacoes/app/components/helpers/sincronizacao/index.ts`
- `Documentacoes/app/components/leitura/CodeBlock.vue`
- `Documentacoes/app/components/leitura/CodigoFonte.vue`
- `Documentacoes/app/components/leitura/DocBlocks.vue`
- `Documentacoes/app/components/leitura/DocNotice.vue`
- `Documentacoes/app/components/leitura/DocSection.vue`
- `Documentacoes/app/components/leitura/DocTable.vue`
- `Documentacoes/app/components/leitura/DocumentToc.vue`
- `Documentacoes/app/components/leitura/DocumentoView.vue`
- `Documentacoes/app/components/leitura/MermaidDiagram.vue`
- `Documentacoes/app/components/leitura/ReferenceText.vue`
- `Documentacoes/app/components/leitura/UnitReference.vue`
- `Documentacoes/app/components/leitura/diagrams.ts`
- `Documentacoes/app/components/leitura/index.ts`
- `Documentacoes/app/components/leitura/useDocumentSections.ts`
- `Documentacoes/app/components/leitura/useReferenciasUnits.ts`
- `Documentacoes/app/components/mapeamentos/financeiro/conteudo/p39-tdd-fin-mapeamento-componentes-bordero-pagamento.ts`
- `Documentacoes/app/components/mapeamentos/financeiro/conteudo/p39-tdd-fin-mapeamento-componentes-bordero-recebimento.ts`
- `Documentacoes/app/components/mapeamentos/financeiro/index.ts`
- `Documentacoes/app/components/mapeamentos/index.ts`
- `Documentacoes/app/components/portal/AppLayout.vue`
- `Documentacoes/app/components/portal/DocumentRoute.vue`
- `Documentacoes/app/components/portal/HomeView.vue`
- `Documentacoes/app/components/portal/NotFoundView.vue`
- `Documentacoes/app/components/portal/PortalLoading.vue`
- `Documentacoes/app/components/portal/index.ts`
- `Documentacoes/app/components/portal/preferenciaTema.ts`
- `Documentacoes/app/components/portal/useTema.ts`
- `Documentacoes/app/components/units/constantes/conteudo/p39-tdd-constantes.ts`
- `Documentacoes/app/components/units/constantes/index.ts`
- `Documentacoes/app/components/units/index.ts`
- `Documentacoes/app/components/units/irunner/conteudo/p39-tdd-fin-processamento-financeiro.ts`
- `Documentacoes/app/components/units/irunner/conteudo/p39-tdd-run-asserts.ts`
- `Documentacoes/app/components/units/irunner/conteudo/p39-tdd-run-modulo.ts`
- `Documentacoes/app/components/units/irunner/conteudo/p39-tdd-run-validar-resultado.ts`
- `Documentacoes/app/components/units/irunner/conteudo/tdd-run-finished.ts`
- `Documentacoes/app/components/units/irunner/conteudo/tdd-run-irunner.ts`
- `Documentacoes/app/components/units/irunner/conteudo/tdd-run-logs.ts`
- `Documentacoes/app/components/units/irunner/conteudo/tdd-run-runner.ts`
- `Documentacoes/app/components/units/irunner/conteudo/tdd-run-started.ts`
- `Documentacoes/app/components/units/irunner/conteudo/tdd-run-unit-base-irunner.ts`
- `Documentacoes/app/components/units/irunner/index.ts`
- `Documentacoes/app/components/units/persistencia/conteudo/p39-tdd-odbc.ts`
- `Documentacoes/app/components/units/persistencia/index.ts`
- `Documentacoes/app/components/units/setup/conteudo/p39-tdd-cache.ts`
- `Documentacoes/app/components/units/setup/conteudo/p39-tdd-casos-de-teste.ts`
- `Documentacoes/app/components/units/setup/conteudo/p39-tdd-parametro-mapeamento.ts`
- `Documentacoes/app/components/units/setup/conteudo/p39-tdd-parametro.ts`
- `Documentacoes/app/components/units/setup/index.ts`
- `Documentacoes/app/config.ts`
- `Documentacoes/app/content/catalogo.ts`
- `Documentacoes/app/content/estrutura/runner.ts`
- `Documentacoes/app/content/guias/autoria.ts`
- `Documentacoes/app/content/units/catalogo.ts`
- `Documentacoes/app/content/units/p39-tdd-base-unit-irunner.ts`
- `Documentacoes/app/content/units/p39-tdd-cache.ts`
- `Documentacoes/app/content/units/p39-tdd-casos-de-teste.ts`
- `Documentacoes/app/content/units/p39-tdd-constantes.ts`
- `Documentacoes/app/content/units/p39-tdd-fat-pedido-venda.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-mapeamento-bordero-pagamento.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-mapeamento-bordero-recebimento.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-pagamento-recebimento.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-processamento.ts`
- `Documentacoes/app/content/units/p39-tdd-finished.ts`
- `Documentacoes/app/content/units/p39-tdd-funcoes-json.ts`
- `Documentacoes/app/content/units/p39-tdd-irunner.ts`
- `Documentacoes/app/content/units/p39-tdd-logs.ts`
- `Documentacoes/app/content/units/p39-tdd-modulo.ts`
- `Documentacoes/app/content/units/p39-tdd-odbc.ts`
- `Documentacoes/app/content/units/p39-tdd-parametro-mapeamento.ts`
- `Documentacoes/app/content/units/p39-tdd-parametros.ts`
- `Documentacoes/app/content/units/p39-tdd-processamento-sincronizacao.ts`
- `Documentacoes/app/content/units/p39-tdd-registrar-caso-teste.ts`
- `Documentacoes/app/content/units/p39-tdd-runner.ts`
- `Documentacoes/app/content/units/p39-tdd-sincronizar-casos-teste-registrados.ts`
- `Documentacoes/app/content/units/p39-tdd-started.ts`
- `Documentacoes/app/contracts/criarDocumentoUnit.ts`
- `Documentacoes/app/contracts/documentacao.ts`
- `Documentacoes/app/contracts/identidade.ts`
- `Documentacoes/app/contracts/referencias.ts`
- `Documentacoes/app/diagrams.ts`
- `Documentacoes/app/iniciar.ts`
- `Documentacoes/app/main.ts`
- `Documentacoes/app/pages/NotFoundPage.ts`
- `Documentacoes/app/router.ts`
- `Documentacoes/app/start.ts`
- `Documentacoes/app/styles/portal.css`
- `Documentacoes/app/templates/novo-documento.ts`
- `Documentacoes/app/types/runtime.d.ts`
- `Documentacoes/app/types/vite-env.d.ts`
- `Documentacoes/app/unitReferences.ts`
- `Documentacoes/config/README.md`
- `Documentacoes/config/build.mjs`
- `Documentacoes/config/lint-templates.mjs`
- `Documentacoes/config/portal-assets.ts`
- `Documentacoes/config/preview.mjs`
- `Documentacoes/config/tsconfig.json`
- `Documentacoes/package-lock.json`
- `Documentacoes/package.json`
- `Documentacoes/tsconfig.json`
- `Documentacoes/vite.config.ts`
- `docs/MAPEAMENTO_AST_USES_UNITS/README.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/p39-tdd-registrar-caso-teste/fonte-unica.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/p39-tdd-registrar-caso-teste/sincronizacao.ast.json`
- `docs/MAPEAMENTO_AST_USES_UNITS/p39-tdd-registrar-caso-teste/sincronizacao.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.ast.json`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_RUN_IRUNNER.ast.json`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_RUN_IRUNNER.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/estado.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/estados.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/falhas.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/geracao.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/lote.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/metricas.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/persistencia-modelo.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/persistencia.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/responsabilidades.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/tentativa.md`
- `docs/MER.md`
- `docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA.pas`
- `docs/assets/casosTestesFinanceiro/P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.pas`
- `docs/assets/casosTestesFinanceiro/P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.pas`
- `docs/assets/configuracoesGerais/P39_TDD_ASSERTS.pas`
- `docs/assets/configuracoesGerais/P39_TDD_CACHE.pas`
- `docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas`
- `docs/assets/configuracoesGerais/P39_TDD_CONSTANTES.pas`
- `docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas`
- `docs/assets/configuracoesGerais/P39_TDD_MODULO.pas`
- `docs/assets/configuracoesGerais/P39_TDD_ODBC.pas`
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_PROCESSAMENTO_SINCRONIZACAO.pas`
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas`
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas`
- `docs/assets/configuracoesGerais/TDD_ASSERTS.pas`
- `docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO.pas`
- `docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO_MAPEAMENTO.pas`
- `docs/assets/emDesenvolvimento/MIGRACAO_NOMES_UNITS_TDD.md`
- `docs/assets/emDesenvolvimento/P39_TDD_RUN_VALIDAR_RESULTADO.pas`
- `docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_BASE_UNIT_IRUNNER.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_ASSERTS.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_MODULO.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_RUN_FINISHED.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_RUN_IRUNNER.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_RUN_LOGS.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_RUN_RUNNER.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_RUN_STARTED.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas`
- `docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO.pas`
- `docs/assets/snippets/TDD_ASSERTS_JSON_MINIMO.json`
- `docs/assets/snippets/TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO.json`
- `docs/assets/snippets/TDD_CASO_TESTE_MODELO_JSON.json`
- `docs/assets/snippets/formatoTDDProcedureMainComInstrucoes.pas`
- `index.html`

## p/ teste

1. Execute npm run dev --prefix Documentacoes e abra o endereço impresso com /TestesAutomatizadosERP/.
2. Abra um card, navegue pelos grupos e pelo sumário, atualize a página e confira as citações clicáveis de units.
3. Busque FCDSCasosTestes, RegistrarLog e FModoDebug; confira os donos dos símbolos. Limpe pelo ícone da busca.
4. Alterne o tema e atualize a página: a escolha deve permanecer.
5. Em Contribuir → Moldes, copie JSON/Pascal. No fluxo do Runner, confira diagramas, orientação e zoom. Leia a documentação individual de LOGS e seu aviso de chamadas antigas.

Check, build, smoke desktop/mobile sem CDN, gate editorial/sincronização, fontes/hash e snippets passaram. Nenhum resultado local comprova execução no ERP ou GitHub Actions. Os fontes ainda têm chamadas a RegistrarLogEmModoDebug, discrepância de uses do validador e limite de reexecução da lista de logs; estão documentados e não foram corrigidos no Pascal nesta entrega.

## O que há de novo

Documentação com temas, busca fácil de limpar, moldes copiáveis e conteúdo atualizado do Runner. Novas páginas podem ser incluídas por snippets e pela skill do projeto. Sem push, PR ou publicação nesta iteração.
