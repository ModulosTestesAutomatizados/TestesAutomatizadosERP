# Conhecimento documental para agentes

## Realização

Implementada exportação estática gerada do catálogo: llms.txt, índice JSON versionado e Markdown por documento público. O plugin valida os cânones antes da projeção; preserva códigos literais, Mermaid, referências, estados e evidências. Adicionada skill de consulta TDD e guia no portal. Implementação local concluída; revisão independente final pendente neste registro.

## Fontes modificados

- Documentacoes/config/knowledge.ts
- Documentacoes/config/portal-assets.ts
- Documentacoes/config/README.md
- Documentacoes/package.json
- index.html
- Documentacoes/app/components/contribuir/conteudo/agentes.ts
- Documentacoes/app/components/contribuir/conteudo/autoria.ts
- Documentacoes/app/components/contribuir/index.ts
- Documentacoes/app/README.md
- .agents/skills/consultar-documentacao-tdd/SKILL.md
- .agents/skills/contribuir-documentacao/SKILL.md
- .specs/features/conhecimento-agentes/spec.md
- .specs/STATE.md

## p/ teste

1. Execute npm run build --prefix Documentacoes e npm run preview --prefix Documentacoes. Use o endereço impresso com /TestesAutomatizadosERP/.
2. Abra llms.txt e knowledge/index.json nesse endereço. Procure RegistrarLog ou FModoDebug no índice e siga o Markdown da unit.
3. Confira assinaturas, estado documental, limites, códigos, diagramas e links para os fontes. Em Contribuir, leia Consultar com agentes de IA e copie o pedido de exemplo.
4. Registre uma página normalmente no catálogo e gere o build: a nova página deve aparecer na exportação sem lista manual paralela.

Check/build aprovados. Fixture local cobre sete tipos de bloco, aliases, símbolos/assinaturas, navegação, fontes, evidência ERP, hidden, versão determinística e alterada, novos registros, cercas internas e cânone ausente. HTTP verificou 28 Markdown, 73 links locais, âncoras e metadados LOGS sem executar Vue. Dev retornou application/json e schemaVersion 1. As duas skills passaram quick_validate. Gates anteriores de fonte/hash/case e coincidência com index Git também passaram. Todos os testes/tools permanecem ignorados.

Os fontes Pascal e Mermaids não foram alterados. Não houve execução no ERP, backend, treinamento de modelos ou publicação remota desta extensão durante esses checks locais. A revisão independente acrescentará seu parecer e limites em validation.md.

## O que há de novo

Agentes podem consultar o conhecimento TDD por arquivos estáticos, com a mesma fonte usada pela documentação visual. Uma skill e um guia explicam como localizar os donos de estados e métodos e preservar as limitações documentadas.
