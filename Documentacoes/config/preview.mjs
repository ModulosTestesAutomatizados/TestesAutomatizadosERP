import { createServer } from 'node:http';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('../.pages-output/', import.meta.url));
const mime = { '.js': 'text/javascript', '.css': 'text/css', '.html': 'text/html', '.md': 'text/plain', '.json': 'application/json' };
await fs.access(path.join(root, 'index.html'));
createServer(async (req, res) => {
  try {
    let relative = decodeURIComponent(new URL(req.url, 'http://localhost').pathname).replace(/^\/TestesAutomatizadosERP(?=\/)/, '');
    if (relative.endsWith('/')) relative += 'index.html';
    const target = path.resolve(root, '.' + relative);
    if (!target.startsWith(root)) { res.writeHead(403).end(); return; }
    res.setHeader('Content-Type', `${mime[path.extname(target)] ?? 'application/octet-stream'}; charset=utf-8`);
    res.end(await fs.readFile(target));
  } catch { res.writeHead(404).end('Arquivo não encontrado'); }
}).listen(8080, '127.0.0.1', () => process.stdout.write('Portal: http://127.0.0.1:8080/\n'));
