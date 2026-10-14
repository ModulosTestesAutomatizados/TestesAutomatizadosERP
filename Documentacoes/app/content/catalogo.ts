// Um registro gera card, menu, busca e página.
import type { IDocumento } from '../models/documentacao.ts';

import runner from './estrutura/runner.ts';
import autoria from './guias/autoria.ts';
import units from './units/catalogo.ts';

const documentos: IDocumento[] = [runner, ...units, autoria];
export default documentos;
