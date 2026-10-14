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

Abra o endereço informado no terminal. O preview tenta a porta 8080 e, se estiver ocupada, seleciona automaticamente uma porta livre. Para fixar uma porta, defina `PORT` antes de executar o comando (no PowerShell: `$env:PORT = '8090'`). O preview serve `Documentacoes/.pages-output`, e não os arquivos TypeScript. Após editar, execute novamente check e build. O índice dos fontes não pode ser servido diretamente porque os navegadores não executam TypeScript.

O workflow `.github/workflows/documentacao-pages.yml` verifica e compila alterações em PRs, sem publicar. Após merge ou push em `master`, a publicação é automática quando pelo menos um arquivo alterado corresponde a `index.html`, `Documentacoes/**`, `docs/MAPEAMENTO_AST_USES_UNITS/**`, `docs/assets/**` ou ao próprio workflow. Os padrões `**` incluem subdiretórios. A execução manual continua disponível em `master`. O GitHub Pages deve usar GitHub Actions como origem. As rotas hash permitem abrir e recarregar páginas sob `/TestesAutomatizadosERP/`; o build inclui `.nojekyll` e mantém os caminhos relativos de assets e diagramas. Consulte `../config/README.md` para os detalhes da configuração.

## Organização dos fontes

- `start.ts`, `main.ts` e `config.ts`: inicialização e dependências CDN.
- `router.ts`: rotas hash genéricas.
- `models/documentacao.ts`: tipos de documentos, blocos, seções, símbolos e navegação.
- `components/`, `pages/` e `composables/`: apresentação e comportamento reutilizáveis.
- `content/catalogo.ts`: catálogo de páginas; cards, navegação e busca são derivados dele.
- `content/units/`: documentações individuais e catálogo único de units.
- `content/casos/`: inventários do legado, do IRunner e fluxo do piloto financeiro.
- `content/historico/`: referências anteriores apresentadas no layout atual.
- `arquivo/html/`: cópias históricas preservadas dos índices anteriores, excluídas da publicação.
- `arquivo/migracao.md`: correspondência entre títulos anteriores e páginas atuais.
- `redirecionamentos/`: entradas de compatibilidade com nomes por assunto. O manifesto gera também as antigas URLs numeradas no artefato, sem manter essas pastas nos fontes.
- `styles/` e `templates/`: estilos compartilhados e modelo copiável de documento.

Não crie novos HTMLs completos ou novas pastas de documentação na raiz de `Documentacoes`. Registre módulos de conteúdo no catálogo.

## Páginas, seções e documentações de units

1. Crie `content/documentos/meu-assunto.ts` com `docpagina`. O snippet usa `satisfies IDocumento` para verificar o contrato editorial.
2. Use `docsecao` para títulos e `doccodigo`, `doclista`, `docaviso`, `doctabela` ou `docdiagrama` para blocos.
3. Importe a página em `content/catalogo.ts` e inclua-a na lista com `docregistro`. Router, layout, cards e busca não precisam ser alterados.
4. Para uma unit, crie `content/units/nome-da-unit.ts` com `docunit`. O modelo organiza responsabilidade, problema resolvido, estados globais, assinaturas, implementação, dependências e limites.
5. Acrescente métodos e estados com `docunitmetodo` e `docunitestado`. Registre a unit em `content/units/catalogo.ts` com `docregistrounit`.
6. Para diagramas, use `docmermaid` em `docs/MAPEAMENTO_AST_USES_UNITS/<slug>/<nome>.md` e referencie o arquivo com `docdiagrama`.
7. Execute check e build e confira a página no preview. Os 22 snippets de `.vscode/documentacao.code-snippets` usam o escopo TypeScript para os módulos; Mermaid usa Markdown. O guia também está em `/#/guias/autoria`.

## Manutenção de seções e estados

Uma página é registrada no catálogo; uma seção é somente um item de `secoes` nessa página. Use `docsecao` para acrescentar um item com `id` único, `titulo`, `nivel` e `blocos`. Para modificar uma seção, edite esse item e preserve o ID para manter links existentes. A ordem dos itens define a leitura e o sumário. Units usam as listas e os campos de `criarDocumentoUnit` para gerar suas seções.

O campo `estado` pertence à página inteira, descreve o recurso documentado e precisa ser atualizado pelo autor. As opções são `em-desenvolvimento`, `em-uso`, `legado` e `validado-no-erp`. Use `docestado` para substituir o valor existente; não duplique o campo. `em-uso` não implica homologação nem uso obrigatório pelo IRunner. `validado-no-erp` exige `evidenciaValidacao` com `data`, `versaoERP` e `referencia` reais, tanto em páginas comuns quanto em `criarDocumentoUnit`; `docvalidacao` fornece o modelo. Pendências de uma seção podem ser registradas com `docaviso`.

`doccaso` posiciona uma página em Casos de teste → Legado ou IRunner. `docfonte` acrescenta uma referência e `docaliasartefato` registra uma variante de pesquisa de estado global. O import criado por `docregistro` ou `docregistrounit` ainda precisa ser incluído na lista do respectivo catálogo. Use `docgrupo` em `content/navegacao.ts` e `docsubgrupo` no array do grupo para ampliar a navegação; `docnavegacao` posiciona a página ou unit com os IDs registrados. O build rejeita IDs inexistentes ou duplicados, sem necessidade de alterar o router para criar grupos.

Para uma unit de caso de teste, use `docunitjson` dentro de `criarDocumentoUnit`. O campo `jsonBase` contém `exemplo` (objeto JSON), `campos` (caminho, tipo, finalidade e impacto), `observacoes` e `fontes` opcionais. Ele gera a seção JSON base do caso de teste usando o terminal copiável e a tabela compartilhada. Preencha o modelo conforme os consumidores do fonte, registrando valores obrigatórios, padrões e precedência; códigos zero são espaços de preenchimento e não representam registros válidos da base.

As rotas de units usam minúsculas e sublinhados convertidos em hífens: `P39_TDD_IRUNNER` → `/units/p39-tdd-irunner`. Aliases representam variantes documentais dos nomes e não comprovam equivalência das implementações. `ReferenceText` identifica nomes registrados e usa `UnitReference` para produzir links em textos, listas, tabelas, títulos e códigos. Nós Mermaid também podem redirecionar para uma unit. A cópia de códigos preserva o texto literal.

## Navegação e busca

O conteúdo é exibido inteiro, sem painéis expansíveis. O sumário hierárquico acompanha a leitura e permite compartilhar seções como `/#/estrutura/runner?secao=lote`. Cards inteiros são links.

O drawer contém grupos expansíveis para Arquitetura, Units, Helpers, Referências, Casos de teste e Contribuir. Units possui IRunner, Infraestrutura compartilhada, Casos de teste e Faturamento. Helpers possui Financeiro e Sincronização, esta preparada para a próxima iteração. Casos de teste mantém Legado e IRunner. O registro único é `content/navegacao.ts`. Para uma unit, use `navegacao: { grupo: 'units', subgrupo: 'irunner', ordem: 0 }`; para um helper financeiro, troque para `grupo: 'helpers', subgrupo: 'financeiro'`. A ordem é opcional. A rota da página atual abre seus grupos automaticamente e continua no padrão `/units/<slug>` para units, mesmo dentro de Helpers.

A busca usa um índice local ponderado inspirado em BM25, com acentos normalizados, múltiplos termos e prefixos. As declarações de estados e assinaturas recebem prioridade sobre citações no corpo. `RegistrarTick` prioriza P39_TDD_RUNNER; `FCasoTesteAtualJson`, P39_TDD_STARTED. `FCDSCasosTestes` é alias explícito de pesquisa de `CDSCasosTestes`, declarado em P39_TDD_CASOS_DE_TESTE. Registre novas variantes com `aliasesArtefatos: { nomeDeclarado: ['variante'] }` sem renomear o Pascal.

## Mapas e limites

Cada diagrama ativo é lido do subdiretório canônico correspondente ao slug da página. O mapa sintático do Runner está em `runner/P39_TDD_IRUNNER.md` e o inventário em `runner/P39_TDD_IRUNNER.ast.json`, incluindo fontes, linhas, hashes e alcance transitivo. A extração cobre o subconjunto uses e carregamentos literais, sem compilar Pascal ou inferir equivalência entre prefixos.

Mapas anteriores ficam em `docs/MAPEAMENTO_AST_USES_UNITS/historico`, separados por assunto. O mapa atual de dependências do piloto financeiro foi revisto contra o processamento e as units disponíveis. Orientação e zoom afetam apenas a leitura, preservando o Markdown canônico.

Casos de Teste e Parâmetros permanecem dependências em uso no IRunner. A etiqueta geral é “Em uso”, pois o portal também documenta outros contratos. Referências anteriores descrevem seus respectivos contratos. `TDD_ASSERTS` continua pendente e a documentação não declara homologação no ERP.

`tests/`, `tools/`, dependências instaladas e saídas geradas são ignorados pelo Git. O pacote versionado contém somente dependências e scripts necessários ao build, TypeScript e ESLint; os recursos de testes locais da LLM não participam da publicação.
