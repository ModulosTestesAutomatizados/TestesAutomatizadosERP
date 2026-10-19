import type { IDocumento, TEstado } from './documentacao.ts';

export const slugUnit = (pNome: string): string => pNome.toLowerCase().replace(/_/g, '-');
export const rotaDocumento = (pDocumento: IDocumento): string => `/${pDocumento.categoria}/${pDocumento.slug}`;
export const estados: Record<TEstado, string> = { legado: 'Contrato anterior', 'em-uso': 'Em uso', 'em-desenvolvimento': 'Em desenvolvimento', 'validado-no-erp': 'Validado no ERP' };
