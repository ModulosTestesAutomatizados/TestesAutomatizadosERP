---
name: consultar-documentacao-tdd
description: Consultar contratos TDD do ERP por unit, estado global, procedure ou fluxo, usando o catálogo e a exportação documental. Usar para entender ou fundamentar alterações no TDD; autoria do portal segue contribuir-documentacao.
---

# Consultar o conhecimento TDD

Localize o assunto e leia somente os documentos necessários. A documentação descreve o contrato e suas limitações; evidência de execução no ERP é registrada separadamente por documento.

## Escolher a fonte

Com checkout local, use `Documentacoes/.pages-output/knowledge/index.json` e os Markdown dessa mesma saída, quando houver um build atual. Gere com `npm run build --prefix Documentacoes` quando necessário à tarefa. Para uma consulta simples sem build, leia o catálogo em `Documentacoes/app/catalogo/index.ts` e o conteúdo da slice em `app/components`; os contratos de `app/contracts/documentacao.ts` identificam os campos.

Sem checkout, comece em `https://modulostestesautomatizados.github.io/TestesAutomatizadosERP/llms.txt` após a publicação desta exportação. Siga o índice e os links Markdown ali fornecidos. Eles são arquivos estáticos e podem ser lidos por HTTP sem executar Vue. Um 404 pode indicar que a exportação ainda não foi publicada; não invente seu conteúdo.

Compare `schemaVersion` e `contentVersion` do índice ao reutilizar uma consulta. `contentVersion` é o hash do conteúdo exportado, normalizando CRLF/LF; não é número de versão do ERP. Uma árvore local modificada pode estar à frente do site publicado: identifique qual revisão fundamenta a resposta. Se o build estiver desatualizado, consulte os fontes locais atuais ou gere uma nova saída antes de afirmar o contrato vigente.

## Encontrar o assunto e seus donos

O índice contém `documentos`. Procure `unit`, `titulo` e `aliases` para nomes de units. Para artefatos e estados globais, examine `simbolos` com `tipo: estado`, incluindo seus aliases. Para procedures/functions, examine `tipo: metodo`, `nome` e `assinatura`. `navegacao.contexto` distingue fluxo, unit, helper e caso de teste.

Exemplos: `FCDSCasosTestes` pode ser alias de um estado; `RegistrarLog` é método de TDD_RUN_LOGS. Leia o Markdown do resultado e siga as citações de dependências conforme a dúvida. Não trate um consumidor que menciona o símbolo como seu proprietário. A assinatura e o ciclo de vida estão na página individual; o fluxo explica a ordem entre units.

Use `markdown` para o texto, `pagina` para a interface e `fontes` para o código de origem. Os símbolos também oferecem links para suas seções. Resolva URLs que começam com `/` no mesmo host da documentação, preservando `/TestesAutomatizadosERP/`.

## Fundamentar a resposta ou alteração

Preserve o nome real: aliases de consulta e redirects não comprovam o identificador instalado no ERP. Leia avisos e limites antes de reutilizar exemplos, especialmente IDs/valores a preencher, reexecução e estado global.

Para dependências, siga os inventários AST indicados pelo índice e os Mermaids canônicos em `docs/MAPEAMENTO_AST_USES_UNITS`. Diferencie `uses` de carga dinâmica, estado compartilhado e referências não resolvidas; hash local não comprova instalação remota.

Confira o fonte Pascal quando a tarefa depender da implementação exata ou houver divergência com a documentação. Relate a divergência e a revisão consultada. Não corrija nomes/contratos silenciosamente para fazê-los coincidir. `em-uso` e `em-desenvolvimento` não equivalem a `validado-no-erp`; mesmo este último exige conferir data, versão e referência em `evidenciaValidacao` para o escopo da conclusão.

Cite a página/seção e o caminho ou URL do fonte que sustentam a conclusão. Informe limites sem transformar uma verificação do frontend em homologação do ERP. A consulta não autoriza executar Pascal, SQL, sincronização ou operações no ERP; alterações necessárias seguem a autorização e as orientações da tarefa em andamento.
