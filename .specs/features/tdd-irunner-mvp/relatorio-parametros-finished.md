# Ajuste local da leitura de parametros e do diagnostico FINISHED

**Data:** 2026-10-14
**Status:** implementado localmente; validacao no JvInterpreter pendente.

## Realizacao (Interno)

Consultadas TDD_STARTED, TDD_BASE_UNIT_IRUNNER e TDD_FINISHED nos grupos 1 a 6 do banco ERP informado, em transacao READ ONLY encerrada com ROLLBACK. Nenhuma gravacao foi realizada. A leitura GetObjectJson(FCasoTesteAtualJson, 'parametros') esta em STARTED, nao em FINISHED. O runner relanca falhas de STARTED, mas seu finally atribuia FINISHED ao nome da etapa antes de persistir, podendo exibir esse nome com a excecao original.

O arquivo docs/assets/emDesenvolvimento/TDD_JSON_FINANCEIRO.json informado pelo usuario contem parametros com seis opcoes. Portanto a ausencia da tag nao explica esse arquivo. Nao foi inspecionada a implementacao nativa de GetObjectJson nem confirmado o conteudo efetivamente carregado do caso 33. A causa dessa divergencia no ambiente continua a exigir verificacao no ERP.

A leitura local passou a usar ParseJSONValue e percorrer os pares da raiz via ExecutarMetodoDeObjeto/GetPair, GetPairName e GetPairValue, padrao ja utilizado por P39_TDD_PARAMETRO. Uma secao ausente ou objeto vazio nao aplica parametros. JSON invalido e secao com tipo diferente de objeto continuam sendo erros; as falhas de VerificarParametros continuam propagadas. Nao foi adicionado fallback silencioso para erros de leitura/aplicacao. O objeto raiz e liberado no finally.

O runner guarda a etapa anterior a FINISHED e a restaura somente depois de uma persistencia bem-sucedida. Se a persistencia levantar excecao, o nome continua FINISHED. Assim, um erro pendente de STARTED nao e rotulado como erro de persistencia quando o encerramento passa.

Evidencias locais: a sonda de JSON passou para ausencia, raiz vazia, texto vazio, secao vazia/preenchida, JSON formatado, secao somente aninhada e cinco entradas invalidas. A fixture real preservou as seis opcoes e seus valores. Mutacao temporaria de parametros para parametro foi detectada. A sonda do nome da etapa falhou no fonte anterior (FINISHED em vez de STARTED) e passou no fonte atualizado para STARTED, IRUNNER e falha real da persistencia. git diff --check passou.

As sondas traduzem trechos restritos do fonte Pascal para JavaScript e substituem parser/adapters/persistencia. Sao evidencia da logica local, nao compilacao Pascal nem execucao do JvInterpreter. A simulacao da leitura anterior reproduz somente ausencia artificial; nao reproduz o erro nativo com a fixture real, que contem a tag. Nao foi executado processamento financeiro nem INSERT de historico nesta sessao.

Conhecimento para a skill do interpretador: FNomeMetodoAtual precisa conservar a origem de uma excecao pendente ao atravessar um finally de persistencia; encontrar parametros no arquivo local nao prova que o adapter nativo o encontra no JSON carregado em runtime.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas
- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas
- .specs/features/tdd-irunner-mvp/evidencias/testar-parametros-json.mjs
- .specs/features/tdd-irunner-mvp/evidencias/testar-metodo-finished.mjs
- .specs/features/tdd-irunner-mvp/relatorio-parametros-finished.md

TDD_FINISHED e o JSON financeiro nao foram alterados. Alteracoes anteriores da worktree foram preservadas.

## p/ teste

1. Disponibilizar os fontes locais TDD_STARTED e TDD_BASE_UNIT_IRUNNER no ambiente de testes e fechar/reabrir as units no BI.
2. Executar o caso 33 com massa controlada. Conferir o JSON exibido no log Preparando caso de teste e comparar com o arquivo financeiro informado.
3. Conferir se as seis opcoes de parametros sao lidas e aplicadas, e se a execucao ultrapassa STARTED. Confirmar tambem o historico da tentativa.
4. Em uma fixture sem operacoes financeiras, conferir um caso sem parametros e outro com parametros vazio: ambos devem seguir sem alterar parametros.
5. Nessa mesma fixture, usar JSON invalido ou parametros com texto/array/null: deve aparecer erro de preparacao, identificado como STARTED se a persistencia do historico passar.
6. Provocar falha controlada na persistencia nessa fixture: o diagnostico deve continuar identificando FINISHED.

Sondas locais a partir da raiz do repositorio:

```powershell
node '.specs/features/tdd-irunner-mvp/evidencias/testar-parametros-json.mjs' . 'docs/assets/emDesenvolvimento/TDD_JSON_FINANCEIRO.json'
node '.specs/features/tdd-irunner-mvp/evidencias/testar-metodo-finished.mjs' .
```

## O que ha de novo

A leitura da secao de parametros passou a percorrer o JSON do caso diretamente. O diagnostico preserva a etapa original quando o encerramento consegue registrar o historico. Confirmacao no ERP ainda pendente.
