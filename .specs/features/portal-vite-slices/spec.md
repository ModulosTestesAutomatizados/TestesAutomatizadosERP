# Portal Vue com Vite, slices por feature e contratos TDD atuais

**Status:** implementação local concluída; revisão independente pendente.
**Data:** 2026-10-16. **Porte:** complexo; execução autorizada após revisão da especificação.

## Problem Statement

O portal usa Vue/Vuetify globais por CDN, templates em strings TypeScript e scripts próprios para compilação, inicialização e preview. A manutenção já exige ferramentas auxiliares para validar esses templates, e os componentes ficam agrupados por tipo técnico sem explicitar suas features.

A estabilização do IRunner também alterou nomes, responsabilidades, métricas e sincronização. Migrar apenas a tecnologia perpetuaria documentação incorreta. Esta especificação reúne a modernização do frontend e a atualização editorial, com entregas locais separáveis e rastreabilidade do pacote recebido da outra sessão.

## Goals

- Usar Vue SFC, TypeScript e Vite com dependências npm e publicação estática no GitHub Pages.
- Organizar componentes e views em slices por feature, respeitando os grupos/subgrupos do mapa.
- Aplicar DDD de forma proporcional, com vocabulário, donos dos modelos e fronteiras explícitas; aplicar SOLID e DRY com critérios verificáveis.
- Incorporar integralmente os requisitos documentais atuais do IRunner, sem modificar sua implementação Pascal.
- Atualizar guia, snippets e criar uma skill local de contribuição coerentes com a organização final.

## Out of Scope

| Item | Motivo |
| --- | --- |
| Implementar nesta entrega de especificação | O pedido atual é começar pela TLC; esta entrega produz artefatos de planejamento |
| Alterar Pascal, SQL, dados ou regras de execução do IRunner | Documentar contratos reconciliados; divergências voltam para a sessão de estabilização |
| Backend, SSR, autenticação, banco de busca, microfrontends | O produto continua um portal estático |
| Introduzir Pinia, repositórios/classes genéricas ou camadas para cada arquivo por convenção | Só se uma necessidade concreta for demonstrada no Design |
| Redesenhar identidade visual e remover conteúdo válido | Preservar a homologação atual; corrigir conteúdo superado explicitamente |
| Publicar, fazer merge ou atualizar o PR anterior automaticamente | A autorização anterior abriu o PR #26; esta iteração exige autorização própria para publicação |
| Versionar ferramentas e testes temporários do agente | Preferência explícita anterior do usuário permanece vigente |
| Sincronizar worktrees, restaurar exclusões ou descartar alterações locais | Há trabalho de outra sessão; a consolidação de fontes exige reconciliação |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Tecnologia | Vue SFC com script setup lang=ts, Vuetify e Vite via npm | Direção expressa do usuário | Sim |
| Local do frontend | Manter Documentacoes/app como raiz do código; componentes organizados por feature dentro de app/components | Preserva a premissa anterior de conteúdo em app e o pedido de slices dentro de componentes | Proposta |
| Hierarquia | Preservar seis raízes e subgrupos do mapa; atualizar folhas para contratos atuais e corrigir grafia de apresentação | Mapa orienta navegação; não congela nomes de units removidas | Proposta |
| Views por página | Conteúdo e resolução de página pertencem à slice; criar SFC específico apenas quando existir comportamento/layout próprio | Evita wrappers idênticos por unit e duplicação do leitor | Proposta |
| DDD | Avaliar contextos editoriais e de descoberta; grupos técnicos de Pascal são taxonomia documental | Um item de menu não demonstra autonomia de modelo ou regra | Proposta |
| Rotas | Manter hash routing e rotas válidas da baseline; alias de busca é distinto de redirecionamento | Pages não oferece fallback de SPA configurável como servidor próprio | Proposta |
| Nomes alterados pelo IRunner | Adotar fonte reconciliada, distinguir nome local e remoto; redirects explícitos para páginas substituídas com equivalência comprovada | O antigo padrão universal P39_TDD_ não pode sobrescrever os novos identificadores TDD_RUN_ | Proposta |
| Encadeamento | Migrar infraestrutura preservando conteúdo primeiro, atualizar conteúdo estabilizado depois, mantendo ambos no escopo planejado | Permite separar regressão técnica de mudança de contrato | Proposta |
| Pacote externo | Snapshot de spec e inventário em referencias/estabilizacao; código reconciliado prevalece após divergências documentadas | O pacote inclui fontes sem commit e nomes locais ainda diferentes | Proposta |
| JSONs ignorados | Exemplos versionados em conteúdo TS/Markdown, sem mudar .gitignore para publicar massas | Torna o build portável sem depender de arquivos pessoais | Herdada do pacote |
| Publicação | Pages com base /TestesAutomatizadosERP/, npm ci e artefato estático no workflow atual | Compatibilidade já exigida para este portal | Sim |
| Versões | Selecionar versões compatíveis com Node e pares Vue/Vuetify no Design; não atualizar todas por serem as mais novas | A migração não exige upgrade indiscriminado | Proposta |
| Skill | Criar .agents/skills/contribuir-documentacao/SKILL.md, com caminhos relativos e referências ao guia/snippets | Compartilhável pelo projeto sem alterar skills globais | Proposta |

**Open questions:** none — escolhas não confirmadas estão registradas como propostas acima; aprovação recebida; propostas técnicas adotadas conforme design.md.

## User Stories

### P1: Desenvolver e publicar a aplicação Vue convencional

**User Story:** Como mantenedor, quero editar SFCs tipados e publicar o build estático pelo fluxo atual.

**Acceptance Criteria**:
1. The componentes e views Vue do portal SHALL ser SFCs com template e script setup lang="ts", sem templates executáveis mantidos em strings TypeScript. (VITE-01)
2. The aplicação SHALL importar Vue, Router, Vuetify, Mermaid, estilos e ícones de dependências npm, sem carregar esses recursos por CDN em runtime. (VITE-02)
3. WHEN npm run dev --prefix Documentacoes for executado THEN o ambiente SHALL servir a aplicação com atualização de SFC sem exigir build completo manual a cada edição. (VITE-03)
4. WHEN npm run build --prefix Documentacoes for executado THEN o projeto SHALL produzir um artefato estático autocontido de publicação. (VITE-04)
5. WHEN o artefato for servido sob /TestesAutomatizadosERP/ THEN o portal SHALL resolver entrada, favicon, chunks, fontes/ícones e Mermaids sem respostas 404 para recursos registrados. (VITE-05)
6. The workflow de documentação SHALL manter validação em PR e publicação somente em master ou execução manual autorizada na master. (VITE-06)
7. The comando check SHALL validar SFCs pelo ESLint e vue-tsc com TypeScript estrito, substituindo a geração de templates virtuais e declarações globais de bibliotecas. (VITE-07)
8. The build SHALL conservar as validações de catálogo, fontes e diagramas hoje existentes, sem precisar de runtime CDN para executá-las. (VITE-08)

**Independent Test:** instalação pelo lockfile, check, dev e build; servir o resultado sob o prefixo Pages em ambiente Linux e bloquear os domínios CDN durante o smoke local.

### P1: Localizar e evoluir features por responsabilidade

**User Story:** Como mantenedor, quero encontrar a implementação e o conteúdo de uma feature sem percorrer diretórios técnicos desconexos.

**Acceptance Criteria**:
1. The diretório app/components SHALL agrupar componentes de negócio por feature e manter suas views, composables e conteúdo específicos junto da feature proprietária. (ARCH-01)
2. The slices documentais SHALL preservar as raízes Arquitetura, Units, Casos de teste, Mapeamentos, Helpers e Contribuir e seus subgrupos atuais na organização das páginas. (ARCH-02)
3. The análise arquitetural SHALL declarar, para cada bounded context candidato, vocabulário, dono de modelo/regras, entradas, saídas e motivo da fronteira, distinguindo-o de grupo de navegação e componente visual. (ARCH-03)
4. The grafo de imports SHALL impedir dependência de componentes compartilhados para features e acesso de uma slice a detalhes internos de outra, permitindo composição apenas pelos contratos públicos definidos no Design. (ARCH-04)
5. The implementação SHALL manter uma única regra de identidade/rota/citação de unit e uma única definição editável de posição/ordem no menu por documento. (ARCH-05)
6. The componentes de código copiável, tabelas, avisos, sumário e Mermaid SHALL ter renderização reutilizável, sem cópias por unit ou página. (ARCH-06)
7. The módulos de catálogo, busca e validação documental SHALL aceitar dados tipados sem depender de instância Vue, DOM ou Vuetify. (ARCH-07)
8. The guia arquitetural SHALL demonstrar SRP, OCP, LSP, ISP e DIP com contratos reais da solução, sem impor herança ou interfaces de uso único apenas para ilustrar princípios. (ARCH-08)

**Independent Test:** localizar uma página por grupo/subgrupo; adicionar documento com blocos existentes sem alterar componentes do leitor; conferir imports e validar busca/catálogo com dados tipados.

### P1: Preservar o portal homologado durante a migração

**Acceptance Criteria**:
1. The portal SHALL preservar cards inteiros clicáveis, grupos expansíveis, tooltips/truncamento, sumário por âncoras, terminal copiável, tabelas abertas, Mermaid com controles e responsividade. (UX-01)
2. WHILE a rota inicial estiver carregando THEN o portal SHALL apresentar somente overlay e skeleton visuais, sem card ou indicador central, mantendo bloqueio até a saída e preferência de movimento reduzido. (UX-02)
3. WHEN uma rota válida da baseline permanecer no catálogo final THEN o portal SHALL resolver o mesmo documento por abertura direta e atualização da página. (UX-03)
4. WHEN o usuário buscar nome de unit, alias, estado global ou procedure THEN a busca SHALL retornar as páginas proprietárias e links válidos segundo a mesma política de relevância da baseline. (UX-04)
5. IF uma rota, conteúdo lazy ou diagrama não puder ser carregado THEN a interface SHALL apresentar estado de erro identificável e ação de recuperação compatível com o recurso. (UX-05)

**Independent Test:** smoke desktop/mobile com abertura direta, busca por símbolos, cópia, âncoras, expansão do drawer, diagrama e falha controlada de carregamento. Não criar uma suíte extensa para cada página.

### P1: Consultar contratos atuais do IRunner

**Acceptance Criteria**:
1. WHEN fontes divergirem do snapshot recebido THEN a atualização editorial SHALL registrar a divergência e reconciliar o contrato antes de publicar afirmações sobre ele. (TDD-01)
2. The atualização documental SHALL satisfazer os critérios DOC-01 a DOC-18 do snapshot incorporado, conforme a matriz de incorporação, sem reutilizar evidências históricas como validação nova. (TDD-02)
3. The catálogo SHALL oferecer documentação individual de RUN_ASSERTS, RUN_MODULO e VALIDAR_RESULTADO, além das demais units atuais cobertas pelo pacote, sem duplicar páginas já existentes de sincronização. (TDD-03)
4. The exemplos JSON SHALL mostrar modelos completos copiáveis e tabelas de objetos/campos e impactos, identificando valores a preencher e defaults sem depender dos JSONs ignorados do autor. (TDD-04)
5. WHEN fontes forem reconciliados THEN os Mermaids e inventários AST SHALL ser regenerados a partir deles em docs/MAPEAMENTO_AST_USES_UNITS/<documentacao>/, mantendo separação entre uses, carga dinâmica e estado compartilhado. (TDD-05)
6. IF não houver evidência identificável no ERP para o contrato atual THEN o documento SHALL explicitar a limitação e não usar validado-no-erp. (TDD-06)

**Independent Test:** matriz DOC-01..18 vinculada às páginas finais e evidência atual dos fontes; build sem JSONs ignorados e sem a worktree irmã disponível.

### P1: Contribuir com guia, snippets e skill coerentes

**Acceptance Criteria**:
1. The snippets SHALL cobrir SFC com script setup TypeScript, página documental, documento de unit, seção, grupo/subgrupo, registro, estado/evidência, JSON com tabela e Mermaid canônico usando caminhos válidos da estrutura final. (AUTHOR-01)
2. The guia Contribuir SHALL explicar quando editar dados documentais, criar view/componente ou nova feature, registrar rota/menu, atualizar estado, citar units e validar a publicação local. (AUTHOR-02)
3. The skill local contribuir-documentacao SHALL orientar contribuições nesses mesmos contratos, referenciando os arquivos atuais do projeto sem exigir caminhos absolutos do computador do autor. (AUTHOR-03)
4. WHEN exemplos representativos dos snippets forem expandidos THEN eles SHALL passar nas validações pertinentes sem APIs globais Vue/VueRouter/Vuetify ou instruções de CDN. (AUTHOR-04)
5. The entrega SHALL manter testes/ferramentas temporários ignorados e registrar verificação proporcional ao risco, incluindo check, build, smoke Pages e revisão independente TLC no encerramento da implementação. (AUTHOR-05)

**Independent Test:** a partir do guia e da skill, adicionar uma documentação de unit e um subgrupo em cópia ignorada usando snippets; conferir tipos, menu, busca e links e descartar a cópia.

## Edge Cases

- O mapa usa TDD_IRUNNER e antigos nomes financeiros; não forçar o prefixo anterior sobre os nomes reais TDD_RUN_.
- A árvore local já possui exclusões e novos Pascal sem commit. Não é uma baseline compilável comprovada; o build atual não foi executado para mascarar fontes ausentes.
- P39_TDD_PROCESSAMENTO_FINANCEIRO local difere de P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO no snapshot externo: registrar qual fonte foi consolidada antes de construir título e grafo.
- Alias no índice não é redirect. Rotas retiradas em iteração anterior não devem ressurgir só para satisfazer UX-03.
- JSON com resultadoEsperado ausente difere de objeto vazio; uma propriedade reservada aninhada não é retirada pela projeção da raiz.
- Um exemplo com IDs/valor zero não é massa financeira válida; status SUCESSO não certifica todos os efeitos financeiros.
- Bibliotecas empacotadas eliminam a falha de CDN específica; conservar recuperação de falha de chunk/rota sem carregar fallback da CDN.
- A entrada estática anterior à montagem não pode depender de Vue para informar falha de inicialização.
- Um novo grupo não deve exigir cópia do leitor ou da busca; uma view especializada não deve importar internals de outra slice.
- Arquivos .vue, Markdown e Pascal com acentos/capitalização precisam funcionar em checkout Linux; somente CRLF/LF é normalizado no hash.

## Dimensões implícitas

| Dimensão | Resolução |
| --- | --- |
| Validação e limites | VITE-08, AUTHOR-04: catálogo, símbolos, fontes, diagramas, tipos e snippet expandido |
| Falha parcial | UX-05 e DOC-06/07/12: distinguir falha visual de persistência parcial descrita, sem alterar ERP |
| Retry/idempotência | Recuperação por recarga do recurso/página; publicação gera saída limpa. Sem retry de banco ou sincronização nesta feature |
| Autorização/rate limits | N/A para leitura estática pública sem API; publicação continua protegida pelo workflow e autorização do usuário |
| Concorrência/ordem | UX-02: liberar interação após readiness/saída; índices consomem catálogo final, não mutações de estado ERP |
| Ciclo de vida | Preservar estados documentais e evidência; snapshots são proveniência e não conteúdo ativo automático |
| Observabilidade | Diagnósticos de check/build com documento/caminho causador; erros de leitura visíveis; sem nova telemetria |
| Dependências externas | Runtime sem CDN; instalação depende do registry/lockfile. Worktree irmã não pode ser dependência do build |
| Integridade de transições | UX-02/05 e TDD-06: loading/pronto/erro e estado documental validado condicionado à evidência |

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| VITE-01 | Ferramentas | Execute | Implemented |
| VITE-02 | Ferramentas | Execute | Implemented |
| VITE-03 | Ferramentas | Execute | Implemented |
| VITE-04 | Ferramentas | Execute | Implemented |
| VITE-05 | Ferramentas | Execute | Implemented |
| VITE-06 | Ferramentas | Execute | Implemented |
| VITE-07 | Ferramentas | Execute | Implemented |
| VITE-08 | Ferramentas | Execute | Implemented |
| ARCH-01 | Organização | Execute | Implemented |
| ARCH-02 | Organização | Execute | Implemented |
| ARCH-03 | Organização | Execute | Implemented |
| ARCH-04 | Organização | Execute | Implemented |
| ARCH-05 | Organização | Execute | Implemented |
| ARCH-06 | Organização | Execute | Implemented |
| ARCH-07 | Organização | Execute | Implemented |
| ARCH-08 | Organização | Execute | Implemented |
| UX-01 | Preservação | Execute | Implemented |
| UX-02 | Preservação | Execute | Implemented |
| UX-03 | Preservação | Execute | Implemented |
| UX-04 | Preservação | Execute | Implemented |
| UX-05 | Preservação | Execute | Implemented |
| TDD-01 | Contratos atuais | Execute | Implemented |
| TDD-02 | Contratos atuais | Execute | Implemented |
| TDD-03 | Contratos atuais | Execute | Implemented |
| TDD-04 | Contratos atuais | Execute | Implemented |
| TDD-05 | Contratos atuais | Execute | Implemented |
| TDD-06 | Contratos atuais | Execute | Implemented |
| AUTHOR-01 | Contribuição | Execute | Implemented |
| AUTHOR-02 | Contribuição | Execute | Implemented |
| AUTHOR-03 | Contribuição | Execute | Implemented |
| AUTHOR-04 | Contribuição | Execute | Implemented |
| AUTHOR-05 | Contribuição | Execute | Implemented |

**Coverage:** 32 critérios próprios; 18 critérios documentais incorporados rastreados em incorporacao-irunner.md. T1–T8 executadas localmente; revisão independente registrada separadamente em validation.md antes de declarar a feature verificada.

## Success Criteria

- Build publicável sem CDN, recursos privados ou worktree irmã; check e smoke no prefixo Pages aprovados.
- Features localizáveis pela hierarquia editorial e fronteiras justificadas por modelos/regras.
- DOC-01..18 com evidência própria atual, sem promessas de homologação inexistente.
- Guia, snippets e skill permitem criar unidade/subgrupo sem duplicar componentes nem regras de rota.
- Código existente do IRunner e mudanças do usuário preservados nesta iteração documental.

## Referências do planejamento

- context.md: baseline e decisões propostas.
- arquitetura-proposta.md: alternativas e análise inicial de contextos; não é Design aprovado.
- incorporacao-irunner.md: matriz normativa e tratamento de conflitos.
- referencias/estabilizacao/: snapshots de proveniência, sem dependência da worktree irmã.
- [Vite / Pages](https://vite.dev/guide/static-deploy.html#github-pages), [Vue SFC](https://vuejs.org/guide/scaling-up/sfc.html), [script setup](https://vuejs.org/api/sfc-script-setup.html), [Bounded Context](https://martinfowler.com/bliki/BoundedContext.html).

Context7 não estava disponível entre as ferramentas da sessão; referências técnicas conferidas nos sites oficiais, após leitura do código local.
