import casos from './p39-tdd-casos-de-teste.ts';
import pedidoVenda from './p39-tdd-fat-pedido-venda.ts';
import modulo from './p39-tdd-modulo.ts';
import parametro from './p39-tdd-parametro.ts';
import pilotoFinanceiro from './refactor-tdd-financeiro-piloto.ts';
import base from './tdd-base-unit-irunner.ts';
import finished from './tdd-finished.ts';
import irunner from './tdd-irunner.ts';
import logs from './tdd-logs.ts';
import runner from './tdd-runner.ts';
import started from './tdd-started.ts';

// Adicionar uma unit aqui basta para criar sua página, busca e citações.
const units = [irunner, runner, base, started, finished, logs, casos, parametro, modulo, pedidoVenda, pilotoFinanceiro];
export default units;
