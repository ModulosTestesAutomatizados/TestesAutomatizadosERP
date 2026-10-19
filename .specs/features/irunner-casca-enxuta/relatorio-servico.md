# Reorganização da casca IRunner

**Data:** 2026-10-15
**Baseline:** e47d2a4
**Entrega:** alterações locais sem stage e sem commit. Confirmação no ERP pendente.

## Realização (Interno)

Registrado o progresso anterior no commit e47d2a4 antes desta iteração. Criada a especificação TLC irunner-casca-enxuta com dez critérios verificáveis.

A casca passou de 223 para 183 linhas. SetarCasoTeste reinicia o contexto antes de acessar os campos do registro. RegistrarTick incorpora o cálculo relativo e seus limites; AplicarParametrosDoCasoTeste incorpora a leitura da seção JSON. Os dois helpers de uso único foram removidos e nenhum método Pascal foi criado.

Após a revisão do usuário, SetarCasoTeste recebe somente módulo e área e sempre lê a descrição do registro corrente. A chamada da casca, o exemplo Pascal e a documentação do portal usam a assinatura de dois parâmetros. A sonda verifica a aridade e descrições diferentes para os casos 28 e 33.

RegistrarMetricas encerra os ticks abertos usando RegistrarTick(1, nome), copia os logs antes do INSERT e contextualiza falhas de persistência. A chamada permanece no finally da casca, antes de limpar a lista. Erro de tick não impede a tentativa de gravar histórico, e não há retry automático. O controle de continuidade e o resumo permanecem no lote. TDD_LOGS não foi alterada nesta iteração.

Os onze grupos do gate local e as sondas anteriores passaram. O sensor independente da reorganização detectou cinco mutações em cópias temporárias, sem alterar fontes reais. Esses resultados são evidência local com tradução restrita e doubles, não execução do JvInterpreter ou gravação em banco. Consulte validation.md para a cobertura e os limites, incluindo a revisão da assinatura simplificada.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas
- docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas
- docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas
- Documentacoes/app/content/units/tdd-runner.ts
- .specs/features/tdd-irunner-mvp/evidencias/testar-logs-processamento.mjs
- .specs/features/tdd-irunner-mvp/evidencias/testar-parametros-json.mjs
- .specs/features/tdd-irunner-mvp/evidencias/testar-persistencia-falhas.mjs
- .specs/features/tdd-irunner-mvp/evidencias/testar-tick-relativo.ps1
- .specs/features/irunner-casca-enxuta/spec.md
- .specs/features/irunner-casca-enxuta/pascal-probe.mjs
- .specs/features/irunner-casca-enxuta/ambiente.mjs
- .specs/features/irunner-casca-enxuta/testar.mjs
- .specs/features/irunner-casca-enxuta/validation.md
- .specs/features/irunner-casca-enxuta/relatorio-servico.md
- .specs/STATE.md

## p/ teste

1. Revisar o diff em relação a e47d2a4. Todas as alterações seguintes estão sem commit.
2. Disponibilizar as quatro units Pascal no ambiente de testes correto e fechar/reabrir no BI para usar os fontes atuais.
3. Executar o caso financeiro com os valores zerados: deve reprovar a validação, gravar o histórico com os logs quando o debug estiver ativo, continuar os casos seguintes e apresentar o resumo do lote.
4. Conferir um caso válido: os tempos relativos e a aplicação dos parâmetros devem manter o comportamento anterior.
5. Em uma fixture sem operações financeiras, provocar falhas na leitura do caso, no fechamento de tick e na persistência. Conferir proteção do ID anterior, tentativa de histórico após erro de tick e diagnóstico combinado sem repetição de INSERT.
6. Conferir em LOGS_PROCESSAMENTO_HE que cada histórico contém os logs da tentativa correta.

Gate local: `node .specs/features/irunner-casca-enxuta/testar.mjs .`.

## O que há de novo

O fluxo do runner ficou mais curto na casca, reaproveitando os métodos existentes e preservando o tratamento das falhas e o resumo do lote. A revisão das próximas mudanças ficou separada do checkpoint anterior no Git.
