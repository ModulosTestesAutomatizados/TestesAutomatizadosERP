# Grupos de navegação e busca por símbolos

## Realização

Arquitetura, Units, Referências e Contribuir agora são grupos expansíveis no drawer. Adicionado Casos de teste, com subgrupos Legado e IRunner. O grupo da rota atual é aberto automaticamente, inclusive ao recarregar, e cada título tem indicador e estado acessível de expansão.

Criadas páginas para o inventário do contrato anterior, o inventário com IRunner e o piloto financeiro. Documento Fatura está no subgrupo Legado. As páginas registram as divergências dos arquivos antigos e a diferença entre opções do processamento anterior e operações sequenciais do piloto. Os diagramas dessas páginas ficam em seus subdiretórios canônicos.

O modelo compartilhado extrai símbolos dos estados globais e assinaturas declaradas nas documentações de units. A busca prioriza a unit responsável, exibe o símbolo correspondente e mantém os resultados de referências com pontuação inferior. FCDSCasosTestes é alias de pesquisa explícito de CDSCasosTestes, preservando o nome do fonte.

Verificação: catálogo válido com 19 documentos e 207 seções; busca por FCDSCasosTestes, RegistrarTick, FCasoTesteAtualJson e CDSConfiguracao conferida. Verificação breve no navegador passou para grupos e subgrupos, navegação, abertura da rota ao recarregar, diagramas, pesquisa por símbolos, mobile e prefixo do GitHub Pages. O artefato estático foi conferido com 71 arquivos e sem erros JavaScript ou assets locais ausentes. Testes/tools continuam ignorados pelo Git. Sem publicação remota.

## Fontes modificados

- `Documentacoes/app/navigation.js`
- `Documentacoes/app/components/NavigationGroup.js`
- `Documentacoes/app/components/AppLayout.js`
- `Documentacoes/app/components/DocumentSearch.js`
- `Documentacoes/app/search.js`
- `Documentacoes/app/styles/portal.css`
- `Documentacoes/app/content/catalogo.js`
- `Documentacoes/app/content/validarCatalogo.js`
- `Documentacoes/app/content/units/criarDocumentoUnit.js`
- `Documentacoes/app/content/units/p39-tdd-casos-de-teste.js`
- `Documentacoes/app/content/casos/legado.js`
- `Documentacoes/app/content/casos/irunner.js`
- `Documentacoes/app/content/casos/piloto-financeiro.js`
- `Documentacoes/app/content/guias/autoria.js`
- `Documentacoes/README.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/casos-legado/entrada.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/casos-irunner/lote.md`
- `docs/MAPEAMENTO_AST_USES_UNITS/piloto-financeiro/teste.md`

## p/ teste

1. Abra o portal e clique nos títulos Arquitetura, Units e Referências para abrir e recolher suas listas.
2. Abra Casos de teste e depois Legado. Consulte o inventário e Documento Fatura.
3. Abra IRunner e consulte o inventário e Piloto financeiro. Recarregue a página: o grupo e o subgrupo da página devem permanecer visíveis.
4. Pesquise FCDSCasosTestes. O primeiro resultado deve ser P39_TDD_CASOS_DE_TESTE, mostrando Estado global: CDSCasosTestes.
5. Pesquise RegistrarTick e FCasoTesteAtualJson. Confira TDD_RUNNER e TDD_STARTED, respectivamente, como primeiros resultados.
6. Repita a navegação em tela estreita, abrindo o menu do header.

## O que há de novo

Navegação organizada em grupos que podem ser abertos e recolhidos. A busca agora ajuda a encontrar quem mantém um estado global ou implementa um método, e os casos estão organizados entre legado e IRunner.
