# Realização

O guia de contribuição foi atualizado para a estrutura atual em TypeScript, incluindo a distinção entre grupos do menu, páginas, seções e blocos. Agora explica a manutenção de seções, o registro nos catálogos, a navegação de casos e o processo de revisão e publicação.

Os estados são atualizados pelo autor no campo estado da página ou de criarDocumentoUnit. O guia descreve os quatro estados e inclui exemplos de mudança com evidência de homologação. A etiqueta em-uso passou a ser Em uso, abrangendo também recursos fora do IRunner. A página do guia foi marcada em-uso por ser o recurso de autoria ativo; isso não declara homologação dos fluxos de teste.

Foram acrescentados cinco snippets: docestado, docvalidacao, doccaso, docfonte e docaliasartefato, totalizando 18. As referências antigas a catalogo.js foram corrigidas. O criador de documentação de unit agora recebe e repassa evidenciaValidacao, permitindo o estado validado-no-erp quando os três campos obrigatórios estão presentes.

# Fontes modificados

- Documentacoes/app/content/guias/autoria.ts
- Documentacoes/app/content/units/criarDocumentoUnit.ts
- Documentacoes/app/content/validarCatalogo.ts
- Documentacoes/app/models/documentacao.ts
- Documentacoes/app/README.md
- .vscode/documentacao.code-snippets

# p/ teste

1. Abra Contribuir → Como escrever uma documentação e consulte o sumário.
2. Confira as instruções de manutenção de seções, mudança de estado, registro e publicação.
3. No VS Code, use docsecao em uma lista secoes e docestado no objeto da página, substituindo o campo anterior.
4. Para um recurso homologado, preencha docvalidacao com data, versão do ERP e referência reais. Sem esses dados, o build deve rejeitar validado-no-erp, inclusive para units.
5. Execute npm run check --prefix Documentacoes e npm run dev --prefix Documentacoes. Abra o endereço informado e confira a etiqueta na página e no card.

Verificações: TypeScript dos modelos de snippets de página e unit; rejeição de validação sem evidência e preservação dos três campos pelo criador de unit. Os recursos de testes permanecem locais e ignorados pelo Git.

# O que há de novo

O guia ensina como manter a documentação conforme o projeto evolui, com exemplos e atalhos para seções, estados, referências e navegação.
