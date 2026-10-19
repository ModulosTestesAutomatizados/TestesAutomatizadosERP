# Sincronização de uma fonte JSON

## Problem Statement

O registro recebe três units JSON e substitui erros de leitura por {}. A validação reprova um objeto vazio, apesar da nova decisão de usá-lo como desativação explícita. O usuário autorizou uma fonte única e duas units remotas de padrão: resultadoEsperado ausente usa a mínima de asserts; camposDisponiveis ausente ou vazio usa a mínima de campos, atualmente {}.

## Goals

- Registrar dados, campos e resultado a partir de uma unit do caso.
- Reutilizar uma função de resolução de objetos e fallback.
- Preservar STARTED, efeitos das verificações explícitas e o index do usuário.

## Out of Scope

| Item | Motivo |
| --- | --- |
| Gravar em banco, sincronizar o ERP, stage ou commit | Somente implementação e verificações locais |
| Regras de preenchimento de camposDisponiveis | A unit remota criada pelo usuário contém {} nesta etapa |
| Alterar parâmetros ou regras financeiras | Preservar a lógica aprovada |
| Reescrever as units legadas de faturamento | Seus exemplos locais são fontes Pascal e não JSON; somente migrar a aridade dos registros |
| Documentação do portal | Outra frente |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Fonte | Dados na raiz, junto de parametros, resultadoEsperado e camposDisponiveis | Contexto do usuário | Sim |
| Mínimo | P39_TDD_ASSERTS_JSON_MINIMO, cujo conteúdo tem resultadoEsperado na raiz | Adição explícita ao contexto | Sim |
| Campos | Ausência ou {} consulta P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO; objeto preenchido é preservado | Nova decisão do usuário nesta execução | Sim |
| Resultado explícito | {} não usa mínimo e não executa novas verificações | Decisão do usuário | Sim |
| Campos futuros | Aceitar {} na unit mínima; preenchimentos futuros usam camposDisponiveis na raiz | Mesmo contrato do mínimo de resultado, sem mudanças posteriores de fluxo | Sim |
| Dados no banco | Preservar as duas propriedades resolvidas em CASO_TESTE_CT e suas tags nos objetos separados das outras duas colunas | STARTED preservada | Sim, contexto |
| Legados | Registros de faturamento passam a resolver resultado pela fonte única; expectativas antigas separadas precisam estar nessa fonte para continuar específicas | Não manter contrato de três fontes descartado pelo usuário | Impacto explícito |
| Verificação | Métodos Pascal extraídos e APIs externas substituídas | Não existe compilador/ERP local disponível | Limite explícito |

**Open questions:** none, decisões e impactos registrados acima.

## User Stories

### P1: Sincronizar uma fonte com defaults explícitos

**Acceptance Criteria**:

1. WHEN RegistrarCasoTeste é chamado THEN o registro SHALL receber seis argumentos: módulo, área, descrição, requisito, uma unit JSON e controle remoto. (SYNC-01)
2. WHEN a fonte é carregada THEN o registro SHALL manter resultadoEsperado e camposDisponiveis resolvidos na raiz de CASO_TESTE_CT, preservar suas tags nas colunas específicas e preservar os demais dados da fonte. (SYNC-02)
3. IF resultadoEsperado está ausente THEN o resolvedor SHALL carregar P39_TDD_ASSERTS_JSON_MINIMO e extrair seu objeto resultadoEsperado. (SYNC-03)
4. WHEN resultadoEsperado é um objeto explícito, inclusive {} THEN o resolvedor SHALL preservá-lo sem consultar a unit mínima. (SYNC-04)
5. WHEN camposDisponiveis está ausente ou vazio THEN o registro SHALL carregar P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO e aceitar seu conteúdo atual {}. (SYNC-05)
6. WHEN camposDisponiveis está preenchido THEN o registro SHALL preservar seu objeto na coluna correspondente. (SYNC-06)
7. IF a fonte, uma propriedade reservada ou o fallback necessário possui formato inválido THEN o registro SHALL rejeitar a configuração antes de executar fallback SQL ou sincronização com escrita. (SYNC-07)
8. WHEN um nome remoto já começa com P39_ THEN CarregarConteudoUnit SHALL não duplicar o prefixo. (SYNC-08)
9. WHEN o resultado esperado é um objeto vazio, com qualquer formatação JSON válida THEN a validação SHALL registrar SEM_VALIDACAO sem acrescentar ou apagar asserts existentes. (SYNC-09)
10. IF o resultado esperado não vazio está malformado ou contém verificações inválidas THEN a validação SHALL continuar reprovando a configuração. (SYNC-10)
11. The implementação SHALL resolver os dois objetos pelo mesmo método, permitindo configurar unit de fallback e política de vazio sem criar uma segunda função para campos. (SYNC-11)

12. WHEN parametros está ausente na fonte THEN o registro SHALL omitir essa propriedade no JSON final, sem acrescentar fallback vazio. (SYNC-12)
13. WHEN o caso já existe THEN a sincronização SHALL consultar e solicitar confirmação antes de carregar a fonte ou os mínimos; a recusa SHALL dispensar leitura e escrita desse caso e permitir continuar o lote. (SYNC-13)

**Independent Test:** capturar o registro completo antes de SQL, simular falhas de leitura e tipos inválidos, testar os três estados de presença e executar o comparador vazio com asserts explícitos anteriores.

## Edge Cases

- Objetos formatados, strings com aspas/chaves e objetos aninhados nos dados.
- Propriedade explícita null, array, texto ou número não significa ausência.
- Fallback inexistente, JSON inválido, propriedade faltante ou vazia não vira {} silenciosamente.
- A política futura de campos usa fallback quando explicitamente habilitada; resultado vazio sempre pode desativar o padrão.
- Todos os quatro registros existentes devem chamar a nova assinatura.

## Correção de contrato aprovada

O modelo docs/assets/snippets/TDD_CASO_TESTE_MODELO_JSON.json orienta a estrutura final; não é uma fonte carregada na sincronização. camposDisponiveis e resultadoEsperado devem manter a tag, inclusive vazios. parametros só permanece quando já existe na fonte. O comparador aceita a tag resultadoEsperado e os registros anteriores com as seções diretamente na raiz. A resolução possui no máximo duas tentativas. Preservar as convenções de leitura do usuário, sem alterar STARTED, documentação publicada ou realizar commits.

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| SYNC-01 | Fonte única | Execute | Verified |
| SYNC-02 | Fonte única | Execute | Verified |
| SYNC-03 | Fonte única | Execute | Verified |
| SYNC-04 | Fonte única | Execute | Verified |
| SYNC-05 | Fonte única | Execute | Verified |
| SYNC-06 | Fonte única | Execute | Verified |
| SYNC-07 | Fonte única | Execute | Verified |
| SYNC-08 | Fonte única | Execute | Verified |
| SYNC-09 | Fonte única | Execute | Verified |
| SYNC-10 | Fonte única | Execute | Verified |
| SYNC-11 | Fonte única | Execute | Verified |

## Success Criteria

- Gates locais dos onze critérios aprovados e revisão independente com mutações isoladas.
- Nenhuma escrita em banco, sincronização efetiva, stage ou commit.
- Sondas anteriores adaptadas somente aos nomes movidos e ao contrato explicitamente substituído de {}.

## Gate Check Commands

- `node .specs/features/sincronizacao-fonte-unica/evidencias/testar.mjs`
- `node .specs/features/sincronizacao-fonte-unica/evidencias/testar-confirmacao.mjs`
- `node .specs/features/sincronizacao-fonte-unica/evidencias/verificar-independente.mjs`
- `node .specs/features/sincronizacao-fonte-unica/evidencias/sensor-independente.mjs`
- `git diff --check`

A revisão dos onze critérios está em validation.md. Os três comandos de testes compõem o gate: o teste independente detecta a política de fallback errada no chamador, que não é coberta apenas pelo teste isolado do resolvedor. Execução nativa continua sendo uma validação posterior.

## Execution Plan

1. Resolver objetos e leitura estrita na unit de registro; testar presença, tipos, fallback e prefixo.
2. Reduzir RegistrarCasoTeste e migrar os quatro consumidores e o modelo JSON financeiro; testar projeção e ordem anterior ao SQL.
3. Tratar objeto vazio no comparador existente, preservando asserts prévios; executar regressões relacionadas.
4. Revisão independente, sensor em cópias isoladas e relatório local. Sem commits por instrução do usuário.
