# Mapas canônicos da documentação

Todos os Mermaid ativos do portal estão em um subdiretório por documentação:

- `runner/`: dependências declaradas, montagem dinâmica, lote, falhas, estados e métricas.
- `casos-de-teste/`: cadastro e datasets compartilhados.
- `parametros/`: preparação, aplicação e escopo dos parâmetros.
- `casos-legado/`: seleção de cenário no processamento anterior.
- `casos-irunner/`: entrada atual e execução por registro.
- `piloto-financeiro/`: dependências e sequência das operações do piloto atual.
- `pedido-venda/`: contribuição do PR #20, com dependências, execução e Draw.io do faturamento refatorado.
- `historico/financeiro/`, `historico/faturamento/` e `historico/cadastro/`: mapas, HTMLs e Draw.io dos contratos anteriores, preservados para consulta. Não representam os fontes atuais do IRunner.

O portal referencia o Markdown canônico; não há cópias dos diagramas em TypeScript. Orientação e zoom são opções locais de leitura. Novos diagramas devem usar `docs/MAPEAMENTO_AST_USES_UNITS/<slug-do-documento>/<diagrama>.md`.

`runner/P39_TDD_IRUNNER.ast.json` mantém o inventário sintático de uses, fontes, linhas, hashes e alcance transitivo. Seu Mermaid correspondente está em `runner/P39_TDD_IRUNNER.md`. O inventário inclui o processamento financeiro que configura o piloto. A extração é limitada às dependências sintáticas; nomes externos e prefixos diferentes permanecem distintos, sem inferir equivalência entre a unit local e a cadastrada no ERP.

As referências históricas de fluxo completo, fallbacks de configuração financeira e carregador independente foram arquivadas. O piloto atual recebe o contexto de P39_TDD_STARTED, usa Teste sem parâmetros, executa quatro operações e realiza teardown em finally. O cursor e a liberação dos artefatos globais pertencem ao molde; TDD_ASSERTS permanece pendente.

Os hashes SHA-256 normalizam apenas CRLF para LF antes do cálculo, preservando todos os demais bytes. Assim, o inventário é verificado tanto no checkout Windows quanto no Linux do GitHub Actions, sem ocultar alterações no conteúdo dos fontes.
