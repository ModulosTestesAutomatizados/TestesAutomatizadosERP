# Dependências do piloto financeiro no fluxo IRunner

O piloto tem entrada `Teste`, chamada pela casca gerada. O processamento configura P39_TDD_IRUNNER diretamente. O estado compartilhado depende do contrato customizado do host ERP; o grafo de uses não comprova essa visibilidade por si só.

```mermaid
flowchart TD
    PROC[P39_TDD_FIN_PROCESSAMENTO] --> IR[P39_TDD_IRUNNER]
    IR --> LOG[P39_TDD_LOGS]
    IR -. CodificacaoUnit .-> BASE[P39_TDD_BASE_UNIT_IRUNNER]
    BASE --> RUNNER[P39_TDD_RUNNER]
    BASE -. marcador de uses preenchido .-> PILOTO[P39_TDD_FIN_PAGAMENTO_RECEBIMENTO]
    RUNNER --> START[P39_TDD_STARTED]
    RUNNER --> FIN[P39_TDD_FINISHED]
    RUNNER --> LOG[P39_TDD_LOGS]
    PILOTO --> RECEBE[P39_TDD_FIN_BORDERO_RECEBIMENTO]
    PILOTO --> PAGA[P39_TDD_FIN_BORDERO_PAGAMENTO]
    START --> CASOS[P39_TDD_CASOS_DE_TESTE]
    CASOS --> PARAM[P39_TDD_PARAMETROS]
    CASOS --> CACHE[P39_TDD_CACHE]
    CASOS --> CONST[P39_TDD_CONSTANTES]
    PARAM --> JSON[P39_TDD_FUNCOES_JSON]
    RUNNER --> ODBC[P39_TDD_ODBC]
```

## Origem do estado consumido

| Estado/metodo | Origem | Uso no piloto |
| --- | --- | --- |
| FCasoTesteAtualId / FCasoTesteAtualJson | P39_TDD_STARTED | Registro preparado para a tentativa corrente |
| ValorStringTag / ValorInteiroTag / ValorCurrencyTag | P39_TDD_FUNCOES_JSON, via PARAMETRO | Leitura compartilhada de JSON |
| FLogsCasoTeste / RegistrarLogEmModoDebug / DelimitadorLog | P39_TDD_LOGS | Registro de mensagens por tentativa, somente com debug |
| FNomeMetodoAtual | P39_TDD_RUNNER | TEARDOWN permite interromper quando a limpeza financeira falha |
| Forms, DMs e CDS financeiros | ERP, via mapeamentos | Telas encerradas, edições canceladas; datasets compartilhados não são destruídos pelo piloto |

## Nomes locais e externos

P39_TDD_RUNNER, P39_TDD_IRUNNER, P39_TDD_STARTED e P39_TDD_FINISHED estão em `docs/assets/emDesenvolvimento/Runner`. Os mapeamentos preservam os nomes TDD existentes no uses do piloto; os fontes de referência no workspace usam o prefixo P39 em `docs/assets/casosTestesFinanceiro/`. O inventário sintático mantém esses nomes externos separados, sem afirmar identidade entre as variantes.

As dependências P39 globais têm fontes de referência no workspace e são integradas pelo host. O grafo não afirma que o JvInterpreter padrão disponibiliza globais entre units irmãs: essa visibilidade vem da customização do ERP. Nenhum uses redundante foi acrescentado ao piloto.

## Propriedade e limites

ExecutarLote controla carga, cursor e limpeza dos CDS compartilhados. Teste valida o JSON, executa as quatro operações financeiras e chama TearDown_DestruirObjetos em finally. O teardown cancela edições e fecha os quatro formulários financeiros, sem liberar os CDS compartilhados. O pagamento usa MapearComponentesBorderoPagamento e IniciarCDSCadastroBordero existentes, sem chamar CriarObjetos.

Asserts permanecem pendentes; resultados/comparações pertencem a essa etapa. Restauração de parâmetros, conversões JSON no host e comportamento dos mapeamentos sob falhas continuam sem homologação comprovada nesta documentação.

O piloto não depende mais de CDSConfiguracao/CarregarConfiguracoes ou fallbacks: pessoa, valor, grupo de resultado e conta vêm do JSON e geram erro quando ausentes/inválidos/zerados. Qualificação, pessoa da nota de crédito e prazo continuam opcionais. Wrappers locais foram retirados por autorização expressa.

Piloto passa a ter seis procedures. _IncluirBordero(pTipo) centraliza recebimento (0) e pagamento (1), mantendo as operações próprias de cada caminho. Seleção da pessoa está incorporada ao pagamento. Validação do JSON é específica e chamada diretamente por Teste; teardown permanece no final.
