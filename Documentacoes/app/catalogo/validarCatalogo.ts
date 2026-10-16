// Contrato compartilhado pelo portal e pelo validador de publicação.
import type { IDocumento, TCategoria, TEstado } from '../contracts/documentacao.ts';

import { GRUPOS_NAVEGACAO } from './grupos.ts';
export const categorias: TCategoria[] = ['estrutura', 'documentos', 'guias', 'units'];
export const estados: Record<TEstado, string> = { legado: 'Contrato anterior', 'em-uso': 'Em uso', 'em-desenvolvimento': 'Em desenvolvimento', 'validado-no-erp': 'Validado no ERP' };
const preenchido = (pValue: unknown): pValue is string => typeof pValue === 'string' && pValue.trim().length > 0;
export const rotaDocumento = (pDocumento: IDocumento): string => `/${pDocumento.categoria}/${pDocumento.slug}`;

export function validarCatalogo(pDocumentos: IDocumento[]): string[] {
  const erros: string[] = [], slugs = new Set<string>(), nomesUnits = new Set<string>();
  const idsGrupos = new Set<string>();
  for (const grupo of GRUPOS_NAVEGACAO) {
    if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(grupo.id) || idsGrupos.has(grupo.id) || !preenchido(grupo.titulo)) erros.push(`navegacao: grupo inválido ou duplicado: ${grupo.id}`);
    idsGrupos.add(grupo.id);
    const idsSubgrupos = new Set<string>();
    for (const sub of grupo.subgrupos ?? []) {
      if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(sub.id) || idsSubgrupos.has(sub.id) || !preenchido(sub.titulo)) erros.push(`navegacao: subgrupo inválido ou duplicado: ${grupo.id}/${sub.id}`);
      idsSubgrupos.add(sub.id);
    }
    if (grupo.subgrupoPadrao && !idsSubgrupos.has(grupo.subgrupoPadrao)) erros.push(`navegacao: subgrupo padrão inexistente: ${grupo.id}`);
  }
  if (!Array.isArray(pDocumentos)) return ['catalogo: deve ser uma lista'];
  for (const doc of pDocumentos) {
    const erro = (pCampo: string, pMensagem: string): number => erros.push(`${doc?.slug ?? '?'}: ${pCampo}: ${pMensagem}`);
    if (!doc || typeof doc !== 'object') { erro('documento', 'registro inválido'); continue; }
    for (const campo of ['slug', 'titulo', 'resumo'] as const) if (!preenchido(doc[campo])) erro(campo, 'obrigatório');
    if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(doc.slug ?? '')) erro('slug', 'use letras minúsculas, números e hífens');
    if (slugs.has(doc.slug)) erro('slug', 'duplicado');
    slugs.add(doc.slug);
    if (!categorias.includes(doc.categoria)) erro('categoria', 'desconhecida');
    if (doc.navegacao) {
      const grupo = GRUPOS_NAVEGACAO.find(pG => pG.id === doc.navegacao?.grupo);
      if (!grupo) erro('navegacao.grupo', 'registre o grupo em content/navegacao.ts');
      if (doc.navegacao.subgrupo !== undefined && !grupo?.subgrupos?.some(pS => pS.id === doc.navegacao?.subgrupo)) erro('navegacao.subgrupo', 'registre o subgrupo no grupo correspondente');
      if (doc.navegacao.ordem !== undefined && !Number.isFinite(doc.navegacao.ordem)) erro('navegacao.ordem', 'use um número finito');
    }
    if (doc.categoria === 'units' && (!preenchido(doc.unit) || doc.slug !== doc.unit.toLowerCase().replace(/_/g, '-'))) erro('unit', 'nome e slug devem seguir o padrão de units');
    if (doc.categoria === 'units' && (!/^P39_TDD_[A-Z0-9_]+$/.test(doc.unit ?? '') || doc.titulo !== doc.unit)) erro('unit', 'use o mesmo nome canônico P39_TDD_ no artefato, título e navegação');
    if (doc.categoria === 'units' && !doc.fontes?.some(pF => pF.caminho.endsWith(`/${doc.unit}.pas`))) erro('fontes', 'o arquivo Pascal deve ter o mesmo nome canônico da unit');
    if (doc.categoria === 'units') {
      if (doc.aliases !== undefined && !Array.isArray(doc.aliases)) erro('aliases', 'deve ser uma lista');
      for (const nome of [doc.unit, ...(Array.isArray(doc.aliases) ? doc.aliases : [])]) {
        if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(nome ?? '')) { erro('unit/alias', 'use identificadores de unit'); continue; }
        const chave = (nome ?? '').toUpperCase();
        if (nomesUnits.has(chave)) erro('unit/alias', `nome duplicado: ${nome}`);
        nomesUnits.add(chave);
      }
    }
    if (!Object.hasOwn(estados, doc.estado)) erro('estado', 'desconhecido');
    if (doc.estado === 'validado-no-erp') {
      for (const campo of ['data', 'versaoERP', 'referencia'] as const) if (!preenchido(doc.evidenciaValidacao?.[campo])) erro(`evidenciaValidacao.${campo}`, 'obrigatório');
    }
    if (!Array.isArray(doc.fontes)) erro('fontes', 'deve ser uma lista');
    else for (const fonte of doc.fontes) if (!preenchido(fonte?.caminho)) erro('fontes.caminho', 'obrigatório');
    if (!Array.isArray(doc.secoes) || !doc.secoes.length) { erro('secoes', 'informe ao menos uma seção'); continue; }
    const ids = new Set();
    for (const secao of doc.secoes) {
      if (!preenchido(secao.id) || ids.has(secao.id)) erro('secoes.id', 'vazio ou duplicado');
      ids.add(secao.id);
      if (!preenchido(secao.titulo)) erro('secoes.titulo', 'obrigatório');
      if (secao.nivel !== undefined && ![2, 3, 4].includes(secao.nivel)) erro('secoes.nivel', 'use 2, 3 ou 4');
      if (!Array.isArray(secao.blocos)) { erro('blocos', 'deve ser uma lista'); continue; }
      for (const bloco of secao.blocos) {
        if (!bloco || !['paragrafo', 'lista', 'tabela', 'codigo', 'aviso', 'mermaid'].includes(bloco.tipo)) { erro('blocos.tipo', 'desconhecido'); continue; }
        if ((bloco.tipo === 'paragrafo' || bloco.tipo === 'aviso') && !preenchido(bloco.texto)) erro('blocos.texto', 'obrigatório');
        if (bloco.tipo === 'aviso' && !['info', 'warning', 'error', 'success'].includes(bloco.severidade)) erro('blocos.severidade', 'desconhecida');
        if (bloco.tipo === 'codigo' && !preenchido(bloco.codigo)) erro('blocos.codigo', 'obrigatório');
        if (bloco.tipo === 'mermaid' && ('codigo' in bloco || !new RegExp(`^docs/MAPEAMENTO_AST_USES_UNITS/${doc.slug}/[A-Za-z0-9_.-]+\\.md$`).test(bloco.fonte ?? ''))) erro('blocos.mermaid', 'referencie um Markdown no subdiretório canônico do documento, sem código inline');
        if (bloco.tipo === 'lista' && (!Array.isArray(bloco.itens) || bloco.itens.some(pI => !preenchido(pI)))) erro('blocos.itens', 'lista inválida');
        if (bloco.tipo === 'tabela') {
          if (!Array.isArray(bloco.colunas) || !bloco.colunas.length) erro('blocos.colunas', 'obrigatório');
          if (!Array.isArray(bloco.linhas) || bloco.linhas.some(pL => !Array.isArray(pL) || pL.length !== bloco.colunas?.length)) erro('blocos.linhas', 'tabela irregular');
        }
      }
    }
  }
  return erros;
}
