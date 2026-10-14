# Responsabilidades do fluxo interpretado

Documentação: Estrutura e fluxo de IRunner.Executar. Este arquivo é a fonte do diagrama exibido pelo portal.

```mermaid
flowchart TD
  IRunner["TDD_IRUNNER: configuração e montagem"] --> Base["BASE_UNIT: Main, ExecutarLote e Run"]
  Base --> Runner["TDD_RUNNER: lote, contexto e cronômetro"]
  Runner --> Casos["CASOS_DE_TESTE: datasets dos casos ativos"]
  Base --> Started["TDD_STARTED: versão, JSON e parâmetros"]
  Started --> Teste["Unit Teste: operações do caso corrente"]
  Teste --> Finished["TDD_FINISHED: histórico e tempos"]
  Logs["TDD_LOGS: mensagens e instruções"] -.-> Base
  Apoio["CACHE, PARAMETRO, ODBC, JSON e CONSTANTES"] -.-> Casos
```
