# Relatório do serviço — MVP TDD IRunner

**Data:** 2026-10-05  
**Status:** implementação local para revisão; validação no JvInterpreter pendente.

### Realização (Interno)

O IRunner recebe módulo e área, carrega uma vez os casos ativos e executa `Teste` para cada registro do CDS global, sem clonar o dataset. Falhas individuais são acumuladas e não interrompem os próximos casos. Ao final do lote, `TearDown` tenta liberar CDS de casos/resultados/campos/configuração, parâmetros, cache e estado de STARTED, mesmo se alguma liberação falhar. A unit financeira usa os métodos e dados disponíveis pelo contexto herdado da unit base, sem declarar `uses` de `TDD_RUNNER` ou `TDD_STARTED`.

O banco dedicado consultado contém um caso ativo em `FINANCEIRO / FINANCEIRO` (ID 28, `TDD_FINANCEIRO`) e três casos ativos em `FATURAMENTO / PEDIDO DE VENDA` (IDs 30, 31 e 32). O primeiro serve para iniciar o smoke test da configuração atual; o segundo demonstra o cenário de múltiplos casos.

### Fontes modificados

- `docs/assets/emDesenvolvimento/TDD_IRUNNER.pas`
- `docs/assets/emDesenvolvimento/TDD_BASE_UNIT_IRUNNER.pas`
- `docs/assets/emDesenvolvimento/TDD_RUNNER.pas`
- `docs/assets/emDesenvolvimento/TDD_STARTED.pas`
- `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas`
- `docs/assets/emDesenvolvimento/P39_PROCESSAMENTO_TDD_FINANCEIRO.pas`
- `docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas`
- `docs/assets/configuracoesGerais/P39_TDD_PARAMETRO.pas`
- `docs/assets/configuracoesGerais/P39_TDD_CACHE.pas`
- `.specs/features/tdd-irunner-mvp/spec.md`
- `.specs/features/tdd-irunner-mvp/tasks.md`
- `.specs/features/tdd-irunner-mvp/revisao-piloto.md`
- `.specs/features/tdd-irunner-mvp/validation.md`
- `.specs/features/tdd-irunner-mvp/relatorio-servico.md`

### p/ teste

1. Comece em uma instância de ERP de testes, com empresa e massa controladas. O caso financeiro atual executa operações reais de inclusão e borderô; não o rode em base operacional.
2. Disponibilize no ambiente do JvInterpreter as versões locais das units listadas acima e suas dependências já usadas pelo ERP, em especial `P39_TDD_ODBC`, `TDD_LOGS` e as duas units de mapeamento de borderô.
3. Execute `Main` de `P39_PROCESSAMENTO_TDD_FINANCEIRO`. A configuração local informa `FINANCEIRO / FINANCEIRO`, que no banco consultado retorna somente o caso ativo ID 28. Confira nos logs que a lista foi carregada e que o fluxo percorreu `STARTED`, `Teste`, o ponto atual de `ASSERTS` e a finalização.
4. Confira que o histórico foi gravado para o ID 28, que as métricas contêm os ticks do caso e que as telas abertas pelo teste foram fechadas. Como ASSERTS continua sob responsabilidade externa, o status operacional do runner não confirma sozinho que os valores esperados foram comparados.
5. Depois de conferir/limpar os dados financeiros criados, execute novamente na mesma sessão. Verifique se o segundo lote volta a carregar casos, parâmetros e cache, sem reutilizar estado liberado nem deixar telas abertas.
6. Para validar a iteração com mais de um caso, use uma fixture de teste sem efeitos financeiros e com um `Teste` que apenas registre o ID/nome atual. O banco tem três casos em `FATURAMENTO / PEDIDO DE VENDA` (IDs 30–32), mas não use diretamente `P39_TDD_FAT_PEDIDO_VENDA` nesse primeiro teste: essa fixture tem um `Setup` próprio que o IRunner atual não executa; além disso, seus testes podem gravar dados de faturamento.
7. Com essa fixture segura, faça um caso falhar de propósito e confirme que os casos seguintes ainda executam, cada resultado é registrado e o `TearDown` acontece uma única vez depois do último caso.
8. Por fim, provoque uma falha na carga inicial e, em ambiente controlado, uma falha durante a limpeza. Confira que o restante das liberações continua sendo tentado e que a mensagem da falha original permanece no diagnóstico.

### O que há de novo

Uma chamada do IRunner pode percorrer todos os casos ativos de um módulo e área. O encerramento agora limpa o estado compartilhado ao fim do lote, mesmo quando um caso ou uma etapa de limpeza falha.

### Guia de início no JvInterpreter

**Primeira rodada — um caso:** use a unit de processamento já configurada para `FINANCEIRO / FINANCEIRO`. Antes da execução, confirme que os dados financeiros padrão apontam para registros válidos na empresa de testes. O caso ID 28 seguirá pelo fluxo financeiro completo (`cEtapaAtual = 0`), portanto reserve uma massa na qual criar duplicatas e borderôs seja permitido.

**Segunda rodada — loop:** não use ainda o piloto financeiro para validar continuação após falha; cada registro repetiria as mesmas operações financeiras. Prepare uma fixture temporária, sem gravações, que só leia o registro corrente de `CDSCasosTestes` e acrescente seu ID/nome ao log. Configure o processamento para uma área com pelo menos dois casos ativos. No JvInterpreter, confirme a sequência completa para cada ID e depois uma única passagem pelo `TearDown` global.

**Critério de aceite inicial:** todos os casos da área aparecem uma vez, o caso que falha não interrompe os seguintes, cada caso conserva seu próprio histórico/métricas, callbacks são fechados e os CDS de casos, resultados, configuração, parâmetros e cache são liberados no fim do lote. Repetir a chamada na mesma sessão deve iniciar um lote limpo.

**Limite atual:** o IRunner registra somente `Teste` no MVP. A fixture de faturamento existente define `Setup`, mas não o recebe nessa chamada; valide o loop primeiro com uma fixture `Teste` sem efeitos colaterais. A execução nativa e a semântica real de liberação no JvInterpreter continuam sem validação neste workspace.
