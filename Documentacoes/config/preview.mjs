import { createServer } from 'node:http';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('../.pages-output/', import.meta.url));
const mime = { '.js': 'text/javascript', '.css': 'text/css', '.html': 'text/html', '.md': 'text/plain', '.json': 'application/json' };
await fs.access(path.join(root, 'index.html'));
const server = createServer(async (req, res) => {
  try {
    let relative = decodeURIComponent(new URL(req.url, 'http://localhost').pathname).replace(/^\/TestesAutomatizadosERP(?=\/)/, '');
    if (relative.endsWith('/')) relative += 'index.html';
    const target = path.resolve(root, '.' + relative);
    if (!target.startsWith(root)) { res.writeHead(403).end(); return; }
    res.setHeader('Content-Type', `${mime[path.extname(target)] ?? 'application/octet-stream'}; charset=utf-8`);
    res.end(await fs.readFile(target));
  } catch { res.writeHead(404).end('Arquivo não encontrado'); }
});

const configuredPort = process.env.PORT;
const port = configuredPort === undefined ? 8080 : Number(configuredPort);
if (!Number.isInteger(port) || port < 0 || port > 65535 || configuredPort === '') {
  process.stderr.write('PORT deve ser um número inteiro entre 0 e 65535.\n');
  process.exit(1);
}

function listen(port) {
  return new Promise((resolve, reject) => {
    const onError = error => { server.off('listening', onListening); reject(error); };
    const onListening = () => { server.off('error', onError); resolve(); };
    server.once('error', onError);
    server.once('listening', onListening);
    server.listen(port, '127.0.0.1');
  });
}

try {
  try {
    await listen(port);
  } catch (error) {
    if (error.code !== 'EADDRINUSE' || configuredPort !== undefined) throw error;
    process.stdout.write('A porta 8080 está ocupada; selecionando uma porta livre.\n');
    await listen(0);
  }
  const address = server.address();
  process.stdout.write(`Portal: http://127.0.0.1:${address.port}/TestesAutomatizadosERP/\n`);
} catch (error) {
  process.stderr.write(`Não foi possível abrir o preview na porta ${port}: ${error.code ?? error.message}.\n`);
  if (error.code === 'EADDRINUSE') process.stderr.write('Escolha outra porta com PORT ou remova essa configuração para usar uma porta livre automaticamente.\n');
  process.exit(1);
}
