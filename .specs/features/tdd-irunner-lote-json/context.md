# Contexto do lote IRunner e JSON

Data: 2026-10-05. Status: proposta para revisao. Entrega autorizada: planejamento completo, sem implementacao.

## Feature Boundary

Executar os casos do cruzamento modulo/area na mesma interpretacao, reutilizar o ciclo implicito no piloto financeiro e consumir FUNCOES_JSON. Asserts pertencem a outro desenvolvedor.

## Implementation Decisions

Confirmado pelo pedido atual: JvInterpreter e integrado e customizado no ERP; Interpretar processa uma unidade completa; existe heranca implicita e compartilhamento de memoria; o runner deve centralizar o fluxo comum.

O usuario confirmou ambas as preferencias solicitadas durante o estudo: somente casos ativos e continuidade apos falha individual, condicionada a recuperacao segura do estado compartilhado. Se essa recuperacao falhar, interromper o lote e identificar casos nao tentados.

## Agent's Discretion

- Recomendar lote sequencial com um dataset de casos e uma fixture registrada para o par. Os registros variam os dados; este trabalho nao cria um dispatcher de fixtures por registro.
- Registrar somente Teste. O usuario autorizou retirar Setup do piloto; a preparacao comum permanece em STARTED.
- Manter acoplamento por globais existentes, com propriedade de recursos e proibicao de mover o cursor declaradas no design.
- Restaurar os parametros alterados ao baseline capturado no inicio do lote. Sem restauracao comprovada, nao executar o proximo caso que dependeria de estado contaminado.
- Remover constantes de etapa e cEtapaAtual conforme correcao do usuario. O plano conserva a sequencia completa das quatro operacoes, sem novo seletor.

## Correcao expressa do usuario

Remocoes autorizadas: uses TDD_STARTED, TDD_ASSERTS e TDD_CARREGAR_CASO_TESTE; constantes cModuloFinanceiro, cAreaFinanceiro, cCasoTesteUnico, cTipoDuplicataReceber, cTipoDuplicataPagar, cEtapaDuplicataReceber, cEtapaDuplicataPagar, cEtapaBorderoRecebimento, cEtapaBorderoPagamento, cEtapaFluxoCompleto e cEtapaAtual; metodos ExecutarFluxoCompletoFinanceiro e Setup.

Nenhum outro metodo sera removido e nenhum novo sera criado sem pergunta com justificativa e aceite previo. Alterar implementacoes existentes e livre. O plano usa os metodos existentes para preparacao, carga, loop, JSON e limpeza. Setup_InicializarObjetos e TearDown_DestruirObjetos permanecem; seus corpos passam a respeitar recursos compartilhados. Os wrappers locais permanecem e delegam a FUNCOES_JSON.

## Revisao de 2026-10-06

O usuario determinou que MensagemPersonalizada seja acrescentada somente na captura externa de Run. As exceptions internas desta etapa propagam a mensagem sem esse prefixo; capturas podem acrescentar contexto especifico com Ex.Message. Removida a atribuicao explicita de string vazia a FHistoricoExecucao.RequisitoVersao conforme instrucao do usuario; o tratamento de null fica com a persistencia/host.

O while atual em Run e apenas a busca transitoria por descricao, nao execucao de todos os casos. O usuario solicitou esclarecer a possibilidade de colocar a iteracao de execucao na Main da casca. A localizacao final desse loop ainda nao foi alterada nesta revisao; precisa separar orquestracao de lote, execucao individual e captura dos erros da carga antes de mover o ciclo.

## Desenho aprovado e aplicado em 2026-10-06

O usuario autorizou transferir SetupCasosTestes existente para TDD_RUNNER, chamar a carga na Main da casca, iterar nela e executar Run por registro corrente. Essa decisao substitui as propostas anteriores de Run como loop do lote e de Setup em STARTED. Nenhum metodo novo foi necessario. Run nao recebe mais os tres argumentos de descricao; o chamador do gerador informa somente modulo e area para a chamada de setup na Main. ASSERTS permanece comentado.

As quatro units locais modificadas e os gates/limites estao em etapa-02-orquestracao-lote.md. O piloto e a restauracao completa de parametros ainda sao etapas seguintes. Propostas nao confirmadas permanecem como tais; nenhum requisito funcional foi declarado Verified.

## Deferred Ideas (escopo preservado)

## Autorizacao adicional de 2026-10-06

Usuario autorizou somente um metodo novo na casca para extrair responsabilidades da Main: ExecutarLote(modulo, area). Main deve conter apenas a chamada; as duas linhas vazias iniciais do molde devem ser mantidas. O molde nao e executado isoladamente; ele compoe o script gerado com os marcadores de injecao.

lCarregados foi retirado e o resumo usa RecordCount diretamente antes de liberar o CDS. FLotePodeContinuar foi retirado; Run trata e registra falhas individuais recuperaveis, enquanto falhas de estado sobem como exceptions para interromper ExecutarLote. Aguardam-se instrucao para testes nativos e refatoracao do piloto.

## Deferred Ideas (continuam fora do escopo)

## Limpeza autorizada de controles em 2026-10-06

Usuario pediu remover FSetupIniciado, FMetricasTickDiffCriadas, FLotePodeContinuar e FAplicacaoParametrosIniciada, preferindo Assigned e exceptions. Todos permanecem ausentes das units atuais. Nao acrescentar controles globais equivalentes sob outros nomes. A formatacao das instrucoes fica para o encerramento da implementacao.

A pergunta sobre SetarCasoTeste e somente estudo: metodo e chamadas devem ficar preservados nesta etapa. A leitura dos dados ja usa o CDS corrente; reinicializacao do historico/estado da tentativa ainda ocorre nesse metodo. Testes no ERP continuam aguardando instrucao expressa.

## Deferred Ideas (demais itens)

## Revisao aprovada e limpeza da Base em 2026-10-06

Usuario aprovou STARTED e decidiu manter SetarCasoTeste. Autorizou mover a declaracao para perto de SetupCasosTestes e corrigir o cabecalho de responsabilidades, sem alterar seu corpo. Pediu retirar controles de telas, acumuladores de erros e verificacoes repetidas de limpeza da Base. Etapa 05 reutiliza rotinas existentes e exceptions normais; nenhum metodo adicionado/removido. Falhas individuais continuam no historico, falhas de preparacao/finalizacao interrompem. Metricas permanecem ate a proxima inicializacao ou encerramento do lote. A validacao no ERP e a formatacao das instrucoes continuam pendentes.

Dispatcher com varias fixtures, execucao paralela, retry financeiro, rollback de duplicatas/borderos, nova tabela de lote e implementacao de comparacoes de resultado ficam fora desta feature.

## Evidencias pendentes

Identidade do contexto compartilhado e thread de Interpretar, resolucao de nomes e qualificacao, comportamento de Free/Assigned, normalizacao JSON no host, restauracao de parametros, valores de status aceitos pelo banco e criterios reais de selecao de titulos. Essas provas sao tarefas iniciais e gates, sem conclusoes antecipadas.

## Contrato de unit unica autorizado em 2026-10-06

Usuario autorizou as tres etapas propostas: atualizar TLC, ajustar gerador/chamador e refatorar piloto. AddUsesUnit sera renomeado para SetTDDUnit com uma string; AddMetodo e a lista de metodos saem. Executar gera a chamada fixa {UNIT.}Teste no molde, nunca executa Teste fora de Interpretar. Nao ha Setup publico opcional nem novo metodo. Somente Setup e ExecutarFluxoCompletoFinanceiro saem do piloto; demais metodos sao preservados. FEstruturaCasoTesteIniciada permanece conforme decisao expressa.

A sequencia local desta etapa e T11 (gerador), T12 (chamador), T10 (piloto). Essa orientacao substitui a ordem anterior dessas tres tarefas. Gates nativos permanecem pendentes; nao publicar nem executar no ERP nesta etapa. A simplificacao aprovada nas etapas 04/05 tambem substitui os requisitos antigos de flags, agregacao de erros e resumo detalhado.

## Simplificacao do gerador solicitada em 2026-10-06

Usuario rejeitou validacao de caracteres do nome e ampliacao da montagem. Pediu voltar ao formato anterior de Executar, com TStringList/lMetodo, mantendo somente a chamada implicita de Teste. CommaText/Troca originais restaurados, sem scanner adicional. lIndice deixa de existir porque nao ha loop. SetTDDUnit e contrato de uma unit mantidos. Essa decisao substitui a concatenacao direta e as garantias de validacao extra registradas na etapa 06. Somente TDD_IRUNNER foi alterada nesta correcao; piloto/Started/Runner/Base/chamador preservados.


## Acabamentos autorizados após commit local 84eb26b

Usuario autorizou retirar ExtrairTag, TagJson, ValorInteiroTagLocal e ValorCurrencyTagLocal do piloto e chamar FUNCOES_JSON diretamente. Autorizou retirar dependência de CDSConfiguracao e métodos de fallback PessoaPadraoConfig, ValorPadraoConfig, GRPadraoConfig e ContaBorderoPadrao. PESSOA_DUP, VALOR_DUP, GRUPORESULTADO_DUPGR e CONTA_BORD agora geram exception se ausentes, inválidos ou zerados, em ValidarCasoTeste antes das operações financeiras. Isso substitui os fallbacks anteriores.

Usuario confirmou expressamente que QUALIFICACAO_DUP, PESSOANOTACREDITO_BORD e PRAZOVENCIMENTO_DUP continuam opcionais. As demais regras de validação, cálculos, ordem financeira e políticas de continuação não devem ser alteradas.

Logs usam FLogsCasoTeste de TDD_LOGS, com registro somente em FModoDebug e Add(pLog + #13), sem LogDoProcessamento nativo. Run limpa a lista por tentativa, copia Text antes da persistência e limpa ao finalizar; lote libera a lista. Delimitadores marcam as etapas. Instruções das units do fluxo usam MostrarInstrucoesUnit condicionado a FExibirInstrucoes; Main do molde continua com uma chamada.

Após busca em todos os arquivos Pascal locais demonstrar ausência de chamadores, usuario autorizou remover os quatro métodos de exibição de debug (texto/CDS) de TDD_LOGS. MostrarInstrucoesUnit foi preservado. Nenhum método novo necessário nesta etapa.


## Simplificação adicional do piloto e alinhamento autorizados

Usuário autorizou ajustar o código: validação específica permanece em ValidarCasoTeste, chamada diretamente por Teste; Setup_InicializarObjetos já havia sido retirado pelo usuário no arquivo atual. ObterResultadoEsperado/ObterResultadoAtual e SetCasoTeste saem do piloto. DefinirPessoaSelecao é incorporada ao pagamento, preservando seu corpo e sem perder seleção/limpeza do CDS. As duas entradas de borderô são substituídas por _IncluirBordero(pTipo), com 0 para recebimento e 1 para pagamento. TearDown_DestruirObjetos fica no final; suas operações e política TEARDOWN permanecem.

As instruções devem usar exatamente 116 caracteres de = e a mesma coluna para todos os operadores + #13. A formatação foi aplicada às instruções dos sete participantes; Main da Base não foi ampliada. No delimitador de TDD_LOGS, a concatenação termina sem operador + sem operando. Registro com debug e Add(pLog + #13) preservados.

## Limpeza sequencial autorizada

Usuário pediu substituir os finally aninhados do lote por um try/except único com as chamadas existentes. Uma liberação que falhar interrompe as seguintes e gera exception com contexto da limpeza; não há tentativa independente das demais. Esta decisão substitui a garantia anterior de execução de todos os teardowns sob erro. Apenas o bloco de encerramento de ExecutarLote foi alterado; Run e métodos de limpeza permanecem.


## LogsProcessamento e coluna de histórico

Usuário solicitou renomear LogsFalhas para LogsProcessamento no record/parâmetro e LOGS_FALHAS_HE para LOGS_PROCESSAMENTO_HE no banco. Captura agora ocorre em Finished, após o diagnóstico SQL e imediatamente antes do INSERT: FHistoricoExecucao.LogsProcessamento := {TDD_LOGS.}FLogsCasoTeste.Text. A cópia na Base foi retirada.

Migration preparada em sql/temp-local/migracao_historico_logs_processamento.sql, usando ALTER COLUMN TO; não aplicada. DDL original aprovada permanece histórica, para aplicação sequencial da migration posterior. MER atualizado com indicação explícita da alteração prevista.

Registro segue condicionado a FModoDebug. A solicitação literal de captura antes do INSERT foi implementada. Mensagens posteriores ao INSERT (ID/métricas/erros de persistência) não entram nessa cópia. Pergunta assíncrona apresentou a alternativa de UPDATE no mesmo histórico, ainda sem resposta; não foi introduzido UPDATE por inferência.

## Finished sem logs de persistência

Usuário esclareceu que não quer registrar mensagens de gravação de métricas. Removidas todas as emissões de RegistrarLogEmModoDebug de Finished, inclusive SQL, ID, contagem e erro de persistência. A captura de LogsProcessamento antes do INSERT permanece, sem UPDATE adicional. Run já possui Clear no finally externo e na entrada: preservado, garante texto limpo após cada tentativa com sucesso ou exception. Nenhuma alteração na Base necessária nesta etapa.
