# Sequência do piloto financeiro

Fonte: `docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas`, procedure `Teste`.
O finally executa a limpeza mesmo quando validação ou operações falham.

```mermaid
flowchart TD
  Teste[Teste] --> Validar[ValidarCasoTeste]
  Validar --> Receber[_IncluirDuplicata: receber]
  Receber --> Pagar[_IncluirDuplicata: pagar]
  Pagar --> Recebimento[_IncluirBordero: recebimento]
  Recebimento --> Pagamento[_IncluirBordero: pagamento]
  Pagamento --> Limpeza[finally: TEARDOWN e TearDown_DestruirObjetos]
  Validar -.->|Erro| Limpeza
  Receber -.->|Erro| Limpeza
  Pagar -.->|Erro| Limpeza
  Recebimento -.->|Erro| Limpeza
  Pagamento -.->|Erro| Limpeza
  Limpeza --> Casca[Retornar ou propagar erro à casca]
```
