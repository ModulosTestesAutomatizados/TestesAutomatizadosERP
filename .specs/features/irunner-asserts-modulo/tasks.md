# IRunner: tarefas de implementação

**Status**: Done (implementa??o local). Especificação aprovada pelo usuário. Executar inline; sete tarefas. Sem stage/commit, conforme instrução do usuário, que prevalece sobre commits automáticos da skill.

## Test Coverage Matrix

> Gerada dos probes em .specs/features/tdd-irunner-mvp/evidencias e dos 25 requisitos aprovados. Sem compilador Delphi/ERP disponível. Não usar os probes antigos como prova desta iteração: referenciam nomes e contratos anteriores.

| Code Layer | Required Test Type | Coverage Expectation | Location Pattern | Run Command |
| --- | --- | --- | --- | --- |
| Dependências | unit estrutural | Grafo, resolução de nomes e estado único | evidencias/testar.mjs | node .specs/features/irunner-asserts-modulo/evidencias/testar.mjs nomes |
| Domínio Pascal | unit traduzida | Requisitos e casos limite; executar os métodos extraídos, substituir fronteiras ERP | evidencias/testar.mjs | node .specs/features/irunner-asserts-modulo/evidencias/testar.mjs |
| ODBC | integração simulada | Payloads completos e falhas parciais, sem gravações | evidencias/testar.mjs | node .specs/features/irunner-asserts-modulo/evidencias/testar.mjs persistencia |

## Gate Check Commands

| Gate Level | When to Use | Command |
| --- | --- | --- |
| Quick | Tarefa individual | node .specs/features/irunner-asserts-modulo/evidencias/testar.mjs GRUPO |
| Full | Integração | node .specs/features/irunner-asserts-modulo/evidencias/testar.mjs |
| Build | Encerramento local | node .specs/features/irunner-asserts-modulo/evidencias/testar.mjs; node .specs/features/irunner-asserts-modulo/evidencias/verificar-independente.mjs; node .specs/features/irunner-asserts-modulo/evidencias/sensor-independente.mjs; git diff --check |

## Execution Plan

### Phase 1: Implementação sequencial

```text
T1 -> T2 -> T3 -> T4 -> T5 -> T6 -> T7
```

## Task Breakdown

### T1: Resolver nomes na cadeia executável
**What**: Atualizar referências e verificar o grafo sem estados duplicados.
**Where**: cadeia de dependências Pascal do IRunner e evidencias/testar.mjs
**Depends on**: None
**Requirement**: RUN-01, RUN-02, RUN-03
**Reuses**: uses e geração atuais; sem novos pontos de entrada.
**Done when**:
- [x] Grafo resolve nomes locais/remotos e origem única de logs/asserts.
**Tests**: unit estrutural, grupo nomes.
**Gate**: quick

### T2: Usar contexto único de módulo
**What**: Remover configuração/carga redundante e validar operações de tela.
**Where**: docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_MODULO.pas
**Depends on**: T1
**Requirement**: RUN-04, RUN-05, RUN-06
**Reuses**: AbrirTela, FocarModulo, TrazerParaFrente e contexto de CASOS_DE_TESTE.
**Done when**:
- [x] Não há FDescModulo duplicado ou carga de casos em MODULO; erros sem prefixo central.
**Tests**: unit traduzida, grupo modulo.
**Gate**: quick

### T3: Isolar acúmulo e capturas de asserts
**What**: Adaptar os métodos existentes de registro e reset ao ciclo por caso.
**Where**: docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_ASSERTS.pas
**Depends on**: T2
**Requirement**: RUN-08, RUN-12, RUN-13
**Reuses**: RegistrarResultado, RegistrarDataSet, AssertsZerar e primitivas.
**Done when**:
- [x] Contadores, relatório e cópias persistem após fechar a origem; reset libera somente recursos próprios.
**Tests**: unit traduzida, grupo asserts.
**Gate**: quick

### T4: Reduzir o validador às comparações
**What**: Corrigir operações/tipos e remover controle de execução, reset, cronômetro e diálogos.
**Where**: docs/assets/configuracoesGerais/P39_TDD_VALIDAR_RESULTADO.pas
**Depends on**: T3
**Requirement**: RUN-09, RUN-13, RUN-14, RUN-15, RUN-16, RUN-17, RUN-18, RUN-19, RUN-20
**Reuses**: CompararResultadoEsperado, CompararComJSON e comparações existentes.
**Done when**:
- [x] Comparações tipadas corretas; expectativas inválidas falham; ausência registra SEM_VALIDACAO; nenhum efeito interativo.
**Tests**: unit traduzida, grupo validador.
**Gate**: quick

### T5: Integrar reset, validação e status no ciclo
**What**: Conectar os métodos existentes ao fluxo de tentativa.
**Where**: ciclo Run/SetarCasoTeste em RUN_UNIT_BASE_IRUNNER e RUN_RUNNER
**Depends on**: T4
**Requirement**: RUN-04, RUN-07, RUN-10, RUN-11, RUN-20, RUN-24
**Reuses**: SetarCasoTeste, RegistrarTick, AssertsZerar e CompararResultadoEsperado.
**Done when**:
- [x] Dois casos não compartilham resultados; falha de assert afeta histórico e resumo; exceção preserva parcial.
**Tests**: integração traduzida, grupo ciclo.
**Gate**: full

### T6: Persistir o resumo de asserts
**What**: Consolidar e enviar métricas ao ODBC pelo histórico retornado.
**Where**: docs/assets/emDesenvolvimento/Runner/TDD_RUN_FINISHED.pas
**Depends on**: T5
**Requirement**: RUN-21, RUN-22, RUN-23, RUN-24, RUN-25
**Reuses**: RegistrarMetricas e SQL comentado existente.
**Done when**:
- [x] Payload completo em sucesso, falha, parcial e zero; sem retry do histórico.
**Tests**: integração simulada, grupo persistencia.
**Gate**: full

### T7: Capturar resultados do financeiro e verificar a integração
**What**: Registrar dados antes dos fechamentos intermediários e validar requisitos da feature.
**Where**: docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO.pas
**Depends on**: T6
**Requirement**: RUN-12 e integração RUN-01 a RUN-25
**Reuses**: RegistrarDataSet; nenhum wrapper de preparação/finalização.
**Done when**:
- [x] Pontos de captura precedem fechamentos; gate local e revisão independente documentados.
**Tests**: integração traduzida e revisão independente com mutações isoladas.
**Gate**: build

## Cross-check

| Tarefa | Dependência no corpo | Seta no plano | Tests/matriz |
| --- | --- | --- | --- |
| T1 | None | origem | estrutural |
| T2 | T1 | T1 -> T2 | unit |
| T3 | T2 | T2 -> T3 | unit |
| T4 | T3 | T3 -> T4 | unit |
| T5 | T4 | T4 -> T5 | integração |
| T6 | T5 | T5 -> T6 | integração |
| T7 | T6 | T6 -> T7 | integração e verifier |

## Resultado dos gates

T1 a T7 conclu?das no gate local: 16 grupos do autor e 5 independentes. Sensor detectou 3/3 muta??es; sem alterar fontes reais. Cobertura por requisito e evid?ncias em validation.md. Sem commits por instru??o do usu?rio. Valida??o nativa permanece separada.
