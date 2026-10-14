# Realização

O modelo de documentação individual de unit ganhou o campo jsonBase, que gera uma seção com JSON formatado e copiável, tabela de objeto/campo, tipo, finalidade e impacto, observações e fontes de referência. Os blocos existentes de código e tabela são reutilizados, sem novos componentes de apresentação.

Foram criadas documentações individuais para P39_TDD_FAT_PEDIDO_VENDA e REFACTOR_TDD_FINANCEIRO_PILOTO, com modelos base conferidos contra os consumidores dos fontes. Pedido de Venda usa documento, item, item.itens e parametros; o piloto financeiro lê tags na raiz. Identificadores zero são explicitamente espaços de preenchimento, e os modelos não declaram homologação no ERP nem integração dos asserts.

O guia de contribuição e o README explicam o novo contrato, acompanhado do snippet docunitjson. O catálogo e os links de citação de units incluem as duas páginas automaticamente. O portal possui 23 documentos e 19 snippets.

# Fontes modificados

- Documentacoes/app/models/documentacao.ts
- Documentacoes/app/content/units/criarDocumentoUnit.ts
- Documentacoes/app/content/units/catalogo.ts
- Documentacoes/app/content/units/p39-tdd-fat-pedido-venda.ts
- Documentacoes/app/content/units/refactor-tdd-financeiro-piloto.ts
- Documentacoes/app/content/guias/autoria.ts
- Documentacoes/app/README.md
- .vscode/documentacao.code-snippets

# p/ teste

1. Abra Units → P39_TDD_FAT_PEDIDO_VENDA e confira JSON base do caso de teste no sumário.
2. Copie o JSON no terminal e confira os objetos documento, item e parametros. Leia a tabela para compreender seleção de clientes, itens, precedência e parâmetros.
3. Abra Units → REFACTOR_TDD_FINANCEIRO_PILOTO e confira os campos financeiros na raiz e a tabela de validação.
4. No VS Code, use docunitjson nos argumentos de criarDocumentoUnit de um novo caso e preencha os dados conforme os fontes consumidores.
5. Execute check e dev, abra o endereço informado e recarregue as páginas sob o prefixo do GitHub Pages.

Verificações: lint, TypeScript strict, build de 23 documentos, JSON válido, tabela com quatro colunas e ausência do tópico em units sem jsonBase. Testes auxiliares são locais e ignorados pelo Git.

# O que há de novo

As units dos casos de teste agora apresentam um modelo JSON copiável e explicam como cada objeto e campo altera o cenário de execução.
