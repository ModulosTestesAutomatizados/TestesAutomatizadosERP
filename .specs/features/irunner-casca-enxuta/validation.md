# Casca IRunner enxuta — validação independente

## Validation: PASS local

**Data:** 2026-10-15. **Verifier:** subagente independente; autor ≠ verificador.
**Spec:** `.specs/features/irunner-casca-enxuta/spec.md`.
**Diff:** `e47d2a4279388f0b0fe88414a9863371236d399b` contra working tree, incluindo arquivos novos da feature. Nenhum stage, commit, stash ou acesso de escrita ao banco foi realizado pelo verificador.

O resultado cobre a organização local do runner e as sondas descritas na spec. Compilação Pascal, execução no JvInterpreter e persistência real no ERP permanecem pendentes. Não há aprovação de runtime ERP implícita neste resultado.

## Etapas verificadas

| Etapa do plano | Evidência | Situação |
| --- | --- | --- |
| Incorporar cálculo e parâmetros nos consumidores | TDD_RUNNER.pas:240; TDD_STARTED.pas:59 | Concluída localmente |
| Reinicializar contexto antes de ler CDS | TDD_RUNNER.pas:146 precede a leitura em :164 | Concluída localmente |
| Mover encerramento/persistência para RegistrarMetricas | TDD_FINISHED.pas:23; TDD_BASE_UNIT_IRUNNER.pas:176 | Concluída localmente |
| Sondas e revisão independente | Gates e sensor abaixo | Concluída localmente |

Não existe tasks.md nesta iteração: o plano de quatro etapas está na spec. A instrução explícita de manter a iteração sem stage/commit prevalece sobre commits por tarefa.

## Cobertura rederivada da spec

Os caminhos de teste abaixo são relativos a `.specs/features/irunner-casca-enxuta/`, salvo indicação contrária. Foram lidos os asserts e comparados com o resultado exato exigido, além de inspecionada a implementação correspondente.

| AC | Resultado definido na spec | file:line + assertion expression | Resultado |
| --- | --- | --- | --- |
| CASCA-01 | Remover somente os dois helpers, sem novos métodos Pascal | `testar.mjs:60` — `assert.ok(!sources.TDD_RUNNER.includes('function CalcularTickRelativo('))` e equivalente para parâmetros; `testar.mjs:62` — `assert.ok(allowed.has(match[1].toLowerCase()))`. Comparação independente das declarações no baseline: BASE 3→3, RUNNER 9→8, STARTED 5→4, FINISHED 2→2 | PASS local |
| CASCA-02 | Seis valores relativos exatos: 110, 9, 12, 1, 7, 2147483647 | `testar.mjs:10` define os seis vetores; `testar.mjs:12` — `assert.equal(e.api.FCDSMetricasTickDiff.rows[0].TEMPO_INICIO,want)` | PASS local |
| CASCA-03 | Rejeitar duração acima de 2147483646 antes de inserir métrica | `testar.mjs:14` — `assert.throws(...,/limite Integer/)`; `assert.equal(...rows.length,0)` | PASS local |
| CASCA-04 | Aplicar exatamente objeto raiz; ausente/vazio não aplica; inválidos falham | `testar.mjs:17` — `assert.deepEqual(e.applied,[])`; `testar.mjs:18` — `assert.deepEqual(e.applied,[{A:1,B:false}])`; `testar.mjs:19` cobre objeto vazio; `testar.mjs:20` — `assert.throws(...)` e `assert.deepEqual(e.applied,[])` para cinco inválidos | PASS local |
| CASCA-05 | ID zero e estado anterior reiniciado se leitura do ID falha; nenhum histórico indevido; assinatura de dois parâmetros e descrição corrente | `testar.mjs:24` — `assert.throws(...,/leitura ID/)`; `testar.mjs:25` — `assert.deepEqual(FHistoricoExecucao,{AutoIncCasoTeste:0,AutoIncHistorico:0,MensagemErro:'',LogsProcessamento:'',StatusExecucao:'',VersaoExecucao:'',RequisitoVersao:'',EtapaFalha:0})`, JSON vazio e etapa zero; `testar.mjs:49` — `assert.equal(invalid.histories.length,0)`; `testar.mjs:29` — `assert.equal(e.api.SetarCasoTeste.length,2)`; `testar.mjs:31` e `testar.mjs:33` — IDs 28/33 e descrições exatas Primeiro caso/Segundo caso após Next | PASS local |
| CASCA-06 | Encerrar ticks abertos via RegistrarTick, copiar logs antes do INSERT e limpeza | `testar.mjs:37` — `assert.ok(...TEMPO_FIM>0)`, `assert.equal(...TEMPO_TOTAL,10)`, payload SUCESSO e `assert.match(e.histories[0][6],/log antes do insert/)` inclusive após Clear. Revisão da ordem em `docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas:36`, :59 e :81; finally e Clear em `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas:170` e :179 | PASS local |
| CASCA-07 | Falha no fechamento ainda tenta histórico FALHA, preserva incompatibilidade e propaga após tentativa | `testar.mjs:40` — erro presente, `histories.length===1`, status FALHA, log da falha, um insert; `testar.mjs:41` — `assert.throws(...,/falha tick final/)` e status `VERSAO_INCOMPATIVEL` | PASS local |
| CASCA-08 | Causa anterior antes de FINISHED; logs em memória; sem retry; etapa restaurada quando persiste | `testar.mjs:44` — `assert.match(...,/validacao financeira[\s\S]*FINISHED[\s\S]*banco indisponivel/)`, logs em memória e um insert; `testar.mjs:45` — erro undefined e método IRUNNER; `testar.mjs:50` cobre falha parcial após histórico inserido | PASS local |
| CASCA-09 | Continuar lote após falha individual; resumo com detalhes e prefixo único; vazio/aprovado não lança erro | `testar.mjs:54` — resumo com 1 falha e ID 28, contagem `[PERSONALIZADA]===1`, `calls===2`, statuses `['FALHA','SUCESSO']`, limpeza final; `testar.mjs:55` — `assert.doesNotThrow(...)` para vazio e aprovado | PASS local |
| CASCA-10 | Marcadores, persistência no finally e debug preservados | `testar.mjs:63` — includes dos três marcadores e prefixo único; `testar.mjs:57` — `assert.equal(...Text.includes('mensagem'),flag)` para true/false; `testar.mjs:48` e :49 exercitam finalização e guarda de ID em falhas; inspeção do finally em `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas:170` | PASS local |

**Resultado:** 10/10 ACs possuem evidência local. Nenhuma lacuna de precisão da spec identificada. Os quatro edge cases listados estão nos ACs 05, 07, 08 e 09 e nos asserts acima.

## Gates executados

- `node .specs/features/irunner-casca-enxuta/testar.mjs .`: 11 grupos aprovados, zero grupos falhos; repetido após a extensão de assinatura e descrição corrente.
- Cinco arquivos `.mjs` em `.specs/features/tdd-irunner-mvp/evidencias/`: todos executados com exit 0, incluindo feedback do lote, logs, método FINISHED, parâmetros JSON e falhas de persistência. A sonda de FINISHED importa a de persistência, repetindo seus cinco cenários; isso não representa cobertura independente extra.
- `testar-tick-relativo.ps1 -Root .`: seis valores exatos e uma rejeição aprovados; repetido após ajuste de EOF.
- `validate_spec.py irunner-casca-enxuta`: zero erros, zero warnings.
- `git diff --check`: inicialmente exit 2 por linha vazia nova ao final de `testar-tick-relativo.ps1:45`; autor removeu a linha extra, sem alteração comportamental. Reexecução final: exit 0.
- `git diff --cached --quiet`: exit 0. HEAD final permanece `e47d2a4279388f0b0fe88414a9863371236d399b`.
- Nenhuma compilação Pascal configurada. O ramo opcional da sonda de parâmetros que recebe fixture externa não foi executado porque a fixture não existe neste workspace; os cenários sintéticos exatos estão cobertos.

Integridade: nenhum arquivo de sonda anterior foi removido. Os mesmos casos de parâmetros, persistência e debug foram mantidos, substituindo tradutores ad hoc por uma sonda comum que lê o corpo real dos consumidores. Objeto vazio passa a ser verificado pelo efeito correto (nenhuma aplicação), em vez do retorno do helper removido. Nenhum assert foi identificado como enfraquecido para ocultar regressão. O gate de onze grupos é novo em relação ao checkpoint; o último grupo acrescentado cobre aridade e troca do registro corrente.

## Sensor de discriminação

Fontes reais e testes reais permaneceram somente leitura. O autor foi avisado para pausar edições antes do trecho de isolamento. Copiaram-se cinco fontes para uma raiz temporária; o gate real recebeu essa raiz por argumento. Cada mutação foi aplicada separadamente, executada e restaurada na cópia.

| Mutação | Fonte real correspondente | Falha observada no gate | Resultado |
| --- | --- | --- | --- |
| Remover +1 da reserva de zero | `docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas:247` | actual 109, expected 110 | Detectada, exit 1 |
| Aplicar `{}` em vez do objeto de parâmetros | `docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas:94` | actual `[{}]`, expected `[{A:1,B:false}]` | Detectada, exit 1 |
| Reiniciar ID com 900 em vez de zero | `docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas:146` | deepEqual do histórico reiniciado falha | Detectada, exit 1 |
| Inverter seleção de ticks abertos | `docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas:35` | TEMPO_FIM continua zero | Detectada, exit 1 |
| Esvaziar cópia de logs no payload | `docs/assets/emDesenvolvimento/Runner/TDD_FINISHED.pas:59` e :169 | payload vazio não contém log anterior ao insert | Detectada, exit 1 |

**Sensor inicial:** cinco mutações comportamentais, cinco detectadas, zero sobreviventes. Essa rodada foi preservada; a extensão abaixo acrescentou uma mutação, totalizando seis detectadas e zero sobreviventes. Profundidade ampliada por envolver histórico e estado por tentativa. Uma primeira execução de orquestração foi interrompida pelo tratamento de stderr do PowerShell; foi descartada e as cinco tentativas acima foram concluídas em nova cópia. Não foi contado erro de parser/orquestração como detecção.

**Isolamento:** `git status --porcelain` antes e depois do sensor foi comparado como string exata e permaneceu idêntico: oito caminhos modificados (quatro sondas anteriores e quatro fontes Pascal) e `?? .specs/features/irunner-casca-enxuta/`. O scratch concluído ficou em `C:/Users/Gerson Ribeiro/AppData/Local/Temp/irunner-verifier-fa2d8ed7fed843e2ad1aa4958a76e5d0`; não houve deleção recursiva. Ajustes documentais posteriores do autor não fazem parte do sensor.

## Revisão de regressão, escopo e limites

- Casca reduzida de 223 para 183 linhas; removidas a varredura de métricas e a formatação específica da persistência. Total de declarações Pascal nas quatro units: 19→17, exatamente os helpers acordados.
- O contexto é reiniciado antes da primeira leitura do registro; a casca passa somente módulo e área. A assinatura final tem dois parâmetros e a descrição é sempre obtida de DESCRICAO no CDS corrente, conforme extensão autorizada pelo usuário.
- O fechamento usa o método existente RegistrarTick, e ocorre antes de montar o payload. Exceção no fechamento muda status, preserva VERSAO_INCOMPATIVEL e segue para uma única tentativa de persistência. Exceção de persistência mantém logs em memória e combina mensagens na ordem exigida.
- Persistência e limpeza continuam no finally externo. Não foram alterados regra financeira, JSON do caso ou TDD_LOGS. Nenhuma nova camada Pascal, novo método, modo de operação ou dependência de produção foi adicionada. O ambiente compartilhado existe somente nas evidências locais.
- Diretrizes consideradas: instruções AGENTS.md fornecidas na conversa, spec desta iteração e referências TLC de validação. Context7 não se aplica: revisão de código/refatoração e execução de scripts próprios, sem consulta de API ou documentação de biblioteca.
- Os testes executam um subconjunto Pascal traduzido para JavaScript, com JSON.parse, CDS, contadores, callbacks e ODBC substituídos. Não verificam compilação, registro de métodos, coerção Double→Integer do interpretador, parser JSON nativo, navegação real do CDS ou efeitos transacionais do ERP. A sonda PowerShell executa a expressão escalar em C#, sem runtime ERP.
- A ordem interna e a abrangência da varredura de todos os ticks foram conferidas no fonte, além do teste dinâmico de tick aberto. Os cenários do fluxo usam múltiplas métricas, mas os doubles continuam sendo uma aproximação explícita das fronteiras reais.

## Pendências e rastreabilidade

Sem gaps locais remanescentes. O ajuste de whitespace encontrado foi devolvido ao autor e reverificado, sem correção de fontes/testes pelo verificador. Por restrição de escrita deste trabalho, o verificador não atualizou spec.md/STATE.md nem registrou arquivos de lessons; cabe ao autor refletir os dez ACs como verificados localmente. O achado de whitespace corrigido não demonstra lacuna comportamental reutilizável; zero mutantes sobreviventes, zero ACs sem cobertura e zero desvios da spec.

**Próximo passo externo:** o usuário executar compilação/interpretação e validar payloads no ERP em ambiente autorizado. Esta revisão não executou financeiro, não sincronizou units, não publicou e não escreveu no banco.
## Extensão verificada: assinatura e descrição do caso corrente

A extensão do CASCA-05 foi revisada separadamente. `docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas:143` declara `SetarCasoTeste(pDescricaoModulo, pDescricaoArea :string)`; `TDD_RUNNER.pas:161` zera a descrição anterior e `TDD_RUNNER.pas:166` lê DESCRICAO após reiniciar o contexto. A chamada da casca em `docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas:98`, as instruções Main em `TDD_RUNNER.pas:64`, o exemplo em `docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas:25` e o portal em `Documentacoes/app/content/units/tdd-runner.ts:18` estão consistentes com os dois parâmetros. A remoção do terceiro argumento é mudança intencional de contrato autorizada; não há novo método ou dependência de produção.

O grupo novo em `testar.mjs:27` prova aridade 2 e duas descrições distintas para IDs 28 e 33, lendo ambos os registros pelo mesmo método. Não é possível provar rejeição de argumento excedente no runtime Pascal por aridade de função JavaScript; a assinatura real foi inspecionada e a compilação/interpretação continua pendente no ERP.

Sensor adicional: substituiu-se somente na cópia temporária a atribuição de DESCRICAO em `TDD_RUNNER.pas:166` por `'Primeiro caso'`. O primeiro caso ainda passou, mas `testar.mjs:33` falhou no segundo, com actual `'Primeiro caso'` e expected `'Segundo caso'`; exit 1, mutação detectada. A preparação dos dados, asserts e fonte reais não foram alterados. O autor pausou edições durante o trecho e `git status --porcelain` foi comparado antes/depois como string exata, sem diferença. Scratch preservado em `C:/Users/Gerson Ribeiro/AppData/Local/Temp/irunner-descricao-286e809c31794b3d937bf04afd4be922`.

Reexecução real após a extensão: 11 grupos aprovados; `git diff --check` exit 0; index vazio e HEAD ainda e47d2a4279388f0b0fe88414a9863371236d399b. Os cinco sensores anteriores não foram repetidos porque o delta adicional não altera contador, parâmetros JSON ou finalização. Resultado da extensão: PASS local, sem novos gaps. Os limites de runtime ERP descritos acima permanecem aplicáveis.