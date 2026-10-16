import type { TBloco } from '../contracts/documentacao.ts';

import CodeBlock from './CodeBlock.ts';
import DocNotice from './DocNotice.ts';
import DocTable from './DocTable.ts';
import MermaidDiagram from './MermaidDiagram.ts';
import ReferenceText from './ReferenceText.ts';

// Composição dos blocos editoriais sem conhecimento das regras do ERP.
export default Vue.defineComponent({
  components: { DocTable, DocNotice, CodeBlock, MermaidDiagram, ReferenceText },
  props: { blocos: Array as import('vue').PropType<TBloco[]> },
  template: `  <div class="doc-blocks"><template
    v-for="(bloco, index) in blocos"
    :key="index">
    <p v-if="bloco.tipo === 'paragrafo'"><ReferenceText :texto="bloco.texto"/></p>
    <ul v-else-if="bloco.tipo === 'lista'"><li
      v-for="(item, i) in bloco.itens"
      :key="i"><ReferenceText :texto="item"/></li></ul>
    <DocTable
      v-else-if="bloco.tipo === 'tabela'"
      :colunas="bloco.colunas"
      :linhas="bloco.linhas"/>
    <CodeBlock
      v-else-if="bloco.tipo === 'codigo'"
      :codigo="bloco.codigo"
      :linguagem="bloco.linguagem"/>
    <DocNotice
      v-else-if="bloco.tipo === 'aviso'"
      :texto="bloco.texto"
      :severidade="bloco.severidade"/>
    <MermaidDiagram
      v-else-if="bloco.tipo === 'mermaid'"
      :fonte="bloco.fonte"
      :titulo="bloco.titulo"/>
  </template></div>`
});
