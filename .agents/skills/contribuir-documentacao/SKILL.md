---
name: contribuir-documentacao
description: Criar e manter páginas, documentação de units, grupos de navegação e componentes do portal TDD em Vue/Vite, com snippets e Mermaid canônico. Usar para contribuições ao portal; alterações na execução Pascal pertencem a outro trabalho.
---

# Contribuir com o portal TDD

Trabalhe a partir da raiz do repositório. As referências abaixo são relativas a ela; não dependem do diretório pessoal de um autor.

## Localizar o dono da alteração

Leia `Documentacoes/app/README.md` e o guia em `Documentacoes/app/components/contribuir/conteudo/autoria.ts`. O código e conteúdo ficam em `Documentacoes/app`. Dentro de `components`, localize a feature: `arquitetura/irunner`, `units/{setup,constantes,persistencia,irunner}`, `casos-de-teste`, `mapeamentos/financeiro`, `helpers/{gerais,sincronizacao}` ou `contribuir`.

Edite dados de `conteudo/` quando os blocos existentes forem suficientes. Crie view/componente SFC com `<script setup lang="ts">` somente para comportamento ou apresentação próprios. Reutilize o leitor e seus blocos; não crie uma cópia de DocumentoView por unit. Slices expõem seus registros pelo `index.ts`; composição do catálogo fica em `app/catalogo`.

## Conteúdo e registro

Use os tipos de `app/contracts/documentacao.ts` e a fábrica `app/contracts/criarDocumentoUnit.ts`. Consulte os snippets reais em `.vscode/documentacao.code-snippets`; ajuste o caminho relativo ao local do arquivo. Registre a página uma vez no export público da slice. Menu, cards, busca e referências derivam do catálogo, sem listas manuais paralelas.

Grupos/subgrupos são registrados no arquivo único indicado pelo guia; cada página informa `navegacao` e ordem. Uma seção usa id único no documento e não precisa de outra rota. Atualize o estado explicitamente. `validado-no-erp` exige data, versão e referência reais; compilação local não comprova homologação no ERP.

Para uma unit, documente responsabilidade, problema resolvido, estados globais e seus donos/ciclo, assinaturas reais, efeitos, implementação, dependências e limites. Distinga identificador Pascal local, referência remota, alias de pesquisa e redirect de URL. Não force prefixo P39_ sobre um nome TDD_RUN_ real. Citações são resolvidas pelo componente de referência a partir do catálogo.

Para casos/configurações, use JSON literal copiável e tabela que explique objetos/campos e impacto no teste. Identifique valores que precisam ser preenchidos. Exemplos versionados não podem depender de arquivos JSON pessoais ignorados. Confira a fonte Pascal ou evidência reconciliada antes de afirmar o contrato; relate diferenças em vez de alterar código TDD para fazer a documentação parecer correta.

Para moldes compartilhados em docs/assets/snippets, use doccodigofonte (bloco codigo-fonte). O build publica o arquivo canônico e o leitor reutiliza o terminal com cópia; não duplique o texto em outra string editável. Os modelos atuais estão em Contribuir → Moldes.

## Diagramas e build

Mantenha os Mermaids em `docs/MAPEAMENTO_AST_USES_UNITS/<slug-do-documento>/` e referencie o Markdown por bloco. Não mantenha uma segunda string Mermaid no componente. Ao atualizar dependências, confira paths, capitalização, edges e hashes do inventário a partir dos fontes; distingue uses de carga dinâmica e estado compartilhado.

Valide com `npm run check --prefix Documentacoes` e `npm run build --prefix Documentacoes`. Para desenvolver, `npm run dev --prefix Documentacoes`; para conferir o artefato, `npm run preview --prefix Documentacoes`. Use o endereço impresso pelo terminal e o prefixo `/TestesAutomatizadosERP/`. Componentes, ícones e Mermaid vêm de npm, sem CDN no runtime.

Faça verificação proporcional: página/rota, menu, busca por unit/estado/procedure, links de citação, sumário e cópia quando afetados. Ferramentas e testes temporários ficam em diretórios ignorados; não os inclua no commit. Preserve trabalho de outras sessões. Descreva o que foi validado e os limites da evidência. Publicação remota depende da autorização da sessão.

O mesmo build gera llms.txt, knowledge/index.json e Markdown por documento público. Não edite esses arquivos de saída nem mantenha um índice manual paralelo. Campos de identidade, navegação, estado/evidência e símbolos alimentam também a consulta por agentes. Uma unit nova com dados completos aparece automaticamente nos dois formatos. Para consumir conhecimento TDD, consulte a skill irmã consultar-documentacao-tdd e o guia Contribuir → Consultar com agentes de IA.
