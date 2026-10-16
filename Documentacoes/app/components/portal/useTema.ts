import { computed } from 'vue';
import { useTheme } from 'vuetify';

import { guardarTema } from './preferenciaTema.ts';

export function useTema() {
  const tema = useTheme();
  const escuro = computed(() => tema.name.value === 'escuro');
  async function alternarTema() {
    const proximo = escuro.value ? 'claro' : 'escuro';
    await tema.change(proximo, false);
    guardarTema(proximo);
  }
  return { escuro, alternarTema };
}
