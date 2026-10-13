import { rotaUnit } from '../unitReferences.ts';

// Uma citação mantém o nome escrito e resolve somente units documentadas.
export default Vue.defineComponent({
  props: { nome: { type: String, required: true } },
  setup(props) { return { destino: Vue.computed(() => rotaUnit(props.nome)) }; },
  template: `  <RouterLink
    v-if="destino"
    :to="destino"
    class="unit-reference">{{ nome }}</RouterLink><span v-else>{{ nome }}</span>`
});
