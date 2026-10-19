# Portal loading Vuetify — validação

**Verdict: PASS**

- Data: 2026-10-14.
- Spec: `.specs/features/portal-loading-vuetify/spec.md`.
- Diff: `d2a7d08..085dfcd`.
- Verificador: agente independente do autor; revisão restrita ao portal documental e ao steering registrado.
- Plano implícito da spec: implementação local concluída; validação independente concluída. Não há `tasks.md` formal para esta feature.

## Critérios ancorados na spec

| AC | Resultado esperado | Evidência de implementação e asserção executada | Resultado |
| --- | --- | --- | --- |
| LOADING-01 | Componentes reais VOverlay, VProgressCircular e VSkeletonLoader; scrim; remover spinner artesanal. | `Documentacoes/app/components/PortalLoading.ts:55` declara overlay, scrim e props; `PortalLoading.ts:77` usa progress circular. `Documentacoes/tools/portal-iteration/browser-loading.mjs:36` verifica `.portal-spinner` igual a zero; linhas 38–40 aguardam overlay ativo/progress e exigem pelo menos seis skeleton loaders reais. | PASS |
| LOADING-02 | Skeleton e conteúdo inerte enquanto rota inicial não estiver pronta. | `Documentacoes/app/main.ts:18` monta antes de `router.isReady()` na linha 24; `Documentacoes/app/components/AppLayout.ts:31` deriva inert do bloqueio. `Documentacoes/tools/portal-iteration/browser-loading.mjs:33` retém o módulo da home; linhas 39–41 exigem skeleton de cards e `el.inert === true` antes de liberá-lo. | PASS |
| LOADING-03 | Mínimo de 650 ms desde montagem, fade de 240 ms, liberar interação após saída. | `Documentacoes/app/main.ts:26` usa `Math.max(0, 650 - elapsed)`; linhas 28–29 aguardam finalizado antes de desbloquear. `Documentacoes/app/components/PortalLoading.ts:66` emite após leave. `Documentacoes/tools/portal-iteration/browser-loading.mjs:47` exige duração computada `0.24s`, linha 48 exige inert durante leave, linha 51 exige duração total >=850 ms (tolerância de observação do DOM frente aos 890 ms nominais), linha 52 exige remoção do skeleton. O sensor abaixo discrimina a retirada do mínimo. | PASS |
| LOADING-04 | Movimento reduzido sem shimmer, rotação ou fade, mantendo indicação acessível. | `Documentacoes/app/components/PortalLoading.ts:10` lê a preferência, linhas 24/58/78 aplicam boilerplate/sem transição/indicador estático; linhas 68–83 preservam status e rótulo. `Documentacoes/app/styles/portal.css:150` desliga transições. `Documentacoes/tools/portal-iteration/browser-loading.mjs:62` ativa reduce; linhas 69–70 exigem boilerplate e zero indicadores indeterminados; linhas 75–76 aguardam desbloqueio e artigo. | PASS |
| LOADING-05 | Erro acessível e recarga em falha de CDN ou rota; sem indicador indefinido. | `Documentacoes/app/start.ts:6` define timeout de 20 s, linhas 27–35 criam alerta e botão focado. `Documentacoes/app/main.ts:31` sinaliza falha da rota; `Documentacoes/app/components/PortalLoading.ts:77` substitui indicador por erro na linha 85. `Documentacoes/tools/portal-iteration/browser-loading.mjs:79` aborta CDN e rota; linhas 82–84 exigem botão, mensagem em alert e foco; linha 89 avança 20001 ms e exige recarga no timeout. | PASS |
| LOADING-06 | Placeholder pré-CDN; cards na home, artigo em documento; mobile e navegação posterior sem atraso. | `Documentacoes/config/build.mjs:55` injeta placeholder estático. `Documentacoes/app/components/AppLayout.ts:27` seleciona layout inicial. `Documentacoes/tools/portal-iteration/browser-loading.mjs:35` exige placeholder com CDN retida; linha 39 exige cards; linhas 55–57 navegam para unit e exigem ausência de skeleton; linhas 68/71–72 exigem documento, drawer oculto e ausência de overflow horizontal em 360 px. | PASS |
| LOADING-07 | Retirar migração do guia e manter Markdown operacional fora do portal publicado. | `Documentacoes/app/content/guias/autoria.ts:139` passa diretamente à revisão/publicação após remoção da seção. `docs/assets/emDesenvolvimento/MIGRACAO_NOMES_UNITS_TDD.md:5` mantém as onze renomeações; linha 51 referencia Mermaid de manutenção. `Documentacoes/tools/portal-iteration/browser-loading.mjs:93` exige ausência de `migracao-nomes` no catálogo; linhas 94–95 exigem roteiro local e HTTP 404 no artefato. Diff detecta rename R100 do Mermaid para `manutencao-migracao-units`. | PASS |
| LOADING-08 | JPEG fornecido em caminho relativo compatível com prefixo Pages. | `index.html:8` usa `./Documentacoes/app/assets/faviconTDD.jpg` com tipo JPEG. `Documentacoes/config/build.mjs:42` copia assets; `Documentacoes/config/preview.mjs:7` define MIME. `Documentacoes/tools/portal-iteration/browser-loading.mjs:96` resolve href sob `/TestesAutomatizadosERP/`; linhas 98–99 exigem HTTP 200, `image/jpeg` e igualdade byte a byte com asset fonte. | PASS |

**Resultado:** 8/8 ACs correspondem aos resultados definidos. A checagem temporal combina teste de navegador com inspeção da constante e sensor; não mede precisão submilissegundo.

## Gates executados pelo verificador

Executados uma vez, sequencialmente, nesta árvore:

1. `npm run check --prefix Documentacoes` — exit 0: ESLint, lint de templates e TypeScript.
2. `npm run build --prefix Documentacoes` — exit 0: 24 documentos compilados.
3. `node Documentacoes/tools/portal-iteration/browser-loading.mjs` — exit 0: quatro grupos PASS (nativo, documento/mobile, falhas, manutenção/favicon).

Não houve falha no gate nem cenário pulado no script utilizado. Falha de CDN, timeout e rota são cenários de erro esperados e aprovados. Não foram executados testes antigos que representam o carregamento ou o roteiro de migração anteriores, conforme escopo informado. Não há contagem histórica reproduzível desse teste local ignorado no range Git; não foi inferido delta de testes versionados. Nenhum teste foi alterado ou removido nesta validação.

## Sensor de discriminação

- Profundidade: leve, uma mutação comportamental proporcional a portal documental.
- Alvo: cópia do `Documentacoes/.build/main.js` correspondente a `Documentacoes/app/main.ts:26`, substituindo `650 -` por `0 -`.
- Isolamento: arquivos `main-mutant.js` e `sensor-loading.mjs` sob `Documentacoes/tools/portal-iteration/`, ambos confirmados por `git check-ignore`. O teste copiado interceptou a resposta de `**/app/main.js` e serviu exclusivamente a cópia mutada; fonte e artefato reais permaneceram intactos. Sem worktree e sem stash.
- Oráculo: mesma asserção temporal de `Documentacoes/tools/portal-iteration/browser-loading.mjs:51` (`times.end-times.start >= 850`).
- Resultado: **KILLED**, exit 1, `AssertionError` na linha 52 da cópia. Tempos observados: start 1234,8 ms; end 1966,1 ms; duração 731,3 ms, abaixo de 850 ms.
- Limpeza: os dois arquivos de scratch removidos por caminhos absolutos verificados dentro do workspace.
- `git status --porcelain` antes: vazio. Após limpeza, antes deste relatório: vazio. Nenhuma alteração versionada produzida pelo sensor.

**Sensor: 1 injetada, 1 morta, 0 sobreviventes.**

## Qualidade, bordas e limites

Revisão do diff confirma alterações concentradas em loading, documentação operacional e favicon, sem dependência nova e sem modificação de units Pascal. O bloqueio permanece até `afterLeave`; carga lenta não adiciona outros 650 ms após readiness. Erro pós-montagem usa componente nativo; erro pré-CDN usa fallback estático. Capturas desktop 1280×800 e mobile 360×740 foram inspecionadas visualmente: painel centralizado, skeleton representativo e sem corte horizontal.

A cobertura usa Vuetify/Vue reais das versões instaladas correspondentes aos recursos CDN, servidas por interceptação local. Ela não prova disponibilidade da rede CDN pública. Animações reduzidas e scrim combinam evidência de fonte e runtime; não houve UAT humana, leitor de tela ou comparação visual automatizada de pixels. O teste de navegação posterior verifica ausência de skeleton, sem orçamento de latência. A igualdade do favicon verifica asset fonte versus artefato servido; a imagem original pré-movimentação não integra o range revisado, portanto não houve comparação independente com arquivo externo anterior.

Ferramentas de navegador e capturas são locais/ignoradas e não entram no commit do produto. O preview existente na porta 57929 não foi parado; os testes abriram e fecharam seu próprio servidor efêmero. Não foram executados ERP, banco, hardware físico, push ou deploy. Sem gaps de implementação encontrados e sem sinal para registrar nova lesson.
## Ajuste visual posterior — 2026-10-14

A pedido do usuário, retirados o card central, a marca e o progresso circular durante a carga normal. Permanecem overlay, skeleton e anúncio de status invisível; painel de erro somente em falhas. Validação do autor após o ajuste: check e build (24 documentos) aprovados; navegador desktop/mobile confirmou ausência de card e progresso circular, transição de 240 ms, mínimo de 650 ms, bloqueio até a saída, movimento reduzido e recarga em falhas. Captura desktop inspecionada: somente skeleton e scrim. Teste local adaptado aos elementos que agora são visualmente ocultos; ferramentas permanecem ignoradas. Esta nota não constitui nova revisão independente.
