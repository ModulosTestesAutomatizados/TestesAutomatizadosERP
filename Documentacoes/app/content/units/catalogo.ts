import processamentoFinanceiro from './p39-processamento-tdd-financeiro.ts';
import cache from './p39-tdd-cache.ts';
import casos from './p39-tdd-casos-de-teste.ts';
import constantes from './p39-tdd-constantes.ts';
import pedidoVenda from './p39-tdd-fat-pedido-venda.ts';
import borderoPagamento from './p39-tdd-fin-mapeamento-componentes-bordero-pagamento.ts';
import borderoRecebimento from './p39-tdd-fin-mapeamento-componentes-bordero-recebimento.ts';
import funcoesJson from './p39-tdd-funcoes-json.ts';
import modulo from './p39-tdd-modulo.ts';
import odbc from './p39-tdd-odbc.ts';
import parametro from './p39-tdd-parametro.ts';
import parametroMapeamento from './p39-tdd-parametro-mapeamento.ts';
import pilotoFinanceiro from './refactor-tdd-financeiro-piloto.ts';
import base from './tdd-base-unit-irunner.ts';
import finished from './tdd-finished.ts';
import irunner from './tdd-irunner.ts';
import logs from './tdd-logs.ts';
import runner from './tdd-runner.ts';
import started from './tdd-started.ts';

// Adicionar uma unit aqui basta para criar sua página, busca e citações.
const units = [irunner, runner, base, started, finished, logs, processamentoFinanceiro, casos, parametro, cache, parametroMapeamento,
  constantes, odbc, funcoesJson, modulo, pedidoVenda, pilotoFinanceiro, borderoPagamento, borderoRecebimento];
export default units;
