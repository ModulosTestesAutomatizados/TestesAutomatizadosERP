<template>
  <v-app id="portal-ready"><div
    :inert="bloqueado || undefined"
    :aria-busy="bloqueado ? 'true' : undefined"
    class="portal-shell"><a
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
      <v-spacer/><DocumentSearch :documentos="documentos"/>
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
    <v-main><v-alert
              v-if="falha && !carregando"
              type="error"
              role="alert">Não foi possível carregar a página. <v-btn @click="recarregarPagina">Recarregar página</v-btn></v-alert><div
                id="conteudo"
                tabindex="-1"
                class="portal-content"><RouterView v-slot="{ Component, route: rotaAtual }"><component
                :is="Component"
                :key="rotaAtual.path"/></RouterView></div>
      <footer class="portal-footer">Testes Automatizados ERP · Documentação mantida no repositório</footer>
    </v-main></div><PortalLoading
    :ativo="carregando"
    :erro="falha"
    :documento="documentoInicial"
    @finalizado="$emit('pronto')"/></v-app>
</template>

<script setup lang="ts">
import { nextTick,ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import { useDisplay } from 'vuetify';

import type { IDocumento } from '../../contracts/documentacao.ts';

import { criarNavegacao, DocumentSearch, gruposDaRota, NavigationGroup } from '../descoberta/index.ts';
import PortalLoading from './PortalLoading.vue';

const props = defineProps({ documentos: { type: Array as import('vue').PropType<IDocumento[]>, required: true }, carregando: Boolean, bloqueado: Boolean, falha: Boolean });
defineEmits(['pronto']);
const { mobile } = useDisplay();
const drawer = ref(!mobile.value);
const route = useRoute();
const grupos = criarNavegacao(props.documentos);
const abertos = ref(gruposDaRota(grupos, route.path));
watch(() => route.path, path => {
      abertos.value = [...new Set([...abertos.value, ...gruposDaRota(grupos, path)])];
    }, { immediate: true });
watch(() => route.path, () => {
      if (mobile.value) drawer.value = false;
      nextTick(() => document.querySelector('h1')?.focus({ preventScroll: true }));
    });
watch(mobile, pValue => { drawer.value = !pValue; });
function recarregarPagina() { window.location.reload(); }
function focarConteudo() { document.getElementById('conteudo')?.focus(); }
const caminhoInicial = window.location.hash.replace(/^#/, '').split('?')[0];
const documentoInicial = !!caminhoInicial && caminhoInicial !== '/';
</script>
