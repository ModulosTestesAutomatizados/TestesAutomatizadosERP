<template>
  <section
    :data-nivel="secao.nivel ?? 2"
    class="doc-section"
    :id="id"><component
    :is="tag"
    class="section-heading"><ReferenceText :texto="titulo"/></component><DocBlocks :blocos="secao.blocos"/></section>
</template>

<script setup lang="ts">
import { computed } from 'vue';

import type { ISecao } from '../../contracts/documentacao.ts';

import DocBlocks from './DocBlocks.vue';
import ReferenceText from './ReferenceText.vue';

const props = defineProps({ secao: { type: Object as import('vue').PropType<ISecao>, required: true }, slug: { type: String, required: true } });
const id = computed(() => `${props.slug}-${props.secao.id}`);
const tag = computed(() => `h${props.secao.nivel ?? 2}`);
const titulo = computed(() => props.secao.titulo.replace(/^\d+\s*·\s*/, ''));
</script>
