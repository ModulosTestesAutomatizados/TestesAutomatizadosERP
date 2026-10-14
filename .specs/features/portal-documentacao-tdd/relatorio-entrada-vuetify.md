# Realização

A entrada do portal deixou de solicitar `bootstrap.js`, arquivo que não existia nos fontes TypeScript. O build agora inclui a inicialização diretamente no HTML publicado. A interface continua usando Vue e Vuetify via CDN, preservando as cores e a tipografia existentes.

# Fontes modificados

- index.html
- Documentacoes/app/start.ts (substitui bootstrap.ts)
- Documentacoes/app/styles/portal.css
- Documentacoes/app/README.md
- Documentacoes/config/build.mjs
- Documentacoes/config/README.md
- Documentacoes/package.json

# p/ teste

1. Execute `npm ci --prefix Documentacoes` e `npm run dev --prefix Documentacoes` na raiz.
2. Abra `http://127.0.0.1:8080/TestesAutomatizadosERP/` e navegue pelos cards, units e diagramas.
3. Recarregue uma documentação e confira a busca, os acentos e a apresentação no celular.
4. No painel de rede do navegador, confirme a ausência de requisições a `bootstrap.js` e de recursos locais com erro 404.

Validação realizada: ESLint, TypeScript strict, build dos 19 documentos e navegação no navegador com prefixo de GitHub Pages. Testes e ferramentas locais permanecem ignorados pelo Git. Os HTMLs históricos que usavam Bootstrap são preservados como arquivo e excluídos do site publicado.

# O que há de novo

O portal inicia sem depender de um arquivo externo de inicialização. O comando de desenvolvimento compila antes de abrir o servidor, e o índice dos fontes orienta como visualizar a documentação.
