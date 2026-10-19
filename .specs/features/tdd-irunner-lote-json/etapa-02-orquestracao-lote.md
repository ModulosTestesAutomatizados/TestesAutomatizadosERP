# Etapa 02: Main do lote e Run individual

Data: 2026-10-06. Status: alteracoes locais aplicadas; verificacao estrutural passou; execucao nativa pendente. Nenhuma publicacao, execucao financeira ou escrita no banco realizada.

## Realizacao

O metodo SetupCasosTestes existente foi transferido de TDD_STARTED para TDD_RUNNER, mantendo dois argumentos (modulo e area) e preenchimento de CDSCasosTestes global. A flag FSetupIniciado tambem pertence agora ao runner. Se a infraestrutura ja estiver ativa, o setup esvazia casos/resultados antes da nova carga para evitar registros de lote anterior.

Main da casca chama SetupCasosTestes uma vez, posiciona First, chama Run para cada registro corrente e avanca Next. A busca transitoria pela descricao foi removida. Main agrega falhas e tenta encerramento independente de metricas residuais, parametros, cache e CDS do lote.

Run existente nao recebe mais parametros e nao busca/recarrega/move CDSCasosTestes. Usa o registro corrente para SetarCasoTeste, inicializa tempos, chama STARTED, codigo IRUNNER gerado, ponto comentado ASSERTS e RegistrarMetricas em sua finalizacao. Reinicia ID historico, status, erro, metodo e etapa por tentativa. RequisitoVersao e obtido do registro corrente, sem atribuicao explicita de string vazia; nao reutiliza o requisito de um caso anterior.

Tempos em aberto sao encerrados antes da persistencia. Falha primaria e capturada antes da finalizacao; erros secundarios sao acumulados sem impedir outras tentativas de fechamento. Controle de vida do CDS de ticks evita Free duplicado entre Run, inicializacao seguinte e limpeza de Main. Logs do historico sao recortados a partir do inicio da tentativa, sem inventar API de limpeza de logs do ERP.

O chamador financeiro informa somente modulo e area. A geracao permanece uma chamada a Interpretar, com os mesmos marcadores existentes. Nenhum metodo foi criado ou removido: SetupCasosTestes foi movido; Run foi ajustado; ASSERTS continua comentado. MensagemPersonalizada ocorre somente na captura externa de Run nos arquivos desta etapa.

## Fontes modificados

- `docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas`
- `docs/assets/emDesenvolvimento/Runner/P39_PROCESSAMENTO_TDD_FINANCEIRO.pas`
- Documentacao TLC: registro desta etapa, contexto, design, tarefas, README e Handoff.

## p/ teste

No interpretador do ERP de homologacao, usar copia do metodo Teste existente com corpo apenas de registro de ID/JSON, sem novas rotinas e sem gravacoes financeiras. A massa de tres casos ativos deve ter IDs e JSONs distintos; incluir descricao repetida para provar que descricao nao e mais chave de selecao.

1. Conferir uma carga e uma Interpretar; observar Run para cada um dos tres IDs, em ordem do indice ID.
2. Conferir tres historicos distintos, cada um ligado ao seu caso e com seus proprios ticks TOTAL/STARTED/IRUNNER/ASSERTS. Tick ASSERTS mede somente o ponto reservado, sem verificacao funcional.
3. Fazer a copia do Teste falhar no segundo caso, sem aplicar parametros ou deixar UI aberta: terceiro caso deve ser tentado e os erros agregados depois do loop.
4. Fazer a copia falhar apos iniciar aplicacao de parametros: sem restauracao disponivel nesta etapa, o lote deve parar e informar nao tentados. Essa interrupcao e conservadora e nao e garantia de restauracao.
5. Simular falha de persistencia e de fechamento: tentativas restantes de limpeza devem ocorrer e a causa primaria deve aparecer antes das secundarias. Falha essencial de callback/liberacao interrompe continuidade.
6. Executar dois lotes de pares diferentes em sessao de teste e conferir ausencia de casos/erro/requisito/ticks do lote anterior.

Verificacoes locais: doze checks estruturais passaram (setup/flag movidos; carga unica na Main; loop chama Run/Next; Run nao move casos; metricas por tentativa; reset de ID/status; requisito vindo do registro; comentario ASSERTS; chamador com dois argumentos; prefixo pessoal unico; CDS global preservado). git diff --check dos quatro arquivos passou. Essas evidencias nao substituem compilacao ou execucao do host.

## O que ha de novo

O fluxo comum passa a executar o registro corrente individualmente, com carga e iteracao controladas pela Main e historico/tempos separados por tentativa.

## Limites desta etapa

- O piloto financeiro ainda registra ExecutarFluxoCompletoFinanceiro e recarrega seu caso fixo no Setup proprio. A infraestrutura itera registros, mas o dominio financeiro ainda precisa da refatoracao seguinte para consumir o JSON herdado. Nao homologar os borderos repetidamente com esse piloto sem essa integracao.
- Baseline/restauracao dos parametros ainda nao implementados. Se o caso falhar apos iniciar VerificarParametros, FLotePodeContinuar fica False. Liberar CDSParametro ao fim do lote nao restaura valores no ERP. Mesmo casos concluidos com overrides exigem a etapa de restauracao para satisfazer LOTE-29 integralmente.
- Resolucao de area por modulo, validacao JSON completa, tratamento de par vazio e demais gates da especificacao continuam pendentes.
- A persistencia de FINISHED existente continua por comandos separados; falha parcial nao recebe retry. METRICAS_ASSERTS permanece comentado.
- Nenhum requisito foi marcado Verified e nenhum commit de conclusao foi criado sem gate nativo. Esta e a etapa incremental escolhida pelo usuario, nao conclusao das 13 tarefas amplas.
