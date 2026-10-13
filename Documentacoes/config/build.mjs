import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const root = fileURLToPath(new URL('../../', import.meta.url));
const project = path.join(root, 'Documentacoes');
const output = path.join(project, '.pages-output');
const compiled = path.join(project, '.build');
// Somente diretórios fixos de saída deste projeto são limpos.
for (const target of [output, compiled]) {
  if (path.dirname(target) !== project || !['.pages-output', '.build'].includes(path.basename(target))) throw new Error('Destino de build inválido');
  await fs.rm(target, { recursive: true, force: true });
}
execFileSync(process.execPath, [path.join(project, 'node_modules/typescript/bin/tsc'), '-p', path.join(project, 'tsconfig.json')], { stdio: 'inherit' });
const { default: documents } = await import(pathToFileURL(path.join(compiled, 'content/catalogo.js')));
const { validarCatalogo } = await import(pathToFileURL(path.join(compiled, 'content/validarCatalogo.js')));
const errors = validarCatalogo(documents);
const assets = new Set(['docs/MAPEAMENTO_AST_USES_UNITS/runner/TDD_IRUNNER.ast.json']);
const inventory = JSON.parse(await fs.readFile(path.join(root, [...assets][0]), 'utf8'));
for (const node of inventory.nodes) {
  if (!node.file || !node.sha256) continue;
  const source = await fs.readFile(path.join(root, node.file));
  // Preserve os bytes do fonte; normalize apenas CRLF para LF entre Windows e Linux.
  const normalized = source.filter((byte, index) => byte !== 13 || source[index + 1] !== 10);
  const hash = createHash('sha256').update(normalized).digest('hex');
  if (hash !== node.sha256) errors.push(`Mapa de uses desatualizado para ${node.file}; revise os arquivos canônicos.`);
}
for (const doc of documents) {
  for (const source of doc.fontes) await fs.access(path.join(root, source.caminho));
  for (const section of doc.secoes) for (const block of section.blocos) {
    if (block.tipo !== 'mermaid') continue;
    assets.add(block.fonte);
    if (!/```mermaid\s*\n[\s\S]*?```/.test(await fs.readFile(path.join(root, block.fonte), 'utf8'))) errors.push(`Mermaid ausente: ${block.fonte}`);
  }
}
if (errors.length) throw new Error(errors.join('\n'));
await fs.mkdir(path.join(output, 'Documentacoes/app'), { recursive: true });
await fs.cp(compiled, path.join(output, 'Documentacoes/app'), { recursive: true });
await fs.cp(path.join(project, 'app/styles'), path.join(output, 'Documentacoes/app/styles'), { recursive: true });
await fs.cp(path.join(project, 'app/redirecionamentos'), path.join(output, 'Documentacoes/app/redirecionamentos'), { recursive: true, filter: p => !p.endsWith('.ts') });
for (const asset of assets) {
  const destination = path.resolve(output, asset);
  if (!destination.startsWith(output + path.sep)) throw new Error('Asset fora da saída');
  await fs.mkdir(path.dirname(destination), { recursive: true });
  await fs.copyFile(path.join(root, asset), destination);
}
// A entrada compilada fica no HTML: nenhum inicializador externo pode faltar.
const entry = (await fs.readFile(path.join(compiled, 'start.js'), 'utf8'))
  .replace(/(['"])\.\/(config|main)\.js\1/g, '$1./Documentacoes/app/$2.js$1');
const template = await fs.readFile(path.join(root, 'index.html'), 'utf8');
if (!template.includes('<!-- portal-entry -->')) throw new Error('Entrada do portal ausente no índice');
const index = template
  .replace(/(<div id="portal-status"[^>]*>)[\s\S]*?(<\/div>)/, '$1Carregando documentação…$2')
  .replace('<!-- portal-entry -->', () => `<script type="module">\n${entry}\n</script>`);
await fs.writeFile(path.join(output, 'index.html'), index, 'utf8');
await fs.unlink(path.join(output, 'Documentacoes/app/start.js'));
// Compatibilidade com URLs anteriores sem manter pastas editoriais na raiz.
const { REDIRECIONAMENTOS } = await import(pathToFileURL(path.join(compiled, 'redirecionamentos/manifesto.js')));
for (const item of REDIRECIONAMENTOS) {
  const destination = path.join(output, item.anterior, 'index.html');
  await fs.mkdir(path.dirname(destination), { recursive: true });
  await fs.writeFile(destination, `<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta http-equiv="refresh" content="0;url=../../index.html#${item.rota}"></head><body><a href="../../index.html#${item.rota}">Abrir documentação</a></body></html>`, 'utf8');
}
await fs.writeFile(path.join(output, '.nojekyll'), '');
process.stdout.write(`Portal compilado: ${documents.length} documentos em Documentacoes/.pages-output.\n`);
