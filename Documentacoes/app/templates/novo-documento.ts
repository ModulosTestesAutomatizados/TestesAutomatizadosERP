// Modelo copiável; não é registrado automaticamente no catálogo.
export default `import type { IDocumento } from '../../models/documentacao.ts';

export default {
  slug: 'novo-caso',
  categoria: 'estrutura',
  navegacao: { grupo: 'estrutura', ordem: 0 },
  titulo: 'Título da documentação',
  resumo: 'Objetivo e conteúdo desta página.',
  estado: 'em-desenvolvimento',
  fontes: [{ caminho: 'docs/assets/caminho/UNIT.pas' }],
  secoes: [
    {
      id: 'objetivo', titulo: 'Objetivo e pré-requisitos', nivel: 2,
      blocos: [
        { tipo: 'paragrafo', texto: 'Explique o objetivo, módulo, área e unit de entrada.' },
        { tipo: 'lista', itens: ['Descreva os pré-requisitos do caso.'] },
        { tipo: 'aviso', severidade: 'warning', texto: 'Declare limitações e pendências.' }
      ]
    }
  ]
} satisfies IDocumento;`;
