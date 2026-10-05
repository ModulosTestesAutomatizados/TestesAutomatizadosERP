# Revisao do piloto financeiro para integracao com IRunner

**Fonte:** docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas.
**Status:** Revisao e ajustes locais do MVP. Integracao no ERP ainda pendente.

## Conclusao

O fluxo da fixture precisa somente de Teste. STARTED seleciona o caso, aplica parametros e valida versao. O piloto valida tags financeiras no inicio de Teste e chama CarregarConfiguracoes, que preenche o CDSConfiguracao global por modulo. O runner geral e responsavel pelo Setup/TearDown do ciclo.

## Comparacao de responsabilidades

| Responsabilidade | STARTED atual | Piloto atual | Destino proposto |
| --- | --- | --- | --- |
| Escolher modulo, area e caso | SetupCasoTeste | Constantes + CarregarCasoTeste | STARTED, com contexto fornecido pelo processamento |
| Obter JSON do caso | CDSCasosTestes global | FCDSCasoTeste + FJSONCasoTeste | Ler o registro escolhido pelo ID do STARTED no CDS global, sem manter copia local |
| Aplicar parametros do ERP | AplicarParametrosDoCasoTeste | Nao faz | STARTED |
| Validar versao | ValidarVersaoRequisito | Nao faz | STARTED |
| Carregar configuracao financeira | CDSConfiguracao compartilhado | Setup_InicializarObjetos | Teste chama CarregarConfiguracoes e le CDSConfiguracao compartilhado |
| Validar EMPRESA_DUP/TIPODOC_DUP | Nao faz | ValidarCasoTeste | Teste financeiro, erro propagado ao runner |
| Executar quatro operacoes | Nao faz | Teste | Teste financeiro |
| Controlar callbacks gerais | Casca Run | Teste tambem abria/fechava | Casca; preservar mensagens de progresso especificas |
| Liberar configuracao propria | TearDown geral do ciclo, conforme fluxo informado pelo usuario | TearDown_DestruirObjetos | Nao criar CDS local; runner geral libera os CDS compartilhados |
| Fechar telas financeiras | Nao faz | Fechamento ao final normal ou excecao engolida | Finally da respectiva operacao |
| Obter resultado esperado | Caso cadastrado | FCDSCasoTeste | Preservar acesso ao caso selecionado; alinhar ponto de consumo com responsavel ASSERTS |

## O que enxugar

| Trecho | Acao proposta | Condicao de remocao |
| --- | --- | --- |
| ExecutarFluxoCompletoFinanceiro | Deixar de registrar; remover a segunda orquestracao | Somente Teste registrado; ciclo geral continua na casca |
| CarregarCasoTeste no Setup | Removido do piloto | JSON e metadados disponiveis a partir do caso selecionado por STARTED |
| FCDSCasoTeste | Remover dataset local duplicado | Usar CDSCasosTestes e CDSResultadoEsperado globais |
| cModuloFinanceiro/cAreaFinanceiro/cCasoTesteUnico | Retirar do fluxo de carga; evitar configuracao duplicada | Main passa a documentar contexto vindo do processamento |
| Abertura/fechamento de callback em Setup/Teste | Remover repeticao do callback generico | Confirmar em runtime ClassOwner e callbacks da casca; mensagens especificas permanecem |
| FCDSConfig retido globalmente | Usar CDSConfiguracao existente e compartilhado | Oito valores abaixo preservados |
| TearDown_DestruirObjetos | Remover depois de eliminar datasets retidos | Nenhum objeto proprio pendente no piloto; teardown geral limpa os recursos compartilhados |
| FCasoTesteInvalido + Exit no Teste | Validar no Teste e propagar excecao | Diagnostico de tags preservado; nao enviar mensagem interna como parte do runner |
| lEsperado/lAtual no wrapper | Deixar de depender do wrapper | Coordenar interface com ASSERTS; nao implementar validacao de resultado nesta tarefa |
| TagJson, SetCasoTeste e variaveis lPosEmpresa/lPosTipoDoc | Candidatos a remocao | Busca em todas as units/contexto do ERP confirma ausencia de consumidores; ausencia local nao prova ausencia remota |
| uses TDD_STARTED/TDD_ASSERTS/TDD_CARREGAR_CASO_TESTE | Revisar apos alteracoes | Preservar dependencias transitivas necessarias; nao retirar uses apenas por aparencia |
| Leitores JSON locais | Manter inicialmente | Sao paliativos ligados ao interpretador customizado; simplificacao exige prova com JSON real |

## Defaults financeiros que Teste deve preservar

Preservar os oito campos efetivamente lidos no fonte:

| Campo real | Consumidor |
| --- | --- |
| CLIENTE_FINCONFIG | PessoaPadraoConfig e bordero de recebimento |
| FORNECEDOR_FINCONFIG | PessoaPadraoConfig e bordero de pagamento |
| VALOR_PADRAO_RECEBER_FINCONFIG | ValorPadraoConfig para receber |
| VALOR_PADRAO_PAGAR_FINCONFIG | ValorPadraoConfig para pagar |
| GR_CONTAS_RECEBER_FINCONFIG | GRPadraoConfig para receber |
| GR_CONTAS_PAGAR_FINCONFIG | GRPadraoConfig para pagar |
| TIPO_FINCONFIG | Tipo de documento |
| CONTA_PRINCIPAL_FINCONFIG | ContaBorderoPadrao |

Esses campos foram conferidos contra as chamadas a FCDSConfig.FieldByName no fonte local.

## Decisao de ciclo e compartilhamento

O processamento registra apenas Teste e informa modulo/area. A unit base herda o `uses` fixo de TDD_RUNNER e percorre CDSCasosTestes sem clone; STARTED carrega o conjunto ativo uma vez e prepara cada registro antes de Teste. Cada caso fecha suas metricas/historico; TearDown limpa os CDS de casos, resultados, campos e configuracao, parametros e cache uma vez ao final do lote, inclusive apos falha de carga.

**Ponto de integração:** `TDD_BASE_UNIT_IRUNNER.Run` chama `TearDown` no finally externo ao loop. `TDD_RUNNER.TearDown` tenta liberar parametros, cache, CDS de casos/resultados/campos/configuracao e estado de STARTED de forma independente. A execucao nativa ainda precisa confirmar o comportamento quando uma liberacao falha.

## Pontos de estabilidade do piloto

- Validar no ERP que o fluxo geral executa TearDown depois de falhas em Teste e libera os CDS compartilhados.
- Conferir que a selecao do caso no CDS global permanece estavel ate a leitura do JSON pelos helpers de STARTED.
- Fechamento das telas ocorre fora de finally nas rotinas financeiras.
- VlrPagar e acumulado sem inicializacao explicita nas duas rotinas de bordero. A implementacao deve iniciar cada acumulacao em zero para tornar a regra do total explicita.
- ExtrairTag declara lMarcador como Integer e o utiliza como texto. Conferir comportamento customizado e corrigir declaracao para String ao tocar esse leitor, sem alterar sua estrategia de fallback sem teste.
- ObterResultadoAtual devolve true fixo para quatro campos. E um ponto de integracao pendente do responsavel ASSERTS, nao evidencia de resultado real.
- O seletor cEtapaAtual e os helpers de inclusao continuam uteis. O IRunner nao substitui o trabalho financeiro.
- Limpeza nao e rollback: as operacoes gravadas antes da falha continuam existentes.

## Evidencia necessaria antes de executar tarefas

Verificar JSON/ID do caso e acesso entre units dentro da mesma interpretacao; verificar ClassOwner; verificar sucesso e falha em cada operacao. Usar uma fixture sem alteracoes financeiras para falhas artificiais de tick, persistencia e callback. Nao executar o financeiro real como sonda de tratamento de excecao.
