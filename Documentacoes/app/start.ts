import { cdn } from './config.ts';

export function carregarScript(pUrl: string): Promise<void> {
  return new Promise<void>((pResolve, pReject) => {
    const script = document.createElement('script');
    const timer = setTimeout(() => { script.remove(); pReject(new Error(`Tempo excedido: ${pUrl}`)); }, 20000);
    script.src = pUrl;
    script.onload = () => { clearTimeout(timer); pResolve(); };
    script.onerror = () => { clearTimeout(timer); pReject(new Error(`Falha ao carregar: ${pUrl}`)); };
    document.head.append(script);
  });
}

try {
  for (const url of [cdn.vue, cdn.router, cdn.vuetify]) await carregarScript(url);
  const { iniciar } = await import('./main.ts');
  await iniciar();
  document.getElementById('app')?.removeAttribute('inert');
  document.getElementById('app')?.removeAttribute('aria-busy');
  document.getElementById('portal-status')?.remove();
} catch {
  const status = document.getElementById('portal-status');
  if (status) {
    status.removeAttribute('aria-label');
    status.removeAttribute('aria-busy');
    status.setAttribute('role', 'alert');
    const mensagem = document.createElement('p');
    mensagem.textContent = 'Não foi possível carregar a documentação.';
    const recarregar = document.createElement('button');
    recarregar.type = 'button';
    recarregar.textContent = 'Recarregar página';
    recarregar.addEventListener('click', () => window.location.reload());
    status.replaceChildren(mensagem, recarregar);
    recarregar.focus();
  }
}
