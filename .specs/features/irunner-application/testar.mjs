import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import {environment,list,error} from '../irunner-asserts-modulo/evidencias/ambiente.mjs';
const root=process.env.RUN_TEST_ROOT??process.cwd();
const base='docs/assets/configuracoesGerais/arquiteturaIRunner/';
const application=base+'P39_TDD_RUN_APPLICATION.pas';
const helper='docs/assets/snippets/TDD_MAPEAMENTO_EVENTOS.pas';
const financial='docs/assets/casosTestesFinanceiro/TDD_FIN_FINANCEIRO.pas';
let groups=0;
function test(name,fn){fn();groups++;console.log('PASS '+name);}
function setup(catalog){
  const e=environment(),a=e.api,calls=[],forms=new Map(),principal={Name:'FPrincipal'};
  const reflection=a.ExecutarMetodoDeObjeto;
  let source=catalog??fs.readFileSync(path.join(root,base+'TDD_RUN_APPLICATION_MAPEAMENTO_JSON.json'),'utf8');
  Object.assign(a,{cFP:'FPrincipal',FP:null,MetodosDeObjeto:()=>"Receber1Click(Sender: TObject)\r\nOutro1Click(Sender: TObject)\r\nEventoSemSufixo(Sender: TObject)",
    FormCriadoPeloNome:name=>name==='FPrincipal'?principal:forms.get(name),
    CriarFormPeloNome:name=>{calls.push(['criar',name]);const form={Show(){calls.push(['show',name]);}};forms.set(name,form);return form;},
    CodificacaoUnit:name=>{assert.equal(name,'P39_TDD_RUN_APPLICATION_MAPEAMENTO_JSON');calls.push(['catalogo']);return source;},
    ExecutarMetodoDeObjeto:(obj,method,args)=>{if(method==='GetPair')return reflection(obj,method,args);calls.push([method,args]);if(method==='Receber1Click')forms.set('FCadReceber',{Show(){calls.push(['show','FCadReceber']);}});},
    RegistrarLog:text=>calls.push(['log',text])});
  e.load(application,['AbrirTela','FocarModulo','TrazerParaFrente']);
  return {...e,calls,forms,principal,setSource(v){source=v;}};
}
test('APP-02/05 Caption e Form resolvem evento no módulo atual',()=>{
  for(const alias of ['Contas a Receber',' contas a receber ','Contas a &Receber','FCadReceber','fcadreceber']){
    const e=setup();e.api.AbrirTela(alias);
    assert.deepEqual(e.calls.filter(v=>['BringToFront','SetFocus','Repaint','Receber1Click','show','criar'].includes(v[0])).map(v=>v[0]),['BringToFront','SetFocus','Repaint','Receber1Click','show']);
    assert.equal(e.calls.find(v=>v[0]==='Receber1Click')[1][0],e.principal);
    assert.match(e.calls.find(v=>v[0]==='log')[1],/FCadReceber.*Receber1Click/);
  }
});
test('APP-04/06 Form conhecido reutiliza ou cria a instância esperada',()=>{
  const e=setup();e.api.AbrirTela('FCadPagar');assert.deepEqual(e.calls.filter(v=>['criar','show'].includes(v[0])),[['criar','FCadPagar'],['show','FCadPagar']]);
  e.calls.length=0;e.api.AbrirTela('FCadPagar');assert.deepEqual(e.calls.filter(v=>v[0]!=='catalogo'),[['show','FCadPagar']]);
  const r=setup();r.forms.set('FCadReceber',{Show(){r.calls.push(['show','existente']);}});r.api.AbrirTela('Contas a Receber');assert.deepEqual(r.calls.filter(v=>v[0]!=='catalogo'),[['show','existente']]);
});
test('APP-03/08 alias ambíguo, módulo diferente e JSON inválido não abrem telas',()=>{
  for(const text of ['{','[]','{"OUTRO":{}}','{"FINANCEIRO":null}','{"FINANCEIRO":{"FA":null}}','{"FINANCEIRO":{"FA":{"caption":"X","evento":""},"FB":{"caption":"X","evento":""}}}']){
    const e=setup(text);assert.throws(()=>e.api.AbrirTela('X'));assert.deepEqual(e.calls,[['catalogo']]);
  }
  const e=setup();assert.throws(()=>e.api.AbrirTela('Inexistente'),/não mapeada/);assert.deepEqual(e.calls,[['catalogo']]);
  const f=setup();f.api.FModulo=0;assert.throws(()=>f.api.AbrirTela('FCadPagar'),/Módulo/);assert.deepEqual(f.calls,[]);
});
test('APP-07 evento direto não depende do catálogo',()=>{
  const e=setup('inválido');e.api.AbrirTela('Outro1Click');e.api.AbrirTela('EventoSemSufixo');assert.equal(e.calls.at(-1)[0],'EventoSemSufixo');e.api.AbrirTela('Outro1Click');assert.ok(!e.calls.some(v=>v[0]==='catalogo'));assert.deepEqual(e.calls.at(-1),['Outro1Click',[e.principal]]);
});
test('APP-08 evento não abre Form: falha sem criação silenciosa',()=>{
  const e=setup();const original=e.api.ExecutarMetodoDeObjeto;e.api.ExecutarMetodoDeObjeto=(obj,method,args)=>method==='GetPair'?original(obj,method,args):e.calls.push([method,args]);
  assert.throws(()=>e.api.AbrirTela('Contas a Receber'),/FCadReceber.*Receber1Click/);assert.ok(!e.calls.some(v=>v[0]==='criar'));
});
test('APP-09 piloto encaminha os quatro destinos antes dos mapeamentos',()=>{
  for(const [method,type,expected] of [['_IncluirDuplicata',0,'EVENTO_INCLUIR_DUPLICATA_RECEBER'],['_IncluirDuplicata',1,'EVENTO_INCLUIR_DUPLICATA_PAGAR'],['_IncluirBordero',0,'EVENTO_INCLUIR_BORDERO_RECEBIMENTO'],['_IncluirBordero',1,'EVENTO_INCLUIR_BORDERO_PAGAMENTO']]){
    const e=environment(),a=e.api;const stop=error('ABERTURA-OBSERVADA'),seen=[];
    Object.assign(a,{cFormReceber:'FCadReceber',cFormPagar:'FCadPagar',cDMCadDuplicata:'DMCadDuplicata',FormCriadoPeloNome:()=>null,AbrirTela:value=>{seen.push(value);throw stop;}});
    e.load(financial,[method]);assert.throws(()=>a[method](type),/ABERTURA-OBSERVADA/);assert.deepEqual(seen,[expected]);
  }
});
function collector(){
  const e=environment(),a=e.api,events=[],closed=[],rows=[],re={Lines:list()},menu={Caption:'&Contas a Receber'},principal={FindComponent:n=>n==='RichEdit1'?re:n==='Receber1'?menu:null};
  re.Lines.Text='texto anterior';let listed=0,display;
  Object.assign(a,{cFP:'FPrincipal',cEvento:'Receber1Click',cComponenteMenu:'Receber1',FP:null,RE:null,FFormsAntes:null,FFormsAbertos:null,FCaptionMenu:'',CDS:null,ftString:1,
    ValorPropriedadeDeObjeto:(o,k)=>o[k],CorteEntre:(s,start,end)=>s.slice(s.indexOf(start)+start.length,s.indexOf(end)),
    FormCriadoPeloNome:n=>n==='FPrincipal'?principal:{Close(){closed.push(n);}},
    ExecutarMetodoDeObjeto:(o,m)=>{events.push(m);if(m==='ListarFormulriosAbertos1Click'){re.Lines.Text='- FExistente (TForm)\r\n- DMConexao (TDataModule)'+(listed++?'\r\n- FCadReceber (TForm)':'');}},
    MostrarLogTexto(){},MostrarCDS:()=>{display=structuredClone(rows);},
    TClientDataSet:{get Create(){return {FieldDefs:{Clear(){},Add(){}},CreateDataSet(){},InsertRecord:r=>rows.push(r),get IsEmpty(){return rows.length===0;},Free(){}};}}});
  e.load(helper,['Main','ListarFormsAbertos','PegarConfiguracoesForm']);
  return {...e,events,closed,re,principal,getRows:()=>display};
}
test('APP-10/11 helper chama seleção, usa Caption do menu e preserva telas anteriores',()=>{
  const e=collector();e.api.Main();assert.deepEqual(e.events,['ListarFormulriosAbertos1Click','Receber1Click','ListarFormulriosAbertos1Click']);assert.deepEqual(e.getRows(),[['Receber1Click','FCadReceber','&Contas a Receber']]);assert.deepEqual(e.closed,['FCadReceber']);assert.equal(e.re.Lines.Text,'texto anterior');
  const f=collector();f.principal.FindComponent=()=>null;assert.throws(()=>f.api.Main(),/menu não encontrado/);assert.deepEqual(f.events,[]);
});
console.log('GATE LOCAL: '+groups+' grupos; APIs substituídas, sem ERP, menus reais ou banco.');
