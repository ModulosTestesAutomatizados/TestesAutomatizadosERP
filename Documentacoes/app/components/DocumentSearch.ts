import documentos from '../content/catalogo.ts';
import { rotaDocumento } from '../content/validarCatalogo.ts';
import { criarBusca } from '../search.ts';
const buscar = criarBusca(documentos);

// Busca sem servidor; o índice é montado uma vez do conteúdo do catálogo.
export default Vue.defineComponent({
  setup() {
    const consulta = Vue.ref(''), aberta = Vue.ref(false);
    const resultados = Vue.computed(() => buscar(consulta.value).slice(0, 8));
    const route = VueRouter.useRoute();
    const router = VueRouter.useRouter();
    Vue.watch(() => route.path, () => { aberta.value = false; });
    function abrirPrimeiro() { if (resultados.value.length) { router.push(rotaDocumento(resultados.value[0].documento)); aberta.value = false; } }
    return { consulta, aberta, resultados, rotaDocumento, abrirPrimeiro };
  },
  template: `  <div
    class="document-search"
    @focusout="pEvent => { if (!pEvent.currentTarget.contains(pEvent.relatedTarget)) aberta = false; }">
    <div class="search-input"><v-icon
      icon="mdi-magnify"
      size="20"
      aria-hidden="true"/><input
      v-model="consulta"
      :aria-expanded="aberta && !!consulta.trim()"
      type="search"
      placeholder="Buscar documentação…"
      aria-label="Buscar documentação"
      aria-controls="search-results"
      @focus="aberta = true"
      @input="aberta = true"
      @keydown.enter.prevent="abrirPrimeiro"
      @keydown.esc="aberta = false"/></div>
    <div
      v-if="aberta && consulta.trim()"
      id="search-results"
      class="search-results"><div
                             class="search-caption"
                             role="status">{{ resultados.length ? 'Resultados por relevância' : 'Nenhuma documentação encontrada' }}</div>
      <ul><li
        v-for="resultado in resultados"
        :key="resultado.documento.slug"><RouterLink
        :to="rotaDocumento(resultado.documento)"
        @click="aberta = false"><strong>{{ resultado.documento.titulo }}</strong><span>{{ resultado.documento.resumo }}</span><span
        v-for="simbolo in resultado.simbolos.slice(0, 3)"
        :key="simbolo.tipo + simbolo.nome"
        class="search-symbol">{{ simbolo.tipo === 'estado' ? 'Estado global' : 'Procedure/function' }}: {{ simbolo.nome }}</span></RouterLink></li></ul>
    </div>
  </div>`
});
