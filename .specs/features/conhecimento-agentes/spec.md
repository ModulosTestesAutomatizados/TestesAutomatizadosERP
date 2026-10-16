# Conhecimento documental para agentes

**Status:** implementação autorizada pelo usuário após proposta em conversa. Extensão delimitada do build existente; três entregas locais.

## Problem Statement

O portal é uma SPA Vue. Agentes precisam de URLs estáticas com texto e símbolos pesquisáveis, provenientes do mesmo catálogo, para consultar o contrato TDD sem renderizar a interface ou duplicar manutenção.

## Goals

Gerar llms.txt, Markdown por documento e índice JSON; orientar consulta com uma skill do projeto e guia no portal. Preservar fontes canônicos e publicação estática no prefixo Pages.

## Out of Scope

Treinamento de modelos, backend, banco vetorial, servidor MCP, execução Pascal/ERP e cópia de toda a árvore de assets. Publicação remota desta extensão depende de autorização; implementação e commits locais estão autorizados.

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Fonte única | Catálogo tipado e assets canônicos validados | Proposta aprovada | Sim |
| Endereços | llms.txt e knowledge/index.json; Markdown em knowledge/categoria/slug.md | URLs estáticas sob a base do Vite | Implementação |
| Documentos públicos | Excluir oculto; preservar estado, fontes e evidência | Mesma política de descoberta | Implementação |
| Versionamento | schemaVersion e contentVersion determinística por hash do conteúdo exportado | Reconhecer mudanças sem timestamp variável | Implementação |

**Open questions:** none.

## User Stories

### P1: Consultar conhecimento atual

**Acceptance Criteria**:
1. WHEN o build executar THEN o portal SHALL gerar llms.txt, índice JSON e um Markdown por documento público, utilizando somente catálogo e assets validados. (KNOW-01)
2. The Markdown SHALL preservar todos os tipos de bloco, códigos literais, Mermaid canônico, fontes e links entre units documentadas, sem inserir links dentro de código copiável. (KNOW-02)
3. The índice SHALL expor schemaVersion, contentVersion, títulos, resumos, nomes/aliases, posição na navegação, estados/evidências, símbolos/assinaturas e URLs de páginas/Markdown/fontes; conteúdo equivalente SHALL ter a mesma versão. (KNOW-03)
4. WHEN documentos forem adicionados, atualizados ou ocultados THEN a exportação SHALL acompanhar o catálogo no build, com links válidos sob a base Pages e sem exportar documentos ocultos. (KNOW-04)
5. IF um asset canônico necessário estiver ausente THEN o build SHALL falhar; a extensão SHALL preservar os gates existentes e os fontes Pascal, sem runtime de backend ou novas dependências. (KNOW-05)
6. The skill consultar-documentacao-tdd e o guia SHALL explicar consulta local/publicada por unit, estado e método, citações de fonte e distinção entre contrato documentado e evidência ERP. (KNOW-06)
7. The entrega SHALL passar check/build, verificação proporcional de exportação/HTTP e revisão independente, mantendo testes/tools ignorados. (KNOW-07)

## Edge Cases

Código contendo cercas Markdown, pipes em tabelas, aliases sem normalizar o nome real, acentos, blocos canônicos ausentes, nomes ocultos citados em texto, base de projeto e mudanças de conteúdo sem alterar a quantidade de páginas.

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| KNOW-01 | Consulta | Execute | Implemented |
| KNOW-02 | Consulta | Execute | Implemented |
| KNOW-03 | Consulta | Execute | Implemented |
| KNOW-04 | Consulta | Execute | Implemented |
| KNOW-05 | Consulta | Execute | Implemented |
| KNOW-06 | Consulta | Execute | Pending |
| KNOW-07 | Consulta | Execute | Pending |

## Success Criteria

Uma consulta a RegistrarLog ou FModoDebug encontra a unit proprietária no JSON e permite ler seu Markdown com fonte, assinatura e limite atual. Todos os links de llms/índice servem no artefato estático; atualização de um documento altera a versão sem manutenção paralela.

## Execução

1. Projeção Markdown/JSON/llms e integração ao plugin existente; validar fixture e build.
2. Skill de consulta, guia e orientação de autoria; validar skill e catálogo.
3. Conferência HTTP do artefato e relatório, seguida de revisão independente TLC/sensor em cópia ignorada. Sem nova branch/worktree ou ferramentas versionadas.

Referências: https://llmstxt.org/; API de plugins e substituição BASE_URL da documentação oficial do Vite. Context7 não exposto nesta sessão; fallback para as fontes oficiais após leitura do código.

Entrega 1: projeção pura e integração ao plugin, descoberta via HTML e ESLint também sobre config/*.ts. Check/build, fixture de todos os blocos e conferência HTTP dos documentos/links/âncoras passaram. A fixture demonstra versão determinística/alterada, exclusão de ocultos, cercas contendo backticks, alias e asset ausente. Ferramentas em Documentacoes/tools/vite-migration permanecem ignoradas. Sem alteração nos fontes Pascal ou Mermaids.
