# Ajustes do preview e mapa de migração

## Problem Statement

O preview precisa de sombra cinza no overlay, contexto nos cards e nomes completos dos mapeamentos. O mantenedor também precisa saber quais cadastros e referências reais do TDD acompanhar na migração.

## Out of Scope

Não executar Pascal, alterar lógica de testes, publicar cadastros ERP/TekStore, criar PR ou enviar commits ao remoto. Testes e ferramentas permanecem locais e ignorados.

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Sombra | Fundo cinza com alpha de 0.48; spinner e mensagens opacos. | Corresponde ao efeito solicitado sem reduzir a opacidade do indicador. | Pedido do usuário; intensidade definida nesta implementação. |
| Cards | Exibir grupo/subgrupo e tipo Unit ou Processamento em campos separados. | O usuário pediu ambas as diferenciações. | Sim. |
| Identidade dos mapeamentos | P39_TDD_FIN_MAPEAMENTO_BORDERO_PAGAMENTO e P39_TDD_FIN_MAPEAMENTO_BORDERO_RECEBIMENTO em arquivo, unit, título, menu e rota. | Nome real, sem transformações cosméticas ou aliases. | Sim. |
| Levantamento | Examinar todos os Pascal locais, distinguindo uses de comentário, qualificação e carregamento por string. | Não há inventário do ERP remoto disponível nesta tarefa. | Premissa explícita. |

**Open questions:** none.

## User Stories

### P1: Refinar a apresentação

**Acceptance Criteria**:

1. The overlay SHALL aplicar fundo `rgb(71 85 105 / 48%)`, preservando opacidade integral do spinner e contraste da mensagem de erro. (PREVIEW-01)
2. The cards SHALL mostrar os títulos de grupo e subgrupo derivados do registro de navegação e distinguir explicitamente Unit de Processamento por metadado, sem inferir nomes. (PREVIEW-02)

### P1: Completar a migração com rastreabilidade

**Acceptance Criteria**:

1. The documentation and local sources SHALL usar os dois nomes P39_TDD_FIN_MAPEAMENTO_BORDERO definidos acima, incluindo arquivos, referências, títulos, rotas e inventário canônico. (PREVIEW-03)
2. The contribution guide SHALL listar as onze identidades renomeadas desde o início da iteração, os consumidores locais em uses e as referências dinâmicas que precisam de correção no ERP, com Mermaid canônico e ressalva de alcance local. (PREVIEW-04)

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| PREVIEW-01 | Apresentação | Execute | Verified |
| PREVIEW-02 | Apresentação | Execute | Verified |
| PREVIEW-03 | Migração | Execute | Verified |
| PREVIEW-04 | Migração | Execute | Verified |

## Execution Plan

1. Aplicar a sombra do overlay; verificar alpha no navegador; commit local.
2. Enriquecer cards por navegação e metadado explícito de tipo; verificar card de processamento e card de mapeamento; commit local.
3. Renomear os dois mapeamentos, atualizar referências/grafo e publicar o inventário de impacto no guia; verificar build, consumidores e navegador; commit local.

Design inline: reutilizar o registro de navegação, os chips Vuetify e o contrato criarDocumentoUnit. Criar metadado de tipo apenas para distinguir processamentos; nomes dos mapeamentos são literais canônicos. Preservar preview na porta atual. Encerrar com revisão independente TLC proporcional à documentação.

## Evidências de implementação

- Overlay e cards: browser-homologacao.mjs verifica alpha 0.48, spinner opaco, grupo/subgrupo e dois processamentos com metadado explícito.
- Migração: check-homologacao.mjs verifica identidades literais dos dois mapeamentos, 11 renomeações, consumidores e carregamentos dinâmicos; compara os fontes com o commit 43a8958, normalizando somente CRLF/LF.
- Guia: navegador confirmou tabela com 11 linhas, links canônicos e Mermaid renderizado em autoria/migracao-nomes.
- Gates: npm run check e build aprovados; 24 documentos. 22 snippets e modelos em strict aprovados. Ferramentas permanecem ignoradas.
- Nenhum push, PR, execução Pascal ou alteração de cadastro externo.
