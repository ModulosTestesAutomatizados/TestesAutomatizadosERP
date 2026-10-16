# Mapas canônicos da documentação

Os Mermaid ativos ficam em um subdiretório por documento:

- runner/: geração, lote, tentativa, falhas, estados, persistência, modelo ER e AST dos uses.
- p39-tdd-registrar-caso-teste/: fonte única, defaults, projeções e AST da sincronização.
- historico/: mapas de contratos anteriores. O diretório manutencao-migracao-units conserva um mapa anterior de renomes para consulta histórica; não representa os contratos atuais nem integra o portal.

Os arquivos TDD_RUN_IRUNNER.ast.json e sincronizacao.ast.json registram roots, nós, paths, linhas e edges das cláusulas uses. Comentários e literais são mascarados; carga dinâmica e compartilhamento de estado aparecem em diagramas separados. Cada nó local tem hash SHA-256 normalizando somente CRLF para LF.

Variantes P39_ são identificadas como referência a arquivo local inequívoco, sem comprovar cadastro no ERP. TDD_VALIDAR_RESULTADO, citado no uses de TDD_RUN_RUNNER, não tem arquivo local do mesmo nome; não recebe artificialmente o hash de P39_TDD_RUN_VALIDAR_RESULTADO. Esse validador atual é uma raiz explícita do inventário.

O build Vite valida catálogo, fontes, capitalização exata, Mermaid e hashes antes de publicar. Copia apenas os mapas/inventários e moldes referenciados. O portal não mantém strings Mermaid duplicadas. A orientação e o zoom são preferências de leitura.

O fluxo atual executa ASSERTS e persiste suas métricas; pendências históricas não descrevem o contrato novo. docs/MER.md aponta para o modelo ER canônico em runner/persistencia-modelo.md.
