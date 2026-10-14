// Os pacotes npm fornecem tipos; a execução usa as versões CDN de config.ts.
declare const Vue: typeof import('vue');
declare const VueRouter: typeof import('vue-router');
declare const Vuetify: typeof import('vuetify');
interface Window {
  mermaid: typeof import('mermaid').default;
}
