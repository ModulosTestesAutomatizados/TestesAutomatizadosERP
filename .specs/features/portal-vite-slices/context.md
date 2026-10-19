# Contexto da migração

**Data:** 2026-10-16. **Status:** proposta pronta para revisão, não aprovada para implementação.

## Pedido confirmado

Vite e Vue/Vuetify por npm; SFC/script setup TypeScript; slices por feature dentro de componentes; hierarquia do mapa preservada ao máximo; análise de bounded contexts; SOLID/DRY; incorporação do pacote de estabilização; snippets atualizados e uma skill local de contribuição.

## Baseline observada

Branch: TestesAutomatizadosERP-docs. HEAD: 59991458a9d31c912f17cd3a3cc02c479413e004. Código da documentação em Documentacoes/app; 24 documentos na última entrega, sem reexecutar build nesta sessão. package.json declara Vue 3.5.43, Router 4.6.4, Vuetify 4.2.3 e Mermaid 11.17.2; hoje carregados como globais via CDN e usados também por ferramentas locais.

O build atual compila TS, valida catálogo/fontes/Mermaid/hash AST e copia saída para .pages-output. Router usa hash. ESLint já tem regras SFC, mas templates atuais passam por ferramenta auxiliar. O plano deve substituir a infraestrutura sem perder suas validações editoriais.

## Alterações locais preexistentes preservadas

O status abaixo foi observado antes de produzir os novos arquivos de planejamento. São alterações de outra sessão/usuário e não foram restauradas, staged, committed ou sincronizadas por esta especificação:

~~~text
 D docs/assets/emDesenvolvimento/MIGRACAO_NOMES_UNITS_TDD.md
 D docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas
 M docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas
 D docs/assets/emDesenvolvimento/Runner/P39_TDD_BASE_UNIT_IRUNNER.pas
 D docs/assets/emDesenvolvimento/Runner/P39_TDD_FINISHED.pas
 D docs/assets/emDesenvolvimento/Runner/P39_TDD_FIN_PROCESSAMENTO.pas
 D docs/assets/emDesenvolvimento/Runner/P39_TDD_IRUNNER.pas
 D docs/assets/emDesenvolvimento/Runner/P39_TDD_LOGS.pas
 D docs/assets/emDesenvolvimento/Runner/P39_TDD_RUNNER.pas
 D docs/assets/emDesenvolvimento/Runner/P39_TDD_STARTED.pas
?? docs/assets/emDesenvolvimento/Runner/P39_TDD_PROCESSAMENTO_FINANCEIRO.pas
?? docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_ASSERTS.pas
?? docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_MODULO.pas
?? docs/assets/emDesenvolvimento/Runner/TDD_RUN_FINISHED.pas
?? docs/assets/emDesenvolvimento/Runner/TDD_RUN_IRUNNER.pas
?? docs/assets/emDesenvolvimento/Runner/TDD_RUN_LOGS.pas
?? docs/assets/emDesenvolvimento/Runner/TDD_RUN_RUNNER.pas
?? docs/assets/emDesenvolvimento/Runner/TDD_RUN_STARTED.pas
?? docs/assets/emDesenvolvimento/Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas
?? docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO.pas
~~~

Não tratar uma exclusão local como instrução para apagar automaticamente sua documentação; reconciliar substituição e identidade com o pacote recebido. Também não restaurar o roteiro de migração apagado pelo usuário.

## Propostas explicitadas

- Manter código em app e configuration/build em Documentacoes, sem mover conteúdo para a raiz.
- Alternativa A em arquitetura-proposta.md: slices editoriais espelhando menu, capacidades compartilhadas e contextos proporcionais ao domínio.
- Usar leitor comum para páginas dirigidas por dados; view específica quando houver comportamento distinto.
- Usar nomes/caminhos reais da estabilização, separando referências remotas e aliases. O mapa mantém grupos e ordem, com folhas atualizadas quando fontes antigos forem substituídos.
- Preservar experiência homologada e rotas válidas; não reintroduzir páginas que o usuário mandou excluir.
- Especificar migração técnica e atualização editorial no mesmo plano, com etapas separadas para diagnóstico de regressões.
- Criar skill do projeto durante Execute, após definir caminhos finais, sem instalar skills globais.

Estas escolhas continuam propostas. Não foi declarada liberdade de decisão do agente nem aprovação implícita de arquitetura pelo usuário.

## Próxima decisão

Revisar a especificação e selecionar a alternativa de organização. Depois produzir Design detalhado com contratos, plano de paths/rotas, dependências e estratégia de build; em seguida Tasks atômicas para aprovação. Nenhum código da aplicação, fonte Pascal, banco, PR ou deployment alterado nesta etapa.
