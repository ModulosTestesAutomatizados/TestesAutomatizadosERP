# STATE

## Decisions

Nenhuma decisao AD de projeto foi registrada como aprovada nesta entrega. As restricoes confirmadas pelo usuario e as propostas locais estao em `.specs/features/tdd-irunner-lote-json/context.md` e `spec.md`. A especificacao historica do MVP permanece preservada e nao comprova a implementacao nos arquivos atuais em Runner.

### AD-001 — frontend documental Vue/Vite

Status: active. Aprovada pela revisão da especificação e autorização de implementação em 2026-10-16. Usar SFC com script setup TypeScript, dependências npm e build estático Vite para Pages. Organizar slices dentro de app/components, preservando a hierarquia editorial e leitor comum dirigido por dados. Publicação documental é o contexto; grupos de assuntos não são automaticamente bounded contexts. Não alterar regras Pascal nesta migração.
### Proveniência da integração do PR #27

As decisões e o handoff da estabilização anterior foram preservados integralmente em `.specs/features/portal-vite-slices/referencias/estabilizacao/STATE-pr27.md`. São históricos: o contrato posterior de LOGS fornecido pelo usuário substitui a captura condicionada a debug descrita naquele snapshot. A entrega Vue/Vite preserva os fontes atuais reconciliados e a autorização de publicação por PR recebida nesta sessão.

## Handoff

- **Feature:** .specs/features/conhecimento-agentes/spec.md.
- **Phase:** três entregas locais implementadas; revisão independente TLC final pendente. Não declarar PASS antes de validation.md e validate_state.
- **Completed:** llms.txt, knowledge/index.json (schemaVersion/contentVersion), Markdown por documento público; códigos/cânones/citações/estados/símbolos/fontes preservados; base Vite, plugin dev/build e rel describedby; skill consultar-documentacao-tdd e guia /guias/agentes. ESLint passa também sobre config/*.ts.
- **Verification:** check/build, fixture knowledge.mjs e HTTP knowledge-http.mjs passaram (28 Markdown, 73 links locais, âncoras e conhecimento LOGS). Asset-gate e git-index-paths passaram; duas skills validadas; dev JSON bruto HTTP 200. Testes/tools ignorados. Nenhum diff em Pascal ou Mermaids.
- **Next step:** revisão independente dos sete KNOW-01..07 e sensor em cópia ignorada; consolidar parecer. Envio desta extensão ao remoto ainda não realizado.
- **Branch/worktree:** TestesAutomatizadosERP-docs, somente este worktree. Sem ERP, SQL, novas dependências, branches ou worktrees.
- **Publicação anterior:** PR #26 atualizado até ab4a2d8 após integrar master/PR #27; build Ubuntu com npm ci/check/build passou. Correção de capitalização Sincronizar incorporada. Nenhum merge/deploy feito pelo agente. Esse PASS Linux antecede a extensão de conhecimento.
- **Dev:** http://127.0.0.1:5173/TestesAutomatizadosERP/; /knowledge/index.json confirmado com 28 documentos.
- **Commits da extensão:** 31affb1 exportação; 807089d skill/guia; relatório e evidências no commit deste registro. Escopo e fontes da migração anterior preservados em portal-vite-slices/validation.md e reconciliacao-fontes.md.
