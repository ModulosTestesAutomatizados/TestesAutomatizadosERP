import 'vuetify/styles';
import '@mdi/font/css/materialdesignicons.css';
import './styles/portal.css';

import { createApp } from 'vue';
import { createVuetify } from 'vuetify';
import { pt } from 'vuetify/locale';

import App from './App.vue';
import { temaInicial } from './components/portal/preferenciaTema.ts';
import { criarRouter } from './router.ts';

export function iniciar() {
  const app = createApp(App);
  app.use(createVuetify({
    locale: { locale: 'pt', messages: { pt } },
    theme: { defaultTheme: temaInicial(), themes: { claro: { dark: false,
      colors: { primary: '#2454C6', secondary: '#5D6475', background: '#F7F8FC', surface: '#FFFFFF', 'on-background': '#17233C', 'on-surface': '#17233C' }
    }, escuro: { dark: true, colors: { primary: '#9CB8FF', secondary: '#B3BCCD', background: '#111827', surface: '#1B2536', 'on-background': '#E5ECF7', 'on-surface': '#E5ECF7' } } } },
    defaults: { VBtn: { style: 'text-transform:none;letter-spacing:0' } }
  }));
  app.use(criarRouter());
  app.mount('#app');
}
