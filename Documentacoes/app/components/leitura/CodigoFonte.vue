<template>
  <p
    v-if="carregando"
    role="status">Carregando modelo…</p>
  <v-alert
    v-else-if="erro"
    type="warning"
    variant="tonal"
    role="alert">
    Não foi possível carregar o modelo.
    <v-btn
      variant="text"
      @click="tentativa++">Tentar novamente</v-btn>
  </v-alert>
  <CodeBlock
    v-else
    :codigo="codigo"
    :linguagem="linguagem"/>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';

import { arquivoLocal } from '../../config.ts';
import CodeBlock from './CodeBlock.vue';

// Exibe e copia os bytes textuais do molde canônico, sem um segundo exemplo editável.
const props = withDefaults(defineProps<{ fonte: string; linguagem?: string }>(), { linguagem: 'texto' });
const codigo = ref(''), carregando = ref(true), erro = ref(false), tentativa = ref(0);
watch([() => props.fonte, tentativa], async ([pFonte], pAnterior, pAoLimpar) => {
  const controller = new AbortController();
  pAoLimpar(() => controller.abort());
  carregando.value = true; erro.value = false;
  try {
    const resposta = await fetch(arquivoLocal(pFonte), { signal: controller.signal });
    if (!resposta.ok) throw new Error('Molde indisponível');
    const texto = await resposta.text();
    if (!controller.signal.aborted) codigo.value = texto;
  } catch {
    if (!controller.signal.aborted) erro.value = true;
  } finally {
    if (!controller.signal.aborted) carregando.value = false;
  }
}, { immediate: true });
</script>
