export const repositorio = 'https://github.com/ModulosTestesAutomatizados/TestesAutomatizadosERP/blob/master/';
export const arquivoLocal = (pCaminho: string): string => import.meta.env.BASE_URL + pCaminho;
export const fonteRepositorio = (pCaminho: string): string => repositorio + pCaminho.split('/').map(encodeURIComponent).join('/');
