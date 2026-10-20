# Carga de faturamento — issue #36

**Estado:** TLC aprovada; MVP local em implementação, homologação ERP pendente. **Base local:** `11d3f27` (a árvore contém uma exclusão preexistente em `docs/assets/emDesenvolvimento/TDD_JSON_FINANCEIRO.json`). **Fonte de demanda:** https://github.com/ModulosTestesAutomatizados/TestesAutomatizadosERP/issues/36

## Problem Statement

O faturamento possui casos de Pedido de Venda, mas não possui um caso de inclusão de Carga. A issue #36 solicita um MVP do cenário feliz, com pedidos de venda e os demais registros necessários, mapeamento de todas as abas, unit de teste reutilizável e processamento instalável. O cadastro no banco dedicado precisa criar a área `CARGA` sob o módulo existente `FATURAMENTO`.

## Goals

- [ ] Sincronizar um caso sob `FATURAMENTO` / `CARGA` a partir de uma única fonte `TDD_FAT_CARGA_JSON`.
- [ ] Disponibilizar `TDD_FAT_CARGA` para incluir uma carga válida no cenário feliz, por `TDD_FAT_PROCESSAMENTO_CARGA`.
- [ ] Mapear todas as abas da tela de carga em `TDD_FAT_MAPEAMENTO_COMPONENTES_CARGA`, com nomes verificados no ERP ou no fonte da tela.
- [ ] Reutilizar rotinas coesas de Pedido de Venda onde o contrato permitir, sem chamar o `main` legado nem mover o cursor do lote IRunner dentro do caso.

## Out of Scope

| Item | Motivo |
| --- | --- |
| Cenários de erro de negócio e combinações de carga | A issue limita o MVP ao cenário feliz. |
| Alterar a lógica do caso legado de Pedido de Venda | A integração pode reutilizar métodos existentes sem refatorar o legado nesta entrega. |
| Homologação presumida por testes locais ou documentação | A execução nativa no JvInterpreter precisa de evidência separada. |
| Criar módulo `FATURAMENTO` | O módulo já existe; só a área `CARGA` será criada pela sincronização. |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Identidade do registro | `FATURAMENTO` / `CARGA` / `TDD_FAT_CARGA`, fonte `TDD_FAT_CARGA_JSON` | Segue os nomes informados e a assinatura de `RegistrarCasoTeste`. | Parcial: a descrição do caso é proposta. |
| Fonte JSON | Arquivo local com objeto raiz; `parametros` é opcional; `resultadoEsperado` e `camposDisponiveis` seguem a resolução da sincronização atual | Contrato de fonte única já implementado. | Proposta. |
| Pedidos de venda | A massa informa `843172`, indicado pelo usuário; consulta somente leitura confirmou tipo 1, empresa 1 e zero vínculos em `CARGA_DOCUMENTOS` | A entrada legada de Pedido de Venda possui cursor próprio e não fornece o código do documento à casca IRunner. | Código e estado atual confirmados no banco; elegibilidade da tela pendente. |
| Demais registros relevantes | O MVP liga um pedido de venda, preenche empresa, data de emissão e serviço de envio e mantém os demais campos em seus padrões da tela; requisitos adicionais só entram após observação da gravação | O esquema confirma `DTEMISSAO_CARGA` e `SERVICODEENVIO_CARGA` como NOT NULL; o DFM não contém todas as validações de negócio. | Esquema confirmado; execução nativa pendente. |
| Mapeamento de abas | Cobrir as 28 abas estáticas de `FCadCarga` (8 principais e 20 internas); conferir na tela se há abas dinâmicas. Automatizar preenchimento somente dos campos do cenário feliz | Inventário extraído do recurso DFM do executável fornecido. | Evidência estática; conferência em execução pendente. |
| Form, DM e evento de menu | `FCadCarga`, `DMCadCarga` e candidato `CadastrodeCarga1Click`; verificar a abertura real antes de codificar o mapeador | Nomes extraídos dos recursos `TFCADCARGA`, `TDMCADCARGA` e `TFPRINCIPAL`. | Evidência estática; execução pendente. |
| Nome remoto das units | Verificar cadastro real no ambiente: `TDD_*` local e eventual `P39_TDD_*` remoto | Alias documental e nome de arquivo não comprovam instalação. | Aguardando levantamento. |
| Requisito de versão | Preencher a versão mínima após validar o ambiente alvo; não copiar `160.00` do piloto financeiro | A versão da Carga não consta na issue. | Aguardando levantamento. |

**Open questions:** O dataset `CDSDocumentos` expõe `DOCUMENTO_CARDOC` como a tabela `CARGA_DOCUMENTOS`? O pedido `843172` passa pelas regras da tela e quais outros campos a gravação exige? O MVP exige `CODIGO_CARGA` positivo após reabertura pelo parâmetro `COD` e o vínculo persistido em `CARGA_DOCUMENTOS`; esses critérios precisam ser confirmados no ERP. O formulário, o DataModule, o evento candidato e as 28 abas estáticas constam de `inventario-executavel.md`.

## User Stories

### P1: Registrar a área e a massa da Carga ⭐ MVP

**User Story:** Como mantenedor do TDD, quero sincronizar o caso de Carga no módulo de Faturamento para que o runner possa selecioná-lo por módulo e área.

**Why P1:** Sem o registro, o processamento não encontra o lote.

**Acceptance Criteria:**

1. WHEN a sincronização aceita o registro de Carga THEN o sistema SHALL localizar o módulo `FATURAMENTO`, criar ou reutilizar a área `CARGA` e registrar a descrição `TDD_FAT_CARGA` com a fonte `TDD_FAT_CARGA_JSON`. (CARGA-01)
2. WHEN o registro é sincronizado novamente e a atualização é confirmada THEN o sistema SHALL atualizar o mesmo caso identificado por módulo, área e descrição, sem criar duplicata. (CARGA-02)
3. IF a fonte `TDD_FAT_CARGA_JSON` não existe, está vazia ou contém JSON inválido THEN a sincronização SHALL interromper esse registro antes de criar módulo/área ou escrever o caso. (CARGA-03)
4. WHEN a fonte JSON válida é registrada THEN o sistema SHALL manter a massa na raiz de `CASO_TESTE_CT` e as tags resolvidas `camposDisponiveis` e `resultadoEsperado` nas projeções existentes. (CARGA-04)

**Independent Test:** executar uma sonda local com leitura e persistência simuladas para confirmar identidade, payload, reexecução e falha antes de escrita; confirmar em ambiente dedicado somente na etapa de instalação autorizada.

### P1: Mapear e executar o cenário feliz ⭐ MVP

**User Story:** Como testador de Faturamento, quero incluir uma Carga contendo pedidos de venda válidos para observar a gravação e o resultado esperado por caso.

**Why P1:** É a entrega funcional descrita na issue.

**Acceptance Criteria:**

1. WHEN o mapeador de `FCadCarga` é concluído THEN `TDD_FAT_MAPEAMENTO_COMPONENTES_CARGA` SHALL declarar as 28 abas estáticas identificadas no executável, seus 5 controles de abas e os componentes usados para preencher e gravar o cenário feliz, acrescidos de eventuais abas dinâmicas confirmadas no ERP. (CARGA-05)
2. WHEN `TDD_FAT_PROCESSAMENTO_CARGA` é executado THEN o sistema SHALL configurar `TDD_FAT_CARGA` com módulo `FATURAMENTO` e área `CARGA` e iniciar o IRunner uma vez. (CARGA-06)
3. WHEN o IRunner entrega um caso corrente válido THEN `TDD_FAT_CARGA.Teste` SHALL validar a massa, abrir a tela comprovada, vincular ao menos um pedido de venda apto, preencher os campos obrigatórios descobertos no levantamento e acionar a gravação. (CARGA-07)
4. WHEN a gravação conclui THEN o caso SHALL capturar o identificador persistido da Carga e as evidências necessárias para comparar o resultado esperado antes de liberar a tela. (CARGA-08)
5. IF a tela, um componente obrigatório ou o pedido de venda apto não está disponível antes da gravação THEN o caso SHALL falhar com diagnóstico da etapa e executar sua limpeza sem acionar a gravação. (CARGA-09)
6. WHEN o caso termina com sucesso ou falha THEN `TDD_FAT_CARGA` SHALL liberar apenas seus recursos e deixar o cursor e os datasets do lote sob responsabilidade do IRunner. (CARGA-10)

**Independent Test:** validar a sequência do caso com fronteiras ERP simuladas, seguida de execução nativa em ambiente de teste com pedido apto e conferência do registro persistido.

## Edge Cases

- IF o cadastro da Carga ou o pedido já foi consumido por execução anterior THEN o caso SHALL detectar a pré-condição e falhar com diagnóstico, sem selecionar silenciosamente outro registro. (CARGA-11)
- IF a gravação retorna sem identificador verificável THEN o caso SHALL registrar falha, mesmo que a tela tenha fechado. (CARGA-12)

## Implicit Requirement Dimensions

| Dimension | Resolution |
| --- | --- |
| Input validation & bounds | CARGA-03, CARGA-07 e inventário das tags obrigatórias após levantamento. |
| Failure / partial failure | CARGA-09 e CARGA-12; limpeza local não implica rollback do ERP. |
| Idempotency / retry / duplicates | CARGA-02 para cadastro TDD; CARGA-11 para massa da Carga. |
| Auth boundaries & rate limits | N/A: executado pelo mecanismo e permissões existentes do ERP. |
| Concurrency / ordering | N/A para MVP de um caso sequencial; confirmar exclusividade da massa na execução nativa. |
| Data lifecycle / expiry | N/A: a issue não solicita exclusão de cargas criadas. |
| Observability | CARGA-08, CARGA-09 e histórico já registrado pelo IRunner. |
| External-dependency failure | CARGA-03 e CARGA-09 cobrem fonte, tela e pedido indisponíveis. |
| State-transition integrity | CARGA-07 e CARGA-12 exigem gravação e identificador verificável. |

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| CARGA-01 | Registrar | Specify | Pending |
| CARGA-02 | Registrar | Specify | Pending |
| CARGA-03 | Registrar | Specify | Pending |
| CARGA-04 | Registrar | Specify | Pending |
| CARGA-05 | Mapear e executar | Specify | Pending |
| CARGA-06 | Mapear e executar | Specify | Pending |
| CARGA-07 | Mapear e executar | Specify | Pending |
| CARGA-08 | Mapear e executar | Specify | Pending |
| CARGA-09 | Mapear e executar | Specify | Pending |
| CARGA-10 | Mapear e executar | Specify | Pending |
| CARGA-11 | Mapear e executar | Specify | Pending |
| CARGA-12 | Mapear e executar | Specify | Pending |

**Coverage:** 12 total, 0 mapped to tasks, 12 pending.

## Success Criteria

- [ ] Área `CARGA` e caso registrados sob `FATURAMENTO`, com reexecução de sincronização sem duplicata.
- [ ] Inventário de todas as abas conferido contra o fonte ou a tela real e mapeador instalável.
- [ ] Um caso de Carga com pedido de venda apto gravado e identificado em ambiente de teste.
- [ ] Histórico do IRunner registra sucesso e evidências; falhas de pré-condição e gravação registram diagnóstico.
- [ ] Resultado de sondas locais separado da evidência de interpretação e persistência no ERP.

## Sequência de entrega proposta

1. Confrontar `inventario-executavel.md` com a tela em execução; confirmar `CadastrodeCarga1Click`, abas dinâmicas, campos obrigatórios e vínculos necessários; fechar o JSON e o resultado esperado com massa apta.
2. Acrescentar o registro `FATURAMENTO` / `CARGA` na sincronização existente e criar a fonte `TDD_FAT_CARGA_JSON`, verificando nomes locais/remotos e versão mínima.
3. Criar `TDD_FAT_MAPEAMENTO_COMPONENTES_CARGA` para localizar tela, abas, componentes e datasets por nomes confirmados.
4. Criar `TDD_FAT_CARGA` com validação do caso corrente, preparação/vínculo do pedido, gravação, captura do resultado e limpeza; reutilizar rotinas do núcleo de Pedido de Venda somente após confirmar que não avançam seu cursor próprio.
5. Criar `TDD_FAT_PROCESSAMENTO_CARGA` como entrada do IRunner para `FATURAMENTO` / `CARGA`.
6. Verificar os contratos localmente e, em etapa separada no ambiente de teste, instalar as units, sincronizar o cadastro e executar o cenário para conferir o registro persistido.

## Fontes consultadas

- `Documentacoes/app/components/helpers/sincronizacao/conteudo/p39-tdd-registrar-caso-teste.ts` — fonte única, identidade, fallbacks e projeções.
- `Documentacoes/app/components/casos-de-teste/conteudo/p39-tdd-fat-pedido-venda.ts` — contrato e limites do Pedido de Venda.
- `Documentacoes/app/components/units/irunner/conteudo/p39-tdd-fin-processamento-financeiro.ts` — padrão de processamento.
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas` — registros atuais.
- `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas` — implementação exata da sincronização.
- `docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_IRUNNER.pas` e `TDD_RUN_UNIT_BASE_IRUNNER.pas` — contrato de lote e entrada `Teste`.
- `docs/assets/casosTestesFinanceiro/processamentos/P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO.pas` e `TDD_FIN_FINANCEIRO.pas` — precedente de processamento e caso por registro.
- `inventario-executavel.md` — recursos estáticos de `FaturamentoMC.exe` fornecido pelo usuário, incluindo formulário, DataModule, abas e componentes.

O índice exportado em `Documentacoes/.pages-output/knowledge/index.json` não existe neste checkout. Esta especificação usa os fontes locais em `11d3f27`; os estados `em-uso` e `em-desenvolvimento` das páginas não comprovam validação no ERP.
