# Navegação, sincronização e apresentação do portal

Status: proposta atualizada com as decisões do usuário. Data: 2026-10-14.

## Problem Statement

O menu atual conserva agrupamentos anteriores, repete entradas de casos e não representa o mapa de navegação fornecido pelo usuário. O carregamento inicial aparece como texto simples, identificadores longos quebram linhas e o final do drawer precisa de espaço para leitura e clique.

Os três fontes atualizados de sincronização já estão no worktree, mas ainda não possuem documentação individual. Esta entrega organiza o portal e documenta esses fontes sem executar suas operações no ERP ou nos bancos.

A nomenclatura passa a ser única entre arquivos Pascal, identificadores de units, menu e títulos das páginas. As páginas anteriores fora do mapa serão excluídas junto de suas rotas, sem camada de compatibilidade.

## Goals

- Representar os seis grupos e a ordem do mapa fornecido, sem duplicar entradas.
- Documentar os três helpers de sincronização com responsabilidades, estados, assinaturas, dependências e efeitos observados nos fontes.
- Exibir carregamento de tela inteira e manter o drawer legível em desktop e celular.
- Preservar publicação estática no GitHub Pages, citações de units e busca por relevância.
- Uniformizar nomes dos artefatos locais e suas referências usando `P39_TDD_` e, nos artefatos de módulo, `P39_TDD_FIN_` ou `P39_TDD_FAT_`.

## Out of Scope

| Item | Motivo |
| --- | --- |
| Alterar lógica Pascal, SQL, regras de sincronização ou registros de casos | Renomeações de arquivos, identificadores e referências estão incluídas; mudanças de comportamento não estão. |
| Executar sincronização, consultas ao banco ou chamadas à TekStore | A entrega é documental e visual. |
| Declarar homologação dos helpers no ERP | Leitura de fonte não comprova execução. |
| Reestruturar o restante do fluxo IRunner ou documentar asserts | Não integra esta solicitação. |
| Adotar PrimeVue ou copiar seletores `.p-*` | O portal utiliza Vue e Vuetify; o CSS fornecido é uma referência visual. |
| Versionar testes, ferramentas locais ou saídas compiladas | Restrição já definida pelo usuário. |
| Publicar diretamente em master | A exceção anterior se restringiu ao commit da pipeline; esta entrega volta ao fluxo por PR. |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Hierarquia e ordem | Usar os seis grupos do mapa reproduzido abaixo, corrigindo somente acentos nos rótulos humanos. | O arquivo foi fornecido como representação da navegação desejada. | Sim, solicitação do usuário. |
| Nome de menu, página e fonte | Usar o mesmo identificador canônico em todas as superfícies; renomear os artefatos locais e ajustar suas referências conforme a tabela de migração. | O usuário rejeitou nomes de exibição diferentes dos fontes e incluiu explicitamente o custo das renomeações. | Sim, resposta do usuário. |
| Páginas anteriores ausentes do mapa | Excluir páginas, rotas e redirecionamentos relacionados, além das entradas de menu, cards e busca. | O usuário escolheu excluir também as páginas e seus endereços. | Sim, resposta do usuário. |
| Posição da sigla do módulo | Usar `P39_TDD_FIN_PROCESSAMENTO` para o processamento financeiro e `P39_TDD_FIN_PAGAMENTO_RECEBIMENTO` para o caso financeiro. | Aplica o padrão `P39_TDD_FIN_` solicitado aos dois artefatos financeiros que ainda tinham nomes fora do padrão. | Premissa de nomenclatura derivada da resposta. |
| Scrollbar | Ocultar permanentemente a barra visual, mantendo rolagem por mouse, touchpad, toque e teclado. | O pedido explícito é fazer a barra desaparecer; o exemplo enviado ainda produz uma barra fina. | Premissa para revisão. |
| Truncamento | Limitar os rótulos do drawer a uma linha com reticências e disponibilizar o nome completo por hover e foco. | Mantém o desenho solicitado sem perder o acesso ao identificador. | Premissa para revisão. |
| Respiro no drawer | Garantir ao menos 48 px após o último item expandido, além da área segura do dispositivo. | Dá um critério verificável ao espaço solicitado no fim da navegação. | Premissa para revisão. |
| Fontes movidos e removidos | Considerar a pasta `Sincronizar` com capitalização exata; preservar a remoção local dos antigos arquivos em `sincronizar/persistenciasODBC` e do HTML antigo, sem restaurá-los automaticamente. | O worktree já contém essas alterações do usuário; Linux diferencia maiúsculas de minúsculas. | Premissa para revisão. |
| Fonte temporária do mapa | Reproduzir o mapa nesta especificação e manter o cadastro TypeScript como fonte executável da navegação. | `mapeamentoNavegacao.txt` está ignorado pela regra `*.txt`; o portal não deve depender desse arquivo local. | Premissa para revisão. |
| Estado de carregamento | Mostrar overlay no artefato compilado; preservar a instrução de desenvolvimento ao abrir o índice dos fontes diretamente. | O índice dos fontes não possui os módulos compilados necessários para iniciar o portal. | Premissa para revisão. |

**Open questions:** none. As duas decisões de produto foram respondidas; os detalhes complementares estão registrados como premissas explícitas acima.

## Mapa de navegação esperado

Os identificadores abaixo serão os nomes canônicos dos artefatos e os títulos das respectivas páginas e entradas de menu. Arquivos Pascal recebem o mesmo nome acrescido de `.pas`. Slugs de documentação derivam desse identificador em minúsculas, com hífens no lugar dos sublinhados.

```text
Arquitetura
  IRunner.Executar
Units
  Setup
    P39_TDD_CASOS_DE_TESTE
    P39_TDD_CACHE
    P39_TDD_PARAMETROS
    P39_TDD_PARAMETRO_MAPEAMENTO
    P39_TDD_MODULO
  Constantes
    P39_TDD_CONSTANTES
  Persistência
    P39_TDD_ODBC
  IRunner
    P39_TDD_IRUNNER
    P39_TDD_BASE_UNIT_IRUNNER
    P39_TDD_RUNNER
    P39_TDD_STARTED
    P39_TDD_FINISHED
    P39_TDD_LOGS
    P39_TDD_FIN_PROCESSAMENTO
Casos de teste
  P39_TDD_FAT_PEDIDO_VENDA
  P39_TDD_FIN_PAGAMENTO_RECEBIMENTO
Mapeamentos
  Financeiro
    P39_TDD_FIN_BORDERO_PAGAMENTO
    P39_TDD_FIN_BORDERO_RECEBIMENTO
Helpers
  Gerais
    P39_TDD_FUNCOES_JSON
  Sincronização
    P39_TDD_REGISTRAR_CASO_TESTE
    P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS
    P39_TDD_PROCESSAMENTO_SINCRONIZACAO
Contribuir
  Como escrever uma documentação
```

Migração de identidade dos artefatos:

| Identidade atual | Identidade canônica de destino |
| --- | --- |
| P39_TDD_PARAMETRO | P39_TDD_PARAMETROS |
| P39_PROCESSAMENTO_TDD_FINANCEIRO | P39_TDD_FIN_PROCESSAMENTO |
| REFACTOR_TDD_FINANCEIRO_PILOTO | P39_TDD_FIN_PAGAMENTO_RECEBIMENTO |
| P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO | P39_TDD_FIN_BORDERO_PAGAMENTO |
| P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO | P39_TDD_FIN_BORDERO_RECEBIMENTO |
| TDD_IRUNNER | P39_TDD_IRUNNER |
| TDD_BASE_UNIT_IRUNNER | P39_TDD_BASE_UNIT_IRUNNER |
| TDD_RUNNER | P39_TDD_RUNNER |
| TDD_STARTED | P39_TDD_STARTED |
| TDD_FINISHED | P39_TDD_FINISHED |
| TDD_LOGS | P39_TDD_LOGS |

Os demais artefatos já seguem o nome canônico. Variantes antigas sem `P39_`, inclusive as usadas pelo piloto financeiro e pelo sincronizador, devem ser atualizadas nas referências locais ativas. Não basta renomear o arquivo: declarações `unit`, cláusulas `uses`, qualificações, textos de instrução, `SetTDDUnit`, `CodificacaoUnit` e exemplos de código gerado precisam permanecer coerentes.

Esta migração é local. Atualizações dos nomes cadastrados no ERP ou na TekStore não serão executadas nesta entrega. A documentação deve registrar que esses cadastros precisam acompanhar os nomes novos antes de executar os fontes renomeados.

## User Stories

### P1: Carregamento inicial de tela inteira

Como leitor, quero uma indicação visual de carregamento até o portal estar disponível.

**Acceptance Criteria**:

1. WHEN o HTML compilado for aberto THEN o portal SHALL exibir um overlay que cubra toda a viewport antes de Vue e Vuetify estarem disponíveis. (PORTAL-01)
2. WHILE a inicialização estiver pendente o overlay SHALL apresentar um indicador visual com nome acessível de carregamento, substituindo o texto simples atual. (PORTAL-02)
3. WHEN a aplicação estiver montada e a rota inicial estiver pronta THEN o portal SHALL remover o overlay e liberar a interação com o conteúdo. (PORTAL-03)
4. IF ocorrer erro de inicialização ou timeout de 20 segundos no carregamento de um script CDN THEN o portal SHALL substituir o indicador por uma mensagem acessível de falha com ação para recarregar. (PORTAL-04)
5. WHERE a preferência de movimento reduzido estiver ativa o indicador SHALL permanecer identificável sem animação contínua. (PORTAL-05)

**Independent Test**: abrir o artefato com rede lenta e com falha de CDN; conferir cobertura da tela, transição para conteúdo e saída de erro.

### P1: Navegação conforme o mapa

Como leitor, quero encontrar cada artefato no grupo definido no mapa, sem entradas duplicadas.

**Acceptance Criteria**:

1. The portal SHALL renderizar os seis grupos principais, os subgrupos e a ordem dos itens conforme o mapa desta especificação. (PORTAL-06)
2. The portal SHALL apresentar cada documentação individual do mapa em exatamente uma posição da navegação. (PORTAL-07)
3. The portal SHALL usar o mesmo nome canônico do artefato no menu, no título de sua página e na identidade usada para gerar sua rota. (PORTAL-08)
4. WHEN o leitor abrir uma rota documentada diretamente THEN o drawer SHALL expandir os grupos e subgrupos que contêm aquela página. (PORTAL-09)
5. The portal SHALL excluir as páginas anteriores ausentes do mapa e seus endereços, sem manter documentos ocultos nem redirecionamentos de compatibilidade. (PORTAL-10)

**Independent Test**: comparar a árvore renderizada com o mapa, contar ocorrências e abrir rotas profundas com todos os grupos inicialmente fechados.

### P1: Documentação dos helpers de sincronização

Como mantenedor, quero consultar o contrato real dos três helpers atualizados sem precisar ler todo o Pascal.

**Acceptance Criteria**:

1. The portal SHALL disponibilizar uma página individual para cada um dos três arquivos listados em Fontes de sincronização, sob Helpers → Sincronização. (PORTAL-11)
2. The documentation SHALL descrever em cada página responsabilidades, problemas resolvidos, dependências, assinaturas, estados globais próprios ou sua ausência e limites observados no fonte. (PORTAL-12)
3. The documentation SHALL distinguir o estado `FCasoTeste` mantido pelo registrador do estado `FSincRemoto` mantido pelo sincronizador e alterado pelo processamento. (PORTAL-13)
4. The documentation SHALL explicar a leitura local/remota, o fallback para `{}`, a criação de módulo/área, o insert do caso e a confirmação antes do update segundo o fonte atual. (PORTAL-14)
5. WHEN o leitor buscar `FCasoTeste`, `FSincRemoto`, `RegistrarCasoTeste`, `CarregarConteudoUnit`, `Sincronizar` ou `RegistrosCasosTestes` THEN a busca SHALL retornar a documentação da unit que declara o respectivo símbolo. (PORTAL-15)
6. WHEN uma das três units novas for citada em conteúdo suportado pelo componente de referência THEN a citação SHALL apontar para sua documentação individual. (PORTAL-16)

**Independent Test**: conferir cada contrato contra seu fonte, buscar os símbolos e seguir as citações entre as três páginas.

### P1: Drawer legível e acessível

Como leitor, quero navegar entre identificadores longos sem quebra de linha e alcançar o último grupo com conforto.

**Acceptance Criteria**:

1. WHEN um rótulo ultrapassar a largura disponível do drawer THEN o portal SHALL apresentá-lo em uma única linha, com truncamento por reticências e sem rolagem horizontal do drawer. (PORTAL-17)
2. WHEN um item truncado receber hover ou foco de teclado THEN o portal SHALL disponibilizar visualmente seu rótulo completo. (PORTAL-18)
3. The drawer SHALL manter pelo menos 48 px de área rolável após o último item expandido, acrescidos da área segura inferior do dispositivo. (PORTAL-19)

**Independent Test**: expandir todos os grupos em viewport de 360 px e em desktop; verificar uma linha por identificador, foco e espaço após Contribuir.

### P1: Rolagem funcional com barras ocultas

Como leitor, quero uma interface sem barras aparentes e continuar percorrendo conteúdos extensos.

**Acceptance Criteria**:

1. The portal SHALL ocultar as barras visuais dos contêineres roláveis da página, drawer, busca, sumário, tabelas, terminal e diagramas. (PORTAL-20)
2. WHILE o conteúdo exceder seu contêiner o portal SHALL preservar a rolagem vertical ou horizontal pertinente por roda do mouse, touchpad, toque e teclado. (PORTAL-21)

**Independent Test**: percorrer o drawer e a página por teclado e rolar lateralmente um terminal ou tabela sem barras aparentes.

### P1: Autoria e publicação compatíveis

Como contribuidor, quero manter os novos grupos e helpers com os mesmos mecanismos reutilizáveis do portal.

**Acceptance Criteria**:

1. The portal SHALL manter grupos, subgrupos, ordem e rótulos de navegação em registros TypeScript reutilizáveis, sem listas paralelas específicas de páginas. (PORTAL-22)
2. The contribution guide and snippets SHALL documentar o cadastro nos novos grupos com nome único entre artefato, menu e página, preservando `P39_TDD_` e a sigla de módulo quando aplicável. (PORTAL-23)
3. WHEN o build executar no GitHub Actions THEN o artefato SHALL resolver os caminhos dos novos fontes com a capitalização `docs/assets/configuracoesGerais/Sincronizar/`. (PORTAL-24)
4. WHEN o artefato for servido sob `/TestesAutomatizadosERP/` THEN o portal SHALL carregar a entrada, navegar entre os novos grupos e reabrir rotas profundas sem servidor de aplicação. (PORTAL-25)

**Independent Test**: executar lint, tipos e build; servir a saída estática com o prefixo do Pages e abrir uma rota nova diretamente.

### P1: Renomeação coerente dos artefatos e dependências

Como mantenedor, quero que os nomes padronizados correspondam aos arquivos e às referências reais, sem depender de nomes alternativos de exibição.

**Acceptance Criteria**:

1. The local sources SHALL adotar os nomes de destino da tabela de migração nos arquivos Pascal e nas declarações de identidade existentes nesses fontes. (PORTAL-26)
2. The active references SHALL usar os nomes canônicos nas cláusulas `uses`, qualificações e literais de carregamento dinâmico dos artefatos renomeados. (PORTAL-27)
3. The portal and canonical diagrams SHALL atualizar caminhos, citações, slugs, inventário AST e hashes para os fontes renomeados. (PORTAL-28)
4. WHEN uma página fora do mapa ou uma rota de unit anterior à renomeação for acessada THEN o portal SHALL exibir a página de documentação não encontrada. (PORTAL-29)
5. The migration SHALL preservar a lógica das procedures e functions, limitando as alterações Pascal à identidade e às referências dos artefatos. (PORTAL-30)
6. The contribution guide SHALL informar a necessidade de atualizar os nomes no cadastro do ERP e na TekStore antes de executar os fontes renomeados. (PORTAL-31)

**Independent Test**: comparar o inventário de arquivos com a tabela de migração, verificar referências ativas e literais dinâmicos, conferir hashes e revisar o diff Pascal para alterações apenas de nomes.

## Páginas a excluir

Excluir os módulos de documentação de `content/documentos/`, `content/casos/` e `content/historico/` que não compõem o novo mapa. Isso inclui referências gerais de casos e parâmetros, páginas intermediárias de casos legado/IRunner, os fluxos separados de pedido de venda e piloto financeiro, runner legado e referências anteriores ocultas. Permanecem as páginas individuais das units, o fluxo de Arquitetura e o guia de contribuição.

Remover também os redirecionamentos numerados do manifesto e seus arquivos de compatibilidade; limpar citações internas para páginas excluídas. Diagramas que deixarem de ter função na documentação ativa devem ser revisados junto de seu diretório canônico. A remoção de uma página não autoriza excluir os fontes Pascal de casos antigos que ainda sirvam como referência ou dependência: esses fontes só mudam quando alcançados pela migração de nomes.

Os registros históricos de decisões e entregas em `.specs/` não serão reescritos para simular que os nomes novos já existiam em versões anteriores.

## Fontes de sincronização

- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas`
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas`
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_PROCESSAMENTO_SINCRONIZACAO.pas`

O processamento atualmente atribui `True` a `FSincRemoto` antes de chamar `Sincronizar`. A documentação deve distinguir essa atribuição do valor inicial do booleano na outra unit. Exemplos Pascal ou JSON devem usar o terminal copiável existente; explicações de campos devem reutilizar o componente de tabela. Se houver novos diagramas, eles devem residir exclusivamente em `docs/MAPEAMENTO_AST_USES_UNITS/<slug-do-documento>/`.

## Edge Cases

- CDN indisponível: PORTAL-04, sem overlay de carregamento indefinido após a falha reconhecida.
- Movimento reduzido: PORTAL-05, sem depender da animação para indicar o estado.
- Link antigo fora do novo menu ou com nome de unit anterior: PORTAL-10 e PORTAL-29, documentação não encontrada.
- Identificador longo e grupos expandidos em celular: PORTAL-17 a PORTAL-19.
- Conteúdo horizontalmente extenso: PORTAL-20 e PORTAL-21, sem substituir rolagem por `overflow: hidden`.
- Diferenças Windows/Linux na pasta movida: PORTAL-24; revisar também referências antigas a `sincronizar/persistenciasODBC`.

## Dimensões implícitas

| Dimensão | Resolução neste escopo |
| --- | --- |
| Validação de entrada e limites | Cadastro de grupos validado pelo catálogo; rótulos limitados visualmente pelo drawer, com texto completo disponível. |
| Falha e falha parcial | PORTAL-04 cobre falha reconhecida na inicialização. |
| Idempotência e duplicidade | PORTAL-07 exige uma entrada por documentação; recarregar inicia novamente o portal estático. |
| Autenticação e limites de chamadas | N/A: não há nova autenticação, endpoint ou chamada de sincronização no portal. |
| Concorrência e ordenação | PORTAL-03 define a saída do carregamento; PORTAL-06 define a ordem da árvore. |
| Ciclo de vida dos dados | PORTAL-10 remove páginas e rotas antigas; nenhum dado de ERP será alterado. |
| Observabilidade | N/A: nenhuma telemetria nova; erro inicial permanece visível e acessível. |
| Falha de dependência externa | PORTAL-04 cobre scripts CDN usados na inicialização. |
| Integridade das transições | Carregando → pronto ou erro; nenhuma operação de sincronização é disparada pela documentação. |

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| PORTAL-01 | Carregamento | Specify | Pending |
| PORTAL-02 | Carregamento | Specify | Pending |
| PORTAL-03 | Carregamento | Specify | Pending |
| PORTAL-04 | Carregamento | Specify | Pending |
| PORTAL-05 | Carregamento | Specify | Pending |
| PORTAL-06 | Navegação | Specify | Pending |
| PORTAL-07 | Navegação | Specify | Pending |
| PORTAL-08 | Navegação | Specify | Pending |
| PORTAL-09 | Navegação | Specify | Pending |
| PORTAL-10 | Navegação | Execute | Verified |
| PORTAL-11 | Helpers | Specify | Pending |
| PORTAL-12 | Helpers | Specify | Pending |
| PORTAL-13 | Helpers | Specify | Pending |
| PORTAL-14 | Helpers | Specify | Pending |
| PORTAL-15 | Helpers | Specify | Pending |
| PORTAL-16 | Helpers | Specify | Pending |
| PORTAL-17 | Drawer | Specify | Pending |
| PORTAL-18 | Drawer | Specify | Pending |
| PORTAL-19 | Drawer | Specify | Pending |
| PORTAL-20 | Rolagem | Specify | Pending |
| PORTAL-21 | Rolagem | Specify | Pending |
| PORTAL-22 | Autoria | Execute | Verified |
| PORTAL-23 | Autoria | Specify | Pending |
| PORTAL-24 | Pages | Specify | Pending |
| PORTAL-25 | Pages | Specify | Pending |
| PORTAL-26 | Nomenclatura | Execute | Verified |
| PORTAL-27 | Nomenclatura | Execute | Verified |
| PORTAL-28 | Nomenclatura | Execute | Verified |
| PORTAL-29 | Nomenclatura | Execute | Verified |
| PORTAL-30 | Nomenclatura | Execute | Verified |
| PORTAL-31 | Nomenclatura | Specify | Pending |

Coverage: 31 requisitos definidos; tarefas ainda não produzidas. As decisões de remoção e nomenclatura foram confirmadas pelo usuário.

## Success Criteria

- Menu corresponde ao mapa aprovado, sem duplicações.
- Três helpers possuem páginas individuais e símbolos encontráveis na busca.
- Overlay, truncamento, respiro inferior e rolagem atendem aos critérios em desktop e celular.
- Lint, tipos e build passam; as verificações locais não são versionadas.
- Artefato continua navegável sob o prefixo do GitHub Pages.

## Próxima etapa

Após a revisão, produzir o desenho da mudança e tarefas atômicas, com verificações proporcionais a esta documentação. Nenhuma alteração de aplicação, commit ou publicação integra esta proposta de especificação.
