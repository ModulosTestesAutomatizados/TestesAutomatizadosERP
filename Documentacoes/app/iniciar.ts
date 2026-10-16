import 'vuetify/styles';
import '@mdi/font/css/materialdesignicons.css';
import './styles/portal.css';

import { createApp } from 'vue';
import { createVuetify } from 'vuetify';

import App from './App.vue';
import { criarRouter } from './router.ts';

export function iniciar() {
  const app = createApp(App);
  app.use(createVuetify({
    theme: { defaultTheme: 'documentacao', themes: { documentacao: { dark: false,
      colors: { primary: '#2454C6', secondary: '#5D6475', background: '#F7F8FC', surface: '#FFFFFF', 'on-background': '#17233C', 'on-surface': '#17233C' }
    } } },
    defaults: { VBtn: { style: 'text-transform:none;letter-spacing:0' } }
  }));
  app.use(criarRouter());
  app.mount('#app');
}
