# Realização

A navegação foi centralizada em content/navegacao.ts. Units possui subgrupos IRunner, Infraestrutura compartilhada, Casos de teste e Faturamento. Helpers possui Financeiro e Sincronização, esta reservada para a próxima iteração. Novos grupos e subgrupos podem ser registrados sem alterar o router; as units mantêm suas rotas e citações padronizadas.

O catálogo ganhou oito documentações: processamento financeiro, cache, mapeamento de parâmetros, constantes, ODBC, funções JSON e os dois mapeamentos de borderô. As 15 units com fonte local no inventário AST do Runner estão documentadas, sem tratar as dependências compartilhadas como exclusivas do IRunner. A busca indexa estados e assinaturas dos novos documentos.

Os snippets docgrupo, docsubgrupo e docnavegacao completam o guia de manutenção, totalizando 22. O build confere IDs de grupos, subgrupos e referências do catálogo. A abertura automática segue o caminho completo do grupo da rota; os títulos longos das units quebram linha no drawer.

Os fontes Pascal permanecem sem alteração. As documentações de P39_TDD_REGISTRAR_CASO_TESTE e P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS ficam para a próxima iteração, conforme solicitado.

# Fontes modificados

- Documentacoes/app/content/navegacao.ts
- Documentacoes/app/navigation.ts
- Documentacoes/app/models/documentacao.ts
- Documentacoes/app/content/validarCatalogo.ts
- Documentacoes/app/components/NavigationGroup.ts
- Documentacoes/app/content/units/catalogo.ts
- Documentacoes/app/content/units/criarDocumentoUnit.ts
- Documentacoes/app/content/units/*.ts (classificação e oito documentações novas)
- Documentacoes/app/content/guias/autoria.ts
- Documentacoes/app/styles/portal.css
- Documentacoes/app/README.md
- .vscode/documentacao.code-snippets

# p/ teste

1. Expanda Units e confira IRunner, Infraestrutura compartilhada, Casos de teste e Faturamento.
2. Confira parâmetros e cache em IRunner; constantes, ODBC e funções JSON em Infraestrutura compartilhada.
3. Expanda Helpers → Financeiro e abra os mapeamentos de borderô. Confira estados globais e assinaturas.
4. Busque CDSCadastroPagamento ou MapearBordero para encontrar o helper responsável.
5. Recarregue a rota de uma unit e confira a abertura dos grupos correspondentes, inclusive no celular.
6. Expanda Sincronização e confira a indicação da próxima iteração, sem páginas artificiais de helpers ainda pendentes.
7. Use docgrupo e docsubgrupo no registro central e docnavegacao na página ou em criarDocumentoUnit. IDs inexistentes devem ser rejeitados pelo build.

Validação: lint, TypeScript strict, build de 31 documentos, cobertura dos fontes locais do AST, IDs inválidos, grupo adicional sem mudança no router, busca, snippets compilados e navegação no navegador com recarga e mobile. Os testes auxiliares continuam locais e ignorados pelo Git.

# O que há de novo

A navegação organiza o catálogo de units por responsabilidade e oferece uma área própria para helpers, preparada para crescer na próxima iteração.
