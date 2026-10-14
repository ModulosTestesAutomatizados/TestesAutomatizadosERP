# Pesquisa: CDN e GitHub Pages

Data: 2026-10-06. Pesquisa do design, sem implementação da aplicação. Artefato de reprodução: [cdn-probe.html](cdn-probe.html).

## Resultado

PASS para compatibilidade nominal de Vue 3.5.43, Vue Router 4.6.4, PrimeVue 4.5.5, PrimeUIX Themes 1.2.5 e Mermaid 11.17.2 em Chromium headless. Componentes Panel, Tag, Button, Message, DataTable e Column foram registrados; rota `/casos/financeiro` foi resolvida; Mermaid gerou SVG.

Os cinco arquivos foram obtidos das URLs CDN fixadas abaixo por HTTP 200, salvos em diretório temporário e reproduzidos pelo navegador via servidor HTTP local. Isso verifica a combinação de artefatos efetivamente baixados. Não é prova de deploy, teste da aplicação final nem teste de todos os componentes e casos de erro. O HTML de reprodução usa essas URLs CDN diretamente; a execução registrada usou cópias locais dos mesmos bytes para separar compatibilidade de instabilidade de rede do navegador.

| Pacote | URL fixada | Bytes | SHA-256 |
| --- | --- | ---: | --- |
| Vue | `https://cdn.jsdelivr.net/npm/vue@3.5.43/dist/vue.global.prod.js` | 168331 | b72394052eef1eeda1752db3758ce1be6f88016903f22e5241cc732ea307478e |
| Vue Router | `https://cdn.jsdelivr.net/npm/vue-router@4.6.4/dist/vue-router.global.prod.js` | 27401 | 71505f07492774a24202b07d1409652791845594d9846513d22310ac38fa0619 |
| PrimeVue | `https://cdn.jsdelivr.net/npm/primevue@4.5.5/umd/primevue.min.js` | 1928490 | 600167664863dde9bf2f80496dc90bb800e26cc1e8b8fd8f0ac04663dd3e8f9c |
| Aura | `https://cdn.jsdelivr.net/npm/@primeuix/themes@1.2.5/umd/aura.js` | 105300 | 9af9f95b35ddb1368059d359747482be176a71a8aeb184015d5686e0235c9007 |
| Mermaid | `https://cdn.jsdelivr.net/npm/mermaid@11.17.2/dist/mermaid.min.js` | 3572661 | 581ed7d74bd9048d0e3a91363927d72ef22942d7722546b27f7cc29e35390eb8 |

Manifestos do registro npm consultados: Router 4.6.4 exige Vue `^3.5.0`; PrimeVue 4.5.5 usa `@primeuix/styled ^0.7.4`; Themes 1.2.5 usa `@primeuix/styled ^0.7.3`. A prova no navegador complementa essa comparação. Foram descartadas URLs móveis e atualização automática para Router 5/PrimeVue 5/Mermaid 12.

Saída da execução em HTTP local, raiz:

```text
vue=3.5.43; route=financeiro; hash=#/casos/financeiro; pathname=/
message=true; table=true; panel=true; tag=true; button=true; svg=true; errors=[]
```

Saída da execução em HTTP local, prefixo de projeto:

```text
vue=3.5.43; route=financeiro; hash=#/casos/financeiro; pathname=/TestesAutomatizadosERP/
message=true; table=true; panel=true; tag=true; button=true; svg=true; errors=[]
```

A primeira tentativa do probe não concluiu por newline literal em string JavaScript gerada no script de pesquisa. O DOM apontou o erro de sintaxe; a string foi corrigida para `\n` antes das execuções PASS. Não houve modificação em código da aplicação.

## Reproduzir a pesquisa

Sirva o HTML por HTTP estático e abra-o em Chromium. O elemento `#result` apresenta JSON de diagnóstico; espere `route=financeiro`, seis componentes/diagrama presentes e `errors=[]`. Para reproduzir a evidência com arquivos locais, baixe as cinco URLs, compare os hashes e substitua apenas os `src` por seus arquivos, mantendo a ordem.

Em teste de prefixo, coloque o HTML e os scripts na subpasta `/TestesAutomatizadosERP/`. Não usar o diretório de pesquisa como aplicação publicada. O probe não contém conteúdo da issue e não deve integrar o pacote Pages.

## GitHub observado

Consultas somente de leitura:

```text
gh repo view ModulosTestesAutomatizados/TestesAutomatizadosERP --json nameWithOwner,defaultBranchRef,isPrivate,url
gh api repos/ModulosTestesAutomatizados/TestesAutomatizadosERP --jq '{default_branch,visibility,has_pages,permissions}'
gh api repos/ModulosTestesAutomatizados/TestesAutomatizadosERP/pages
```

Resultado: branch padrão `master`, repositório público, `has_pages=false`. Permissões retornadas: `pull=true`, `push=true`, `triage=true`, `admin=false`, `maintain=false`. A consulta específica Pages retornou HTTP 404, coerente com ausência de site. A API de repositório forneceu confirmação explícita; não foi inferida ausência apenas do 404.

Habilitar Pages via Actions exige acesso de administração/configuração não demonstrado pela credencial disponível. Nenhuma configuração GitHub foi alterada. O workflow poderá ser preparado localmente; habilitação e deploy real só ocorrerão após revisão e com permissão adequada.

## Fontes

[PrimeVue CDN](https://primevue.org/cdn), [Vue Router global](https://router.vuejs.org/installation), [hash history](https://router.vuejs.org/api/functions/createWebHashHistory.html) e [Mermaid usage](https://mermaid.js.org/config/usage.html), consultados via Context7. Manifestos: registro oficial npm dos cinco pacotes, conferidos durante a pesquisa. GitHub observado via CLI autenticada.
