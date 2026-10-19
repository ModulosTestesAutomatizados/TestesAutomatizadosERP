# Incorporação do pacote de estabilização

## Autoridade e conflitos

O pacote externo foi recebido para planejamento editorial, não como patch ou autorização para mudar Pascal. Os snapshots em `referencias/estabilizacao/` preservam o material recebido; `proveniencia.md` registra origem, HEAD observado e hashes. Não são documentos ativos do portal nem specs paralelas a implementar isoladamente.

A spec desta feature governa migração/arquitetura/contribuição. Os contratos de conteúdo DOC-01..18 do snapshot são incorporados por TDD-02 e detalhados abaixo. DOC-19 apenas limitava o trabalho da sessão que produziu o repasse; não impede a futura implementação documental aqui. A proibição de redesenhar/trocar framework do pacote é substituída, nesta feature, pelo pedido expresso de Vite/SFC; identidade visual e semântica continuam preservadas.

O pacote não obriga recriar páginas e endereços excluídos pelo usuário. Cada responsabilidade editorial terá destino no catálogo atual; caminho antigo da matriz externa é pista de localização, não contrato de pasta. Alias de busca, redirect e nome remoto não são equivalentes.

Se os fontes consolidados mudarem, registrar fonte, hash anterior/atual, diferença de contrato e atualização necessária; não trocar hashes para silenciar a validação. Fontes ausentes nesta worktree não serão copiados automaticamente. Nenhuma worktree ou credencial externa será necessária para build final.

## Rastreabilidade editorial completa

Todos os destinos abaixo são áreas funcionais propostas; nomes físicos finais pertencem ao Design. Não há evidência de implementação nesta matriz.

| Origem | Resultado preservado | Destino na organização proposta | Evidência futura |
| --- | --- | --- | --- |
| DOC-01 | Nomes/caminhos atuais em título, fontes, exemplos e diagrama | Units/IRunner, Casos, Helpers e catálogo | Manifesto reconciliado e referências sem fonte antiga ativa |
| DOC-02 | Nome local, remoto P39_, alias e histórico distintos | Contrato editorial/citação e páginas de unit | Campos e exemplos de busca/redirect sem falsa equivalência |
| DOC-03 | Unicidade, assinaturas, donos de estado e links | Todas as slices de conteúdo | Validação de catálogo e página individual |
| DOC-04 | Geração única, lote controla cursor, captura antes do fechamento, ASSERTS após TEARDOWN | Arquitetura/IRunner e caso financeiro | Fluxograma de execução e fontes reconciliados |
| DOC-05 | Reset no ciclo, capturas/acúmulo ASSERTS, comparação no validador, ticks no runner, persistência FINISHED | Units/IRunner e validação | Tabelas de dono/produtor/consumidor/ciclo e links por unit |
| DOC-06 | Assert reprovado influencia FALHA, continuidade condicionada, resumo central | Fluxo e RUN_RUNNER/UNIT_BASE | Cenários de falha documentados conforme fonte |
| DOC-07 | Histórico, asserts agregados, ticks, LOGS_PROCESSAMENTO_HE e persistência parcial sem retry | RUN_FINISHED e docs/MER.md | Campos/ordem conferidos; nenhuma migration executada |
| DOC-08 | FModoDebug distinto de FExibirInstrucoes; transmissão ao programa gerado | RUN_LOGS e RUN_IRUNNER | Exemplos e limites coerentes |
| DOC-09 | Tick relativo, volta Cardinal, zero reservado | RUN_RUNNER | Assinatura/cálculo e limites atuais |
| DOC-10 | RegistrarCasoTeste com seis argumentos e fonte JSON única | Helpers/Sincronização e autoria de casos | Assinatura e projeção das propriedades reservadas |
| DOC-11 | Todos os estados dos defaults, distinguindo ausente e vazio | Helpers/Sincronização | Tabela completa de decisões e exemplos JSON |
| DOC-12 | Fonte/propriedade/fallback inválido falha antes da escrita | Helpers/Sincronização | Fluxo de erro sem fallback silencioso |
| DOC-13 | Três modelos completos versionados no conteúdo | Caso financeiro e conteúdo de configuração/defaults | Terminal copiável, tabela de objetos/campos e build sem JSON ignorado |
| DOC-14 | Retirar pendências superadas e APIs removidas do conteúdo ativo | Catálogo e páginas migradas | Busca textual contextualizada e histórico identificado |
| DOC-15 | AST real com hashes, paths, linhas e edges de fontes reconciliados | docs/MAPEAMENTO_AST_USES_UNITS por documentação | Inventário e validação do build atualizados; uses separado de cargas/estado |
| DOC-16 | Parâmetros aprovados e limitação GetValueJson para objetos | STARTED e conteúdo de parâmetros | Fonte atual e aviso sobre ausência de restauração automática |
| DOC-17 | Não promover teste local a homologação ERP | Estado/evidência em todas as páginas novas | Status validado-no-erp condicionado a evidência identificável |
| DOC-18 | Check, build, rotas, fontes, diagramas, busca e aliases | Gates da migração e revisão editorial final | Relatório novo; não reaproveitar PASS histórico |
| DOC-19 | Somente pacote de repasse na sessão de origem | Proveniência | Não é tarefa editorial nem restrição da futura Execute desta feature |

## Casos de configuração obrigatórios

Preservar a tabela completa do snapshot: resultadoEsperado ausente usa mínimo remoto; objeto vazio explícito não usa mínimo; objeto preenchido é preservado. camposDisponiveis ausente ou vazio usa mínimo remoto, preenchido é preservado. Propriedades reservadas null/escalar/array falham. Fonte/mínimo obrigatório indisponível ou inválido propaga erro antes da escrita. Remover somente propriedades reservadas da raiz do payload do caso, preservando homônimas aninhadas.

Os três modelos integrais estão no snapshot de inventário: financeiro, asserts mínimo e campos mínimo. Não introduzir envelope casoTeste nem raiz asserts. Exibir o modelo financeiro com zeros como preenchimento obrigatório, não massa válida universal. A leitura no ERP é via CodificacaoUnit, não arquivo de disco.

## Pontos a reconciliar antes de conteúdo e grafos

- Novo nome financeiro do snapshot difere do arquivo local observado nesta sessão.
- Mudanças locais já substituíram parte dos P39_TDD_* por TDD_RUN_*; título/menu não podem ser normalizados de volta por regex anterior.
- A ausência de ASSERTS como documento passa a ser pendência desta entrega; não permanece como API não implementada quando o fonte a comprovar.
- Registrar e sincronizar já têm páginas individuais no catálogo atual; atualizar conteúdo, não duplicar.
- Inventário registra reexecução com FLogsCasoTeste liberado sem nil e limitações de captura nativa. Confirmar estado após reconciliação e manter limitação se persistir; não corrigir Pascal neste trabalho.
- REFERÊNCIAS ou páginas antigas ausentes do novo mapa não voltam ao menu para acomodar instruções desatualizadas do repasse.

## Ordem proposta

Fechar abordagem e baseline → migrar ferramentas/SFCs mantendo semântica da baseline → reconciliar contratos TDD → atualizar páginas, busca/citações e grafos → atualizar autoria/snippets/skill → validar conjunto. É uma sequência de planejamento, não tasks aprovadas nem execução iniciada.

## Reconciliação posterior: fontes atualizados pelo usuário

A confirmação posterior do usuário torna docs/assets atual a referência de código. Ver reconciliacao-fontes.md. DOC-10/11/13 passam a preservar o formato atual: raiz do caso com objetos nomeados recompostos e wrappers nas colunas específicas, validador compatível com wrapper e raiz histórica. A chave de cadastro financeiro atual é TDD_FIN_FINANCEIRO. Os três JSONs de docs/assets/snippets são moldes compartilhados versionáveis; não são as massas pessoais ignoradas do pacote anterior. Os snapshots de proveniência permanecem intactos como histórico.
