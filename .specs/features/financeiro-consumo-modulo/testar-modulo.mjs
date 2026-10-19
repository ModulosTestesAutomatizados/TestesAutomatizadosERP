import assert from 'node:assert/strict';
import {environment} from '../irunner-asserts-modulo/evidencias/ambiente.mjs';
const file='docs/assets/emDesenvolvimento/Runner/P39_TDD_RUN_MODULO.pas';
function setup(){
  const e=environment(),a=e.api,calls=[],principal={Nome:'FPrincipal'};
  Object.assign(a,{FModulo:1,FDescModulo:'FINANCEIRO',cFP:'FPrincipal',FP:null,
    FormCriadoPeloNome:name=>{assert.equal(name,'FPrincipal');return principal;},
    ExecutarMetodoDeObjeto:(...args)=>calls.push(args)});
  e.load(file,['AbrirTela','FocarModulo','TrazerParaFrente']);
  return {...e,calls,principal};
}
{
  const e=setup();e.api.TrazerParaFrente();e.api.FocarModulo();
  assert.deepEqual(e.calls,[[e.principal,'BringToFront'],[e.principal,'SetFocus'],[e.principal,'Repaint']]);
  console.log('PASS MODFIN-08 chamadas sem parâmetros omitem o argumento opcional');
}
{
  for(const values of [{FModulo:0},{FDescModulo:''}])for(const method of ['AbrirTela','FocarModulo','TrazerParaFrente']){
    const e=setup();Object.assign(e.api,values);assert.throws(()=>e.api[method]('EVENTO_DE_TESTE'),/Módulo não informado/);assert.deepEqual(e.calls,[]);
  }
  for(const method of ['AbrirTela','FocarModulo','TrazerParaFrente']){
    const e=setup();e.api.FormCriadoPeloNome=()=>null;assert.throws(()=>e.api[method]('EVENTO_DE_TESTE'),/Tela principal não encontrada/);assert.deepEqual(e.calls,[]);
  }
  console.log('PASS MODFIN-09 contexto inválido e principal ausente não executam eventos');
}
{
  const e=setup();e.api.AbrirTela('EVENTO_DE_TESTE');
  assert.deepEqual(e.calls,[[e.principal,'EVENTO_DE_TESTE',[e.principal]]]);
  console.log('PASS contrato de AbrirTela preserva evento e sender sem presumir handler financeiro');
}
console.log('GATE LOCAL: 3 grupos; sem executar ERP, menu real ou banco. Refatoração financeira ainda depende do catálogo de eventos.');
