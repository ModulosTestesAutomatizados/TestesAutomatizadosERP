# Validation: PASS

## Confirmação antes da leitura — SYNC-13

PASS local da correção de ordem. Verificador independente `/root/verificar_tags_json`: três grupos de `evidencias/testar-confirmacao.mjs`, dez principais e quatro complementares aprovados. Sensor: 4/4 mutações detectadas, incluindo leitura indevida após recusa; hashes e porcelain preservados.

- `P39_TDD_REGISTRAR_CASO_TESTE.pas:86`: consulta e confirmação anteriores à leitura; código negativo encerra apenas este registro.
- `evidencias/testar-confirmacao.mjs:19`: recusa não lança erro com fonte inexistente; sequência contém somente consulta e pergunta. Repetição comprova continuidade.
- `evidencias/testar-confirmacao.mjs:26`: caso novo ou aceite com fonte inexistente interrompe sem escrita de caso, módulo ou área.
- `evidencias/testar-confirmacao.mjs:34`: fonte válida direciona insert/update, uma consulta, uma confirmação quando aplicável e payload completo. ID de atualização conferido em `:39`.

SincronizarCasoTeste passou a consultar por descrições e retornar -1 (recusa), 0 (novo) ou ID (update). QuestionarParaRodarUpdateCasoTeste foi renomeado para AtualizarCasoTeste e mantém somente a persistência, pois a confirmação ocorre antes. Nenhum método novo foi criado. Nenhum acesso real ao banco, stage ou commit. Confirmar no ERP permanece pendente.

## Revisão do contrato com tags — 2026-10-16

PASS local da correção posterior aprovada pelo usuário. Verificador independente `/root/verificar_tags_json`: dez grupos em `evidencias/testar.mjs` e quatro em `evidencias/verificar-independente.mjs`, sem problemas concretos no escopo. Esta revisão substitui o contrato anterior de projeção descrito abaixo, que permanece como histórico da primeira implementação.

- `P39_TDD_REGISTRAR_CASO_TESTE.pas:110`: caso completo mantém camposDisponiveis e resultadoEsperado resolvidos na raiz; as colunas específicas recebem objetos com as respectivas tags.
- `evidencias/testar.mjs:18`: verifica os valores completos das três colunas e a preservação de parametros existente.
- `evidencias/testar.mjs:24`: verifica defaults no caso completo e ausência de parametros sintético (SYNC-12).
- `P39_TDD_REGISTRAR_CASO_TESTE.pas:169`: no máximo duas tentativas; o verificador revisou os caminhos de liberação.
- `P39_TDD_VALIDAR_RESULTADO.pas:252`: extrai resultadoEsperado antes de comparar, preservando os registros anteriores sem tag. Grupos de validação cobrem vazio com tag, null, arrays e seção inválida.
- Sensor atualizado: 3/3 mutações detectadas (resultado vazio usa mínimo indevidamente; retorno perde tag; vazio reprova). Hashes e porcelain preservados pelo sensor.

Os mínimos locais foram movidos pelo usuário para `docs/assets/snippets`; os testes acompanham esse caminho. O modelo documental não é carregado na sincronização. STARTED, documentação publicada e arquivos JSON não foram modificados nesta correção. Nenhum stage, commit ou acesso ao banco. Execução nativa continua pendente.

`git diff --check` identifica espaço ao final da linha vazia anterior a FCasoTeste.Modulo na unit de registro, já presente nas alterações de formatação do usuário e preservado nesta correção.

**Result**: PASS local para SYNC-01 a SYNC-11. Verificador independente `/root/verificar_asserts_modulo`, diferente do autor. Revisão de 2026-10-16 sobre o diff não commitado relativo a `db20fe6ad9fa61310f1e99538cbf213a773b31b4`, preservando as alterações anteriores do usuário. A revisão não executou o ERP, sincronização, ODBC ou gravações em banco; nenhum stage ou commit foi realizado.

## Evidências executadas

- `node .specs/features/sincronizacao-fonte-unica/evidencias/testar.mjs`: nove grupos aprovados.
- `node .specs/features/sincronizacao-fonte-unica/evidencias/verificar-independente.mjs`: quatro grupos adversariais aprovados.
- `node .specs/features/sincronizacao-fonte-unica/evidencias/sensor-independente.mjs`: três mutações detectadas em cópias temporárias, com `RUN_TEST_ROOT`; hashes dos fontes reais e porcelain iguais antes/depois do sensor.
- `node .specs/features/irunner-asserts-modulo/evidencias/verificar-independente.mjs`: cinco grupos anteriores aprovados, com paths adaptados ao estado atual.
- `git diff --check`: exit 0. Avisos LF/CRLF não representam falha de whitespace.

Os testes executam métodos extraídos dos fontes Pascal por um tradutor restrito, substituindo as fronteiras externas. Os testes independentes carregam também `GetPairName` e `GetPairValue` reais, em vez de substituir sua lógica; rastreiam os objetos JSON simulados para exigir liberação e impedir liberação dupla. Isso demonstra os caminhos de `finally`, sem comprovar o comportamento nativo da biblioteca de JSON.

## Cobertura evidence-or-zero

Nas referências abaixo, `evidencias/` pertence a esta feature; `Registro` é `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas` e `Validador` é `docs/assets/emDesenvolvimento/P39_TDD_VALIDAR_RESULTADO.pas`.

| Requisito | Resultado observado e evidência | Veredito |
| --- | --- | --- |
| SYNC-01 | Assinatura de seis argumentos em `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas:64`; `evidencias/testar.mjs:18` verifica record completo e aridade; `evidencias/testar.mjs:20` executa os quatro consumidores com seis argumentos. Busca dos fontes encontrou somente esses quatro callers executáveis. | PASS local |
| SYNC-02 | Projeção de pares em Registro, preservando dados e parametros e excluindo somente as duas propriedades raiz reservadas; `evidencias/testar.mjs:18` compara os três objetos; `evidencias/verificar-independente.mjs:15` cobre texto com aspas/chaves e propriedade reservada aninhada que deve continuar nos dados. | PASS local |
| SYNC-03 | Chamada do resolvedor em Registro:83; `evidencias/testar.mjs:15` verifica ausência e o nome remoto exato do mínimo. `evidencias/verificar-independente.mjs:31` executa o registro com ausência dos dois objetos e confere o mínimo resultante. | PASS local |
| SYNC-04 | `evidencias/testar.mjs:15` exige que objeto explícito vazio/preenchido não consulte fallback; `evidencias/verificar-independente.mjs:15` confere `{}` no payload final do registro, detectando alteração da política no chamador. | PASS local |
| SYNC-05 | Chamada de campos em Registro:84 com fallback remoto e política de vazio; `evidencias/testar.mjs:16` observa consulta nas formas ausente e `{ }`, aceitando fallback `{}` e wrapper preenchido. | PASS local |
| SYNC-06 | `evidencias/testar.mjs:16` e `evidencias/testar.mjs:18` verificam preservação do objeto preenchido em CamposDisponiveis e ausência de consulta desnecessária ao fallback. | PASS local |
| SYNC-07 | Resolução/projeção ocorrem antes do primeiro fallback SQL de Registro:105. `evidencias/testar.mjs:17` e `evidencias/testar.mjs:19` cobrem fonte/reservadas/mínimo de asserts inválidos; `evidencias/verificar-independente.mjs:23` cobre fallback de campos ausente, vazio, null, array, wrapper inválido e propriedade faltante, exigindo zero eventos de escrita. Objetos JSON são liberados em todos os caminhos simulados. | PASS local |
| SYNC-08 | Carregamento estrito em Registro:117; `evidencias/testar.mjs:14` exige `P39_FONTE` tanto para nome curto quanto já prefixado, sem duplicação. | PASS local |
| SYNC-09 | `docs/assets/emDesenvolvimento/P39_TDD_VALIDAR_RESULTADO.pas:254`; `evidencias/testar.mjs:21` mantém tanto assert aprovado como reprovado anteriores, registra SEM_VALIDACAO e não adiciona verificação; `evidencias/verificar-independente.mjs:38` verifica o acumulado após comparação válida seguida de `{ }`, com liberação do objeto antes de sair. | PASS local |
| SYNC-10 | `evidencias/testar.mjs:22` reprova JSON malformado, raiz inválida e seção desconhecida; `evidencias/verificar-independente.mjs:38` demonstra que mínimo válido aprova e quantidade/operação inválidas, array sem verificações e tempo inválido reprovam. | PASS local |
| SYNC-11 | Um único resolvedor em Registro:134, usado pelas duas chamadas Registro:83 e Registro:84; `evidencias/testar.mjs:15` e `evidencias/testar.mjs:16` exercitam políticas diferentes de vazio e fallback configurável sem função paralela para campos. | PASS local |

## Sensor de discriminação

| Mutação em cópia isolada | Contrato violado | Resultado |
| --- | --- | --- |
| RegistrarCasoTeste passa `True` como política de vazio para resultadoEsperado | SYNC-04: `{}` explícito passaria a usar mínimo | Detectada pelo novo teste independente de payload final |
| Projeção inclui todas as propriedades reservadas no caso | SYNC-02 | Detectada pelo gate do autor |
| Validador deixa de aceitar objeto vazio | SYNC-09 | Detectada pelo gate do autor |

A primeira mutação inicialmente sobreviveu aos nove grupos do autor porque o resolvedor era testado com política correta, mas o registro não era exercitado com resultado vazio. O teste independente fechou essa lacuna. Os quatro grupos independentes devem permanecer no gate de encerramento junto dos nove grupos principais.

As cópias foram descartadas após conferir que o destino resolvido pertencia ao diretório temporário exclusivo do sensor. Nenhum arquivo JSON ignorado da árvore real foi alterado pelo sensor.

## Regressão anterior e limites

O gate anterior completo `irunner-asserts-modulo/evidencias/testar.mjs` apresenta **15 grupos aprovados e uma falha**, no teste de geração/lote em `irunner-asserts-modulo/evidencias/testar.mjs:52`: espera `FLogsCasoTeste = nil` após liberar o lote, mas observa um objeto marcado como liberado. `git show HEAD:docs/assets/emDesenvolvimento/Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas` confirma que o baseline db20fe6 já executa `FLogsCasoTeste.Free` sem a atribuição subsequente a nil. Essa alteração antecede esta feature. O teste foi mantido e a produção não foi alterada para contorná-lo. Logo, este PASS é dos onze critérios de sincronização e não constitui aprovação de todo o fluxo IRunner atual; reutilização da lista após Free deve ser investigada em escopo próprio com o interpretador real.

Os quatro exemplos legados continuam contendo fontes Pascal nas units de caso, em vez de JSON. A aridade foi migrada conforme aprovado, mas esses conteúdos precisam ser convertidos em fonte JSON única pelo mantenedor antes de sincronizá-los; a leitura estrita os rejeitará. Nenhuma execução de sincronização foi feita para ocultar ou confirmar esse impacto.

A existência/conteúdo das duas units mínimas remotas foi informada pelo usuário; os testes as substituem por fixtures. A leitura real de CodificacaoUnit, exposição de GetPair/ToJSON, liberação nativa dos objetos e aplicação dos três payloads nas colunas do banco ainda requerem validação no ERP autorizada separadamente. STARTED e regras financeiras não foram alteradas por este escopo.
