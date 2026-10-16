// Falha pré-montagem independente de Vue.
function exibirFalha() {
  const status = document.getElementById('portal-status');
  if (!status) return;
  status.className = 'portal-boot portal-boot-error';
  status.setAttribute('role', 'alert'); status.removeAttribute('aria-busy');
  status.replaceChildren();
  const texto = document.createElement('p'); texto.textContent = 'Não foi possível carregar a documentação.';
  const botao = document.createElement('button'); botao.textContent = 'Recarregar página';
  botao.onclick = () => window.location.reload(); status.append(texto, botao); botao.focus();
}
window.addEventListener('vite:preloadError', exibirFalha);
import('./iniciar.ts').then(pModulo => pModulo.iniciar()).catch(exibirFalha);
