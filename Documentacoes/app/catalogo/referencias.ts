import type { IDocumento, IReferenciaUnit } from '../contracts/documentacao.ts';
import type { IReferenciasUnits } from '../contracts/referencias.ts';

import { rotaDocumento } from '../contracts/identidade.ts';

// Projeção pura: mesmo catálogo para nomes reais, aliases e destinos.
export function criarReferenciasUnits(pDocumentos: IDocumento[]): IReferenciasUnits {
  const nomes = new Map<string, IDocumento>();
  for (const doc of pDocumentos.filter(pDoc => !!pDoc.unit)) for (const nome of [doc.unit ?? '', ...(doc.aliases ?? [])]) {
    if (nomes.has(nome.toUpperCase())) throw new Error(`Referência de unit duplicada: ${nome}`);
    nomes.set(nome.toUpperCase(), doc);
  }
  const resolverUnit = (pNome: string) => nomes.get(pNome.toUpperCase());
  const rotaUnit = (pNome: string) => { const doc = resolverUnit(pNome); return doc ? rotaDocumento(doc) : undefined; };
  function partesReferencia(pTexto = ''): IReferenciaUnit[] {
    const partes: IReferenciaUnit[] = [];
    let anterior = 0;
    for (const match of pTexto.matchAll(/[A-Za-z_][A-Za-z0-9_]*/g)) {
      if (!resolverUnit(match[0])) continue;
      if (match.index > anterior) partes.push({ texto: pTexto.slice(anterior, match.index) });
      partes.push({ texto: match[0], unit: true });
      anterior = match.index + match[0].length;
    }
    if (anterior < pTexto.length) partes.push({ texto: pTexto.slice(anterior) });
    return partes;
  }
  return { resolverUnit, rotaUnit, partesReferencia };
}
