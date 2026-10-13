import type { IDocumento, IGrupoNavegacao } from './models/documentacao.ts';

import { rotaDocumento } from './content/validarCatalogo.ts';

// Grupos derivados do catálogo; cada documento pode escolher grupo e subgrupo.
export function criarNavegacao(pDocumentos: IDocumento[]): IGrupoNavegacao[] {
  const visiveis = pDocumentos.filter(pD => !pD.oculto);
  const categorias = [
    ['estrutura', 'Arquitetura', 'mdi-sitemap-outline'],
    ['units', 'Units', 'mdi-code-braces'],
    ['documentos', 'Referências', 'mdi-book-open-page-variant-outline'],
    ['guias', 'Contribuir', 'mdi-pencil-outline']
  ];
  const grupos: IGrupoNavegacao[] = categorias.map(([pId, pTitulo, pIcone]) => ({
    id: pId, titulo: pTitulo, icone: pIcone, documentos: visiveis.filter(pD => pD.categoria === pId && !pD.navegacao)
  }));
  grupos.splice(3, 0, { id: 'casos', titulo: 'Casos de teste', icone: 'mdi-format-list-checks', grupos: [
    { id: 'casos-legado', titulo: 'Legado', documentos: visiveis.filter(pD => pD.navegacao?.subgrupo === 'legado').sort((pA, pB) => (pA.navegacao?.ordem ?? 100) - (pB.navegacao?.ordem ?? 100)) },
    { id: 'casos-irunner', titulo: 'IRunner', documentos: visiveis.filter(pD => pD.navegacao?.subgrupo === 'irunner').sort((pA, pB) => (pA.navegacao?.ordem ?? 100) - (pB.navegacao?.ordem ?? 100)) }
  ] });
  return grupos;
}

export function gruposDaRota(pGrupos: IGrupoNavegacao[], path: string): string[] {
  for (const grupo of pGrupos) {
    if (grupo.documentos?.some(pD => rotaDocumento(pD) === path)) return [grupo.id];
    for (const filho of grupo.grupos ?? []) if (filho.documentos?.some(pD => rotaDocumento(pD) === path)) return [grupo.id, filho.id];
  }
  return [];
}
