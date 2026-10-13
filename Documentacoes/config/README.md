# Configuração do portal

`eslint.config.js` aplica o padrão Vue/TypeScript de `k6/infra/frontend/config/eslint.config.js`, incluindo ordenação de imports, nomenclatura e regras Vue. `lint-templates.mjs` apresenta os templates inline como SFCs virtuais ao ESLint para aplicar também as regras Vue de atributos e formatação; os fontes continuam módulos TypeScript compatíveis com CDN. O código do portal é escrito em TypeScript; as bibliotecas npm fornecem tipos e ferramentas de desenvolvimento. Vue, Vuetify, Router e Mermaid continuam sendo carregados via CDN na aplicação publicada.

Na raiz do repositório:

```powershell
npm ci --prefix Documentacoes
npm run check --prefix Documentacoes
npm run build --prefix Documentacoes
npm run preview --prefix Documentacoes
```

Abra `http://127.0.0.1:8080/`. O preview serve somente `Documentacoes/.pages-output`, resultado do build. Não abra o índice dos fontes diretamente: o navegador precisa dos módulos JavaScript emitidos pelo compilador.

`npm run dev --prefix Documentacoes` compila antes de servir. O build insere `app/start.ts` compilado diretamente no índice publicado; não existe dependência de `bootstrap.js` nem do framework Bootstrap. O índice dos fontes mostra as instruções de desenvolvimento, sem requisitar arquivos ainda não compilados.

`../tsconfig.json` usa modo strict e reescreve imports relativos `.ts` para `.js`. `build.mjs` compila, valida o catálogo e as referências e monta o artefato estático por seleção explícita. Confere os hashes dos fontes locais do inventário sintático para detectar mapas desatualizados. Copia os diagramas canônicos utilizados, gera os redirecionamentos de compatibilidade e exclui histórico HTML, fontes TypeScript, configurações, testes, ferramentas e dependências npm.

`package.json` e `package-lock.json` são versionados porque definem o build reproduzível e o ESLint. Testes e ferramentas de consumo local da LLM continuam ignorados, sem scripts ou dependências de testes neste pacote.

Os hashes do inventário AST são calculados normalizando CRLF para LF, para que o checkout Windows e o Linux do GitHub Actions verifiquem o mesmo conteúdo.

O workflow do GitHub Pages verifica e compila o portal. A publicação é acionada manualmente no GitHub Actions; selecione GitHub Actions como origem em Settings → Pages. O site final continua estático, com rotas hash e `.nojekyll`; não precisa de Node no navegador.
