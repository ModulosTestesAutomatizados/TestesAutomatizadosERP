# Leitura do banco de teste da Carga

Fonte: banco dedicado de testes informado pelo usuário, consulta somente leitura em 2026-10-19. Nenhum registro foi criado ou alterado. O endereço de infraestrutura permanece fora deste repositório público.

- `CARGA.CODIGO_CARGA` identifica a carga. `DTEMISSAO_CARGA` e `SERVICODEENVIO_CARGA` sao NOT NULL.
- `CARGA_DOCUMENTOS.CARGA_CARDOC` aponta para a carga e `DOCUMENTO_CARDOC` aponta para o documento.
- `DOCUMENTO_FATURA.CODIGO_DOCFAT` identifica o pedido; `TIPO_DOCFAT=1` foi usado como pre-condicao de Pedido de Venda.
- Pedido indicado pelo usuario: `843172`, empresa `1`, tipo `1`, `STATUS_DOCFAT=0`, `SITUACAO_DOCFAT=0`, `CARGA_DOCFAT=0`, sem vinculos em `CARGA_DOCUMENTOS` no momento da consulta.
- As duas consultas de pre-condicao implementadas em `TDD_FAT_CARGA` retornaram, respectivamente, `1` pedido elegivel pelo filtro de tipo/empresa/carga e `0` vinculos existentes, considerando empresa `1`.
- Units locais observadas no BI: `TDD_RUN_IRUNNER`, `TDD_RUN_APPLICATION`, `TDD_RUN_ASSERTS`, `TDD_REGISTRAR_CASO_TESTE`, `TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS`, `TDD_FIN_FINANCEIRO_JSON` (`TIPO_UNIT=5`). As quatro novas units de Carga ainda nao estavam instaladas.

O esquema e a pre-condicao SQL nao validam os eventos de inclusao, a projecao de `CDSDocumentos` nem a gravacao da tela. Esses pontos exigem execucao nativa.
