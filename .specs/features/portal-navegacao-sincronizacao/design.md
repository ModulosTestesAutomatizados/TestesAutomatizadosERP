# Desenho da iteração aprovada

## Architecture Overview

Manter Vue, Vuetify via CDN, TypeScript e rotas hash. O catálogo continua sendo a origem de cards, busca, citações e páginas. O registro central de navegação recebe os seis grupos aprovados; cada documento declara sua posição e ordem. Não introduzir rótulo alternativo de unit.

Renomear os fontes locais e as referências de identidade em uma migração coerente. Atualizar os módulos editoriais, o inventário de uses e os diagramas afetados. Não executar operações no ERP, TekStore ou bancos.

Excluir os dez documentos intermediários/históricos fora do mapa e os redirecionamentos numerados. O catálogo final terá 24 documentos: 22 units, Arquitetura e Contribuir. Remover referências internas às páginas excluídas. Históricos TLC permanecem intactos.

## Code Reuse Analysis

- `criarDocumentoUnit`: contrato das três páginas de sincronização, símbolos de busca, assinaturas copiáveis e tabelas de estados.
- `NavigationGroup` e `criarNavegacao`: agrupamento e abertura de ancestrais da rota.
- `CodeBlock`, `DocTable`, busca local e referências de units: sem novos componentes documentais paralelos.
- `start.ts` e `build.mjs`: inserir um overlay HTML/CSS antes de qualquer dependência CDN, removê-lo depois da montagem e mostrar falha com recarga.

## Components

- Overlay: HTML gerado no marcador de status do índice; spinner CSS independente do Vue, nome acessível, redução de movimento e ação de recarga em falha. `#app` permanece inerte enquanto carrega.
- Drawer: títulos em uma linha com ellipsis, tooltip Vuetify por hover/foco, padding inferior de 48 px mais safe area; largura existente preservada.
- Scroll: `scrollbar-width: none` e fallback WebKit, preservando overflow e áreas focáveis para rolagem por teclado.
- Helpers: registrar FCasoTeste e FSincRemoto somente como estados próprios das respectivas units; o processamento consome o booleano, não o declara.

## Data Models

Manter os modelos existentes. Reforçar no validador a igualdade de título, unit, slug e nome de arquivo para units canônicas; nomes e ordenação ficam no catálogo existente. O inventário AST usa os nomes e caminhos atuais e hashes SHA-256 com CRLF normalizado para LF.

## Risks & Concerns

| Local | Risco | Mitigação |
| --- | --- | --- |
| `Runner/TDD_IRUNNER.pas` | Nome do molde em string | Atualizar o literal e verificar o nome do arquivo de destino. |
| Processamento financeiro | Caso selecionado em string | Migrar SetTDDUnit e exemplo interpretado junto do piloto. |
| Inventário AST | Aliases antigos eram nós externos | Reconstruir nós e uses contra os arquivos atuais, sem duplicar variantes. |
| `build.mjs` | Regex do status antigo assume HTML sem filhos | Substituir o marcador completo por HTML de overlay delimitado. |
| Pasta `Sincronizar` | Linux diferencia capitalização | Usar os caminhos exatos e verificar os fontes referenciados. |
| Cadastros externos | Renomear localmente não atualiza o ERP | Documentar a etapa de cadastro necessária; não declarar homologação. |
| Arquivos do usuário | Remoções e três fontes novos já presentes | Preservar a versão fornecida; alterações Pascal limitadas aos identificadores. |

## Tech Decisions

Overlay independente das bibliotecas é necessário para cobrir também o carregamento delas. Tooltips e navegação usam os componentes Vuetify existentes. Testes de consumo da LLM ficam em `Documentacoes/tools/portal-iteration/`, ignorado, com evidências registradas nesta feature. Não criar outro worktree para implementação ou revisão; mutações de verificação usam cópias temporárias de arquivos.

Context7 não está disponível nas ferramentas da sessão. Referências oficiais consultadas: https://vuetifyjs.com/en/components/tooltips/ , https://vuejs.org/api/general.html#nexttick e https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/scrollbar-width .
