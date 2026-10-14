import type { IDocumento, TBloco } from '../../models/documentacao.ts';

export function obterBlocos(pDocumento: IDocumento, pId: string): TBloco[] {
  const secao = pDocumento.secoes.find(pSecao => pSecao.id === pId);
  if (!secao) throw new Error(`Seção histórica ausente: ${pDocumento.slug}/${pId}`);
  return secao.blocos;
}
