# Configuração do portal

O portal usa Vue SFC com TypeScript, Vuetify, Router, Mermaid e ícones instalados por npm. O Vite compila uma aplicação estática sem CDN. `eslint.config.js` aplica o padrão Vue/TypeScript de `k6/infra/frontend/config/eslint.config.js` diretamente sobre `.vue` e `.ts`.

Da raiz do repositório:

```powershell
npm ci --prefix Documentacoes
npm run dev --prefix Documentacoes
npm run check --prefix Documentacoes
npm run build --prefix Documentacoes
npm run preview --prefix Documentacoes
```

Dev atualiza SFCs durante a edição; preview serve somente o build em `Documentacoes/.pages-output`. Use o endereço impresso, incluindo `/TestesAutomatizadosERP/`. Para escolher uma porta, acrescente `-- --port 8090` ao comando dev ou preview. Sem `--strictPort`, Vite tenta outra porta quando a solicitada estiver ocupada. Não abra o índice fonte diretamente.

`check` executa ESLint, vue-tsc e a checagem TypeScript da configuração. A entrada única é `index.html` na raiz. `vite.config.ts` define base, alias, compiladores e saída. Não existe dependência de bootstrap.js ou do framework Bootstrap.

`portal-assets.ts` valida catálogo, existência e capitalização exatas das fontes, blocos Mermaid e hashes dos inventários AST. Os hashes normalizam somente CRLF para LF para conferir Windows e Linux. O plugin publica apenas diagramas referenciados, inventários registrados e moldes canônicos utilizados pelos blocos `codigo-fonte`, além de `.nojekyll`. Não copia `.specs`, ferramentas ou toda a árvore Pascal.

`package.json` e `package-lock.json` definem o build reproduzível. Testes/ferramentas temporários permanecem ignorados. Os três JSONs compartilhados de `docs/assets/snippets` são exceções explícitas; massas JSON pessoais continuam ignoradas.

O workflow valida PRs e publica somente push em `master` ou execução manual na `master`. Os filtros cobrem `index.html`, `Documentacoes/**`, `docs/assets/**`, `docs/MAPEAMENTO_AST_USES_UNITS/**` e o próprio workflow. Publica `.pages-output` com rotas hash. Pages deve usar GitHub Actions como origem; não precisa de Node no navegador.
