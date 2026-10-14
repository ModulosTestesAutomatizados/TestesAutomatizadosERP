import type { IGrupoNavegacao } from '../models/documentacao.ts';

import { rotaDocumento } from '../content/validarCatalogo.ts';

// Um grupo expansível pode conter documentos e outros grupos.
const navigationGroup = Vue.defineComponent({
  name: 'NavigationGroup',
  props: { grupo: { type: Object as import('vue').PropType<IGrupoNavegacao>, required: true } },
  setup: () => ({ rotaDocumento }),
  template: `  <v-list-group
    :value="grupo.id"
    class="navigation-group">
    <template #activator="{ props, isOpen }"><v-list-item
      v-bind="props"
      :aria-expanded="isOpen"
      :title="grupo.titulo"
      :prependIcon="grupo.icone"
      tag="button"
      type="button"
      role="button"
      class="navigation-group-title"/></template>
    <NavigationGroup
      v-for="filho in grupo.grupos ?? []"
      :key="filho.id"
      :grupo="filho"/>
    <v-list-item
      v-if="!grupo.documentos?.length && !grupo.grupos?.length"
      :title="grupo.vazio ?? 'Sem documentação cadastrada.'"
      disabled/>
    <v-tooltip
      v-for="doc in grupo.documentos ?? []"
      :key="doc.slug"
      :text="doc.titulo"
      :openOnFocus="true"
      location="end">
      <template #activator="{ props }"><v-list-item
        v-bind="props"
        :to="rotaDocumento(doc)"
        :title="doc.titulo"
        class="navigation-document"/></template>
    </v-tooltip>
  </v-list-group>`
});
export default navigationGroup;
