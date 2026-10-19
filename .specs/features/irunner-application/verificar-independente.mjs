import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import {environment,error} from '../irunner-asserts-modulo/evidencias/ambiente.mjs';
const root=process.env.RUN_TEST_ROOT??process.cwd();
const file='docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_APPLICATION.pas';
let groups=0;
function test(name,fn){fn();groups++;console.log('PASS independente '+name);}
function fixture(catalog){
  const e=environment(),a=e.api,calls=[],forms=new Map(),principal={Name:'FPrincipal'};
  const reflect=a.ExecutarMetodoDeObjeto;
  Object.assign(a,{cFP:'FPrincipal',FP:null,
    MetodosDeObjeto:()=> 'Abrir1Click(Sender: TObject)\r\nAbrirSemSufixo(Sender: TObject)',
    FormCriadoPeloNome:n=>n==='FPrincipal'?principal:forms.get(n),
    CriarFormPeloNome:n=>{calls.push(['create',n]);return {Show(){calls.push(['show',n]);}};},
    CodificacaoUnit:n=>{assert.equal(n,'P39_TDD_RUN_APPLICATION_MAPEAMENTO_JSON');calls.push(['catalog']);return JSON.stringify(catalog);},
    ExecutarMetodoDeObjeto:(o,m,args)=>{if(m==='GetPair')return reflect(o,m,args);calls.push([m]);},RegistrarLog:()=>{}});
  e.load(file,['AbrirTela','TrazerParaFrente','FocarModulo']);
  return {...e,calls,forms,principal};
}
test('APP-02 isolamento e módulo normalizado',()=>{
  const e=fixture({OUTRO:{FErrado:{caption:'Duplicado',evento:''}},FINANCEIRO:{FCerto:{caption:'Duplicado',evento:''}}});
  e.api.FDescModulo=' financeiro ';e.api.AbrirTela('Duplicado');
  assert.ok(e.calls.some(v=>v[0]==='create'&&v[1]==='FCerto'));
  assert.ok(!e.calls.some(v=>v[1]==='FErrado'));
});
test('APP-03 colisão Form x Caption impede efeitos',()=>{
  const e=fixture({FINANCEIRO:{FX:{caption:'X',evento:''},FY:{caption:'FX',evento:''}}});
  assert.throws(()=>e.api.AbrirTela('FX'),/ambígua/);assert.deepEqual(e.calls,[['catalog']]);
});
test('APP-04 instância existente impede evento',()=>{
  const e=fixture({FINANCEIRO:{FX:{caption:'Tela',evento:'Abrir1Click'}}});
  e.forms.set('FX',{Show(){e.calls.push(['show','same']);}});e.api.AbrirTela('Tela');
  assert.deepEqual(e.calls,[['catalog'],['show','same']]);
});
test('APP-08 falha no evento propaga sem fallback',()=>{
  const e=fixture({FINANCEIRO:{FX:{caption:'Tela',evento:'Abrir1Click'}}});
  const reflect=e.api.ExecutarMetodoDeObjeto;
  e.api.ExecutarMetodoDeObjeto=(o,m,args)=>{if(m==='Abrir1Click')throw error('ERRO-ORIGINAL');return reflect(o,m,args);};
  assert.throws(()=>e.api.AbrirTela('Tela'),/ERRO-ORIGINAL/);assert.ok(!e.calls.some(v=>v[0]==='create'));
  const p=fixture({});p.api.FormCriadoPeloNome=()=>null;
  assert.throws(()=>p.api.AbrirTela('QualquerClick'),/principal/);assert.deepEqual(p.calls,[]);
});
test('APP-02/06 chamadas consecutivas não reutilizam resolução anterior',()=>{
  const e=fixture({FINANCEIRO:{FX:{caption:'Primeira',evento:''},FY:{caption:'Segunda',evento:''}}});
  for(const alias of ['Primeira','Segunda','Primeira'])e.api.AbrirTela(alias);
  assert.deepEqual(e.calls.filter(v=>v[0]==='create').map(v=>v[1]),['FX','FY','FX']);
});
test('APP-07 metadata identifica evento sem sufixo e não executa outros métodos',()=>{
  const e=fixture({});e.api.AbrirTela(' abrirsemsufixo ');
  assert.deepEqual(e.calls,[['BringToFront'],['SetFocus'],['Repaint'],['abrirsemsufixo']]);
  assert.ok(!e.calls.some(v=>v[0]==='Abrir1Click'||v[0]==='catalog'));
});
test('APP-01 cadeia usa nome novo',()=>{
  const runner=fs.readFileSync(path.join(root,'docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_RUNNER.pas'),'utf8');
  assert.match(runner,/uses[^;]*TDD_RUN_APPLICATION/);assert.doesNotMatch(runner,/TDD_RUN_MODULO/);
});
console.log('REVISÃO INDEPENDENTE: '+groups+' grupos; execução simulada, sem ERP ou banco.');
