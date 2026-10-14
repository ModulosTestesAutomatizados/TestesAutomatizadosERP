import { carregarMermaid, lerDiagrama } from '../diagrams.ts';
import { partesReferencia, rotaUnit } from '../unitReferences.ts';
import CodeBlock from './CodeBlock.ts';
let sequence = 0;

function vincularUnits(pRoot: Element): void {
  for (const node of pRoot.querySelectorAll('.node')) {
    const nome = partesReferencia(node.textContent ?? '').find(p => p.unit)?.texto;
    if (!nome || node.closest('a')) continue;
    const link = document.createElementNS('http://www.w3.org/2000/svg', 'a');
    link.setAttribute('href', '#' + rotaUnit(nome));
    link.setAttribute('aria-label', `Documentação de ${nome}`);
    node.before(link); link.append(node);
  }
}

// Orientação e escala afetam apenas a leitura, preservando a fonte canônica.
export default Vue.defineComponent({
  components: { CodeBlock },
  props: { codigo: String, fonte: String, titulo: { type: String, default: 'Diagrama' } },
  setup(props) {
    const svg = Vue.ref(''), source = Vue.ref(''), error = Vue.ref(false), loading = Vue.ref(true);
    const viewport = Vue.ref<HTMLDivElement | null>(null), orientacao = Vue.ref(''), zoom = Vue.ref(100);
    const dimensoes = Vue.ref({ largura: 1, altura: 1 }), largura = Vue.ref(600);
    const fluxo = Vue.computed(() => /^\s*(flowchart|graph)\s+(TD|TB|BT|LR|RL)\b/.test(source.value));
    const tamanho = Vue.computed(() => {
      const d = dimensoes.value;
      const escala = Math.min(1, largura.value / d.largura, 480 / d.altura) * zoom.value / 100;
      return { width: `${d.largura * escala}px`, height: `${d.altura * escala}px` };
    });
    let generation = 0;
    let observer: ResizeObserver | undefined;
    async function renderizar() {
      const current = ++generation;
      error.value = false; loading.value = true;
      let container;
      try {
        const code = orientacao.value && fluxo.value
          ? source.value.replace(/^(\s*(?:flowchart|graph)\s+)(TD|TB|BT|LR|RL)\b/, '$1' + orientacao.value) : source.value;
        const mermaid = await carregarMermaid();
        container = document.createElement('div'); container.className = 'diagram-render-container'; document.body.append(container);
        const result = await mermaid.render(`tdd-diagram-${++sequence}`, code, container);
        if (current !== generation) return;
        const root = new DOMParser().parseFromString(result.svg, 'image/svg+xml').documentElement;
        const box = root.getAttribute('viewBox')?.split(/[\s,]+/).map(Number);
        dimensoes.value = { largura: box?.[2] || 600, altura: box?.[3] || 400 };
        root.setAttribute('width', '100%'); root.setAttribute('height', '100%'); root.style.maxWidth = 'none';
        vincularUnits(root); svg.value = new XMLSerializer().serializeToString(root);
      } catch {
        if (current === generation) { error.value = true; svg.value = ''; }
      } finally {
        container?.remove(); if (current === generation) loading.value = false;
      }
    }
    Vue.watch(() => [props.codigo, props.fonte], async () => {
      const current = ++generation;
      svg.value = ''; loading.value = true; error.value = false; orientacao.value = ''; zoom.value = 100;
      try {
        const code = props.codigo ?? await lerDiagrama(props.fonte ?? '');
        if (current !== generation) return;
        source.value = code; await renderizar();
      } catch { if (current === generation) { error.value = true; loading.value = false; } }
    }, { immediate: true });
    Vue.watch(orientacao, () => { if (source.value) { zoom.value = 100; renderizar(); } });
    Vue.onMounted(() => {
      observer = new ResizeObserver(pEntries => { largura.value = Math.max(1, pEntries[0].contentRect.width); });
      if (viewport.value) observer.observe(viewport.value);
    });
    Vue.onBeforeUnmount(() => { generation++; observer?.disconnect(); });
    return { svg, source, error, loading, viewport, orientacao, zoom, fluxo, tamanho };
  },
  template: `  <!-- eslint-disable vue/no-v-html -- SVG produzido pelo Mermaid em securityLevel strict, sem HTML editorial. -->
  <figure class="diagram"><figcaption>{{ titulo }}</figcaption>
    <div
      v-if="svg"
      class="diagram-controls">
      <button
        :disabled="zoom <= 50"
        aria-label="Reduzir diagrama"
        @click="zoom = Math.max(50, zoom - 25)">−</button>
      <span
        class="diagram-zoom"
        aria-live="polite">{{ zoom }}%</span>
      <button
        :disabled="zoom >= 400"
        aria-label="Ampliar diagrama"
        @click="zoom = Math.min(400, zoom + 25)">+</button>
      <button
        aria-label="Ajustar diagrama"
        @click="zoom = 100">Ajustar</button>
      <template v-if="fluxo"><button
        :aria-pressed="orientacao === 'LR'"
        aria-label="Orientação horizontal"
        @click="orientacao = 'LR'">Horizontal</button><button
        :aria-pressed="orientacao === 'TD'"
        aria-label="Orientação vertical"
        @click="orientacao = 'TD'">Vertical</button></template>
    </div>
    <p
      v-if="loading"
      role="status">Carregando diagrama…</p>
    <div
      ref="viewport"
      :tabindex="svg ? 0 : undefined"
      :aria-label="titulo"
      class="diagram-svg"><div
      v-if="svg"
      :style="tamanho"
      v-html="svg"></div></div>
    <div
      v-if="error"
      class="diagram-fallback"><v-alert
      type="warning"
      variant="tonal">Diagrama indisponível</v-alert><CodeBlock
      v-if="source"
      :codigo="source"
      linguagem="mermaid"/><p v-else>Consulte a fonte: {{ fonte }}</p></div>
    <details v-else-if="svg"><summary>Ver código Mermaid</summary><CodeBlock
      :codigo="source"
      linguagem="mermaid"/></details>
  </figure>`
});
