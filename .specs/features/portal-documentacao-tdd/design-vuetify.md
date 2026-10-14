# Portal de documentação TDD — revisão com Vuetify

Data: 2026-10-13. Estado: design aprovado pelo usuário e implementação autorizada nesta sessão.

Este documento revisa o [design anterior](design.md) conforme o pedido atual: Vue e **Vuetify** via CDN, Vue Router, componentes reutilizáveis, snippets de IDE e documentação do fluxo IRunner. O usuário aprovou esta revisão e autorizou a implementação com “Pode seguir com a implementação com essas novas especificações!”. A escolha anterior de PrimeVue e sua prova de compatibilidade não se aplicam à nova stack.

## Objetivo e recorte

Reduzir a duplicação dos HTMLs existentes e permitir acrescentar uma área documental sem copiar layout, scripts ou navegação. A primeira documentação técnica será a estrutura de `IRunner.Executar`, incluindo as dependências transitivas, preparação, execução por lote, persistência de métricas e estado global compartilhado. `TDD_ASSERTS` permanece pendente.

Os quatro documentos atuais serão preservados e migrados com identificação das diferenças entre legado e refatoração. O foco técnico desta iteração é Runner; novos catálogos de cenários além do conteúdo existente ficam para iterações posteriores. Não alterar fontes Pascal ou executar operações no ERP para produzir o portal.

## Escolha de arquitetura

Recomendação: módulos JavaScript de conteúdo, catálogo único e componentes genéricos. Componentes Vue são objetos exportados com templates em strings, compatíveis com navegador sem compilação de SFC. O catálogo alimenta cards, menu e resolução das páginas.

Alternativas avaliadas: um componente específico para cada documento permite layouts próprios, mas repete apresentação; carregar os HTMLs antigos diretamente preserva conteúdo rapidamente, mas mantém scripts e Bootstrap duplicados. A recomendação permite migrar o conteúdo para uma estrutura comum e documentar novas áreas com snippets.

```text
index.html                         entrada, CDN, ponto de montagem e fallback
Documentacoes/app/main.js          instalação Vue, Vuetify e Router
Documentacoes/app/router.js        rotas genéricas e título da página
Documentacoes/app/components/      apresentação reutilizável
Documentacoes/app/pages/           início, documento e página não encontrada
Documentacoes/app/content/         documentos separados por assunto
Documentacoes/app/content/catalogo.js  registro único para cards e navegação
Documentacoes/app/styles/          estilos compartilhados
Documentacoes/README.md            autoria, prévia e instruções Pages
.vscode/documentacao.code-snippets snippets de autoria para VS Code
docs/mapeamentoUses/               mapas canônicos e evidências de uses
Documentacoes/tools/               extração do grafo e validação de conteúdo
```

O índice da raiz terá apenas metadados, assets e inicialização. A home e seus cards serão componentes. Rotas hash preservam navegação e recarregamento no prefixo do repositório do GitHub Pages. Arquivos locais usam caminhos relativos à entrada, sem caminhos absolutos iniciados em `/`.

Stack: Vue 3 com compilador de templates, Vue Router e Vuetify com builds CDN compatíveis. Fixar versões exatas após uma prova da combinação Vue/Vuetify/Router em navegador; a prova anterior de PrimeVue não é suficiente. Mermaid será carregado para diagramas, com código textual como fallback.

## Componentes e autoria

| Componente | Responsabilidade |
| --- | --- |
| AppLayout | Cabeçalho, navegação responsiva e RouterView |
| RedirectCard | Título, resumo, estado e destino RouterLink |
| DocumentPage | Resolver documento pelo slug e compor seções |
| DocSection | Seção com título, âncora e expansão local |
| DocTable | Tabela com cabeçalhos e rolagem própria |
| DocNotice | Avisos e pendências com v-alert |
| CodeBlock | Código literal, seleção e cópia |
| MermaidDiagram | Renderizar diagrama e mostrar fallback em caso de erro |

Usar componentes Vuetify para layout, cards, botões, expansão e avisos. Os componentes não contêm regras específicas do Runner. Cada documento exporta `slug`, `categoria`, `titulo`, `resumo`, `estado`, `fontes` e `secoes`; cada seção tem ID, título e blocos de texto, lista, tabela, código, aviso ou diagrama.

Adicionar documento exige criar um módulo e acrescentar um import/registro no catálogo, sem modificar router ou componentes. Rotas genéricas: `/`, `/estrutura/:slug`, `/documentos/:slug` e `/guias/:slug`. Slug ou rota inexistente mostra uma página com retorno ao início.

Snippets propostos: `docpagina` (documento completo), `docsecao`, `doccodigo`, `doctabela`, `docdiagrama` e `docregistro` (import e registro no catálogo). O card é derivado do registro; não precisa de snippet de HTML duplicado. VS Code é o padrão proposto para a IDE; outra IDE pode receber os mesmos modelos em formato próprio.

Validação do catálogo rejeita slugs duplicados, campos obrigatórios vazios, IDs de seção duplicados, tipos de bloco desconhecidos e referências locais ausentes. Estado `Validado no ERP` exige evidência identificável; leitura de fontes locais não equivale a homologação.

## Grafo estrutural dos uses

O grafo será derivado de uma árvore sintática do subconjunto Pascal necessário para identificar cláusulas `uses`, distinguindo comentários, strings, identificadores e localização no fonte. Não será apresentado como AST completa do compilador Delphi nem como prova de resolução pelo interpretador ERP.

O extrator percorre os `.pas` da seleção documental, registra nós, arestas diretas, arquivo e linha, e calcula alcance transitivo sem inserir declarações redundantes. Dependências sem fonte são marcadas externas/não resolvidas. Nomes `P39_TDD_*` e `TDD_*` são preservados: variantes podem ter implementações diferentes; vínculos conceituais devem ser explícitos, sem fundir arquivos silenciosamente.

`TDD_IRUNNER` declara apenas `TDD_LOGS`, mas carrega o molde por `CodificacaoUnit('TDD_BASE_UNIT_IRUNNER')`; o molde declara `TDD_RUNNER,__USES_UNITS__`. Essas relações são dinâmicas e recebem arestas e legenda distintas. `TDD_FINISHED` usa globais do contexto interpretado sem declarar uses; acessos a símbolos compartilhados não serão inventados como arestas estáticas.

Artefato canônico: `docs/mapeamentoUses/TDD_IRUNNER.md`, acompanhado do inventário estruturado gerado. O portal consome esse mapa; o fluxo de chamadas aparece em outro diagrama. Atualizar os fontes e executar novamente o extrator deve regenerar as relações sem editar o diagrama manualmente.

## Conteúdo obrigatório do card Runner

O card “Estrutura e fluxo de IRunner.Executar” abre `/estrutura/runner`. As seções serão:

1. Contrato de configuração: `SetTDDUnit`, dois `AddParamsRun` (módulo e área como literais Pascal), `Executar` e entrada `Teste` sem parâmetros.
2. Montagem do código: leitura do molde, substituição dos marcadores e uma chamada a `Interpretar`.
3. Responsabilidades e links de fontes: IRUNNER, RUNNER, molde/base, STARTED, FINISHED, LOGS e CASOS_DE_TESTE.
4. Grafo dos uses diretos/transitivos e dependências dinâmicas.
5. Fluxo do lote, da tentativa, dos erros e da limpeza.
6. Estado global e execuções variáveis com os mesmos artefatos.
7. Histórico, logs, tempos e limites da validação.

Nomenclatura no portal: “BASE_UNIT” corresponde ao arquivo `TDD_BASE_UNIT_IRUNNER.pas`; “TDD_CASOS_DE_TESTES” corresponde ao fonte disponível `P39_TDD_CASOS_DE_TESTE.pas` (singular). Exibir nome real e rótulo conceitual para permitir localizar o arquivo.

Fluxo observado nos fontes:

```text
SetTDDUnit + AddParamsRun → Executar → molde preenchido → Interpretar
→ Main → ExecutarLote → SetupCasosTestes → First
→ [Run → SetarCasoTeste → métricas → Started → Teste
   → etapa ASSERTS reservada → fechar tempos → RegistrarMetricas]
→ Next / próximo caso → limpeza do lote
```

O molde controla `First/Next`; Started lê ID, descrição e JSON do registro corrente, valida versão e aplica parâmetros. Falhas do teste podem ser registradas e permitir continuar; falhas de preparação que não sejam incompatibilidade de versão propagam e interrompem o lote. Falhas de persistência e limpeza também propagam. O diagrama deve mostrar esses caminhos separadamente.

| Estado/artefato | Ciclo de vida a explicar |
| --- | --- |
| CDSCasosTestes e CDSResultadoEsperado | Carga no setup; cursor controlado pelo lote; encerramento no teardown |
| FHistoricoExecucao e FContextoCasoTeste | Reiniciados/configurados por SetarCasoTeste |
| FCasoTesteAtualId e FCasoTesteAtualJson | Reiniciados por tentativa e preenchidos em Started |
| FCDSMetricasTickDiff, FEtapaAtual e FNomeMetodoAtual | Tempos e etapa por tentativa; encerramento dos tempos abertos antes da persistência |
| FLogsCasoTeste | Limpa no início e fim de Run; snapshot no histórico antes de persistir; liberação no lote |
| FModoDebug e FExibirInstrucoes | Controles independentes de logs e exibição de instruções |
| Cache e parâmetros | Reutilização na execução e limpeza do lote; não prometer restauração de valores no ERP |
| FTDDUnit e FParamsCasosTeste | Configuração da montagem; não prometer chamadas repetidas seguras sem evidência no host |

`RegistrarMetricas` insere HISTORICO_EXECUCAO, obtém o ID e persiste METRICAS_TICK_DIFF vinculadas. METRICAS_ASSERTS está comentada. `SUCESSO` indica conclusão sem exceção do caminho implementado; não comprova aprovação de asserts. As chamadas Free e compartilhamento de globais serão documentados como observados, sem alegar isolamento, concorrência ou reentrância.

## Migração e verificação

Preservar os HTMLs originais antes de substituí-los por redirecionamentos. Mapear cada seção para um destino; separar explicações legadas das atuais. Os quatro temas existentes continuarão acessíveis pelo catálogo. A mudança de stack não autoriza descartar conteúdo.

Verificar entrada na raiz e sob `/TestesAutomatizadosERP/`, cards, links diretos, recarregamento, histórico voltar/avançar, rota inexistente, layout mobile e teclado. Conferir o conteúdo contra os fontes. Para o extrator, verificar comentários/strings contendo uses, cláusulas multilinha, dependências externas, ciclos, alias de prefixos e marcadores dinâmicos. Testar um documento criado pelos snippets sem alterar o router.

Preparar instruções e artefato estático para Pages. Publicação e habilitação do serviço são etapas posteriores à revisão do portal; o estado remoto atual deve ser consultado nessa etapa, sem reutilizar como atual o diagnóstico anterior.

## Referências consultadas

- [Vue — uso sem build e módulos](https://vuejs.org/guide/quick-start.html).
- [Vuetify — instalação CDN](https://vuetifyjs.com/en/getting-started/installation/).
- [Vue Router — histórico hash](https://router.vuejs.org/api/functions/createWebHashHistory.html).
- Fontes locais: `docs/assets/emDesenvolvimento/Runner/` e `docs/assets/configuracoesGerais/`.
- Diretriz local: `.agents/AGENTS.md`, seções de nomenclatura, herança de uses e mapas Mermaid.

## Execução

O aceite deste design autoriza o [plano de implementação](implementation-plan.md). Os critérios desta revisão e seu recorte prevalecem sobre as escolhas históricas de PrimeVue e catálogo ampliado da especificação anterior. A aplicação é construída no workspace; habilitação e publicação remota do Pages permanecem etapas posteriores à revisão do portal.
