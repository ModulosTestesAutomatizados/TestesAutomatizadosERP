// Um registro gera card, item do menu e página em uma rota genérica.
import type { IDocumento } from '../models/documentacao.ts';

import casosIRunner from './casos/irunner.ts';
import casosLegado from './casos/legado.ts';
import pedidoVenda from './casos/pedido-venda.ts';
import pilotoFinanceiro from './casos/piloto-financeiro.ts';
import casos from './documentos/casos-de-teste.ts';
import parametros from './documentos/parametros.ts';
import runner from './estrutura/runner.ts';
import autoria from './guias/autoria.ts';
import casosAnterior from './historico/casos-de-teste.ts';
import documentoFatura from './historico/documento-fatura.ts';
import parametrosAnterior from './historico/parametros.ts';
import runnerLegado from './historico/runner-legado.ts';
import units from './units/catalogo.ts';
const documentos: IDocumento[] = [runner, casos, parametros,
  { ...documentoFatura, navegacao: { grupo: 'casos', subgrupo: 'legado' } },
  runnerLegado, autoria, ...units, casosLegado, casosIRunner, pilotoFinanceiro, pedidoVenda,
  { ...casosAnterior, slug: 'casos-de-teste-referencia-anterior', titulo: 'Casos de teste — referência anterior', oculto: true },
  { ...parametrosAnterior, slug: 'parametros-referencia-anterior', titulo: 'Parâmetros — referência anterior', oculto: true }
];
export default documentos;
