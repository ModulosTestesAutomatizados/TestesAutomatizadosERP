# Etapa 09: piloto reduzido e instruções alinhadas

## Realização

Piloto ficou com seis procedures. Teste chama ValidarCasoTeste diretamente; Setup_InicializarObjetos já não existia no arquivo entregue pelo usuário nesta etapa. Removidos os dois produtores de resultado e SetCasoTeste. Seleção da pessoa foi incorporada ao pagamento, preservando verificação, abertura, limpeza e preenchimento do CDSSelecao. _IncluirBordero(pTipo) substitui as duas entradas anteriores: 0 recebe, 1 paga. Teardown permanece no final, sem alteração de seu corpo ou da política de interrupção.

As instruções dos sete participantes usam separadores com 116 caracteres de = e operadores + #13 na mesma coluna. MostrarInstrucoesUnit permanece condicionado a FExibirInstrucoes. Concatenação do delimitador em TDD_LOGS encerrada com #13, sem operador pendente. Nenhuma alteração no registro de debug, no molde da Base, na validação específica ou nos opcionais nesta etapa.

## Fontes modificados

- docs/assets/emDesenvolvimento/REFACTOR_TDD_FINANCEIRO_PILOTO.pas
- Instruções em TDD_LOGS, TDD_IRUNNER, TDD_RUNNER, TDD_STARTED, TDD_FINISHED e P39_PROCESSAMENTO_TDD_FINANCEIRO em docs/assets/emDesenvolvimento/Runner.
- Registros TLC e mapa de dependências.

## p/ teste

Verificação estrutural passou: comparação dos dois caminhos financeiros com os corpos anteriores, seleção inline equivalente, ordem das quatro operações, inventário de seis procedures, ausência de referências aos métodos retirados no fluxo, teardown no final, largura dos separadores e coluna das quebras. git diff --check e validadores TLC passaram. Essas evidências não executam o interpretador.

Na validação futura autorizada no ERP, conferir Teste com recebimento/pagamento, pessoa selecionada, totais separados por chamada, opcionais e encerramento. Nenhuma operação financeira, alteração no banco, publicação ou commit foi realizada pelo agente. Gates nativos continuam pendentes; asserts não foram implementados.

## O que há de novo

Piloto tem uma entrada para borderô por tipo e menos auxiliares; instruções seguem a largura e o alinhamento solicitados.
