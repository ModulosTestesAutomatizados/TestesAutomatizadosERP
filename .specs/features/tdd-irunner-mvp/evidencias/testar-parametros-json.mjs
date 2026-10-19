import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';
const root = process.argv[2] ?? process.cwd();
const source = fs.readFileSync(process.argv[4] ?? path.join(root, 'docs/assets/emDesenvolvimento/Runner/TDD_STARTED.pas'), 'utf8');
const matched = source.match(/function ObterParametrosDoCasoTeste\(pJson :string\) :string;[\s\S]*?\nbegin\r?\n([\s\S]*?)\nend;/);
// Sonda da rotina extraida: usa JSON.parse como substituto do parser nativo.
// Nao executa JvInterpreter nem aplica parametros no ERP.
let read;
if (!matched) {
  assert.match(source, /GetObjectJson\(FCasoTesteAtualJson, 'parametros'\)/);
  read = text => {
    if (!text.trim() || text.trim() === '{}') return '';
    const obj = JSON.parse(text);
    if (!Object.hasOwn(obj, 'parametros')) throw Error("Value 'parametros' not found");
    return JSON.stringify(obj.parametros);
  };
} else {
  let body = matched[1].replace(/\/\/[^\r\n]*/g, '');
  const expr = text => text.replace(/<>/g, '!==').replace(/\bnot\b/g, '!').replace(/\s=\s/g, ' === ');
  body = body.split(/\r?\n/).map(line => {
    line = line.trim();
    if (!line) return '';
    if (line === 'begin') return '{';
    if (line === 'end;') return '}';
    if (line === 'try') return 'try {';
    if (line === 'finally') return '} finally {';
    if (line === 'Exit;') return 'return Result;';
    if (/^if .* then$/.test(line)) return 'if (' + expr(line.slice(3, -5)) + ')';
    const loop = line.match(/^for (\w+) := (.*?) to (.*?) do$/);
    if (loop) return `for (${loop[1]} = ${loop[2]}; ${loop[1]} <= ${loop[3]}; ${loop[1]}++)`;
    return line.replace(/raise Exception.Create\((.*)\);/, 'throw Error($1);').replace(/:=/g, '=').replace(/\bnil\b/g, 'null');
  }).join('\n');
  const compile = new Function('api', `const {Trim,Copy,Assigned,TJSONObject,ExecutarMetodoDeObjeto,GetPairName,GetPairValue,MensagemPersonalizada} = api; return function(pJson) { let Result,lTexto,lObj,lIndice,lPair; ${body}\nreturn Result; }`);
  read = compile({
    Trim: value => value.trim(), Copy: (v,start,len) => v.slice(start-1,start-1+len), Assigned: v => v != null,
    MensagemPersonalizada: '', TJSONObject: {ParseJSONValue: text => { try { const obj=JSON.parse(text); return {Count:Object.keys(obj).length,pairs:Object.entries(obj),Free(){}}; } catch {return null;} }},
    ExecutarMetodoDeObjeto: (obj,method,args) => {assert.equal(method,'GetPair'); return obj.pairs[args[0]];},
    GetPairName: pair => pair[0], GetPairValue: pair => JSON.stringify(pair[1])
  });
}
const cases = [
  ['ausente no JSON financeiro','{"EMPRESA_DUP":1,"TIPODOC_DUP":1}',''],
  ['objeto vazio','{}',''], ['texto vazio',' ',''],
  ['parametros vazio','{"parametros":{}}','{}'],
  ['parametros preenchido','{"parametros":{"A":1,"B":"S"}}','{"A":1,"B":"S"}'],
  ['JSON formatado','{\n "parametros": {"A":1}\n}','{"A":1}'],
  ['parametros somente dentro de outro objeto','{"outro":{"parametros":{"A":1}}}','']
];
for (const [name,text,want] of cases) { assert.equal(read(text),want,name); console.log('PASS '+name); }
for (const text of ['{invalid','[]','{"parametros":null}','{"parametros":"texto"}','{"parametros":[]}']) {assert.throws(()=>read(text),'JSON ou secao invalida precisa falhar');}
console.log('PASS rejeita JSON e secao invalidos');
if (process.argv[3]) {
  const fixture=fs.readFileSync(process.argv[3],'utf8');
  const params=JSON.parse(read(fixture));
  assert.deepEqual(params, {
    NecessarioAutorizarPagamentos:false,
    NecessarioAutorizarAdiantamentos:false,
    ObrigatorioGrupoResultadoDiferenteDeZeroNaDuplicata:true,
    OcultarDuplicataPagarSalario:false,
    BloquearLancamentoBorderoQualificacao0Todas:false,
    BorderoExigirPreenchimentoRegraIntegracaoContabil:false
  });
  console.log('PASS seis parametros do JSON financeiro informado pelo usuario');
}
