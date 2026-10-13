# Realização

A contribuição de TEK-JoaoPauloJaques no PR #20 foi incorporada ao PR do portal, preservando o autor do commit. Os conflitos foram conciliados com os fontes atuais: as melhorias compartilhadas de Casos de Teste e Parâmetros já estavam presentes, e as respectivas versões reorganizadas foram mantidas. Os fontes refatorados de faturamento, as cinco camadas novas, o controle de módulo e os fontes de asserts foram incorporados como referências, sem habilitar sua integração pendente.

O mapa e o Draw.io foram movidos para `pedido-venda/`. O portal ganhou uma página do fluxo refatorado e uma documentação individual de P39_TDD_MODULO. Foi corrigida a aresta do validador para P39_TDD_ASSERTS: o uses do validador está ativo; o uses comentado pertence ao próprio fonte de asserts.

O preview deixou de falhar quando a porta 8080 está ocupada. Ele seleciona uma porta livre automaticamente e informa o endereço com o prefixo do projeto. Uma porta explícita via PORT é respeitada e recebe mensagem clara se não estiver disponível.

# Fontes modificados

- docs/assets/casosTestesFaturamento/*.pas (fontes abrangidos pelo PR #20)
- docs/assets/configuracoesGerais/P39_TDD_MODULO.pas
- docs/assets/configuracoesGerais/P39_TDD_ASSERTS.pas
- docs/assets/configuracoesGerais/TDD_ASSERTS.pas
- docs/MAPEAMENTO_AST_USES_UNITS/pedido-venda/
- docs/MAPEAMENTO_AST_USES_UNITS/README.md
- Documentacoes/app/content/casos/pedido-venda.ts
- Documentacoes/app/content/casos/legado.ts
- Documentacoes/app/content/units/p39-tdd-modulo.ts
- Documentacoes/app/content/units/catalogo.ts
- Documentacoes/app/content/catalogo.ts
- Documentacoes/config/preview.mjs
- Documentacoes/config/README.md
- Documentacoes/app/README.md
- index.html
- .github/workflows/documentacao-pages.yml

# p/ teste

1. Execute `npm run dev --prefix Documentacoes` mesmo com a porta 8080 ocupada e abra o endereço informado.
2. Navegue em Casos de teste → Legado → Pedido de venda — Documento de Fatura. Confira os dois diagramas e as pendências registradas.
3. Clique em P39_TDD_MODULO e busque por FocarModulo para verificar a página específica da unit.
4. Recarregue a página sob `/TestesAutomatizadosERP/` e confira a ausência de erros locais de carregamento.
5. Após o merge, configure Settings → Pages → Source como GitHub Actions e acione manualmente o workflow Documentação · GitHub Pages na branch padrão. O job de deploy confere a configuração do Pages antes de publicar. O preview local não é executado no GitHub Pages.

Verificações: lint, TypeScript strict, build de 21 documentos e carregamento no navegador sob o prefixo Pages. Os testes e as ferramentas auxiliares permanecem locais e ignorados.

# O que há de novo

Pedido de Venda e controle de foco do módulo agora estão acessíveis no portal. O desenvolvimento local continua funcionando quando outra aplicação já utiliza a porta 8080.
