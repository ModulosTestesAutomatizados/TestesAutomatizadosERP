import type { IDocumento } from '../../../contracts/documentacao.ts';

export default {
  slug: 'agentes', categoria: 'guias', titulo: 'Consultar com agentes de IA',
  resumo: 'Conhecimento TDD em Markdown e JSON, gerado do mesmo catálogo para consultas por agentes.',
  estado: 'em-uso', navegacao: { grupo: 'guias', ordem: 2 },
  fontes: [
    { caminho: '.agents/skills/consultar-documentacao-tdd/SKILL.md' },
    { caminho: 'Documentacoes/config/knowledge.ts' }
  ],
  secoes: [
    { id: 'acesso', titulo: 'Arquivos estáticos para consulta', blocos: [
      { tipo: 'paragrafo', texto: 'O build gera llms.txt, knowledge/index.json e um Markdown para cada documento público. Todos vêm do mesmo catálogo usado pelo portal; uma página nova aparece na exportação ao ser registrada. Nenhum conteúdo gerado deve ser editado manualmente.' },
      { tipo: 'codigo', linguagem: 'texto', codigo: `https://modulostestesautomatizados.github.io/TestesAutomatizadosERP/llms.txt
https://modulostestesautomatizados.github.io/TestesAutomatizadosERP/knowledge/index.json` },
      { tipo: 'paragrafo', texto: 'Esses endereços ficam disponíveis após publicar o build que contém a exportação. Localmente, execute npm run build --prefix Documentacoes e npm run preview --prefix Documentacoes; use o endereço impresso seguido de llms.txt ou knowledge/index.json. Não é necessário renderizar Vue para ler esses arquivos.' }
    ] },
    { id: 'indice', titulo: 'Encontrar units, estados e métodos', blocos: [
      { tipo: 'tabela', colunas: ['Campo do índice', 'Uso na consulta'], linhas: [
        ['schemaVersion', 'Versão do formato JSON; atualmente 1.'],
        ['contentVersion', 'Hash do conteúdo exportado, com CRLF/LF equivalentes. Identifica mudanças na revisão consultada; não é a versão do ERP.'],
        ['documentos[].unit, titulo, aliases', 'Localizar a unit pelo nome real ou por nomes de consulta anteriores.'],
        ['documentos[].simbolos', 'Consultar estados globais (tipo estado), métodos (tipo metodo), assinaturas e aliases, com links de seção.'],
        ['documentos[].navegacao', 'Identificar grupo/subgrupo e contexto editorial.'],
        ['documentos[].markdown, pagina, fontes', 'Ler o texto estático, abrir o portal e conferir o código de origem.'],
        ['documentos[].estado, evidenciaValidacao', 'Preservar o estado documental e conferir o escopo de qualquer evidência ERP.'],
        ['inventarios', 'Seguir os inventários canônicos de uses; distinguir origens locais de referências não resolvidas.']
      ] },
      { tipo: 'paragrafo', texto: 'Para FCDSCasosTestes, consulte também aliases de símbolos para chegar a P39_TDD_CASOS_DE_TESTE. Para RegistrarLog e FModoDebug, leia TDD_RUN_LOGS e suas limitações. Um fluxo pode citar um estado sem ser seu proprietário.' }
    ] },
    { id: 'skill', titulo: 'Skill de consulta e exemplo de pedido', blocos: [
      { tipo: 'paragrafo', texto: 'A skill consultar-documentacao-tdd está em .agents/skills/consultar-documentacao-tdd/SKILL.md. Ela orienta consulta local ou publicada, seleção por símbolo, leitura de dependências e citação de evidências. Para editar o portal, use contribuir-documentacao. Cada ferramenta de IA precisa ser configurada para carregar a skill ou receber o endereço do índice na tarefa.' },
      { tipo: 'codigo', linguagem: 'texto', codigo: `Consulte o llms.txt da documentação TDD e seu índice JSON.
Localize a unit proprietária de FModoDebug e a assinatura de RegistrarLog.
Leia o Markdown correspondente e explique quando a mensagem é armazenada e exibida.
Cite a seção, o fonte e as limitações documentadas; informe o estado de validação e a contentVersion consultada.` },
      { tipo: 'aviso', severidade: 'info', texto: 'A exportação oferece contexto consultável durante a tarefa. A descoberta automática de llms.txt e a instalação de skills dependem da ferramenta utilizada; fornecer o endereço explicitamente torna o ponto de partida claro.' }
    ] },
    { id: 'manutencao', titulo: 'Atualização e limites da evidência', blocos: [
      { tipo: 'paragrafo', texto: 'Atualize a página na slice proprietária, os arquivos canônicos e a evidência quando aplicável. O build valida essas fontes antes de gerar Markdown/JSON. Blocos de código permanecem literais; citações textuais apontam para o Markdown da unit. Documentos ocultos ficam fora da exportação.' },
      { tipo: 'aviso', severidade: 'warning', texto: 'Em uso e Em desenvolvimento não certificam execução no ERP. Confira data, versão e referência de validação e as limitações da página. Uma cópia local ou exportação salva pode estar desatualizada em relação ao código ou ao site publicado.' }
    ] }
  ]
} satisfies IDocumento;
