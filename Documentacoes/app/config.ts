export const cdn = {
  vue: 'https://cdn.jsdelivr.net/npm/vue@3.5.43/dist/vue.global.prod.js',
  router: 'https://cdn.jsdelivr.net/npm/vue-router@4.6.4/dist/vue-router.global.prod.js',
  vuetify: 'https://cdn.jsdelivr.net/npm/vuetify@4.2.3/dist/vuetify.min.js',
  mermaid: 'https://cdn.jsdelivr.net/npm/mermaid@11.17.2/dist/mermaid.min.js'
};
export const repositorio = 'https://github.com/ModulosTestesAutomatizados/TestesAutomatizadosERP/blob/master/';
// Resolvido a partir do módulo, preservando o prefixo de hospedagem e ignorando rotas hash.
export const raizSite = new URL('../../', import.meta.url);
export const arquivoLocal = (pCaminho: string): string => new URL(pCaminho, raizSite).href;
export const fonteRepositorio = (pCaminho: string): string => repositorio + pCaminho.split('/').map(encodeURIComponent).join('/');
