# Validação do portal: PASS

**Verdict**: PASS
**Data**: 2026-10-14.
**Spec**: `.specs/features/portal-navegacao-sincronizacao/spec.md`.
**Diff range**: `4f0a17bad6b0d3be1f62c8fdbb6407d2cc55c107..f3d9f1a`.
**Verifier**: subagente independente, sem autoria da implementação ou dos testes existentes.

Os 31 critérios foram confrontados com seus resultados esperados. O portal final contém 24 documentos, incluindo 22 units. Não há gap funcional pendente identificado. A revisão combina asserções executadas e inspeção documental; não representa 31 testes automatizados independentes nem homologação do Pascal.

## Tarefas e escopo

T1–T7 estão concluídas em `tasks.md`. A correção adicional T8 removeu palavras de mensagens Pascal indevidamente tratadas como dependências no inventário AST. A regressão local correspondente passou no HEAD final. O resultado real é 18 nós (17 locais e um marcador dinâmico) e 21 arestas.

Nenhuma implementação ou teste existente foi alterado pelo verificador. Foram produzidos este relatório e um pequeno verificador local ignorado. Não foram criados branches, worktrees, stash ou commits; não houve operações remotas.

## Evidência por critério

Nas referências abaixo, `tools/` significa `Documentacoes/tools/portal-iteration/`, `units/` significa `Documentacoes/app/content/units/` e `Sincronizar/` significa `docs/assets/configuracoesGerais/Sincronizar/`. Os caminhos abreviados são relativos à raiz do repositório. As ferramentas são locais e ignoradas, por decisão do usuário.

| AC | Resultado esperado e evidência verificada | Resultado |
| --- | --- | --- |
| PORTAL-01 | Overlay antes das bibliotecas. `tools/browser.mjs:37`: `loading.rect.width === 1280` e `height === 800`, com Vue deliberadamente retido nas linhas 30–33. `Documentacoes/config/build.mjs:54` gera o overlay diretamente no HTML. | PASS |
| PORTAL-02 | Indicador com nome acessível. `tools/browser.mjs:38`: `role === 'status'`, `label === 'Carregando documentação'`, `inert === true`; spinner aguardado na linha 35. | PASS |
| PORTAL-03 | Conteúdo liberado após montagem/rota. `tools/browser.mjs:40`: aguarda `#portal-ready`; linha 41 aguarda overlay detached; linha 42 exige ausência de inert. `Documentacoes/app/main.ts:15` aguarda `router.isReady()` antes de mount e nextTick. | PASS |
| PORTAL-04 | Falha e timeout de script CDN com recarga. `tools/browser.mjs:48`: `role === 'alert'`; linha 49 compara mensagem exata; linha 50 exige zero spinners; linha 51 exige foco no botão. Linhas 54–59 avançam relógio em 20001 ms com script pendente e aguardam o botão. `Documentacoes/app/start.ts:6`: timeout de 20000 ms. | PASS |
| PORTAL-05 | Movimento reduzido sem animação contínua. `tools/browser.mjs:16` ativa reducedMotion; linha 38 exige `animation === 'none'`. `Documentacoes/app/styles/portal.css:134`: `.portal-spinner { animation: none; }`; borda e nome acessível permanecem. | PASS |
| PORTAL-06 | Árvore e ordem do mapa. `tools/check.mjs:14`: deepEqual dos seis títulos; linhas 15 e 22–25 conferem subgrupos e ordem das units; linha 42 confere os três helpers. Inspeção de `Documentacoes/app/content/navegacao.ts:2` e catálogo confirma Financeiro, Gerais, Arquitetura/IRunner.Executar e Contribuir/guia. | PASS |
| PORTAL-07 | Uma posição por documento. `tools/check.mjs:27`: `flattened.length === docs.length`; linha 28: `new Set(slug).size === docs.length`; linha 29 exige ausência de ocultos. | PASS |
| PORTAL-08 | Nome único no menu, página e rota. `tools/check.mjs:31`: `titulo === unit`; linha 32: slug igual ao nome em minúsculas com hífens; linha 33: fonte termina em `/${unit}.pas`. `Documentacoes/app/components/NavigationGroup.ts:39` usa `doc.titulo`. | PASS |
| PORTAL-09 | Rota direta expande ancestrais. `tools/browser.mjs:64` abre hash profundo; linha 67 exige item visível. `Documentacoes/app/components/AppLayout.ts:14`: `abertos = ref(gruposDaRota(grupos, route.path))`, com atualização por watch. | PASS |
| PORTAL-10 | Páginas e compatibilidade excluídas. `tools/check.mjs:36` exige ausência dos slugs removidos; linhas 37–38 exigem ausência do diretório de redirecionamentos e saída antiga. Diff confirma exclusão dos módulos, HTMLs e manifesto. | PASS |
| PORTAL-11 | Três páginas individuais no grupo correto. `tools/check.mjs:40`: 24 documentos; linha 42: deepEqual da lista de helpers; linhas 48–51 conferem fontes, rotas e métodos individuais. | PASS |
| PORTAL-12 | Contratos fiéis a cada fonte, por inspeção. `units/p39-tdd-registrar-caso-teste.ts:8` a 32 contém responsabilidade, problema, estado, nove assinaturas, dependências e limites; corresponde a `Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas:1` a 293. `units/p39-tdd-sincronizar-casos-teste-registrados.ts:8` a 27 corresponde ao fonte de 47 linhas. `units/p39-tdd-processamento-sincronizacao.ts:8` a 20 corresponde ao fonte de 13 linhas. As assinaturas, sequência e efeitos foram comparados; não se inferiu execução. | PASS |
| PORTAL-13 | Propriedade dos estados distinguida. `units/p39-tdd-registrar-caso-teste.ts:11`: `FCasoTeste: TCasoTeste`; sincronizador editorial linha 11 declara FSincRemoto e ausência de inicialização explícita; processamento editorial linha 14 explicita ausência de globais próprios. Correspondem a `var FCasoTeste`, `var FSincRemoto` e `FSincRemoto := True` nos respectivos fontes. `tools/check.mjs:53` exige que processamento não declare símbolo FSincRemoto. | PASS |
| PORTAL-14 | Local/remoto, `{}`, módulo/área, insert e confirmação de update. Inspeção de `units/p39-tdd-registrar-caso-teste.ts:15` a 22: fallback, prefixo, chave de busca, `mrYes`, parametrização e RETURNING. No Pascal, `CarregarConteudoUnit` inicia `Result := '{}'`, retorna para nome vazio, prefixa quando remoto e silencia exceção; `SincronizarCasoTeste` distingue código positivo; update está dentro de `if lRespostaUsuario = mrYes then`; módulo/área usam fallback ativo. Também documenta cancelamento sem rollback. | PASS |
| PORTAL-15 | Busca encontra cada dono dos seis símbolos. `tools/check.mjs:44` fixa mapa símbolo → unit; linha 45 exige simultaneamente `r.documento.unit === name` e símbolo com `s.nome === symbol`. | PASS |
| PORTAL-16 | Citações resolvem as três páginas. `tools/check.mjs:49`: `rotaUnit(name) === /units/${d.slug}`; linha 50 exige parte de referência reconhecida como unit. `Documentacoes/app/components/ReferenceText.ts` reutiliza essa resolução. | PASS |
| PORTAL-17 | Uma linha, ellipsis e sem overflow horizontal. `tools/browser.mjs:74` e seguintes exigem `whiteSpace === 'nowrap'`, `textOverflow === 'ellipsis'`, `overflow === 'hidden'`; no bloco mobile exige `drawer.scrollWidth <= clientWidth` e página sem overflow. Captura de 360 px inspecionada. | PASS |
| PORTAL-18 | Rótulo completo por hover e foco. `tools/browser.mjs:68` itera `['hover','focus']`; linha 70 aguarda tooltip com nome completo. | PASS |
| PORTAL-19 | 48 px mais safe area. `tools/browser.mjs:76` exige `paddingBottom >= 48`; `Documentacoes/app/styles/portal.css:19` contém `calc(48px + env(safe-area-inset-bottom, 0px))`. Árvore é expandida no teste de scroll. | PASS |
| PORTAL-20 | Barras ocultas em todos os contêineres. `Documentacoes/app/styles/portal.css:4` e 5 aplicam `scrollbar-width: none` e pseudo WebKit globalmente; `tools/browser.mjs:85` a 87 exige computed scrollbarWidth `none` em html, drawer, pre e tabela. Inspeção confirma aplicação também a busca, sumário e diagrama. | PASS |
| PORTAL-21 | Rolagem pertinente preservada. `tools/browser.mjs:90` e seguintes prova ArrowRight no terminal, wheel na página, PageDown e wheel no drawer expandido e ArrowRight na tabela estreita. `Documentacoes/app/styles/portal.css:47`, 66, 85 e 97 mantêm overflow auto nos demais contêineres. Não há handlers cancelando gestos de scroll. Ver limites de dispositivos abaixo. | PASS |
| PORTAL-22 | Registros reutilizáveis. Inspeção de `Documentacoes/app/content/navegacao.ts:2`: GRUPOS_NAVEGACAO; `Documentacoes/app/navigation.ts:14`: filtra catálogo por grupo/subgrupo e ordena por `navegacao.ordem`; AppLayout deriva a árvore desse registro. Não foi introduzida lista paralela específica de página. | PASS |
| PORTAL-23 | Guia/snippets com cadastro e identidade únicos. `tools/snippets.mjs:23` a 28 exige nome `P39_TDD_NOVA_UNIT`, fonte correspondente, ausência de aliases e grupo casos; linhas 33–36 rejeitam instruções obsoletas. Expansões de página/unit compiladas em strict. Guia e snippets inspecionados para prefixo e módulo. | PASS |
| PORTAL-24 | Capitalização correta para o build. `tools/check.mjs:48` exige prefixo exato `docs/assets/configuracoesGerais/Sincronizar/`; `tools/verifier-audit.mjs:6` exige `tracked.has(source.caminho)` com comparação sensível a maiúsculas contra git ls-files. Build verifica acesso a cada fonte. Não foi executado GitHub Actions/Linux. | PASS |
| PORTAL-25 | Entrada e hash profundo sob Pages. `tools/browser.mjs:12` usa URL com `/TestesAutomatizadosERP/`; linhas 64–67 abrem documento diretamente; navegação subsequente atravessa rotas antigas e atuais sem backend. Teste final passa e exige zero pageerrors. | PASS |
| PORTAL-26 | Arquivos e identidades migrados. `tools/migrate.py:35` calcula destino pela tabela aprovada; linhas 37–40 exigem destino, conteúdo esperado e ausência do nome antigo. `tools/check.mjs:31` a 33 confere identidade editorial e fonte. | PASS |
| PORTAL-27 | Referências estáticas/dinâmicas coerentes. `tools/migrate.py:38` compara bytes do baseline após substituições de nomes de tokens; linha 43 exige `SetTDDUnit('P39_TDD_FIN_PAGAMENTO_RECEBIMENTO')`; linha 45 exige `CodificacaoUnit('P39_TDD_BASE_UNIT_IRUNNER')`. Diff Pascal inspecionado para nomes e qualificações. | PASS |
| PORTAL-28 | Paths, citações, slugs, inventário/hash e diagramas. `tools/check.mjs:12` e 13 rejeitam nós espúrios e exigem apenas P39_TDD_LOGS no uses real de IRunner; linhas 31–33 conferem slugs/fontes. `Documentacoes/config/build.mjs:27` recalcula SHA-256 normalizado e linha 28 rejeita divergência. `tools/verifier-audit.mjs:9` exige 18 nós/21 arestas. Inventário e Mermaid canônicos finais inspecionados. | PASS |
| PORTAL-29 | Endereços retirados mostram não encontrado. `tools/browser.mjs:78` e seguintes visita slugs de páginas antigas e units renomeadas e aguarda heading `Documentação não encontrada`; `tools/check.mjs:36` exclui slugs do catálogo; router mantém fallback de não encontrado. | PASS |
| PORTAL-30 | Lógica Pascal preservada. `tools/migrate.py:38`: comparação integral de bytes após somente renomeação aprovada e normalização CRLF/LF; resultado: 21 fontes alcançados. O baseline local contém as alterações Pascal fornecidas pelo usuário antes desta tarefa, não o antigo conteúdo removido. | PASS |
| PORTAL-31 | Aviso de cadastro externo. `tools/snippets.mjs:33`: `guide.includes('atualize os nomes cadastrados no ERP e na TekStore')`; guia informa fazê-lo antes de executar. Nenhum cadastro foi modificado. | PASS |

## Gates executados

| Comando | Resultado |
| --- | --- |
| `npm run check --prefix Documentacoes` | PASS, exit 0: ESLint, validação de templates e TypeScript. |
| `npm run build --prefix Documentacoes` | PASS, exit 0: 24 documentos. Correção AST posterior não altera código compilado; build também foi executado pelo autor no HEAD T8. |
| `python Documentacoes/tools/portal-iteration/migrate.py --check` | PASS, exit 0: 21 fontes, nomes dinâmicos e conteúdo preservados. |
| `node Documentacoes/tools/portal-iteration/check.mjs final` | PASS, exit 0 no HEAD final, incluindo regressão AST T8. |
| `node Documentacoes/tools/portal-iteration/snippets.mjs` | PASS, exit 0: inventário de 22 snippets e duas expansões de autoria compiladas em strict. |
| `node Documentacoes/tools/portal-iteration/browser.mjs final` | PASS, exit 0: loading/pronto/erro/timeout, drawer, scroll, prefixo Pages e mobile. Preview próprio encerrado em finally. |
| `node Documentacoes/tools/portal-iteration/verifier-audit.mjs` | PASS: paths versionados com case exato, quatro versões locais iguais às CDN e tamanho real do AST. |

Houve duas falhas transitórias iniciais: snippets não encontrou módulo compilado e browser não encontrou spinner. A saída compilada estava sendo reconstruída durante o período de revisão T8. As causas não foram reproduzidas com saída estável: ambos passaram integralmente em nova execução sequencial, sem alteração de produto ou teste. Não se usa a hipótese de corrida como prova de correção; a evidência válida é a nova execução aprovada.

Não existe contagem de testes versionados para comparar: a restrição do usuário mantém ferramentas e testes desta entrega ignorados. Não foram removidos testes versionados no diff. Os números acima descrevem documentos, snippets e fontes, não um total artificial de casos de teste.

## Sensor de discriminação

Foram usadas somente cópias de `.build`, `check.mjs` inalterado e do inventário AST em `Documentacoes/tools/portal-iteration/verifier-sensor/`. O baseline da cópia passou antes das mutações. Cada mutação foi restaurada na cópia antes da seguinte. O diretório scratch foi removido ao concluir.

| Mutação | Semântica alterada na cópia | Resultado |
| --- | --- | --- |
| M1 | Em `.build/content/navegacao.js`, título do grupo Arquitetura passou a Units. | KILLED, exit 1: `check.mjs:14`, árvore de títulos divergiu. |
| M2 | Em `.build/content/units/catalogo.js`, retirado processamentoSincronizacao da lista exportada. | KILLED, exit 1: `check.mjs:40`, 23 documentos em vez de 24. |

Profundidade proporcional: 2 mutações comportamentais, 2 mortas, 0 sobreviventes. `git status --porcelain` real antes = string vazia; depois = string vazia. A implementação real permaneceu intacta. O relatório foi escrito somente após essa prova de isolamento.

## Qualidade, edge cases e limites

O diff atende ao escopo aprovado: organização documental, migração de identidade e apresentação. Reutiliza catálogo, registro de navegação, referências, tabelas, terminais e busca existentes. As remoções são as aprovadas; não adiciona dependência de execução ERP. A correção AST T8 resolve um achado real da revisão, com asserção específica contra interpretar mensagens como uses. Não há mutante sobrevivente nem gap de precisão da especificação identificado.

Foram vistos desktop.png (1280×800) e mobile.png (360×740), ambos locais e ignorados. A captura mobile mostra drawer sem overflow e truncamento correto. Hover/foco, rota profunda, erro de CDN, timeout, reduced motion e conteúdo horizontal receberam verificação automatizada real em Chromium.

Limites: este parecer usa inspeção de código para a generalização de scroll a busca/sumário/diagramas e para touchpad/toque; não declara ensaio em hardware móvel, Firefox ou Safari. O teste de navegador intercepta CDN com distribuições reais Vue 3.5.43, Vue Router 4.6.4, Vuetify 4.2.3 e Mermaid 11.17.2, conferidas em package.json, sem mocks de API. Não comprova disponibilidade da CDN pública. Case dos paths foi comparado ao índice Git, mas não houve execução Linux nem GitHub Actions. Não houve UAT humano, sincronização, acesso a banco, chamadas TekStore, execução ou homologação ERP, push ou deploy.

A matriz de rastreabilidade da spec ainda contém status antigos nas primeiras linhas e texto de planejamento; o orquestrador deve reconciliar esse registro com este parecer. Isso não muda o resultado observado da implementação.

**Resultado final**: PASS no escopo documental e visual, 31/31 ACs com evidência, 2/2 mutações mortas. Nenhum gap funcional pendente priorizado.


Lição derivada do achado AST corrigido: L-001, candidata em .specs/lessons.json e .specs/LESSONS.md, registrada pelo script da skill. Gate estrutural validate_state: PASS, zero erros.

## Encerramento pelo orquestrador

Os 31 estados de rastreabilidade foram reconciliados como Verified após o parecer independente. A contagem textual de T8 foi corrigida para 18 nós e 21 arestas. Registros finais não alteram a implementação revisada em f3d9f1a. Nenhum push ou deploy foi executado.
