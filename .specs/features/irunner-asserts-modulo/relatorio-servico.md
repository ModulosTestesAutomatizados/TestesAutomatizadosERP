# Integração de ASSERTS e MODULO ao IRunner

## Realização (Interno)

Corrigidos os nomes dos fontes na cadeia executável, a busca do molde e a unit financeira configurada. As referências compartilhadas de logs apontam para RUN_LOGS, evitando estados concorrentes. MODULO usa o contexto existente e não recarrega casos.

ASSERTS reinicia seu estado por tentativa, mantém resultados aprovados/reprovados e captura cópias dos datasets antes dos fechamentos financeiros. O validador passou de 490 para aproximadamente 250 linhas, ficando com as comparações. A ordem Maior/Menor foi corrigida; conversões inválidas e campos ausentes não aprovam silenciosamente. Seus diálogos, alterações de flag e cronômetro próprio foram removidos.

O runner executa a validação, transforma reprovações em FALHA e mantém a continuidade e o resumo do lote. FINISHED grava uma linha agregada de METRICAS_ASSERTS por histórico, incluindo zero ou resultados parciais. Mantidos o tratamento central, o controle de debug e a lógica aprovada de STARTED. As instruções e referências de nomes em STARTED foram atualizadas; seu comportamento não foi alterado.

Não houve stage, commit, sincronização, execução financeira ou escrita no banco. A revisão dos fontes legados de faturamento ficou fora do diff; suas dependências anteriores não foram migradas para RUN_ASSERTS.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_RUN_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_RUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_STARTED.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_FINISHED.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_LOGS.pas
- docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_ASSERTS.pas
- docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_MODULO.pas
- docs/assets/emDesenvolvimento/Runner/P39_TDD_PROCESSAMENTO_FINANCEIRO.pas
- docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas
- docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO.pas
- docs/assets/configuracoesGerais/P39_TDD_VALIDAR_RESULTADO.pas
- docs/assets/configuracoesGerais/P39_TDD_CONSTANTES.pas
- docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas
- docs/assets/configuracoesGerais/P39_TDD_ODBC.pas
- docs/assets/configuracoesGerais/P39_TDD_CACHE.pas
- docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas
- docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO.pas
- docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO_MAPEAMENTO.pas
- docs/assets/configuracoesGerais/Sincronizar/P39_TDD_PROCESSAMENTO_SINCRONIZACAO.pas
- docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas
- docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas
- .specs/STATE.md e artefatos em .specs/features/irunner-asserts-modulo/

Nos compartilhados acima, exceto VALIDAR_RESULTADO, as alterações são de referências de nomes. O exemplo Pascal foi regenerado pelo Executar extraído, sem interpretar seu fluxo no ERP.

## p/ teste

1. Disponibilizar o conjunto coerente de fontes no ambiente de testes, mantendo P39_ somente nas dependências remotas correspondentes. A versão do molde precisa acompanhar a do IRunner.
2. Executar um caso sem resultado esperado: deve registrar SEM_VALIDACAO, sem fabricar assert aprovado. Seus asserts explícitos, quando presentes, continuam contando.
3. Executar um caso com resultado esperado configurado, primeiro correto e depois divergente. Conferir o status do histórico e a linha correspondente de METRICAS_ASSERTS, com contadores, etapa, tempo e os dois resultados.
4. Executar pelo menos dois casos no mesmo lote, um reprovado e outro aprovado. O segundo não deve herdar falhas, contadores ou capturas do primeiro. Deve haver resumo final com a reprovação do primeiro.
5. Conferir os logs com debug ativo em sucesso e falha. Se uma operação interromper o teste após algumas verificações, conferir resultados parciais e o diagnóstico original.
6. Conferir no ERP a captura de CDSCadastro nos pontos logo após gravar duplicata e borderô. O dataset deve estar disponível e ativo nesses pontos; a validação posterior utiliza a cópia. A última captura de uma mesma chave CDS|DM substitui a anterior. Para campos presentes em mais de uma captura, informar cds e dm no item esperado.

Verificação local: `node .specs/features/irunner-asserts-modulo/evidencias/testar.mjs` (16 grupos) e `node .specs/features/irunner-asserts-modulo/evidencias/verificar-independente.mjs` (5 grupos). Os métodos Pascal são extraídos e executados em um tradutor restrito, com APIs do ERP e ODBC substituídas. Isso não comprova compilação JvInterpreter, eventos de gravação, conteúdo real dos BLOBs ou compatibilidade do adapter de TClientDataSet.Data no ERP. A revisão e o sensor independentes estão em validation.md.

## O que há de novo

Os asserts passam a influenciar o resultado do caso e a ter métricas próprias no histórico. As tentativas mantêm estados separados e preservam suas evidências mesmo após o fechamento das telas.
