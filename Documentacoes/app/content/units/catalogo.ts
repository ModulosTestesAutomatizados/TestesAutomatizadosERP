import processamentoFinanceiro from './p39-tdd-fin-processamento.ts';
import cache from './p39-tdd-cache.ts';
import casos from './p39-tdd-casos-de-teste.ts';
import constantes from './p39-tdd-constantes.ts';
import pedidoVenda from './p39-tdd-fat-pedido-venda.ts';
import borderoPagamento from './p39-tdd-fin-bordero-pagamento.ts';
import borderoRecebimento from './p39-tdd-fin-bordero-recebimento.ts';
import funcoesJson from './p39-tdd-funcoes-json.ts';
import modulo from './p39-tdd-modulo.ts';
import odbc from './p39-tdd-odbc.ts';
import parametro from './p39-tdd-parametros.ts';
import parametroMapeamento from './p39-tdd-parametro-mapeamento.ts';
import pilotoFinanceiro from './p39-tdd-fin-pagamento-recebimento.ts';
import base from './p39-tdd-base-unit-irunner.ts';
import finished from './p39-tdd-finished.ts';
import irunner from './p39-tdd-irunner.ts';
import logs from './p39-tdd-logs.ts';
import runner from './p39-tdd-runner.ts';
import started from './p39-tdd-started.ts';

// Adicionar uma unit aqui basta para criar sua página, busca e citações.
const units = [irunner, runner, base, started, finished, logs, processamentoFinanceiro, casos, parametro, cache, parametroMapeamento,
  constantes, odbc, funcoesJson, modulo, pedidoVenda, pilotoFinanceiro, borderoPagamento, borderoRecebimento];
export default units;
