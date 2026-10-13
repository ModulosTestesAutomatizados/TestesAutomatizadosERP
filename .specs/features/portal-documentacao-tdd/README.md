# Portal de documentação TDD: planejamento e implementação

Issue: [#22](https://github.com/ModulosTestesAutomatizados/TestesAutomatizadosERP/issues/22).

O design atualizado usa Vue, Vuetify e Vue Router via CDN e recebeu autorização de implementação em 2026-10-13. Consulte [design-vuetify.md](design-vuetify.md), [plano de implementação](implementation-plan.md) e o [guia do portal](../../../Documentacoes/README.md). As análises e escolhas anteriores são preservadas como histórico.

## Ordem de leitura

1. [Análise](analise.md): diff rastreado e arquivos novos, inventário de conteúdos, responsabilidades e divergências com evidências.
2. [Contexto](context.md): pedidos confirmados e defaults propostos.
3. [Issue integral](issue-22.md): body preservado, sem correções editoriais.
4. [Especificação TLC](spec.md): 47 critérios EARS, contrato do snippet, navegação e publicação.
5. [Relatório da entrega documental](relatorio-servico.md): resumo do trabalho e roteiro de revisão.
6. [Design técnico](design.md): versões fixadas, componentes, modelos, navegação, migração e publicação.
7. [Pesquisa de compatibilidade e Pages](evidencias/pesquisa-cdn-pages.md): prova nominal em Chromium e situação do repositório.

## Arquitetura vigente

Portal estático Vue 3 + Vuetify + Vue Router via CDN; `index.html` na raiz apenas como entrada; rotas hash para Pages; componentes e catálogo declarativo em `Documentacoes/app/`; seis snippets para incluir novos documentos sem alterar layout/router. Mapa sintático regenerável em `docs/mapeamentoUses/`.

A refatoração é apresentada como Em desenvolvimento. O legado permanece identificado. Fontes de casos com conteúdo duplicado recebem limite explícito de evidência até sua origem ser verificada.

## Próxima etapa

Concluir as verificações registradas no plano e revisar o portal antes de habilitar ou publicar remotamente o Pages. A pesquisa CDN anterior refere-se a PrimeVue; não comprova a stack atual. O estado remoto deve ser consultado quando a publicação for solicitada.
