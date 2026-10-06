# Etapa 10: limpeza sequencial do lote

## Realização

Usuário solicitou substituir os finally aninhados por uma sequência de chamadas com try/except único. ExecutarLote agora chama métricas, parâmetros, cache, casos e liberação dos logs nessa ordem. Exception recebe contexto de falha na limpeza e propaga; chamadas posteriores à que falhar não são executadas. Não há garantia de tentar os cinco encerramentos sob erro, por decisão desta etapa.

As fontes inspecionadas de métricas, parâmetros e cache não têm except interno. O teardown de casos tenta os próprios CDS e relança erros ao final. Nenhum desses métodos foi alterado. Run permaneceu integralmente igual.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas
- Registros TLC da decisão.

## p/ teste

Verificação estrutural confirmou try/except único na limpeza e preservação de Run; git diff --check passou. Execução no ERP não realizada. Na validação futura, falha em uma liberação deve subir com o contexto do lote e impedir as chamadas seguintes.

## O que há de novo

Encerramento do lote mais simples, com propagação da primeira falha de limpeza.
