# Portal estático de documentação TDD do ERP

**Status:** Especificação histórica aprovada em 2026-10-06. A revisão [design-vuetify.md](design-vuetify.md), aprovada em 2026-10-13 com autorização de implementação, prevalece para stack, escopo e autoria. Os requisitos anteriores de PrimeVue e catálogo ampliado abaixo são preservados como histórico, sem representar a iteração atual.
**Data:** 2026-10-06.
**Método:** TLC Spec Driven, complexidade Large. Specify aprovado; [design.md](design.md) produzido. Tasks e Execute seguem as revisões do fluxo TLC.
**Issue:** [#22](https://github.com/ModulosTestesAutomatizados/TestesAutomatizadosERP/issues/22), body integral em [issue-22.md](issue-22.md).
**Base:** [context.md](context.md) e [analise.md](analise.md). Restrições posteriores do usuário: GitHub Pages, entrada na raiz e Vue Router.

## Problem Statement

A documentação está distribuída entre cinco HTMLs Bootstrap, diagramas HTML/Markdown, fontes Pascal e especificações internas. Os HTMLs repetem apresentação e scripts e descrevem contratos que divergem do Runner refatorado. A equipe precisa de um portal estático navegável, com responsabilidade e estado de cada unit explícitos, catálogo dos casos e autoria de novas documentações sem duplicar layout.

## Goals

- [ ] Uma entrada `index.html` na raiz e uma aplicação Vue com PrimeVue e Vue Router via CDN, sem build obrigatório.
- [ ] Uma estrutura comum para conceitos, units, exemplos, diagramas e documentação de casos.
- [ ] Migração dos quatro documentos de detalhe e da apresentação existentes, com revisão dos contratos.
- [ ] Catálogo inicial de Documento Fatura/Pedido de Venda e Financeiro.
- [ ] Um snippet de conteúdo que permita acrescentar documentação sem editar layout ou router.
- [ ] Publicação estática no GitHub Pages com links internos que sobrevivem a recarregamento.

## Out of Scope

| Feature | Reason |
| --- | --- |
| Concluir ou corrigir Runner, fixtures e asserts Pascal | A issue é documental; problemas do runtime são registrados com sua evidência |
| Executar SQL, migrations ou testes no ERP | Não é necessário para especificar/publicar documentação e pode modificar dados |
| Backend, CMS e autenticação | Conteúdo estático mantido no repositório |
| Consultar dados do ERP, TekStore ou GitHub em runtime | O site não depende de credenciais nem serviço de dados |
| Editor/gerador de casos no navegador | Snippet é receita de autoria versionada, não interface de cadastro |
| Busca global e filtros avançados | Navegação, índice e catálogo atendem à entrega inicial |
| Vite, SFC, SSR e geração estática obrigatória | Pedido exige uso via CDN; ferramentas de validação não alteram essa restrição |
| Tornar Faturamento legado compatível com a casca nova | Exige mudança funcional própria, sobretudo no controle do cursor |
| Declarar homologação ou migration aplicada sem evidência | Documentação não substitui validação no ERP |
| Alterar o body, fechar a issue ou ajustar Projects nesta entrega de spec | O portal ainda não foi entregue |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Stack e entrada | Vue 3 e PrimeVue via CDN, Vue Router, index na raiz como bootstrap | Instruções explícitas do usuário | Sim |
| Hospedagem | GitHub Pages | Instrução posterior explícita | Sim |
| Conteúdo | Documentação estática de TDD ERP e catálogo de Documento Fatura/Financeiro | Issue #22 | Sim |
| Routing mode | `createWebHashHistory()` preservando pathname do site | Pages não oferece fallback SPA configurável por rota | Não, proposta |
| Versões | Fixar versões exatas compatíveis de Vue, Router, PrimeVue, tema e Mermaid no design | Consultas retornam exemplos de majors distintos; pinning evita atualização silenciosa | Não, proposta; gate no design |
| Organização física | `index.html` na raiz do repo; código do portal em `Documentacoes/app/` | Reaproveita pasta e separa entrada de layout/conteúdo | Não, proposta |
| Autoria | Módulos JavaScript de dados com export e catálogo de registros | Reutilização sem build e sem arquivos JSON ignorados | Não, proposta |
| Estado documental | `Legado`, `Em desenvolvimento`, `Validado no ERP` | Fontes locais e spec não comprovam homologação | Não, proposta |
| Estado inicial | Runner/piloto: Em desenvolvimento; Faturamento atual: Legado | Não há prova de adaptação nem homologação desta refatoração | Não, classificação proposta |
| Catálogo inicial | Documento Fatura, três cenários de Pedido existentes e Financeiro | Escopo da issue e materiais já disponíveis | Não, seleção proposta |
| Publicação técnica | Actions prepara artefato selecionado do portal; deploy após aceite de entrega | Evita empacotar indiscriminadamente o repositório e não exige compilação de frontend | Não, proposta |
| Origem/branch de publicação | Usar branch padrão efetivamente consultada no design; não assumir nome `main` | Workspace está em master, sem consulta ao setup Pages nesta entrega | Não, proposta |
| Links antigos | Cinco index legados viram redirecionamentos com link visível após revisão da migração | Há caminhos locais existentes, sem publicação atual comprovada | Não, proposta |
| Renderização editorial | Blocos tipados; rich text estático escrito como componente quando necessário | Evita HTML legado injetado e scripts duplicados | Não, proposta |
| Banco e configurações | Documentar dedicated DB versus tabelas do ERP, sem acesso em runtime | Os fontes mostram responsabilidades distintas | Não, contrato editorial derivado das fontes |
| Migration de logs | Descrever alteração prevista e ausência do arquivo local; não fornecer download | MER referencia arquivo que não está disponível | Não, fato do snapshot |
| Evidência funcional | Exigir referência identificável antes de usar Validado no ERP | Nenhuma execução ERP foi feita nesta análise | Não, proposta |
| Fontes de casos duplicadas | Validar correspondência de conteúdo e nome; documentar ausência de fonte verificável quando não recuperável | Dez arquivos de Faturamento e sete de Financeiro repetem conteúdo; recuperar fonte não é autorizado por esta análise | Não, fato e proposta de tratamento |
| Escopo desta sessão | Gerar análise/contexto/spec; portal será outra etapa | Pedido original termina em geração da especificação | Sim, interpretação do escopo solicitado |

**Open questions:** none - as ambiguidades receberam default e justificativa acima. Defaults não equivalem a aprovação; podem ser alterados na revisão. A escolha das versões exatas pertence ao design e bloqueia implementação/publicação até a prova de compatibilidade CDN.

## User Stories

### P1: Acessar e navegar no portal publicado

**User Story:** Como desenvolvedor ou executor de testes, quero abrir e compartilhar uma documentação específica para encontrar o mesmo conteúdo ao recarregar a página.

**Acceptance Criteria**:
1. The portal SHALL manter na raiz do repositório um `index.html` sem conteúdo editorial de documentação, contendo apenas metadados, assets, ponto de montagem e mensagens de bootstrap. (DOC-01)
2. The portal SHALL carregar Vue 3, Vue Router compatível, PrimeVue, seu tema e Mermaid por URLs CDN com versões exatas documentadas. (DOC-02)
3. The portal SHALL funcionar por HTTP estático sem execução obrigatória de npm, bundler ou compilação de SFC. (DOC-03)
4. WHEN uma rota conhecida é aberta diretamente ou recarregada THEN o portal SHALL apresentar o documento correspondente usando Vue Router com hash. (DOC-04)
5. WHEN o site é servido no prefixo `/TestesAutomatizadosERP/` THEN o portal SHALL resolver todos os assets locais dentro desse prefixo. (DOC-05)
6. WHEN o usuário aciona voltar ou avançar no navegador THEN o portal SHALL apresentar a rota e o item de navegação correspondentes à entrada do histórico. (DOC-06)
7. IF uma rota ou slug não existe THEN o portal SHALL mostrar `Documentação não encontrada` com link para o catálogo. (DOC-07)

**Independent Test:** Servir os arquivos sob raiz local e sob `/TestesAutomatizadosERP/`; abrir `/#/estrutura/runner`, recarregar, navegar entre dois documentos e voltar; acessar slug inexistente. Em subpath, zero 404 de assets locais.

### P1: Ler conteúdos com componentes reutilizáveis

**User Story:** Como leitor, quero encontrar os documentos com a mesma estrutura para consultar definições, artefatos, instruções, configuração e limitações.

**Acceptance Criteria**:
1. The portal SHALL usar um único layout compartilhado para menu, título do documento e área de leitura. (DOC-08)
2. The portal SHALL disponibilizar componentes reutilizáveis para seção, tabela de responsabilidades, aviso, bloco de código e diagrama. (DOC-09)
3. WHEN um documento é selecionado THEN o portal SHALL exibir seu título, resumo, módulo/área quando aplicáveis e estado documental. (DOC-10)
4. WHEN uma seção é expandida ou recolhida THEN o portal SHALL atualizar somente o estado dessa seção, sem depender da função global `ocultar` ou de `onclick` inline. (DOC-11)
5. WHEN o viewport possui largura de 360 pixels THEN o portal SHALL manter o menu acessível e restringir a rolagem horizontal a tabelas, código e diagramas que excedam o espaço disponível. (DOC-12)
6. WHEN o leitor navega exclusivamente por teclado THEN o portal SHALL permitir acessar links e controles de seção com foco visível. (DOC-13)
7. WHEN a rota muda THEN o portal SHALL atualizar `document.title` para o título do documento seguido de ` | TDD ERP`. (DOC-14)

**Independent Test:** Abrir dois documentos que reutilizam seções de mesmo tipo; recolher uma sem afetar outra; inspecionar layout a 360 e 1280 pixels; navegar sem mouse e conferir título da aba em cada rota.

### P1: Entender a arquitetura e o estado real da refatoração

**User Story:** Como mantenedor de TDD, quero entender a responsabilidade de cada unit e distinguir o que existe localmente do que foi homologado para não copiar contratos antigos como atuais.

**Acceptance Criteria**:
1. The documentação SHALL incluir visão geral, arquitetura/Runner, units de base, casos de teste, parâmetros, modelo de dados e guia de autoria. (DOC-15)
2. WHEN a documentação do Runner é aberta THEN o portal SHALL apresentar o fluxo `SetTDDUnit → AddParamsRun módulo/área → Executar → Interpretar → ExecutarLote → Run → Started → Teste → RegistrarMetricas`, identificado como `Em desenvolvimento`. (DOC-16)
3. The documentação SHALL manter `AddUsesUnit`, `AddMetodo` e execução por descrição apenas em conteúdo explicitamente identificado como `Legado`. (DOC-17)
4. WHEN uma unit de base é apresentada THEN a documentação SHALL informar responsabilidade, entradas públicas relevantes, dependências e referência ao fonte correspondente. (DOC-18)
5. WHEN o leitor consulta resultados do novo Runner THEN a documentação SHALL identificar `ASSERTS` e persistência de `METRICAS_ASSERTS` como pendentes, sem atribuir aprovação funcional a `SUCESSO`. (DOC-19)
6. WHEN o leitor consulta parâmetros THEN a documentação SHALL descrever a propagação de erro em `AtualizarParametros`, a ausência de restauração automática e a distinção entre configuração global e por empresa conforme os fontes analisados. (DOC-20)
7. WHEN o leitor consulta histórico/modelo de dados THEN a documentação SHALL identificar a renomeação de logs como prevista e a divergência `VERSAO_INCOMPATIVEL` no fonte versus `INCOMPATIVEL_VERSAO` no MER. (DOC-21)
8. IF um documento usa o estado `Validado no ERP` THEN a documentação SHALL conter uma referência de evidência funcional com data e versão ERP. (DOC-22)

**Independent Test:** Comparar as páginas ao molde, Started, Finished, LOGS, CASOS_DE_TESTE, CACHE e PARAMETRO. Conferir o inventário obrigatório abaixo; buscas pelas APIs antigas devem apontar somente seções de legado. Conferir que não há badge de validação sem evidência.

### P1: Consultar o catálogo de casos e cenários

**User Story:** Como autor ou executor, quero localizar Documento Fatura e Financeiro com pré-requisitos, entradas, fluxo e limites para entender os casos já desenvolvidos.

**Acceptance Criteria**:
1. WHEN o catálogo é aberto THEN o portal SHALL listar Documento Fatura/Pedido de Venda e Financeiro com links para detalhes. (DOC-23)
2. WHEN um caso é aberto THEN o portal SHALL mostrar objetivo, módulo/área, unit de entrada, pré-requisitos, JSON de entrada, expectativa/limite da validação, fluxo, dependências e observações. (DOC-24)
3. WHEN Documento Fatura é aberto THEN o portal SHALL disponibilizar os cenários `PEDIDO COM DESCONTO PERCENTUAL`, `PEDIDO POR UNIDADE FABRIL` e `PEDIDO COM SEQUENCIA NOS ITENS`, vinculados às respectivas units JSON existentes. (DOC-25)
4. WHEN Financeiro é aberto THEN o portal SHALL distinguir o piloto por lote da suíte anterior, incluindo duplicatas receber/pagar e borderôs receber/pagar na ordem observada. (DOC-26)
5. The documentação SHALL identificar o loop próprio de Documento Fatura como legado não adaptado à casca por lote. (DOC-27)
6. WHEN uma entrada descreve uma validação ainda não implementada THEN o portal SHALL exibi-la como pendência junto da referência, sem fabricar resultado esperado aprovado. (DOC-28)

**Independent Test:** Abrir cada caso pelo catálogo, identificar a origem dos dados e chegar aos três cenários de Pedido. Conferir que o sincronizador financeiro legado usa a área `BORDERÔ` e o processamento novo informa FINANCEIRO/FINANCEIRO, sem unificar os dois cadastros por hipótese. Nas referências JSON de Pedido, distinguir nomes confirmados no sincronizador de conteúdo ainda não comprovado nos arquivos duplicados.

### P1: Ler e compartilhar diagramas e exemplos

**User Story:** Como leitor técnico, quero ver os fluxos e copiar os exemplos preservando o conteúdo para entender e reproduzir a estrutura documental.

**Acceptance Criteria**:
1. WHEN uma rota com diagrama é exibida após navegar de outra página THEN o portal SHALL renderizar o diagrama Mermaid desse documento. (DOC-29)
2. WHEN um diagrama de dependências é apresentado THEN o portal SHALL distinguir dependências diretas, transitivas e externas por legenda textual. (DOC-30)
3. IF a renderização de um diagrama falha THEN o portal SHALL mostrar `Diagrama indisponível` e o texto Mermaid original, mantendo o restante do documento legível. (DOC-31)
4. WHEN um exemplo Pascal, JSON ou Mermaid é exibido THEN o portal SHALL apresentá-lo como texto literal, sem interpretar seu conteúdo como HTML ou ação ERP. (DOC-32)
5. WHEN o usuário copia um bloco de código com a API de clipboard disponível THEN o portal SHALL copiar exatamente o conteúdo do bloco e informar `Código copiado`. (DOC-33)
6. IF a cópia automática está indisponível ou falha THEN o portal SHALL manter o bloco selecionável e informar `Selecione o código para copiar`. (DOC-34)

**Independent Test:** Navegar duas vezes para um documento com Mermaid; testar fluxo genérico, mapa financeiro e mapa de Pedido. Injetar Mermaid inválido em cópia de teste, verificar fallback. Exibir `<script>` como exemplo inerte e comparar texto copiado com a origem.

### P1: Registrar a documentação de um novo caso

**User Story:** Como desenvolvedor de um caso novo, quero copiar um registro de documentação e adicionar seu conteúdo ao catálogo para entregar código e documentação juntos sem refazer a interface.

**Acceptance Criteria**:
1. WHEN o guia de autoria é aberto THEN o portal SHALL oferecer um snippet completo com os campos e blocos do contrato descrito nesta especificação. (DOC-35)
2. WHEN um módulo de documento válido é acrescentado e referenciado uma vez no catálogo THEN o portal SHALL disponibilizar seu item e sua rota `/casos/:slug` sem alteração do layout, dos componentes ou da tabela de rotas. (DOC-36)
3. IF um registro possui slug repetido ou campo obrigatório vazio THEN a validação do catálogo SHALL reprovar o registro com identificação do slug/campo antes da publicação. (DOC-37)
4. WHEN o autor segue o guia para um caso novo THEN a documentação SHALL indicar como preencher unidades/fontes, pré-requisitos, dados, expectativa, diagrama e estado de validação. (DOC-38)
5. WHEN uma entrega inclui novo caso de teste THEN o checklist documental SHALL exigir a inclusão ou atualização do registro correspondente no catálogo. (DOC-39)

**Independent Test:** Usar o snippet para um caso temporário em cópia do site; acrescentar um único import/registro no catálogo e verificar card e rota sem modificar router. Testar slug duplicado e título vazio: validação deve falhar identificando cada problema. O caso temporário não integra a publicação final.

### P1: Migrar e publicar uma documentação sustentável

**User Story:** Como responsável pela documentação, quero publicar apenas os arquivos do portal e manter os conteúdos existentes acessíveis para disponibilizar a entrega da issue no Pages.

**Acceptance Criteria**:
1. The migração SHALL mapear cada seção editorial dos quatro HTMLs existentes para um documento novo ou uma referência de legado, registrando sua origem e destino. (DOC-40)
2. WHEN a migração dos cinco HTMLs é concluída THEN seus caminhos antigos SHALL encaminhar para as rotas equivalentes e apresentar link visível para o destino. (DOC-41)
3. The pacote de publicação SHALL conter `index.html` na raiz e somente os arquivos da aplicação e recursos documentais selecionados para o portal. (DOC-42)
4. WHEN o portal é publicado no GitHub Pages THEN sua URL SHALL abrir visão geral, catálogo e detalhe de um caso em acesso direto e após recarregamento. (DOC-43)
5. IF Vue, Router, PrimeVue ou tema não podem ser carregados THEN a entrada SHALL exibir `Não foi possível carregar a documentação. Recarregue a página.` em vez de área vazia. (DOC-44)
6. WHEN JavaScript está desativado THEN a entrada SHALL apresentar `Ative o JavaScript para acessar a documentação.`. (DOC-45)
7. WHEN a documentação técnica é entregue THEN o repositório SHALL incluir instruções para prévia HTTP, atualização do catálogo, validação e publicação no Pages. (DOC-46)
8. IF um fonte local não corresponde ao contrato documentado ou é uma cópia de outro papel THEN a documentação SHALL identificar `Fonte não verificada` junto dessa referência até haver fonte correspondente comprovado. (DOC-47)

**Independent Test:** Verificar manifesto origem/destino, cinco redirecionamentos, conteúdo do artefato e ausência de configs/especificações/SQL. Conferir hashes e conteúdo dos fontes usados nas receitas; referência sem comprovação mostra o aviso definido, sem ser tratada como exemplo executável. Bloquear cada dependência essencial em separado e testar JavaScript desativado. Após deploy autorizado, registrar a URL e evidência de rota recarregada no Pages real.

## Conteúdo obrigatório e responsabilidades

| Grupo | Cobertura mínima | Origem principal |
| --- | --- | --- |
| Apresentação | O que é TDD ERP, como ler o portal e estados de evolução | `Documentacoes/index.html` e issue #22 |
| Arquitetura | Ciclo de interpretação, lote, tentativa, memória compartilhada e limites do host | Runner, mapa financeiro e spec do lote |
| Runner | As sete units rastreadas no diretório Runner, mais piloto financeiro | `docs/assets/emDesenvolvimento/` |
| Base | CASOS_DE_TESTE, CACHE, CONSTANTES, FUNCOES_JSON, ODBC, PARAMETRO, PARAMETRO_MAPEAMENTO, registro e sincronização de casos | Fontes em `configuracoesGerais/` e demais referências locais |
| Asserts | Responsabilidade das referências ASSERTS/VALIDAR_GENERICO/FAT_VALIDAR_RESULTADO e limites atuais | Fonte existente ou dependência externa identificada; sem inventar implementações |
| Dados | CASO_TESTE, HISTORICO_EXECUCAO, METRICAS_TICK_DIFF, METRICAS_ASSERTS e configurações por módulo | MER e fontes; estado da migration explícito |
| Estratégias | Data-driven por JSON, ODBC centralizado, mapeamentos de tela, herança de uses, controle do cursor e reutilização | Fontes + análise; motivo/problema resolvido por estratégia |
| Documento Fatura | Componentes, dados, precedência de entradas, três cenários, fluxo e limites de cada versão de comparação | HTML, sincronizador e fontes de Faturamento; duplicações identificadas |
| Financeiro | Suíte anterior, piloto refatorado, quatro operações, tags obrigatórias/opcionais e teardown | Financeiro e piloto local |
| Autoria | Documentar um novo caso, cadastrar no catálogo e atualizar diagrama específico | Snippet e checklist |

Referências sem fonte local devem aparecer como dependência externa, com limite da evidência. Não documentar toda a biblioteca JvInterpreter como parte desta feature.

## Organização e navegação propostas

`index.html` é a entrada. O layout é um componente da aplicação; a home é uma rota, sem conteúdo editorial no HTML de bootstrap. Arquivos locais usam caminhos relativos e respeitam maiúsculas/minúsculas do GitHub Pages.

```text
index.html
Documentacoes/
  app/
    main.js
    router.js
    components/
    pages/
    content/
      catalogo.js
      estrutura/
      casos/
    styles/
    templates/
  README.md
  01-Processo-Runner-Orquestrador/index.html  (redirecionamento após migração)
  02-Caso-de-Teste/index.html               (redirecionamento após migração)
  03-Parametro/index.html                  (redirecionamento após migração)
  04-Documento-Fatura/index.html           (redirecionamento após migração)
  index.html                              (redirecionamento após migração)
```

O design decide nomes finais dos arquivos mantendo essas responsabilidades. O catálogo define documentos, não um registro dinâmico de código remoto. Componentes Vue são módulos JS locais; o build completo de produção de Vue inclui compilador de templates. Não carregar `.vue` diretamente nem usar distribuição runtime-only com templates não compilados. PrimeVue usa a distribuição UMD e um tema compatível, registrados uma vez no bootstrap, conforme a [documentação CDN](https://primevue.org/cdn).

| Rota lógica | Página |
| --- | --- |
| `/` | Visão geral |
| `/estrutura/runner` | Refatoração e fluxo do Runner |
| `/estrutura/units` | Responsabilidades/dependências das units |
| `/estrutura/casos-de-teste` | Dados, cadastro e sincronização |
| `/estrutura/parametros` | Aplicação e limites dos parâmetros |
| `/estrutura/modelo-de-dados` | MER e alteração prevista de logs |
| `/casos` | Catálogo |
| `/casos/:slug` | Documento/caso declarativo |
| `/guias/novo-caso` | Snippet e checklist de autoria |
| `/legado/runner` | Contrato anterior, explicitamente histórico |
| Rota não reconhecida | Documentação não encontrada |

Seções usam IDs derivados de documento e seção, sem colisões. A tabela de responsabilidades preserva variantes `TDD_*`/`P39_TDD_*` como destinos diferentes da mesma unit, quando comprovado. A página de caso separa cenário de dados da fixture que o executa; slug é identificador documental estável e não substitui ID/descrição no banco.

## Contrato do snippet de documentação

O snippet registra **documentação no portal**, não cadastra nem executa casos no ERP. O guia aponta separadamente para o processo de cadastro do banco dedicado. O mesmo contrato deve ser usado pelos casos iniciais para provar reutilização.

Campos obrigatórios: `slug`, `titulo`, `resumo`, `modulo`, `area`, `estado`, `unitEntrada`, `fontes`, `secoes`. Slug é único em todo o catálogo, em kebab-case ASCII (`^[a-z0-9]+(?:-[a-z0-9]+)*$`). `estado` admite somente `legado`, `em-desenvolvimento`, `validado-no-erp`. Cada fonte exige caminho/nome e classificação `local` ou `externa`. Fontes externas não recebem download local fictício. Estado validado exige `evidenciaValidacao` com data, versão ERP e referência.

Seções de caso: definições, artefatos, instruções, configuração e observações, com IDs únicos dentro do documento. Tipos mínimos de bloco: `paragrafo`, `lista`, `tabela`, `codigo`, `aviso`, `mermaid`. Bloco de código contém linguagem e texto; aviso contém severidade e texto; tabela contém colunas e linhas. Blocos preservam texto literal. Um campo `fontes` ou bloco pode apontar à evidência original sem expor uma cópia integral do código Pascal no pacote publicado.

Exemplo de autoria para especificar o contrato; o arquivo abaixo será fornecido como template na implementação:

```javascript
export default {
  slug: 'novo-caso-exemplo',
  titulo: 'Novo caso de teste',
  resumo: 'Objetivo de negócio e comportamento que este caso observa.',
  modulo: 'MODULO DO CASO',
  area: 'AREA DO CASO',
  estado: 'em-desenvolvimento',
  unitEntrada: 'P39_TDD_NOVO_CASO',
  fontes: [
    { caminho: 'docs/assets/casosTestesModulo/P39_TDD_NOVO_CASO.pas', tipo: 'local' }
  ],
  secoes: [
    {
      id: 'definicoes', titulo: 'Definições',
      blocos: [{ tipo: 'paragrafo', texto: 'Objetivo, cenário e limite da validação.' }]
    },
    {
      id: 'artefatos', titulo: 'Artefatos',
      blocos: [{ tipo: 'tabela', colunas: ['Unit', 'Responsabilidade'],
        linhas: [['P39_TDD_NOVO_CASO', 'Executa o comportamento do cenário.']] }]
    },
    {
      id: 'uso', titulo: 'Instruções de uso',
      blocos: [
        { tipo: 'lista', itens: ['Descrever a preparação da massa.', 'Descrever a entrada de execução no ERP.'] },
        { tipo: 'codigo', linguagem: 'json', codigo: '{"parametros":{}}' },
        { tipo: 'paragrafo', texto: 'Informar o resultado esperado e como verificá-lo; comparação ainda pendente neste exemplo.' },
        { tipo: 'mermaid', codigo: 'flowchart TD\n  Preparacao --> Teste\n  Teste --> Encerramento' }
      ]
    },
    {
      id: 'configuracao', titulo: 'Instalação e configurações',
      blocos: [{ tipo: 'lista', itens: ['Listar cadastros, versão, units e parâmetros necessários.'] }]
    },
    {
      id: 'observacoes', titulo: 'Observações importantes',
      blocos: [{ tipo: 'aviso', severidade: 'warn',
        texto: 'Exemplo de autoria. Substitua os dados e referências; não representa caso homologado.' }]
    }
  ]
};
```

No catálogo, a receita será um import local e uma inclusão no array único de documentos. O template contém campos ilustrativos intencionais; antes de publicar um documento real, referências locais devem existir e o conteúdo deve descrever o caso. A validação do catálogo cobre campos obrigatórios, enum, slugs/IDs duplicados e tipos de bloco. A revisão editorial cobre veracidade e expectativa do teste. Um teste com registro sintético deve provar que o router genérico não precisa ser editado.

## Migração editorial

O manifesto de migração terá origem, seção, destino e ação (`migrado`, `corrigido`, `legado`). Cada heading relevante dos quatro documentos de detalhe recebe destino. Textos repetidos podem ter o mesmo destino centralizado, com a relação registrada.

Primeiro migrar conceitos e contratos; depois documentos de casos e diagramas; por último substituir os HTMLs antigos por entradas de redirecionamento. Exemplos `EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas` e `codigo-gerado-financeiro.pas` serão identificados como snapshots divergentes, não templates atuais. Diagramas de dependências existentes devem ser conciliados com as fontes da versão correspondente.

A migration de logs ausente será citada como pendência sem link quebrado. Dez fontes de Faturamento e sete de Financeiro com conteúdos repetidos exigem verificação da origem antes de fornecer receitas. Enquanto não há fonte correspondente comprovado, o documento identifica `Fonte não verificada`; nomes de cenários confirmados no sincronizador podem constar no catálogo, sem atribuir dados JSON que os arquivos não comprovam. O validador local `TDD_FAT_VALIDAR_RESULTADO` contém comparação de tempo, divergindo da descrição de outra versão no HTML. A documentação deve identificar a versão, sem generalizar o limite anterior.

O portal usa links para fontes no repositório quando adequado; documentos e diagramas apresentados ao leitor ficam no artefato selecionado. Nenhum código de negócio será executado pelo portal.

## GitHub Pages

O artefato terá o `index.html` no topo, como exige a [documentação de entrada do Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site). A URL alvo, a confirmar após publicação, é `https://modulostestesautomatizados.github.io/TestesAutomatizadosERP/`.

Hash (`/#/casos/financeiro`) mantém o caminho físico servido pelo Pages. O [contrato de createWebHashHistory](https://router.vuejs.org/api/functions/createWebHashHistory.html) permite preservar o pathname sem hardcode do nome do repositório. Não adotar `createWebHistory()` com links profundos sem resolver o fallback do host; isso não é necessário nesta proposta.

O workflow proposto valida o catálogo/links, copia arquivos selecionados para diretório de artefato e publica via Actions/Pages. Não há bundle de produção: preparação de artefato é cópia/validação. O pacote exclui `.envrc`, `.codex`, `.agents`, `.opencode`, `.specs`, SQL, dumps e fontes brutos não selecionados. Assets editoriais necessários serão incluídos explicitamente. A fonte e branch de publicação e permissões de Pages serão verificadas no design, segundo as [exigências de custom workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages).

Configurar e publicar será parte da entrega da feature, após implementação e revisão. Esta especificação não é evidência de site publicado nem autorização para alterar configurações externas nesta sessão.

## Edge Cases

| Situação | Resultado definido | Requisito |
| --- | --- | --- |
| Slug inexistente | Página de documentação não encontrada, sem erro fatal | DOC-07 |
| IDs de seção iguais em documentos diferentes | Identificação composta por documento/seção e estado independente | DOC-11 |
| URLs em subpasta ou capitalização diferente | Usar caminhos relativos e validar case exato do artefato | DOC-05 |
| Rota do catálogo seguida de página com diagrama | Renderizar no ciclo de navegação, não só no load inicial | DOC-29 |
| Mermaid inválido ou CDN Mermaid indisponível | Texto fonte disponível, restante legível | DOC-31 |
| Clipboard negado/contexto sem API | Seleção manual com mensagem definida | DOC-34 |
| Documento validado sem evidência | Registro rejeitado na validação do contrato | DOC-22 |
| Slug duplicado/campo obrigatório ausente | Validação reprovada antes da publicação | DOC-37 |
| Snapshot de Pascal desatualizado | Referência de legado/diferença; não oferecer como fluxo atual | DOC-17, DOC-28 |
| Falha de dependência essencial | Mensagem de bootstrap; não prometer portal offline | DOC-44 |

## Implicit Requirement Dimensions

| Dimension | Resolution |
| --- | --- |
| Input validation & bounds | DOC-22, DOC-37; contrato com campos, enum, slugs e blocos; sem entrada livre de HTML executável |
| Failure / partial-failure states | DOC-07, DOC-31, DOC-34, DOC-44, DOC-45 |
| Idempotency / retry / duplicate handling | DOC-37 para duplicidade; navegação/hash é determinística; retry de gravações N/A porque o portal não grava dados de negócio |
| Auth boundaries & rate limits | N/A porque o portal é estático sem autenticação/API; permissões do workflow pertencem à publicação descrita |
| Concurrency / ordering | DOC-06 e DOC-29 para navegação/renderização do documento corrente; execução paralela ERP N/A porque o site não executa testes |
| Data lifecycle / expiry | DOC-17, DOC-22, DOC-40 e DOC-47; conteúdo versionado, origem verificada e legado identificado; TTL N/A porque não há dados de sessão persistidos |
| Observability | DOC-14, DOC-31, DOC-37 e DOC-44; título/mensagens/erro de validação; analytics e telemetria externa N/A por escopo |
| External-dependency failure | DOC-31, DOC-34, DOC-44; CDN e clipboard; sem promessa de funcionamento offline |
| State-transition integrity | DOC-06, DOC-11, DOC-22, DOC-29; estado de rota/seção e guardas do estado documental |

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| DOC-01 | Navegação | Specify | Pending |
| DOC-02 | Navegação | Specify | Pending |
| DOC-03 | Navegação | Specify | Pending |
| DOC-04 | Navegação | Specify | Pending |
| DOC-05 | Navegação | Specify | Pending |
| DOC-06 | Navegação | Specify | Pending |
| DOC-07 | Navegação | Specify | Pending |
| DOC-08 | Leitura | Specify | Pending |
| DOC-09 | Leitura | Specify | Pending |
| DOC-10 | Leitura | Specify | Pending |
| DOC-11 | Leitura | Specify | Pending |
| DOC-12 | Leitura | Specify | Pending |
| DOC-13 | Leitura | Specify | Pending |
| DOC-14 | Leitura | Specify | Pending |
| DOC-15 | Arquitetura | Specify | Pending |
| DOC-16 | Arquitetura | Specify | Pending |
| DOC-17 | Arquitetura | Specify | Pending |
| DOC-18 | Arquitetura | Specify | Pending |
| DOC-19 | Arquitetura | Specify | Pending |
| DOC-20 | Arquitetura | Specify | Pending |
| DOC-21 | Arquitetura | Specify | Pending |
| DOC-22 | Arquitetura | Specify | Pending |
| DOC-23 | Catálogo | Specify | Pending |
| DOC-24 | Catálogo | Specify | Pending |
| DOC-25 | Catálogo | Specify | Pending |
| DOC-26 | Catálogo | Specify | Pending |
| DOC-27 | Catálogo | Specify | Pending |
| DOC-28 | Catálogo | Specify | Pending |
| DOC-29 | Diagramas e exemplos | Specify | Pending |
| DOC-30 | Diagramas e exemplos | Specify | Pending |
| DOC-31 | Diagramas e exemplos | Specify | Pending |
| DOC-32 | Diagramas e exemplos | Specify | Pending |
| DOC-33 | Diagramas e exemplos | Specify | Pending |
| DOC-34 | Diagramas e exemplos | Specify | Pending |
| DOC-35 | Autoria | Specify | Pending |
| DOC-36 | Autoria | Specify | Pending |
| DOC-37 | Autoria | Specify | Pending |
| DOC-38 | Autoria | Specify | Pending |
| DOC-39 | Autoria | Specify | Pending |
| DOC-40 | Migração e publicação | Specify | Pending |
| DOC-41 | Migração e publicação | Specify | Pending |
| DOC-42 | Migração e publicação | Specify | Pending |
| DOC-43 | Migração e publicação | Specify | Pending |
| DOC-44 | Migração e publicação | Specify | Pending |
| DOC-45 | Migração e publicação | Specify | Pending |
| DOC-46 | Migração e publicação | Specify | Pending |
| DOC-47 | Migração e publicação | Specify | Pending |

**Coverage:** 47 requisitos, todos associados a uma story, teste independente e seção do design. Zero requisitos Verified. Tasks ainda não foi produzido; associação a tarefas e evidências ocorrerá nas fases seguintes. A validação estrutural desta spec não comprova aceitação da aplicação.

## Success Criteria

- [ ] Revisão editorial resolve as divergências documentadas sem modificar os fontes Pascal por efeito da migração.
- [ ] Quatro documentos de detalhe são migrados com manifesto; cinco caminhos antigos continuam levando ao conteúdo equivalente.
- [ ] Catálogo apresenta ambos os domínios e os três cenários existentes de Pedido de Venda.
- [ ] Novo documento obtido pelo snippet aparece por registro no catálogo, sem alterações em router/layout.
- [ ] Rotas profundas e assets funcionam na raiz local e no prefixo do Pages após recarregar.
- [ ] Diagramas renderizam depois da navegação e preservam texto em falha; exemplos copiam texto exato.
- [ ] Publicação autorizada possui URL real e evidência de navegação no GitHub Pages.
- [ ] Validação final independente relaciona os 47 requisitos a evidências, depois de implementar a feature.
