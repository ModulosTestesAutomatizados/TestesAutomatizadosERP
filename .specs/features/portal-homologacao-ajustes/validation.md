# Validation: portal-homologacao-ajustes — PASS

**Date**: 2026-10-14
**Spec**: `.specs/features/portal-homologacao-ajustes/spec.md`
**Diff range**: `43a8958..b0a7ccd`
**Verifier**: agente independente `/root/verificar_homologacao` (autor diferente do revisor). Revisão proporcional aos quatro ajustes documentais, sem alterações de implementação ou testes.

## Critérios e evidências

| Critério | Resultado esperado e evidência | Resultado |
| --- | --- | --- |
| PREVIEW-01 | Fundo `rgb(71 85 105 / 48%)`, spinner opaco e mensagem legível. `Documentacoes/app/styles/portal.css:8` define alpha no fundo, sem opacity no contêiner; linha 9 mantém fundo branco da mensagem. `Documentacoes/tools/portal-iteration/browser-homologacao.mjs:39` compara a cor computada com `rgba(71, 85, 105, 0.48)` e linha 40 compara opacity do spinner com `1`; linhas 57–60 verificam erro e foco. | PASS |
| PREVIEW-02 | Contexto vem dos títulos do registro e tipo explícito Unit/Processamento. `Documentacoes/app/navigation.ts:13` resolve grupo/subgrupo; `Documentacoes/app/components/RedirectCard.ts:18` usa esse contexto e linha 23 usa tipoArtefato. `Documentacoes/app/content/units/criarDocumentoUnit.ts:10` define padrão unit, e os dois documentos de processamento declaram processamento na linha 4. `Documentacoes/tools/portal-iteration/check-homologacao.mjs:13` compara exatamente os dois processamentos; linhas 14–15 e 20 comparam os três contextos. `Documentacoes/tools/portal-iteration/browser-homologacao.mjs:46` e linhas 48–51 confirmam contexto e chips renderizados. | PASS |
| PREVIEW-03 | Nomes finais literais P39_TDD_FIN_MAPEAMENTO_BORDERO_PAGAMENTO e P39_TDD_FIN_MAPEAMENTO_BORDERO_RECEBIMENTO em arquivo, título, unit, rota e inventário. `Documentacoes/tools/portal-iteration/check-homologacao.mjs:19` compara titulo/unit/slug com os nomes esperados; linhas 22–23 rejeitam nomes intermediários e conferem basename Pascal; linhas 26 e 31 comparam conteúdo com 43a8958 normalizando CRLF/LF e permitindo somente a troca dos nomes no consumidor; linhas 54–55 conferem o AST canônico. `docs/assets/emDesenvolvimento/P39_TDD_FIN_PAGAMENTO_RECEBIMENTO.pas:1` e linha 2 referenciam os dois nomes finais. | PASS |
| PREVIEW-04 | Guia contém 11 renomeações cumulativas, uses locais, carregamentos por nome separados, diagrama canônico e ressalva local. `Documentacoes/app/content/guias/autoria.ts:140` contém a seção; linha 146 delimita o alcance; linha 219 aponta para Mermaid canônico. `Documentacoes/tools/portal-iteration/check-homologacao.mjs:35` compara 11 linhas, linha 49 compara integralmente nomes/consumidores, linhas 51–52 verificam CodificacaoUnit e SetTDDUnit, linha 56 confere fonte canônica. `Documentacoes/tools/portal-iteration/browser-homologacao.mjs:133` verifica as 11 linhas renderizadas e linhas 134–135 verificam SVG e link final. `docs/MAPEAMENTO_AST_USES_UNITS/autoria/impacto-renomeacao.md:7` inicia as 15 arestas de uses. | PASS |

Revisão adicional independente, sem novo arquivo de teste: leitura dos 80 Pascal locais, descartando comentários e strings antes de extrair uses, confirmou exatamente todos os consumidores das 11 linhas. Os 11 nomes anteriores existem na árvore `4f0a17b`; os finais existem na árvore atual. Referências dinâmicas confirmadas diretamente em `docs/assets/emDesenvolvimento/Runner/P39_TDD_IRUNNER.pas:64` e `docs/assets/emDesenvolvimento/Runner/P39_TDD_FIN_PROCESSAMENTO.pas:27`. Nenhuma lacuna de precisão nos quatro critérios.

## Gates executados

Todos executados nesta revisão, sequencialmente, com exit 0:

- `npm run check --prefix Documentacoes`: ESLint, templates e TypeScript.
- `npm run build --prefix Documentacoes`: 24 documentos compilados.
- `node Documentacoes/tools/portal-iteration/check-homologacao.mjs`: classificação, identidades, preservação de lógica Pascal, 11 renomeações e referências.
- `node Documentacoes/tools/portal-iteration/snippets.mjs`: 22 snippets e modelos página/unit compilados em strict.
- `node Documentacoes/tools/portal-iteration/browser-homologacao.mjs final`: loading, erro, timeout, cards, rolagem, rotas, mobile, tabela e Mermaid.

Não houve teste removido, assert enfraquecido ou alteração dos verificadores pelo revisor. Não existe contagem histórica consolidada de casos/asserts; foram conferidos o catálogo de 24 documentos e os 22 snippets, sem inventar total de testes. Os testes existentes foram reutilizados; nenhum teste pesado foi acrescentado.

## Sensor de discriminação

Uma mutação comportamental leve em cópia temporária ignorada de `Documentacoes/.build/navigation.js`, com imports reescritos para URLs absolutas. O checker existente foi copiado e apontado para a cópia; o controle passou (exit 0). Em seguida foi removido o subgrupo do retorno de contextoDocumento: retorno `Units` em vez de `Units / IRunner`. O mesmo assert de `Documentacoes/tools/portal-iteration/check-homologacao.mjs:14` rejeitou a cópia (exit 1, ERR_ASSERTION). **1 mutação, 1 eliminada, 0 sobreviventes.**

A cópia temporária foi descartada após verificar que seu caminho permanecia dentro de `Documentacoes/tools/portal-iteration`. O código real não recebeu a mutação. Porcelain capturado imediatamente antes e depois do sensor, idêntico byte a byte:

```text
?? .specs/features/portal-homologacao-ajustes/relatorio-servico.md
```

O relatório de serviço foi criado pelo orquestrador antes do sensor. O porcelain inicial desta revisão estava limpo; essa mudança concorrente foi reconhecida no baseline do sensor. Este validation.md foi criado somente depois da comparação.

## Qualidade e limites

Diff restrito aos ajustes pedidos e seus consumidores documentais; alterações de código pequenas e coerentes com catálogo/navegação existentes. Nenhuma nova abstração ou flexibilidade além do metadado explícito necessário. Casos de erro e timeout do loader, movimento reduzido, nomes intermediários rejeitados e acesso mobile já foram exercitados pelos verificadores existentes.

Verificação limitada a fontes locais e portal compilado. Não houve consulta/alteração no ERP ou TekStore, execução Pascal, migração mutante real, novo worktree, branch, stash, commit ou push. O navegador usa distribuições locais das mesmas versões fixadas para servir as dependências do CDN; disponibilidade externa do CDN não foi homologada. Não houve UAT humano nesta revisão. Sem falhas fundamentadas a registrar como lições e sem correções pendentes.

**Result**: PASS — 4/4 critérios, cinco comandos de gate aprovados e sensor isolado eliminado.
