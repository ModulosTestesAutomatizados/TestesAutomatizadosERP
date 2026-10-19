# Realização

Corrigido o caminho de dupla liberação de logs sem atribuições a nil. Executar cria e libera seu buffer local de montagem; Main cria a lista do lote, liberada pelo próprio lote. Ao sair de Executar, a referência de logs do chamador é restaurada. Somente o texto da preparação é transferido ao programa interpretado. Nenhum método novo foi criado.

# Fontes modificados

- docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_IRUNNER.pas
- docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_UNIT_BASE_IRUNNER.pas
- .specs/features/irunner-logs-preparacao/testar-liberacao.mjs
- .specs/features/irunner-asserts-modulo/evidencias/testar.mjs
- docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_RUN_IRUNNER.ast.json

# p/ teste

Quatro grupos de testes estritos de liberação e dezesseis de regressão passaram localmente, com revisão independente. Cobrem listas separadas, contexto compartilhado por Main, preservação da exceção original e nova chamada com uma nova lista de parâmetros. Usam tradução restrita do Pascal com APIs substituídas; não comprovam execução nativa nem reuso via AddParamsRun após Free no mesmo contexto.

A suíte antiga de logs ainda espera MostrarLogTexto com um argumento; o fonte atual do usuário usa dois. Essa expectativa não foi alterada para encobrir a diferença.

Atualizar TDD_RUN_IRUNNER e TDD_RUN_UNIT_BASE_IRUNNER juntas no ambiente e repetir o processamento. Conferir sucesso/falha e logs de preparação e de cada caso no histórico. Execução nativa pendente. Nenhum banco, menu real, stage ou commit foi executado nesta correção.

# O que há de novo

Preparação e lote liberam somente suas próprias listas com Free, sem nil e sem disputa pela mesma instância.
