# STATE

## Decisions

Nenhuma decisao AD de projeto foi registrada como aprovada nesta entrega. As restricoes confirmadas pelo usuario e as propostas locais estao em `.specs/features/tdd-irunner-lote-json/context.md` e `spec.md`. A especificacao historica do MVP permanece preservada e nao comprova a implementacao nos arquivos atuais em Runner.

## Handoff

- **Feature:** .specs/features/portal-navegacao-sincronizacao/
- **Phase / Task:** Implementação local e revisão independente TLC concluídas: PASS.
- **Completed:** T1–T7 e T8 de correção do grafo. Nomes canônicos em fontes, páginas, menu e referências; seis grupos; 24 documentos; três helpers de sincronização; exclusão das páginas e rotas antigas; overlay; truncamento e tooltip; respiro de 48 px no drawer; scroll com barras ocultas; guia e 22 snippets atualizados.
- **Verification:** Lint, tipos, build, catálogo, busca, snippets e navegação desktop/mobile sob prefixo Pages passaram. Migração comparada ao baseline dos fontes fornecidos, sem mudanças de lógica Pascal. Sensor independente: duas mutações em cópias, ambas detectadas, sem alterar a árvore real.
- **Next step:** Revisão do usuário e eventual autorização para publicação via PR. validation.md e gate TLC aprovados. Publicação remota depende de nova instrução; a exceção de push direto em master ficou restrita à pipeline anterior.
- **Runtime limits:** Nenhuma execução no ERP/TekStore/bancos. Atualizar os nomes dos cadastros externos antes de executar os fontes renomeados. Testes e ferramentas locais continuam ignorados.
- **Branch / worktree:** TestesAutomatizadosERP-docs, somente este worktree.
