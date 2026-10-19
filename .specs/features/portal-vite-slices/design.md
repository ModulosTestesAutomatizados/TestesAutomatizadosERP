# Design: portal Vite por slices

Status: implementação autorizada pelo usuário após revisão da spec em 2026-10-16. Alternativa A, recomendada na proposta aprovada.

## Architecture Overview

Publicação documental é o bounded context do frontend: Documento, Seção, Símbolo, Fonte e Evidência têm regras editoriais próprias. Descoberta é uma capacidade interna, com projeções de navegação/relevância, sem modelo autônomo suficiente para impor outro bounded context. Leitura e shell são módulos de apresentação/infraestrutura. Os grupos do mapa representam o domínio descrito, não contextos executáveis no frontend.

Slices editoriais ficam em app/components/{arquitetura,units,casos-de-teste,mapeamentos,helpers,contribuir}, com os subgrupos do mapa. Cada slice exporta documentos por index.ts. Views dirigidas por dados usam o mesmo leitor; não criar SFCs vazios por folha. app/catalogo compõe somente esses exports públicos. app/contracts contém modelos editoriais, identidade/rotas e portas tipadas. app/components/leitura recebe documento via prop e referências por porta injetada; não conhece o catálogo concreto. Descoberta recebe documentos via props. Portal/router compõem dependências.

## Components and Interfaces

| Dono | Contrato público | Dependências |
| --- | --- | --- |
| contracts/documentacao.ts | IDocumento, IDadosUnit, ISecao, TBloco | Tipos TypeScript |
| contracts/identidade.ts | slugUnit, rotaDocumento, estados | Modelo editorial |
| contracts/referencias.ts | IReferenciasUnits e chave de injeção | Modelo; tipo InjectionKey apenas |
| catalogo/index.ts | documentos e registro tipado | index.ts das slices editoriais |
| catalogo/referencias.ts | criarReferenciasUnits(documentos) | Contratos; nenhuma dependência Vue/DOM |
| catalogo/validarCatalogo.ts | validarCatalogo(documentos) → string[] | Modelos e grupos registrados |
| descoberta/index.ts | DocumentSearch, NavigationGroup, RedirectCard e projeções puras | Contratos; componentes recebem dados |
| leitura/index.ts | DocumentoView, ReferenceText | Contratos; leitor recebe documento; referências injetadas |
| portal | AppLayout, PortalLoading, HomeView, DocumentRoute, NotFoundView | Exports públicos de descoberta/leitura, catálogo na composição |

## Build e publicação

Vite 8.3.4, plugin-vue 6.0.10 e vue-tsc 3.3.13 são compatíveis com Node >=24 já exigido. Preservar Vue/Router/Vuetify/Mermaid atuais; estilos Vuetify e fonte MDI são imports npm. Mermaid usa import dinâmico local com securityLevel strict. Nenhuma dependência runtime via CDN.

Manter index.html fonte na raiz do repositório como entrada única, root Vite na raiz e config em Documentacoes/vite.config.ts. Assim não criar um segundo HTML nem alterar URLs públicas. Vite resolve dependências a partir dos imports em Documentacoes. Artefato em Documentacoes/.pages-output, base /TestesAutomatizadosERP/, hash routing. Build plugin confere catálogo, fontes, capitalização real e inventários; copia somente os Markdown Mermaid e inventários necessários. Em dev, serve os mesmos assets canônicos pelo middleware. Não copiar docs/assets ou .specs inteiros para a publicação.

## Reuse e SOLID

Preservar políticas de ranking, controles Mermaid, conteúdo dos componentes e CSS homologado. Migrar templates string para SFC real. Código copiável usa a mesma string no clipboard; referência visual não altera o literal. LSP aplica-se ao contrato de Documento, sem herança artificial. SRP separa registrar/validar, buscar e renderizar. OCP permite incluir documento sem mudar leitor. ISP entrega props e porta pequenas. DIP entrega o catálogo resolvido por composição e referência por porta. DRY mantém identidade/rota/menu e blocos em donos únicos.

## Error Handling Strategy

Bootstrap estático independente de Vue mostra erro/recarga em falha do módulo inicial. Após montagem, PortalLoading controla pronto/erro e interação, sem card durante loading. Falha posterior de chunk de rota tem alerta e recarga. Diagrama indisponível tem diagnóstico, referência à fonte e retry. Rota inexistente tem página 404 interna. Erros editoriais impedem build com caminho/documento causador.

## Risks & Concerns

- build.mjs fixa AST antigo; substituir por manifesto explícito de inventários e validar todos os nós com origem local.
- Pascal local diverge do pacote estabilizado; conteúdo fica condicionado à reconciliação. Nenhum byte Pascal será alterado pelo agente. Questão enviada ao usuário enquanto infraestrutura avança.
- Módulo de citações atual importa catálogo e pode criar ciclo no leitor; usar fábrica pura e porta injetada no App.
- Templates opcionais ocultavam erros; vue-tsc strict detectará props/eventos DOM que serão corrigidos na migração.
- Snippets dependem de paths antigos; gerar exemplos contra estrutura final, sem publicar ferramentas temporárias.
- Navegação antiga por regex deve ser substituída por registro de documentos e redirects explícitos, sem ressuscitar rotas excluídas.

## Verificação proporcional

Preservar baseline de catálogo/rotas em arquivo local ignorado. Check real com ESLint e vue-tsc; bundle Vite e testes locais de contratos puros no momento da migração. Após conteúdo/grafos: build completo com validações, smoke Pages desktop/mobile com CDN bloqueada e conferência editorial dos DOC-01..18. Testes e scripts auxiliares permanecem ignorados conforme usuário. Verificador TLC independente ao terminar a última tarefa.
