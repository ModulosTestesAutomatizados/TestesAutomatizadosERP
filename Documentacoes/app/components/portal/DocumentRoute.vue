<template>
  <DocumentoView
    v-if="documento"
    :documento="documento"/>
  <NotFoundView v-else/>
</template>
<script setup lang="ts">
import { computed } from 'vue';
import { useRoute } from 'vue-router';

import documentos from '../../catalogo/index.ts';
import { rotaDocumento } from '../../contracts/identidade.ts';
import { DocumentoView } from '../leitura/index.ts';
import NotFoundView from './NotFoundView.vue';
const route = useRoute();
const documento = computed(() => documentos.find(pDoc => rotaDocumento(pDoc) === route.path));
</script>
