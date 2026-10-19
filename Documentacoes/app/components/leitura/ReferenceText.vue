<template>
  <span class="reference-text"><template
    v-for="(parte, index) in partes"
    :key="index"><UnitReference
    v-if="parte.unit"
    :nome="parte.texto"/><template v-else>{{ parte.texto }}</template></template></span>
</template>

<script setup lang="ts">
import { useReferenciasUnits } from './useReferenciasUnits.ts';
const { partesReferencia } = useReferenciasUnits();
import { computed } from 'vue';

import UnitReference from './UnitReference.vue';

const props = defineProps({ texto: { type: String, default: '' } });

const partes = computed(() => partesReferencia(props.texto));
</script>
