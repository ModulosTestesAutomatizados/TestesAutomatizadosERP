import type { IDocumento, IReferenciaUnit } from './contracts/documentacao.ts';

import units from './catalogo/units.ts';

export const slugUnit = (pNome: string): string => pNome.toLowerCase().replace(/_/g, '-');
const nomes = new Map<string, IDocumento>();
for (const doc of units) for (const nome of [doc.unit ?? '', ...(doc.aliases ?? [])]) {
  const normalized = nome.toUpperCase();
  if (nomes.has(normalized)) throw new Error(`Referência de unit duplicada: ${nome}`);
  nomes.set(normalized, doc);
}
export const resolverUnit = (pNome: string): IDocumento | undefined => nomes.get(pNome.toUpperCase());
export const rotaUnit = (pNome: string): string | undefined => { const doc = resolverUnit(pNome); return doc ? `/units/${doc.slug}` : undefined; };

export function partesReferencia(pTexto = ''): IReferenciaUnit[] {
  const partes: IReferenciaUnit[] = [];
  let anterior = 0;
  for (const match of String(pTexto ?? '').matchAll(/[A-Za-z_][A-Za-z0-9_]*/g)) {
    if (!resolverUnit(match[0])) continue;
    if (match.index > anterior) partes.push({ texto: pTexto.slice(anterior, match.index) });
    partes.push({ texto: match[0], unit: true });
    anterior = match.index + match[0].length;
  }
  if (anterior < String(pTexto ?? '').length) partes.push({ texto: pTexto.slice(anterior) });
  return partes;
}
