import type { IDocumento, IGrupoNavegacao, INavegacaoDocumento } from '../../contracts/documentacao.ts';

import { GRUPOS_NAVEGACAO } from '../../catalogo/grupos.ts';
import { rotaDocumento } from '../../contracts/identidade.ts';

export function navegacaoDocumento(pDocumento: IDocumento): INavegacaoDocumento {
  if (pDocumento.navegacao) return pDocumento.navegacao;
  const grupo = GRUPOS_NAVEGACAO.find(pG => pG.categoria === pDocumento.categoria);
  return { grupo: grupo?.id ?? pDocumento.categoria, subgrupo: grupo?.subgrupoPadrao };
}

// Contexto legível compartilhado pelos cards; não altera nomes nem rotas.
export function contextoDocumento(pDocumento: IDocumento): string {
  const nav = navegacaoDocumento(pDocumento);
  const grupo = GRUPOS_NAVEGACAO.find(pG => pG.id === nav.grupo);
  const subgrupo = grupo?.subgrupos?.find(pS => pS.id === nav.subgrupo);
  return [grupo?.titulo, subgrupo?.titulo].filter(Boolean).join(' / ');
}

// O registro central define os grupos; as páginas mantêm as rotas originais.
export function criarNavegacao(pDocumentos: IDocumento[]): IGrupoNavegacao[] {
  const visiveis = pDocumentos.filter(pD => !pD.oculto);
  const documentos = (pGrupo: string, pSubgrupo?: string) => visiveis.filter(pD => {
    const nav = navegacaoDocumento(pD);
    return nav.grupo === pGrupo && nav.subgrupo === pSubgrupo;
  }).sort((pA, pB) => (pA.navegacao?.ordem ?? 100) - (pB.navegacao?.ordem ?? 100));
  return GRUPOS_NAVEGACAO.map(pGrupo => ({
    id: pGrupo.id, titulo: pGrupo.titulo, icone: pGrupo.icone,
    documentos: documentos(pGrupo.id),
    grupos: pGrupo.subgrupos?.map(pSub => ({
      id: `${pGrupo.id}-${pSub.id}`, titulo: pSub.titulo, vazio: pSub.vazio,
      documentos: documentos(pGrupo.id, pSub.id)
    }))
  }));
}

export function gruposDaRota(pGrupos: IGrupoNavegacao[], pPath: string): string[] {
  for (const grupo of pGrupos) {
    if (grupo.documentos?.some(pD => rotaDocumento(pD) === pPath)) return [grupo.id];
    const caminho = gruposDaRota(grupo.grupos ?? [], pPath);
    if (caminho.length) return [grupo.id, ...caminho];
  }
  return [];
}
