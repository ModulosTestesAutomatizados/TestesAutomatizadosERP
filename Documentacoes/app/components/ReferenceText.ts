import { partesReferencia } from '../unitReferences.ts';
import UnitReference from './UnitReference.ts';

// Identificação automática de nomes, preservando pontuação e texto literal.
export default Vue.defineComponent({
  components: { UnitReference }, props: { texto: { type: String, default: '' } },
  setup(props) { return { partes: Vue.computed(() => partesReferencia(props.texto)) }; },
  template: `  <span class="reference-text"><template
    v-for="(parte, index) in partes"
    :key="index"><UnitReference
    v-if="parte.unit"
    :nome="parte.texto"/><template v-else>{{ parte.texto }}</template></template></span>`
});
