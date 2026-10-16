import { createRouter, createWebHashHistory } from 'vue-router';

import documentos from './catalogo/index.ts';
export function criarRouter() {
  const router = createRouter({
    history: createWebHashHistory(import.meta.env.BASE_URL),
    routes: [
      { path: '/', component: () => import('./components/portal/HomeView.vue') },
      ...documentos.map(pDoc => ({ path: `/${pDoc.categoria}/${pDoc.slug}`, component: () => import('./components/portal/DocumentRoute.vue') })),
      { path: '/:pathMatch(.*)*', component: () => import('./components/portal/NotFoundView.vue') }
    ],
    scrollBehavior(pTo, pFrom, pSaved) { if (pSaved) return pSaved; if (pTo.query.secao) return false; return { top: 0 }; }
  });
  router.afterEach(pTo => {
    const doc = documentos.find(pD => `/${pD.categoria}/${pD.slug}` === pTo.path);
    document.title = `${doc?.titulo ?? (pTo.path === '/' ? 'Documentação TDD' : 'Documentação não encontrada')} | TDD ERP`;
  });
  return router;
}
