# Ajuste local do overflow no cronometro IRunner

**Data:** 2026-10-14
**Status:** implementado localmente; validacao no JvInterpreter do ERP pendente.

## Realizacao (Interno)

Consultadas as oito units de GR_UNIDADE_CODIFICACAO nos grupos 1 a 6 do banco informado, em transacao READ ONLY encerrada com ROLLBACK. Nenhuma gravacao foi executada. TDD_RUNNER recebe GetTickCount e envia o contador absoluto para campos AsInteger; TDD_FINISHED tambem consome AsInteger. As units consultadas nao definem GetTickCount/TickDiff: o registro desses metodos no adapter do ERP nao foi inspecionado.

O contador bruto agora entra em Double. O CDS recebe milissegundos relativos a inicializacao de cada tentativa, acrescidos de 1 para reservar zero como marcador de fim em aberto. A diferenca entre inicio e fim continua calculada pelo TickDiff existente, sem alterar TDD_FINISHED ou o banco. A virada do contador de 32 bits e compensada antes da conversao para Integer. A tentativa admite ate 2.147.483.646 ms (aproximadamente 24,85 dias); acima disso, informa erro explicito antes da conversao. A base da tentativa e reiniciada em InicializarMetricasTickDiff.

FNomeMetodoAtual passa a identificar INICIALIZAR METRICAS e TOTAL antes dessas operacoes. As renomeacoes e exclusoes que ja estavam na worktree foram preservadas.

**Evidencia local:** o caminho anterior reproduziu overflow com 2.834.258.109. A sonda numerica extrai e traduz somente a rotina escalar Pascal para C#, executando seis vetores com resultados literais e uma rejeicao por limite. Todos passaram. Trocar temporariamente a compensacao 4.294.967.296 por 4.294.967.295 fez o caso de virada falhar (esperado 12, obtido 11). git diff --check passou.

**Limite da evidencia:** a sonda nao compila Pascal e nao executa o JvInterpreter, seus adapters, TickDiff, o CDS ou a persistencia. Portanto nao comprova a resolucao funcional do caso 28. Executar a sonda em uma nova sessao PowerShell por rodada, pois Add-Type conserva o tipo compilado na sessao.

Conhecimento para a skill do interpretador: um contador Cardinal retornado pelo ambiente nao deve atravessar AsInteger como uptime absoluto; Double permite calcular e validar o valor relativo antes da conversao. Nao inferir a assinatura do adapter apenas pelo nome do metodo.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas
- .specs/features/tdd-irunner-mvp/evidencias/testar-tick-relativo.ps1
- .specs/features/tdd-irunner-mvp/relatorio-overflow-tick.md

## p/ teste

1. Disponibilizar no ambiente de testes os dois fontes Pascal atualizados, mantendo os nomes TDD_RUNNER e TDD_BASE_UNIT_IRUNNER.
2. Fechar e reabrir as units no BI para que a sessao use o codigo atualizado.
3. Executar o processamento financeiro com a massa controlada do piloto. Conferir se o caso 28 ultrapassa o inicio TOTAL sem o overflow informado.
4. Conferir no historico os tempos de cada etapa: inicio e fim sao relativos a tentativa; o total continua sendo a duracao em milissegundos e o texto continua formatado.
5. Repetir o lote e conferir a nova base por tentativa e a liberacao dos recursos. Uma eventual nova falha deve ser registrada separadamente: esse ajuste trata o cronometro.
6. Para verificar os limites sem executar operacoes financeiras, usar uma fixture de teste sem gravacoes com CalcularTickRelativo(2834258109.0, 2834258000.0) = 110, CalcularTickRelativo(5.0, 4294967290.0) = 12 e CalcularTickRelativo(123.0, 123.0) = 1. Conferir tambem que inicio e fim no mesmo tick produzem duracao zero e fim diferente de zero.

Para repetir a evidencia numerica local a partir da raiz do repositorio, em uma nova sessao PowerShell:

```powershell
& '.specs/features/tdd-irunner-mvp/evidencias/testar-tick-relativo.ps1' -Root (Get-Location).Path
```

## O que ha de novo

O cronometro usa o tempo de cada tentativa, evitando que o contador acumulado da maquina provoque overflow ao iniciar o teste. Falhas na preparacao das metricas passam a identificar a operacao na mensagem. Confirmacao no ERP ainda pendente.
