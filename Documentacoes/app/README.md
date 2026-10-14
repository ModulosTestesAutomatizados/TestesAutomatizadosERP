# Documentação TDD do ERP

O conteúdo e os fontes da documentação ficam exclusivamente em `Documentacoes/app`. Os diagramas ficam em `docs/MAPEAMENTO_AST_USES_UNITS`, organizados por documentação. A configuração de desenvolvimento e publicação fica em `Documentacoes/config`.

O portal é escrito em TypeScript, com contratos compartilhados e verificação em modo strict. Vue, Vue Router, Vuetify e Mermaid continuam via CDN, com versões fixadas em `config.ts`. O build converte os módulos para JavaScript; o resultado publicado é estático e não exige backend ou banco.

## Desenvolvimento e GitHub Pages

Na raiz do repositório:

```powershell
npm ci --prefix Documentacoes
npm run check --prefix Documentacoes
npm run build --prefix Documentacoes
npm run preview --prefix Documentacoes
```

Para compilar e abrir o servidor em um único comando, use `npm run dev --prefix Documentacoes`. A inicialização TypeScript é inserida no HTML durante o build, sem solicitar `bootstrap.js`. A interface usa exclusivamente Vuetify, com a tipografia e as cores definidas em `styles/portal.css` e `main.ts`.

O carregamento inicial usa `PortalLoading` com VOverlay e VSkeletonLoader, sem card central nem indicador circular. O estado de carregamento é anunciado aos leitores de tela; o painel de recarga aparece somente em falhas. O skeleton representa cards ou artigo, aguarda a rota inicial e permanece pelo menos 650 ms antes do fade de saída de 240 ms. Navegações posteriores não repetem esse atraso. Movimento reduzido desativa animações. Antes do CDN há somente um placeholder estático. `assets/faviconTDD.jpg` contém a imagem fornecida para o favicon e é copiado para o artefato.

Abra o endereço informado no terminal. O preview tenta a porta 8080 e, se estiver ocupada, seleciona automaticamente uma porta livre. Para fixar uma porta, defina `PORT` antes de executar o comando (no PowerShell: `$env:PORT = '8090'`). O preview serve `Documentacoes/.pages-output`, e não os arquivos TypeScript. Após editar, execute novamente check e build. O índice dos fontes não pode ser servido diretamente porque os navegadores não executam TypeScript.

O workflow `.github/workflows/documentacao-pages.yml` verifica e compila alterações em PRs, sem publicar. Após merge ou push em `master`, a publicação é automática quando pelo menos um arquivo alterado corresponde a `index.html`, `Documentacoes/**`, `docs/MAPEAMENTO_AST_USES_UNITS/**`, `docs/assets/**` ou ao próprio workflow. Os padrões `**` incluem subdiretórios. A execução manual continua disponível em `master`. O GitHub Pages deve usar GitHub Actions como origem. As rotas hash permitem abrir e recarregar páginas sob `/TestesAutomatizadosERP/`; o build inclui `.nojekyll` e mantém os caminhos relativos de assets e diagramas. Consulte `../config/README.md` para os detalhes da configuração.

## Organização dos fontes

- `start.ts`, `main.ts` e `config.ts`: inicialização e dependências CDN.
- `router.ts`: rotas hash genéricas.
- `models/documentacao.ts`: tipos de documentos, blocos, seções, símbolos e navegação.
- `components/`, `pages/` e `composables/`: apresentação e comportamento reutilizáveis.
- `content/catalogo.ts`: catálogo de páginas; cards, navegação e busca são derivados dele.
- `content/units/`: documentações individuais e catálogo único de units.
- `content/estrutura/` e `content/guias/`: fluxo IRunner e guia de contribuição.
- `content/navegacao.ts`: seis grupos e seus subgrupos; posição e ordem vêm de cada documento.
- `styles/` e `templates/`: estilos compartilhados e modelo copiável de documento.

Não crie novos HTMLs completos ou novas pastas de documentação na raiz de `Documentacoes`. Registre módulos de conteúdo no catálogo.

## Páginas, seções e documentações de units

1. Crie um módulo, como `content/estrutura/meu-assunto.ts`, com `docpagina`. Preencha categoria e grupo registrados. O snippet usa `satisfies IDocumento` para verificar o contrato editorial.
2. Use `docsecao` para títulos e `doccodigo`, `doclista`, `docaviso`, `doctabela` ou `docdiagrama` para blocos.
3. Importe a página em `content/catalogo.ts` e inclua-a na lista com `docregistro`. Router, layout, cards e busca não precisam ser alterados.
4. Para uma unit, crie `content/units/nome-da-unit.ts` com `docunit`. O modelo organiza responsabilidade, problema resolvido, estados globais, assinaturas, implementação, dependências e limites.
5. Acrescente métodos e estados com `docunitmetodo` e `docunitestado`. Registre a unit em `content/units/catalogo.ts` com `docregistrounit`.
6. Para diagramas, use `docmermaid` em `docs/MAPEAMENTO_AST_USES_UNITS/<slug>/<nome>.md` e referencie o arquivo com `docdiagrama`.
7. Execute check e build e confira a página no preview. Os 22 snippets de `.vscode/documentacao.code-snippets` usam o escopo TypeScript para os módulos; Mermaid usa Markdown. O guia também está em `/#/guias/autoria`.

## Manutenção de seções e estados

Uma página é registrada no catálogo; uma seção é somente um item de `secoes` nessa página. Use `docsecao` para acrescentar um item com `id` único, `titulo`, `nivel` e `blocos`. Para modificar uma seção, edite esse item e preserve o ID para manter links existentes. A ordem dos itens define a leitura e o sumário. Units usam as listas e os campos de `criarDocumentoUnit` para gerar suas seções.

O campo `estado` pertence à página inteira, descreve o recurso documentado e precisa ser atualizado pelo autor. As opções são `em-desenvolvimento`, `em-uso`, `legado` e `validado-no-erp`. Use `docestado` para substituir o valor existente; não duplique o campo. `em-uso` não implica homologação nem uso obrigatório pelo IRunner. `validado-no-erp` exige `evidenciaValidacao` com `data`, `versaoERP` e `referencia` reais, tanto em páginas comuns quanto em `criarDocumentoUnit`; `docvalidacao` fornece o modelo. Pendências de uma seção podem ser registradas com `docaviso`.

`doccaso` posiciona a documentação individual em Casos de teste, sem subgrupos. `docfonte` acrescenta uma referência e `docaliasartefato` registra uma variante de pesquisa de estado global. O import criado por `docregistro` ou `docregistrounit` ainda precisa ser incluído na lista do respectivo catálogo. Use `docgrupo` em `content/navegacao.ts` e `docsubgrupo` no array do grupo para ampliar a navegação; `docnavegacao` posiciona a página ou unit com os IDs registrados. O build rejeita IDs inexistentes ou duplicados, sem necessidade de alterar o router para criar grupos.

Para uma unit de caso de teste, use `docunitjson` dentro de `criarDocumentoUnit`. O campo `jsonBase` contém `exemplo` (objeto JSON), `campos` (caminho, tipo, finalidade e impacto), `observacoes` e `fontes` opcionais. Ele gera a seção JSON base do caso de teste usando o terminal copiável e a tabela compartilhada. Preencha o modelo conforme os consumidores do fonte, registrando valores obrigatórios, padrões e precedência; códigos zero são espaços de preenchimento e não representam registros válidos da base.

Arquivo Pascal, identidade da unit, título e nome no menu devem ser iguais, começando com `P39_TDD_`. Para artefatos específicos de módulo, use `P39_TDD_FIN_`, `P39_TDD_FAT_` e a sigla correspondente. As rotas usam minúsculas e hífens: `P39_TDD_IRUNNER` → `/units/p39-tdd-irunner`. O build rejeita título ou nome de fonte divergentes. `ReferenceText` e `UnitReference` produzem os links nas citações, inclusive nos nós Mermaid, sem alterar o texto literal copiado.

Ao renomear, atualize declarações, `uses`, qualificações, nomes em `CodificacaoUnit` e `SetTDDUnit`, exemplos, catálogo e grafos. **Antes de executar os fontes renomeados, atualize os nomes cadastrados no ERP e na TekStore.** A migração local não publica esses cadastros nem comprova homologação. As páginas antigas fora do mapa e as rotas anteriores das units renomeadas foram excluídas, sem redirecionamento.

## Navegação e busca

O conteúdo é exibido inteiro, sem painéis expansíveis. O sumário hierárquico acompanha a leitura e permite compartilhar seções como `/#/estrutura/runner?secao=lote`. Cards inteiros são links.

O drawer segue esta ordem: Arquitetura; Units (Setup, Constantes, Persistência e IRunner); Casos de teste; Mapeamentos (Financeiro); Helpers (Gerais e Sincronização); Contribuir. O registro único é `content/navegacao.ts`. Cada página define grupo, subgrupo quando existir e ordem. Exemplo: `navegacao: { grupo: 'helpers', subgrupo: 'sincronizacao', ordem: 0 }`. Casos usa apenas `grupo: 'casos'`. A rota atual abre os ancestrais automaticamente. Todas as documentações individuais mantêm `/units/<slug>`, inclusive casos, mapeamentos e helpers.

A busca usa um índice local ponderado inspirado em BM25, com acentos normalizados, múltiplos termos e prefixos. As declarações de estados e assinaturas recebem prioridade sobre citações no corpo. `RegistrarTick` prioriza P39_TDD_RUNNER; `FCasoTesteAtualJson`, P39_TDD_STARTED. `FCDSCasosTestes` é alias explícito de pesquisa de `CDSCasosTestes`, declarado em P39_TDD_CASOS_DE_TESTE. Registre novas variantes com `aliasesArtefatos: { nomeDeclarado: ['variante'] }` sem renomear o Pascal.

## Mapas e limites

Cada diagrama ativo é lido do subdiretório canônico correspondente ao slug da página. O mapa sintático do Runner está em `runner/P39_TDD_IRUNNER.md` e o inventário em `runner/P39_TDD_IRUNNER.ast.json`, incluindo fontes, linhas, hashes e alcance transitivo de `uses`. As raízes incluem o processamento e o cenário financeiro selecionado dinamicamente. A extração não compila Pascal nem comprova o cadastro externo das units.

Mapas anteriores ficam em `docs/MAPEAMENTO_AST_USES_UNITS/historico`, separados por assunto; não são páginas do portal. Os diagramas das páginas excluídas foram removidos. Orientação e zoom afetam apenas a leitura, preservando o Markdown canônico.

Casos de Teste e Parâmetros permanecem dependências em uso no IRunner. A etiqueta geral é “Em uso”, pois o portal também documenta outros contratos. `TDD_ASSERTS` continua pendente e a documentação não declara homologação no ERP.

`tests/`, `tools/`, dependências instaladas e saídas geradas são ignorados pelo Git. O pacote versionado contém somente dependências e scripts necessários ao build, TypeScript e ESLint; os recursos de testes locais da LLM não participam da publicação.
