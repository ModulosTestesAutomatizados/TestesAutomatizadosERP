# Casca IRunner com os métodos existentes

## Problem Statement

A casca chegou a 223 linhas ao receber reinicialização de contexto, varredura de métricas e tratamento de persistência. Esta iteração redistribui essas responsabilidades nos métodos existentes e remove dois helpers de uso único, preservando as correções do piloto.

Baseline: `e47d2a4`. A pedido do usuário, este é o único commit desta entrega; a especificação, os testes e a implementação seguintes permanecem na worktree, sem stage e sem commit.

## Goals

- Reduzir a casca sem criar métodos Pascal, parâmetros de modo ou novas units.
- Preservar os resultados verificáveis de ticks, parâmetros, logs e feedback do lote.
- Separar evidência local de execução real no JvInterpreter, que continua pendente.

## Out of Scope

| Item | Motivo |
| --- | --- |
| Novos métodos de preparação, falha, encerramento ou limpeza | Rejeitados pelo usuário; reutilizar os existentes |
| Alterar TDD_LOGS ou ignorar FModoDebug | A mudança foi descartada; debug já está habilitado |
| Gravar no banco, executar financeiro, sincronizar ou publicar | Somente alterações locais autorizadas nesta iteração |
| Mudar regras financeiras ou os zeros do JSON | Esta iteração é de organização do runner |
| Corrigir bugs não relacionados de ciclo de vida | Registrar separadamente, sem ampliar o diff |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Próximos commits | Nenhum após e47d2a4 | Usuário quer comparar a próxima iteração no diff | Sim |
| Métodos | Incorporar CalcularTickRelativo e ObterParametrosDoCasoTeste nos consumidores | São helpers de uso único discutidos e aprovados para remoção | Sim |
| Finalização | RegistrarMetricas fecha os ticks pendentes e persiste, chamando RegistrarTick(1, nome) | Não criar outra camada para encerrar tempos | Sim |
| Contexto | SetarCasoTeste reinicia antes de consultar campos do CDS; a casca não avalia FieldByName nos argumentos dessa chamada | Uma exceção durante a preparação não deve reutilizar o ID anterior | Sim, derivado da garantia já acordada |
| Entrada pública de SetarCasoTeste | Receber somente módulo e área; descrição sempre vem do registro corrente | Usuário confirmou que o fluxo sempre itera os casos e não precisa fornecer uma descrição | Sim |
| Verificação | Sondas executam lógica traduzida do Pascal e doubles nas fronteiras do ERP | Não existe compilação/JvInterpreter configurado nesta sessão | Limite explícito |

**Open questions:** none. As decisões de comportamento foram resolvidas na conversa; as escolhas técnicas e os limites estão registrados acima.

## User Stories

### P1: Revisar uma casca menor sem perder as correções

**User Story:** Como mantenedor, quero que a casca coordene o fluxo usando os métodos existentes, para acompanhar execução e falhas sem navegar por novos wrappers.

**Acceptance Criteria**:

1. The implementação SHALL remover CalcularTickRelativo e ObterParametrosDoCasoTeste sem acrescentar declarações de métodos Pascal em relação ao baseline. (CASCA-01)
2. WHEN RegistrarTick lê o contador bruto THEN o runner SHALL produzir os mesmos tempos relativos: 2834258109/2834258000 = 110, 2147483648/2147483640 = 9, 5/4294967290 = 12, 123/123 = 1, 0/4294967290 = 7 e 2147483646/0 = 2147483647. (CASCA-02)
3. IF o tempo relativo excede 2147483646 ms THEN RegistrarTick SHALL rejeitar a conversão para Integer antes de inserir uma métrica. (CASCA-03)
4. WHEN AplicarParametrosDoCasoTeste recebe uma seção parametros na raiz THEN o runner SHALL aplicar exatamente seu objeto; seção ausente ou objeto vazio não aplica parâmetros, e raiz/seção inválida continua sendo erro. (CASCA-04)
5. IF a leitura do registro corrente falha antes de obter um ID THEN SetarCasoTeste SHALL deixar o ID em zero e os erros, logs, versão, requisito, JSON e etapa anteriores reiniciados, sem criar histórico para o ID anterior. (CASCA-05)
   WHEN SetarCasoTeste recebe módulo e área THEN o runner SHALL obter a descrição do registro corrente sem aceitar um terceiro parâmetro. (CASCA-05)
6. WHEN a tentativa é finalizada com ID válido THEN RegistrarMetricas SHALL encerrar cada tick aberto com RegistrarTick(1, nome), copiar os logs atuais e tentar inserir o histórico antes de limpar a lista do caso. (CASCA-06)
7. IF o encerramento dos ticks falha THEN RegistrarMetricas SHALL registrar a falha e tentar persistir o histórico com status FALHA, preservando VERSAO_INCOMPATIVEL quando aplicável, e apresentar a falha após essa tentativa. (CASCA-07)
8. IF a persistência falha THEN o runner SHALL apresentar a causa anterior antes do erro de FINISHED e conservar os logs em memória sem repetir o INSERT; se passar, SHALL restaurar a etapa anterior a FINISHED. (CASCA-08)
9. WHEN um caso falha no teste e a finalização passa THEN o lote SHALL continuar os demais casos e apresentar um resumo final com os detalhes e um único prefixo MensagemPersonalizada. (CASCA-09)
10. The casca SHALL conservar os marcadores usados por TDD_IRUNNER, a chamada de persistência no finally e o comportamento existente de TDD_LOGS condicionado a FModoDebug. (CASCA-10)

**Independent Test:** executar as sondas com fonte real traduzido e fronteiras substituídas, comparar os payloads e a ordem dos eventos, e injetar falhas somente em cópias temporárias. A compilação e a gravação real serão confirmadas no ERP pelo usuário.

## Edge Cases

- IF a preparação falha sem ID válido THEN o runner SHALL não tentar INSERT com FK ausente. (CASCA-05)
- IF apenas o fechamento do tick falha após sucesso do teste THEN o histórico SHALL registrar FALHA e o erro de fechamento. (CASCA-07)
- IF teste e persistência falham THEN o diagnóstico SHALL conter primeiro a validação do teste e depois FINISHED. (CASCA-08)
- WHEN o lote está vazio ou todos os casos passam THEN o lote SHALL encerrar sem resumo de erro. (CASCA-09)

## Dimensões presentes

Limites de contador e JSON: CASCA-02 a CASCA-04. Estado por tentativa: CASCA-05. Persistência, falha parcial, ordem de encerramento e ausência de retry: CASCA-06 a CASCA-08. Observabilidade: CASCA-09 e CASCA-10. Autenticação, concorrência, retenção e alterações de negócio são N/A porque não são modificadas nesta refatoração local.

## Execution Plan

1. Incorporar cálculo e leitura de parâmetros nos consumidores, mantendo os vetores de teste.
2. Centralizar a reinicialização em SetarCasoTeste e testar exceções na leitura do CDS.
3. Mover varredura e tratamento de persistência para RegistrarMetricas; reduzir Run mantendo os finally.
4. Atualizar sondas para os novos locais, executar gates e revisão independente TLC com mutações em cópias temporárias.

Não há tasks.md separado: são quatro etapas de uma iteração média já autorizada. A regra de commits por tarefa da skill é substituída pela instrução explícita do usuário de manter esta iteração sem commit.

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| CASCA-01 | P1 | Execute | Verified |
| CASCA-02 | P1 | Execute | Verified |
| CASCA-03 | P1 | Execute | Verified |
| CASCA-04 | P1 | Execute | Verified |
| CASCA-05 | P1 | Execute | Verified |
| CASCA-06 | P1 | Execute | Verified |
| CASCA-07 | P1 | Execute | Verified |
| CASCA-08 | P1 | Execute | Verified |
| CASCA-09 | P1 | Execute | Verified |
| CASCA-10 | P1 | Execute | Verified |

Verified nesta tabela significa verificação local aprovada em validation.md; compilação e execução no ERP continuam pendentes.

## Success Criteria

- Base menor que as 223 linhas do baseline, sem varredura de FCDSMetricasTickDiff ou formatação específica de erro de persistência.
- Nenhuma nova declaração Pascal; os dois helpers de uso único deixam de existir.
- Gates locais e sensor aprovados; validação no ERP explicitamente pendente.
- HEAD permanece e47d2a4, index vazio e alterações desta iteração visíveis no diff.

## Gates

`py -3 'C:/Users/Gerson Ribeiro/.codex/skills/tlc-spec-driven/scripts/validate_spec.py' irunner-casca-enxuta` valida a estrutura TLC.

`node .specs/features/irunner-casca-enxuta/testar.mjs .` executa o gate local da iteração. Os cenários existentes continuam cobertos, com a captura respeitando o debug conforme decisão do usuário. `git diff --check` verifica o diff novo. Não existe build Pascal configurado neste workspace.
