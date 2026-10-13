# Estado do lote e estado de uma tentativa

Documentação: Estrutura e fluxo de IRunner.Executar. Este arquivo é a fonte do diagrama exibido pelo portal.

```mermaid
flowchart TD
  Configuracao["FTDDUnit e FParamsCasosTeste"] --> Montagem["Executar: montar e interpretar"]
  Montagem --> Lote["Setup: casos, resultados esperados, cache e parâmetros"]
  Lote --> Registro["Registro corrente"]
  Registro --> Reiniciar["SetarCasoTeste: contexto, histórico, método e etapa"]
  Reiniciar --> Limpar["Run: limpar logs e inicializar métricas"]
  Limpar --> Preparar["Started: preencher ID e JSON atuais"]
  Preparar --> Teste["Teste: consumir dados e configuração"]
  Teste --> Snapshot["Fechar tempos e copiar logs para o histórico"]
  Snapshot --> Persistir["Finished: persistir tentativa"]
  Persistir --> Proximo{"Há próximo caso?"}
  Proximo -- Sim --> Registro
  Proximo -- Não --> Teardown["Liberar recursos do lote"]
```
