import type { IDocumento } from '../../../contracts/documentacao.ts';

export default {
  slug: 'autoria', categoria: 'guias', titulo: 'Como escrever uma documentação',
  resumo: 'Crie páginas e grupos, documente units e mantenha componentes Vue, estados e diagramas na slice responsável.',
  estado: 'em-uso', fontes: [
    'Documentacoes/app/README.md', '.vscode/documentacao.code-snippets',
    'Documentacoes/app/contracts/documentacao.ts', 'Documentacoes/app/contracts/criarDocumentoUnit.ts',
    'Documentacoes/app/catalogo/index.ts', 'Documentacoes/app/catalogo/grupos.ts',
    'Documentacoes/app/catalogo/validarCatalogo.ts', 'Documentacoes/vite.config.ts',
    '.agents/skills/contribuir-documentacao/SKILL.md'
  ].map(pCaminho => ({ caminho: pCaminho })),
  secoes: [
    { id: 'organizacao', titulo: 'Escolha a feature responsável', blocos: [
      { tipo: 'paragrafo', texto: 'Os grupos do menu orientam a organização do conteúdo. Um documento é um módulo TypeScript de dados; um componente ou view é um arquivo .vue. Não é preciso criar uma view para cada unit.' },
      { tipo: 'lista', itens: [
        'Arquitetura: components/arquitetura/irunner/conteudo.',
        'Units: components/units/{setup,constantes,persistencia,irunner}/conteudo.',
        'Casos de teste: components/casos-de-teste/conteudo.',
        'Mapeamentos: components/mapeamentos/financeiro/conteudo.',
        'Helpers: components/helpers/{gerais,sincronizacao}/conteudo.',
        'Contribuir: components/contribuir/conteudo.',
        'Leitura: components/leitura contém o leitor, sumário, referências, terminal, tabelas e diagramas.',
        'Descoberta: components/descoberta contém busca, navegação e cards. Portal contém shell e composição de rotas.'
      ] },
      { tipo: 'paragrafo', texto: 'Os caminhos desta seção partem de Documentacoes/app. Edite conteúdo para texto, assinatura, estado, JSON ou diagrama. Crie um SFC apenas quando precisar de comportamento ou layout que os blocos existentes não atendem.' }
    ] },
    { id: 'nova-pagina', titulo: 'Criar ou modificar uma página', blocos: [
      { tipo: 'lista', itens: [
        'Abra o módulo da página na slice. Para uma nova página, use docpagina em um arquivo .ts dentro de conteudo.',
        'Defina slug, categoria, título, resumo, estado, fontes e seções. Informe navegacao com grupo/subgrupo e ordem existentes.',
        'Exporte a página uma vez no index.ts público da slice. Se criar um subgrupo físico novo, agregue seu index.ts no index da feature.',
        'O catálogo em app/catalogo/index.ts compõe os exports públicos. Ele alimenta página, menu, cards, busca e citações; não mantenha cadastros paralelos.',
        'Seções não precisam de rota: acrescente id único, título, nível e blocos no array secoes. O sumário é derivado desses dados.'
      ] },
      { tipo: 'codigo', linguagem: 'typescript', codigo: `// components/arquitetura/irunner/conteudo/novo-fluxo.ts
import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  slug: 'novo-fluxo', categoria: 'estrutura', titulo: 'Novo fluxo',
  resumo: 'Responsabilidade e limites do fluxo.', estado: 'em-desenvolvimento',
  navegacao: { grupo: 'estrutura', ordem: 1 }, fontes: [],
  secoes: [{ id: 'objetivo', titulo: 'Objetivo', blocos: [
    { tipo: 'paragrafo', texto: 'Explique o contrato e cite as units pelo nome real.' }
  ] }]
} satisfies IDocumento;` },
      { tipo: 'codigo', linguagem: 'typescript', codigo: `// No index.ts da mesma slice (arquitetura/irunner):
import novoFluxo from './conteudo/novo-fluxo.ts';
// Acrescente novoFluxo ao array exportado que já existe.` }
    ] },
    { id: 'unit', titulo: 'Documentar uma unit', blocos: [
      { tipo: 'paragrafo', texto: 'Use docunit e criarDocumentoUnit. Informe nome local real, arquivo Pascal correspondente, responsabilidade, problema, estados globais/ciclo de vida, assinaturas e efeitos, implementação, dependências e limites. O mesmo nome local é usado no título e menu. Referências remotas e aliases não renomeiam o fonte.' },
      { tipo: 'paragrafo', texto: 'A fábrica gera seções e símbolos de busca a partir de estados e metodos. Citar o nome de uma unit documentada em parágrafo, lista, tabela, código ou Mermaid cria um link para a página da unit. O texto literal do bloco continua sendo o conteúdo enviado à área de transferência.' },
      { tipo: 'aviso', severidade: 'info', texto: 'Alias é um nome de pesquisa/citação. Ele não cria redirecionamento de URL. Ao substituir uma página, registre explicitamente o destino da rota antiga e confira links internos; não reintroduza páginas que foram excluídas do mapa.' }
    ] },
    { id: 'grupos', titulo: 'Criar grupos e subgrupos', blocos: [
      { tipo: 'paragrafo', texto: 'Use docgrupo ou docsubgrupo no registro único app/catalogo/grupos.ts. Depois use docnavegacao na página. A ordem dos grupos/subgrupos vem desse registro; a ordem das páginas vem de navegacao.ordem.' },
      { tipo: 'codigo', linguagem: 'typescript', codigo: `// No registro de grupos, acrescente ao array subgrupos do dono:
{ id: 'novo-subgrupo', titulo: 'Novo subgrupo' }
// Na página correspondente:
navegacao: { grupo: 'units', subgrupo: 'novo-subgrupo', ordem: 0 }` },
      { tipo: 'paragrafo', texto: 'Registre o subgrupo antes de usá-lo; o catálogo rejeita IDs inexistentes ou duplicados. Se houver conteúdo específico, mantenha-o na pasta correspondente da feature e exporte pelo index público.' }
    ] },
    { id: 'estado', titulo: 'Atualizar o estado da documentação', blocos: [
      { tipo: 'paragrafo', texto: 'Edite o campo estado existente com docestado; não acrescente uma segunda propriedade. Cards e cabeçalho da página refletem o novo valor automaticamente.' },
      { tipo: 'tabela', colunas: ['Valor', 'Quando usar'], linhas: [
        ['em-desenvolvimento', 'Contrato ou conteúdo ainda em evolução; descreva os limites conhecidos.'],
        ['em-uso', 'Conteúdo que descreve o fluxo em uso; não equivale a homologação da execução.'],
        ['legado', 'Contrato anterior preservado e explicitamente identificado.'],
        ['validado-no-erp', 'Exige evidenciaValidacao com data, versaoERP e referencia reais para este contrato.']
      ] },
      { tipo: 'codigo', linguagem: 'typescript', codigo: `estado: 'validado-no-erp',
evidenciaValidacao: {
  data: '2026-10-16', versaoERP: 'VERSAO_REAL',
  referencia: 'URL_DO_REGISTRO_REAL_DE_HOMOLOGACAO'
}` },
      { tipo: 'aviso', severidade: 'warning', texto: 'Os valores acima são modelo a substituir. Build, teste local e evidência de uma versão anterior não permitem promover automaticamente uma página a validado-no-erp.' }
    ] },
    { id: 'json', titulo: 'JSON copiável e impacto dos campos', blocos: [
      { tipo: 'paragrafo', texto: 'Use docunitjson no documento de caso. jsonBase.exemplo é um objeto literal versionado; campos explica caminho, tipo, finalidade e impacto. A fábrica reutiliza terminal com cópia e tabela, sem componentes específicos para cada JSON.' },
      { tipo: 'paragrafo', texto: 'Registre observacoes para defaults, obrigatoriedade, valores a preencher e erros. Não referencie como fonte um JSON ignorado que só existe no computador do autor. Exemplos com IDs/valores zero devem ser identificados como modelos a preencher.' },
      { tipo: 'codigo', linguagem: 'typescript', codigo: `jsonBase: {
  exemplo: { configuracao: { codigo: 0 } },
  campos: [
    ['configuracao', 'objeto', 'Dados do caso', 'Define o contexto de entrada'],
    ['configuracao.codigo', 'número', 'Identificador a preencher', 'Zero é apenas placeholder; confira a validação do teste']
  ],
  observacoes: ['Preencha os valores conforme a massa do ambiente.']
}` }
    ] },
    { id: 'diagramas', titulo: 'Atualizar Mermaid e inventário de uses', blocos: [
      { tipo: 'paragrafo', texto: 'Salve o Markdown em docs/MAPEAMENTO_AST_USES_UNITS/<slug>/<diagrama>.md com docmermaid e referencie com docdiagrama. Esse diretório continua a fonte de verdade. Não cole uma segunda string Mermaid no componente.' },
      { tipo: 'paragrafo', texto: 'Para inventários de dependências, confira paths, declarações, linhas, hashes e edges reais. Comentários/literais Pascal não criam uses. Carga dinâmica e estados compartilhados devem ser identificados separadamente. Ao renomear um inventário, atualize seu registro e consumidores no mesmo trabalho.' }
    ] },
    { id: 'componente', titulo: 'Quando criar componente ou view Vue', blocos: [
      { tipo: 'paragrafo', texto: 'Use doccomponente em um .vue da slice. Templates usam imports locais, Composition API e TypeScript. Shared só recebe primitivas realmente genéricas; componentes que conhecem documento ou citação pertencem à leitura. A feature proprietária expõe o componente pelo index.ts quando outras features precisarem usá-lo.' },
      { tipo: 'codigo', linguagem: 'vue', codigo: `<template>
  <v-alert type="info" variant="tonal">{{ mensagem }}</v-alert>
</template>
<script setup lang="ts">
defineProps<{ mensagem: string }>();
</script>` },
      { tipo: 'paragrafo', texto: 'O leitor comum recebe um IDocumento; views especializadas são justificadas por comportamento próprio. Catálogo/validação/busca operam sobre dados tipados. Não implemente estado do ERP em stores do frontend para simular uma unit documentada.' }
    ] },
    { id: 'snippets', titulo: 'Snippets disponíveis na IDE', blocos: [
      { tipo: 'lista', itens: [
        'docpagina, docunit e docregistrounit/docregistro: documento e export público da slice.',
        'docsecao, doccodigo, doctabela, doclista e docaviso: blocos do leitor.',
        'docunitmetodo, docunitestado, docaliasartefato: assinatura e estado pesquisável.',
        'docunitjson: exemplo JSON com tabela de campos e observações. doccodigofonte lê o molde canônico de docs/assets/snippets e reutiliza o terminal copiável, sem duplicar seu conteúdo no documento.',
        'docgrupo, docsubgrupo, docnavegacao e doccaso: posicionamento no menu.',
        'docestado e docvalidacao: estado documental e evidência identificável.',
        'docmermaid e docdiagrama: fonte canônica e referência.',
        'doccomponente: SFC com script setup TypeScript. Ajuste os paths relativos nos exemplos à profundidade da pasta escolhida.'
      ] }
    ] },
    { id: 'validar', titulo: 'Desenvolver, validar e publicar', blocos: [
      { tipo: 'codigo', linguagem: 'shell', codigo: `npm ci --prefix Documentacoes
npm run dev --prefix Documentacoes
npm run check --prefix Documentacoes
npm run build --prefix Documentacoes
npm run preview --prefix Documentacoes` },
      { tipo: 'paragrafo', texto: 'Dev usa Vite com atualização automática. Preview serve o artefato compilado, não os fontes; use o endereço impresso no terminal. Confira o prefixo /TestesAutomatizadosERP/, rota direta/refresh, menu, busca por estado/procedure, citações, sumário, cópia e diagrama afetados.' },
      { tipo: 'paragrafo', texto: 'A pipeline valida PRs. Após merge na master, publica o artefato estático no Pages. Nenhum servidor Node é necessário em produção. Testes/ferramentas temporários de agentes ficam ignorados; a documentação e configurações necessárias ao build são versionadas.' }
    ] },
    { id: 'skill', titulo: 'Contribuição assistida por agente', blocos: [
      { tipo: 'paragrafo', texto: 'A skill contribuir-documentacao, em .agents/skills/contribuir-documentacao/SKILL.md, orienta a criação/manutenção de páginas, grupos e componentes conforme este guia. Ela referencia os contratos e snippets atuais do projeto e não altera as regras Pascal do ERP.' }
    ] }
  ]
} satisfies IDocumento;
