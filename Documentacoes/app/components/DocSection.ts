import type { ISecao } from '../models/documentacao.ts';

import DocBlocks from './DocBlocks.ts';
import ReferenceText from './ReferenceText.ts';

// Seção de leitura contínua; o nível do título também alimenta o sumário.
export default Vue.defineComponent({
  components: { DocBlocks, ReferenceText },
  props: { secao: { type: Object as import('vue').PropType<ISecao>, required: true }, slug: String },
  setup(props) {
    const id = Vue.computed(() => `${props.slug}-${props.secao.id}`);
    const tag = Vue.computed(() => `h${props.secao.nivel ?? 2}`);
    const titulo = Vue.computed(() => props.secao.titulo.replace(/^\d+\s*·\s*/, ''));
    return { id, tag, titulo };
  },
  template: `  <section
    :data-nivel="secao.nivel ?? 2"
    class="doc-section"
    :id="id"><component
    :is="tag"
    class="section-heading"><ReferenceText :texto="titulo"/></component><DocBlocks :blocos="secao.blocos"/></section>`
});
