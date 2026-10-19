# STATE

## Decisions

Nenhuma decisao AD de projeto foi registrada como aprovada nesta entrega. As restricoes confirmadas pelo usuario e as propostas locais estao em `.specs/features/tdd-irunner-lote-json/context.md` e `spec.md`. A especificacao historica do MVP permanece preservada e nao comprova a implementacao nos arquivos atuais em Runner.

### AD-001 — frontend documental Vue/Vite

Status: active. Aprovada pela revisão da especificação e autorização de implementação em 2026-10-16. Usar SFC com script setup TypeScript, dependências npm e build estático Vite para Pages. Organizar slices dentro de app/components, preservando a hierarquia editorial e leitor comum dirigido por dados. Publicação documental é o contexto; grupos de assuntos não são automaticamente bounded contexts. Não alterar regras Pascal nesta migração.
### Proveniência da integração do PR #27

As decisões e o handoff da estabilização anterior foram preservados integralmente em `.specs/features/portal-vite-slices/referencias/estabilizacao/STATE-pr27.md`. São históricos: o contrato posterior de LOGS fornecido pelo usuário substitui a captura condicionada a debug descrita naquele snapshot. A entrega Vue/Vite preserva os fontes atuais reconciliados e a autorização de publicação por PR recebida nesta sessão.

## Handoff

- **Feature:** .specs/features/conhecimento-agentes/spec.md.
- **Phase:** concluída localmente; revisão independente PASS 7/7 em validation.md e validate_state sem erros. Falha inicial KNOW-03 corrigida em 271111a, com regressão CRLF/LF e rechecagem aprovada.
- **Completed:** llms.txt, knowledge/index.json (schemaVersion/contentVersion), Markdown por documento público; códigos/cânones/citações/estados/símbolos/fontes preservados; base Vite, plugin dev/build e rel describedby; skill consultar-documentacao-tdd e guia /guias/agentes. ESLint passa também sobre config/*.ts.
- **Verification:** check/build, fixture knowledge.mjs e HTTP knowledge-http.mjs passaram (28 Markdown, 73 links locais, âncoras e conhecimento LOGS). Asset-gate e git-index-paths passaram; duas skills validadas; dev JSON bruto HTTP 200. Testes/tools ignorados. Nenhum diff em Pascal ou Mermaids.
- **Next step:** aguardar instruções de publicação desta extensão por novo PR. PR #26 já integrado em master (26ca11c); extensão ainda não enviada ao remoto.
- **Branch/worktree:** TestesAutomatizadosERP-docs, somente este worktree. Sem ERP, SQL, novas dependências, branches ou worktrees.
- **Publicação anterior:** PR #26 atualizado até ab4a2d8 após integrar master/PR #27, com build Ubuntu npm ci/check/build aprovado; integrado em 2026-10-16 pelo usuário. Origin/master contém apenas o merge 26ca11c além da base ab4a2d8, sem diferença de conteúdo. Esse PASS Linux antecede a extensão de conhecimento.
- **Dev:** http://127.0.0.1:5173/TestesAutomatizadosERP/, sessão exec 94824; llms.txt HTTP 200 text/plain. /guias/agentes e /knowledge/index.json disponíveis no mesmo prefixo.
- **Commits da extensão:** 31affb1 exportação; 807089d skill/guia; 9548f92 gates locais; 271111a correção de metadados e primeiro parecer; fechamento no commit deste registro. Sensor 1/1 morto, árvore isolada preservada; consulta pela skill encontrou LOGS corretamente. Lição candidata L-002 registrada. Escopo e fontes da migração anterior preservados em portal-vite-slices/validation.md e reconciliacao-fontes.md.
