# Etapa 04: limpeza dos controles adicionais

Data: 2026-10-06. Alteracoes locais aplicadas; verificacao estrutural passou; testes no ERP continuam aguardando instrucao do usuario.

## Realizacao

Removidos FSetupIniciado, FMetricasTickDiffCriadas e FAplicacaoParametrosIniciada de TDD_RUNNER e suas referencias em STARTED/molde. FLotePodeContinuar ja havia sido removido e permanece ausente. A liberacao e o uso das metricas voltam a verificar Assigned; preparo do caso usa disponibilidade/atividade/registro corrente do CDS, sem flag paralelo de setup.

Falhas de inicializacao/preparacao sobem por exception; incompatibilidade de versao permanece falha individual. A interrupcao conservadora baseada em FAplicacaoParametrosIniciada foi retirada conforme a limpeza solicitada; falhas posteriores de Teste seguem o tratamento individual sem aquele rastreamento. A restauracao de parametros ainda e responsabilidade pendente e nao foi implementada por esta alteracao.

SetarCasoTeste e suas chamadas foram preservados integralmente. O metodo hoje tambem reinicia ID de historico, status, erro, etapa e contexto da tentativa; ler o registro corrente substitui a obtencao dos dados, mas nao substitui automaticamente essa reinicializacao. A pergunta sobre sua necessidade foi tratada como estudo, sem alterar o trecho.

As instrucoes em Main de TDD_RUNNER foram preservadas, inclusive seu formato, para revisao ao concluir a implementacao. Nenhum metodo foi criado ou removido.

## Fontes modificados

- `docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas`
- `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas`
- Registros TLC desta etapa.

## p/ teste

Checks estruturais executados: ausencia dos quatro controles nos tres arquivos, liberacao de metricas com Assigned, preservacao exata do corpo de SetarCasoTeste e das instrucoes do runner, Main do molde com uma chamada e duas linhas vazias iniciais preservadas. git diff --check passou.

Nenhuma execucao nativa ou operacao no banco realizada. A semantica de Assigned/Free e de referencias apos liberacao deve ser confirmada no host durante a validacao autorizada futura. O piloto ainda precisa ser refatorado; estas evidencias nao indicam conclusao funcional do lote financeiro.

## O que ha de novo

Runner utiliza os objetos e o tratamento de exceptions existentes, com menos flags globais de controle. SetarCasoTeste permanece aguardando eventual decisao posterior de simplificacao.
