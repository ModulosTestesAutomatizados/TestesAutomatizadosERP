# Instrucoes para agentes neste repositorio

## Instrucoes da procedure Main em units TDD

- Ao criar ou alterar uma unit Pascal TDD que apresenta instrucoes na `procedure Main`, use `docs/assets/snippets/formatoTDDProcedureMainComInstrucoes.pas` como formato obrigatorio.
- Monte `lInstrucoes: String` com responsabilidade resumida da unit, separadores, estado compartilhado e tipos, assinaturas e finalidades dos metodos disponibilizados, e observacoes pertinentes. Use `#13` entre as linhas.
- Alinhe todos os trechos `+ #13 +` da `Main` na mesma coluna do snippet, preservando o espacamento entre as quebras de linha.
- Chame `{P39_TDD_RUN_LOGS.}MostrarInstrucoesUnit('NOME_UNIT', lInstrucoes)` com o nome real da unit. Nao substitua essa chamada por um log generico nem deixe a string de instrucoes sem uso.
- Descreva apenas estado e metodos que a unit efetivamente oferece; quando uma secao nao tiver itens proprios, esclareca isso no texto.
- No fluxo IRunner, configure e propague `FExibirInstrucoes` ao codigo interpretado antes das chamadas de instrucoes. Na entrada do lote, invoque explicitamente `NOME_UNIT.Main` para cada unit auxiliar desejada, com nome qualificado e sem chaves, uma vez antes do setup.

## Propagacao de excecoes no fluxo IRunner

- Nunca use `MensagemPersonalizada` em `raise` de casos de teste, mapeadores, auxiliares ou outras units intermediarias. Crie a excecao apenas com a mensagem do erro; se capturar uma excecao sem precisar acrescentar contexto, propague-a com `raise;`.
- O prefixo `MensagemPersonalizada` deve ser aplicado uma unica vez no `raise` interceptador do fluxo orquestrado por `docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_IRUNNER.pas`. No codigo atual, esse interceptador esta na `procedure Main` do molde `docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_UNIT_BASE_IRUNNER.pas`, que o IRunner carrega e interpreta.
- Ao acrescentar contexto em um nivel intermediario, preserve a mensagem recebida e repasse-a sem o prefixo; o interceptador final formata a mensagem para apresentacao.
- Nao acrescente `MensagemPersonalizada` manualmente em `ShowMessage`, logs ou outras apresentacoes intermediarias.

## Casos executados pelo IRunner

- Use `docs/assets/casosTestesFinanceiro/TDD_FIN_FINANCEIRO.pas` como referencia para o fluxo `Teste`/`TearDown_DestruirObjetos`.
- O IRunner possui `FEtapaAtual` e registra a etapa no historico; nao mantenha uma etapa local paralela apenas para formatar excecoes. Para cada fase relevante, defina `FNomeMetodoAtual` e use `RegistrarTick(0, FNomeMetodoAtual)` no inicio e `RegistrarTick(1, FNomeMetodoAtual)` no fim. O tick inicial incrementa `FEtapaAtual`.
- Se o teardown iniciar outra etapa apos uma falha, preserve a etapa da falha antes da limpeza. Depois de um teardown bem sucedido, restaure o nome da fase que falhou ou retorne a `IRUNNER` em caso de sucesso. Uma falha do proprio teardown deve continuar identificada como `TEARDOWN`.
- No teardown, localize formulario, DataModule e datasets pelo nome e libere somente os recursos do caso. Nao mantenha uma flag global apenas para indicar que o formulario foi aberto.
- Abra e exiba formularios pelo `TDD_RUN_APPLICATION.AbrirTela` no caso de teste. O mapeador apenas localiza o formulario ja aberto e seus componentes; nao chame `Show` nem `CriarFormPeloNome` no mapeador.

## Flags Boolean nos processamentos

- No processamento de sincronizacao, fora do IRunner, configure as flags com `{TDD_FILTROS.}FiltroLogicoEmBoolean('Nome da opcao?', VariavelBoolean)` antes da chamada que as consome. Inclua `TDD_FILTROS` no `uses`.
- Preserve as duas perguntas de `FSincRemoto`: uma no processamento e outra em `Sincronizar`. A segunda resposta e a utilizada por `RegistrosCasosTestes`.
- Para o fluxo IRunner, `TDD_RUN_LOGS.SetterFlags` configura `FModoDebug` e `FExibirInstrucoes` uma vez por meio de `TDD_FILTROS`. O ponto de chamada no IRunner ainda sera definido; nao documente nem suponha chamada automatica.
- O filtro logico abre com `N` como valor inicial. `Main` de uma unit so exibe instrucoes se o fluxo a chamar explicitamente e `FExibirInstrucoes` estiver ativo.
