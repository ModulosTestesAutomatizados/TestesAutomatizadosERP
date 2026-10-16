<template>
  <v-alert
    :type="severidade"
    variant="tonal"
    density="comfortable"
    rounded="lg"
    class="doc-notice"><ReferenceText :texto="texto"/></v-alert>
</template>

<script setup lang="ts">
import ReferenceText from './ReferenceText.vue';

withDefaults(defineProps<{ texto?: string; severidade?: 'info' | 'warning' | 'error' | 'success' }>(), { texto: '', severidade: 'info' });

</script>
