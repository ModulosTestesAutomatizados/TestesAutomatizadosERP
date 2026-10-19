# Decisões de evolução em 2026-10-16

O usuário definiu este contrato após a validação nativa do caso 28. Estas decisões substituem a regra anterior que reprovava o resultado esperado igual a {}. A implementação e a validação desta evolução são acompanhadas em ../sincronizacao-fonte-unica/spec.md.

| Entrada na fonte única | Resultado da sincronização |
| --- | --- |
| Propriedade resultadoEsperado ausente | Carregar a codificação de P39_TDD_ASSERTS_JSON_MINIMO como resultado esperado |
| resultadoEsperado: {} explícito | Preservar objeto vazio como desativação explícita; não aplicar mínimo |
| resultadoEsperado com objeto preenchido | Usar esse objeto como resultado esperado |
| camposDisponiveis ausente ou vazio | Carregar P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO, atualmente {} |
| camposDisponiveis com objeto preenchido | Preservar o objeto explícito sem fallback |

Na execução, resultado esperado vazio ou objeto JSON com zero propriedades significa ausência de configuração: não acrescentar assert e registrar SEM_VALIDACAO, preservando quaisquer asserts explícitos do teste. O padrão é aplicado na sincronização, não recalculado durante o runner.

Direção técnica recomendada: propriedade resultadoEsperado no nível raiz do JSON atual, ao lado dos dados e de parametros. A sincronização projeta os dados de entrada em CASO_TESTE_CT e resultadoEsperado em RESULTADO_ESPERADO_CT. STARTED e a estrutura de parâmetros recebida por ela permanecem preservadas. Não criar funções de preparação/finalização adicionais.

Validações propostas para implementação: null, arrays e escalares em resultadoEsperado são erros de configuração. Falha de leitura ou conteúdo inválido da unit mínima deve interromper a sincronização antes das gravações, sem ser convertido silenciosamente em {} por CarregarConteudoUnit. A unit remota mínima tem nome exato P39_TDD_ASSERTS_JSON_MINIMO; evitar duplicação do prefixo remoto.

Corpo mínimo acordado na conversa anterior: {"erro":{"quantidade":0,"operacao":"Igual"}}. Ele verifica erros explicitamente registrados no fluxo, sem substituir validações financeiras específicas.

O arquivo [json](../../../docs/assets/emDesenvolvimento/TDD_ASSERTS_JSON_MINIMO.json) já está com o valor mínimo incluindo a propriedade "resultadoEsperado", isso vai facilitar em algumas regras na unit de sincronização.

A unit remota P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO foi criada pelo usuário durante a implementação. O corpo {} é aceito; quando preenchida, usa {"camposDisponiveis": {...}}. A sincronização já consulta essa unit, sem precisar alterar código quando o padrão for preenchido.

A observação vinculada para essa unit do tipo json no ambiente remoto foi:

```text
A sincronização dos casos de teste faz uma leitura de um json com as configurações de cada caso, ao se deparar com a ausência da propriedade "resultadoEsperado" nesse determinado Json, o conteúdo dessa unit é utilizado como fallback, ressalva para quando essa propriedade exista, mesmo que vazia ("resultadoEsperado": {}), nesse caso as propriedades explícitas são aplicadas, json vazio ignora asserts no teste.
```
