import ReferenceText from './ReferenceText.ts';
// Tabela de referência com citações de units e scroll restrito ao bloco.
export default Vue.defineComponent({
  components: { ReferenceText },
  props: { colunas: Array as import('vue').PropType<string[]>, linhas: Array as import('vue').PropType<string[][]> },
  template: `  <div
    class="table-scroll"
    tabindex="0"
    aria-label="Tabela de referência com rolagem horizontal"><v-table density="comfortable">
    <thead><tr><th
      v-for="(coluna, index) in colunas"
      :key="index"
      scope="col">{{ coluna }}</th></tr></thead>
    <tbody><tr
      v-for="(linha, index) in linhas"
      :key="index"><td
      v-for="(celula, cell) in linha"
      :key="cell"><ReferenceText :texto="celula"/></td></tr></tbody>
  </v-table></div>`
});
