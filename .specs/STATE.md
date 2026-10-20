# Estado do trabalho TLC

## Decisions

### AD-001: Reutilizar os métodos existentes do IRunner

Não criar wrappers de preparação, falha, encerramento ou limpeza nesta iteração. O cálculo relativo pertence a RegistrarTick; a leitura dos parâmetros pertence a AplicarParametrosDoCasoTeste; o contexto pertence a SetarCasoTeste; o fechamento de métricas e a persistência pertencem a RegistrarMetricas. A casca mantém a ordem, os finally e o controle do lote.

### AD-002: Um checkpoint, próxima iteração sem commit

O usuário solicitou o checkpoint `e47d2a4` antes da reorganização. As alterações de irunner-casca-enxuta, sua especificação e suas evidências ficam fora do index e sem novo commit. Não executar push ou gravação no banco.

### AD-003: Preservar debug e distinguir validação local de ERP

TDD_LOGS mantém a captura condicionada a FModoDebug. As sondas locais executam um subconjunto do fonte Pascal traduzido com fronteiras ERP substituídas; não são compilação Pascal nem evidência de persistência real. A confirmação no JvInterpreter é uma etapa separada.

### AD-004: Contexto sempre obtido do registro corrente

SetarCasoTeste recebe somente módulo e área. O usuário confirmou que o fluxo sempre itera o lote; a descrição não é mais argumento nem alternativa opcional, sendo lida do CDS após a reinicialização segura do contexto.

## Handoff

- Feature atual: `.specs/features/fat-carga-issue-36/spec.md`, aprovada pelo usuário. Arquivos Pascal/JSON do MVP em `docs/assets/emDesenvolvimento/carga`; planejamento e evidências na feature TLC.
- Sincronização alterada em `docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas` para criar/reutilizar `FATURAMENTO/CARGA` com fonte `TDD_FAT_CARGA_JSON`.
- Pedido informado pelo usuário: `843172`. Leitura somente leitura no banco dedicado de testes confirmou tipo 1, empresa 1 e zero vínculos na ocasião. Schema e consulta documentados em `evidencias/banco-teste.md`; o endereço de infraestrutura não é publicado.
- O executável FaturamentoMC.exe foi analisado em cópia descompactada temporária; DFM confirma `FCadCarga`, `DMCadCarga`, cinco controles e 28 abas. `inventario-executavel.md` contém limites da evidência.
- Sonda estática aprovada: `python .specs/features/fat-carga-issue-36/evidencias/verificar_mvp.py`; validadores TLC: `validate_spec.py` 0 erros/1 aviso de questão aberta, `validate_tasks.py` 0 erros/3 avisos de tarefas sem teste automatizado.
- Próximo passo: interpretar as novas units no BI, sincronizar caso, executar processamento e confirmar `CODIGO_CARGA` e par `CARGA_CARDOC/DOCUMENTO_CARDOC`. Só essa execução pode fechar CARGA-05/07/08/09/10/11/12; possível ajuste em `CDSDocumentos` se sua projeção divergir da tabela.
- Preservar exclusão preexistente de `docs/assets/emDesenvolvimento/TDD_JSON_FINANCEIRO.json`. Nenhum arquivo foi staged, commitado ou instalado no ERP nesta iteração.
