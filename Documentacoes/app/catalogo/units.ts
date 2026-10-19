import documentos from './index.ts';
export default documentos.filter(pDoc => !!pDoc.unit);
