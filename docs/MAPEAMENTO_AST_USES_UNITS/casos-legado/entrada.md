# Entrada financeira do contrato anterior

Fonte: `docs/assets/casosTestesFinanceiro/processamentos/InclusaoDeDuplicatas.pas`.
As chamadas abaixo pertencem ao processamento; os arquivos locais das units apresentam divergências descritas na documentação.

```mermaid
flowchart TD
  Main[Main] --> Filtro{ConfirmarFiltros}
  Filtro -->|Cancelado| Fim[Fim]
  Filtro -->|Confirmado| Tipo{Tipo de Teste}
  Tipo -->|0| Receber[Duplicata a receber]
  Tipo -->|1| Pagar[Duplicata a pagar]
  Tipo -->|2| Pagamento[Borderô de pagamento]
  Tipo -->|3| Recebimento[Borderô de recebimento]
  Receber --> Fim
  Pagar --> Fim
  Pagamento --> Fim
  Recebimento --> Fim
```
