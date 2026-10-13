import RedirectCard from '../components/RedirectCard.ts';
import documentos from '../content/catalogo.ts';

export default Vue.defineComponent({
  components: { RedirectCard },
  setup: () => ({ documentos: documentos.filter(pD => !pD.oculto) }),
  template: `  <div><header class="home-header"><div class="eyebrow">TESTES AUTOMATIZADOS · ERP</div><h1 tabindex="-1">Documentação TDD</h1>
         <p class="home-description">Entenda a estrutura, acompanhe o fluxo dos casos e registre conhecimento junto do código.</p>
         <div class="home-meta"><span>Arquitetura e execução</span><span>Referências por assunto</span><span>Autoria com snippets</span></div></header>
    <v-row class="mt-6"><v-col
      v-for="documento in documentos"
      :key="documento.slug"
      cols="12"
      md="6"
      xl="4"><RedirectCard :documento="documento"/></v-col></v-row>
  </div>`
});
