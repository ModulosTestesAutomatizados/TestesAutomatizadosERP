import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';
const source=fs.readFileSync(process.argv[3]??path.join(process.argv[2]??'.','docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas'),'utf8');
let part=source.slice(source.indexOf('procedure Run;')).replace(/\{[\s\S]*?\}|\/\/[^\r\n]*/g,'');
let body=part.slice(part.indexOf('\nbegin')+6).trim().replace(/end;\s*$/,'');
body=body.replace(/raise Exception.Create\(([\s\S]*?)\);/g,(_,m)=>'throw Error('+m.replace(/\s+/g,' ')+');');
body=body.replace(/if\s+([\s\S]*?)\s+then/g,(_,c)=>'if ('+c.replace(/\s+/g,' ').replace(/<>/g,'!==').replace(/\bnot\b/g,'!').replace(/\band\b/g,'&&').replace(/\bor\b/g,'||').replace(/\s=\s/g,' === ')+')');
body=body.split(/\r?\n/).map(line=>{
  line=line.trim();if(!line)return '';
  if(line==='begin')return '{';if(line==='end;')return '}';
  if(line==='try')return 'try {';if(line==='finally')return '} finally {';if(line==='except')return '} catch(Ex) {';
  if(/^on \w+: Exception do$/.test(line))return '';
  if(/^while .* do$/.test(line))return 'while ('+line.slice(6,-3).replace(/\bnot\b/g,'!')+')';
  if(line==='raise;')return 'throw Ex;';
  return line.replace(/:=/g,'=').replace(/#13/g,"'\\n'").replace(/Ex.Message/g,'Ex.message').replace(/TStringList.Create;/g,'TStringList.Create();').replace(/^([\w.]+);$/,'$1();').replace(/__CHAMADAS_METODOS__/g,'Teste();');
}).join('\n');
const create=new Function('api',`with(api) {return function(){let lMetodoAntesFinished,lErroDaExecucao,lErroPersistencia;${body}}}`);
export function scenario({closeTick=false,init=false,invalidId=false,persist=false,test=false}={}) {
  let cursor=0;const events=[];const stored=[];const history={AutoIncCasoTeste:0,AutoIncHistorico:0,MensagemErro:'',LogsProcessamento:'',StatusExecucao:''};
  const list={items:[],Add(v){this.items.push(v)},Clear(){this.items=[]},get Text(){return this.items.join('\n')}};
  const api={FHistoricoExecucao:history,FNomeMetodoAtual:'',FEtapaAtual:0,FDescModulo:'FINANCEIRO',FDescArea:'FINANCEIRO',FLogsCasoTeste:list,
    Assigned:v=>v!=null,IntToStr:String,Trim:s=>s.trim(),
    RegistrarLogEmModoDebug:s=>list.Add(s),DelimitadorLog:s=>list.Add(s),
    CDSCasosTestes:{FieldByName(){return {AsString:'Caso 28'}}},
    SetarCasoTeste(){if(invalidId)throw Error('caso invalido');history.AutoIncCasoTeste=28;},
    InicializarMetricasTickDiff(){if(init)throw Error('falha de inicializacao');},
    RegistrarTick(point){if(closeTick&&point===1&&history.StatusExecucao)throw Error('falha de tick final');},
    FCDSMetricasTickDiff:{First(){cursor=0},get Eof(){return cursor>0},Next(){cursor++},FieldByName(name){return name==='TEMPO_FIM'?{AsInteger:0}:{AsString:'TOTAL'}}},
    CallBack_AbreTela(){},CallBack_FechaTela(){events.push('fecha callback')},ClassOwner:'owner',
    Started(){list.Add('STARTED executado')},Teste(){list.Add('Teste executado');if(test)throw Error('validacao financeira');},
    RegistrarMetricas(){events.push('persistencia');if(persist)throw Error('banco indisponivel');history.LogsProcessamento=list.Text;stored.push({...history});}
  };
  try{create(api)();return {events,stored,list,history,metodo:api.FNomeMetodoAtual}}catch(error){return {events,stored,list,history,error,metodo:api.FNomeMetodoAtual}}
}
let result=scenario({closeTick:true});
assert.equal(result.stored.length,1,'Falha de tick final nao pode impedir tentativa de persistir');
assert.match(result.stored[0].LogsProcessamento,/falha de tick final/);assert.equal(result.stored[0].StatusExecucao,'FALHA');assert.ok(result.error);console.log('PASS tick final falha, registra log e tenta persistir');
result=scenario({init:true});assert.equal(result.stored.length,1);assert.match(result.stored[0].LogsProcessamento,/falha de inicializacao/);assert.ok(result.error);console.log('PASS preparacao falha com ID valido e tenta persistir');
result=scenario({test:true});assert.equal(result.error,undefined);assert.equal(result.stored[0].StatusExecucao,'FALHA');assert.match(result.stored[0].LogsProcessamento,/validacao financeira/);assert.equal(result.list.Text,'');console.log('PASS falha de teste persiste antes de limpar e permite proximo caso');
result=scenario({invalidId:true});assert.equal(result.stored.length,0);assert.ok(result.error);console.log('PASS sem ID valido nao grava historico incorreto');
result=scenario({persist:true,test:true});assert.ok(result.error);assert.match(result.error.message,/validacao financeira/);assert.match(result.error.message,/banco indisponivel/);assert.match(result.history.LogsProcessamento,/banco indisponivel/);assert.equal(result.events.filter(v=>v==='persistencia').length,1);console.log('PASS falha de persistencia informada com causa original e sem retry');
