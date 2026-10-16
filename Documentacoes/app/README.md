# Portal documental TDD

O código fica em `Documentacoes/app`. Vue SFC com `<script setup lang="ts">`, Vuetify, Router e Mermaid são dependências npm compiladas pelo Vite. O resultado é estático, com base `/TestesAutomatizadosERP/` e rotas hash, compatível com GitHub Pages.

## Desenvolvimento

Da raiz do repositório:

```shell
npm ci --prefix Documentacoes
npm run dev --prefix Documentacoes
npm run check --prefix Documentacoes
npm run build --prefix Documentacoes
npm run preview --prefix Documentacoes
```

Use o endereço impresso pelo terminal. Dev compila SFC e atualiza a aplicação durante a edição; preview serve o artefato em `.pages-output`. `check` executa ESLint real sobre TS/SFC e vue-tsc estrito. `index.html` da raiz é a única entrada fonte, e o Vite o transforma no índice do artefato. Nenhum servidor Node é necessário no Pages. O workflow atual valida PRs e publica após alterações autorizadas na master.

## Organização e fronteiras

`components` contém slices por feature, com componentes/views e conteúdo específicos. A hierarquia editorial corresponde à navegação:

- `arquitetura/irunner/conteudo`
- `units/{setup,constantes,persistencia,irunner}/conteudo`
- `casos-de-teste/conteudo`
- `mapeamentos/financeiro/conteudo`
- `helpers/{gerais,sincronizacao}/conteudo`
- `contribuir/conteudo`

Cada slice expõe seus documentos por `index.ts`. `catalogo/index.ts` compõe esses registros públicos. Registre cada documento apenas uma vez: cards, rotas, navegação, pesquisa e citações derivam do mesmo catálogo. Posição/ordem são declaradas pela página em `navegacao`; grupos e subgrupos ficam no registro único `catalogo/grupos.ts`.

`contracts` define o modelo editorial, fábrica de documento de unit, identidade/rota e a porta de referências. `components/descoberta` mantém busca, drawer e cards; `components/leitura` mantém leitor, sumário e blocos; `components/portal` compõe o shell e resolve documentos. Não crie uma view idêntica para cada unit. Use o leitor por dados e acrescente view especializada somente quando precisar de comportamento próprio.

O bounded context identificado é a publicação documental: Documento, Seção, Fonte, Símbolo e Evidência têm regras editoriais próprias. Descoberta é uma capacidade desse contexto; leitura e shell são apresentação. Os grupos IRunner, Financeiro ou Setup descrevem assuntos do ERP e não criam, por si, bounded contexts no frontend. Não replique o estado Pascal em stores da aplicação.

## Dependências, SOLID e DRY

- Conteúdo usa contratos tipados. Catálogo, validação, projeção de menu, ranking e resolução de nomes não dependem de instância Vue, DOM ou Vuetify.
- O leitor recebe documento por prop e referências por uma porta injetada. Não importa catálogo concreto ou conteúdo de outra slice.
- Features consumidoras usam exports públicos dos demais módulos. Componentes usados só por uma feature permanecem locais. Shared, quando necessário, contém somente primitivas genéricas e não importa features.
- SRP separa validar, descobrir e renderizar. OCP permite registrar nova página sem mudar o leitor. LSP permite consumir qualquer IDocumento válido pelo mesmo contrato, sem exceção por nome de unit. ISP evita passar documento inteiro para tabela ou estado de zoom para busca. DIP mantém as operações puras sobre contratos e deixa a composição Vue nos adapters.
- DRY mantém uma definição de identidade/rota, uma posição por documento e uma implementação dos blocos reutilizados. Fluxos citam as páginas de units, sem duplicar suas explicações completas.

## Autoria, fontes e evidência

O guia ativo fica em `components/contribuir/conteudo/autoria.ts`. Snippets da IDE estão em `.vscode/documentacao.code-snippets`; a skill compartilhável do projeto é `.agents/skills/contribuir-documentacao/SKILL.md`. Use os caminhos relativos à profundidade da slice ao criar documentos TypeScript. SFCs podem usar o alias `@` para imports do app.

O nome local real identifica a página de unit. Referência remota, alias de busca e redirect de URL têm finalidades diferentes; não force P39_ em um identificador TDD_RUN_ real. `validado-no-erp` exige data, versão e evidência identificáveis para o contrato atual.

Mermaids permanecem canônicos em `docs/MAPEAMENTO_AST_USES_UNITS/<slug>/`. Exemplos JSON devem estar no conteúdo versionado e não depender de arquivos pessoais ignorados. Fontes e inventários devem ser reconciliados antes de declarar um contrato atualizado. Testes/ferramentas temporários de agentes permanecem em diretórios ignorados.

## Carregamento e identidade visual

`PortalLoading.vue` usa overlay e skeleton nativos, sem card ou indicador circular central durante a carga. O skeleton representa cards ou artigo, espera a rota inicial e permanece ao menos 650 ms, com saída de 240 ms. Movimento reduzido é respeitado. Status acessível é visualmente oculto; recarga visível aparece em falhas. Navegações posteriores não repetem o atraso inicial. Antes do módulo inicial há um placeholder estático independente de Vue.

O favicon fornecido fica em `assets/faviconTDD.png`; o Vite resolve seu endereço e o inclui no artefato. Tipografia, cores e CSS homologados são mantidos em `styles/portal.css`.
