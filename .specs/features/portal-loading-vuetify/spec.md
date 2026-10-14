# Carregamento nativo Vuetify

## Problem Statement

O overlay atual é artesanal e desaparece abruptamente quando a documentação fica pronta. Usar os componentes nativos solicitados pelo usuário e dar continuidade visual ao carregamento, incluindo placeholders de conteúdo.

## Out of Scope

Não mudar nomes, navegação ou conteúdo das units; não adicionar backend, dependências ou atrasos a cada navegação. Não publicar PR, push ou deploy. Ferramentas de teste continuam ignoradas.

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Componentes | VOverlay, VProgressCircular e VSkeletonLoader da versão CDN já usada. | Componentes indicados pelo usuário. | Sim. |
| Continuidade | Placeholder estático antes do CDN; passagem ao skeleton Vuetify após montagem. | Vuetify não existe antes de carregar sua própria biblioteca. | Premissa técnica. |
| Tempo mínimo | 650 ms contados da montagem do loading Vuetify; fade de 240 ms na saída. | Evita flash breve sem adicionar atraso depois de uma carga mais lenta. | Ajuste de UX desta implementação. |
| Movimento reduzido | Sem shimmer, rotação ou fade; indicador estático acessível. | Preservar acessibilidade já adotada pelo portal. | Premissa técnica. |

**Open questions:** none.

## User Stories

### P1: Carregamento contínuo e com conteúdo representado

**Acceptance Criteria**:

1. The loading interface SHALL usar VOverlay com scrim, VProgressCircular e VSkeletonLoader reais do Vuetify, removendo o spinner CSS artesanal. (LOADING-01)
2. WHILE a rota inicial não estiver pronta a aplicação SHALL manter o skeleton e bloquear interação com o conteúdo real. (LOADING-02)
3. WHEN a rota inicial ficar pronta THEN a aplicação SHALL manter o loading por pelo menos 650 ms desde sua montagem e revelar o conteúdo com fade de 240 ms, liberando a interação após a saída. (LOADING-03)
4. WHERE movimento reduzido estiver ativo o carregamento SHALL desativar shimmer, rotação e fade sem perder indicação acessível. (LOADING-04)
5. IF uma dependência CDN ou a rota inicial falhar THEN o portal SHALL mostrar mensagem acessível de erro e ação para recarregar, sem indicador indefinido. (LOADING-05)
6. The static artifact SHALL mostrar placeholder antes do Vuetify e skeleton de cards na home ou de artigo em rota documental, com adaptação mobile e navegação posterior sem atraso artificial. (LOADING-06)
7. The contribution guide SHALL remover a seção operacional de migração, mantendo o roteiro somente em docs/assets/emDesenvolvimento/MIGRACAO_NOMES_UNITS_TDD.md fora do catálogo publicado. (LOADING-07)
8. The static artifact SHALL servir o favicon JPEG fornecido pelo usuário em caminho relativo compatível com o prefixo do Pages. (LOADING-08)

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| LOADING-01 | Carregamento | Execute | Verified |
| LOADING-02 | Carregamento | Execute | Verified |
| LOADING-03 | Carregamento | Execute | Verified |
| LOADING-04 | Carregamento | Execute | Verified |
| LOADING-05 | Carregamento | Execute | Verified |
| LOADING-06 | Carregamento | Execute | Verified |
| LOADING-07 | Manutenção | Execute | Verified |
| LOADING-08 | Identidade | Execute | Verified |

## Execution Plan

1. Integrar o componente reutilizável de loading ao ciclo de montagem e rota inicial, ajustar placeholder de bootstrap e estilos; verificar cenários reais no navegador e qualidade; commit local.
2. Encerrar com revisão independente TLC, registrar evidências e manter preview no endereço atual.

Referências consultadas: documentação oficial Vuetify de overlays, progress-circular e skeleton-loaders fornecida pelo usuário, e implementação instalada de Vuetify 4.2.3 para as props, eventos e tipos. Context7 não está disponível nesta sessão.

Steering recebido durante implementação: remover do portal o roteiro de migração (é trabalho dos desenvolvedores) e usar public/faviconTDD.jpg como favicon. Imagem original movida para app/assets para manter os recursos da documentação na aplicação, sem alterações visuais. O Markdown operacional fica fora do catálogo e do artefato publicado.

## Evidências de implementação

Gate local: npm run check e npm run build aprovados, com 24 documentos. browser-loading.mjs passou em bootstrap anterior ao CDN, três componentes Vuetify reais, bloqueio do conteúdo, mínimo de 650ms, fade de 240ms, navegação posterior sem atraso, skeleton de artigo mobile, movimento reduzido e falhas CDN/timeout/rota. A mesma verificação confirma a remoção da seção de migração, o Markdown operacional fora do artefato e o JPEG original servido como image/jpeg sob prefixo Pages. Ferramentas e capturas são locais e ignoradas.
