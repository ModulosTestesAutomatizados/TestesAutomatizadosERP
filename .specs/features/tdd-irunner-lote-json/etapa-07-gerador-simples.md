# Etapa 07: restaurar o formato de Executar

## Realizacao

Executar voltou ao formato original com lLS como TStringList, lMetodo e as chamadas lLS.Add. Teste e fixo, sem lista ou loop de metodos. A string de SetTDDUnit preenche uses e comentario de origem. CommaText e Troca global de virgulas restaurados conforme pedido expresso. Scanner de identificador/literais e verificacoes adicionais de molde/marcadores retirados. lIndice nao foi mantido por nao haver iteracao de metodos. Demais fontes Pascal preservados nesta correcao.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_IRUNNER.pas
- Registros TLC e evidencia estatica de codigo gerado.

## p/ teste

Auditoria estrutural e composicao estatica passaram: seis linhas de callback/ticks/log/chamada, Teste unico dentro de Run e substituicao do par FINANCEIRO/FINANCEIRO. Validadores TLC strict e git diff --check passaram. Nenhum teste Pascal/ERP executado; gates nativos e pendencias funcionais anteriores permanecem.

## O que ha de novo

Gerador mantem a forma anterior de montagem e chama Teste automaticamente para a unit configurada, sem validacoes adicionais.
