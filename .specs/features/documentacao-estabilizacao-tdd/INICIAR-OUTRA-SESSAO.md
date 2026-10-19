# Repasse para a sessão de documentação

Copie o prompt abaixo para a outra sessão. Se ela estiver em outra branch/worktree sem este pacote, disponibilize juntos spec.md, inventario-fontes.md e este arquivo. O inventário contém os JSONs ignorados: não é necessário reconstruí-los da conversa.

## Prompt pronto

```text
Implemente a atualização da documentação dos artefatos TDD conforme:

.specs/features/documentacao-estabilizacao-tdd/spec.md
.specs/features/documentacao-estabilizacao-tdd/inventario-fontes.md

Esta sessão é a frente de documentação. A worktree de estabilização é:
C:/Users/Gerson Ribeiro/Documents/TEK/ProjetosTek/Testes/TestesAutomatizadosERP-tdd-runner

Leia os fontes dessa worktree somente como referência. Não altere Pascal,
JSONs de execução, banco de dados ou comportamento do TDD. Não publique
automaticamente o portal. Preserve modificações já existentes do usuário.

Não dependa do histórico de conversa. A especificação contém o mapa de
renomes, as responsabilidades redistribuídas, o formato editorial do portal,
as inclusões/remoções/correções necessárias e os limites conhecidos.
O inventário contém os caminhos/uses/assinaturas atuais, hashes e o conteúdo
integral dos três JSONs que são ignorados por .gitignore.

Reconcilie os fontes com o inventário antes de escrever: HEAD db20fe6 não
contém todas as mudanças sem commit. Não faça checkout/reset nem substitua
arquivos do usuário para igualar os hashes. Se houver alterações posteriores,
registre as diferenças e documente o contrato atual verificável.

Use os formatos já existentes em Documentacoes/app/content e os diagramas
canônicos em docs/MAPEAMENTO_AST_USES_UNITS. Não faça uma troca global de
nomes nos materiais históricos. Não promova a implementação a validado-no-erp
sem evidência nativa posterior identificável.

Os contratos essenciais são:
- Runner agora usa os nomes TDD_RUN_*; P39_ indica referência remota.
- ASSERTS está implementado e possui métricas persistidas; não é mais reserva.
- No piloto, TEARDOWN ocorre dentro de Teste antes de ASSERTS; comparações
  usam capturas feitas antes dos fechamentos.
- FINISHED fecha ticks pendentes, consolida métricas e copia logs antes
  do INSERT; a captura continua condicionada a FModoDebug.
- RegistrarCasoTeste recebe seis argumentos e uma única unit JSON.
- resultadoEsperado ausente usa P39_TDD_ASSERTS_JSON_MINIMO; {} explícito
  não busca padrão e apenas registra SEM_VALIDACAO na execução.
- camposDisponiveis ausente ou {} consulta
  P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO, cujo conteúdo atual é {}.
- A sincronização separa as duas propriedades reservadas dos dados do caso.
  Não há envelope casoTeste nem propriedade raiz asserts no contrato final.
- Falhas de leitura/configuração não viram {} silenciosamente.
- A última sincronização ainda exige teste real no ERP. Gates locais não
  comprovam compilação nativa, gravação real ou segurança de reexecução.

Implemente apenas a documentação após essa reconciliação. Entregue a lista
de páginas/mapas alterados e os resultados de npm run check e npm run build
em Documentacoes, além da revisão de links, busca/aliases e diagramas.
Não corrija a falha anterior de Free sem nil no código TDD para fazer uma
afirmação documental passar; registre o limite.
```

## Ordem recomendada para a leitura

1. Ler a especificação inteira, especialmente as tabelas de renomes e defaults.
2. Conferir o inventário e os três corpos JSON ao final dele.
3. Ler RUN_IRUNNER, o molde, RUN_RUNNER, STARTED e FINISHED para o ciclo.
4. Ler RUN_ASSERTS, RUN_MODULO, VALIDAR_RESULTADO e o financeiro para os donos e capturas.
5. Ler o registrador e seus quatro consumidores para a fonte única e a nova assinatura.
6. Ler apenas então as páginas documentais da matriz, tratando-as como formato/conteúdo a corrigir.
7. Planejar páginas e diagramas; preservar histórico e atualizar fontes/rotas com o catálogo.
8. Verificar catálogo/build, portabilidade sem JSONs ignorados e resultado visual da navegação.

## Exemplos que não podem faltar no resultado documental

### Entrada do piloto

```pascal
SetTDDUnit('TDD_FIN_FINANCEIRO');
AddParamsRun('''FINANCEIRO''');
AddParamsRun('''FINANCEIRO''');
Executar;
```

### Registro com uma fonte

```pascal
RegistrarCasoTeste(
  'FINANCEIRO', 'FINANCEIRO', 'TDD_FINANCEIRO',
  '160.00', 'TDD_FIN_FINANCEIRO_JSON', False);
```

`TDD_FINANCEIRO` nesse exemplo é a descrição do registro, não o nome da unit executável. False seleciona a fonte local; os defaults continuam nas units remotas de nome exato.

### Resultado explicitamente desativado

```json
{
  "EMPRESA_DUP": 1,
  "parametros": {},
  "resultadoEsperado": {},
  "camposDisponiveis": {}
}
```

Esse fragmento demonstra a política de configuração; não é um caso financeiro positivo completo. O resultado explícito vazio não consulta o mínimo de asserts. Os campos vazios consultam o mínimo de campos. O inventário contém o modelo completo de entrada e os dois mínimos.

## Definição de entrega desta preparação

Os três arquivos deste pacote constituem a especificação e o contexto portátil. A documentação do portal, os diagramas, o MER e os fontes foram apenas lidos. Critérios DOC-01 a DOC-18 são trabalho da sessão futura; DOC-19 se refere ao limite observado nesta sessão.
