# Verificação independente — logs de preparação

Revisor: agente `verificar_logs_preparacao`, distinto do implementador. Revisão da árvore de trabalho em 2026-10-16; nenhuma execução no ERP, consulta ao banco, alteração de fonte Pascal, stage ou commit pelo revisor.

## Resultado e rastreabilidade

Não foi encontrado impedimento nos caminhos analisados. Os seis requisitos têm evidência local; a compatibilidade efetiva com JvInterpreter permanece dependente do teste no ERP.

| Requisito | Evidência no fonte | Evidência executada |
|---|---|---|
| LOG-01 | `TDD_RUN_LOGS.pas:45–54`: inclusão na lista anterior à condição de debug | Grupo de captura com debug falso e verdadeiro; mutante que volta a condicionar a captura foi detectado |
| LOG-02 | `TDD_RUN_LOGS.pas:52–53`: somente `MostrarLogTexto` depende de `FModoDebug` | Exibição, captura e instruções verificadas separadamente |
| LOG-03 | `TDD_RUN_IRUNNER.pas:63–66,85–92`: limpeza no início da chamada e cópia após registrar o código gerado | Histórico exclui marcador do lote anterior; segunda preparação não incorpora a primeira |
| LOG-04 | `TDD_RUN_UNIT_BASE_IRUNNER.pas:101–104,202`: limpa e repõe snapshot antes de cada caso; limpa após persistir | Dois casos têm a mesma preparação e excluem log exclusivo do vizinho; falha também mantém preparação |
| LOG-05 | `TDD_RUN_IRUNNER.pas:89–98` e `TDD_RUN_UNIT_BASE_IRUNNER.pas:25`: literal escapado, liberação da lista externa antes de `Interpretar` e atribuição no contexto interpretado | Aspas, acentos, CR, LF e texto que parece comando preservados; mutante de transferência vazia detectado |
| LOG-06 | Chamadas Pascal pesquisadas em toda `docs/assets` | Grupo confirma ausência do identificador antigo |

Arquivos citados sem caminho completo acima pertencem a `docs/assets/emDesenvolvimento/Runner/`. A cópia para persistência continua em `TDD_RUN_FINISHED.pas:73–74` e não depende do debug.

## Comandos e resultados

- `node .specs/features/irunner-logs-preparacao/testar.mjs`: 5 grupos passaram.
- `node .specs/features/irunner-asserts-modulo/evidencias/testar.mjs`: 16 grupos passaram.
- `node .specs/features/irunner-logs-preparacao/sensor-independente.mjs`: 3/3 mutantes detectados por asserções; modificações limitadas a cópias temporárias removidas ao final. Além da captura e da transferência, foi detectada a remoção da recomposição por caso.
- Após o ajuste final que libera e zera a lista externa antes de `Interpretar`, o revisor repetiu os 5 grupos de logs e os 3 mutantes: todos os resultados foram mantidos. A chamada recebe o texto já incorporado ao código e cria sua própria lista quando necessário.
- `node .specs/features/sincronizacao-fonte-unica/evidencias/testar.mjs`: 6 grupos passam, depois falha em `todos consumidores`, linha 20, pois a fixture ignorada `TDD_FIN_FINANCEIRO_JSON.json` não contém `camposDisponiveis: {}` que o teste antigo exige. Essa ausência corresponde ao cenário informado pelo usuário e não decorre desta alteração de logs. Não se alterou a fixture ou a expectativa para ocultar a falha.

## Limites e pontos de atenção

- Os testes executam métodos Pascal mediante executor local em JavaScript; não constituem compilação Delphi/JvInterpreter nem prova da implementação de threads de `Interpretar`.
- A simulação com lista inicialmente compartilhada propaga a referência ao terminar o contexto interno; ela não prova identidade de estados globais no interpretador real. O caso com contextos separados comprova que a transferência textual não depende da lista externa.
- `Interpretar` deve concluir antes de o `finally` externo liberar seus recursos, como já pressupunha o fluxo existente para `FUnitInterpretar`. Caso a API seja realmente assíncrona, será necessário confirmar seu contrato no ERP; a cópia textual evita compartilhar a lista, mas não demonstra sincronismo da API.
- Os logs de setup do lote, anteriores ao primeiro `Run` no contexto interno, continuam sujeitos à limpeza por caso. O requisito aprovado transporta a preparação externa da chamada `Executar`; não amplia a persistência para mensagens posteriores ao último histórico ou falhas anteriores à criação de um caso válido.
- A captura permanente aumenta o volume do histórico, sobretudo porque cada caso inclui o código gerado. Verificar no teste do ERP a gravação do texto integral e o comportamento com debug falso.
- O rename de `TDD_VALIDAR_RESULTADO` para `TDD_RUN_VALIDAR_RESULTADO` já existia no ambiente; o `uses` corrigido do RUNNER corresponde ao arquivo presente. Não foram identificadas remoções das modificações do usuário nos fontes gerais previamente alterados.
