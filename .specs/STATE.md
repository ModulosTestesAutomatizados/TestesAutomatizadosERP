# STATE

## Decisions

Nenhuma decisao AD de projeto foi registrada como aprovada nesta entrega. As restricoes confirmadas pelo usuario e as propostas locais estao em `.specs/features/tdd-irunner-lote-json/context.md` e `spec.md`. A especificacao historica do MVP permanece preservada e nao comprova a implementacao nos arquivos atuais em Runner.

### AD-001 — frontend documental Vue/Vite

Status: active. Aprovada pela revisão da especificação e autorização de implementação em 2026-10-16. Usar SFC com script setup TypeScript, dependências npm e build estático Vite para Pages. Organizar slices dentro de app/components, preservando a hierarquia editorial e leitor comum dirigido por dados. Publicação documental é o contexto; grupos de assuntos não são automaticamente bounded contexts. Não alterar regras Pascal nesta migração.
## Handoff

- **Feature:** .specs/features/portal-vite-slices/
- **Phase / Task:** T1–T8 concluídas localmente. Verificador independente PASS em validation.md, 32/32 AC + DOC-01..18; validate_state sem erros.
- **Completed:** 27 documentos em slices; SFC/script setup TypeScript/Vite; Vue/Router/Vuetify 4.2.6/Mermaid/MDI via npm; conteúdo atual Runner/asserts/módulo/validador/sincronização; quatro moldes canônicos; AST/Mermaids reconciliados; plugin de integridade/cópia; guia/snippets/skill; tema claro/escuro e clearable.
- **Verification:** check/build e scripts ignorados editorial, sync-check, asset-gate, snippets e native passaram. Smoke sob prefixo Pages sem CDN incluiu moldes/retry, diagramas/links/zoom/orientação, tema salvo, busca, loading, rota/refresh, mobile e falhas. Actions/Linux e ERP não executados.
- **Sources:** Usuário atualizou assets e confirmou LOGS novo. RegistrarLog sempre acumula e FModoDebug controla exibição. Chamadas antigas em outras units são divergência documentada. Manifesto de bytes anterior difere somente nesse LOGS fornecido pelo usuário. Outros limites em reconciliacao-fontes.md.
- **Next step:** Aguardar homologação/instruções do usuário. Nada enviado ao remoto. Não abrir PR/publicar sem autorização própria desta iteração.
- **Branch / worktree:** TestesAutomatizadosERP-docs, somente este worktree. Sem push/PR/deploy, ERP, banco, TekStore ou novas branches.
- **Dev:** http://127.0.0.1:5173/TestesAutomatizadosERP/ (conferir processo se necessário).
- **Commits:** 48204f2 plano, dd8ca50 slices, d6ab199 SFC/Vite, cf1acae autoria, e00b368 Runner, 8d3f769 JSON/moldes, 3ec6b8f assets canônicos, 3cef3aa temas/clearable, 5615968 moldes/autoria. Evidência T8 segue no commit deste registro.

Revisão final: range 5999145..a8a2a0d; sete scripts locais e check/build próprios passaram. Sensor de rejeição de hash morto em cópia isolada, porcelain idêntico. Sem Linux/Actions/ERP ou instalação limpa. Uma mensagem de diagnóstico com path antigo ficou como observação cosmética no parecer. Preview reiniciado em 5173, sessão exec 77811.
