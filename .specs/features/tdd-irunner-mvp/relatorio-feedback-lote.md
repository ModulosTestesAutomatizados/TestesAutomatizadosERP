# Feedback ao final do lote IRunner

**Data:** 2026-10-14
**Status:** ajuste local implementado; apresentação no ERP pendente de validação.

## Realização (Interno)

Confirmado nos fontes locais e na TDD_BASE_UNIT_IRUNNER do banco ERP (consulta READ ONLY, grupos 1 a 6) que o tratamento registra falhas de IRUNNER e retorna normalmente. Apenas falhas de preparação ou limpeza insegura eram relançadas. Portanto a falha de validação chegava ao histórico, mas não ao tratamento com MensagemPersonalizada.

Conforme escolha do usuário, o lote continua os demais casos e copia os detalhes de cada tentativa reprovada antes de limpar o contexto para a próxima. Após encerrar e liberar os recursos, levanta um resumo com quantidade de casos executados, quantidade de falhas e mensagens individuais. O retorno de Run continua permitindo essa iteração. Falhas de infraestrutura mantêm a interrupção existente.

Main passou a concentrar o único acréscimo de MensagemPersonalizada, alcançando o resumo e as falhas que escapam de ExecutarLote. O tratamento de Run mantém ID, método e mensagem sem repetir o prefixo. A apresentação não depende do modo debug. Os INSERTs de histórico e métricas não foram alterados.

O JSON informado contém PESSOA_DUP=0, VALOR_DUP=0 e GRUPORESULTADO_DUPGR=0. A validação financeira atual rejeita esses valores. Essa regra e os dados não foram alterados: o ajuste trata o feedback dessas falhas.

Sonda do fluxo extraído de Main/ExecutarLote: antes da mudança, falhou por falta de feedback; depois, passou em oito cenários. Verifica continuidade até um caso posterior aprovado, cópia das mensagens, limpeza antes do resumo, prefixo único, lote aprovado/vazio, agregação de falha e versão incompatível, mensagem vazia e interrupções de persistência/carga/limpeza. Uma mutação temporária que impede acumular falhas foi detectada. A sonda já existente do nome de FINISHED também passou. git diff --check passou.

Limite: as sondas traduzem trechos restritos de Pascal para JavaScript e substituem Run, CDS, métodos de limpeza e persistência. Não compilam Pascal nem executam JvInterpreter. Nesta sessão não houve gravacao no banco ou execução financeira. Se uma falha de infraestrutura interromper o lote, o erro dessa interrupção será apresentado e os históricos já persistidos continuam disponíveis.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas
- .specs/features/tdd-irunner-mvp/evidencias/testar-feedback-lote.mjs
- .specs/features/tdd-irunner-mvp/relatorio-feedback-lote.md

## p/ teste

1. Atualizar TDD_BASE_UNIT_IRUNNER no ambiente de testes correto e fechar/reabrir a unit no BI.
2. Executar o lote com o caso 28 e seu JSON zerado. Conferir que o histórico continua registrando as três tags inválidas.
3. Confirmar que os demais casos são tentados e que, ao final, aparece uma única mensagem com o resumo e os detalhes de cada caso reprovado.
4. Conferir que as telas e os recursos do lote foram encerrados antes da apresentação do resumo.
5. Usar uma fixture sem operações financeiras para conferir lote inteiramente aprovado, falha seguida de sucesso, várias falhas e uma falha controlada de infraestrutura. Lote aprovado não deve apresentar erro; falha de infraestrutura deve interromper e apresentar sua causa.
6. Conferir que o cabeçalho personalizado aparece uma só vez, inclusive com o modo debug desligado.

Sondas locais a partir da raiz:

```powershell
node '.specs/features/tdd-irunner-mvp/evidencias/testar-feedback-lote.mjs' .
node '.specs/features/tdd-irunner-mvp/evidencias/testar-metodo-finished.mjs' .
```

## O que há de novo

O lote continua os demais testes e apresenta as falhas ao terminar. O executor deixa de precisar consultar somente o histórico para saber que houve reprovação.
