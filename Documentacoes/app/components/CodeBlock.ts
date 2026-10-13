import ReferenceText from './ReferenceText.ts';
// Texto literal e cópia; citações não alteram o código enviado ao clipboard.
export default Vue.defineComponent({
  components: { ReferenceText },
  props: { codigo: { type: String, required: true }, linguagem: { type: String, default: 'texto' } },
  setup(props) {
    const mensagem = Vue.ref('');
    async function copiar() {
      try { await navigator.clipboard.writeText(props.codigo); mensagem.value = 'Código copiado'; }
      catch { mensagem.value = 'Selecione o código para copiar'; }
    }
    return { mensagem, copiar };
  },
  template: `  <div class="code-block"><div class="code-toolbar"><div
                            class="terminal-dots"
                            aria-hidden="true"><span></span><span></span><span></span></div><span class="terminal-language">{{ linguagem }}</span><v-btn
                            size="small"
                            variant="text"
                            aria-label="Copiar código"
                            @click="copiar">Copiar</v-btn></div>
    <pre tabindex="0"><code><ReferenceText :texto="codigo"/></code></pre><div
      class="copy-status"
      role="status"
      aria-live="polite">{{ mensagem }}</div></div>`
});
