# Atualização documental dos artefatos TDD estabilizados

## Problem Statement

O portal descreve uma versão anterior do IRunner: usa nomes removidos, reserva ASSERTS como pendente e atribui à casca responsabilidades que passaram para os métodos existentes de outras units. As últimas alterações introduziram captura de dados, métricas de asserts e sincronização de uma fonte JSON com defaults remotos. Os modelos JSON locais são ignorados pelo Git e não acompanharão automaticamente um novo checkout.

Esta é uma especificação de transferência para outra sessão, preparada em 2026-10-16. A documentação foi consultada somente para identificar seu formato e os locais a atualizar. **A implementação documental não está autorizada nesta sessão.** Os contratos abaixo vêm dos fontes e das decisões do usuário, não do conteúdo desatualizado do portal.

## Goals

- Atualizar a documentação ativa para os nomes, contratos e responsabilidades atuais.
- Incluir ASSERTS, MODULO, validação, sincronização e os três modelos JSON.
- Remover afirmações superadas sem apagar a história dos contratos anteriores.
- Entregar contexto suficiente para outra sessão trabalhar sem acesso a esta conversa.
- Manter explícita a diferença entre fonte implementado, teste local e homologação no ERP.

## Out of Scope

| Item | Motivo |
| --- | --- |
| Implementar esta especificação nesta sessão | Pedido expresso: apenas preparar o repasse |
| Alterar os fontes Pascal, JSONs de trabalho ou regras TDD na sessão documental | A estabilização pertence a esta worktree; divergências devem ser registradas |
| Corrigir a reexecução do lote, restaurar parâmetros ou acrescentar asserts financeiros | Trabalho de código separado |
| Consultar/gravar banco, sincronizar units, executar financeiro ou publicar portal | Não são necessários para documentar os fontes |
| Redesenhar o portal, trocar framework ou mudar sua identidade visual | Preservar o formato editorial existente |
| Transformar arquivos ignorados em novos requisitos de checkout sem decisão explícita | Exemplos precisam ser portáveis; não alterar .gitignore por conveniência |
| Substituir contratos históricos por versões atuais | Manter a distinção entre histórico e fluxo ativo |

## Assumptions & Open Questions

| Assumption / decision | Chosen default | Rationale | Confirmed? |
| --- | --- | --- | --- |
| Sessão atual | Criar somente esta especificação e anexos em .specs/features/documentacao-estabilizacao-tdd/ | Escopo expresso do usuário | Sim |
| Referência de código | Árvore atual desta worktree, inclusive mudanças sem commit | HEAD db20fe6 não contém toda a sincronização nova | Sim, estado observado |
| Sessão futura | Documentar; não corrigir código nem publicar automaticamente | Separação de responsabilidades pedida pelo usuário | Sim |
| Formato | Usar IDocumento e criarDocumentoUnit, catálogos e Mermaid canônico existentes | Formato identificado por leitura do portal | Escolha técnica |
| JSONs ignorados | Incluir exemplos completos em blocos documentais versionados, usando os snapshots deste pacote | Links para arquivos ausentes no checkout quebram o build | Escolha técnica |
| Histórico | Nomes antigos podem permanecer em referências históricas e aliases identificados, nunca como contrato atual | Não apagar contexto nem inventar equivalência de APIs | Escolha técnica |
| Homologação | Não usar validado-no-erp para o conjunto novo sem evidência posterior identificável | O usuário ainda precisa testar a última sincronização no ERP | Sim |
| Campos mínimos | Fallback remoto já implementado; conteúdo atual é {} | Última decisão substitui a proposta inicial de adiar esse fallback | Sim |
| Inventários | Regerar a partir dos fontes reconciliados; não apenas trocar rótulos e hashes | Nomes, caminhos e dependências mudaram | Escolha técnica |

**Open questions:** none. Escolhas editoriais propostas estão explícitas. Antes da implementação futura, reconciliar os fontes com o inventário anexo; alterações posteriores de comportamento exigem atualizar esta especificação.

## Pacote de transferência e proveniência

- `inventario-fontes.md`: caminhos atuais, hashes SHA-256 normalizados CRLF para LF, uses e assinaturas extraídos dos fontes; contém também o corpo exato dos três JSONs ignorados.
- `INICIAR-OUTRA-SESSAO.md`: prompt pronto para copiar e roteiro de leitura.
- Referência física desta sessão: `C:/Users/Gerson Ribeiro/Documents/TEK/ProjetosTek/Testes/TestesAutomatizadosERP-tdd-runner`.
- HEAD observado: `db20fe6` (`fix: renomeando arquivos e incluindo asserts, modulo e verificação do resultado esperado`). Há modificações sem commit; **não basta trocar para esse commit para obter o contrato atual**.
- Históricos relevantes: `e47d2a4` checkpoint inicial; `835dbac` estabilização; `0303da9` renomes; `8acfc83` especificação ASSERTS/MODULO; `db20fe6` integração e novos renomes. São evidências históricas, não instruções para checkout/reset.
- Ler também `.specs/features/sincronizacao-fonte-unica/{spec.md,validation.md,relatorio-servico.md}` e `.specs/features/irunner-asserts-modulo/{context.md,validation.md}`. Relatórios antigos podem apontar nomes anteriores: o inventário atual e o código prevalecem.
- Não transferir credenciais, conexões privadas ou dumps de banco para o portal. Nenhuma informação desse tipo é necessária neste pacote.

## Formato documental encontrado

| Componente | Formato e regra a preservar |
| --- | --- |
| `Documentacoes/app/models/documentacao.ts` | Tipos IDocumento, IDadosUnit, ISecao e TBloco; estados legado/em-uso/em-desenvolvimento/validado-no-erp |
| `Documentacoes/app/content/units/criarDocumentoUnit.ts` | Gera página de unit com responsabilidade, estados/ciclo de vida, assinaturas, implementação, dependências e limites |
| `Documentacoes/app/content/units/catalogo.ts` | Registro de páginas de units; alimenta catálogo, busca e citações |
| `Documentacoes/app/content/catalogo.ts` | Catálogo geral de estrutura, documentos, guias, units e histórico |
| `Documentacoes/app/content/validarCatalogo.ts` | Nomes/aliases únicos; slug de unit corresponde ao nome; validado-no-erp exige data/versão/referência |
| `docs/MAPEAMENTO_AST_USES_UNITS/<slug>/` | Mermaid em Markdown canônico; TypeScript referencia o arquivo, sem duplicar o diagrama como string |
| `Documentacoes/config/build.mjs` | Confere fontes, diagramas, hashes do inventário e gera o portal; há caminho de AST fixo no código |
| `Documentacoes/app/redirecionamentos/` e `app/router.ts` | Verificar compatibilidade de links se slugs/rotas mudarem; alias de busca não é garantia de redirecionamento de URL |

Não é necessário mudar o builder ou o modelo para documentar estes contratos. Usar estado explícito nas páginas novas: criarDocumentoUnit adota em-uso como default, o que não equivale à homologação.

## Mapa de nomes, movimentos e substituições

Prefixo `TDD_RUN_*` identifica os artefatos do runner. `P39_` permanece para referências remotas. O nome do arquivo de referência e o identificador usado no uses devem ser descritos separadamente; não inferir equivalência instalada no ERP.

| Nome/caminho anterior | Referência atual | Tratamento documental |
| --- | --- | --- |
| Runner/TDD_IRUNNER.pas | Runner/TDD_RUN_IRUNNER.pas | Atualizar página, exemplos, links, grafo e montagem dinâmica |
| Runner/TDD_RUNNER.pas | Runner/TDD_RUN_RUNNER.pas | Atualizar contexto, métricas e dependências |
| Runner/TDD_BASE_UNIT_IRUNNER.pas | Runner/TDD_RUN_UNIT_BASE_IRUNNER.pas | Atualizar nome do molde e CodificacaoUnit; ordem UNIT_BASE mudou |
| Runner/TDD_STARTED.pas | Runner/TDD_RUN_STARTED.pas | Nome e referências novos; comportamento de parâmetros aprovado foi preservado |
| Runner/TDD_FINISHED.pas | Runner/TDD_RUN_FINISHED.pas | Atualizar persistência e consolidação, não apenas nome |
| Runner/TDD_LOGS.pas | Runner/TDD_RUN_LOGS.pas | Atualizar compartilhamento, debug e snapshot |
| Runner/P39_TDD_PROCESSAMENTO_FINANCEIRO.pas | Runner/P39_TDD_FIN_PROCESSAMENTO_FINANCEIRO.pas | Renome efetivo; portal também usa a forma antiga P39_PROCESSAMENTO_TDD_FINANCEIRO |
| emDesenvolvimento/TDD_FINANCEIRO.pas | emDesenvolvimento/TDD_FIN_FINANCEIRO.pas | Cenário atual; referências REFACTOR_TDD_FINANCEIRO_PILOTO são anteriores |
| TDD_JSON_FINANCEIRO como nome da fonte no registro | TDD_FIN_FINANCEIRO_JSON, modelo em emDesenvolvimento/TDD_FIN_FINANCEIRO_JSON.json | Mudança da referência de cadastro, não renome físico comprovado de um arquivo JSON versionado |
| configuracoesGerais/P39_TDD_ASSERTS.pas e TDD_ASSERTS.pas | Runner/P39_TDD_RUN_ASSERTS.pas | Substituição com alterações de estado/ciclo; não prometer compatibilidade automática |
| configuracoesGerais/P39_TDD_MODULO.pas | Runner/P39_TDD_RUN_MODULO.pas | Substituição; SetModulo e estados redundantes foram removidos da nova unit |
| configuracoesGerais/P39_TDD_VALIDAR_RESULTADO.pas | emDesenvolvimento/P39_TDD_VALIDAR_RESULTADO.pas | Movimento e redução de responsabilidades |
| sincronizar/persistenciasODBC/... citado no portal | configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas e P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas | Corrigir diretório e capitalização real; Linux diferencia maiúsculas |

Nesta tabela, `Runner/` é `docs/assets/emDesenvolvimento/Runner/`; os demais caminhos de fonte partem de `docs/assets/`. Formas antigas encontradas no portal não devem ser apresentadas como renomes comprovados pelo Git quando são apenas referências legadas.

`EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas` é um artefato de exemplo, não a fonte de montagem executada por IRunner. Se ele divergir do molde/gerador atual, a sessão documental deve seguir esses dois fontes e apontar a divergência; não editar o exemplo Pascal nesta frente apenas para ajustar a documentação.

## Responsabilidades e contratos que passam a ser canônicos

### Geração, lote e contexto

1. RUN_IRUNNER configura uma única unit com `procedure Teste` sem parâmetros. SetTDDUnit seleciona o cenário; dois AddParamsRun recebem módulo e área como literais Pascal. Executar interpreta uma vez, não por caso.
2. O molde vem de `CodificacaoUnit('TDD_RUN_UNIT_BASE_IRUNNER')`. Há quatro marcadores: `__USES_UNITS__`, `__PARAMETROS_CASO_TESTE__`, `__CHAMADAS_METODOS__` e `__MODO_DEBUG__`. O debug externo é transmitido explicitamente ao programa gerado; não presumir estado compartilhado entre interpretações.
3. Main do molde concentra o prefixo MensagemPersonalizada. ExecutarLote carrega uma vez e controla First/Run/Next. Run usa o registro corrente. O Teste não recarrega casos nem avança esse cursor.
4. SetarCasoTeste recebe somente módulo e área, nunca descrição vazia como terceiro argumento. Reinicia histórico, métricas de asserts, contexto, contadores/capturas e estados antes da leitura do próximo registro. Lê ID, REQUISITOVERSAO e DESCRICAO do CDS; essas atribuições não foram abandonadas.
5. Preparação, callbacks, falha de limpeza e finalização têm caminhos de propagação. Falhas ordinárias do teste/asserções podem permitir o próximo caso quando a finalização passa. Preservar VERSAO_INCOMPATIVEL; não substituir pelo nome antigo INCOMPATIVEL_VERSAO sem conferir o fonte.
6. O lote com falhas apresenta um resumo após a limpeza, com quantidade tentada e mensagens por caso. Sucesso não gera esse resumo de erro. O resumo de lote é posterior aos históricos individuais e não deve ser descrito como salvo automaticamente em cada um.

### STARTED e parâmetros

- STARTED permanece com identidade do registro, versão requerida e aplicação de parametros. A extração usa TJSONObject e GetPair/GetPairName/GetPairValue herdados da cadeia de uses; não criar um segundo parser na explicação.
- parametros ausente ou objeto vazio não aplica parâmetros; seção com tipo incorreto é configuração inválida. Não mudar esse comportamento na frente documental.
- A sonda nativa mostrou GetValueJson lendo escalar, mas falhando para objetos: `Conversion from TJSONObject to string is not supported`; propriedade ausente também lança exceção. Não recomendar GetValueJson para extrair objetos inteiros ou supor que compactar o JSON resolve essa limitação.
- Aplicação de parâmetros altera a configuração do ERP. Limpeza dos datasets não significa restauração dos valores anteriores.

### Asserts, validação e módulo

| Responsabilidade anterior/mal atribuída | Dono e comportamento atuais |
| --- | --- |
| Validador reiniciava os asserts | Reset pertence ao ciclo do caso, por SetarCasoTeste/AssertsZerar; CompararComJSON preserva asserts já executados |
| Validador mantinha erros reais | RegistrarErroReal e FErrosReais pertencem a RUN_ASSERTS; exceções do runner não viram erros esperados automaticamente |
| Validador mantinha cronômetro próprio | Runner mede com RegistrarTick; FTempoExecucaoMs recebe o tempo de IRUNNER antes de ASSERTS |
| Validador exibindo mensagens/alterando ScriptDeTestesEmExecucao | Comparador usa logs e resultados; sem diálogos ou controle do ciclo |
| Validador gerenciando datasets vivos | RegistrarDataSet em RUN_ASSERTS captura cópias do registro disponível, por chave CDS|DM |
| MODULO configurando e carregando casos | CASOS_DE_TESTE mantém FModulo/FDescModulo e SetModulo; SetupCasosTestes prepara o lote |
| MODULO duplicando FDescModulo/FModuloDefinido/FMenuName | Nova RUN_MODULO mantém a referência FP e métodos de tela; valida contexto existente e resolve FPrincipal em cada operação |
| Casca consolidando/persistindo tudo | FINISHED encerra tempos pendentes, consolida evidências/métricas, copia logs e executa a persistência |

- RUN_ASSERTS contém primitivas de comparação, FAssertsTotal/FAssertsPass/FAssertsFail, FFalhas, FResultados, FDataSets, FErrosReais, FTempoExecucaoMs e FResultadoEsperadoCaso. Explicar proprietário, produtores, consumidores e momento do reset de cada um.
- RegistrarResultado acumula e retorna Boolean; não lança exceção apenas por reprovação. Run consulta AssertsOk para atribuir SUCESSO/FALHA, registrar diagnóstico e alimentar o resumo. Não descrever o novo SUCESSO como resultado de uma atribuição incondicional.
- FResultados guarda aprovados e reprovados, com os valores disponíveis; FFalhas somente falhas. Evidências persistidas não se limitam à lista de reprovações.
- Comparações Maior/Menor avaliam obtido > esperado e obtido < esperado; igualdade respeita tipo. Conversões inválidas, referências ausentes/ambíguas e NULL não aprovam zero ou falso silenciosamente.
- No financeiro, Teste executa quatro operações e seu finally faz TEARDOWN antes de retornar. ASSERTS vem depois. Isso é possível pelas capturas feitas após gravar e antes dos fechamentos: não desenhar ASSERTS lendo telas já fechadas.
- RegistrarDataSet copia dados e posição; não edita/libera o componente original. Última captura da mesma chave substitui a anterior. `cds` e `dm` podem desambiguar um campo presente em mais de uma captura. Não inventar histórico de todas as versões da mesma chave.
- Revalidar no ERP Data/RecNo, índice/filtro e disponibilidade após gravar; o mock local não certifica esses efeitos. Os mapeamentos financeiros mantêm as referências do ERP, não datasets substitutos criados pelo piloto.

### Tempos, logs e persistência

- RegistrarTick recebe o contador bruto em Double, calcula o relativo à base, trata a volta com 4294967296.0 e rejeita relativo maior que 2147483646 antes de converter. Acrescenta 1 porque zero representa tempo aberto. Não recomendar conversão direta do uptime Cardinal para Integer.
- O encerramento dos tempos pendentes usa o próprio RegistrarTick(1, nome), dentro de RegistrarMetricas. Não documentar EncerrarTemposPendentes ou wrappers equivalentes como API existente. CalcularTickRelativo e ObterParametrosDoCasoTeste não são novos serviços públicos: suas lógicas foram incorporadas aos consumidores existentes.
- FINISHED: encerrar ticks; consolidar FMetricasAsserts; copiar FLogsCasoTeste.Text imediatamente antes do INSERT; inserir HISTORICO_EXECUCAO com RETURNING; inserir uma linha agregada de METRICAS_ASSERTS; inserir linhas de METRICAS_TICK_DIFF.
- A linha agregada possui FK retornada, etapa, tempo total em ms, total/aprovados/falhos e esperado/obtido. Persiste também total zero e parciais; ResultadoEsperado é o objeto separado do caso, ResultadoObtido vem de FResultados.Text.
- FModoDebug continua controlando captura em RUN_LOGS. FExibirInstrucoes controla a exibição de instruções independentemente. Não documentar logs incondicionais ou ligar captura à existência de erro.
- A coluna usada pelo código é LOGS_PROCESSAMENTO_HE; LOGS_FALHAS_HE no MER/documentação anterior está desatualizada para esse caminho. Corrigir a descrição documental, sem executar migration nem inferir todos os ambientes.
- Falhas de encerramento e persistência preservam a causa anterior; não há retry automático do histórico, nem garantia de transação única abrangendo pai e filhos. Não prometer logs persistidos se o banco estiver indisponível.
- O host observado não expõe EmptyDataSet nesse caminho. O piloto e a limpeza de casos usam First/IsEmpty/Delete onde corrigido. Não transformar a limitação observada em proibição universal de Delphi.

### Fonte JSON única e sincronização

Assinaturas atuais obrigatórias nos exemplos:

```pascal
procedure RegistrarCasoTeste(
  pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste,
  pRequisitoVersao, pUnitJsonCasoTeste: string;
  pSincRemoto: boolean);

function CarregarConteudoUnit(pNomeUnit: string; pSincRemoto: boolean): string;

function ObterObjetoConfiguracao(
  pJson, pPropriedade, pUnitFallback: string;
  pFallbackSeVazio: boolean): string;
```

| Entrada na fonte única | Resultado na sincronização |
| --- | --- |
| resultadoEsperado ausente | Ler P39_TDD_ASSERTS_JSON_MINIMO e extrair resultadoEsperado |
| resultadoEsperado: {} explícito | Preservar {}; não buscar mínimo |
| resultadoEsperado preenchido | Preservar o objeto explícito |
| camposDisponiveis ausente ou {} | Ler P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO; conteúdo atual {} é válido |
| camposDisponiveis preenchido | Preservar objeto explícito sem fallback |
| Propriedades reservadas null, array ou escalar | Rejeitar configuração, não tratar como ausência |
| Unit fonte/mínima necessária indisponível ou formato inválido | Propagar erro antes dos fallbacks SQL e da sincronização com escrita |

- Uma fonte JSON por caso mantém dados na raiz, parametros e as propriedades reservadas opcionais. Não é o envelope inicialmente cogitado com `casoTeste: {...}`. Também não existe uma propriedade raiz `asserts` no contrato final.
- A sincronização retira apenas as duas propriedades reservadas da raiz e grava os demais dados em CASO_TESTE_CT. Grava os objetos separados em CAMPOS_DISPONIVEIS_CT e RESULTADO_ESPERADO_CT. Propriedades aninhadas homônimas continuam pertencendo aos dados.
- O fallback é decidido na sincronização, não buscado pelo runner a cada execução. Um {} já persistido não é substituído pelo mínimo em ASSERTS: somente gera SEM_VALIDACAO e preserva verificações explícitas.
- O corpo mínimo de resultado tem `resultadoEsperado` na raiz; grava-se apenas seu objeto interno, sem dupla camada. Campos mínimos aceitam o corpo atual {}; preenchimento futuro usa `{"camposDisponiveis": {...}}`.
- CarregarConteudoUnit lê CodificacaoUnit, não um caminho .json do disco. Não duplica P39_ em nomes já prefixados e não silencia falhas com {}. Defaults têm nomes remotos exatos, mesmo se a fonte do caso é local.
- Os quatro RegistrarCasoTeste foram reduzidos de oito para seis argumentos. A descrição financeira continua `TDD_FINANCEIRO` como chave de cadastro; a unit de fonte agora é `TDD_FIN_FINANCEIRO_JSON`. Não confundir descrição do registro com nome da unit executável `TDD_FIN_FINANCEIRO`.
- A antiga fonte separada TDD_JSON_BASE_RESULTADO_ESPERADO deixa de ser argumento dos registros de faturamento. Expectativas específicas precisam estar no resultadoEsperado da respectiva fonte. Os exemplos locais P39_TDD_JSON_PEDIDO_*.pas/P39_TDD_JSON_BASE_RESULTADO_ESPERADO.pas contêm Pascal; não inventar sua migração JSON remota nem tratá-los como documentos JSON válidos.
- O mínimo `erro.quantidade = 0` verifica FErrosReais alimentado por RegistrarErroReal. Não comprova todos os efeitos financeiros, ausência de qualquer erro do ERP ou captura universal de exceções.

## Matriz editorial: incluir, alterar e remover

| Alvo existente | Alteração futura obrigatória |
| --- | --- |
| `content/estrutura/runner.ts` | Reescrever nomes/fontes, quatro marcadores, grafo, sequência com TEARDOWN/capturas/ASSERTS, status, snapshot em FINISHED e métricas agregadas |
| `content/units/tdd-irunner.ts` | Migrar para página canônica RUN_IRUNNER e explicar transmissão do debug |
| `content/units/tdd-runner.ts` | Migrar para RUN_RUNNER; contexto/reset, ticks relativos e propriedade dos records |
| `content/units/tdd-base-unit-irunner.ts` | Migrar para RUN_UNIT_BASE_IRUNNER; orquestração, central raise e resumo; não atribuir cópia de logs à casca |
| `content/units/tdd-started.ts` | Migrar nome/path; descrever parser e requisitos; não redesenhar parâmetros |
| `content/units/tdd-finished.ts` | Migrar nome/path; tempos pendentes, snapshot, assert agregado, falhas parciais |
| `content/units/tdd-logs.ts` | Migrar nome/path; captura condicionada e snapshot cujo dono é FINISHED |
| `content/units/p39-tdd-modulo.ts` | Retirar do contrato ativo a API antiga de SetModulo/estados redundantes; criar página RUN_MODULO e preservar referência anterior claramente histórica quando necessária |
| `content/casos/irunner.ts` e `casos/piloto-financeiro.ts` | Fonte atual, entrada Teste, capturas, TEARDOWN anterior a ASSERTS, defaults e evidência limitada |
| `content/documentos/casos-de-teste.ts` | Atualizar paths reais e bloco de registro herdado via obterBlocos; fonte única, seis argumentos, projeção e tabela de defaults |
| `content/documentos/parametros.ts`, `units/p39-tdd-parametro.ts`, `units/p39-tdd-casos-de-teste.ts` | Ajustar nomes de consumidores/donos e integração, preservando escopo e ausência de restauração automática |
| `content/guias/autoria.ts` | Atualizar advertência sobre SUCESSO/asserts; incluir fonte única, defaults e padrão de Main do snippet atual |
| `content/units/catalogo.ts` e `content/catalogo.ts` | Registrar novas páginas, migrar imports, evitar nomes/aliases e slugs duplicados; manter histórico distinto |
| `docs/MAPEAMENTO_AST_USES_UNITS/runner/*.md` | Atualizar responsabilidades, lote, falhas, estado, métricas e dependências reais |
| `docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_IRUNNER.ast.json` e `.md` | Regerar roots, nós, paths, linhas, hashes e alcance. O nome do arquivo pode permanecer por compatibilidade de build; se renomeado, atualizar build e todos os consumidores juntos |
| `docs/MAPEAMENTO_AST_USES_UNITS/casos-irunner/`, `casos-de-teste/`, `piloto-financeiro/`, `parametros/` e README | Alinhar diagramas com cadastro/sincronização separados da execução; remover pendência genérica de ASSERTS |
| `docs/MER.md` | Alinhar LOGS_PROCESSAMENTO_HE e a descrição dos estados com o SQL corrente; manter métricas de asserts existentes, sem inventar nova tabela |

Os caminhos `content/...` nesta matriz partem de `Documentacoes/app/`. Criar páginas de unit para RUN_ASSERTS, RUN_MODULO, VALIDAR_RESULTADO e os dois métodos/units de registro e sincronização ainda sem cobertura própria. Cobrir o processamento financeiro e o cenário nas páginas de casos; uma segunda explicação duplicada não é requisito.

**Remover do conteúdo ativo**: "ASSERTS permanece pendente", "INSERT de asserts comentado", "Run faz snapshot dos logs", "ASSERTS é apenas um trecho reservado", assinatura de registro com três units JSON, descrição como terceiro argumento de SetarCasoTeste, MODULO como carregador do lote, fallback silencioso de unit indisponível, propriedade raiz asserts e nomes anteriores como destinos executáveis atuais. Não remover estas expressões de registros históricos sem analisar seu contexto.

**Preservar como limites**: sem restauração automática de parâmetros; sem retry/atomicidade global; captura depende de debug; alias documental não comprova variante remota; reexecução e captura nativa ainda exigem evidência. Não remover advertências verdadeiras apenas para o portal parecer concluído.

## JSONs ignorados e portabilidade

Os três caminhos são `docs/assets/emDesenvolvimento/TDD_FIN_FINANCEIRO_JSON.json`, `TDD_ASSERTS_JSON_MINIMO.json` e `TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO.json`. A regra `*.json` de .gitignore os exclui. Seus corpos integrais estão no inventário anexo, portanto outra sessão não precisa que o autor os envie novamente.

Na documentação futura, publicar exemplos como blocos de código TypeScript/Markdown versionados. Não adicionar esses paths em `fontes` e esperar que existam no build limpo: build.mjs exige existência de cada fonte. Uma alteração para versionar/copiar esses assets exige decisão explícita e não é requisito desta especificação. O inventário AST .ast.json é diferente: já existe exceção em .gitignore que o permite.

O exemplo financeiro local tem PESSOA_DUP, VALOR_DUP e GRUPORESULTADO_DUPGR iguais a zero; ValidarCasoTeste os rejeita. Identificar esses valores como modelo a preencher, não como massa positiva pronta. Não copiar para o portal valores obtidos de um banco como se fossem universais.

## Evidência, limites e pontos que não devem virar promessas

- O usuário executou o piloto no ERP em etapas e observou diagnósticos centrais. O histórico 96 consultado anteriormente mostrava SUCESSO e logs NULL; isso motivou transmitir debug ao programa gerado. Não dizer que esse registro foi corrigido retroativamente.
- O erro nativo "Nenhuma verificação configurada" com resultado {} motivou a política atual de SEM_VALIDACAO. Isso é evidência de um caminho executado, não homologação de todas as comparações/capturas.
- Última sincronização com fonte única: nove grupos locais do autor, quatro independentes e três mutações detectadas em cópias, conforme validation.md. São métodos extraídos/traduzidos com APIs externas substituídas; não comprovam compilação JvInterpreter ou INSERT real.
- A suíte anterior tem quinze grupos aprovados e uma falha de reexecução: o HEAD libera FLogsCasoTeste sem nil. Não corrigir código na sessão documental; manter limite explícito e não declarar toda a suíte verde. Não atribuir essa falha à nova sincronização.
- A captura por Data/RecNo depende de comportamento do dataset, índices/filtros e disponibilidade após gravar no ERP. Asserts com {} nem sequer exercitam a comparação de campos.
- Relatórios de iterações anteriores não são prova do estado atual. Se o código mudou após os hashes do inventário, ler os novos fontes e atualizar a proposta antes de concluir a documentação.

## User Stories

### P1: Consultar o contrato atual sem depender desta conversa

**Acceptance Criteria**:

1. The documentação ativa SHALL usar os nomes/caminhos atuais da tabela de renomes em títulos, fontes, exemplos e diagramas. (DOC-01)
2. The documentação SHALL distinguir nome local, referência remota P39_, alias de pesquisa e versão histórica sem prometer equivalência instalada. (DOC-02)
3. WHEN uma página de unit é adicionada ou migrada THEN o catálogo SHALL manter nomes/aliases únicos, assinaturas atuais, estados com seus donos e navegação interna válida. (DOC-03)
4. The página de arquitetura SHALL mostrar geração uma vez, controle de cursor pelo lote, preparo por caso, capturas antes do fechamento e ASSERTS depois do TEARDOWN do piloto. (DOC-04)
5. The conteúdo de responsabilidades SHALL atribuir reset ao ciclo do caso, acúmulo/capturas a RUN_ASSERTS, comparação ao validador, tempos ao runner e persistência/snapshot a FINISHED. (DOC-05)
6. The documentação de execução SHALL descrever reprovação de assert influenciando FALHA, continuidade condicionada à finalização e resumo central com um prefixo MensagemPersonalizada. (DOC-06)
7. The documentação de persistência SHALL apresentar histórico, linha agregada de asserts e linhas de ticks, usando LOGS_PROCESSAMENTO_HE e preservando a possibilidade de gravação parcial sem retry. (DOC-07)
8. The documentação de logs SHALL distinguir FModoDebug de FExibirInstrucoes e registrar que o modo debug é transmitido ao programa gerado. (DOC-08)
9. The documentação de ticks SHALL explicar a base relativa, a volta Cardinal e o zero reservado sem recomendar conversão direta do uptime para Integer. (DOC-09)
10. The documentação de cadastro SHALL usar a assinatura de seis argumentos e uma única fonte JSON, sem as duas propriedades reservadas no payload entregue a STARTED. (DOC-10)
11. The documentação SHALL reproduzir todos os estados da tabela de defaults, incluindo {} explícito de resultado sem fallback e campos vazios com fallback já implementado. (DOC-11)
12. IF fonte, propriedade reservada ou fallback obrigatório é inválido THEN os exemplos documentais SHALL indicar falha anterior às gravações em vez de fallback silencioso. (DOC-12)
13. The documentação SHALL incluir os três modelos JSON completos em artefatos versionados de conteúdo, sem depender de arquivos ignorados para funcionar em checkout limpo. (DOC-13)
14. The conteúdo ativo SHALL remover as pendências superadas de asserts/persistência e os métodos/estados removidos, preservando contratos históricos identificados. (DOC-14)
15. WHEN o inventário de dependências é atualizado THEN seus hashes, paths, linhas e edges SHALL derivar dos fontes reconciliados, preservando a diferença entre uses, carga dinâmica e estado compartilhado. (DOC-15)
16. The documentação de STARTED SHALL preservar o contrato aprovado de parametros e a limitação nativa observada de GetValueJson para objetos. (DOC-16)
17. IF não há evidência completa posterior no ERP THEN as páginas novas SHALL não usar o estado validado-no-erp nem transformar gates locais em homologação. (DOC-17)
18. The entrega documental futura SHALL registrar o resultado de npm run check, npm run build, conferência das rotas/fontes/diagramas e revisão de busca/aliases. (DOC-18)
19. The execução desta sessão SHALL criar somente os artefatos deste pacote de especificação, sem modificar Documentacoes/, mapas, MER, Pascal ou JSONs do piloto. (DOC-19)

**Independent Test:** outra sessão consegue iniciar com este pacote, localizar cada responsabilidade no inventário, construir exemplos portáteis e validar o portal em checkout sem os JSONs ignorados; asserções/documentos antigos só permanecem nos locais históricos ou aliases explicitamente definidos.

## Edge Cases

- Aliases duplicados entre a página legada de MODULO e a nova; assinaturas antigas de SetModulo não devem aparecer como API nova.
- Fonte existente no Windows mas quebrada em Linux por capitalização ou diretório antigo.
- Renomear o arquivo AST e esquecer o caminho fixo em build.mjs ou a exceção .gitignore.
- Alias funcionando na busca, mas URL antiga não redirecionando; testar o comportamento real e corrigir links internos juntos.
- JSONs presentes no computador do autor e ausentes no checkout de outra sessão/CI.
- Um mínimo remoto contendo wrapper resultadoEsperado e outro atualmente contendo apenas {}; não gravar wrapper duplo nem trocar políticas de vazio.
- Empregar uma expectativa legada separada que não foi migrada para a fonte única.
- Publicar snippet de Main com chamada não qualificada a outra Main, causando recursão; seguir o snippet e as convenções dos fontes.
- Remover advertência real de persistência parcial/reentrância junto das pendências obsoletas de asserts.

## Requirement Traceability

| Requirement ID | Entrega documental | Phase | Status |
| --- | --- | --- | --- |
| DOC-01 | Nomes e fontes | Specify | Pending |
| DOC-02 | Nomenclatura e histórico | Specify | Pending |
| DOC-03 | Catálogos e páginas | Specify | Pending |
| DOC-04 | Arquitetura | Specify | Pending |
| DOC-05 | Responsabilidades e estado | Specify | Pending |
| DOC-06 | Falhas e resumo | Specify | Pending |
| DOC-07 | Persistência e MER | Specify | Pending |
| DOC-08 | Logs e geração | Specify | Pending |
| DOC-09 | Tempos | Specify | Pending |
| DOC-10 | Cadastro e assinatura | Specify | Pending |
| DOC-11 | Defaults | Specify | Pending |
| DOC-12 | Falhas na sincronização | Specify | Pending |
| DOC-13 | JSONs portáteis | Specify | Pending |
| DOC-14 | Remoções e histórico | Specify | Pending |
| DOC-15 | Inventário e diagramas | Specify | Pending |
| DOC-16 | Parâmetros | Specify | Pending |
| DOC-17 | Evidência | Specify | Pending |
| DOC-18 | Verificação futura | Specify | Pending |
| DOC-19 | Escopo da sessão atual | Specify | Verified |

## Success Criteria

- Este pacote é autocontido: inclui prompt de início, mapa de mudanças, assinaturas/uses de referência, JSONs completos e limites conhecidos.
- Nenhuma documentação ou fonte de execução foi implementada/modificada para atender este pedido atual.
- Na futura entrega, os dezoito requisitos de conteúdo e verificação devem ter evidência própria; DOC-19 comprova apenas a preparação deste pacote.
- Comandos futuros em `Documentacoes/`: `npm run check` e `npm run build`. Não foram executados nesta sessão, pois o build escreve saídas e o usuário pediu somente leitura da documentação.
- Verificar manualmente catálogo, busca por nomes novos/antigos, links de símbolos e Mermaid, histórico, exemplos copiados e fontes em ambiente com capitalização estrita.
- Sem publicação automática, alterações de código TDD ou gravação de banco pela sessão documental.
