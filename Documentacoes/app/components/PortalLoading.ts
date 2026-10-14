// Carregamento inicial: skeleton e scrim; aviso de recarga somente em caso de falha.
export default Vue.defineComponent({
  props: {
    ativo: { type: Boolean, required: true },
    erro: Boolean,
    documento: Boolean
  },
  emits: ['finalizado'],
  setup(props) {
    const movimentoReduzido = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    const recarregar = Vue.ref<{ $el: HTMLElement }>();
    Vue.watch(() => props.erro, async pErro => {
      if (pErro) { await Vue.nextTick(); recarregar.value?.$el.focus(); }
    });
    return { movimentoReduzido, recarregar, recarregarPagina: () => window.location.reload() };
  },
  template: `  <v-fade-transition>
    <div
      v-if="ativo"
      :data-layout="documento ? 'documento' : 'cards'"
      class="portal-skeleton"
      aria-hidden="true">
      <div class="portal-skeleton-header"><v-skeleton-loader
        :boilerplate="movimentoReduzido"
        type="avatar, text"
        width="200"/></div>
      <div class="portal-skeleton-drawer"><v-skeleton-loader
        :boilerplate="movimentoReduzido"
        type="list-item@8"/></div>
      <div class="portal-skeleton-content">
        <v-skeleton-loader
          :boilerplate="movimentoReduzido"
          type="heading, paragraph"
          maxWidth="720"/>
        <div
          v-if="!documento"
          class="portal-skeleton-cards"><v-skeleton-loader
          v-for="card in 4"
          :key="card"
          :boilerplate="movimentoReduzido"
          type="heading, paragraph, button"
          class="portal-skeleton-card"
          rounded="lg"/></div>
        <div
          v-else
          class="portal-skeleton-article"><v-skeleton-loader
          :boilerplate="movimentoReduzido"
          type="article@3, table"/><v-skeleton-loader
          :boilerplate="movimentoReduzido"
          type="heading, text@8"
          class="portal-skeleton-toc"/></div>
      </div>
    </div>
  </v-fade-transition>
  <v-overlay
    :modelValue="ativo"
    :opacity="0.32"
    :transition="movimentoReduzido ? false : 'fade-transition'"
    :closeOnBack="false"
    :zIndex="3100"
    scrim="#475569"
    scrollStrategy="block"
    class="portal-loading-overlay align-center justify-center"
    persistent
    noClickAnimation
    @afterLeave="$emit('finalizado')">
    <span
      v-if="!erro"
      class="portal-loading-status"
      role="status"
      aria-live="polite">Carregando documentação</span>
    <v-sheet
      v-if="erro"
      role="alert"
      class="portal-loading-panel"
      rounded="xl"
      elevation="8"
      aria-live="polite">
      <p>Não foi possível carregar a documentação.</p><v-btn
        ref="recarregar"
        color="primary"
        @click="recarregarPagina">Recarregar página</v-btn>
    </v-sheet>
  </v-overlay>`
});
