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

- Feature atual: `.specs/features/sincronizacao-fonte-unica/spec.md`, implementação local concluída e revisão independente PASS local.
- Baseline observado: `db20fe6`, com alterações prévias do usuário em fontes compartilhados e no exemplo. Essas alterações foram preservadas; nenhum stage/commit desta sessão.
- Decisões do usuário: resultadoEsperado ausente usa P39_TDD_ASSERTS_JSON_MINIMO; {} explícito não acrescenta asserts e registra SEM_VALIDACAO; camposDisponiveis ausente ou vazio usa a nova P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO, atualmente {}.
- Implementado: método único ObterObjetoConfiguracao, leitura estrita, assinatura RegistrarCasoTeste com seis argumentos, quatro consumidores atualizados, projeção dos objetos reservados fora do caso e validador aceitando objeto vazio. STARTED não alterada.
- Testes da feature: nove grupos do autor, quatro independentes e 3/3 mutações detectadas. Revisão dos onze requisitos em validation.md. Não executam ERP/ODBC.
- Regressão anterior observada: gate irunner-asserts-modulo tem 15 grupos aprovados e falha na reexecução porque o HEAD libera FLogsCasoTeste sem nil. Teste preservado; limpeza fora deste escopo. Cinco adversariais anteriores aprovados.
- Próximo passo: disponibilizar o conjunto coerente no ERP para confirmação nativa. Sem escrita em banco, sincronização efetiva ou documentação do portal. JSONs locais continuam ignorados pela regra *.json existente.
