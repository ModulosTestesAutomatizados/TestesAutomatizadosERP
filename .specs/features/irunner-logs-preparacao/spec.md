# Logs de preparação e captura permanente

## Problem Statement

Logs anteriores a Interpretar não chegam ao histórico dos casos. A captura também depende de FModoDebug, embora o histórico deva conter logs com debug desligado. O usuário aprovou transferir uma cópia textual da preparação e renomear o logger, preservando as convenções existentes.

## Goals

- WHEN RegistrarLog é chamado THEN a lista SHALL receber a mensagem independentemente de FModoDebug. (LOG-01)
- WHEN FModoDebug está desligado THEN RegistrarLog SHALL omitir MostrarLogTexto; quando ligado SHALL exibir a mensagem. (LOG-02)
- WHEN Executar inicia uma nova preparação THEN a cópia SHALL conter somente os logs desta chamada, incluindo o código montado antes de incorporar a própria cópia. (LOG-03)
- WHEN Run inicia um caso THEN o histórico SHALL conter a preparação do lote e os logs exclusivos do caso, sem logs de outro caso ou lote. (LOG-04)
- WHEN Interpretar recebe o código THEN a preparação SHALL ser transportada como texto com aspas e quebras de linha preservadas, sem exigir compartilhamento de objetos entre contextos. (LOG-05)
- WHEN os fontes são atualizados THEN todas as chamadas Pascal SHALL usar RegistrarLog, sem manter wrapper para o nome anterior. (LOG-06)

## Out of Scope

Documentação publicada, consultas/gravações reais no banco, execução ERP, stage e commits. STARTED recebe somente a troca do nome do logger. Não persistir resumo posterior ao último histórico nem prometer histórico de um caso que não chegou a iniciar.

## Assumptions & Open Questions

Cada histórico recebe a mesma preparação daquele lote. A preparação cobre a chamada atual de Executar, não mensagens anteriores da aplicação. FModoDebug controla a tela; FExibirInstrucoes continua controlando instruções. Não é necessário assumir a implementação de threads de Interpretar. Sem perguntas pendentes.

## Execution Plan

1. Renomear o logger nos fontes e tornar sua captura incondicional.
2. Transferir a preparação para o molde e recompor a lista por caso; liberar e zerar referências pertencentes ao fluxo.
3. Testar captura, transporte entre contextos separados, múltiplos casos, nova execução e falhas; revisão independente.

## Success Criteria

Testes locais derivados dos seis critérios aprovados, sem fontes antigos chamando o logger anterior, revisão independente. Limite explícito: o executor local de métodos não substitui JvInterpreter/ERP.
