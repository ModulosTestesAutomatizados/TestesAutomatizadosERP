<template>
  <div class="doc-blocks"><template
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
  </template></div>
</template>

<script setup lang="ts">
import type { TBloco } from '../../contracts/documentacao.ts';

import CodeBlock from './CodeBlock.vue';
import DocNotice from './DocNotice.vue';
import DocTable from './DocTable.vue';
import MermaidDiagram from './MermaidDiagram.vue';
import ReferenceText from './ReferenceText.vue';

defineProps<{ blocos: TBloco[] }>();

</script>
