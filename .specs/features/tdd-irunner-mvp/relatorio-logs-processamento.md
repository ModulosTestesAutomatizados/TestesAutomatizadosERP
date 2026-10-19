# Logs do processamento nas falhas do IRunner

**Data:** 2026-10-14
**Status:** implementado localmente; verificação dos INSERTs no ERP pendente.

## Realização (Interno)

O usuário confirmou NULL em LOGS_PROCESSAMENTO_HE. Consultadas TDD_LOGS e TDD_FINISHED no banco ERP em transação READ ONLY encerrada com ROLLBACK. O fonte instalado também bloqueia a captura quando FModoDebug está falso. Não foi consultado o banco dedicado dos históricos, pois sua conexão não foi informada; portanto o NULL relatado não foi reproduzido diretamente. O estado efetivo do flag em runtime também não foi medido.

TDD_LOGS agora acumula todas as mensagens, independentemente do debug, preservando o nome do método por compatibilidade. TDD_FINISHED copia FLogsCasoTeste.Text para LogsProcessamento imediatamente antes do INSERT, sem depender de uma cópia feita pelo chamador.

A persistência saiu do bloco de fechamento dos ticks e passou para o finally externo de Run, antes de limpar a lista. Uma falha de preparação, tick final ou callback já não impede essa tentativa quando existe um ID válido. O contexto é reiniciado antes da preparação, evitando usar o ID ou a mensagem de uma tentativa anterior. Erros que escapam são registrados no buffer antes da persistência.

Se a persistência também falhar, o diagnóstico combina a causa anterior com a falha de FINISHED e conserva uma cópia dos logs no histórico em memória. Não há repetição automática de INSERT. Não existe garantia de gravação quando o banco/ODBC falha, quando não há ID válido ou quando o processo termina abruptamente. Não foi introduzido armazenamento alternativo em arquivo. Falhas de infraestrutura continuam interrompendo o lote; falhas individuais de teste continuam permitindo os demais casos e o resumo final.

As sondas locais falharam antes dos ajustes por captura vazia sem debug, falta de snapshot no ponto de INSERT e ausência de tentativa de persistência quando o tick final falhava. Após os ajustes, passaram cenários de debug ligado/desligado, sucesso/falha/incompatibilidade, limpeza da lista após snapshot, falhas de preparação e tick, ausência de ID, erro de persistência combinado sem retry e preservação do método. A sonda de feedback do lote também passou, assim como git diff --check.

Limite: as sondas traduzem trechos restritos do Pascal para JavaScript e substituem TStringList, datasets, Run/ODBC e callbacks conforme o cenário. Não compilam Pascal nem comprovam a gravação pelo adapter ODBC do ERP. Nesta sessão não foram executados INSERTs ou operações financeiras.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_LOGS.pas
- docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas
- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas (instruções)
- docs/assets/emDesenvolvimento/TDD_FINANCEIRO.pas (instruções)
- .specs/features/tdd-irunner-mvp/evidencias/testar-logs-processamento.mjs
- .specs/features/tdd-irunner-mvp/evidencias/testar-persistencia-falhas.mjs
- .specs/features/tdd-irunner-mvp/evidencias/testar-metodo-finished.mjs
- .specs/features/tdd-irunner-mvp/relatorio-logs-processamento.md

## p/ teste

1. Disponibilizar TDD_LOGS, TDD_FINISHED e TDD_BASE_UNIT_IRUNNER no ambiente de testes correto e fechar/reabrir as units no BI. As instruções de STARTED e do piloto também foram atualizadas.
2. Executar o caso com os três valores zerados. Conferir no histórico novo se LOGS_PROCESSAMENTO_HE contém as etapas e a mensagem de validação financeira.
3. Conferir que os logs continuam disponíveis com FModoDebug desligado e que cada histórico contém somente a tentativa correspondente.
4. Em fixture sem gravações financeiras, provocar falha de inicialização ou de tick final depois de obter o ID do caso. Conferir que o histórico com os logs foi tentado mesmo nessas falhas.
5. Simular falha de ODBC nessa fixture: a mensagem deve apresentar a falha de persistência junto da causa anterior, sem repetir automaticamente o INSERT.
6. Verificar que a execução dos demais casos e o resumo final continuam funcionando para as falhas individuais de teste.

Sondas a partir da raiz do repositório:

```powershell
node '.specs/features/tdd-irunner-mvp/evidencias/testar-logs-processamento.mjs' .
node '.specs/features/tdd-irunner-mvp/evidencias/testar-metodo-finished.mjs' .
node '.specs/features/tdd-irunner-mvp/evidencias/testar-feedback-lote.mjs' .
```

## O que há de novo

Os logs deixam de depender do debug. O runner tenta gravá-los antes de limpar a tentativa, inclusive quando a execução ou seu encerramento falham, desde que exista um ID válido do caso.
