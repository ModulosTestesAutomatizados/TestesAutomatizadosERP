# Relatório de serviço

## Realização

Carregamento inicial com overlay, progresso e skeleton nativos do Vuetify, saída suave e respeito ao movimento reduzido. Roteiro de migração retirado do guia público e mantido como Markdown de desenvolvimento. Imagem fornecida usada como favicon em caminho compatível com GitHub Pages.

## Fontes modificados

- .specs/features/portal-loading-vuetify/spec.md
- Documentacoes/app/README.md
- Documentacoes/app/assets/faviconTDD.jpg
- Documentacoes/app/components/AppLayout.ts
- Documentacoes/app/components/PortalLoading.ts
- Documentacoes/app/content/guias/autoria.ts
- Documentacoes/app/main.ts
- Documentacoes/app/start.ts
- Documentacoes/app/styles/portal.css
- Documentacoes/config/build.mjs
- Documentacoes/config/preview.mjs
- docs/MAPEAMENTO_AST_USES_UNITS/README.md
- docs/MAPEAMENTO_AST_USES_UNITS/manutencao-migracao-units/impacto-renomeacao.md
- docs/assets/emDesenvolvimento/MIGRACAO_NOMES_UNITS_TDD.md
- index.html

## p/ teste

1. Abra http://127.0.0.1:57929/TestesAutomatizadosERP/ e atualize a página para observar o carregamento e o ícone da aba.
2. Abra uma documentação diretamente e repita em tela estreita; confira o carregamento e a leitura após a saída do overlay.
3. Confira que Contribuir não apresenta Migração de nomes. O roteiro está em docs/assets/emDesenvolvimento/MIGRACAO_NOMES_UNITS_TDD.md.

Lint, tipos, build e cenários de navegador passaram. Revisão independente: 8/8 critérios; detalhes e limites em validation.md. Testes locais permanecem ignorados. Nenhuma publicação remota realizada.

## O que há de novo

A documentação ganhou carregamento visual mais suave e seu favicon. O roteiro de manutenção dos nomes agora fica junto dos arquivos de desenvolvimento.
