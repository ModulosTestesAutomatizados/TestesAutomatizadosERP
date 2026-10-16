# Fonte JSON única para sincronização e asserts

## Realização (Interno)

RegistrarCasoTeste recebe seis argumentos: módulo, área, descrição, requisito, uma unit JSON e controle remoto/local. Os quatro registros existentes foram migrados. A unit financeira carregada é TDD_FIN_FINANCEIRO_JSON. As propriedades resultadoEsperado e camposDisponiveis são projetadas nas colunas próprias; os demais dados e parametros permanecem no JSON do caso, preservando STARTED.

Criado somente o método reaproveitável ObterObjetoConfiguracao(pJson, pPropriedade, pUnitFallback: string; pFallbackSeVazio: boolean): string. Resultado ausente usa P39_TDD_ASSERTS_JSON_MINIMO; resultado explícito {} desativa essa busca. Campos ausentes ou vazios usam P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO. Seu conteúdo atual {} é aceito; conteúdo futuro usa {"camposDisponiveis": {...}}, sem alterar código ou assinatura.

CarregarConteudoUnit não duplica 'P39_' e não silencia falha de leitura. Objetos inválidos ou fallback necessário indisponível impedem o registro antes dos fallbacks SQL de módulo/área e da sincronização. O validador identifica objetos vazios pelo parser, inclusive formatados, registra SEM_VALIDACAO e preserva asserts explícitos anteriores.

Não houve escrita em banco, sincronização efetiva, stage ou commit. A consulta ao banco ERP foi somente READ ONLY, filtrada pelos grupos 1 a 6, para conferir os nomes/conteúdos disponíveis.

## Fontes modificados

- docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas
- docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas
- docs/assets/emDesenvolvimento/P39_TDD_VALIDAR_RESULTADO.pas
- docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO_JSON.json
- docs/assets/emDesenvolvimento/TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO.json (novo modelo local {})
- .specs/features/irunner-asserts-modulo/context.md
- .specs/features/irunner-asserts-modulo/evidencias/testar.mjs
- .specs/features/irunner-asserts-modulo/evidencias/verificar-independente.mjs
- .specs/features/irunner-asserts-modulo/evidencias/sensor-independente.mjs
- .specs/features/sincronizacao-fonte-unica/ e .specs/STATE.md

Os JSONs em docs/assets são ignorados pela regra *.json já existente no repositório. Foram alterados/criados no disco, sem modificar essa regra nem forçar inclusão no index. O modelo TDD_ASSERTS_JSON_MINIMO.json adicionado pelo usuário foi preservado.

## p/ teste

1. Disponibilizar o registrador e seus consumidores em conjunto, respeitando a nova assinatura. Manter acessíveis as duas units remotas mínimas. Não executar uma versão antiga dos consumidores com o registrador novo.
2. Sem resultadoEsperado na fonte do caso, conferir que RESULTADO_ESPERADO_CT recebe apenas o objeto interno da unit mínima, sem outra camada resultadoEsperado.
3. Com resultadoEsperado: {}, conferir que o mínimo não é consultado e ASSERTS somente registra SEM_VALIDACAO, preservando verificações explícitas do teste.
4. Com resultadoEsperado preenchido, conferir que a sincronização usa esse objeto. JSON inválido, null, array ou escalar deve produzir diagnóstico, sem virar ausência de configuração.
5. Com camposDisponiveis ausente ou {}, conferir o uso da unit mínima de campos. Com objeto preenchido, conferir que ele prevalece sobre a unit mínima. Para preencher o mínimo futuramente, usar a propriedade camposDisponiveis na raiz da unit remota.
6. Conferir que CASO_TESTE_CT contém os dados e parametros, sem resultadoEsperado e camposDisponiveis. O arquivo financeiro local inclui camposDisponiveis: {} e omite resultadoEsperado para usar o mínimo remoto de asserts.
7. Conferir que uma unit mínima indisponível interrompe a sincronização antes das gravações. Nomes já prefixados P39_ não devem receber outro prefixo.

Os registros legados de faturamento deixam de carregar TDD_JSON_BASE_RESULTADO_ESPERADO separadamente. Para manter expectativas específicas anteriores, elas devem estar em resultadoEsperado dentro da fonte JSON de cada caso. Não foi inventado conteúdo para esses JSONs remotos: os arquivos locais com esses nomes são fontes Pascal, não os documentos JSON a migrar.

Verificação da feature: nove grupos do autor, quatro adversariais independentes e 3/3 mutações detectadas em cópias isoladas, detalhados em validation.md. Executar os três scripts testar.mjs, verificar-independente.mjs e sensor-independente.mjs do diretório evidencias desta feature. Métodos Pascal extraídos, fronteiras ERP/ODBC substituídas; não comprova compilação nativa ou persistência real.

A suíte da iteração anterior foi atualizada aos arquivos movidos pelo usuário e à nova regra explícita de {}. Quinze grupos passam e um teste de reexecução do lote falha porque o HEAD db20fe6 libera FLogsCasoTeste sem atribuir nil. Essa limpeza não foi alterada nesta feature e o teste foi mantido. Os cinco grupos independentes anteriores passam.

## O que há de novo

Cada caso passa a ter uma única fonte JSON com seus dados, campos e resultado esperado. As configurações mínimas são consultadas nas units remotas conforme a presença e o conteúdo de cada propriedade.
