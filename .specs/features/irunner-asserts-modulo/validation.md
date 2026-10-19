# Validation: PASS

**Result**: PASS local. Verificador independente `/root/verificar_asserts_modulo`, diferente do autor da implementação. Revisão realizada em 2026-10-15 sobre o diff não commitado de `0303da92a6f590263ae4427e64d4c6e5e9873235` para a árvore de trabalho. Nenhum teste executou ERP, ODBC ou gravação em banco; não houve stage ou commit.

## Evidências executadas

- `node .specs/features/irunner-asserts-modulo/evidencias/testar.mjs`: 16 grupos aprovados.
- `node .specs/features/irunner-asserts-modulo/evidencias/verificar-independente.mjs`: cinco grupos adversariais aprovados.
- `node .specs/features/irunner-asserts-modulo/evidencias/sensor-independente.mjs`: três mutações detectadas em cópias temporárias via `RUN_TEST_ROOT`. Hashes dos três fontes reais e `git status --porcelain` iguais antes/depois do sensor.
- `git diff --check`: exit 0; avisos de conversão LF/CRLF não indicam falha de whitespace.

Os executores traduzem métodos extraídos dos fontes Pascal e substituem fronteiras externas. Valores esperados foram confrontados com os ACs, incluindo limites estritos, estados consecutivos, payload completo, preservação de falha e log anterior à limpeza. O gerador real `Executar` e o `Main` gerado são exercitados pelo teste em `evidencias/testar.mjs:52`; não se trata de compilação nativa.

## Cobertura dos requisitos

Nas referências abaixo, `Runner/` corresponde a `docs/assets/emDesenvolvimento/Runner/`, `Gerais/` a `docs/assets/configuracoesGerais/`, e `evidencias/` ao diretório desta feature.

| AC | Evidência de implementação e resultado observado | Veredito local |
| --- | --- | --- |
| RUN-01 | `evidencias/testar.mjs:12`: grafo transitivo sem os nomes antigos; os destinos necessários existem. | PASS |
| RUN-02 | `Runner/TDD_RUN_IRUNNER.pas:48`, `evidencias/testar.mjs:52`: geração usa o molde novo, injeta a unit financeira e remove marcadores. | PASS |
| RUN-03 | `evidencias/testar.mjs:12`: travessia sem ciclos e estado único RUN_LOGS/RUN_ASSERTS no caminho inspecionado. | PASS |
| RUN-04 | `Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas:30`, `evidencias/testar.mjs:51`: segunda carga remove registros anteriores; geração real executa dois casos com uma chamada de setup. | PASS |
| RUN-05 | `Runner/P39_TDD_RUN_MODULO.pas:1`, `evidencias/testar.mjs:22`: sem declaração duplicada ou recarga; opera no contexto existente. | PASS |
| RUN-06 | `Runner/P39_TDD_RUN_MODULO.pas:9`, `Runner/P39_TDD_RUN_MODULO.pas:21`, `Runner/P39_TDD_RUN_MODULO.pas:32`: os três métodos conferem módulo/descrição e form; sem prefixo central. Teste de tela/contexto em `evidencias/testar.mjs:22`. | PASS |
| RUN-07 | `Runner/TDD_RUN_RUNNER.pas:147`, `Runner/P39_TDD_RUN_ASSERTS.pas:215`; `evidencias/testar.mjs:44`, `evidencias/testar.mjs:45`, `evidencias/testar.mjs:49`: reset antes de ler ID, segundo caso sem estados anteriores, erros reais zerados. | PASS |
| RUN-08 | `Runner/P39_TDD_RUN_ASSERTS.pas:90`, `evidencias/testar.mjs:33`, `evidencias/testar.mjs:50`: total e contador exclusivo; evidências dos valores efetivos de booleano, texto e moeda. | PASS |
| RUN-09 | `Gerais/P39_TDD_VALIDAR_RESULTADO.pas:206`, `evidencias/testar.mjs:37`: assert explícito aprovado permanece junto da comparação automática. | PASS |
| RUN-10 | `Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas:142`, `evidencias/testar.mjs:52`: primeiro caso FALHA, segundo SUCESSO, resumo central com dois executados e um falho. | PASS |
| RUN-11 | `evidencias/testar.mjs:44`, `evidencias/testar.mjs:46`: exceção original preservada e assert parcial persistido. | PASS |
| RUN-12 | `Runner/P39_TDD_RUN_ASSERTS.pas:63`, `evidencias/testar.mjs:34`, `evidencias/verificar-independente.mjs:11`: captura sobrevive ao fechamento, substituição libera cópia anterior, origem não é liberada/editada. Pontos financeiros precedem fechamento em `docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO.pas:171`, `docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO.pas:249` e `docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO.pas:331`. | PASS |
| RUN-13 | `evidencias/testar.mjs:37`, `evidencias/verificar-independente.mjs:11`: falta de captura/campo, ambiguidade e captura inativa reprovam; chave explícita desambigua. | PASS |
| RUN-14 | `Gerais/P39_TDD_VALIDAR_RESULTADO.pas:1`, `evidencias/testar.mjs:40`: validador delega acúmulo/logs, não persiste e não controla o ciclo; `RegistrarErroReal` pertence ao acúmulo. | PASS |
| RUN-15 | `Gerais/P39_TDD_VALIDAR_RESULTADO.pas:20`, `evidencias/testar.mjs:36`, `evidencias/verificar-independente.mjs:6`: obtido > esperado e obtido < esperado; limites iguais reprovam nos três tipos numéricos/data. | PASS |
| RUN-16 | `Gerais/P39_TDD_VALIDAR_RESULTADO.pas:55`, `evidencias/testar.mjs:36`, `evidencias/verificar-independente.mjs:23`: conversões estritas; inválidos e NULL não aprovam zero/falso. | PASS |
| RUN-17 | `evidencias/testar.mjs:37`: objeto vazio, seção desconhecida, JSON malformado, array sem verificações e quantidade inválida produzem reprovação. Código rejeita tipo/operação inválidos em `Gerais/P39_TDD_VALIDAR_RESULTADO.pas:55`. | PASS |
| RUN-18 | `evidencias/testar.mjs:40`: análise estrutural impede diálogos, alteração de flag e cronômetro próprio no validador. | PASS |
| RUN-19 | `Gerais/P39_TDD_VALIDAR_RESULTADO.pas:242`, `evidencias/testar.mjs:37`: ausência produz SEM_VALIDACAO e não cria assert fictício. | PASS |
| RUN-20 | `Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas:137`, `Gerais/P39_TDD_VALIDAR_RESULTADO.pas:183`, `evidencias/testar.mjs:42`: tempo IRUNNER obtido antes de ASSERTS, zero válido e limite excedido reprovado. | PASS |
| RUN-21 | `Runner/TDD_RUN_FINISHED.pas:106`, `evidencias/testar.mjs:46`, `evidencias/verificar-independente.mjs:37`: uma linha, oito valores em ordem, FK retornada 96, esperado não vazio, relatório obtido e duração efetiva 25 ms. | PASS |
| RUN-22 | `evidencias/testar.mjs:46`: sucesso, reprovação, exceção parcial e total zero enviam os contadores próprios. | PASS |
| RUN-23 | `evidencias/testar.mjs:47`: falha do INSERT de asserts propaga causa original + FINISHED; exatamente um INSERT de histórico, sem retry. | PASS |
| RUN-24 | `Runner/TDD_RUN_RUNNER.pas:250`, `evidencias/verificar-independente.mjs:28`: uso de RegistrarTick, virada Cardinal gera 11 ms e valor fora de Integer é rejeitado. | PASS |
| RUN-25 | `Runner/TDD_RUN_FINISHED.pas:74`, `evidencias/testar.mjs:46`, `evidencias/testar.mjs:52`: logs incluem FINISHED antes do INSERT; são limpos depois; debug falso conserva a política aprovada. | PASS |

## Sensor de discriminação

| Mutação isolada | Contrato violado | Detecção |
| --- | --- | --- |
| Maior usa `>=` | RUN-15, limite igual | `verificar-independente.mjs`, limites estritos |
| `if AssertsOk` substituído por condição verdadeira | RUN-10, status com reprovação | `testar.mjs`, ciclo de casos |
| `ResultadoObtido` descarta o relatório | RUN-21/22, evidências persistidas | `testar.mjs`, payload de persistência |

O primeiro mutante sobrevive ao conjunto original sem limites iguais e é eliminado pelo teste independente adicionado. Esse teste deve permanecer no gate de encerramento.

## Correções solicitadas durante a verificação

- Os métodos de foco/frente não conferiam contexto de módulo: autor corrigiu sem novo wrapper.
- Evidências de booleano/texto/moeda não incluíam todos os valores efetivos: autor ampliou mensagens e teste.
- A factory simulada de TClientDataSet reutilizava a mesma instância; o teste de duas capturas revelou o problema. Autor corrigiu o mock; ambas as cópias agora são independentes.
- Migração de um validador legado de faturamento introduziria incompatibilidade com funções antigas e estado duplicado. Autor retirou essa migração fora do caminho desta feature.

## Limites e validação posterior no ERP

Não há gap local bloqueante restante nos 25 ACs. A aprovação local não comprova resolução de nomes no interpretador instalado nem INSERTs reais. O grafo local trata os nomes remotos P39 e seus equivalentes locais como a mesma identidade lógica; a sincronização deve respeitar o nome de cada destino.

É necessário observar no ERP: disponibilidade dos membros nativos usados na captura (`Data`, `RecNo`, `FindField`) e JSON; o formato de datas/decimais do ambiente; os quatro pontos financeiros com datasets ativos após gravar; e a FK/conteúdo real de METRICAS_ASSERTS. Cópia de `Data` mais `RecNo` deve ser conferida especialmente se a origem tiver índice/filtro diferente da cópia. Esses efeitos nativos não são representados pelo mock de dataset. O contrato atual captura o registro corrente, e a última captura de uma mesma chave substitui a anterior, conforme a especificação aprovada.

Nenhuma sincronização, execução financeira ou escrita em banco foi usada como evidência desta revisão.
