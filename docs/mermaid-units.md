# Diagrama Mermaid — Units do Projeto de Testes Automatizados

## Grafo de Dependências (uses)

```mermaid
graph TD
    %% ── NÓS: Arquivos .pas ──────────────────────────────────

    SUB["P39_TDD_INSERIR_UNIT_EXECUTA.pas<br/><i>Insere unit no ERP</i>"]
    VAL["P39_TDD_VALIDAR_GENERICO.pas<br/><i>Validação genérica por tipo</i>"]
    REG["P39_TDD_REGISTRAR_CASO_TESTE_EXECUCAO.pas<br/><i>Registra execução de caso de teste</i>"]
    ODBC["P39_TDD_ODBC.pas<br/><i>Centraliza conexão ODBC 32b</i>"]
    JSON["P39_TDD_FUNCOES_JSON.pas<br/><i>Helper de leitura JSON</i>"]
    MAPE["P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.pas<br/><i>Mapeia componentes do borderô</i>"]
    CONST["P39_TDD_CONSTANTES.pas<br/><i>Constantes, tipos e utils compartilhados</i>"]
    CMP["P39_TDD_COMPARAR_VALOR_REFACTORED.pas<br/><i>Comparação refatorada de valores</i>"]
    ASSERTS["P39_TDD_ASSERTS<br/><i>(não existe no repo — builtin do ERP)</i>"]

    %% ── ARESTAS: dependências declaradas em uses ────────────

    SUB -->|"uses"| ODBC
    SUB -->|"uses"| CONST
    VAL -->|"uses"| CONST
    VAL -->|"uses"| ODBC
    VAL -->|"uses"| JSON
    VAL -->|"uses"| ASSERTS
    REG -->|"uses"| CONST
    REG -->|"uses"| ODBC
    ODBC -->|"uses"| CONST

    %% ── Dependências IMPLÍCITAS (chamadas sem uses) ─────────

    CMP -.->|"chama"| VAL
    CMP -.->|"chama"| JSON
    CMP -.->|"chama"| CONST

    %% ── Estilos ─────────────────────────────────────────────

    classDef core fill:#f0ad4e,stroke:#d9534f,stroke-width:2px,color:#000
    classDef infra fill:#5bc0de,stroke:#31708f,stroke-width:2px,color:#fff
    classDef leaf fill:#5cb85c,stroke:#449d44,stroke-width:2px,color:#fff
    classDef erp  fill:#aaa,stroke:#666,stroke-width:1px,stroke-dasharray:5\,5,color:#000
    classDef implicit fill:#fff,stroke:#f0ad4e,stroke-width:2px,stroke-dasharray:4\,4,color:#000

    class CONST core
    class ODBC,JSON infra
    class SUB,REG,MAPE leaf
    class ASSERTS erp
    class CMP implicit
```

## Legenda

| Cor | Significado |
|-----|-------------|
| **Laranja** | **Camada core** — constantes e tipos usados por todas as units |
| **Azul** | **Infraestrutura** — helpers de conexão e parsing |
| **Verde** | **Units de aplicação** — scripts de inserção, registro e mapeamento |
| **Cinza tracejado** | **Unit ausente** — `P39_TDD_ASSERTS` não existe no repo (builtin do ERP) |
| **Branco laranja tracejado** | **Dependência implícita** — chamadas diretas sem `uses` formal |

---

## Árvore hierárquica de dependências

```mermaid
graph TD
    root["✔ Projeto de Testes Automatizados"]

    root --> L1["Nível 1 — Sem dependências"]
    root --> L2["Nível 2 — Depende só de Nível 1"]
    root --> L3["Nível 3 — Depende de Nível 1+2"]

    L1 --> C["P39_TDD_CONSTANTES"]
    L1 --> J["P39_TDD_FUNCOES_JSON"]
    L1 --> M["P39_TDD_FIN_MAPEAMENTO_...BORDERO"]
    L1 --> A["P39_TDD_ASSERTS (ERP)"]

    L2 --> O["P39_TDD_ODBC"]
    O -->|"uses"| C

    L3 --> S["P39_TDD_INSERIR_UNIT_EXECUTA"]
    L3 --> V["P39_TDD_VALIDAR_GENERICO"]
    L3 --> R["P39_TDD_REGISTRAR_CASO_TESTE_..."]
    L3 --> CP["P39_TDD_COMPARAR_VALOR_REFACTORED"]

    S -->|"uses"| O
    S -->|"uses"| C
    V -->|"uses"| O
    V -->|"uses"| C
    V -->|"uses"| J
    V -->|"uses"| A
    R -->|"uses"| O
    R -->|"uses"| C

    classDef lvl0 fill:#f0ad4e,stroke:#d9534f,color:#000
    classDef lvl1 fill:#fff,stroke:#aaa,color:#333
    classDef lvl2 fill:#5bc0de,stroke:#31708f,color:#fff
    classDef lvl3 fill:#5cb85c,stroke:#449d44,color:#fff

    class root lvl0
    class C,J,M,A lvl1
    class O lvl2
    class S,V,R,CP lvl3
```

---

**Nota:** A unit `P39_TDD_ASSERTS` é referenciada em `uses` da unit `P39_TDD_VALIDAR_GENERICO` mas não possui arquivo `.pas` neste repositório — é provavelmente um módulo embutido no motor de script do ERP.
