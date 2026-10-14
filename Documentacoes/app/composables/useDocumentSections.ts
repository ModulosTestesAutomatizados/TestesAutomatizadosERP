// Destaque da seção em leitura e navegação por links compartilháveis.
import type { IDocumento } from '../models/documentacao.ts';
import type { ComputedRef } from 'vue';
export function useDocumentSections(pDocumento: ComputedRef<IDocumento | undefined>) {
  const route = VueRouter.useRoute();
  const ativa = Vue.ref('');
  let frame: number | undefined;
  function atualizar() {
    if (!pDocumento.value) return;
    const secoes = pDocumento.value.secoes;
    let atual: string | undefined = secoes[0]?.id;
    for (const secao of secoes) {
      const element = document.getElementById(`${pDocumento.value.slug}-${secao.id}`);
      if (element && element.getBoundingClientRect().top <= 150) atual = secao.id;
    }
    if (window.scrollY + window.innerHeight >= document.documentElement.scrollHeight - 2) atual = secoes.at(-1)?.id;
    ativa.value = atual ?? '';
  }
  function aoRolar() { if (!frame) frame = requestAnimationFrame(() => { frame = undefined; atualizar(); }); }
  async function irParaSecao() {
    await Vue.nextTick();
    const secao = pDocumento.value?.secoes.find(pS => pS.id === route.query.secao);
    if (secao) {
      ativa.value = secao.id;
      document.getElementById(`${pDocumento.value?.slug}-${secao.id}`)?.scrollIntoView({ block: 'start', behavior: matchMedia('(prefers-reduced-motion: reduce)').matches ? 'instant' : 'smooth' });
    } else atualizar();
  }
  Vue.watch(() => route.query.secao, irParaSecao, { flush: 'post' });
  Vue.onMounted(() => { window.addEventListener('scroll', aoRolar, { passive: true }); irParaSecao(); });
  Vue.onBeforeUnmount(() => { window.removeEventListener('scroll', aoRolar); if (frame) cancelAnimationFrame(frame); });
  return { ativa };
}
