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

- Feature: `.specs/features/irunner-casca-enxuta/spec.md`.
- Branch: `refactor/tdd-runner`; baseline: `e47d2a4`.
- Implementação local: quatro fontes Pascal reorganizados; dois helpers removidos; casca de 223 para 183 linhas.
- Verificação: gate local e sondas anteriores aprovados; revisão TLC independente PASS local, 10/10 critérios e 5/5 mutações detectadas.
- Próximo passo operacional: revisar o diff e disponibilizar as quatro units no ERP para validação nativa.
- Sem stage/commit nesta iteração, conforme instrução do usuário.
