# Decisão após uma exceção

Documentação: Estrutura e fluxo de IRunner.Executar. Este arquivo é a fonte do diagrama exibido pelo portal.

```mermaid
flowchart TD
  Erro["Exceção dentro de Started ou Teste"] --> Registro["MensagemErro e EtapaFalha"]
  Registro --> Versao{"Status VERSAO_INCOMPATIVEL?"}
  Versao -- Sim --> Preservar["Preservar status"]
  Versao -- Não --> Falha["Status FALHA"]
  Falha --> Inseguro{"STARTED ou TEARDOWN?"}
  Inseguro -- Sim --> Propagar["Propagar erro e interromper lote"]
  Inseguro -- Não --> Continuar["Falha do teste pode continuar"]
  Preservar --> Continuar
  Continuar --> Persistir["Finally: tempos e persistência"]
  Propagar --> Persistir
  Persistir --> Persistencia{"Persistência e fechamento sem erro?"}
  Persistencia -- Não --> Abortar["Erro propagado; limpeza do lote"]
  Persistencia -- Sim --> Decisao{"Havia erro propagado?"}
  Decisao -- Sim --> Abortar
  Decisao -- Não --> Proximo["Próximo caso"]
```
