import type { IDocumento, IReferenciaUnit } from './documentacao.ts';
import type { InjectionKey } from 'vue';

export interface IReferenciasUnits {
  resolverUnit: (pNome: string) => IDocumento | undefined;
  rotaUnit: (pNome: string) => string | undefined;
  partesReferencia: (pTexto?: string) => IReferenciaUnit[];
}
export const REFERENCIAS_UNITS: InjectionKey<IReferenciasUnits> = Symbol('referencias-units');
