import { arquivoLocal,cdn } from './config.ts';

let promise: Promise<typeof window.mermaid> | undefined;
export function carregarMermaid() {
  if (!promise) promise = new Promise((pResolve, pReject) => {
    const script = document.createElement('script');
    const timer = setTimeout(() => { script.remove(); pReject(new Error('Mermaid indisponível')); }, 15000);
    script.src = cdn.mermaid;
    script.onerror = () => { clearTimeout(timer); pReject(new Error('Mermaid indisponível')); };
    script.onload = () => {
      clearTimeout(timer);
      try {
        window.mermaid.initialize({ startOnLoad: false, securityLevel: 'strict', flowchart: { htmlLabels: false }, theme: 'neutral' });
        pResolve(window.mermaid);
      } catch (error) { pReject(error); }
    };
    document.head.append(script);
  });
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
