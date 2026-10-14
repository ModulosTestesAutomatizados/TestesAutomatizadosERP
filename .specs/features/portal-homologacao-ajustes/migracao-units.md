# Renomeações locais e impacto no TDD

Escopo: fontes locais de `docs/assets`, sem consulta ou alteração ERP/TekStore. As referências já estão corrigidas neste repositório. Confira os cadastros reais; não repita trocas onde o nome final já está correto.

## Onze units renomeadas

| Nome anterior | Nome final | Consumidores em uses |
| --- | --- | --- |
| TDD_IRUNNER | P39_TDD_IRUNNER | P39_TDD_FIN_PROCESSAMENTO |
| TDD_BASE_UNIT_IRUNNER | P39_TDD_BASE_UNIT_IRUNNER | Nenhum uses direto encontrado nos fontes locais. |
| TDD_RUNNER | P39_TDD_RUNNER | EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR; P39_TDD_BASE_UNIT_IRUNNER |
| TDD_STARTED | P39_TDD_STARTED | P39_TDD_RUNNER |
| TDD_FINISHED | P39_TDD_FINISHED | P39_TDD_RUNNER |
| TDD_LOGS | P39_TDD_LOGS | P39_TDD_CONSTANTES; P39_TDD_FUNCOES_JSON; P39_TDD_IRUNNER; P39_TDD_PARAMETRO_MAPEAMENTO; P39_TDD_PROCESSAMENTO_SINCRONIZACAO; P39_TDD_RUNNER |
| P39_TDD_PARAMETRO | P39_TDD_PARAMETROS | P39_TDD_CASOS_DE_TESTE |
| P39_PROCESSAMENTO_TDD_FINANCEIRO | P39_TDD_FIN_PROCESSAMENTO | Nenhum uses direto encontrado nos fontes locais. |
| REFACTOR_TDD_FINANCEIRO_PILOTO | P39_TDD_FIN_PAGAMENTO_RECEBIMENTO | EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR |
| P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO | P39_TDD_FIN_MAPEAMENTO_BORDERO_PAGAMENTO | P39_TDD_FIN_PAGAMENTO_RECEBIMENTO |
| P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO | P39_TDD_FIN_MAPEAMENTO_BORDERO_RECEBIMENTO | P39_TDD_FIN_PAGAMENTO_RECEBIMENTO |

Os nomes intermediários P39_TDD_FIN_BORDERO_PAGAMENTO/RECEBIMENTO do primeiro preview também passam aos nomes finais com FIN_MAPEAMENTO_.

## Referências por nome fora de uses

| Consumidor | Tipo | Nome esperado | Ação |
| --- | --- | --- | --- |
| P39_TDD_IRUNNER | CodificacaoUnit | P39_TDD_BASE_UNIT_IRUNNER | Atualizar o nome cadastrado do molde; não aparece em uses. |
| P39_TDD_FIN_PROCESSAMENTO | SetTDDUnit | P39_TDD_FIN_PAGAMENTO_RECEBIMENTO | Atualizar a seleção por string do cenário financeiro. |
| EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR | Exemplo de código gerado | P39_TDD_BASE_UNIT_IRUNNER / P39_TDD_RUNNER / P39_TDD_FIN_PAGAMENTO_RECEBIMENTO | Revisar declaração unit, uses e qualificações do exemplo. Não é um caso novo para cadastrar. |

## Pontos exatos nos fontes locais

- [EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR](../../../../docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas): linha 3, `uses P39_TDD_FIN_PAGAMENTO_RECEBIMENTO`.
- [EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR](../../../../docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas): linha 3, `uses P39_TDD_RUNNER`.
- [P39_TDD_BASE_UNIT_IRUNNER](../../../../docs/assets/emDesenvolvimento/Runner/P39_TDD_BASE_UNIT_IRUNNER.pas): linha 3, `uses P39_TDD_RUNNER`.
- [P39_TDD_CASOS_DE_TESTE](../../../../docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas): linha 1, `uses P39_TDD_PARAMETROS`.
- [P39_TDD_CONSTANTES](../../../../docs/assets/configuracoesGerais/P39_TDD_CONSTANTES.pas): linha 1, `uses P39_TDD_LOGS`.
- [P39_TDD_FIN_PAGAMENTO_RECEBIMENTO](../../../../docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas): linha 2, `uses P39_TDD_FIN_MAPEAMENTO_BORDERO_PAGAMENTO`.
- [P39_TDD_FIN_PAGAMENTO_RECEBIMENTO](../../../../docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas): linha 1, `uses P39_TDD_FIN_MAPEAMENTO_BORDERO_RECEBIMENTO`.
- [P39_TDD_FIN_PROCESSAMENTO](../../../../docs/assets/emDesenvolvimento/Runner/P39_TDD_FIN_PROCESSAMENTO.pas): linha 3, `uses P39_TDD_IRUNNER`.
- [P39_TDD_FUNCOES_JSON](../../../../docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas): linha 1, `uses P39_TDD_LOGS`.
- [P39_TDD_IRUNNER](../../../../docs/assets/emDesenvolvimento/Runner/P39_TDD_IRUNNER.pas): linha 1, `uses P39_TDD_LOGS`.
- [P39_TDD_PARAMETRO_MAPEAMENTO](../../../../docs/assets/configuracoesGerais/manipulacaoParametros/P39_TDD_PARAMETRO_MAPEAMENTO.pas): linha 1, `uses P39_TDD_LOGS`.
- [P39_TDD_PROCESSAMENTO_SINCRONIZACAO](../../../../docs/assets/configuracoesGerais/Sincronizar/P39_TDD_PROCESSAMENTO_SINCRONIZACAO.pas): linha 3, `uses P39_TDD_LOGS`.
- [P39_TDD_RUNNER](../../../../docs/assets/emDesenvolvimento/Runner/P39_TDD_RUNNER.pas): linha 1, `uses P39_TDD_FINISHED`.
- [P39_TDD_RUNNER](../../../../docs/assets/emDesenvolvimento/Runner/P39_TDD_RUNNER.pas): linha 1, `uses P39_TDD_LOGS`.
- [P39_TDD_RUNNER](../../../../docs/assets/emDesenvolvimento/Runner/P39_TDD_RUNNER.pas): linha 1, `uses P39_TDD_STARTED`.

As duas units de registro/sincronização foram movidas sem renomear. O processamento de sincronização é novo; não integra a contagem de onze.

Mermaid canônico: `docs/MAPEAMENTO_AST_USES_UNITS/autoria/impacto-renomeacao.md`. O guia Contribuir expõe as mesmas tabelas e o diagrama.
