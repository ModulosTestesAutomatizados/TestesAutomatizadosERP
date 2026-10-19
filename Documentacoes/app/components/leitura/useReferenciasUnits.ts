import { inject } from 'vue';

import { REFERENCIAS_UNITS } from '../../contracts/referencias.ts';

export function useReferenciasUnits() {
  const referencias = inject(REFERENCIAS_UNITS);
  if (!referencias) throw new Error('Catálogo de referências não fornecido ao leitor');
  return referencias;
}
