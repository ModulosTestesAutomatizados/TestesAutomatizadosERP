# Inspecao do IRunner e do piloto financeiro

Data: 2026-10-05. Escopo: estudo e planejamento, sem alteracoes Pascal ou no banco.

## Conclusao

O fluxo atual e de caso unico. A mudanca exige separar a vida do lote da vida de cada caso. A casca deve percorrer o dataset compartilhado; STARTED deve consumir o registro corrente; a fixture deve executar somente sua responsabilidade financeira. Acrescentar um loop mantendo os carregadores atuais permite que STARTED reposicione o cursor e que o piloto execute repetidamente o caso fixo.

## Evidencias nas seis unidades solicitadas

| Evidencia | Comportamento atual | Consequencia e tratamento proposto |
| --- | --- | --- |
| `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas:11` | Run recebe modulo, area e descricao do caso; nao existe loop | Run do lote recebe modulo/area; ciclo interno processa cada ID uma vez |
| `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas:24` | SetarCasoTeste precede Started para um caso | Separar carga do lote e selecao do registro atual |
| `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas:38` | Existe etapa ASSERTS sem implementacao, seguida de SUCESSO | Manter somente o ponto reservado; SUCESSO significa conclusao operacional, sem aprovacao funcional |
| `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas:58` | Falha na persistencia do finally impede os fechamentos seguintes | Tentar persistencia, callbacks e liberacoes independentemente, preservando a falha primaria |
| `docs/assets/emDesenvolvimento/Runner/TDD_IRUNNER.pas:38` | Text e indice 0 sao acessados sem proteger Assigned/Count | Validar listas antes de desreferencia-las, com limpeza desde o inicio da geracao |
| `docs/assets/emDesenvolvimento/Runner/TDD_IRUNNER.pas:52` | Os dois ramos geram o mesmo codigo; outros metodos tambem sao aceitos | Formalizar Teste unico, chamado no maximo uma vez por caso |
| `docs/assets/emDesenvolvimento/Runner/TDD_IRUNNER.pas:81` | CommaText monta parametros e substituicao global altera todas as virgulas | Montar apenas trechos dos marcadores; preservar literais e validar duas entradas |
| `docs/assets/emDesenvolvimento/Runner/TDD_IRUNNER.pas:87` | Quatro listas sao liberadas, mas FParamsCasosTeste nao | Limpar todas as listas inclusive em falha de validacao e segunda execucao |
| `docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas:34` | Insere historico e depois insere ticks em comandos separados | Persistencia e por caso, com ID proprio; informar gravacao parcial sem retry |
| `docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas:104` | Percorre FCDSMetricasTickDiff e nao CDSCasosTestes | Preservar esta separacao; nunca mover o cursor do lote na finalizacao |
| `docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas:48` | SetupCasoTeste recarrega e busca pela descricao, com First/Next/Break | Criar preparacao pelo registro atual, sem carga ou busca neste caminho |
| `docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas:132` | Extrai parametros e faz parse de objeto com finally | Validar objeto raiz e objeto parametros antes de alterar configuracao do ERP; controlar inicializacao parcial |
| `docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas:164` | Result nao e definido no caminho sem requisito; requisito nao e copiado ao historico | Definir retorno True sem requisito e registrar requisito normalizado |
| `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas:1` | uses STARTED, ASSERTS e carregador especifico | Remover dependencias de ciclo; manter apenas mapeamentos financeiros diretos |
| `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas:51` | ExecutarFluxoCompletoFinanceiro executa Setup/Teste/TearDown proprio | Registrador passa a chamar Teste; fixture nao abre outro ciclo |
| `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas:108` | Cria FCDSCasoTeste/FCDSConfig e carrega TDD_FINANCEIRO fixo | Usar FCasoTesteAtualJson e CDSConfiguracao compartilhados, sem clone |
| `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas:141` | Caso invalido envia mensagem e sai sem excecao | Runner pode registrar SUCESSO indevido; sinalizar falha operacional ao runner |
| `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas:67` | Resultado atual devolve quatro strings true constantes | Nao representa verificacao real; registrar limite e deixar contrato de resultados para o responsavel por asserts |
| `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas:405` | ExtrairTag declara lMarcador Integer e atribui texto; fallback usa Pos/Copy | Inconsistencia de tipo visivel; preservar metodo e ajustar corpo para delegar ao helper compartilhado |
| `docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas:247` | VlrPagar e acumulado sem inicializacao explicita; ocorre tambem no pagamento | Inicializar em cada chamada; limpar selecao e edicoes de UI entre casos |
| `docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas:10` | TagExiste significa GetValueJson diferente de vazio; excecoes sao ocultadas | Nao usar como prova de JSON valido ou de presenca estrutural da chave |
| `docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas:39` | ValorCurrencyTag troca ponto por virgula e usa Currency | Provar conversao decimal e assinatura no ERP; nao generalizar compatibilidade a Delphi compilado |

## Dependencias que precisam entrar no plano

- `Runner/TDD_RUNNER.pas`: historico, contexto e ticks compartilhados. O indice de ticks e NOME_METODO; repetir TOTAL/STARTED no mesmo CDS produz colisao. Reinicializar metricas por caso e zerar cada campo do historico.
- `Runner/P39_PROCESSAMENTO_TDD_FINANCEIRO.pas`: fornece tres parametros e registra ExecutarFluxoCompletoFinanceiro. Deve migrar junto da assinatura de Run.
- `P39_TDD_CASOS_DE_TESTE.pas:103`: preenchimento e aditivo por FindKey; nao esvazia dados antigos. Uma nova carga deve partir de estrutura limpa.
- `P39_TDD_CASOS_DE_TESTE.pas:184`: inicializa quatro CDS antes de cache/parametros. A flag final nao comprova quais recursos foram criados em uma falha parcial.
- `P39_TDD_CACHE.pas`: AreaPeloNome procura somente DESCRICAO_AREA. `docs/MER.md` relaciona AREA.MODULO_AREA com MODULO; a resolucao do par deve considerar o modulo.
- `P39_TDD_PARAMETRO.pas`: AtualizarParametros usa ExecuteCommand e Relogar no ERP. Liberar CDSParametro nao restaura valores. A heranca de parametros entre casos precisa de uma politica explicita.
- `P39_TDD_CONSTANTES.pas` e `P39_TDD_CACHE.pas` declaram nomes globais de cache iguais. O grafo mistura TDD_LOGS e P39_TDD_LOGS. Provar resolucao e identidade no host antes de inferir colisao ou compartilhar estado entre variantes.

## Fontes e limites do estudo

As fontes atuais prevalecem sobre `.specs/features/tdd-irunner-mvp/`: os documentos antigos citam caminhos anteriores e comportamentos ausentes nas units em Runner. As decisoes historicas sao pistas, nao novas confirmacoes do usuario nesta tarefa.

Foram lidos os arquivos locais, o modelo `docs/MER.md`, o JSON financeiro de exemplo e as regras de `.agents/AGENTS.md`. Nao foi necessario consultar o banco para formular a arquitetura; quantidades de casos, constraints e valores reais continuam sem validacao remota. Nenhum script financeiro foi executado.

Apos recarga solicitada pelo usuario, Context7 MCP ficou disponivel. resolve-library-id encontrou `/project-jedi/jvcl`, fonte High com 3927 snippets. Foram feitas consultas separadas sobre resolucao de globais/uses, tipos de parametros e Free/Assigned. As consultas de globais entre units irmas e de Free/Assigned nao retornaram documentacao correspondente. A consulta de tipos trouxe paginas historicas do interpretador e changelog; nao demonstra o comportamento da versao customizada do ERP.

O Context7 referencia a [documentacao JVCL do interpretador](https://github.com/project-jedi/jvcl/blob/master/websites/JVCL2/JvInterpreter.htm), que descreve variaveis locais/globais e bindings registrados pela aplicacao. Esse material nao prova a heranca customizada entre units irmas. Tambem foi consultada a [fonte oficial atual do JvInterpreter](https://github.com/project-jedi/jvcl/blob/master/jvcl/run/JvInterpreter.pas), inclusive via leitura raw: CheckNotSupportedFunctionParameters rejeita arrays/records em parametros. Nao passar records entre rotinas. Interpretar, identidade do contexto, liberacao de referencias e thread do ERP exigem prova no host.

Correcao de escopo recebida durante o estudo: o usuario autorizou retirar somente Setup e ExecutarFluxoCompletoFinanceiro, os tres uses de infraestrutura do piloto e as onze constantes listadas em context.md. Nenhum metodo novo esta previsto. Outros metodos permanecem com corpos ajustaveis; qualquer excecao depende de pergunta justificada e aceite previo.

Nao foi encontrado comando de CLI para executar estas seis units no interpretador integrado. Os gates funcionais deste plano usam evidencias no ERP; validacao estrutural dos documentos nao equivale a compilacao ou execucao Pascal.
