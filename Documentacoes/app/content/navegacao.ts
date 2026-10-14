import type { IDefinicaoGrupoNavegacao } from '../models/documentacao.ts';

// Registro único de grupos: páginas e units escolhem estes IDs em navegacao.
export const GRUPOS_NAVEGACAO: IDefinicaoGrupoNavegacao[] = [
  { id: 'estrutura', titulo: 'Arquitetura', icone: 'mdi-sitemap-outline', categoria: 'estrutura' },
  { id: 'units', titulo: 'Units', icone: 'mdi-code-braces', categoria: 'units', subgrupoPadrao: 'infraestrutura', subgrupos: [
    { id: 'irunner', titulo: 'IRunner' },
    { id: 'infraestrutura', titulo: 'Infraestrutura compartilhada' },
    { id: 'casos', titulo: 'Casos de teste' },
    { id: 'faturamento', titulo: 'Faturamento' }
  ] },
  { id: 'helpers', titulo: 'Helpers', icone: 'mdi-tools', subgrupos: [
    { id: 'financeiro', titulo: 'Financeiro' },
    { id: 'sincronizacao', titulo: 'Sincronização', vazio: 'Documentações previstas para a próxima iteração.' }
  ] },
  { id: 'documentos', titulo: 'Referências', icone: 'mdi-book-open-page-variant-outline', categoria: 'documentos' },
  { id: 'casos', titulo: 'Casos de teste', icone: 'mdi-format-list-checks', subgrupos: [
    { id: 'legado', titulo: 'Legado' }, { id: 'irunner', titulo: 'IRunner' }
  ] },
  { id: 'guias', titulo: 'Contribuir', icone: 'mdi-pencil-outline', categoria: 'guias' }
];
