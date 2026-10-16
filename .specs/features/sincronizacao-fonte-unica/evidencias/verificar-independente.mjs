import assert from 'node:assert/strict';
import {environment,error} from '../../irunner-asserts-modulo/evidencias/ambiente.mjs';
const registration='docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas';
function setup(){
 const e=environment(),a=e.api,created=[],events=[],units={P39_TDD_ASSERTS_JSON_MINIMO:'{"resultadoEsperado":{"erro":{"quantidade":0,"operacao":"Igual"}}}',P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO:'{}'};
 const originalParse=a.TJSONObject.ParseJSONValue,originalExec=a.ExecutarMetodoDeObjeto;
 a.TJSONObject.ParseJSONValue=text=>{const o=originalParse(text);if(o){o.Free=()=>{assert.ok(!o.freed,'objeto JSON liberado duas vezes');o.freed=true;};created.push(o);}return o;};
 a.ExecutarMetodoDeObjeto=(o,m,args)=>m==='ToJSON'?JSON.stringify({[o[0]]:o[1]}).slice(1,-1):originalExec(o,m,args);
 a.CodificacaoUnit=name=>{if(!Object.hasOwn(units,name))throw error('Leitura indisponível: '+name);return units[name];};
 a.RegistroFallbackModulo=()=>{events.push('SQL_MODULO');return 1;};a.RegistroFallbackArea=()=>{events.push('SQL_AREA');return 2;};a.SincronizarCasoTeste=()=>0;a.InsertCasoTeste=()=>events.push(structuredClone(a.FCasoTeste));a.FCasoTeste={};
 e.load('docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas',['GetPairName','GetPairValue']);
 e.load(registration,['CarregarConteudoUnit','ObterObjetoConfiguracao','RegistrarCasoTeste']);
 return {...e,created,events,units,assertFreed(){assert.ok(created.every(o=>o.freed),'Todo objeto criado deve ser liberado');}};
}
{
 const e=setup(),a=e.api;
 e.units.SOURCE='{"EMPRESA_DUP":1,"texto":"chave: valor { \\\"aspas\\\" }","aninhado":{"resultadoEsperado":{"x":1}},"parametros":{"Ativo":false},"resultadoEsperado":{},"camposDisponiveis":{}}';
 a.RegistrarCasoTeste('F','F','caso','160','SOURCE',false);
 const record=e.events.at(-1);assert.deepEqual(JSON.parse(record.ResultadoEsperado),{resultadoEsperado:{}});assert.deepEqual(JSON.parse(record.CamposDisponiveis),{camposDisponiveis:{}});
 const payload=JSON.parse(record.CasoTeste);assert.equal(payload.EMPRESA_DUP,1);assert.deepEqual(payload.aninhado,{resultadoEsperado:{x:1}});assert.deepEqual(payload.parametros,{Ativo:false});assert.deepEqual(payload.resultadoEsperado,{});assert.deepEqual(payload.camposDisponiveis,{});e.assertFreed();
 console.log('PASS independente projeção com helpers reais, aninhamento e memória de sucesso');
}
{
 for(const fallback of [undefined,'','  ','[]','null','{"camposDisponiveis":null}','{"camposDisponiveis":[]}','{"outra":{}}']){
  const e=setup();e.units.SOURCE='{"resultadoEsperado":{},"camposDisponiveis":{}}';
  if(fallback===undefined)delete e.units.P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO;else e.units.P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO=fallback;
  assert.throws(()=>e.api.RegistrarCasoTeste('F','F','caso','160','SOURCE',false),'Fallback de campos inválido deve abortar');assert.deepEqual(e.events,[]);e.assertFreed();
 }
 console.log('PASS independente fallback de campos inválido interrompe antes de SQL e libera JSON');
}
{
 for(const source of ['{"resultadoEsperado":null,"camposDisponiveis":{}}','{"resultadoEsperado":{},"camposDisponiveis":null}','{"resultadoEsperado":{},"camposDisponiveis":1}']){
  const e=setup();e.units.SOURCE=source;assert.throws(()=>e.api.RegistrarCasoTeste('F','F','caso','160','SOURCE',false));assert.deepEqual(e.events,[]);e.assertFreed();
 }
 const e=setup();e.units.SOURCE='{}';e.api.RegistrarCasoTeste('F','F','caso','160','SOURCE',false);assert.deepEqual(JSON.parse(e.events.at(-1).ResultadoEsperado),{resultadoEsperado:{erro:{quantidade:0,operacao:'Igual'}}});e.assertFreed();
 console.log('PASS independente presença inválida e dois fallbacks ausentes sem vazamento');
}
{
 const e=setup(),a=e.api;
 e.load('docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_ASSERTS.pas',['InicializarAcumulo','RegistrarResultado','AssertsPassou','AssertsFalhou','AssertsZerar','AssertsTotal','AssertsPass','AssertsFail','AssertsOk','AssertsResumo']);
 e.load('docs/assets/emDesenvolvimento/P39_TDD_VALIDAR_RESULTADO.pas',['GetOperacao','AplicarOperacaoNumerica','OperacaoDescricao','CompararQuantidadeErros','CompararValores','CompararTempo','FinalizarComparacao','CompararComJSON']);
 a.AssertsZerar();a.AssertsPassou('verificação explícita');
 a.CompararComJSON('{"resultadoEsperado":{"erro":{"quantidade":0,"operacao":"Igual"}}}');assert.deepEqual([a.AssertsTotal,a.AssertsPass,a.AssertsFail],[2,2,0]);
 a.CompararComJSON('{"resultadoEsperado":{}}');assert.deepEqual([a.AssertsTotal,a.AssertsPass,a.AssertsFail],[2,2,0]);
 for(const invalid of ['{"erro":{"quantidade":"inválido","operacao":"Igual"}}','{"erro":{"quantidade":0,"operacao":"INVALIDA"}}','{"valor":[]}','{"tempo":{"tempo_total":0,"tipo_registo":"segundo"}}']){
  const before=a.AssertsFail;a.CompararComJSON(invalid);assert.ok(a.AssertsFail>before,invalid);
 }
 e.assertFreed();console.log('PASS independente mínimo válido, vazio e configurações inválidas preservam acúmulo e memória');
}
