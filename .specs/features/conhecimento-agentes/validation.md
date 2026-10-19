# Validation: conhecimento-agentes — PASS

**Data:** 2026-10-19. **Range final:** `ab4a2d8..271111a`. **Verificador:** subagente independente, autor ≠ verificador. Escopo médio executado sem tasks.md formal.

Sete ACs aprovados após corrigir KNOW-03 em 271111a. Rechecagem delimitada confirmou a normalização dos metadados antes da serialização e executou as regressões CRLF/LF. Nenhum código real foi alterado pelo verificador. O histórico da falha inicial está preservado abaixo.

## Matriz de aceitação

| AC | Resultado esperado | Evidência concreta | Resultado |
| --- | --- | --- | --- |
| KNOW-01 | Build gera llms, JSON e Markdown por documento público a partir das fontes validadas | `Documentacoes/config/portal-assets.ts:71` chama prepararAssets e gerarConhecimento; `Documentacoes/tools/vite-migration/knowledge-http.mjs:10` compara quantidade com catálogo público; linhas 11 e 15 verificam llms e Markdown HTTP 200. 28 documentos servidos. | PASS |
| KNOW-02 | Todos os blocos, códigos literais, Mermaid, fontes e links preservados | `Documentacoes/config/knowledge.ts:40` a 53 cobre os sete tipos; `Documentacoes/tools/vite-migration/knowledge.mjs:20` exige literal e cerca ampliada; linhas 21–24 exigem pipe escapado, Mermaid, link, aviso e lista. Código não passa pelo resolvedor textual (knowledge.ts:47). Fontes em knowledge.ts:73. | PASS |
| KNOW-03 | Índice completo e versão igual para conteúdo equivalente | `Documentacoes/tools/vite-migration/knowledge.mjs:11` a 18 e 38 verificam schema, assinatura, aliases, navegação, estado, fontes e evidência; linhas 27/29/40 verificam determinismo e alteração substantiva; linhas 33 e 35 exigem versões iguais com CRLF/LF em resumo, assinatura e assets. `Documentacoes/config/knowledge.ts:107` normaliza strings recursivamente antes de stringify somente para hashing. Fixture atual executada pelo verificador, exit 0. | PASS |
| KNOW-04 | Inclusão/atualização/ocultação acompanha catálogo com base Pages válida | `Documentacoes/tools/vite-migration/knowledge.mjs:25` exclui segredo oculto em todas as saídas; linha 26 não cria link oculto; linhas 29/40/42 cobrem atualização e inclusão. `knowledge-http.mjs:18` valida âncoras e linha 21 exige HTTP 200 para 73 links locais sob a base. | PASS |
| KNOW-05 | Asset necessário ausente falha; gates/fontes preservados; sem backend/dependências | `Documentacoes/tools/vite-migration/knowledge.mjs:43` exige erro Asset canônico ausente; `Documentacoes/config/portal-assets.ts:31` valida catálogo e linha 58 verifica hashes canônicos. Inspeção do diff: sem mudanças em docs/assets, docs/MAPEAMENTO_AST_USES_UNITS ou package-lock; package.json só amplia lint para config. Assets emitidos vêm do Map preparado explicitamente (portal-assets.ts:93), sem cópia recursiva de árvore privada. | PASS |
| KNOW-06 | Skill/guia orientam consulta por unit/estado/método, fontes e evidência ERP | `.agents/skills/consultar-documentacao-tdd/SKILL.md:12` orienta saída local; linhas 20–24 descrevem busca/dono/URLs; linhas 32–34 delimitam ERP e exigem citação. `Documentacoes/app/components/contribuir/conteudo/agentes.ts:19` contém campos e linha 41 preserva limite ERP. Forward-test abaixo localizou os dois símbolos corretamente. | PASS |
| KNOW-07 | check/build, exportação/HTTP e revisão independente, tools ignorados | check/build, knowledge.mjs e knowledge-http.mjs terminaram com exit 0; git check-ignore confirma ambos ignorados. Sensor morto e revisão presente. | PASS |

## Gates e integridade

- `npm run check --prefix Documentacoes; if ($LASTEXITCODE -eq 0) { npm run build --prefix Documentacoes }`: exit 0. Lint/typecheck passaram; build transformou 2472 módulos e terminou em 19,09 s.
- `node Documentacoes/tools/vite-migration/knowledge.mjs`: exit 0.
- `node Documentacoes/tools/vite-migration/knowledge-http.mjs`: exit 0; 28 Markdown, 73 links locais, âncoras, JSON e MIME corretos; preview próprio encerrado pelo teste.
- quick_validate.py com `python -X utf8` e PyYAML local: ambas as skills válidas.
- Rechecagem final: diff 9548f92..271111a altera somente a preparação do hash no código de produção; códigos e saídas continuam usando os valores originais. Verificador executou novamente knowledge.mjs, exit 0, incluindo as duas novas asserções CRLF/LF. Orquestrador informou fixture/check/build/HTTP finais com exit 0 (sessão 24712; 28 documentos/73 links). Gates amplos não repetidos pelo verificador nesta rechecagem restrita.
- Testes proporcionais: dois scripts de cenários e HTTP parametrizado. Nenhum teste versionado foi removido/enfraquecido no range; scripts ignorados não têm baseline histórico versionado para comparar contagem. Sem skips internos observados. Asset-gate/git-index-paths não repetidos: já aprovados e escopo canônico sem diff.

## Sensor de discriminação

Uma mutação comportamental em cópia ignorada: `knowledge.ts:24`, filtro `!pDoc.oculto` invertido para `pDoc.oculto`. Cópia da fixture apontou para cópia do módulo com imports ajustados; nenhuma asserção alterada. Teste falhou com exit 1 em `knowledge.mjs:12`: recebeu tdd-oculto.md em vez de tdd-exemplo.md. **1 injetada, 1 morta, 0 sobreviventes.** Cópias descartadas com caminhos absolutos conferidos. `git status --porcelain` vazio antes e depois do sensor, igualdade True. Nenhuma branch/worktree/stash/remoto alterada.

Sensor preservado na rechecagem: o filtro e a projeção pública não mudaram no fix. A fixture final mantém as asserções de exclusão. Árvore limpa no início da rechecagem; somente este relatório foi atualizado.

## Histórico da falha inicial e resolução

**Primeiro parecer: FAIL, KNOW-03, em 9548f92.** Reprodução read-only usando gerarConhecimento, mesmo documento mínimo e mesmos assets/base, variando somente `resumo: 'a\nb'` para `resumo: 'a\r\nb'`:

- LF: `fbac26413a8d4b89b523d7e19d559015677d36171316c0473c63fbb6af20149f`.
- CRLF: `5c461a303e8446182070982dc0f8ef20714bdce830e02b2f280876d0c2c859b9`.

JSON.stringify convertia as quebras em escapes antes da normalização dos buffers. Resolvido pelo autor em 271111a: replacer normaliza strings antes de serializar os metadados do hash (knowledge.ts:107), sem alterar registros/Markdown exportados. Regressões knowledge.mjs:33 e :35 aprovadas pelo verificador; alteração substantiva continua mudando a versão (:29 e :40). O autor relatou regressão vermelha antes e verde após o fix. Lição L-002 registrada pelo orquestrador, sem duplicação nesta revisão. Nenhum gap pendente.

## Forward-test da skill

Segui somente a skill e a saída atual: procurei documentos.simbolos no índice, identifiquei o dono e li o Markdown correspondente. **Resposta derivada:** FModoDebug pertence a **TDD_RUN_LOGS**. A assinatura é `procedure RegistrarLog(pLog :string);`. RegistrarLog cria FLogsCasoTeste quando necessário e sempre acrescenta `pLog + #13`; se FModoDebug estiver ativo, também chama MostrarLogTexto com `[DEBUG]`. O debug controla a exibição. Fontes: `Documentacoes/.pages-output/knowledge/units/tdd-run-logs.md:31`, `:70`, `:93`; código indicado no índice: `docs/assets/emDesenvolvimento/Runner/TDD_RUN_LOGS.pas:42` a 50, conferido em leitura.

Consulta original em HEAD9548f92, schemaVersion 1, contentVersion `0029437da3bb7198b3fa10ae23add3f95d39fa3b782992cc51ef971a4e41f7e0`, também presente na saída final conferida em 271111a. Estado **em-desenvolvimento**, sem evidenciaValidacao no registro. Limites documentados (Markdown:110 e :112): ponteiro liberado sem nil limita reexecução e ainda existem chamadas antigas a RegistrarLogEmModoDebug. Fonte/documentação local não comprova cadastro remoto, compilação conjunta ou homologação ERP. A skill conduz corretamente à consulta e preserva esses limites. Forward-test não repetido: skill e contrato de LOGS não mudaram.

## Qualidade e limites

Mudanças cirúrgicas, estilo compatível, projeção única e sem backend, novas dependências ou alteração Pascal. Testes mapeiam ACs/edge cases (cercas, pipes, acentos, aliases, ocultos, asset ausente, base e atualização sem alterar quantidade); a regressão acrescentada cobre equivalência CRLF/LF dos metadados e assets. Nenhuma precisão adicional da spec foi inventada: a equivalência é explicitada no guia/skill da própria entrega. Sem suíte por página, UAT visual, publicação remota ou homologação ERP. Resultado local independe de Linux/Actions.

**Conclusão:** PASS; sete ACs aprovados, sem gaps pendentes. A rejeição inicial de validate_state foi preservada como histórico; a checagem final retornou exit 0 e zero erros. Somente este relatório foi escrito pelo verificador. Lição L-002 já registrada pelo orquestrador.
