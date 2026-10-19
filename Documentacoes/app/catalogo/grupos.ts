import type { IDefinicaoGrupoNavegacao } from '../contracts/documentacao.ts';

// Registro único de grupos; cada página declara posição e ordem.
export const GRUPOS_NAVEGACAO: IDefinicaoGrupoNavegacao[] = [
  { id: 'estrutura', titulo: 'Arquitetura', icone: 'mdi-sitemap-outline', categoria: 'estrutura' },
  { id: 'units', titulo: 'Units', icone: 'mdi-code-braces', categoria: 'units', subgrupoPadrao: 'setup', subgrupos: [
    { id: 'setup', titulo: 'Setup' },
    { id: 'constantes', titulo: 'Constantes' },
    { id: 'persistencia', titulo: 'Persistência' },
    { id: 'irunner', titulo: 'IRunner' }
  ] },
  { id: 'casos', titulo: 'Casos de teste', icone: 'mdi-format-list-checks' },
  { id: 'mapeamentos', titulo: 'Mapeamentos', icone: 'mdi-map-outline', subgrupos: [
    { id: 'financeiro', titulo: 'Financeiro' }
  ] },
  { id: 'helpers', titulo: 'Helpers', icone: 'mdi-tools', subgrupos: [
    { id: 'gerais', titulo: 'Gerais' },
    { id: 'sincronizacao', titulo: 'Sincronização' }
  ] },
  { id: 'guias', titulo: 'Contribuir', icone: 'mdi-pencil-outline', categoria: 'guias' }
];
