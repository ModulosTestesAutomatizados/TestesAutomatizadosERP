# Revisão independente de APPLICATION

Revisor distinto do autor. Revisão estática dos fontes atuais e execução local com APIs substituídas; nenhuma chamada ao ERP, menu real ou banco.

## Evidência executada

- `node .specs/features/irunner-application/testar.mjs`: 7 grupos passaram.
- `node .specs/features/irunner-application/verificar-independente.mjs`: 7 grupos adicionais passaram, incluindo evento sem sufixo e seleção insensível a maiúsculas.
- `node .specs/features/irunner-application/sensor-independente.mjs`: 3 mutantes comportamentais rejeitados. O sensor altera somente cópias temporárias e aponta RUN_TEST_ROOT para essas cópias. Mutações: aceitar alias ambíguo, ignorar Form existente e fechar Form preexistente.
- `node .specs/features/irunner-application/verificar-documentacao.mjs`: APP-12 passou na exportação gerada. Conferidos índice de conhecimento, navegação Helpers/Gerais, estado em-desenvolvimento, símbolos, aliases, redirect anterior e igualdade literal do snippet publicado com a fonte canônica, inclusive no Markdown.

## Rastreabilidade

| Requisito | Evidência local e limite |
| --- | --- |
| APP-01 | Runner contém TDD_RUN_APPLICATION e não contém TDD_RUN_MODULO. Resolução real de units depende de publicar nomes correspondentes no ERP. |
| APP-02 | Caption/Form normalizados, seleção do módulo atual, chamadas consecutivas sem vazamento de resolução. |
| APP-03 | Colisão Caption/Caption e Caption/Form falha antes de abrir; sensor confirma discriminação. |
| APP-04 | Form existente recebe Show sem evento nem criação; mutante de reutilização rejeitado. |
| APP-05 | Sequência BringToFront/SetFocus/Repaint/evento/Show verificada pelo teste do autor. Sender é FPrincipal. |
| APP-06 | Form registrado sem evento usa CriarFormPeloNome; criação e reutilização verificadas. |
| APP-07 | Nome encontrado em MetodosDeObjeto, extraído antes de `(`, funciona sem consultar catálogo, inclusive sem sufixo Click. A enumeração não executa outros métodos. |
| APP-08 | JSON inválido, módulo ausente, alias inexistente, principal ausente, evento que não cria o Form e exceção original do evento cobertos. Não há criação silenciosa após evento falho. |
| APP-09 | Quatro destinos financeiros observados antes dos mapeamentos. Preenchimento e teardown preservados por leitura; execução financeira real permanece pendente. |
| APP-10 | Helper invoca só evento selecionado além do método já existente de listar Forms; CAPTION vem do componente de menu e não do Form.Caption. |
| APP-11 | Baseline anterior protege Forms existentes; fechamento somente de novos candidatos e restauração do RichEdit verificados. Sensor de fechamento indevido rejeitado. |
| APP-12 | Catálogo registra helper uma vez na slice, fonte canônica copiável e configuração/efeitos/limites explícitos. Exportação knowledge e bytes do snippet revisados independentemente. Check/build aprovados pelo autor; interação no navegador não executada nesta revisão. |

## Análise estática

Não foi identificado bloqueio concreto nos caminhos revisados. Os pares JSON são consumidos antes de liberar o objeto proprietário. Dados necessários depois do Free ficam em strings; não são reutilizadas referências a pares de objetos liberados. As chamadas de reflexão sem argumentos não usam o literal vazio `[]`. São mantidos os métodos existentes, sem classes, records ou novos tipos incompatíveis introduzidos no Pascal.

O catálogo contém apenas o Caption/Evento confirmado de Contas a Receber. Demais Forms permanecem registrados com strings vazias, sem inventar eventos. A ausência de evento conserva a criação por Form permitida na especificação. O helper coleta candidatos manualmente e não grava/publica o catálogo.

## Limites para teste no ERP

O harness converte Pascal para execução JavaScript e substitui reflexão, JSON, Forms e coleta. Não prova registro nativo de TJSONPair/GetPair, semântica do adaptador, lifecycle dos Forms reais, permissões de menu ou retorno do método ListarFormulriosAbertos1Click. Necessário testar o catálogo remoto publicado, a abertura de Contas a Receber por menu, reutilização de tela aberta e os quatro fluxos financeiros no ERP. Títulos iguais continuam exigindo Form ou evento para desambiguar.

## Veredito final

APP-01 a APP-12 aprovados no escopo da verificação local descrita, sem bloqueios concretos identificados nesta alteração. O autor informou check e build do portal aprovados; esta revisão confirmou os dados produzidos, sem repetir build concorrente. Não implica homologação ERP nem teste visual/interativo do portal.

Revisão final do piloto: concordo com remover o lookup anterior a AbrirTela e os Show redundantes em duplicatas e borderô de pagamento. Esses destinos entram pelo caminho mapeado de Application, que valida a instância e chama lForm.Show antes de retornar; o lookup posterior necessário ao preenchimento e os mapeamentos são preservados. Reexecutados após esse ajuste: 7 grupos do autor, 7 independentes e APP-12 passaram.

Regressões de outras suítes relatadas pelo autor permanecem explicitamente fora desta aprovação: após adaptar paths, a suíte IRunner passa 15 grupos e falha na expectativa FParamsCasosTeste=nil ausente no fonte atual do usuário; logs-preparacao espera MostrarLogTexto com um argumento, enquanto o logger atual do usuário passa dois. Não se alteraram essas expectativas nem fontes de produção para ocultar as divergências. Essas duas execuções foram relatadas pelo autor, não repetidas pelo revisor.
