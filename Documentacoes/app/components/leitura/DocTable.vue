<template>
  <div
    class="table-scroll"
    tabindex="0"
    aria-label="Tabela de referência com rolagem horizontal"><v-table density="comfortable">
    <thead><tr><th
      v-for="(coluna, index) in colunas"
      :key="index"
      scope="col">{{ coluna }}</th></tr></thead>
    <tbody><tr
      v-for="(linha, index) in linhas"
      :key="index"><td
      v-for="(celula, cell) in linha"
      :key="cell"><ReferenceText :texto="celula"/></td></tr></tbody>
  </v-table></div>
</template>

<script setup lang="ts">
import ReferenceText from './ReferenceText.vue';

defineProps<{ colunas: string[]; linhas: string[][] }>();

</script>
