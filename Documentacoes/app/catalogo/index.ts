import type { IDocumento } from '../contracts/documentacao.ts';
import docs0 from '../components/arquitetura/index.ts';
import docs1 from '../components/units/index.ts';
import docs2 from '../components/casos-de-teste/index.ts';
import docs3 from '../components/mapeamentos/index.ts';
import docs4 from '../components/helpers/index.ts';
import docs5 from '../components/contribuir/index.ts';
const documentos: IDocumento[] = [...docs0, ...docs1, ...docs2, ...docs3, ...docs4, ...docs5];
export default documentos;
