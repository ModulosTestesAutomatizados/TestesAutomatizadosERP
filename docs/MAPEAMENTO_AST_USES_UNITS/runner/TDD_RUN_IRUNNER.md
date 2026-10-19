# Dependencias uses reconciliadas

```mermaid
flowchart LR
  n0["P39_TDD_CACHE"]
  n1["P39_TDD_CASOS_DE_TESTE"]
  n2["P39_TDD_CONSTANTES"]
  n3["P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO"]
  n4["P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO"]
  n5["P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO"]
  n6["P39_TDD_FUNCOES_JSON"]
  n7["P39_TDD_ODBC"]
  n8["P39_TDD_PARAMETRO"]
  n9["P39_TDD_PARAMETRO_MAPEAMENTO"]
  n10["P39_TDD_RUN_APPLICATION"]
  n11["P39_TDD_RUN_ASSERTS"]
  n12["P39_TDD_RUN_VALIDAR_RESULTADO"]
  n13["TDD_FIN_FINANCEIRO"]
  n14["TDD_RUN_APPLICATION_MAPEAMENTO_JSON"]
  n15["TDD_RUN_FINISHED"]
  n16["TDD_RUN_IRUNNER"]
  n17["TDD_RUN_LOGS"]
  n18["TDD_RUN_RUNNER"]
  n19["TDD_RUN_STARTED"]
  n20["TDD_RUN_UNIT_BASE_IRUNNER"]
  n21["__USES_UNITS__"]
  n16 --> n17
  n2 --> n17
  n1 --> n2
  n9 --> n17
  n8 --> n9
  n6 --> n17
  n8 --> n6
  n1 --> n8
  n7 --> n2
  n0 --> n7
  n1 --> n0
  n19 --> n1
  n18 --> n19
  n10 --> n1
  n18 --> n10
  n11 --> n1
  n12 --> n11
  n18 --> n12
  n18 --> n15
  n20 --> n18
  n20 --> n21
  n13 --> n4
  n13 --> n3
  n5 --> n16
  n16 -. CodificacaoUnit .-> n20
  n10 -. CodificacaoUnit .-> n14
```

Setas continuas representam uses; setas pontilhadas representam carga dinamica. Os hashes normalizam somente CRLF/LF. Estado compartilhado e APIs nativas nao sao inferidos como uses.
