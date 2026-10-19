# Realização

RegistrarLog sempre adiciona mensagens à lista; FModoDebug controla somente MostrarLogTexto. Todas as chamadas Pascal do diretório de artefatos foram renomeadas, sem wrapper para o método antigo. As instruções nas units foram ajustadas; documentação publicada permanece fora do escopo.

IRunner serializa somente os logs de preparação da chamada atual, escapando aspas, CR e LF. O texto é incorporado ao molde e a lista original é liberada antes de Interpretar. Cada Run limpa sua lista e recebe a mesma preparação textual do lote, seguida de suas próprias mensagens. Finished mantém a persistência por caso. A referência da lista é zerada depois de Free para permitir nova execução.

O código registrado como diagnóstico representa a montagem anterior à inclusão da própria cópia de logs, evitando expansão recursiva. Não foram criados novos métodos Pascal.

# Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_RUN_LOGS.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_RUNNER.pas (também corrige uses da unit de validação já renomeada)
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_STARTED.pas (somente chamadas e instrução do logger)
- docs/assets/emDesenvolvimento/Runner/TDD_RUN_FINISHED.pas
- docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_ASSERTS.pas
- docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas (somente chamadas, preservando alterações anteriores do usuário)
- docs/assets/emDesenvolvimento/P39_TDD_RUN_VALIDAR_RESULTADO.pas
- docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO.pas
- docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas (somente exemplo comentado)
- .specs/features/irunner-asserts-modulo/evidencias/{ambiente,testar,verificar-independente,sensor-independente}.mjs (adaptação do contrato do logger e caminhos da validação renomeada)
- .specs/features/sincronizacao-fonte-unica/evidencias/{testar,verificar-independente,sensor-independente}.mjs (caminho da validação renomeada)
- .specs/features/irunner-logs-preparacao/ (especificação, testes e revisão desta entrega)

Os outros arquivos já modificados pelo usuário no início da tarefa foram preservados. Nenhum stage, commit, execução ERP ou acesso ao banco.

# p/ teste

1. Atualizar no ambiente de teste a unit de logs e todas as units que chamam o método renomeado; fontes antigas ainda chamando RegistrarLogEmModoDebug precisam acompanhar a atualização.
2. Executar com FModoDebug falso: o histórico deve conter CÓDIGO GERADO e as etapas do caso, sem exibição das mensagens de debug.
3. Executar com FModoDebug verdadeiro: manter a captura e também mostrar as mensagens.
4. Executar um lote com dois casos identificáveis: ambos devem conter a preparação comum, e cada histórico deve conter apenas as etapas daquele caso.
5. Reexecutar com outra configuração: conferir que o novo histórico não contém as mensagens específicas do lote anterior.
6. Provocar uma falha controlada no teste: conferir preparação e diagnóstico no histórico da tentativa.

Verificações locais aprovadas: cinco grupos novos, dezesseis grupos do IRunner, cinco grupos da revisão independente anterior e três grupos de confirmação da sincronização. Sensor independente desta entrega detectou três mutações.

A suíte geral de sincronização ainda reprova a verificação antiga da massa financeira: ela espera camposDisponiveis igual a objeto vazio no arquivo JSON local, mas o arquivo atual não contém essa propriedade. Seis grupos anteriores passam; a verificação foi preservada e a massa não foi alterada para encobrir a divergência. Quatro grupos independentes de sincronização passam. O executor local substitui APIs externas e não prova o funcionamento nativo do JvInterpreter, ODBC ou threads. A execução no ERP continua pendente.

# O que há de novo

Os históricos passam a receber os logs mesmo sem debug e incluem a preparação do código executado, mantendo os registros de cada caso separados.
