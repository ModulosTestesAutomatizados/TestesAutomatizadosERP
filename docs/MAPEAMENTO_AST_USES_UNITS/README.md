# Mapas canônicos da documentação

Todos os Mermaid ativos do portal estão em um subdiretório por documentação:

- `runner/`: dependências declaradas, montagem dinâmica, lote, falhas, estados e métricas.
- `historico/financeiro/`, `historico/faturamento/` e `historico/cadastro/`: mapas, HTMLs e Draw.io dos contratos anteriores, preservados para consulta. Não representam os fontes atuais do IRunner.

O portal referencia o Markdown canônico; não há cópias dos diagramas em TypeScript. Orientação e zoom são opções locais de leitura. Novos diagramas devem usar `docs/MAPEAMENTO_AST_USES_UNITS/<slug-do-documento>/<diagrama>.md`.

`runner/P39_TDD_IRUNNER.ast.json` mantém o inventário sintático de uses, fontes, linhas, hashes e alcance transitivo. Seu Mermaid correspondente está em `runner/P39_TDD_IRUNNER.md`. As raízes incluem P39_TDD_FIN_PROCESSAMENTO e o cenário P39_TDD_FIN_PAGAMENTO_RECEBIMENTO, selecionado por SetTDDUnit. O inventário usa os nomes canônicos dos arquivos atuais, incluindo os dois mapeamentos locais de borderô. Não comprova o cadastro das units no ERP. Os diretórios das páginas excluídas foram removidos; cada nova página que possuir Mermaid deverá manter seu próprio subdiretório.

As referências históricas de fluxo completo, fallbacks de configuração financeira e carregador independente foram arquivadas. O piloto atual recebe o contexto de P39_TDD_STARTED, usa Teste sem parâmetros, executa quatro operações e realiza teardown em finally. O cursor e a liberação dos artefatos globais pertencem ao molde; TDD_ASSERTS permanece pendente.

Os hashes SHA-256 normalizam apenas CRLF para LF antes do cálculo, preservando todos os demais bytes. Assim, o inventário é verificado tanto no checkout Windows quanto no Linux do GitHub Actions, sem ocultar alterações no conteúdo dos fontes.
