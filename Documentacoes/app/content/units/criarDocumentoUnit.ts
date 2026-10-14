// Contrato editorial único para a documentação de UMA unit.
import type { IDadosUnit, IDocumento, ISecao, ISimbolo } from '../../models/documentacao.ts';

function nomeMetodo(pAssinatura: string): string {
  const nome = pAssinatura.match(/(?:procedure|function)\s+([A-Za-z_0-9]+)/i)?.[1];
  if (!nome) throw new Error(`Assinatura inválida: ${pAssinatura}`);
  return nome;
}

export function criarDocumentoUnit({ nome: pNome, aliases: pAliases = [], aliasesArtefatos: pAliasesArtefatos = {}, resumo: pResumo, fonte: pFonte, responsabilidade: pResponsabilidade, problema, estado: pEstado = 'em-uso', evidenciaValidacao: pEvidenciaValidacao, jsonBase: pJsonBase, navegacao: pNavegacao, estados: pEstados = [], metodos: pMetodos = [], implementacao: pImplementacao = [], dependencias: pDependencias = [], limites: pLimites = [] }: IDadosUnit): IDocumento {
  return {
    slug: pNome.toLowerCase().replace(/_/g, '-'), categoria: 'units', titulo: pNome,
    unit: pNome, aliases: pAliases, resumo: pResumo, estado: pEstado, evidenciaValidacao: pEvidenciaValidacao, navegacao: pNavegacao,
    fontes: [pFonte, ...(pJsonBase?.fontes ?? [])].map(pCaminho => ({ caminho: pCaminho })),
    simbolos: [
      ...pEstados.flatMap(([pDeclaracao]) => (pDeclaracao.replace(/:[^/]+/g, '').match(/[A-Za-z_][A-Za-z0-9_]*/g) ?? []).map<ISimbolo>(pNome => ({
        nome: pNome, tipo: 'estado', secao: 'estados', aliases: pAliasesArtefatos[pNome] ?? []
      }))),
      ...pMetodos.map<ISimbolo>(([pAssinatura]) => ({ nome: nomeMetodo(pAssinatura), tipo: 'metodo', assinatura: pAssinatura }))
    ],
    secoes: [
      { id: 'responsabilidade', titulo: 'Responsabilidade e problema resolvido', blocos: [
        { tipo: 'paragrafo', texto: pResponsabilidade }, { tipo: 'paragrafo', texto: problema }
      ] },
      ...(pJsonBase ? [{ id: 'json-base', titulo: 'JSON base do caso de teste', blocos: [
        { tipo: 'codigo', linguagem: 'json', codigo: JSON.stringify(pJsonBase.exemplo, null, 2) },
        { tipo: 'tabela', colunas: ['Objeto / campo', 'Tipo', 'Finalidade', 'Impacto no teste'], linhas: pJsonBase.campos },
        ...(pJsonBase.observacoes?.length ? [{ tipo: 'lista', itens: pJsonBase.observacoes } as const] : [])
      ] } satisfies ISecao] : []),
      { id: 'estados', titulo: 'Estados globais', blocos: pEstados.length ? [
        { tipo: 'tabela', colunas: ['Estado / tipo', 'Finalidade', 'Ciclo de vida'], linhas: pEstados }
      ] : [{ tipo: 'paragrafo', texto: 'Esta unit não declara estado global próprio. Os artefatos consumidos do contexto interpretado são descritos na implementação abaixo.' }] },
      { id: 'metodos', titulo: 'Procedures e functions', blocos: [{ tipo: 'paragrafo', texto: 'As assinaturas abaixo pertencem ao fonte referenciado. Cada entrada descreve sua responsabilidade e a forma de implementação.' }] },
      ...pMetodos.map<ISecao>(([pAssinatura, pFinalidade, pComo]) => ({
        id: nomeMetodo(pAssinatura).toLowerCase().replace(/_/g, '-'),
        titulo: nomeMetodo(pAssinatura), nivel: 3,
        blocos: [{ tipo: 'codigo', linguagem: 'pascal', codigo: pAssinatura.replace(/;+$/, '') + ';' },
          { tipo: 'paragrafo', texto: pFinalidade }, { tipo: 'paragrafo', texto: pComo }]
      })),
      { id: 'implementacao', titulo: 'Como a unit é implementada', blocos: [{ tipo: 'lista', itens: pImplementacao }] },
      { id: 'dependencias', titulo: 'Dependências e integração', blocos: [
        { tipo: 'lista', itens: pDependencias.length ? pDependencias : ['Sem cláusula uses no fonte; a integração ocorre pelo contexto interpretado.'] },
        { tipo: 'paragrafo', texto: 'Aliases locais e remotos são nomes de referência documental. O fonte vinculado é a evidência desta página; isso não comprova que a variante carregada no ERP seja idêntica.' }
      ] },
      ...(pLimites.length ? [{ id: 'limites', titulo: 'Limites e observações', blocos: [{ tipo: 'lista', itens: pLimites }] } satisfies ISecao] : [])
    ]
  };
}
