import fs from 'node:fs';import path from 'node:path';import os from 'node:os';import assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';import {createHash} from 'node:crypto';
const root=process.cwd(),base=fs.mkdtempSync(path.join(os.tmpdir(),'sync-verifier-'));
const registration='docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas';
const cases=[
 ['recusa-ainda-carrega-fonte',registration,'if lCodigoCasoTeste < 0 then','if false then'],
 ['resultado-vazio-usa-minimo',registration,"'P39_TDD_ASSERTS_JSON_MINIMO', false);","'P39_TDD_ASSERTS_JSON_MINIMO', true);"],
 ['retorno-perde-tag',registration,`Result := '{"' + pPropriedade + '":' + lValor + '}';`, 'Result := lValor;'],
 ['objeto-vazio-reprova','docs/assets/emDesenvolvimento/P39_TDD_VALIDAR_RESULTADO.pas','if lObjeto.Count = 0 then','if False then'],
];
const porcelain=()=>spawnSync('git',['status','--porcelain'],{cwd:root,encoding:'utf8'}).stdout;
const baseline=porcelain(),hash=file=>createHash('sha256').update(fs.readFileSync(path.join(root,file))).digest('hex'),before=cases.map(([,file])=>hash(file));
try{
 for(const [name,file,original,replacement] of cases){
  const scratch=path.join(base,name);fs.mkdirSync(scratch);fs.cpSync(path.join(root,'docs/assets'),path.join(scratch,'docs/assets'),{recursive:true});
  const target=path.join(scratch,file),text=fs.readFileSync(target,'utf8');assert.ok(text.includes(original),'Alvo da mutação existe: '+name);fs.writeFileSync(target,text.replace(original,replacement));
  let killed=false;
  for(const test of ['testar.mjs','verificar-independente.mjs','testar-confirmacao.mjs']){
   const run=spawnSync(process.execPath,[path.join(root,'.specs/features/sincronizacao-fonte-unica/evidencias',test)],{env:{...process.env,RUN_TEST_ROOT:scratch},encoding:'utf8'});
   if(run.status!==0){assert.match(run.stderr,/AssertionError/,'Deve falhar por contrato, não por infraestrutura: '+name);killed=true;console.log('KILLED '+name+' por '+test);break;}
  }
  assert.ok(killed,'Mutação não detectada: '+name);
 }
}finally{
 const resolved=path.resolve(base);assert.ok(resolved.startsWith(path.resolve(os.tmpdir())+path.sep)&&path.basename(resolved).startsWith('sync-verifier-'));fs.rmSync(resolved,{recursive:true,force:true});
}
assert.deepEqual(cases.map(([,file])=>hash(file)),before);assert.equal(porcelain(),baseline);
console.log('SENSOR: 4/4 mutações mortas; hashes e porcelain da árvore real preservados.');
