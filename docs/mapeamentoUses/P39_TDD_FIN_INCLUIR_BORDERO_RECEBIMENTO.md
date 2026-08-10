# Mapeamento de Uses - P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO

Diagrama de dependências (`uses`) do caso de teste **Incluir Borderô de
Recebimento**, incluindo a herança transitiva entre as units.

## Diagrama

```mermaid
flowchart LR
    subgraph CASO["Caso de Teste (emDesenvolvimento)"]
        INCLUIR["P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO"]
    end

    subgraph LOCAL["Local (emDesenvolvimento)"]
        CARREGAR["TDD_CARREGAR_CASO_TESTE"]
        MAP_RECEB["TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO"]
    end

    subgraph REMOTO["Remoto (P39_*)"]
        REGISTRAR["P39_TDD_REGISTRAR_CASO_TESTE"]
        FUNCOES_JSON["P39_TDD_FUNCOES_JSON"]
        ODBC["P39_TDD_ODBC"]
        CONSTANTES["P39_TDD_CONSTANTES"]
    end

    INCLUIR --> CARREGAR
    INCLUIR --> MAP_RECEB
    INCLUIR --> FUNCOES_JSON

    CARREGAR --> REGISTRAR
    REGISTRAR --> ODBC
    ODBC --> CONSTANTES
```

## Dependências diretas

| Unit | Purpose |
| ---- | ------- |
| `TDD_CARREGAR_CASO_TESTE` | Carrega o caso de teste do banco e popula o CDS por referência. |
| `TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO` | Mapeia o form `FCadBorderoAcerto` e os CDSs do borderô. |
| `P39_TDD_FUNCOES_JSON` | Leitura de tags do JSON do caso de teste (`ValorInteiroTag`, etc.). |

## Heranças transitivas de uses

- `TDD_CARREGAR_CASO_TESTE` → `P39_TDD_REGISTRAR_CASO_TESTE` → `P39_TDD_ODBC` → `P39_TDD_CONSTANTES`
  - Por isso **não** é necessário declarar `P39_TDD_ODBC` no `uses` da unit principal.
  - `TDDReaderODBC` e `MensagemPersonalizada` ficam disponíveis transitivamente.

## Notas

### Leitura da configuração financeira

- A unit não depende mais de `P39_TDD_FIN_CONFIG_FINANCEIRO` (removida do `uses`).
  O SQL `GetSQLSelectFinanceiroConfig` foi replicado como função local, mantendo a
  leitura de `FINANCEIRO_CONFIGURACAO` via `TDDReaderODBC` e os campos
  `CLIENTE_FINCONFIG`/`CONTA_PRINCIPAL_FINCONFIG`.

### Carregador e versão remota do registro

- `TDD_CARREGAR_CASO_TESTE` usa `P39_TDD_REGISTRAR_CASO_TESTE` (unit global do
  ERP) para `RegistroFallbackModulo`/`RegistroFallbackArea`, com `TDDReaderODBC`
  herdado de `P39_TDD_ODBC`.

### Form real do borderô

O mapeamento `TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO` aponta para o
form **`FCadBorderoAcerto`** / **`DMCadBorderoAcerto`** (Bordero de Acerto),
conforme unit legada localizada localmente.

### Regra de negócio: valor do complemento

- `_IncluiBorderoRecebimento` calcula `VALOR_COMPLBORD` somando `VLREMABERTO` das
  duplicatas a receber em aberto da pessoa (`PESSOA_DUP` do JSON, com fallback
  `CLIENTE_FINCONFIG`).
- Se não houver duplicata em aberto (ou valor zero), o ERP rejeita o gravamento com
  **"O valor do complemento deve ser maior que zero"**.
- O JSON do caso de teste deve apontar (`PESSOA_DUP`) para uma pessoa que possua
  duplicatas a receber em aberto no ERP — normalmente as duplicatas criadas pelo caso
  de teste **CADASTRAR DUPLICATA A RECEBER** executado antes na suíte.
- A unit valida `VlrPagar = 0` e aborta com mensagem acionável antes de chegar à
  regra de negócio do ERP.
