import documentos from '../content/catalogo.ts';
import { criarNavegacao, gruposDaRota } from '../navigation.ts';
import DocumentSearch from './DocumentSearch.ts';
import navigationGroup from './NavigationGroup.ts';

// Estrutura compartilhada; navegação derivada do catálogo.
export default Vue.defineComponent({
  components: { DocumentSearch, NavigationGroup: navigationGroup },
  setup() {
    const { mobile } = Vuetify.useDisplay();
    const drawer = Vue.ref(!mobile.value);
    const route = VueRouter.useRoute();
    const grupos = criarNavegacao(documentos);
    const abertos = Vue.ref(gruposDaRota(grupos, route.path));
    Vue.watch(() => route.path, path => {
      abertos.value = [...new Set([...abertos.value, ...gruposDaRota(grupos, path)])];
    }, { immediate: true });
    Vue.watch(() => route.path, () => {
      if (mobile.value) drawer.value = false;
      Vue.nextTick(() => document.querySelector('h1')?.focus({ preventScroll: true }));
    });
    Vue.watch(mobile, pValue => { drawer.value = !pValue; });
    function focarConteudo() { document.getElementById('conteudo')?.focus(); }
    return { grupos, abertos, mobile, drawer, focarConteudo };
  },
  template: `  <v-app id="portal-ready"><a
                             href="#conteudo"
                             class="skip-link"
                             @click.prevent="focarConteudo">Ir para o conteúdo</a>
    <v-app-bar
      height="68"
      class="portal-bar"
      flat><v-btn
           v-if="mobile"
           icon="mdi-menu"
           aria-label="Abrir navegação"
           @click="drawer = !drawer"/>
      <RouterLink
        to="/"
        class="brand"><span class="brand-mark">T</span><span>TDD <strong>ERP</strong></span></RouterLink>
      <v-spacer/><DocumentSearch/>
    </v-app-bar>
    <v-navigation-drawer
      v-model="drawer"
      :temporary="mobile"
      :permanent="!mobile"
      width="280"
      class="portal-drawer">
      <nav
        tabindex="0"
        aria-label="Documentações"><div class="drawer-heading">EXPLORAR</div><v-list
        v-model:opened="abertos"
        openStrategy="multiple"
        density="comfortable"
        nav><v-list-item
            to="/"
            title="Início"
            prependIcon="mdi-home-outline"
            exact/>
        <NavigationGroup
          v-for="grupo in grupos"
          :key="grupo.id"
          :grupo="grupo"/>
      </v-list></nav>
    </v-navigation-drawer>
    <v-main><div
              id="conteudo"
              tabindex="-1"
              class="portal-content"><RouterView v-slot="{ Component, route }"><component
                :is="Component"
                :key="route.path"/></RouterView></div>
      <footer class="portal-footer">Testes Automatizados ERP · Documentação mantida no repositório</footer>
    </v-main></v-app>`
});
