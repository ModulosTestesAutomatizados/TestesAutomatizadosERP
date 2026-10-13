import DocSection from '../components/DocSection.ts';
import DocumentToc from '../components/DocumentToc.ts';
import ReferenceText from '../components/ReferenceText.ts';
import { useDocumentSections } from '../composables/useDocumentSections.ts';
import { fonteRepositorio } from '../config.ts';
import documentos from '../content/catalogo.ts';
import { estados } from '../content/validarCatalogo.ts';
import NotFoundPage from './NotFoundPage.ts';

export default Vue.defineComponent({
  components: { DocSection, DocumentToc, NotFoundPage, ReferenceText },
  setup() {
    const route = VueRouter.useRoute();
    const documento = Vue.computed(() => documentos.find(pDoc => pDoc.slug === route.params.slug && pDoc.categoria === route.params.categoria));
    const { ativa } = useDocumentSections(documento);
    return { documento, estados, fonteRepositorio, ativa };
  },
  template: `  <div
    v-if="documento"
    class="document-layout"><article><header class="document-header"><RouterLink
                                                                     to="/"
                                                                     class="back-link">← Todas as documentações</RouterLink>
                                     <div class="eyebrow mt-6">{{ documento.categoria === 'estrutura' ? 'ARQUITETURA E EXECUÇÃO' : documento.categoria === 'units' ? 'DOCUMENTAÇÃO DA UNIT' : documento.categoria === 'guias' ? 'GUIA DE AUTORIA' : 'REFERÊNCIA TÉCNICA' }}</div>
                                     <h1 tabindex="-1"><ReferenceText :texto="documento.titulo"/></h1><p class="document-summary"><ReferenceText :texto="documento.resumo"/></p>
                                     <v-chip
                                       :color="documento.estado === 'legado' ? 'secondary' : 'primary'"
                                       class="document-state"
                                       variant="tonal"
                                       size="small">{{ estados[documento.estado] }}</v-chip>
                                   </header>
    <v-alert
      v-if="documento.estado === 'legado'"
      type="info"
      variant="tonal"
      rounded="lg"
      class="my-6">Referência anterior preservada. As APIs, exemplos e observações abaixo podem divergir da refatoração. Consulte <RouterLink to="/estrutura/runner">o fluxo atual do Runner</RouterLink>.</v-alert>
    <div class="sections"><DocSection
      v-for="secao in documento.secoes"
      :key="documento.slug + secao.id"
      :secao="secao"
      :slug="documento.slug"/></div>
    <footer class="sources"><h2>Fontes e evidências</h2><p>Referências no repositório. A leitura dos fontes não representa homologação no ERP.</p><ul><li
      v-for="fonte in documento.fontes"
      :key="fonte.caminho"><a
      :href="fonteRepositorio(fonte.caminho)"
      target="_blank"
      rel="noopener">{{ fonte.caminho }}</a></li></ul><RouterLink
      v-if="documento.referenciaAnterior"
      :to="documento.referenciaAnterior">Consultar a documentação anterior preservada</RouterLink></footer>
  </article><DocumentToc
    :documento="documento"
    :ativa="ativa"/></div><NotFoundPage v-else/>`
});
