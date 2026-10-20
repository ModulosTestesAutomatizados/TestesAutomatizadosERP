# Desenho do MVP de Carga

O caso recebe do IRunner um pedido de venda previamente cadastrado e apto. O JSON informa o codigo exato `843172`, indicado pelo usuario. Em leitura na base `DADOSMC_1032-TDD.FDB`, o documento existe, e do tipo 1, pertence a empresa 1 e nao possui registro em `CARGA_DOCUMENTOS`. A descricao explicita distingue a carga criada. O mapeamento usa os nomes extraidos do DFM de `FaturamentoMC.exe` em 2026-10-13.

O processamento configura `TDD_FAT_CARGA` no IRunner para `FATURAMENTO/CARGA`. `Teste` valida a massa e consulta `DOCUMENTO_FATURA` e `CARGA_DOCUMENTOS` para rejeitar pedido inexistente, de outra empresa ou ja vinculado. Em seguida, abre `FCadCarga`, inclui o cabecalho, tenta vincular o documento por `CDSDocumentos.DOCUMENTO_CARDOC`, aciona a gravacao pelo botao herdado, reabre pelo parametro `COD`, verifica `CODIGO_CARGA` e o par persistido `CARGA_CARDOC/DOCUMENTO_CARDOC` e captura o cadastro para `resultadoEsperado`. O runner controla a lista de casos, o historico e a comparacao final.

A sincronizacao pode gravar JSON formatado no caso corrente. Antes de ler as tags com `P39_TDD_FUNCOES_JSON`, o caso interpreta e serializa novamente o objeto para obter JSON compacto, conforme a restricao observada no interpretador.

O esquema consultado confirma `DOCUMENTO_CARDOC` em `CARGA_DOCUMENTOS` e `CODIGO_CARGA` em `CARGA`. O DFM nao prova que o dataset `CDSDocumentos` exponha `DOCUMENTO_CARDOC` nem quais validacoes de negocio os eventos executam. O codigo falha antes de gravar quando uma pre-condicao detectavel nao esta satisfeita. A execucao nativa ainda precisa comprovar a inclusao e o vinculo do pedido `843172`; depois do primeiro sucesso, o mesmo pedido nao podera ser reutilizado neste cenario.

`TDD_FAT_CARGA_JSON` e uma unit de conteudo JSON, `TIPO_UNIT=5`, cujo conteudo deve ser gravado compacto no BI. `TDD_FAT_CARGA`, `TDD_FAT_MAPEAMENTO_COMPONENTES_CARGA` e `TDD_FAT_PROCESSAMENTO_CARGA` sao units Pascal Script locais. Para sincronizacao remota, a Tek Store precisa publicar a variante `P39_` da unit JSON.

Nenhuma alteracao sera feita no pedido legado: sua entrada possui cursor proprio e nao pode ser chamada no interior de um caso corrente do IRunner.
