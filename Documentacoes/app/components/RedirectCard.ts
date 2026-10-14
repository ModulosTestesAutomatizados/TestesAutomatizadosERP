import type { IDocumento } from '../models/documentacao.ts';

import { estados, rotaDocumento } from '../content/validarCatalogo.ts';
import { contextoDocumento } from '../navigation.ts';

// Navegação reutilizável; o catálogo determina conteúdo e destino.
export default Vue.defineComponent({
  props: { documento: { type: Object as import('vue').PropType<IDocumento>, required: true } },
  setup: () => ({ estados, rotaDocumento, contextoDocumento }),
  template: `  <v-card
    :to="rotaDocumento(documento)"
    :aria-label="'Abrir ' + documento.titulo"
    class="redirect-card"
    variant="outlined"
    rounded="lg"
    height="100%">
    <v-card-text class="d-flex flex-column h-100 pa-6">
      <div class="card-category">{{ contextoDocumento(documento) }}</div>
      <v-chip
        v-if="documento.unit"
        class="align-self-start mt-3"
        size="x-small"
        variant="tonal">{{ documento.tipoArtefato === 'processamento' ? 'Processamento' : 'Unit' }}</v-chip>
      <h2 class="card-title mt-3">{{ documento.titulo }}</h2>
      <p class="mt-3 card-summary">{{ documento.resumo }}</p>
      <v-chip
        :color="documento.estado === 'legado' ? 'secondary' : 'primary'"
        class="mt-5 align-self-start"
        size="small"
        variant="tonal">{{ estados[documento.estado] }}</v-chip>
      <div
        class="card-arrow mt-auto pt-6"
        aria-hidden="true">→</div>
    </v-card-text>
  </v-card>`
});
