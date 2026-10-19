# Sincronização da fonte única

```mermaid
flowchart TD
  Registro[RegistrarCasoTeste: modulo, area, descricao, versao, unit e origem] --> Consulta[Consultar existencia]
  Consulta --> Decisao{Atualizacao aceita ou caso novo?}
  Decisao -- Nao --> Pular[Voltar ao proximo registro]
  Decisao -- Sim --> Fonte[Carregar a unica unit JSON do caso]
  Fonte --> Resultado[Resolver resultadoEsperado]
  Fonte --> Campos[Resolver camposDisponiveis]
  Resultado -. ausente .-> MinimoAsserts[P39_TDD_ASSERTS_JSON_MINIMO]
  Campos -. ausente ou vazio .-> MinimoCampos[P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO]
  Resultado --> Validar[Validar e recompor os objetos com suas tags]
  Campos --> Validar
  Validar --> Persistir[Insert ou update parametrizado]
```

resultadoEsperado explicitamente vazio não usa mínimo. parametros ausente não é sintetizado. Os dois mínimos usam suas units remotas também quando a fonte principal é local.
