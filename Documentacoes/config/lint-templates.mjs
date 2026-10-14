import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { ESLint } from 'eslint';
import ts from 'typescript';

// Aplica as mesmas regras Vue aos templates inline usados com as bibliotecas CDN.
const project = fileURLToPath(new URL('../', import.meta.url));
const fix = process.argv.includes('--fix');
const eslint = new ESLint({ cwd: project, overrideConfigFile: path.join(project, 'config/eslint.config.js'), fix });
const results = [];
for (const directory of ['components', 'pages']) {
  for (const name of await fs.readdir(path.join(project, 'app', directory))) {
    if (!name.endsWith('.ts')) continue;
    const file = path.join(project, 'app', directory, name);
    let content = await fs.readFile(file, 'utf8');
    const source = ts.createSourceFile(file, content, ts.ScriptTarget.Latest, true);
    const templates = [];
    function visit(pNode) {
      if (ts.isPropertyAssignment(pNode) && pNode.name.getText(source) === 'template' && ts.isNoSubstitutionTemplateLiteral(pNode.initializer)) templates.push(pNode.initializer);
      ts.forEachChild(pNode, visit);
    }
    visit(source);
    for (const template of templates.reverse()) {
      const virtual = `<template>\n${template.text}\n</template>\n`;
      const [result] = await eslint.lintText(virtual, { filePath: file.replace(/\.ts$/, '.vue') });
      const position = source.getLineAndCharacterOfPosition(template.getStart(source));
      result.filePath = file;
      for (const message of result.messages) {
        if (message.line === 2) message.column += position.character + 1;
        message.line += position.line - 1;
        if (message.endLine) message.endLine += position.line - 1;
      }
      results.push(result);
      if (fix && result.output) {
        const body = result.output.slice('<template>\n'.length, -'\n</template>\n'.length);
        content = content.slice(0, template.getStart(source)) + '`' + body.replace(/`/g, '\\`').replace(/\$\{/g, '\\${') + '`' + content.slice(template.end);
      }
    }
    if (fix) await fs.writeFile(file, content, 'utf8');
  }
}
const formatter = await eslint.loadFormatter('stylish');
const output = await formatter.format(results);
if (output) process.stdout.write(output);
if (results.some(pResult => pResult.errorCount)) process.exitCode = 1;
