import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';
const root=process.argv[2]??'.';
const read=file=>fs.readFileSync(path.join(root,'docs/assets/emDesenvolvimento/Runner',file),'utf8');
function translate(body) {
  return body.replace(/\{[\s\S]*?\}|\/\/[^\r\n]*/g,'').split(/\r?\n/).map(line=>{
    line=line.trim();if(!line)return '';
    if(line==='begin')return '{';if(line==='end;')return '}';
    if(/^if .* then$/.test(line))return 'if ('+line.slice(3,-5).replace(/\bnot\b/g,'!')+')';
    return line.replace(/TStringList.Create;/g,'TStringList.Create();').replace(/:=/g,'=').replace(/#13/g,"'\\n'");
  }).join('\n');
}
// Sonda do logger real extraido, com TStringList substituida por lista JS.
const logger=read('TDD_LOGS.pas').match(/procedure RegistrarLogEmModoDebug\(pLog :string\);\s*begin([\s\S]*?)\nend;/)[1];
const capture=new Function('api','pLog',`with(api){${translate(logger)}}`);
const newList=()=>({items:[],Add(text){this.items.push(text)},get Text(){return this.items.join('\n')},Clear(){this.items=[]}});
for(const debug of [false,true]) {
  const api={FModoDebug:debug,FLogsCasoTeste:null,Assigned:v=>v!=null,TStringList:{Create:newList}};
  capture(api,'Iniciando caso 28');capture(api,'Falha de validacao');
  if (debug) {
    assert.match(api.FLogsCasoTeste.Text,/Iniciando caso 28/);assert.match(api.FLogsCasoTeste.Text,/Falha de validacao/);
  } else {
    assert.equal(api.FLogsCasoTeste.Text,'');
  }
  console.log('PASS respeita modo debug '+debug);
}
const finished=read('TDD_FINISHED.pas');
const method=finished.slice(finished.indexOf('procedure RegistrarMetricas;'));
let prefix=method.slice(method.indexOf('\nbegin')+6,method.indexOf("lSQL := 'INSERT INTO HISTORICO_EXECUCAO"));
prefix=prefix.replace(/\btry\s*$/,'');
const snapshot=new Function('api',`with(api){${translate(prefix)}}`);
for(const status of ['SUCESSO','FALHA','VERSAO_INCOMPATIVEL']) {
  const list=newList();list.Add('Log do caso 28: '+status);
  const history={StatusExecucao:status,LogsProcessamento:''};
  snapshot({FLogsCasoTeste:list,FHistoricoExecucao:history,Assigned:v=>v!=null});
  list.Clear();assert.equal(history.LogsProcessamento,'Log do caso 28: '+status);
  console.log('PASS snapshot antes do INSERT para '+status+' sobrevive ao Clear');
}
