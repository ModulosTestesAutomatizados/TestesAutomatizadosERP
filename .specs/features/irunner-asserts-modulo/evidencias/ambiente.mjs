import {compile} from './pascal.mjs';
import fs from 'node:fs';import path from 'node:path';
export const error=m=>Object.assign(Error(m),{Message:m});
export function list(){const obj={rows:[],Objects:[],Add(v){this.rows.push(v);return this.rows.length-1;},AddObject(v,o){this.Objects.push(o);return this.Add(v);},IndexOf(v){return this.rows.indexOf(v);},Delete(i){this.rows.splice(i,1);this.Objects.splice(i,1);},Clear(){this.rows=[];this.Objects=[];},Free(){this.freed=true;},get Count(){return this.rows.length;},get Text(){return this.rows.join('\r\n');},set Text(v){this.rows=v.split(/\r?\n/);}};return new Proxy(obj,{get:(o,k)=>/^\d+$/.test(String(k))?o.rows[+k]:Reflect.get(o,Object.keys(o).find(n=>n.toLowerCase()===String(k).toLowerCase())??k)});}
export function dataset(rows=[]){return {rows:structuredClone(rows),RecNo:1,Active:true,State:1,freed:false,
  get Data(){return structuredClone(this.rows);},set Data(v){this.rows=structuredClone(v);this.Active=true;},
  get RecordCount(){return this.rows.length;},get IsEmpty(){return !this.rows.length;},get Eof(){return this.RecNo>this.rows.length;},First(){this.RecNo=1;},Next(){this.RecNo++;},
  Delete(){this.rows.splice(this.RecNo-1,1);},Free(){this.freed=true;},Close(){this.Active=false;this.rows=[];},
  FindField(name){return this.rows[this.RecNo-1]&&Object.hasOwn(this.rows[this.RecNo-1],name)?this.FieldByName(name):null;},
  FieldByName(name){const owner=this;return {FieldName:name,get IsNull(){return owner.rows[owner.RecNo-1][name]==null;},get AsString(){return String(owner.rows[owner.RecNo-1][name]??'');},set AsString(v){owner.rows[owner.RecNo-1][name]=v;},get AsInteger(){return owner.rows[owner.RecNo-1][name]??0;},set AsInteger(v){owner.rows[owner.RecNo-1][name]=v;}};},
  FindKey([key]){const i=this.rows.findIndex(r=>r.ID===key||r.NOME_METODO===key);if(i<0)return false;this.RecNo=i+1;return true;},
  Locate(fields,values){const i=this.rows.findIndex(r=>fields.split(';').every((n,j)=>r[n]===values[j]));if(i<0)return false;this.RecNo=i+1;return true;},
  Edit(){},Post(){},Insert(){this.rows.push({});this.RecNo=this.rows.length;}};}
function json(value){return {value,get Count(){return Array.isArray(value)?value.length:Object.keys(value).length;},pairs:Object.entries(value),Items(i){return json(value[i]);},get ToJson(){return JSON.stringify(value);},Free(){this.freed=true;}};}
export function environment(){
  const log=[],histories=[],assertRows=[],tickRows=[],sources={};
  const api={FAssertsTotal:0,FAssertsPass:0,FAssertsFail:0,FErrosReais:0,FTempoExecucaoMs:0,FFalhas:null,FDataSets:null,FResultados:null,FModoDebug:true,FLogsCasoTeste:list(),FLogsPreparacao:'',FEtapaAtual:0,FNomeMetodoAtual:'',FTempoBaseTick:2834258000,GetTickCount:2834258010,FCasoTesteAtualId:28,FCasoTesteAtualJson:'{}',FDescModulo:'FINANCEIRO',FDescArea:'FINANCEIRO',FModulo:1,FContextoCasoTeste:{},FHistoricoExecucao:{AutoIncCasoTeste:28,MensagemErro:'',StatusExecucao:''},FMetricasAsserts:{},
    cPulada:'ASSERTS: PULADO - ',cFalha:'ASSERTS: FALHOU - ',cOperacaoIgual:0,cOperacaoMaior:1,cOperacaoMenor:2,
    JSONFormatado:s=>JSON.stringify(JSON.parse(s),null,2),Trim:s=>s.trim(),UpperCase:s=>s.toUpperCase(),LowerCase:s=>s.toLowerCase(),Length:s=>s.length,IntToStr:String,CurrToStr:String,FloatToStr:String,VarToStr:v=>String(v??''),QuotedStr:v=>"'"+v.replaceAll("'","''")+"'",Pos:(a,b)=>b.indexOf(a)+1,Copy:(s,start,len)=>s.slice(start-1,start-1+len),Troca:(s,a,b)=>s.split(a).join(b),CorteAte:(s,c)=>s.includes(c)?s.slice(0,s.indexOf(c)):s,CorteApos:(s,c)=>s.includes(c)?s.slice(s.indexOf(c)+1):'',Assigned:v=>v!=null,iif:(c,a,b)=>c?a:b,VarArrayOf:v=>v,Round:Math.round,TickDiff:(a,b)=>b-a,
    Exception:{Create:error},TStringList:{get Create(){return list();}},TClientDataSet:Object.defineProperty(v=>v,'Create',{get:()=>dataset()}),
    StrToInt:s=>{if(!/^[+-]?\d+$/.test(s.trim())||+s>2147483647||+s< -2147483648)throw error('Inteiro inválido');return +s;},
    StrToFloat:s=>{if(!/^[+-]?(?:\d+(?:[.,]\d*)?|[.,]\d+)$/.test(s.trim()))throw error('Número inválido');return +s.replace(',','.');},
    StrToDateTime:s=>{const v=Date.parse(s);if(!Number.isFinite(v))throw error('Data inválida');return v;},
    TJSONObject:{ParseJSONValue:s=>{try{return json(JSON.parse(s));}catch{return null;}}},TJSONArray:v=>v,
    ExecutarMetodoDeObjeto:(obj,m,args)=>{if(m==='GetPair')return obj.pairs[args[0]];throw error(m);},GetPairName:p=>p[0],GetPairValue:p=>JSON.stringify(p[1]),
    GetValueJson:(text,tag)=>{const v=JSON.parse(text)[tag];if(v===undefined)throw error('Tag ausente: '+tag);if(v!==null&&typeof v==='object')throw error('Objeto não é escalar');return v==null?'':String(v);},
    RegistrarLog:text=>{api.FLogsCasoTeste.Add(text);log.push(text);},DelimitadorLog:text=>api.RegistrarLog(text),
    TDDScalarODBCP:(sql,params)=>{if(api.failHistory)throw error('histórico indisponível');histories.push([...params]);return 96;},
    TDDCommandODBCP:(sql,params)=>{if(sql.includes('METRICAS_ASSERTS')){if(api.failAsserts)throw error('asserts indisponível');assertRows.push([...params]);}else tickRows.push([...params]);},
  };
  api.GetValueJsonDef=(s,tag,fallback)=>{try{return api.GetValueJson(s,tag);}catch{return fallback;}};
  api.LogDoProcessamentoAdd=text=>log.push(text);
  api.CDSCasosTestes=dataset([{ID:28,DESCRICAO:'Caso 28',REQUISITOVERSAO:'160.00',CASOTESTE:'{}'}]);api.CDSResultadoEsperado=dataset([]);api.FCDSMetricasTickDiff=dataset([]);
  const load=(file,names)=>{const s=fs.readFileSync(path.join(process.env.RUN_TEST_ROOT??process.cwd(),file),'utf8');sources[file]=s;for(const name of names){const fn=compile(s,name,api);if(/^(AssertsTotal|AssertsPass|AssertsFail|AssertsOk|AssertsResumo)$/.test(name))Object.defineProperty(api,name,{get:()=>fn(),configurable:true});else api[name]=fn;}return s;};
  return {api,log,histories,assertRows,tickRows,load,sources};
}
