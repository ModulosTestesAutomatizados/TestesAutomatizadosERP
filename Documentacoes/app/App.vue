<template>
  <AppLayout
    :documentos="documentos"
    :carregando="carregando"
    :bloqueado="bloqueado"
    :falha="falha"
    @pronto="concluir"/>
</template>

<script setup lang="ts">
import { nextTick, onMounted, provide, ref } from 'vue';
import { useRouter } from 'vue-router';

import documentos from './catalogo/index.ts';
import { criarReferenciasUnits } from './catalogo/referencias.ts';
import { AppLayout } from './components/portal/index.ts';
import { REFERENCIAS_UNITS } from './contracts/referencias.ts';

provide(REFERENCIAS_UNITS, criarReferenciasUnits(documentos));
const carregando = ref(true), bloqueado = ref(true), falha = ref(false);
const router = useRouter();
function concluir() { bloqueado.value = false; }
router.onError(() => { falha.value = true; });
onMounted(async () => {
  const inicio = performance.now();
  document.getElementById('portal-status')?.remove();
  document.getElementById('app')?.removeAttribute('inert');
  try {
    await router.isReady();
    await nextTick();
    await new Promise<void>(pResolve => setTimeout(pResolve, Math.max(0, 650 - (performance.now() - inicio))));
    carregando.value = false;
  } catch { falha.value = true; }
});
</script>
