# Relatório da iteração

## Realização

Aplicada a navegação aprovada, com nomes canônicos nos artefatos, páginas e menu. Documentados os três helpers de sincronização. Removidas páginas e rotas antigas. Implementados loading de tela inteira, truncamento com tooltip, espaço inferior no drawer e rolagem com barras ocultas. Atualizados guia e 22 snippets.

## Fontes modificados

Lista extraída do Git para esta iteração; inclui arquivos excluídos e destinos de renomeação.

- `.specs/features/portal-navegacao-sincronizacao/context.md`
- `.specs/features/portal-navegacao-sincronizacao/design.md`
- `.specs/features/portal-navegacao-sincronizacao/spec.md`
- `.specs/features/portal-navegacao-sincronizacao/tasks.md`
- `.vscode/documentacao.code-snippets`
- `Documentacoes/app/README.md`
- `Documentacoes/app/arquivo/README.md`
- `Documentacoes/app/arquivo/html/casos-de-teste/index.html`
- `Documentacoes/app/arquivo/html/documento-fatura/index.html`
- `Documentacoes/app/arquivo/html/parametros/index.html`
- `Documentacoes/app/arquivo/html/portal-anterior.html`
- `Documentacoes/app/arquivo/html/runner-orquestrador/index.html`
- `Documentacoes/app/arquivo/migracao.md`
- `Documentacoes/app/components/AppLayout.ts`
- `Documentacoes/app/components/NavigationGroup.ts`
- `Documentacoes/app/content/casos/irunner.ts`
- `Documentacoes/app/content/casos/legado.ts`
- `Documentacoes/app/content/casos/pedido-venda.ts`
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
- `Documentacoes/app/content/navegacao.ts`
- `Documentacoes/app/content/units/catalogo.ts`
- `Documentacoes/app/content/units/criarDocumentoUnit.ts`
- `Documentacoes/app/content/units/p39-tdd-base-unit-irunner.ts`
- `Documentacoes/app/content/units/p39-tdd-cache.ts`
- `Documentacoes/app/content/units/p39-tdd-casos-de-teste.ts`
- `Documentacoes/app/content/units/p39-tdd-constantes.ts`
- `Documentacoes/app/content/units/p39-tdd-fat-pedido-venda.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-bordero-pagamento.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-bordero-recebimento.ts`
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
- `Documentacoes/app/content/validarCatalogo.ts`
- `Documentacoes/app/main.ts`
- `Documentacoes/app/redirecionamentos/casos-de-teste/index.html`
- `Documentacoes/app/redirecionamentos/documento-fatura/index.html`
- `Documentacoes/app/redirecionamentos/manifesto.ts`
- `Documentacoes/app/redirecionamentos/parametros/index.html`
- `Documentacoes/app/redirecionamentos/runner-orquestrador/index.html`
- `Documentacoes/app/start.ts`
- `Documentacoes/app/styles/portal.css`
- `Documentacoes/app/templates/novo-documento.ts`
- `Documentacoes/config/README.md`
- `Documentacoes/config/build.mjs`
- `docs/Documentacoes/PEDIDO_DE_VENDA_TESTES_AUTOMATIZADOS.html`
- `docs/MAPEAMENTO_AST_USES_UNITS/README.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/casos-de-teste/cadastro.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/casos-de-teste/datasets.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/casos-irunner/lote.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/casos-legado/entrada.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/cadastro/TDD_CARREGAR_CASO_TESTE.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/P39_TDD_FIN_DUPLICATAS.drawio`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/P39_TDD_FIN_DUPLICATAS.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO.drawio`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/REFACTOR_TDD_FINANCEIRO.drawio`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/REFACTOR_TDD_FINANCEIRO.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/REFACTOR_TDD_FIN_FLUXO_COMPLETO.drawio`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/REFACTOR_TDD_FIN_FLUXO_COMPLETO.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/parametros/aplicacao.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/parametros/escopo.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/parametros/preparacao.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/pedido-venda/P39_TDD_FAT_PEDIDO_VENDA.drawio`
- `docs/MAPEAMENTO_AST_USES_UNITS/pedido-venda/dependencias.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/pedido-venda/execucao.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/piloto-financeiro/dependencias.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/piloto-financeiro/teste.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.ast.json`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_IRUNNER.ast.json`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_IRUNNER.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/responsabilidades.md`
- `docs/assets/casosTestesFaturamento/P39_TDD_FAT_DOCUMENTO_FATURA.pas`
- `docs/assets/casosTestesFinanceiro/P39_TDD_FIN_BORDERO_PAGAMENTO.pas`
- `docs/assets/casosTestesFinanceiro/P39_TDD_FIN_BORDERO_RECEBIMENTO.pas`
- `docs/assets/configuracoesGerais/P39_TDD_CACHE.pas`
- `docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas`
- `docs/assets/configuracoesGerais/P39_TDD_CONSTANTES.pas`
- `docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas`
- `docs/assets/configuracoesGerais/P39_TDD_ODBC.pas`
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_PROCESSAMENTO_SINCRONIZACAO.pas`
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas`
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas`
- `docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETROS.pas`
- `docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO_MAPEAMENTO.pas`
- `docs/assets/configuracoesGerais/sincronizar/persistenciasODBC/P39_TDD_CARREGAR_CASO_TESTE.pas`
- `docs/assets/configuracoesGerais/sincronizar/persistenciasODBC/P39_TDD_REGISTRAR_CASO_TESTE.pas`
- `docs/assets/configuracoesGerais/sincronizar/persistenciasODBC/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas`
- `docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas`
- `docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_BASE_UNIT_IRUNNER.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_FINISHED.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_FIN_PROCESSAMENTO.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_IRUNNER.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_LOGS.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_RUNNER.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_TDD_STARTED.pas`
- `index.html`

## p/ teste

1. Na raiz do worktree, execute npm run dev --prefix Documentacoes e abra o endereço informado no terminal.
2. Confira os seis grupos do menu e abra os três itens de Helpers → Sincronização. Busque FCasoTeste ou FSincRemoto e confira as units responsáveis.
3. Observe o carregamento inicial, os nomes longos em uma linha e o texto completo ao passar o mouse ou usar o teclado. Expanda os grupos e role até Contribuir.
4. Confira a rolagem de página, menu, tabelas e terminais sem barras visíveis. Abra uma página diretamente pelo endereço e repita em tela pequena.
5. Páginas e endereços antigos não devem abrir documentos. Para executar os fontes Pascal renomeados no ERP, primeiro atualize os respectivos cadastros no ERP e na TekStore; isso não foi realizado nesta entrega.

Verificações locais: lint, tipos, build estático com 24 documentos, catálogo e busca, compilação dos modelos de snippets e navegador sob o prefixo do GitHub Pages. Testes e ferramentas permaneceram ignorados pelo Git. Consulte validation.md para a revisão independente e seus limites.

## O que há de novo

A documentação segue o novo mapa e inclui os helpers de sincronização. O menu ficou mais legível e o carregamento ocupa a tela inteira, mantendo a identidade visual do portal.
