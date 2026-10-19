# Etapa 08: JSON sem configuração, logs e instruções

Data: 2026-10-06. Base: commit local do usuário 84eb26b. Alterações locais aplicadas; validação no ERP pendente.

## Realização

Removidos os quatro wrappers JSON e os quatro métodos de fallback de configuração do piloto. Chamadas usam FUNCOES_JSON diretamente. O piloto não referencia CDSConfiguracao/CarregarConfiguracoes. PESSOA_DUP, VALOR_DUP, GRUPORESULTADO_DUPGR e CONTA_BORD são verificados em ValidarCasoTeste: leitura zero, incluindo ausente/inválido, gera exception antes das operações financeiras. Os três opcionais confirmados pelo usuário permanecem iguais: QUALIFICACAO_DUP, PESSOANOTACREDITO_BORD e PRAZOVENCIMENTO_DUP. Não foi acrescentada restrição de valores negativos aos quatro campos que anteriormente usavam fallback.

Logs usam RegistrarLogEmModoDebug e DelimitadorLog. Run cria/limpa a lista na entrada, copia Text antes da persistência e limpa em finally; o lote libera a lista. Foi removido o recorte por índices do log nativo. FModoDebug continua controlando o registro e Add(pLog + #13) foi preservado. O snapshot contém as mensagens até a entrada em FINISHED: mensagens emitidas durante a persistência ficam fora da cópia já enviada ao histórico. Não foi introduzida query de atualização/repetição de histórico.

Após inventário sem chamadores em todos os arquivos Pascal locais, removidas as quatro procedures de exibição de texto/CDS de TDD_LOGS, conforme autorização posterior. MostrarInstrucoesUnit permanece condicionado a FExibirInstrucoes. Instruções dos sete participantes são padronizadas com descrição, assinaturas, responsabilidades e separadores. A Base mantém instruções em comentário por ser molde, preservando duas linhas iniciais e Main com uma chamada. Forms e callbacks operacionais não foram retirados.

Nenhum método novo. Demais métodos preservados. Ordem financeira, validação de versão, ticks, SQL e política STARTED/TEARDOWN não foram alterados. Asserts continuam fora do escopo.

## Fontes modificados

- docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas
- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_LOGS.pas
- docs/assets/emDesenvolvimento/Runner/TDD_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas
- docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas
- docs/assets/emDesenvolvimento/Runner/P39_PROCESSAMENTO_TDD_FINANCEIRO.pas
- docs/mapeamentoUses/REFACTOR_TDD_FINANCEIRO_PILOTO.md
- Registros TLC e evidencia estática de código gerado.

## p/ teste

Auditoria estrutural passou: inventário exato de remoções, nenhum método extra, ausência de chamadas aos quatro métodos retirados em todos os arquivos Pascal, opcionais preservados, lógica de Started e blocos SQL iguais ao HEAD, sequência financeira mantida, ciclo de logs e Main do molde preservados. Composição estática demonstrou Teste único no código gerado. Validadores TLC strict passaram com zero erros/avisos. git diff --check passou. Esses checks não interpretam Pascal nem validam operações financeiras.

Quando autorizado no ERP: usar massa de homologação; executar casos distintos e conferir logs por histórico, delimitadores e ausência de mensagens do caso anterior. Com debug desligado, logs individuais devem ficar vazios. Retirar um dos quatro campos anteriormente atendidos por configuração e conferir falha antes de gravar duplicatas. Omitir os três opcionais e conferir o comportamento anterior. Habilitar/desabilitar FExibirInstrucoes e conferir a exibição das instruções. Conferir falha de Teste com continuação e falha de TEARDOWN com interrupção.

Nenhum teste nativo, escrita no banco, publicação ou commit realizado pelo agente. Gates funcionais do plano amplo permanecem pendentes; nenhuma tarefa marcada Verified. Arquivos externos observados no status foram preservados.

## O que há de novo

Piloto usa os dados explícitos do JSON, logs são separados por caso e as units têm instruções consistentes. O fluxo registra diagnóstico em memória sem as antigas telas de debug.
