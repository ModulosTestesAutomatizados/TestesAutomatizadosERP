# Consumo de TDD_RUN_MODULO pelo piloto financeiro

**Estado:** proposta para revisão; nenhuma implementação nesta etapa.

## Problem Statement

TDD_RUN_MODULO já está na cadeia de uses do runner, mas o piloto financeiro cria formulários diretamente. Queremos centralizar a abertura pelo menu nos métodos existentes do módulo, preservando as operações financeiras e as convenções de leitura do usuário. As chamadas de foco do módulo ainda contêm arrays vazios rejeitados pelo interpretador em execução anterior.

## Goals

- Reutilizar AbrirTela, TrazerParaFrente e FocarModulo nas aberturas aplicáveis.
- Manter a sequência duplicata receber, duplicata pagar, borderô receber e borderô pagar.
- Reutilizar telas existentes sem criar duplicatas ou perder os focos específicos dos campos.
- Não criar métodos auxiliares, wrappers ou cópias de FModulo/FDescModulo.

## Out of Scope

| Item | Motivo |
| --- | --- |
| JSON, sincronização, regras e valores financeiros | A mudança trata somente da abertura e apresentação das telas |
| STARTED, asserts, tempos e persistência do histórico | Preservar os contratos já existentes |
| Reescrever os mapeadores compartilhados de borderô | Seus consumidores legados mantêm o contrato atual; o piloto verificará a abertura antes de chamá-los |
| Fechamento genérico de janelas e novos métodos | O teardown financeiro já mantém essa responsabilidade |
| Documentação publicada | Trabalho em outra frente; esta especificação fica em .specs |
| Executar ERP, gravar no banco, sincronizar, stage ou commit nesta etapa | Pedido atual é somente criar a especificação |

## Evidência e pontos de alteração

| Fluxo | Situação atual | Alteração proposta |
| --- | --- | --- |
| Duplicata receber | _IncluirDuplicata(0), FCadReceber, criação direta em TDD_FIN_FINANCEIRO.pas:120–124 | Abrir pelo evento confirmado do menu quando a tela não existir; localizar e validar o formulário antes de obter componentes |
| Duplicata pagar | _IncluirDuplicata(1), FCadPagar, mesmo trecho | Mesma política, com evento próprio e formulário correspondente |
| Borderô receber | _IncluirBordero(0), FCadBorderoAcerto; MapearBordero também cria/exibe a tela | Abrir e validar antes de MapearBordero; preservar o mapeador compartilhado nesta iteração |
| Borderô pagar | _IncluirBordero(1), FCadBorderoPagamento, criação direta em TDD_FIN_FINANCEIRO.pas:259–266 | Abrir e validar antes de MapearComponentesBorderoPagamento e IniciarCDSCadastroBordero |
| Operações no módulo | P39_TDD_RUN_MODULO.pas:62–63,76 usa [] | Omitir o terceiro argumento nas chamadas sem parâmetros de SetFocus, Repaint e BringToFront |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Formulário já aberto | Reutilizar e apresentar a instância existente; não disparar novamente o evento de menu | Preserva o comportamento de procurar antes de criar e evita duplicação | Proposta para revisão |
| Foco da janela principal | Quando precisar abrir pelo menu: TrazerParaFrente, FocarModulo e AbrirTela, nessa ordem | Preparar o módulo antes de abrir a tela filha; não retirar foco durante preenchimento | Proposta para revisão |
| Evento de abertura | Usar somente nomes confirmados no ERP ou em fonte autoritativo do ambiente | Nome de formulário não é nome de evento; a pesquisa local não encontrou os quatro handlers | Levantamento obrigatório antes de implementar |
| Evento retorna sem abrir a tela | Interromper a etapa com erro identificando formulário e evento, sem recorrer a CriarFormPeloNome | Um fallback direto ocultaria a falha do novo caminho pelo menu | Proposta para revisão |
| Mapeadores legados | Não alterar assinaturas ou a criação defensiva atual; no piloto, chamar somente depois de confirmar que a tela está aberta | Reduz a superfície e evita quebrar outros testes | Proposta para revisão |
| Dependências | Consumir pela cadeia de uses existente e pelas anotações entre chaves | Convenção do interpretador e do usuário | Contexto da sessão |

**Open questions:** none — os comportamentos não discutidos têm uma proposta explícita na tabela acima, sujeita à revisão do usuário. Permanece um pré-requisito factual da implementação: identificar e comprovar os quatro eventos de menu. A especificação não autoriza substituí-los por nomes presumidos.

### Catálogo necessário antes da implementação

| Destino | Evento no FPrincipal | Evidência necessária |
| --- | --- | --- |
| FCadReceber | Ainda não identificado nos fontes locais | Nome exato e confirmação de que abre FCadReceber no módulo financeiro |
| FCadPagar | Ainda não identificado nos fontes locais | Nome exato e confirmação de que abre FCadPagar |
| FCadBorderoAcerto | Ainda não identificado nos fontes locais | Nome exato e confirmação de que abre FCadBorderoAcerto |
| FCadBorderoPagamento | Ainda não identificado nos fontes locais | Nome exato e confirmação de que abre FCadBorderoPagamento |

O levantamento deve usar leitura dos fontes reais ou inspeção do ambiente, sem executar operações financeiras ou gravar dados. Atualizar este catálogo com a origem da evidência antes de modificar os pontos de abertura.

## User Stories

### P1: Abrir as telas financeiras pelo módulo existente

**User Story:** Como mantenedor do piloto, quero que a abertura das quatro telas reutilize TDD_RUN_MODULO para manter um único caminho de interação com o menu.

**Acceptance Criteria**:

1. WHEN uma das quatro etapas necessita de um formulário ainda inexistente THEN o piloto SHALL executar TrazerParaFrente, FocarModulo e AbrirTela com o evento confirmado daquela tela, nessa ordem. (MODFIN-01)
2. WHEN o formulário esperado já existe THEN o piloto SHALL reutilizar e apresentar essa instância sem disparar o evento de abertura novamente. (MODFIN-02)
3. WHEN AbrirTela retorna THEN o piloto SHALL localizar o formulário esperado antes de obter ou mapear seus componentes. (MODFIN-03)
4. IF o formulário esperado não existe após o evento THEN o piloto SHALL interromper a etapa com erro contendo o nome do formulário e do evento, sem criar o formulário diretamente. (MODFIN-04)
5. The piloto SHALL preservar a ordem das quatro operações financeiras, seus valores, filtros, cliques de inclusão/gravação e capturas de datasets. (MODFIN-05)
6. The piloto SHALL manter edtCliente.SetFocus e edtNovoBanco.SetFocus nas posições atuais do preenchimento do borderô. (MODFIN-06)
7. The teardown financeiro SHALL continuar responsável por cancelar edições pendentes e fechar as telas financeiras. (MODFIN-07)
8. WHEN SetFocus, Repaint ou BringToFront é chamado por TDD_RUN_MODULO THEN a chamada reflexiva SHALL omitir o argumento opcional de parâmetros, sem utilizar []. (MODFIN-08)
9. IF o contexto do módulo ou o formulário principal não está disponível THEN os métodos do módulo SHALL propagar suas exceções pelos tratamentos de etapa já existentes no piloto. (MODFIN-09)
10. The implementação SHALL reutilizar os métodos e estados existentes sem criar wrappers, métodos adicionais ou cópias de FModulo/FDescModulo. (MODFIN-10)
11. WHEN uma abertura pelo menu é tentada THEN o piloto SHALL registrar o formulário e o evento por RegistrarLog antes de invocar o menu, independentemente do modo debug. (MODFIN-11)

**Independent Test:** simular formulários ausentes e existentes para cada uma das quatro etapas; conferir a sequência de chamadas, a instância usada e a ausência de criação direta. Simular evento que não abre tela e verificar erro antes do mapeamento. No ERP, confirmar o caminho real de abertura e executar o lote financeiro autorizado com as mesmas expectativas de resultado anteriores.

## Edge Cases

- Tela já aberta, inclusive no caso seguinte do lote: reaproveitar a instância, sem guardar referências locais antigas entre tentativas.
- Evento inexistente ou que lança exceção: preservar a causa no tratamento de etapa e executar o finally de teardown existente; não adicionar tentativas automáticas.
- Evento abre outro formulário: reprovar pela ausência do formulário esperado antes do acesso a componentes.
- Principal ausente ou contexto inválido: falhar antes dos cliques da etapa; a limpeza segue o fluxo atual.
- Mapeamento de recebimento continua contendo criação defensiva para legados, mas essa alternativa não deve ser alcançada para compensar falha de abertura no novo fluxo.
- Falha de abertura depois de uma etapa financeira concluída não implica rollback do lote; a refatoração preserva o comportamento atual de falhas parciais.

## Requirement Traceability

| Requirement ID | Story | Phase | Status |
| --- | --- | --- | --- |
| MODFIN-01 | P1 | Specify | Pending |
| MODFIN-02 | P1 | Specify | Pending |
| MODFIN-03 | P1 | Specify | Pending |
| MODFIN-04 | P1 | Specify | Pending |
| MODFIN-05 | P1 | Specify | Pending |
| MODFIN-06 | P1 | Specify | Pending |
| MODFIN-07 | P1 | Specify | Pending |
| MODFIN-08 | P1 | Specify | Pending |
| MODFIN-09 | P1 | Specify | Pending |
| MODFIN-10 | P1 | Specify | Pending |
| MODFIN-11 | P1 | Specify | Pending |

## Success Criteria

- Catálogo dos quatro eventos preenchido com evidência antes da implementação das aberturas.
- Critérios MODFIN-01 a MODFIN-11 cobertos por verificações locais dos comportamentos alterados, sem tratar simulação como prova do ERP.
- Verificação nativa no ambiente de teste para as quatro telas, com e sem instância previamente aberta.
- Conjunto financeiro mantém seus resultados e teardown após a troca do caminho de abertura.
- Nenhuma mudança em documentação publicada, JSON ou regras financeiras.

## Plano curto para a próxima etapa

1. Confirmar os quatro eventos e atualizar o catálogo; nenhuma alteração de abertura antes disso.
2. Ajustar os métodos existentes em TDD_FIN_FINANCEIRO e corrigir as três chamadas sem parâmetros em P39_TDD_RUN_MODULO; manter assinaturas e mapeadores compartilhados.
3. Verificar cenários de abertura, reutilização e falha; executar regressões pertinentes e revisão independente. Validação no ERP é separada e deve registrar evidências reais.

Não criar design.md ou tasks.md nesta etapa: o plano cabe em três passos. A instrução vigente de manter alterações sem commit permanece válida.
