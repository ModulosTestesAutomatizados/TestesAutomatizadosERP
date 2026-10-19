# Alternativas e fronteiras propostas

**Status:** análise inicial para escolher abordagem antes do Design detalhado. Nenhuma decisão AD foi registrada como aprovada.

## Alternativas com o mesmo escopo

| Abordagem | Organização | Benefício | Custo |
| --- | --- | --- | --- |
| A — slices editoriais + capacidades compartilhadas (recomendada) | app/components contém features de leitura/descoberta e slices documentais que refletem os grupos do menu | Atende o mapa, mantém leitor único e torna donos explícitos | Exige contratos de catálogo e regras de import claras |
| B — contextos no primeiro nível de components | Contextos de publicação/descoberta/leitura contêm suas features; hierarquia do menu fica dentro de publicação | Expõe fronteiras semânticas logo na raiz | Distancia a localização das páginas do mapa esperado pelo usuário |
| C — slices por página com views completas | Cada página possui view, dados e componentes próprios; biblioteca de blocos comum | Máxima autonomia visual por página | Muito código semelhante para páginas que só diferem pelo conteúdo; risco de regras divergentes |

Todas usam Vue SFC/Vite, o mesmo conteúdo atualizado e Pages. A recomendação A é uma proposta sujeita à revisão do usuário, não uma arquitetura escolhida implicitamente.

## Vocabulário e bounded contexts candidatos

DDD aqui orienta linguagem e fronteiras em um único frontend. Não implica microserviços, classes de entidades ou um bounded context para cada pasta. Contextos candidatos só viram fronteiras formais se a análise no Design confirmar modelos/regras distintos; uma feature pode ser apenas módulo de um mesmo contexto.

| Fronteira candidata | Linguagem e dono | Regras e modelos | Entrada / saída | Justificativa e decisão proposta |
| --- | --- | --- | --- | --- |
| Publicação documental | Documento, seção, fonte, símbolo, estado, evidência; dono do contrato editorial | Identidade, unicidade, conteúdo, posicionamento editorial, evidência de validação | Definições por slice → catálogo validado | Principal contexto candidato: possui regras próprias e modelo editorial; não representa execução do ERP |
| Descoberta documental | Consulta, resultado, relevância, grupo aberto, destino | Projeção de busca e navegação; resultado ponderado, não proprietário do texto documental | Catálogo somente leitura → resultados/destinos | Candidato secundário; pode permanecer capacidade do mesmo contexto se não houver linguagem/regras suficientemente autônomas |
| Leitura/apresentação | Bloco, sumário, seção ativa, copiar, zoom | Estado visual de leitura e contratos de props/eventos | Documento validado → interface e ações locais | Módulo de apresentação; não presumir bounded context só por existir um renderer |
| Shell/publicação estática | Rota, asset, base, tema, loading | Composição e adaptação para Vue/Router/Vuetify/Vite | Rotas/catálogo → aplicação e artefato | Infraestrutura/composição, não domínio de negócio |

IRunner, Setup, Financeiro e Sincronização são assuntos documentados. O frontend não controla FAssertsTotal, cursor do lote, transação ou parâmetros ERP. Essas responsabilidades pertencem aos fontes Pascal e são descritas pelo conteúdo; não devem virar stores/frontend services para simular o ERP.

## Estrutura indicativa da alternativa A

Nomes e localização de contratos públicos serão fechados no Design. A árvore expressa os donos e a hierarquia; não exige criar subpastas vazias nem uma view para cada folha.

```text
Documentacoes/
  app/
    main.ts
    App.vue
    router/
    styles/
    assets/
    contracts/                 contratos editoriais pequenos e tipados
    components/
      portal/                  shell, home, loading, erro/rota ausente
      descoberta/              busca e navegação; projeções do catálogo
      leitura/                 leitor, blocos, TOC, referências e diagramas
      arquitetura/
        irunner/               conteúdo do fluxo e view especializada se necessária
      units/
        setup/
        constantes/
        persistencia/
        irunner/               contratos TDD_RUN_ e demais units atuais
      casos-de-teste/           cenários financeiro e faturamento
      mapeamentos/
        financeiro/
      helpers/
        gerais/
        sincronizacao/
      contribuir/              guia e exemplos de autoria
      shared/                  primitivas visuais realmente genéricas
    catalogo/                  composição dos registros públicos das slices
  config/                      configuração e validação de build
  vite.config.ts
  package.json
  index.html                   entrada fonte proposta; destino publicado é raiz do artefato
docs/MAPEAMENTO_AST_USES_UNITS/<documentacao>/
.agents/skills/contribuir-documentacao/SKILL.md
```

Uma slice documental pode ter `conteudo/`, um contrato público e componentes/views locais quando necessários. A pasta `units/irunner` não precisa conter uma cópia de DocumentPage para cada fonte. O shell resolve a rota pelo registro público e entrega o documento ao leitor; a slice fornece uma view própria somente quando dados e blocos existentes não expressarem a necessidade.

Os caminhos físicos usam nomes estáveis sem acentos; rótulos de UI continuam em português correto. IDs de grupo existentes não precisam ser iguais ao nome da pasta. Nome real do artefato, nome remoto, slug e alias têm campos e finalidades distintos.

## Dependências e SOLID/DRY

- Contratos editoriais e operações puras não importam Vue, Vuetify ou DOM.
- Slices de conteúdo dependem desses contratos. Catálogo compõe exports públicos e é validado uma vez; menu e busca são projeções dele, sem cadastros paralelos.
- Componentes de leitura recebem documento/blocos por props e emitem ações; não importam todas as páginas.
- Features não importam detalhes internos das outras. Contratos de citação/identidade ficam acessíveis sem dependência circular leitor ↔ catálogo.
- Shared não conhece conteúdo, catálogo ou features. Um componente usado só por uma feature permanece local até surgir reutilização real.
- SRP: validação editorial, ranking e renderização têm motivos distintos para mudar. OCP: adicionar conteúdo com blocos existentes não altera o leitor. LSP: qualquer documento válido pode ser consumido pelo mesmo leitor/contrato, sem exceção por nome de unit. ISP: busca não recebe estado de zoom/DOM e tabela não recebe o documento inteiro. DIP: regras puras operam sobre contratos/dados, adapters Vue/Vite realizam composição.
- DRY: reutilizar regra e componente; texto de responsabilidades de units mantém uma definição canônica. As visões de fluxo referenciam as unidades, sem copiar sua página inteira.

## Preservação e transição

Migrar infraestrutura e conteúdo em etapas verificáveis. A baseline deve registrar rotas, identidades, estados, busca e assets antes das alterações. A atualização de nomes deve gerar uma tabela com destino explícito por rota renomeada; alias lexical não atende esse contrato. Páginas excluídas anteriormente pelo usuário continuam ausentes.

O Vite assume compilação, bundling e preview; validação documental e preparação dos diagramas permanecem como responsabilidade explícita do build. Não apagar verificações de hashes, referências e fontes ao substituir build.mjs. Os arquivos canônicos Mermaid permanecem fora do frontend; somente os assets requeridos são incluídos no artefato publicado.

A posição definitiva do HTML fonte, a saída do build e a compatibilidade do index da raiz do repositório serão decididas em Design junto do workflow. O artefato sempre terá index.html na raiz e base Pages correta. Não manter dois HTMLs independentes que exijam atualização manual equivalente.

## Risks & Concerns

| Evidência atual | Risco | Mitigação proposta |
| --- | --- | --- |
| app/types/runtime.d.ts e templates em strings | Falsa sensação de tipagem de template | SFC e vue-tsc; retirar declarações globais legadas |
| config/build.mjs fixa caminho do AST antigo | Renome deixa build dependente de arquivo obsoleto | Fonte de configuração única para inventários, migração coordenada e validação em Linux |
| app/router.ts resolve categorias por regex fixa | Feature nova exige modificar roteamento genérico | Contrato de registro/rota no Design e teste de registro representativo |
| app/pages/DocumentPage.ts importa catálogo e escolhe apresentação | Acoplamento entre obtenção e renderização | Resolver em composição e passar documento ao leitor |
| Pascal local removido/renomeado e snapshot externo com conteúdo sem commit | Documentar contrato antigo ou copiar fonte incompleto | Manifesto reconciliado antes da edição; não sincronizar worktrees automaticamente |
| pacote externo cita páginas já excluídas do portal | Reintroduzir lixo ou conteúdo duplicado | Matriz funcional de destino atual, não aplicação literal dos paths antigos |
| snippets usam paths relativos do layout anterior | Autoria gera exemplo quebrado | Expandir exemplos representativos após fechar aliases/layout e rodar check |
| árvore do menu usada como arquitetura completa | Boundaries artificiais e wrappers vazios | Contextos justificados por modelo/regra; leitor e lógica pura compartilhados |

## Pesquisa

O código atual e as decisões locais foram lidos antes das fontes externas. Context7 não estava exposto nesta sessão.

- [Vue SFC](https://vuejs.org/guide/scaling-up/sfc.html): componentes compilados com template/script/style.
- [script setup](https://vuejs.org/api/sfc-script-setup.html): sintaxe compilada para Composition API em SFC.
- [Vite / Pages](https://vite.dev/guide/static-deploy.html#github-pages): build estático e configuração base para repositório.
- [Bounded Context](https://martinfowler.com/bliki/BoundedContext.html): delimitação de aplicação de modelos e suas relações; a análise de fronteiras acima é proposta específica deste projeto.
