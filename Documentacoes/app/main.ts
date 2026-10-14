import AppLayout from './components/AppLayout.ts';
import documentos from './content/catalogo.ts';
import { validarCatalogo } from './content/validarCatalogo.ts';
import { criarRouter } from './router.ts';

export async function iniciar() {
  const erros = validarCatalogo(documentos);
  if (erros.length) throw new Error(erros.join('\n'));
  const app = Vue.createApp(AppLayout);
  const router = criarRouter();
  app.use(Vuetify.createVuetify({ theme: { defaultTheme: 'documentacao', themes: { documentacao: { dark: false,
    colors: { primary: '#2454C6', secondary: '#5D6475', background: '#F7F8FC', surface: '#FFFFFF', 'on-background': '#17233C', 'on-surface': '#17233C' } } } },
    defaults: { VBtn: { style: 'text-transform:none;letter-spacing:0' } } }));
  app.use(router);
  await router.isReady();
  app.mount('#app');
}
