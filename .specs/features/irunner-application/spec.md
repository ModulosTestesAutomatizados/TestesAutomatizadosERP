# TDD_RUN_APPLICATION e catálogo de telas

**Estado:** implementação local e documentação concluídas; testes locais e revisão independente de runtime aprovados. Cadastro remoto e confirmação no ERP permanecem pendentes e não foram executados nesta sessão.

**Ajuste posterior do usuário:** o piloto financeiro passa temporariamente somente eventos de máscara EVENTO_INCLUIR_DUPLICATA_RECEBER, EVENTO_INCLUIR_DUPLICATA_PAGAR, EVENTO_INCLUIR_BORDERO_RECEBIMENTO e EVENTO_INCLUIR_BORDERO_PAGAMENTO. O usuário substituirá esses literais pelos eventos reais antes de executar. A evolução do catálogo/cache e da Application foi adiada; o runtime da Application permanece inalterado nesta correção. A verificação de integração APP-09 acompanha esses quatro destinos temporários.

## Problem Statement

O usuário substituiu a proposta anterior de abertura exclusivamente pelo menu por AbrirTela com Caption, Form ou Evento. Os artefatos foram movidos para docs/assets/configuracoesGerais/arquiteturaIRunner e o arquivo APPLICATION já foi renomeado por ele. Falta reconciliar referências, resolver aliases e oferecer um helper de coleta no portal.

## Goals

- Manter uma única procedure AbrirTela(pTela :string), sem overloads ou wrappers.
- Manter o DE → PARA num JSON versionado, separado por módulo e indexado pelo nome do Form.
- Priorizar evento confirmado; abrir por Form quando não houver evento registrado, preservando o comportamento anterior do financeiro.
- Documentar o helper e seus efeitos sem executá-lo automaticamente em testes ou no portal.

## Out of Scope

Publicar units remotas, acessar/escrever banco, executar menus reais, alterar regras financeiras ou afirmar homologação ERP. O helper não alimenta o runtime automaticamente e não invoca todos os métodos do principal. Preservar alterações e movimentações existentes do usuário, sem commits.

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Fonte do catálogo | TDD_RUN_APPLICATION_MAPEAMENTO_JSON.json junto da arquitetura; carregada como P39_TDD_RUN_APPLICATION_MAPEAMENTO_JSON | Fonte única versionada e reutilizável por qualquer unit de teste; independente de JSON do caso | Escolha técnica proposta nesta execução |
| Estrutura | Módulo → nome do Form → caption e evento | Evita duplicar o Form e impede cruzamento de aliases entre módulos | Escolha técnica |
| Comparação | Trim, UpperCase e remoção de & no caption | Atalhos visuais não fazem parte do título amigável; acentos permanecem significativos | Escolha técnica |
| Evento direto | Nome encontrado por MetodosDeObjeto do principal continua executando diretamente | Preserva contrato anterior sem exigir cadastrar todos os eventos | Compatibilidade |
| Form sem evento | Usar Form existente ou CriarFormPeloNome, apenas para Form registrado no catálogo | Nova solicitação permite Evento ou Form como destino final | Interpretação explicitada ao usuário |
| Caption desconhecido ou ambíguo | Erro antes de abrir qualquer tela | Não escolher silenciosamente nem executar texto como método | Escolha técnica |
| Dados iniciais | Só Contas a Receber tem Caption/Evento preenchidos; demais Forms do piloto sem aliases inventados | FCadReceber e Receber1Click confirmados pelo usuário; outros Forms confirmados nos fontes | Evidência explícita |
| Coleta | Um evento/menu selecionado por execução, comparação de telas antes/depois, Close somente de telas novas | Helper atual executa métodos indiscriminadamente e usa Form.Caption em vez do menu | Correção necessária |

**Open questions:** none — decisões técnicas e limites estão explicitados acima. Catálogo adicional depende de revisão dos dados coletados no ERP; isso não impede os destinos Form já conhecidos.

## User Stories

### P1: Abertura legível por alias

**Acceptance Criteria**:

1. WHEN o runner carrega a integração visual THEN ele SHALL referenciar TDD_RUN_APPLICATION em vez de TDD_RUN_MODULO. (APP-01)
2. WHEN AbrirTela recebe Caption ou Form registrado THEN ela SHALL resolver exatamente uma entrada do módulo corrente por comparação normalizada. (APP-02)
3. IF duas entradas correspondem à mesma entrada de usuário THEN AbrirTela SHALL rejeitar a ambiguidade antes de qualquer abertura. (APP-03)
4. WHEN o Form resolvido já está aberto THEN AbrirTela SHALL exibir essa instância sem disparar evento ou criar outra. (APP-04)
5. WHEN uma entrada tem evento e o Form está ausente THEN AbrirTela SHALL chamar o evento após TrazerParaFrente e FocarModulo, e confirmar o Form esperado. (APP-05)
6. WHEN uma entrada não tem evento e o Form está ausente THEN AbrirTela SHALL criar e apresentar o Form registrado, mantendo o caminho anterior do financeiro. (APP-06)
7. WHEN um evento do principal é informado diretamente THEN AbrirTela SHALL continuar aceitando esse identificador sem exigir uma entrada no catálogo. (APP-07)
8. IF catálogo, módulo, principal, alias ou Form esperado é inválido THEN a operação SHALL propagar erro descritivo sem fallback que esconda falha do evento. (APP-08)
9. WHEN o piloto abre uma das quatro telas financeiras THEN ele SHALL usar AbrirTela e preservar preenchimento, capturas, foco dos campos e teardown existentes. (APP-09)

**Independent Test:** simular a aplicação e catálogo, conferir destinos resolvidos, normalização, isolamento por módulo, reutilização e falhas sem efeitos; verificar as quatro integrações do piloto.

### P1: Helper de coleta e documentação

**Acceptance Criteria**:

1. WHEN o helper é executado THEN ele SHALL invocar somente o evento selecionado e usar o Caption do componente de menu selecionado. (APP-10)
2. WHEN o helper compara telas antes e depois THEN ele SHALL registrar somente Forms novos e fechar apenas esses Forms, sem Free de formulários ou datamodules compartilhados. (APP-11)
3. WHEN a documentação é gerada THEN ela SHALL expor o helper no catálogo com estados, configuração, efeitos, limitações e código canônico copiável, sem declarar validação ERP. (APP-12)

**Independent Test:** testar coleta com lista prévia e posterior, menu ausente e nenhum Form novo; check/build do portal e inspeção dos dados exportados.

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| APP-01 | Abertura | Execute | Verified |
| APP-02 | Abertura | Execute | Verified |
| APP-03 | Abertura | Execute | Verified |
| APP-04 | Abertura | Execute | Verified |
| APP-05 | Abertura | Execute | Verified |
| APP-06 | Abertura | Execute | Verified |
| APP-07 | Abertura | Execute | Verified |
| APP-08 | Abertura | Execute | Verified |
| APP-09 | Abertura | Execute | Verified |
| APP-10 | Helper | Execute | Verified |
| APP-11 | Helper | Execute | Verified |
| APP-12 | Helper | Execute | Verified |

Verified indica evidência local, não homologação no ERP. Evidências e limites em revisao-independente.md e relatorio-servico.md.

## Success Criteria

Testes locais dos contratos, revisão independente, check/build do portal e distinção explícita de teste local e execução nativa. Nenhuma publicação remota, gravação em banco ou commit. A proposta financeiro-consumo-modulo anterior é supersedida quanto à exigência de evento para todas as telas.

## Plano

1. Implementar catálogo e resolução no método existente e integrar piloto.
2. Corrigir helper e documentá-lo pela skill contribuir-documentacao; reconciliar paths e inventários necessários ao build.
3. Verificar contratos e portal, revisar de forma independente e registrar limites para teste no ERP.
