# Ajustes de homologação do portal

## Realização

Aplicada sombra cinza translúcida ao loading. Cards apresentam grupo/subgrupo e distinguem Unit de Processamento por metadado explícito. Mapeamentos receberam FIN_MAPEAMENTO_ em seus nomes reais. O guia de contribuição agora lista as onze renomeações cumulativas, consumidores em uses e carregamentos por nome com Mermaid canônico.

## Fontes modificados

- `.specs/features/portal-homologacao-ajustes/migracao-units.md`
- `.specs/features/portal-homologacao-ajustes/spec.md`
- `.vscode/documentacao.code-snippets`
- `Documentacoes/app/components/RedirectCard.ts`
- `Documentacoes/app/content/guias/autoria.ts`
- `Documentacoes/app/content/units/catalogo.ts`
- `Documentacoes/app/content/units/criarDocumentoUnit.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-mapeamento-bordero-pagamento.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-mapeamento-bordero-recebimento.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-pagamento-recebimento.ts`
- `Documentacoes/app/content/units/p39-tdd-fin-processamento.ts`
- `Documentacoes/app/content/units/p39-tdd-processamento-sincronizacao.ts`
- `Documentacoes/app/models/documentacao.ts`
- `Documentacoes/app/navigation.ts`
- `Documentacoes/app/styles/portal.css`
- `docs/MAPEAMENTO_AST_USES_UNITS/autoria/impacto-renomeacao.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO.drawio`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/REFACTOR_TDD_FINANCEIRO.drawio`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/REFACTOR_TDD_FINANCEIRO.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/REFACTOR_TDD_FIN_FLUXO_COMPLETO.drawio`
- `docs/MAPEAMENTO_AST_USES_UNITS/historico/financeiro/REFACTOR_TDD_FIN_FLUXO_COMPLETO.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.ast.json`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/P39_TDD_IRUNNER.md`
- `docs/assets/casosTestesFinanceiro/P39_TDD_FIN_MAPEAMENTO_BORDERO_PAGAMENTO.pas`
- `docs/assets/casosTestesFinanceiro/P39_TDD_FIN_MAPEAMENTO_BORDERO_RECEBIMENTO.pas`
- `docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas`

## p/ teste

1. Atualize o preview em http://127.0.0.1:57929/TestesAutomatizadosERP/ e confira os rótulos de navegação nos cards e a etiqueta Processamento nas duas entradas de processamento.
2. Com rede lenta, observe o loading de tela inteira com sombra cinza. A indicação permanece opaca; falhas continuam oferecendo recarga.
3. Abra Mapeamentos → Financeiro e confira os nomes P39_TDD_FIN_MAPEAMENTO_BORDERO_PAGAMENTO e P39_TDD_FIN_MAPEAMENTO_BORDERO_RECEBIMENTO no menu, card e página.
4. Abra Contribuir → Migração de nomes. Confira as onze linhas, consumidores e Mermaid. Os dados abrangem somente os fontes locais; os cadastros reais do ERP/TekStore ainda precisam ser conferidos antes de executar.

## O que há de novo

Cards com contexto e tipo do artefato, loading com sombra e nomes completos para os mapeamentos. A contribuição passou a incluir um roteiro para acompanhar a migração dos nomes no TDD.
