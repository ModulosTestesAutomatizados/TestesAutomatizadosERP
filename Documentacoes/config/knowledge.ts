import type { IDocumento, TBloco } from '../app/contracts/documentacao.ts';

import { createHash } from 'node:crypto';

import { criarReferenciasUnits } from '../app/catalogo/referencias.ts';
import { contextoDocumento, criarNavegacao, navegacaoDocumento } from '../app/components/descoberta/navigation.ts';
import { fonteRepositorio } from '../app/config.ts';
import { estados, rotaDocumento } from '../app/contracts/identidade.ts';

const escapar = (pTexto: string): string => pTexto.replace(/[\\`*_[\]<>|]/g, '\\$&');
const link = (pTitulo: string, pUrl: string): string => `[${escapar(pTitulo)}](<${pUrl}>)`;
const caminhoMarkdown = (pDoc: IDocumento): string => `knowledge/${pDoc.categoria}/${pDoc.slug}.md`;

// A cerca cresce quando o código contém backticks; o conteúdo copiável permanece literal.
function codigo(pTexto: string, pLinguagem = 'texto'): string {
  const maior = Math.max(0, ...[...pTexto.matchAll(/`+/g)].map(pMatch => pMatch[0].length));
  const cerca = '`'.repeat(Math.max(3, maior + 1));
  const linguagem = /^[a-zA-Z0-9_-]+$/.test(pLinguagem) ? pLinguagem : 'texto';
  return `${cerca}${linguagem}\n${pTexto}${pTexto.endsWith('\n') ? '' : '\n'}${cerca}`;
}

// Projeta o catálogo já validado; somente assets explicitamente preparados entram na exportação.
export function gerarConhecimento(pDocumentos: IDocumento[], pAssets: Map<string, Buffer>, pBase: string): Map<string, Buffer> {
  const documentos = pDocumentos.filter(pDoc => !pDoc.oculto);
  const refs = criarReferenciasUnits(documentos);
  const markdownUrl = (pDoc: IDocumento) => pBase + caminhoMarkdown(pDoc);
  const paginaUrl = (pDoc: IDocumento) => pBase + '#' + rotaDocumento(pDoc);
  const ancora = (pDoc: IDocumento, pSecao?: string) => pSecao ? `#${pDoc.slug}-${pSecao}` : '';
  const texto = (pTexto: string): string => refs.partesReferencia(pTexto).map(pParte => {
    const destino = pParte.unit ? refs.resolverUnit(pParte.texto) : undefined;
    return destino ? link(pParte.texto, markdownUrl(destino)) : escapar(pParte.texto);
  }).join('');
  const lerAsset = (pFonte: string): string => {
    const bytes = pAssets.get(pFonte);
    if (!bytes) throw new Error(`Asset canônico ausente na exportação: ${pFonte}`);
    return bytes.toString('utf8');
  };
  function bloco(pBloco: TBloco): string {
    switch (pBloco.tipo) {
      case 'paragrafo': return texto(pBloco.texto);
      case 'lista': return pBloco.itens.map(pItem => `- ${texto(pItem).replace(/\n/g, '\n  ')}`).join('\n');
      case 'aviso': return `> **Aviso (${pBloco.severidade}):** ${texto(pBloco.texto).replace(/\n/g, '\n> ')}`;
      case 'tabela': {
        const linha = (pValores: string[]) => `| ${pValores.map(pValor => texto(pValor).replace(/\r?\n/g, '<br>')).join(' | ')} |`;
        return [linha(pBloco.colunas), `| ${pBloco.colunas.map(() => '---').join(' | ')} |`, ...pBloco.linhas.map(linha)].join('\n');
      }
      case 'codigo': return codigo(pBloco.codigo, pBloco.linguagem);
      case 'codigo-fonte': return `${link('Molde canônico', pBase + pBloco.fonte)}\n\n${codigo(lerAsset(pBloco.fonte), pBloco.linguagem)}`;
      case 'mermaid': {
        const match = lerAsset(pBloco.fonte).match(/```mermaid\s*\n([\s\S]*?)```/);
        if (!match) throw new Error(`Mermaid ausente na exportação: ${pBloco.fonte}`);
        return `**${escapar(pBloco.titulo)}**\n\n${link('Diagrama canônico', pBase + pBloco.fonte)}\n\n${codigo(match[1], 'mermaid')}`;
      }
    }
  }
  const output = new Map<string, Buffer>();
  const registros = documentos.map(pDoc => {
    const markdown = [
      `# ${escapar(pDoc.titulo)}`, texto(pDoc.resumo),
      `**Estado:** ${estados[pDoc.estado]} (${pDoc.estado}).`,
      `**Grupo:** ${escapar(contextoDocumento(pDoc))}.`,
      link('Abrir no portal', paginaUrl(pDoc)),
      ...(pDoc.unit ? [`**Unit:** ${escapar(pDoc.unit)}.`] : []),
      ...(pDoc.aliases?.length ? [`**Aliases de consulta:** ${pDoc.aliases.map(escapar).join(', ')}.`] : []),
      ...(pDoc.evidenciaValidacao ? [`**Evidência ERP:** ${escapar(pDoc.evidenciaValidacao.data)}, versão ${escapar(pDoc.evidenciaValidacao.versaoERP)}; ${escapar(pDoc.evidenciaValidacao.referencia)}.`] : []),
      'Conteúdo derivado do catálogo do portal. O estado documental e as limitações da página devem acompanhar qualquer conclusão sobre execução no ERP.',
      ...pDoc.secoes.flatMap(pSecao => [
        `<a id="${pDoc.slug}-${pSecao.id}"></a>`,
        `${'#'.repeat(pSecao.nivel ?? 2)} ${texto(pSecao.titulo)}`,
        ...pSecao.blocos.map(bloco)
      ]),
      '## Fontes e evidências', ...pDoc.fontes.map(pFonte => `- ${link(pFonte.caminho, fonteRepositorio(pFonte.caminho))}`)
    ].join('\n\n') + '\n';
    output.set(caminhoMarkdown(pDoc), Buffer.from(markdown));
    return {
      id: rotaDocumento(pDoc), titulo: pDoc.titulo, resumo: pDoc.resumo, unit: pDoc.unit,
      tipoArtefato: pDoc.tipoArtefato, aliases: pDoc.aliases ?? [], estado: pDoc.estado,
      evidenciaValidacao: pDoc.evidenciaValidacao,
      navegacao: { ...navegacaoDocumento(pDoc), contexto: contextoDocumento(pDoc) },
      pagina: paginaUrl(pDoc), markdown: markdownUrl(pDoc),
      simbolos: (pDoc.simbolos ?? []).map(pSimbolo => ({ ...pSimbolo,
        markdown: markdownUrl(pDoc) + ancora(pDoc, pSimbolo.secao),
        pagina: paginaUrl(pDoc) + (pSimbolo.secao ? `?secao=${encodeURIComponent(pSimbolo.secao)}` : '')
      })),
      fontes: pDoc.fontes.map(pFonte => ({ caminho: pFonte.caminho, url: fonteRepositorio(pFonte.caminho) }))
    };
  });
  const inventarios = [...pAssets.keys()].filter(pCaminho => pCaminho.endsWith('.ast.json')).sort();
  const listas: string[] = [];
  function listar(pGrupos: ReturnType<typeof criarNavegacao>, pPai = ''): void {
    for (const grupo of pGrupos) {
      const titulo = pPai ? `${pPai} / ${grupo.titulo}` : grupo.titulo;
      if (grupo.documentos?.length) listas.push(`## ${escapar(titulo)}\n\n` + grupo.documentos.map(pDoc =>
        `- ${link(pDoc.titulo, markdownUrl(pDoc))}: ${escapar(pDoc.resumo.replace(/\r?\n/g, ' '))} (${estados[pDoc.estado]}).`).join('\n'));
      if (grupo.grupos) listar(grupo.grupos, titulo);
    }
  }
  listar(criarNavegacao(documentos));
  output.set('llms.txt', Buffer.from([
    '# Documentação TDD ERP', '> Contratos, fluxos, units e moldes dos testes automatizados do ERP.',
    'Consulte apenas as páginas relevantes. O índice contém nomes reais, aliases, estados globais e assinaturas. Cite a página e sua fonte; preserve o estado de validação e as limitações. Exemplos com valores a preencher não comprovam execução no ERP.',
    `## Índice estruturado\n\n- ${link('Índice JSON de documentos e símbolos', pBase + 'knowledge/index.json')}: schemaVersion e contentVersion identificam o formato e a revisão do conteúdo.`,
    ...listas,
    ...(inventarios.length ? ['## Inventários de dependências\n\n' + inventarios.map(pCaminho => `- ${link(pCaminho, pBase + pCaminho)}: uses, origens locais e referências não resolvidas.`).join('\n')] : [])
  ].join('\n\n') + '\n'));
  const hash = createHash('sha256').update(JSON.stringify({ schemaVersion: 1, documentos: registros }));
  for (const caminho of [...output.keys(), ...inventarios].sort()) {
    hash.update(caminho).update('\0').update((output.get(caminho) ?? pAssets.get(caminho))!.toString('utf8').replace(/\r\n/g, '\n')).update('\0');
  }
  const index = { schemaVersion: 1, contentVersion: hash.digest('hex'), documentos: registros,
    inventarios: inventarios.map(pCaminho => ({ caminho: pCaminho, url: pBase + pCaminho })) };
  output.set('knowledge/index.json', Buffer.from(JSON.stringify(index, null, 2) + '\n'));
  return output;
}
