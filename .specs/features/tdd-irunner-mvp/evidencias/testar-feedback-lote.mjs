import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';
const source=fs.readFileSync(process.argv[3] ?? path.join(process.argv[2] ?? '.', 'docs/assets/emDesenvolvimento/Runner/TDD_BASE_UNIT_IRUNNER.pas'),'utf8');
function procedure(name) {
  const start=source.indexOf('procedure '+name);
  const next=source.indexOf('\nprocedure ',start+1);
  let part=source.slice(start,next<0?source.length:next);
  part=part.replace(/\{[\s\S]*?\}|\(\*[\s\S]*?\*\)|\/\/[^\r\n]*/g,'');
  const body=part.slice(part.indexOf('\nbegin')+6).trim().replace(/end;\s*$/,'').replace(/raise Exception.Create\(([\s\S]*?)\);/g, (_,message)=>'throw Error('+message.replace(/\s+/g,' ')+');');
  const expr=s=>s.replace(/<>/g,'!==').replace(/\bnot\b/g,'!').replace(/\band\b/g,'&&').replace(/\bor\b/g,'||').replace(/\s=\s/g,' === ').replace(/#13/g,"'\\n'");
  return body.split(/\r?\n/).map(line=>{
    line=line.trim(); if(!line)return '';
    if(line==='begin')return '{'; if(line==='end;')return '}';
    if(line==='try')return 'try {';
    if(line==='finally')return '} finally {';
    if(line==='except')return '} catch(Ex) {';
    if(/^on \w+: Exception do$/.test(line))return '';
    if(/^if .* then$/.test(line))return 'if ('+expr(line.slice(3,-5))+')';
    if(/^while .* do$/.test(line))return 'while ('+expr(line.slice(6,-3))+')';
    if(line==='raise;')return 'throw Ex;';
    line=expr(line).replace(/:=/g,'=').replace(/raise Exception.Create\((.*)\);/,'throw Error($1);').replace(/Ex.Message/g,'Ex.message');
    line=line.replace(/^([\w.]+);$/,'$1();').replace(/__PARAMETROS_CASO_TESTE__/g,"'FINANCEIRO','FINANCEIRO'");
    return line;
  }).join('\n');
}
// Sonda das procedures Main/ExecutarLote extraidas. Run, CDS, callbacks e
// persistencia sao substituidos: nao executa o ERP nem o JvInterpreter.
const create=new Function('api',`with(api) { return function() { let lTentados,lCasosFalhos,lFalhas; function ExecutarLote(pDescricaoModulo,pDescricaoArea) { ${procedure('ExecutarLote')} } ${procedure('Main')} }; }`);
function scenario(cases,{fatal=false,setup=false,cleanup=false}={}) {
  const events=[]; let index=0;
  const history={};
  const api={FHistoricoExecucao:history,MensagemPersonalizada:'[PERSONALIZADA]',IntToStr:String,Trim:v=>v.trim(),Assigned:v=>v!=null,
    CDSCasosTestes:{RecordCount:cases.length,First(){index=0;},get Eof(){return index>=cases.length;},Next(){index++;}},
    SetupCasosTestes(){if(setup)throw Error('falha de carga');},
    DelimitadorLog(){},RegistrarLogEmModoDebug(){},
    Run(){const item=cases[index];events.push('caso '+item.id); history.AutoIncCasoTeste=item.id;history.StatusExecucao=item.status;history.MensagemErro=item.error??'';if(fatal)throw Error('falha de persistencia');},
    LiberarMetricasTickDiff(){events.push('limpeza');if(cleanup)throw Error('falha de limpeza');},
    TearDown_FinalizarParametros(){},Cache_TearDown_LimparInformacoes(){},TearDown_Finalizar_CasosTeste(){},FLogsCasoTeste:{Free(){}}
  };
  try {create(api)();return {events};}catch(error){return {events,error};}
}
const failed={id:28,status:'FALHA',error:'Falha no caso ID 28, método IRUNNER: Caso financeiro inválido: PESSOA_DUP, VALOR_DUP, GRUPORESULTADO_DUPGR'};
const success={id:29,status:'SUCESSO'};
let result=scenario([failed,success]);
assert.deepEqual(result.events,['caso 28','caso 29','limpeza']);
assert.ok(result.error,'Lote com falha registrada precisa apresentar feedback');
assert.match(result.error.message,/1 caso\(s\) com falha/);
assert.match(result.error.message,/ID 28/);
assert.equal(result.error.message.split('[PERSONALIZADA]').length-1,1);
console.log('PASS continua apos falha, limpa recursos e apresenta resumo com um prefixo');
result=scenario([success]);assert.equal(result.error,undefined);console.log('PASS lote aprovado sem erro');
result=scenario([failed,{id:33,status:'VERSAO_INCOMPATIVEL',error:'Falha no caso ID 33: versão incompatível'},success]);
assert.match(result.error.message,/2 caso\(s\) com falha/);assert.match(result.error.message,/ID 28/);assert.match(result.error.message,/ID 33/);console.log('PASS agrega falhas de teste e versao sem perder detalhes');
for(const option of ['fatal','setup','cleanup']) {
  result=scenario([success,success],{[option]:true});assert.ok(result.error);assert.equal(result.error.message.split('[PERSONALIZADA]').length-1,1);
  if(option==='fatal')assert.deepEqual(result.events,['caso 29','limpeza']);
  console.log('PASS falha de infraestrutura '+option+' apresentada uma vez');
}


result=scenario([{id:40,status:'FALHA',error:''},success]);
assert.match(result.error.message,/Caso ID 40: FALHA/);console.log('PASS falha sem mensagem recebe ID e status');
result=scenario([]);assert.equal(result.error,undefined);assert.deepEqual(result.events,['limpeza']);console.log('PASS lote vazio encerra normalmente');
