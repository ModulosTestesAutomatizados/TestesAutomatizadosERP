# Planejamento: lote IRunner e piloto financeiro

Planejamento inicial entregue em 2026-10-05. Implementacao incremental local registrada nas etapas abaixo; validacao nativa pendente e nenhuma publicacao realizada.

O fluxo proposto usa uma Interpretar, carga unica de casos ativos do modulo/area e tentativa por ID. STARTED prepara o registro corrente; Teste consome a memoria compartilhada; FINISHED grava historico/ticks do caso. Falha individual permite continuar; falha de restauracao segura encerra o lote e identifica os nao tentados.

## Leitura

1. [Inspecao](inspecao.md): evidencias dos seis arquivos e dependencias afetadas.
2. [Decisoes e restricoes](context.md): preferencias confirmadas e remocoes exatas autorizadas.
3. [Especificacao](spec.md): 38 requisitos em EARS, pressupostos e limites.
4. [Design](design.md): responsabilidades, cursor, recursos, JSON, parametros e compatibilidade.
5. [Tarefas](tasks.md): 13 entregaveis atomicos, dependencias, cenarios e gates.
6. [Verificacao do planejamento](verificacao-planejamento.md): checks estruturais e limites das evidencias.
7. [Relatorio de entrega](relatorio-servico.md): fechamento do estudo.
8. [Etapa 01](etapa-01-carga-preparacao.md): separacao inicial de carga/preparacao e revisao de exceptions.
9. [Etapa 02](etapa-02-orquestracao-lote.md): setup no runner, Main do lote e Run individual, com limites de integracao.

## Restricoes aplicadas

Remover do piloto somente os tres uses, onze constantes e dois metodos enumerados em context.md. Preservar demais metodos e ajustar seus corpos. Nenhum metodo novo previsto. Qualquer necessidade adicional exige pergunta com justificativa e aceite expresso.

Asserts, publicacao e alteracoes no banco estao fora desta entrega. A sequencia completa das quatro operacoes substitui o seletor local de etapas removido; essa interpretacao fica explicita para revisao. As demais propostas nao confirmadas estao identificadas na tabela de pressupostos da spec.

Context7 foi consultado apos a recarga e encontrou `/project-jedi/jvcl`. As particularidades do ERP nao sao demonstradas pelo upstream e exigem provas nativas previstas em T1.
