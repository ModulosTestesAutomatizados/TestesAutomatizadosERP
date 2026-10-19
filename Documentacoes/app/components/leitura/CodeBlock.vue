<template>
  <div class="code-block"><div class="code-toolbar"><div
                            class="terminal-dots"
                            aria-hidden="true"><span></span><span></span><span></span></div><span class="terminal-language">{{ linguagem }}</span><v-btn
                            size="small"
                            variant="text"
                            aria-label="Copiar código"
                            @click="copiar">Copiar</v-btn></div>
    <pre tabindex="0"><code><ReferenceText :texto="codigo"/></code></pre><div
      class="copy-status"
      role="status"
      aria-live="polite">{{ mensagem }}</div></div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

import ReferenceText from './ReferenceText.vue';

const props = defineProps({ codigo: { type: String, required: true }, linguagem: { type: String, default: 'texto' } });
const mensagem = ref('');
async function copiar() {
      try { await navigator.clipboard.writeText(props.codigo); mensagem.value = 'Código copiado'; }
      catch { mensagem.value = 'Selecione o código para copiar'; }
    }
</script>
