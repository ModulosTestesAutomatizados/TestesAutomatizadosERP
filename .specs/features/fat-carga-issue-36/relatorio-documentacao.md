# Relatório da contribuição documental

**Data:** 2026-10-20
**Tarefa:** Documentação dos filtros, logs e sincronização do MVP de CARGA (#36)

## Realização (Interno)

O portal descreve a unit `P39_TDD_FILTROS`, o `SetterFlags` de `P39_TDD_RUN_LOGS` e a segunda pergunta de `FSincRemoto` em `Sincronizar`. A rota canônica `/units/p39-tdd-filtros` corresponde ao fonte Pascal com o mesmo prefixo. Os mapas de `uses` e hashes foram reconciliados. A execução no ERP permanece pendente.

## Fontes modificados

- `Documentacoes/app/components/helpers/gerais/conteudo/p39-tdd-filtros.ts`
- `Documentacoes/app/components/helpers/sincronizacao/conteudo/p39-tdd-sincronizar-casos-teste-registrados.ts`
- `Documentacoes/app/components/helpers/sincronizacao/conteudo/p39-tdd-processamento-sincronizacao.ts`
- `Documentacoes/app/components/units/irunner/conteudo/p39-tdd-run-logs.ts`
- `Documentacoes/app/catalogo/redirecionamentos.ts`
- `docs/MAPEAMENTO_AST_USES_UNITS/runner/`
- `docs/MAPEAMENTO_AST_USES_UNITS/p39-tdd-registrar-caso-teste/`

## p/ teste

1. Abra a documentação local no endereço informado pelo preview.
2. Acesse `#/units/p39-tdd-filtros` e confirme que a página de filtros é exibida.
3. Abra `P39_TDD_RUN_LOGS` no menu Units e confira `FFlagsSetadas` e `SetterFlags`.
4. Abra `P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS` e confira as duas perguntas de sincronização e o registro de CARGA.

## O que há de novo

O portal explica onde cada flag é perguntada e deixa claro que as instruções de uma unit dependem de uma chamada explícita à sua `Main`.
