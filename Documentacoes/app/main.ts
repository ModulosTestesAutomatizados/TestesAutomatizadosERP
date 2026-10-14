import AppLayout from './components/AppLayout.ts';
import documentos from './content/catalogo.ts';
import { validarCatalogo } from './content/validarCatalogo.ts';
import { criarRouter } from './router.ts';

export async function iniciar() {
  const erros = validarCatalogo(documentos);
  if (erros.length) throw new Error(erros.join('\n'));
  const carregando = Vue.ref(true), bloqueado = Vue.ref(true), falha = Vue.ref(false);
  let finalizar: () => void;
  const finalizado = new Promise<void>(pResolve => { finalizar = pResolve; });
  const app = Vue.createApp({ render: () => Vue.h(AppLayout, { carregando: carregando.value, bloqueado: bloqueado.value, falha: falha.value, onPronto: () => finalizar() }) });
  const router = criarRouter();
  app.use(Vuetify.createVuetify({ theme: { defaultTheme: 'documentacao', themes: { documentacao: { dark: false,
    colors: { primary: '#2454C6', secondary: '#5D6475', background: '#F7F8FC', surface: '#FFFFFF', 'on-background': '#17233C', 'on-surface': '#17233C' } } } },
    defaults: { VBtn: { style: 'text-transform:none;letter-spacing:0' } } }));
  app.use(router);
  app.mount('#app');
  await Vue.nextTick();
  document.getElementById('app')?.removeAttribute('inert');
  document.getElementById('portal-status')?.remove();
  const inicio = performance.now();
  try {
    await router.isReady();
    await Vue.nextTick();
    await new Promise<void>(pResolve => setTimeout(pResolve, Math.max(0, 650 - (performance.now() - inicio))));
    carregando.value = false;
    await finalizado;
    bloqueado.value = false;
    await Vue.nextTick();
  } catch (error) {
    falha.value = true;
    await Vue.nextTick();
    throw error;
  }
}
