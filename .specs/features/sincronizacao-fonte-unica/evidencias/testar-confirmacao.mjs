import assert from 'node:assert/strict';
import {environment,error} from '../../irunner-asserts-modulo/evidencias/ambiente.mjs';
const file='docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas';
function setup(id=28,answer=7){
  const e=environment(),a=e.api,events=[];
  Object.assign(a,{FCasoTeste:{},mtConfirmation:0,mbYes:6,mbNo:7,mrYes:6,
    StrToIntDef:(v,d)=>/^[+-]?\d+$/.test(v)?Number(v):d,
    Format:(s,v)=>s.replace('%s',v[0]),
    TDDScalarODBCP:(sql,args)=>{events.push(['consulta',args]);assert.match(sql,/MD\.DESCRICAO_MODULO/);assert.match(sql,/AR\.DESCRICAO_AREA/);return id;},
    MessageDlg:()=>{events.push(['pergunta']);return answer;},
    CodificacaoUnit:()=>{events.push(['fonte']);throw error('Unit inexistente');},
    RegistroFallbackModulo:()=>{events.push(['modulo']);return 1;},
    RegistroFallbackArea:()=>{events.push(['area']);return 2;},
    TDDCommandODBCP:(sql,args)=>events.push(['escrita',sql,args])});
  e.load(file,['SincronizarCasoTeste','CarregarConteudoUnit','ObterObjetoConfiguracao','RegistrarCasoTeste','AtualizarCasoTeste','InsertCasoTeste']);
  return {...e,events,run:()=>a.RegistrarCasoTeste('FATURAMENTO','PEDIDO DE VENDA','CASO','160','FONTE',false)};
}
{
  const e=setup();assert.doesNotThrow(e.run);
  assert.deepEqual(e.events,[['consulta',['CASO','FATURAMENTO','PEDIDO DE VENDA']],['pergunta']]);
  // O próximo caso também pode ser recusado, sem interromper o lote.
  assert.doesNotThrow(e.run);assert.deepEqual(e.events.map(v=>v[0]),['consulta','pergunta','consulta','pergunta']);
  console.log('PASS recusa dispensa fonte, mínimos e escritas e permite continuar');
}
for(const id of [0,null,28]){
  const e=setup(id,6);assert.throws(e.run,/Unit inexistente/);
  assert.deepEqual(e.events.map(v=>v[0]),id===28?['consulta','pergunta','fonte']:['consulta','fonte']);
}
console.log('PASS aceite ou registro novo exige fonte antes de qualquer escrita');
for(const id of [0,28]){
  const e=setup(id,6),a=e.api;
  a.CodificacaoUnit=()=>{e.events.push(['fonte']);return '{"resultadoEsperado":{},"camposDisponiveis":{"A":{}}}';};
  a.ExecutarMetodoDeObjeto=(obj,m,args)=>m==='GetPair'?obj.pairs[args[0]]:JSON.stringify({[obj[0]]:obj[1]}).slice(1,-1);
  assert.doesNotThrow(e.run);const write=e.events.at(-1);
  assert.equal(write[0],'escrita');assert.match(write[1],id===28?/^update /:/^insert /);
  assert.equal(e.events.filter(v=>v[0]==='consulta').length,1);
  assert.equal(e.events.filter(v=>v[0]==='pergunta').length,id===28?1:0);
  assert.deepEqual(JSON.parse(write[2][4]),{camposDisponiveis:{A:{}},resultadoEsperado:{}});
  if(id===28)assert.equal(write[2][7],28);
}
console.log('PASS fonte válida gera insert ou update com payload completo e uma confirmação');
