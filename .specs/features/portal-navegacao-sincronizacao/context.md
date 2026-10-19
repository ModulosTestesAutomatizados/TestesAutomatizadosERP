# Decisões de navegação e nomenclatura

Data: 2026-10-14.
Especificação: `spec.md` neste diretório.

## Decisões confirmadas

- Excluir as páginas anteriores que não aparecem no novo mapa, inclusive seus endereços. Não manter páginas ocultas nem redirecionamentos para elas.
- Usar o mesmo nome no menu, nos rótulos, nos títulos das páginas e nos artefatos.
- Incluir o custo de renomear os artefatos na entrega.
- Preservar `P39_TDD_` e empregar abreviações de módulo como `P39_TDD_FIN_` e `P39_TDD_FAT_` quando aplicável.

## Consequências para a implementação

- Fazer a migração de nomes antes de finalizar as páginas novas; assim a documentação nasce com caminhos e identificadores canônicos.
- Revisar referências Pascal estáticas e dinâmicas. O IRunner carrega o molde por `CodificacaoUnit` e o processamento seleciona o caso por `SetTDDUnit`; ambos dependem de strings com os nomes atuais.
- Atualizar o inventário AST, os hashes e os diagramas canônicos junto dos fontes renomeados.
- Revisar as variantes sem prefixo usadas pelos casos financeiros e pelo sincronizador.
- Excluir do catálogo e dos fontes de documentação as páginas fora do mapa e retirar o manifesto de redirecionamentos antigos.
- Atualizar as instruções de contribuição e os snippets para impedir nomes de exibição diferentes da identidade do artefato.
- Não executar alterações no ERP, na TekStore ou nos bancos. Os cadastros externos exigirão os nomes novos antes de executar os fontes renomeados.

## Premissas complementares

- O processamento financeiro passa a `P39_TDD_FIN_PROCESSAMENTO`; o piloto passa a `P39_TDD_FIN_PAGAMENTO_RECEBIMENTO`.
- `P39_TDD_PARAMETRO` passa ao plural `P39_TDD_PARAMETROS`, conforme o mapa fornecido.
- As duas units de mapeamento passam a `P39_TDD_FIN_BORDERO_PAGAMENTO` e `P39_TDD_FIN_BORDERO_RECEBIMENTO`.
- Os seis artefatos do núcleo IRunner que ainda não possuem o prefixo passam a recebê-lo.
- A lógica das rotinas permanece a mesma; alterações Pascal se restringem aos nomes e às referências correspondentes.

## Limites preservados

Trabalhar somente neste worktree. Não versionar testes e ferramentas de consumo local. A exceção anterior de push direto em master não se aplica a esta entrega.
