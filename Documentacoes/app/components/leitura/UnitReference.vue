<template>
  <RouterLink
    v-if="destino"
    :to="destino"
    class="unit-reference">{{ nome }}</RouterLink><span v-else>{{ nome }}</span>
</template>

<script setup lang="ts">
import { useReferenciasUnits } from './useReferenciasUnits.ts';
const { rotaUnit } = useReferenciasUnits();
import { computed } from 'vue';

const props = defineProps({ nome: { type: String, required: true } });

const destino = computed(() => rotaUnit(props.nome));
</script>
