import assert from 'node:assert/strict';
import fs from 'node:fs';
import {environment} from '../irunner-asserts-modulo/evidencias/ambiente.mjs';
import {tokens} from '../irunner-asserts-modulo/evidencias/pascal.mjs';

const e=environment(),a=e.api;
const base=fs.readFileSync('docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_UNIT_BASE_IRUNNER.pas','utf8');
let generated='',snapshot='';
Object.assign(a,{
  FTDDUnit:'TESTE',
  CodificacaoUnit:()=>base,
  Interpretar:code=>{generated=code;},
  DelimitadorLog:()=>a.FLogsCasoTeste.Add("Preparação com 'aspas' e acentuação"),
  RegistrarLog:code=>{a.FLogsCasoTeste.Add(code);snapshot=a.FLogsCasoTeste.Text;}
});
a.FParamsCasosTeste=a.TStringList.Create;
a.FParamsCasosTeste.Add("'FINANCEIRO'");a.FParamsCasosTeste.Add("'FINANCEIRO'");
e.load('docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_IRUNNER.pas',['Executar']);
a.Executar();
// The terminating semicolon can also occur inside a quoted source snapshot.
const ts=tokens(generated),start=ts.findIndex((t,i)=>t.v==='FLogsPreparacao'&&ts[i+1]?.v===':=');
const expression=[];
for(let i=start+2;i<ts.length;i++){
  if(!ts[i].str&&ts[i].v===';')break;
  expression.push(ts[i]);
}
assert.ok(expression.length>200,'exercise a full, multiline template');
assert.ok(expression.every(t=>t.str),'snapshot must use adjacent literals, without an operator chain');
assert.equal(expression.map(t=>t.v).join(''),snapshot,'preserve exact source, CR/LF, accents and quotes');
console.log('PASS snapshot completo preservado sem cadeia de operadores');
