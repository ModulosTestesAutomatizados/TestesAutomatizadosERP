<template>
  <div
    class="document-search"
    @focusout="aoSair">
    <v-text-field
      v-model="consulta"
      :aria-expanded="aberta && !!consulta?.trim()"
      type="search"
      placeholder="Buscar documentação…"
      aria-label="Buscar documentação"
      aria-controls="search-results"
      clearIcon="mdi-close-circle"
      prependInnerIcon="mdi-magnify"
      variant="outlined"
      density="compact"
      class="search-field"
      clearable
      hideDetails
      @focus="aberta = true"
      @update:modelValue="aberta = !!consulta?.trim()"
      @click:clear="aberta = false"
      @keydown.enter.prevent="abrirPrimeiro"
      @keydown.esc="aberta = false"/>
    <div
      v-if="aberta && consulta?.trim()"
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
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import type { IDocumento } from '../../contracts/documentacao.ts';

import { rotaDocumento } from '../../contracts/identidade.ts';
import { criarBusca } from './search.ts';
const props = defineProps<{ documentos: IDocumento[] }>();
const buscar = criarBusca(props.documentos);
const consulta = ref<string | null>(''), aberta = ref(false);
const resultados = computed(() => buscar(consulta.value ?? '').slice(0, 8));
const route = useRoute();
const router = useRouter();
watch(() => route.path, () => { aberta.value = false; });
function aoSair(pEvent: FocusEvent) { if (!(pEvent.currentTarget as HTMLElement).contains(pEvent.relatedTarget as Node | null)) aberta.value = false; }
function abrirPrimeiro() { if (resultados.value.length) { router.push(rotaDocumento(resultados.value[0].documento)); aberta.value = false; } }
</script>
