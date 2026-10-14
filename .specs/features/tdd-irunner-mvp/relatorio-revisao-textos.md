# Revisão de escrita das units do Runner

## Realização (Interno)

Revisadas mensagens e comentários das units locais do Runner, corrigindo acentuação e pontuação. No arquivo salvo, os três prefixos internos de MensagemPersonalizada em TDD_STARTED ainda estavam presentes; foram removidos conforme a orientação do usuário. O prefixo interno introduzido em CalcularTickRelativo também foi retirado, mantendo a apresentação centralizada no tratamento externo de Run.

A comparação dos tokens antes/depois confirmou alterações somente em textos, comentários e nos prefixos retirados. Os nomes técnicos e o marcador usado para gerar o fluxo permanecem consistentes. Os arquivos continuam em UTF-8 e os caracteres são representáveis em WIN1252. git diff --check passou. Não houve acesso ao banco nem execução do processamento financeiro.

Orientação registrada para futuras correções: quando Run já acrescenta MensagemPersonalizada ao erro apresentado, as rotinas internas devem propagar a mensagem sem repetir esse prefixo.

## Fontes modificados

- docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas
- docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_IRUNNER.pas
- docs/assets/emDesenvolvimento/Runner/TDD_LOGS.pas
- docs/assets/emDesenvolvimento/Runner/EXAMPLE_RESULTADO_UNIT_PARA_INTERPRETAR.pas
- .specs/features/tdd-irunner-mvp/relatorio-revisao-textos.md

## p/ teste

1. Conferir os textos das instruções, mensagens e comentários nas units locais revisadas.
2. Ao disponibilizá-las no BI, fechar e reabrir as units para carregar os fontes atuais.
3. Nas mensagens de erro, conferir a acentuação e a ocorrência única do cabeçalho personalizado apresentado por Run.

## O que há de novo

Mensagens e comentários do Runner foram revisados para português com acentuação. O cabeçalho personalizado permanece concentrado no tratamento externo da execução.
