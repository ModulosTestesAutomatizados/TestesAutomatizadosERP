import documentos from './content/catalogo.ts';

export function criarRouter() {
  const router = VueRouter.createRouter({
    history: VueRouter.createWebHashHistory(),
    routes: [
      { path: '/', component: () => import('./pages/HomePage.ts') },
      { path: '/:categoria(estrutura|documentos|guias|units)/:slug', component: () => import('./pages/DocumentPage.ts') },
      { path: '/:pathMatch(.*)*', component: () => import('./pages/NotFoundPage.ts') }
    ],
    scrollBehavior(pTo, pFrom, pSaved) {
      if (pSaved) return pSaved;
      if (pTo.query.secao) return false;
      return { top: 0 };
    }
  });
  router.afterEach(pTo => {
    const doc = documentos.find(pD => pD.categoria === pTo.params.categoria && pD.slug === pTo.params.slug);
    document.title = `${doc?.titulo ?? (pTo.path === '/' ? 'Documentação TDD' : 'Documentação não encontrada')} | TDD ERP`;
  });
  return router;
}
