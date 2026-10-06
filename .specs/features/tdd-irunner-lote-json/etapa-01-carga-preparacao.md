# Etapa 01: carga do conjunto e preparacao corrente

Status: alteracoes locais aplicadas; verificacao estrutural passou; validacao nativa pendente. Nenhum commit ou publicacao realizado nesta etapa.

## Realizacao

Conforme a sequencia autorizada pelo usuario, SetupCasoTeste foi renomeado para SetupCasosTestes, com dois argumentos: modulo e area. Esse metodo reutiliza SetModulo, SetArea e CarregarCasosTeste para preencher CDSCasosTestes, que continua global em P39_TDD_CASOS_DE_TESTE. Nao seleciona um caso nem aplica parametros individuais.

Started agora prepara o registro corrente: valida a disponibilidade do CDS, copia ID/JSON/descricao para o contexto compartilhado, verifica versao e aplica os parametros desse caso. Nao chama o carregador e nao move o cursor. ValidarVersaoRequisito define True quando nao ha requisito e registra o requisito normalizado no historico.

A casca chama SetupCasosTestes antes de Started. A busca original por descricao foi transferida para Run para preservar o comportamento atual de caso unico ate a proxima responsabilidade: iterar e finalizar todos os casos. Nao foi implementado o loop de execucao do lote.

Nenhum metodo novo foi criado e nenhum metodo foi removido; somente a renomeacao autorizada. Piloto, gerador, persistencia, helpers JSON e demais units nao foram alterados. O carregador compartilhado continua com seu comportamento atual, inclusive preenchimento aditivo e erro quando nenhum caso existe; reset do lote, area por modulo e limpeza completa permanecem etapas futuras.

## Fontes modificados

- `docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas`
- `.specs/features/tdd-irunner-lote-json/etapa-01-carga-preparacao.md`
- `.specs/features/tdd-irunner-lote-json/tasks.md`
- `.specs/STATE.md`

## p/ teste

Validacoes abaixo ainda precisam ser realizadas no ambiente de testes do ERP, em sessao com as units atualizadas. Como os parametros podem alterar configuracao do sistema, usar o ambiente de homologacao previsto no plano.

1. Execute a carga do modulo/area e confira que o CDS global contem o conjunto ativo. A carga isolada nao deve aplicar os parametros individuais.
2. Posicione o CDS em um caso conhecido e execute Started no contexto do runner. Confira ID, descricao e JSON no contexto/historico, sem mudanca de posicao nem nova carga.
3. Repita com outro registro, inclusive com descricao igual se houver massa apropriada; Started deve usar o ID/JSON correntes.
4. Confira caso sem requisito de versao: a verificacao deve retornar True, sem atribuicao explicita de string vazia ao requisito; verificar o tratamento de null no host/persistencia.
5. Confira versao incompativel: Started deve sinalizar incompatibilidade antes de aplicar parametros.
6. Execute o chamador atual para um caso especifico e confira que continua selecionando a descricao solicitada. Ainda nao executa todos os casos.

Verificacao local executada: assinatura plural com dois argumentos, uma chamada ao carregador, carga sem selecao/preparacao individual, Started sem carga/movimento de cursor, copia de ID/JSON, versao antes dos parametros, inventario de metodos preservado, carga antes de Started na casca e CDS global mantido. Nove verificacoes estruturais passaram; git diff --check dos dois arquivos passou. A assinatura esperada estava ausente antes da alteracao e foi encontrada depois.

Essas verificacoes sao analise estrutural, nao testes funcionais nem compilacao do JvInterpreter. Nao houve prova nativa, gravacao de parametros ou consulta/escrita no banco nesta etapa. Os gates nativos TLC permanecem pendentes, sem marcar requisitos Verified.

## O que ha de novo

Carga do conjunto separada da preparacao individual. Cada registro pode ser preparado usando o CDS global existente, abrindo caminho para a proxima etapa de iteracao do lote.

## Revisao solicitada em 2026-10-06

### Realizacao

Removida a atribuicao FHistoricoExecucao.RequisitoVersao := ''. Removidos os prefixos MensagemPersonalizada de todas as exceptions em TDD_STARTED e das exceptions internas da casca desta etapa. Somente a captura externa de Run mantem esse prefixo. Captura de carga agora informa 'Falha ao carregar os casos de teste: ' com E.Message; captura de execucao informa 'Falha na execucao do caso de teste: ' com Ex.Message.

### Fontes modificados

TDD_STARTED.pas, TDD_BASE_UNIT_IRUNNER.pas e registros documentais desta etapa. Nenhum metodo adicionado/removido. Loop de execucao do lote nao implementado ou movido; o while atual continua somente a busca transitoria pela descricao solicitada.

### p/ teste

No ERP de homologacao, provocar falha na carga ou preparacao e conferir uma unica ocorrencia da mensagem personalizada na captura externa de Run, com contexto de cada camada e causa original. Conferir requisito ausente sem forcamento de string vazia. Inspecao estrutural verifica ausencia do prefixo em STARTED e ocorrencia unica na casca; validacao nativa permanece pendente. Dependencias compartilhadas nao foram alteradas nesta revisao.

### O que ha de novo

Exceptions das unidades desta etapa acrescentam contexto sem repetir o prefixo de apresentacao ao usuario.
