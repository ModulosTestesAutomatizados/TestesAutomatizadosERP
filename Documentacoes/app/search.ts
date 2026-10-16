// Índice local ponderado: título/unit/assinaturas têm maior peso que o corpo.
import type { IDocumento, IResultadoBusca, TBloco } from './contracts/documentacao.ts';
const stopwords = new Set(['a', 'o', 'as', 'os', 'de', 'do', 'da', 'dos', 'das', 'e', 'em', 'um', 'uma', 'para', 'por', 'com', 'que', 'no', 'na', 'nos', 'nas']);
export const normalizar = (pTexto: unknown): string => String(pTexto ?? '').normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
function tokens(pTexto: string): string[] {
  const palavras = normalizar(pTexto).match(/[a-z0-9_]+/g) ?? [];
  return palavras.flatMap(p => p.includes('_') ? [p, ...p.split('_')] : [p]).filter(p => p.length > 1 && !stopwords.has(p));
}
function textoBloco(pBloco: TBloco): string {
  switch (pBloco.tipo) {
    case 'paragrafo': case 'aviso': return pBloco.texto;
    case 'codigo': return pBloco.codigo;
    case 'lista': return pBloco.itens.join(' ');
    case 'tabela': return [...pBloco.colunas, ...pBloco.linhas.flat()].join(' ');
    case 'mermaid': return pBloco.titulo;
  }
}
export function criarBusca(pDocumentos: IDocumento[]): (pConsulta: string) => IResultadoBusca[] {
  const registros = pDocumentos.filter(pD => !pD.oculto).map(pDoc => {
    const simbolos = pDoc.simbolos ?? [];
    const campos: [string, number][] = [
      [pDoc.titulo, 8], [pDoc.unit ?? '', 10], [(pDoc.aliases ?? []).join(' '), 8], [pDoc.resumo, 4],
      ...simbolos.map<[string, number]>(pS => [[pS.nome, ...(pS.aliases ?? []), pS.assinatura ?? ''].join(' '), 12]),
      ...pDoc.secoes.flatMap(pSecao => [[pSecao.titulo, 4] as [string, number], ...pSecao.blocos.map<[string, number]>(pBloco => [textoBloco(pBloco), pBloco.tipo === 'codigo' ? 2 : 1])])
    ];
    const termos = new Map<string, number>();
    for (const [texto, peso] of campos) for (const palavra of tokens(texto)) termos.set(palavra, (termos.get(palavra) ?? 0) + peso);
    return { doc: pDoc, simbolos, termos, tamanho: [...termos.values()].reduce((pA, pB) => pA + pB, 0) };
  });
  const frequencia = new Map<string, number>();
  for (const r of registros) for (const termo of r.termos.keys()) frequencia.set(termo, (frequencia.get(termo) ?? 0) + 1);
  const media = registros.reduce((pA, pR) => pA + pR.tamanho, 0) / (registros.length || 1);
  return (pConsulta: string): IResultadoBusca[] => {
    const termos = [...new Set(tokens(pConsulta))];
    if (!termos.length) return [];
    const frase = normalizar(pConsulta).trim();
    return registros.map((pR): IResultadoBusca | undefined => {
      let score = 0, correspondencias = 0;
      for (const termo of termos) {
        const candidatos = pR.termos.has(termo) ? [termo] : [...pR.termos.keys()].filter(pT => termo.length >= 3 && pT.startsWith(termo));
        let melhor = 0;
        for (const palavra of candidatos) {
          const tf = pR.termos.get(palavra) ?? 0, df = frequencia.get(palavra) ?? 0;
          const idf = Math.log(1 + (registros.length - df + 0.5) / (df + 0.5));
          const peso = idf * tf * 2.2 / (tf + 1.2 * (0.25 + 0.75 * pR.tamanho / (media || 1)));
          melhor = Math.max(melhor, peso * (palavra === termo ? 1 : 0.6));
        }
        if (melhor) { score += melhor; correspondencias++; }
      }
      if (!correspondencias) return undefined;
      score *= correspondencias / termos.length;
      if (normalizar(pR.doc.titulo).includes(frase)) score += 5;
      if ([pR.doc.unit, ...(pR.doc.aliases ?? [])].some(pN => pN && normalizar(pN) === frase)) score += 12;
      const encontrados = pR.simbolos.filter(pS => [pS.nome, ...(pS.aliases ?? [])].some(pNome => {
        const n = normalizar(pNome);
        return termos.some(pTermo => n === pTermo || (pTermo.length >= 3 && n.startsWith(pTermo)));
      }));
      if (encontrados.length) score += 16 * correspondencias / termos.length;
      return { documento: pR.doc, score, simbolos: encontrados };
    }).filter((pR): pR is IResultadoBusca => pR !== undefined).sort((pA, pB) => pB.score - pA.score || pA.documento.titulo.localeCompare(pB.documento.titulo, 'pt-BR'));
  };
}
