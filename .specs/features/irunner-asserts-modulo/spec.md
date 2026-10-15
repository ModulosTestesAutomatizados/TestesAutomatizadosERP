# IRunner: nomes, módulo e métricas de asserts

## Problem Statement

Os arquivos foram renomeados no commit 0303da9, mas referências executáveis ainda usam os nomes anteriores. ASSERTS permanece sem integração na casca e seu INSERT está comentado. MODULO duplica configuração/carga de casos; VALIDAR_RESULTADO mistura comparação, acúmulo, cronômetro, controle de execução e apresentação.

Esta especificação inicia uma nova iteração. A especificação irunner-casca-enxuta não cobre sua implementação. Estado: proposta para revisão; nenhum requisito abaixo está implementado ou validado por esta especificação.

## Goals

- Resolver as dependências executáveis com os nomes TDD_RUN_* e os nomes remotos P39_* correspondentes.
- Integrar módulo e asserts sem novos wrappers de ciclo de vida.
- Isolar estados por caso e usar reprovações no status do histórico e no resumo do lote.
- Persistir métricas e evidências de asserts pelo histórico retornado, inclusive em falhas parciais.
- Reduzir VALIDAR_RESULTADO às responsabilidades de validação.

## Out of Scope

| Item | Motivo |
| --- | --- |
| Documentação do portal, mapas AST e manuais | Outra frente do usuário; somente artefatos TLC desta iteração |
| Alterar o comportamento da STARTED ou o JSON de parâmetros | Aprovados pelo usuário; somente referências de nomes podem ser corrigidas |
| Novos métodos Preparar/Encerrar/PersistirAsserts | Reutilizar AssertsZerar, RegistrarResultado, SetarCasoTeste, RegistrarTick e RegistrarMetricas |
| Novas tabelas e migrations | METRICAS_ASSERTS existente atende ao resumo por tentativa |
| Executar o financeiro, sincronizar fontes, publicar ou escrever em banco | Trabalho local; consultas somente em leitura |
| Stage, commit e push | Manter o próximo diff disponível ao usuário |
| Reescrever testes legados de outros módulos | Corrigir somente consumidores e dependências necessários ao caminho IRunner; impacto em compartilhados deve ser identificado |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Nomes | TDD_RUN_* no ambiente local e P39_TDD_RUN_* quando o destino é remoto | Regra expressa do usuário; não converter todo P39_* em nome local indiscriminadamente | Sim |
| STARTED | Preservar comportamento e extração de parâmetros | Aprovação explícita anterior | Sim |
| FDescModulo | Usar estado único de CASOS_DE_TESTE, removendo a duplicação de RUN_MODULO | Aprovado nesta conversa | Sim |
| Novos wrappers | Nenhum; adaptar os métodos existentes | Preferência reiterada do usuário | Sim |
| Debug | Conservar FModoDebug e sua transmissão para Interpretar | O usuário rejeitou captura incondicional anteriormente | Sim |
| Resultado esperado ausente/vazio | Sem validação automática: registrar SEM_VALIDACAO nos logs, sem inventar aprovação de assert; asserts explícitos continuam contando | Compatibilidade com pilotos que executam sem resultado esperado configurado | Proposta para revisão |
| Resultado esperado configurado | Conteúdo inválido, seção desconhecida ou configuração sem verificações produz assert reprovado | Impedir SUCESSO com validação configurada mas não executada | Proposta para revisão |
| Granularidade da persistência | Uma linha agregada de METRICAS_ASSERTS por histórico, incluindo total zero | Tabela existente armazena resumo e dois BLOBs; não possui estado próprio de validação | Proposta para revisão |
| Datasets intermediários | Registrar uma cópia dos dados disponíveis em cada ponto relevante; última captura da mesma chave substitui a anterior | O financeiro fecha datasets durante Teste, antes de ASSERTS | Proposta para revisão |
| Esperado/obtido | Persistir o esperado do caso e um relatório determinístico com cada comparação e seus valores efetivos | Resumo atual contém falhas, mas não evidencia todos os aprovados | Proposta para revisão |
| Exceções de execução | Preservar a causa e os contadores parciais; não converter automaticamente exceções em erros esperados | Não mascarar instabilidade do runner por uma expectativa erro.quantidade | Proposta para revisão |
| Compatibilidade | Evidência local com fronteiras substituídas e validação posterior no ERP | Não há compilação nativa/JvInterpreter do ERP configurada na sessão | Limite conhecido |

**Open questions:** none — as decisões ainda não confirmadas estão registradas como propostas na tabela acima. A implementação começa após revisão desta especificação.

## User Stories

### P1: Executar com dependências e contexto únicos

**User Story:** Como mantenedor, quero usar as units renomeadas sem carregar estados concorrentes de logs, asserts ou módulo.

**Acceptance Criteria**:

1. The fluxo IRunner SHALL resolver os uses executáveis para os nomes disponíveis no destino e não referenciar TDD_IRUNNER, TDD_RUNNER, TDD_LOGS, TDD_STARTED ou TDD_FINISHED antigos nesse caminho. (RUN-01)
2. WHEN Executar gera o programa THEN o IRunner SHALL buscar TDD_RUN_UNIT_BASE_IRUNNER e chamar a unit financeira TDD_FIN_FINANCEIRO configurada pela entrada. (RUN-02)
3. The cadeia transitiva do IRunner SHALL carregar uma única implementação de estado para logs e uma única para asserts, sem ciclos introduzidos pela integração. (RUN-03)
4. WHEN o lote carrega seus casos THEN SetupCasosTestes SHALL permanecer o único responsável pela carga e pelo avanço First/Run/Next coordenado pela casca. (RUN-04)
5. The RUN_MODULO SHALL usar FDescModulo de CASOS_DE_TESTE sem redeclarar esse estado ou recarregar casos para abrir/focar a tela. (RUN-05)
6. IF o módulo não está configurado ou a tela principal não existe THEN os métodos de tela SHALL produzir diagnóstico sem acrescentar MensagemPersonalizada. (RUN-06)

**Independent Test:** analisar o grafo Pascal ignorando comentários/strings e simular geração e módulo; demonstrar uma carga e cursor inalterado pelas operações de tela.

### P1: Validar sem misturar estados entre tentativas

**User Story:** Como executor, quero resultados de asserts vinculados somente ao caso corrente, mesmo quando o caso anterior falha.

**Acceptance Criteria**:

1. WHEN SetarCasoTeste inicia uma tentativa THEN o fluxo SHALL zerar contadores, falhas, datasets registrados, métricas de asserts, resultados e erros reais da tentativa anterior antes de ler o novo registro. (RUN-07)
2. WHEN RegistrarResultado registra uma verificação THEN RUN_ASSERTS SHALL atualizar total e exatamente um dos contadores aprovado/reprovado, preservando descrição, esperado e obtido disponíveis no caminho da comparação. (RUN-08)
3. WHEN a validação automática inicia THEN CompararComJSON SHALL preservar asserts explícitos já executados no mesmo caso. (RUN-09)
4. IF qualquer assert é reprovado THEN a tentativa SHALL registrar FALHA e um diagnóstico no resumo final sem interromper os demais casos quando a limpeza e a persistência permitem continuar. (RUN-10)
5. IF a execução falha após realizar verificações THEN o fluxo SHALL preservar a causa original e os resultados parciais para finalização. (RUN-11)
6. WHEN RegistrarDataSet captura um dataset THEN o estado de validação SHALL preservar seus dados mesmo após fechar a tela, sem liberar ou editar o componente original do ERP. (RUN-12)
7. IF uma referência configurada de dataset/campo está ausente, inativa sem captura ou ambígua THEN a comparação SHALL registrar reprovação em vez de ignorar silenciosamente a expectativa. (RUN-13)

**Independent Test:** executar dois casos consecutivos, primeiro reprovado e segundo aprovado; fechar o dataset original após captura e validar a cópia; simular exceção após um assert aprovado.

### P1: Comparações confiáveis e responsabilidades definidas

**User Story:** Como autor de testes, quero comparações corretas sem mensagens interativas ou reinicializações que descartem resultados.

**Acceptance Criteria**:

1. The VALIDAR_RESULTADO SHALL limitar-se à leitura da expectativa do caso e às comparações, delegando acúmulo a RUN_ASSERTS, tempos ao runner, logs a RUN_LOGS e persistência a FINISHED. (RUN-14)
2. WHEN a operação é Maior ou Menor THEN as comparações SHALL avaliar obtido > esperado ou obtido < esperado respectivamente, inclusive para números e datas. (RUN-15)
3. WHEN o tipo é inteiro, moeda, data, booleano ou texto THEN a igualdade SHALL respeitar esse tipo sem converter uma entrada inválida em zero, data zero ou falso para aprová-la. (RUN-16)
4. IF uma operação, tipo ou expectativa configurada é inválida THEN o validador SHALL registrar um assert reprovado com o contexto do erro. (RUN-17)
5. WHEN uma comparação termina THEN o validador SHALL não exibir ShowMessage/MostrarLogTexto nem alterar ScriptDeTestesEmExecucao. (RUN-18)
6. IF não existe resultado esperado configurado THEN o fluxo SHALL registrar SEM_VALIDACAO no log e preservar o resultado dos asserts explícitos. (RUN-19)
7. WHEN uma seção tempo é comparada THEN o validador SHALL usar o tempo de execução do teste registrado pelo runner antes da validação, sem incluir FINISHED e sem reiniciar um cronômetro próprio. (RUN-20)

**Independent Test:** matriz de tipos e operações com limites iguais, maior e menor; valores malformados; expectativa ausente e configurada inválida; spies rejeitam diálogos e alterações de flags.

### P1: Persistir métricas mesmo em execução parcial

**User Story:** Como responsável pelo piloto, quero consultar o histórico, os logs e os resultados de asserts de cada tentativa.

**Acceptance Criteria**:

1. WHEN um histórico é inserido e retorna ID válido THEN RegistrarMetricas SHALL inserir uma linha agregada de METRICAS_ASSERTS com esse ID e os oito parâmetros de FK, etapa, tempo, contadores e resultados previstos pelo esquema existente. (RUN-21)
2. WHEN a tentativa possui asserts parciais ou total zero THEN RegistrarMetricas SHALL persistir os valores reais desses contadores sem reutilizar métricas do caso anterior. (RUN-22)
3. IF a gravação de métricas falha após inserir o histórico THEN o fluxo SHALL propagar diagnóstico de FINISHED preservando a causa anterior e sem repetir automaticamente o INSERT do histórico. (RUN-23)
4. The fluxo SHALL usar RegistrarTick para medir ASSERTS e manter TEMPO_TOTAL_AT em milissegundos dentro do domínio Integer aceito pela tabela. (RUN-24)
5. WHEN o caso termina com sucesso ou falha e debug está ativo THEN FINISHED SHALL copiar os logs antes de persistir e antes da limpeza por tentativa. (RUN-25)

**Independent Test:** capturar os parâmetros enviados ao ODBC em sucesso, reprovação, exceção parcial e nenhum assert; injetar falha no INSERT filho e verificar ausência de retry do histórico.

## Edge Cases

- Primeiro caso sem estrutura em memória e segundo caso após falha com datasets capturados.
- Duas origens com o mesmo nome de campo; seleção por chave de dataset deve evitar aprovação acidental.
- Dataset fechado antes de ASSERTS e dataset recapturado após uma segunda operação.
- Exceção no teste, exceção na validação, falha de cleanup e falha de persistência mantendo a primeira causa.
- Resultado esperado ausente, vazio, malformado e com seção desconhecida são cenários distintos.
- Asserts explícitos antes da validação automática não podem ser apagados por CompararComJSON.
- Tempo medido igual a zero é um resultado válido; o relógio bruto não pode provocar overflow de Cardinal para Integer.

## Responsibility Design

| Unidade | Responsabilidade nesta iteração |
| --- | --- |
| RUN_IRUNNER | Gerar código com nomes corretos e transmitir debug |
| RUN_UNIT_BASE_IRUNNER | Coordenar lote, fases, finally e feedback central |
| RUN_RUNNER | Preparar/reiniciar contexto e métricas; medir etapas com RegistrarTick |
| RUN_STARTED | Comportamento aprovado preservado |
| RUN_MODULO | Interação de tela usando contexto já configurado; sem duplicar SetModulo de CASOS_DE_TESTE |
| RUN_ASSERTS | Primitivas, contadores, evidências e capturas de dados pertencentes ao caso |
| VALIDAR_RESULTADO | Interpretar expectativa e comparar valores com as primitivas existentes |
| RUN_FINISHED | Consolidar os valores finais necessários e persistir histórico, asserts e ticks |
| RUN_LOGS | Lista compartilhada com captura condicionada a debug |

Reutilizar CompararResultadoEsperado e demais entradas existentes. Remover a dependência MODULO -> VALIDAR_RESULTADO se não houver chamada; carregá-las no ponto do fluxo que realmente as utiliza. Não remover um uses apenas porque o chamador possui a dependência: verificar a cadeia transitiva da própria unit no interpretador. Não introduzir RUN_ASSERTS -> RUN_RUNNER -> RUN_ASSERTS; o runner copia resultados do núcleo de asserts para sua métrica.

O registro de datasets deve acontecer enquanto cada resultado financeiro está disponível, inclusive antes dos fechamentos intermediários. A etapa ASSERTS consulta capturas e consolida o caso; o finally financeiro conserva a limpeza. Nenhuma cópia possui autorização para gravar em banco ou para liberar os componentes originais.

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| RUN-01 | Dependências | Execute | Verified |
| RUN-02 | Dependências | Execute | Verified |
| RUN-03 | Dependências | Execute | Verified |
| RUN-04 | Dependências | Execute | Verified |
| RUN-05 | Dependências | Execute | Verified |
| RUN-06 | Dependências | Execute | Verified |
| RUN-07 | Estados | Execute | Verified |
| RUN-08 | Estados | Execute | Verified |
| RUN-09 | Estados | Execute | Verified |
| RUN-10 | Estados | Execute | Verified |
| RUN-11 | Estados | Execute | Verified |
| RUN-12 | Estados | Execute | Verified |
| RUN-13 | Estados | Execute | Verified |
| RUN-14 | Comparações | Execute | Verified |
| RUN-15 | Comparações | Execute | Verified |
| RUN-16 | Comparações | Execute | Verified |
| RUN-17 | Comparações | Execute | Verified |
| RUN-18 | Comparações | Execute | Verified |
| RUN-19 | Comparações | Execute | Verified |
| RUN-20 | Comparações | Execute | Verified |
| RUN-21 | Persistência | Execute | Verified |
| RUN-22 | Persistência | Execute | Verified |
| RUN-23 | Persistência | Execute | Verified |
| RUN-24 | Persistência | Execute | Verified |
| RUN-25 | Persistência | Execute | Verified |

**Coverage:** 25 requisitos definidos; tarefas e implementação ainda não iniciadas.

## Implicit Requirements Sweep

| Dimensão | Tratamento |
| --- | --- |
| Entrada e limites | RUN-13, RUN-15 a RUN-17, RUN-24 |
| Falha parcial | RUN-10, RUN-11, RUN-22, RUN-23 |
| Idempotência/retry | RUN-21, RUN-23; uma chamada de finalização por tentativa, sem retry automático |
| Autorização | Nenhuma nova fronteira de autenticação; consultas somente em leitura nesta sessão |
| Concorrência/ordem | Fluxo sequencial; isolamento por caso em RUN-07 a RUN-12 |
| Ciclo de vida | Capturas pertencem ao caso; limpar/liberar sem afetar componentes do ERP |
| Observabilidade | RUN-08, RUN-18, RUN-19, RUN-25 |
| Dependências externas | RUN-01 a RUN-03, RUN-06, RUN-23 |
| Integridade dos estados | RUN-04, RUN-05, RUN-07, RUN-09 a RUN-11 |

## Success Criteria

- Todos os 25 requisitos demonstrados por verificações derivadas desta especificação.
- Revisão independente e sensor de discriminação em cópias isoladas antes de concluir a implementação.
- Nenhuma mudança funcional em STARTED ou na leitura do JSON de parâmetros.
- Nenhuma escrita em banco, sincronização, stage ou commit durante a implementação local.
- Validação nativa separada, com resultado observado pelo usuário no ERP; testes simulados não comprovam integração ODBC/JvInterpreter.

## Source Findings

Baseline inspecionado: 0303da9, árvore limpa antes de criar esta proposta. P39_TDD_VALIDAR_RESULTADO foi adicionado pelo usuário e depende de P39_TDD_ASSERTS, diferente da nova P39_TDD_RUN_ASSERTS. O validador usa AssertFalhou/AssertIgualMoeda enquanto a nova unit oferece AssertsFalhou/AssertIgualCurrency; comparações numéricas e de datas Maior/Menor estão invertidas; igualdade ignora o caminho tipado; lDM pode ser reaproveitado indevidamente entre origens; campo não encontrado pode não gerar assert. CompararComJSON reinicia asserts já acumulados; FinalizarComparacao e CompararValor alteram ScriptDeTestesEmExecucao; há diálogos interativos e cronômetro duplicado.

O esquema real METRICAS_ASSERTS foi consultado em READ ONLY na análise anterior: FK obrigatória, etapa/tempo/contadores Integer e esperado/obtido BLOB texto. A implementação deve usar a abstração ODBC existente, sem criar conexão paralela ou tabela nova.
