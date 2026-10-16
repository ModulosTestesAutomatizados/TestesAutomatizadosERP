export type TTemaPortal = 'claro' | 'escuro';
const CHAVE_TEMA = 'tdd-documentacao-tema';

export function temaInicial(): TTemaPortal {
  try {
    const salvo = localStorage.getItem(CHAVE_TEMA);
    if (salvo === 'claro' || salvo === 'escuro') return salvo;
  } catch { /* Leitura continua disponível mesmo sem armazenamento local. */ }
  return matchMedia('(prefers-color-scheme: dark)').matches ? 'escuro' : 'claro';
}

export function guardarTema(pTema: TTemaPortal): void {
  document.documentElement.dataset.tema = pTema;
  try { localStorage.setItem(CHAVE_TEMA, pTema); } catch { /* Preferência vale nesta sessão. */ }
}
