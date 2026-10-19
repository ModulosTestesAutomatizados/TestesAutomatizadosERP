import { arquivoLocal } from '../../config.ts';
let sequence = 0;
let promise: Promise<typeof import('mermaid').default> | undefined;
export const proximoDiagrama = (): string => `tdd-diagram-${++sequence}`;
export function carregarMermaid() {
  if (!promise) promise = import('mermaid').then(pModulo => {
    pModulo.default.initialize({ startOnLoad: false, securityLevel: 'strict', flowchart: { htmlLabels: false }, theme: 'neutral' });
    return pModulo.default;
  }).catch(pErro => { promise = undefined; throw pErro; });
  return promise;
}
export async function lerDiagrama(pFonte: string): Promise<string> {
  const response = await fetch(arquivoLocal(pFonte));
  if (!response.ok) throw new Error(`Fonte indisponível: ${pFonte}`);
  const markdown = await response.text();
  const match = markdown.match(/```mermaid\s*\n([\s\S]*?)```/);
  if (!match) throw new Error('Bloco Mermaid ausente');
  return match[1].trim();
}
