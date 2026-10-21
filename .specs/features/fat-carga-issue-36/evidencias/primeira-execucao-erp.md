# Primeira execução do MVP no ERP

O usuário executou o caso ID 34. O lote encerrou com um caso e uma falha:

```text
Falha no caso ID 34, método CARGA_VINCULAR_PEDIDO: Operation aborted
```

O método chegou à fase de vincular pedido, após validar a massa, abrir/mapear a tela e iniciar o cabeçalho. A fase chama `CDSDocumentos.Insert`, atribui `DOCUMENTO_CARDOC` e chama `Post`. A mensagem do interceptador não distingue qual das três operações disparou a exceção.

O recurso `TDMCADCARGA` do executável observado declara `BeforeInsert`, `OnNewRecord` e `BeforePost` em `CDSDocumentos`. O recurso `TFCADCARGA` declara o botão `btnFiltro` com caption `&Adicionar` e evento `btnFiltroClick`. Esses vínculos sugerem que a inclusão direta no dataset pode depender de regras da tela, mas o código desses eventos não está disponível para confirmação estática.

Foi adicionada identificação da operação em `TDD_FAT_CARGA.pas`, preservando a mensagem original da exceção. Na próxima execução, observar se a falha indica `CDSDocumentos.Insert`, `CDSDocumentos.atribuir DOCUMENTO_CARDOC` ou `CDSDocumentos.Post`. Só então decidir se é necessário usar o fluxo do botão `Adicionar` ou ajustar os dados do registro.
