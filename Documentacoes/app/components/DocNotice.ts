import ReferenceText from './ReferenceText.ts';
// Avisos de leitura; texto sempre escapado pelo Vue.
export default Vue.defineComponent({
  components: { ReferenceText },
  props: { texto: String, severidade: { type: String, default: 'info' } },
  template: `  <v-alert
    :type="severidade"
    variant="tonal"
    density="comfortable"
    rounded="lg"
    class="doc-notice"><ReferenceText :texto="texto"/></v-alert>`
});
