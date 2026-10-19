# Realização

Atualização posterior solicitada pelo usuário: substituídas somente as quatro entradas de AbrirTela do piloto por máscaras EVENTO_INCLUIR_DUPLICATA_RECEBER/PAGAR e EVENTO_INCLUIR_BORDERO_RECEBIMENTO/PAGAMENTO, para preenchimento manual dos handlers reais. Não executar o piloto sem substituir essas máscaras. Application, catálogo e cache não foram modificados nesse ajuste. A expectativa de integração e o hash do piloto no inventário foram atualizados; os sete grupos locais continuam aprovados.

Concluído localmente o consumo de TDD_RUN_APPLICATION, nome de arquivo já iniciado pelo usuário na nova pasta da arquitetura. AbrirTela mantém um único parâmetro e aceita evento do principal identificado por MetodosDeObjeto, ou Caption/Form do catálogo do módulo. A enumeração dos métodos não os executa.

O catálogo versionado fica em docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_APPLICATION_MAPEAMENTO_JSON.json. A chave de primeiro nível é o módulo; cada Form contém caption e evento. Aberturas com evento são priorizadas, instâncias existentes são reutilizadas e entradas sem evento mantêm a criação pelo Form registrado. O catálogo não usa o banco nem o JSON do caso. Os objetos de leitura são liberados por chamada; não foi criado um cache global.

O piloto usa Contas a Receber na abertura da duplicata a receber e os três outros nomes de Form já confirmados nos fontes. Somente o evento Receber1Click e seu título foram fornecidos pelo usuário; outros Captions/Eventos não foram inventados. Abertura, preenchimento, foco dos campos e teardown permanecem responsabilidades distintas.

O helper foi melhorado e movido de emDesenvolvimento para docs/assets/snippets/TDD_MAPEAMENTO_EVENTOS.pas, fonte canônica copiável no portal. Ele executa um evento selecionado, captura o Caption de seu componente de menu e compara nomes de Forms anteriores e posteriores. Nunca usa Free nos Forms/DMs compartilhados. Os resultados são candidatos a revisão; não atualiza nem publica o catálogo automaticamente.

Usada a skill .agents/skills/contribuir-documentacao/SKILL.md para registrar o helper, documentar a Application, reconciliar caminhos movidos e manter aliases/redirect do nome anterior. O portal já tinha referências a inventários e diagramas ausentes: foram adicionados os cânones necessários e reconciliados os hashes/edges de uses, distinguindo carga dinâmica e estado compartilhado. Um guia apontava para a skill consultar-documentacao-tdd ausente; foi mantido como guia e passou a informar essa pendência sem exigir um arquivo inexistente no build.

# Fontes modificados

Fontes Pascal e dados desta iteração (as movimentações anteriores do usuário foram preservadas):

- docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_APPLICATION.pas
- docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_RUNNER.pas
- docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_APPLICATION_MAPEAMENTO_JSON.json
- docs/assets/casosTestesFinanceiro/TDD_FIN_FINANCEIRO.pas
- docs/assets/snippets/TDD_MAPEAMENTO_EVENTOS.pas (movido e revisado)

Documentação e evidências:

- Documentacoes/app/components/helpers/gerais/index.ts
- Documentacoes/app/components/helpers/gerais/conteudo/tdd-mapeamento-eventos.ts
- Documentacoes/app/components/units/irunner/index.ts
- Documentacoes/app/components/units/irunner/conteudo/p39-tdd-run-application.ts (substitui a página modulo)
- Documentacoes/app/catalogo/redirecionamentos.ts
- Documentacoes/app/components/contribuir/conteudo/agentes.ts
- Documentacoes/app/components/arquitetura/irunner/conteudo/runner.ts
- Referências de fontes em Documentacoes/app/components/units/irunner, casos-de-teste e helpers reconciliadas com os caminhos reais; nenhuma view Vue foi reescrita.
- docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_RUN_IRUNNER.ast.json e TDD_RUN_IRUNNER.md
- Diagramas geracao, tentativa, estados, persistencia-modelo e persistencia no mesmo diretório.
- docs/MAPEAMENTO_AST_USES_UNITS/p39-tdd-registrar-caso-teste/sincronizacao.ast.json e fonte-unica.md
- .specs/features/irunner-application/ e adaptações de caminhos nas sondas anteriores.

Sem stage, commit, banco, execução real de menus/helper, publicação de units ou deploy do portal.

# p/ teste

1. Cadastrar o conteúdo do novo catálogo JSON na unit remota P39_TDD_RUN_APPLICATION_MAPEAMENTO_JSON, do tipo JSON, antes de testar Caption ou Form. Esse cadastro não foi feito nesta sessão.
2. Atualizar no ambiente as units APPLICATION, RUNNER e o piloto financeiro com suas dependências. A unit anterior MODULO não é mais o uses do runner.
3. No módulo financeiro de testes, conferir AbrirTela('Contas a Receber'), AbrirTela('FCadReceber') e AbrirTela('Receber1Click'). As três entradas devem chegar à tela esperada; a forma direta de evento mantém o contrato anterior.
4. Testar novamente com a tela já aberta: entradas Caption/Form devem reutilizá-la. O evento direto continua executando o handler informado.
5. Executar o piloto autorizado e conferir os quatro fluxos, resultados e fechamento das telas. As demais telas usam seus Forms registrados, com eventos vazios, até o levantamento complementar.
6. Abrir no portal Helpers → Gerais → TDD_MAPEAMENTO_EVENTOS. Copiar o molde, conferir cEvento e o nome real cComponenteMenu (Receber1 é configuração a conferir no ambiente) antes de executar manualmente.
7. Para o helper, usar ambiente isolado e somente um evento de abertura escolhido. Conferir EVENTO/FORM/CAPTION, que as telas preexistentes não foram fechadas e que o RichEdit foi restaurado. Se houver múltiplos candidatos, revisar antes de alterar o catálogo.

Evidência local aprovada: 7 grupos principais, 7 independentes, 3 mutações detectadas, validação estrutural da especificação, npm run check e npm run build do portal. Verificação estática confirmou catálogo, grupo/subgrupo, símbolos, redirect e igualdade dos bytes do molde publicado com o canônico. Não foi feita inspeção visual no navegador nem validação nativa no ERP.

Regressões mais amplas não foram declaradas integralmente aprovadas: após reconciliar os caminhos movidos, a suíte anterior do IRunner passa 15 grupos e reprova a expectativa FParamsCasosTeste=nil na geração/reexecução; o fonte atual do usuário não faz essa atribuição. A sonda de logs espera MostrarLogTexto com um argumento, enquanto a implementação atual do usuário envia texto e título em dois argumentos. As expectativas foram preservadas; esses contratos não foram alterados para contornar as falhas.

# O que há de novo

Os testes podem abrir telas pelo título amigável do menu, pelo Form cadastrado ou pelo evento. Um helper documentado auxilia a construir o DE → PARA sem executar todos os métodos da aplicação nem destruir telas preexistentes.
