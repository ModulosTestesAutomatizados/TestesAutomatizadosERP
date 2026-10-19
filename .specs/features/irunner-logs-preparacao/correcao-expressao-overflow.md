# Realização

Investigado o transporte textual dos logs de preparação. A montagem convertia cada CR/LF em operadores de soma dentro de uma única atribuição. O molde completo gerava centenas desses operadores. O JvInterpreter limita a pilha de expressões e emite ieExpressionStackOverflow quando ela é excedida; isso é compatível com o erro informado, mas a origem exata no ERP ainda depende do reteste.

A montagem agora usa literais consecutivos: `'linha'#13#10'outra linha'`. O parser do JvInterpreter transforma constantes # em tokens de string, e Expression1 acumula tokens consecutivos sem essa cadeia de operadores. Nenhum método novo, nil ou alteração de limpeza foi introduzido.

Referências consultadas: [JvInterpreter.pas](https://github.com/project-jedi/jvcl/blob/master/jvcl/run/JvInterpreter.pas), constante cJvInterpreterStackMax e Expression1; [JvInterpreterParser.pas](https://github.com/project-jedi/jvcl/blob/master/jvcl/run/JvInterpreterParser.pas), leitura de constantes de caracteres. Context7 não estava disponível entre as ferramentas desta sessão.

# Fontes modificados

- docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_IRUNNER.pas: duas substituições de CR/LF e comentário.
- .specs/features/irunner-logs-preparacao/testar-expressao.mjs: verifica o fonte gerado e a igualdade integral do snapshot.
- .specs/features/irunner-asserts-modulo/evidencias/pascal.mjs: executor restrito passa a reconhecer literais consecutivos, conforme o parser consultado.
- docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_RUN_IRUNNER.ast.json: hash atualizado.

# p/ teste

O teste novo falhou antes da correção pela presença da cadeia de operadores. Depois, passou preservando integralmente conteúdo, aspas, acentos e CR/LF. Passaram também quatro grupos de liberação e dezesseis de regressão. São verificações locais com fronteiras ERP substituídas; não reproduzem a pilha nativa do interpretador.

Atualizar TDD_RUN_IRUNNER no ambiente que já recebeu a correção anterior de propriedade das listas. Repetir o processamento e conferir os logs de preparação persistidos por caso, inclusive quando o caso falhar. Execução nativa pendente. Sem banco, commit ou publicação.

# O que há de novo

O texto de preparação continua completo, com sua representação gerada sem centenas de somas na mesma expressão.
