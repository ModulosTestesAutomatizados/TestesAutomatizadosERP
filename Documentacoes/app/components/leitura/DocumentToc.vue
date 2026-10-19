<template>
  <aside class="document-toc"><nav aria-label="Sumário"><h2>Sumário</h2><ul>
    <li
      v-for="secao in documento.secoes"
      :key="secao.id"
      :data-nivel="secao.nivel ?? 2">
      <RouterLink
        :to="{ path: route.path, query: { secao: secao.id } }"
        :class="{ 'toc-active': ativa === secao.id }"
        :aria-current="ativa === secao.id ? 'location' : undefined">{{ titulo(secao) }}</RouterLink>
    </li>
  </ul></nav></aside>
</template>

<script setup lang="ts">
import { useRoute } from 'vue-router';

import type { IDocumento } from '../../contracts/documentacao.ts';

defineProps({ documento: { type: Object as import('vue').PropType<IDocumento>, required: true }, ativa: { type: String, default: '' } });

const route = useRoute();
const titulo = (pSecao: import('../../contracts/documentacao.ts').ISecao) => pSecao.titulo.replace(/^\d+\s*·\s*/, '');
</script>
