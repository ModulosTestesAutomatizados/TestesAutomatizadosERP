import type { IDocumento } from '../app/contracts/documentacao.ts';
import type { Plugin } from 'vite';

import { createHash } from 'node:crypto';
import fs from 'node:fs/promises';
import path from 'node:path';

import documentos from '../app/catalogo/index.ts';
import { validarCatalogo } from '../app/catalogo/validarCatalogo.ts';
import { gerarConhecimento } from './knowledge.ts';

interface INoInventario { file?: string; sha256?: string }
export const inventarios = [
  'docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_RUN_IRUNNER.ast.json',
  'docs/MAPEAMENTO_AST_USES_UNITS/p39-tdd-registrar-caso-teste/sincronizacao.ast.json'
];

// Lê o caminho por segmentos para detectar capitalização divergente também no Windows.
async function lerArquivo(pRoot: string, pCaminho: string): Promise<Buffer> {
  if (pCaminho.includes('\\') || pCaminho.split('/').some(pParte => !pParte || pParte === '.' || pParte === '..') || path.isAbsolute(pCaminho)) throw new Error(`Caminho editorial inválido: ${pCaminho}`);
  let atual = pRoot;
  for (const parte of pCaminho.split('/')) {
    const entradas = await fs.readdir(atual);
    if (!entradas.includes(parte)) throw new Error(`Fonte ausente ou capitalização incorreta: ${pCaminho}`);
    atual = path.join(atual, parte);
  }
  return fs.readFile(atual);
}

export async function prepararAssets(pRoot: string, pDocumentos: IDocumento[] = documentos) {
  const erros = validarCatalogo(pDocumentos);
  if (erros.length) throw new Error(erros.join('\n'));
  const assets = new Map<string, Buffer>();
  for (const documento of pDocumentos) {
    for (const fonte of documento.fontes) await lerArquivo(pRoot, fonte.caminho);
    for (const secao of documento.secoes) for (const bloco of secao.blocos) {
      if (bloco.tipo === 'codigo-fonte') {
        const conteudo = await lerArquivo(pRoot, bloco.fonte);
        if (bloco.fonte.endsWith('.json')) JSON.parse(conteudo.toString('utf8'));
        assets.set(bloco.fonte, conteudo);
        continue;
      }
      if (bloco.tipo !== 'mermaid') continue;
      const markdown = await lerArquivo(pRoot, bloco.fonte);
      if (!/```mermaid\s*\n[\s\S]*?```/.test(markdown.toString('utf8'))) throw new Error(`Mermaid ausente: ${bloco.fonte}`);
      assets.set(bloco.fonte, markdown);
    }
  }
  for (const inventario of inventarios) {
    const bytes = await lerArquivo(pRoot, inventario);
    const mapa = JSON.parse(bytes.toString('utf8')) as { nodes: INoInventario[] };
    for (const node of mapa.nodes) {
      if (!node.file || !node.sha256) continue;
      const fonte = await lerArquivo(pRoot, node.file);
      // Mantém os bytes originais do Pascal, normalizando somente CRLF para LF.
      const normalizado = fonte.filter((pByte, pIndex) => pByte !== 13 || fonte[pIndex + 1] !== 10);
      const hash = createHash('sha256').update(normalizado).digest('hex');
      if (hash !== node.sha256) throw new Error(`Mapa de uses desatualizado: ${node.file}`);
    }
    assets.set(inventario, bytes);
  }
  return assets;
}

export function portalAssets(pRoot: string): Plugin {
  let assets = new Map<string, Buffer>();
  let base = '/';
  return {
    name: 'portal-documentacao-assets',
    configResolved(pConfig) { base = pConfig.base; },
    async buildStart() {
      assets = await prepararAssets(pRoot);
      const conhecimento = gerarConhecimento(documentos, assets, base);
      for (const [caminho, conteudo] of conhecimento) assets.set(caminho, conteudo);
    },
    configureServer(pServer) {
      pServer.middlewares.use(async (pRequest, pResponse, pNext) => {
        const url = new URL(pRequest.url ?? '/', 'http://localhost');
        const caminho = url.pathname.startsWith(base) ? url.pathname.slice(base.length) : url.pathname.replace(/^\//, '');
        if (!assets.has(caminho)) return pNext();
        try {
          const gerado = caminho === 'llms.txt' || caminho.startsWith('knowledge/');
          const conteudo = gerado ? assets.get(caminho)! : await lerArquivo(pRoot, caminho);
          const tipo = caminho.endsWith('.json') ? 'application/json' : caminho.endsWith('.md') ? 'text/markdown' : 'text/plain';
          pResponse.setHeader('Content-Type', `${tipo}; charset=utf-8`);
          pResponse.end(conteudo);
        } catch {
          pResponse.statusCode = 404; pResponse.end('Fonte indisponível');
        }
      });
    },
    generateBundle() {
      for (const [fileName, source] of assets) this.emitFile({ type: 'asset', fileName, source });
      this.emitFile({ type: 'asset', fileName: '.nojekyll', source: '' });
    }
  };
}
