import assert from 'node:assert/strict';
import {environment,dataset} from './ambiente.mjs';
const e=environment(),a=e.api;
e.load('docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_ASSERTS.pas',['InicializarAcumulo','RegistrarDataSet','RegistrarResultado','AssertsPassou','AssertsFalhou','AssertsZerar','AssertsTotal','AssertsPass','AssertsFail','AssertsOk','AssertsResumo']);
e.load('docs/assets/configuracoesGerais/P39_TDD_VALIDAR_RESULTADO.pas',['GetOperacao','AplicarOperacaoNumerica','OperacaoDescricao','CompararCampoPorTipo','CompararValor','ConverterParaCurrency']);
for(const type of ['ftInteger','ftCurrency','ftDateTime']){
  const value=type==='ftDateTime'?'2026-10-15':'10';
  for(const op of [1,2]){a.AssertsZerar();a.CompararCampoPorTipo(type,value,value,op,'limite');assert.equal(a.AssertsOk,false,`${type}: limite igual não satisfaz maior/menor`);}
}
console.log('PASS independente RUN-15 limites estritos');
const first=dataset([{A:2}]),second=dataset([{A:3}]);
a.DMCriadoPeloNome=name=>({FindComponent:()=>name==='DM1'?first:second});
a.AssertsZerar();a.RegistrarDataSet('CDS|DM1');a.RegistrarDataSet('CDS|DM2');
a.CompararValor('{"campo":"A","resultado":2,"tipo_campo":"ftInteger","operacao":"Igual"}');
assert.equal(a.AssertsFail,1,'capturas ambíguas reprovam');
a.CompararValor('{"campo":"A","resultado":2,"tipo_campo":"ftInteger","operacao":"Igual","dm":"DM1","cds":"CDS"}');
assert.equal(a.AssertsPass,1,'chave explícita desambigua: '+a.FResultados.Text);
a.FDataSets.Objects[0].Active=false;
a.CompararValor('{"campo":"A","resultado":2,"tipo_campo":"ftInteger","operacao":"Igual","dm":"DM1"}');
assert.equal(a.AssertsFail,2,'captura inativa reprova');
assert.deepEqual(first.rows,[{A:2}]);assert.equal(first.freed,false);assert.equal(first.RecNo,1);
console.log('PASS independente RUN-12/13 ambiguidades, inativa e origem preservada');
const nullSource=dataset([{A:null}]);a.DMCriadoPeloNome=()=>({FindComponent:()=>nullSource});
a.AssertsZerar();a.RegistrarDataSet('CDS|DM');
a.CompararValor('{"campo":"A","resultado":0,"tipo_campo":"ftInteger","operacao":"Igual"}');
assert.equal(a.AssertsFail,1);assert.match(a.FResultados.Text,/NULL/);
console.log('PASS independente RUN-16 NULL não equivale a zero');
e.load('docs/assets/emDesenvolvimento/Runner/TDD_RUN_RUNNER.pas',['RegistrarTick','FormatarTickDiff','PreencherComZeros']);
a.FCDSMetricasTickDiff=dataset([]);a.FTempoBaseTick=4294967290;a.GetTickCount=4294967290;
a.RegistrarTick(0,'ASSERTS');a.GetTickCount=5;a.RegistrarTick(1,'ASSERTS');
assert.equal(a.FCDSMetricasTickDiff.FieldByName('TEMPO_TOTAL').AsInteger,11);
a.GetTickCount=2147483640;a.FTempoBaseTick=0; // último relativo válido.
a.FCDSMetricasTickDiff=dataset([]);a.RegistrarTick(0,'TOTAL');
a.GetTickCount=2147483647;assert.throws(()=>a.RegistrarTick(1,'TOTAL'),/Integer/);
console.log('PASS independente RUN-24 virada Cardinal e domínio Integer');
a.AssertsZerar();a.AssertsPassou('esperado 10, obtido 10');a.FResultadoEsperadoCaso='{"valor":[{"campo":"A","resultado":10}]}';
a.FCDSMetricasTickDiff=dataset([{NOME_METODO:'ASSERTS',ETAPA_CASO_TESTE:7,TEMPO_INICIO:1,TEMPO_FIM:26,TEMPO_TOTAL:25,TEMPO_TOTAL_FORMATADO:'00:00:00.025'}]);
e.load('docs/assets/emDesenvolvimento/Runner/TDD_RUN_FINISHED.pas',['RegistrarMetricas']);a.RegistrarMetricas();
assert.deepEqual(e.assertRows.at(-1).slice(0,7),[96,7,25,1,1,0,a.FResultadoEsperadoCaso]);
assert.match(e.assertRows.at(-1)[7],/esperado 10, obtido 10/);
console.log('PASS independente RUN-21 payload com esperado não vazio e tempo real');
