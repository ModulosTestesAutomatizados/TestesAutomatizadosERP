# Estado do trabalho TLC

## Decisions

### AD-001: Reutilizar os métodos existentes do IRunner

Não criar wrappers de preparação, falha, encerramento ou limpeza nesta iteração. O cálculo relativo pertence a RegistrarTick; a leitura dos parâmetros pertence a AplicarParametrosDoCasoTeste; o contexto pertence a SetarCasoTeste; o fechamento de métricas e a persistência pertencem a RegistrarMetricas. A casca mantém a ordem, os finally e o controle do lote.

### AD-002: Um checkpoint, próxima iteração sem commit

O usuário solicitou o checkpoint `e47d2a4` antes da reorganização. As alterações de irunner-casca-enxuta, sua especificação e suas evidências ficam fora do index e sem novo commit. Não executar push ou gravação no banco.

### AD-003: Preservar debug e distinguir validação local de ERP

TDD_LOGS mantém a captura condicionada a FModoDebug. As sondas locais executam um subconjunto do fonte Pascal traduzido com fronteiras ERP substituídas; não são compilação Pascal nem evidência de persistência real. A confirmação no JvInterpreter é uma etapa separada.

### AD-004: Contexto sempre obtido do registro corrente

SetarCasoTeste recebe somente módulo e área. O usuário confirmou que o fluxo sempre itera o lote; a descrição não é mais argumento nem alternativa opcional, sendo lida do CDS após a reinicialização segura do contexto.

## Handoff

- Feature atual: `.specs/features/irunner-asserts-modulo/spec.md`, aprovada e implementada localmente.
- Baseline atual observado: `0303da9 chore(rename): alterações nos nomes de units simulando etiquetas`; árvore limpa antes desta proposta. O snapshot anterior em e47d2a4 é histórico, não o baseline atual.
- O usuário adicionou P39_TDD_VALIDAR_RESULTADO e aprovou a direção de integrar asserts/módulo, remover FDescModulo duplicado e manter STARTED como aprovada.
- Especificação atual: 25 requisitos, sete tarefas concluídas. Nomes/uses corrigidos; MODULO sem contexto duplicado; ASSERTS com evidências/cópias por caso; validador somente comparações; métricas agregadas persistidas por FINISHED. RegistrarErroReal foi movido do validador para RUN_ASSERTS.
- Verificação: 16 grupos do autor, cinco independentes e 3/3 mutações detectadas em cópias temporárias. PASS local em validation.md; nenhum gate representa execução ERP/ODBC.
- Próximo passo: o usuário disponibilizar o conjunto coerente de fontes no ambiente de teste e observar as capturas Data/RecNo, os datasets ativos após Save e as métricas/logs reais. Sem escrita em banco, stage ou commit nesta iteração. Documentação do portal não foi alterada.
- Feature anterior: `.specs/features/irunner-casca-enxuta/spec.md`; sua validação local não comprova os requisitos desta nova iteração nem a execução nativa dos novos nomes.
