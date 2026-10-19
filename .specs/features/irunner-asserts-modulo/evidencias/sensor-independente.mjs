import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import {spawnSync} from 'node:child_process';
import assert from 'node:assert/strict';
import {createHash} from 'node:crypto';
const root=process.cwd(),base=fs.mkdtempSync(path.join(os.tmpdir(),'irunner-verifier-'));
const cases=[
 ['maior-inclusivo','docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_VALIDAR_RESULTADO.pas','pValorReal > pValorEsperado','pValorReal >= pValorEsperado'],
 ['status-incondicional','docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_UNIT_BASE_IRUNNER.pas','if AssertsOk then','if True then'],
 ['descarta-relatorio','docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_FINISHED.pas','FMetricasAsserts.ResultadoObtido := FResultados.Text;','FMetricasAsserts.ResultadoObtido := \'\';'],
];
const porcelain=()=>spawnSync('git',['status','--porcelain'],{cwd:root,encoding:'utf8'}).stdout;
const originalPorcelain=porcelain();
const digest=file=>createHash('sha256').update(fs.readFileSync(path.join(root,file))).digest('hex');
const originalHashes=cases.map(([,file])=>digest(file));
try{
 for(const [name,file,before,after] of cases){
  const scratch=path.join(base,name);fs.mkdirSync(scratch);fs.cpSync(path.join(root,'docs/assets'),path.join(scratch,'docs/assets'),{recursive:true});
  const target=path.join(scratch,file),original=fs.readFileSync(target,'utf8');assert.ok(original.includes(before),name+' alvo existente');fs.writeFileSync(target,original.replace(before,after));
  let killed=false;
  for(const test of ['testar.mjs','verificar-independente.mjs']){
   const run=spawnSync(process.execPath,[path.join(root,'.specs/features/irunner-asserts-modulo/evidencias',test)],{env:{...process.env,RUN_TEST_ROOT:scratch},encoding:'utf8'});
   if(run.status!==0){killed=true;console.log('KILLED '+name+' por '+test);break;}
  }
  assert.ok(killed,'SURVIVED '+name);
 }
}finally{
 const resolved=path.resolve(base),prefix=path.resolve(os.tmpdir())+path.sep;
 assert.ok(resolved.startsWith(prefix)&&path.basename(resolved).startsWith('irunner-verifier-'));
 fs.rmSync(resolved,{recursive:true,force:true});
}
assert.deepEqual(cases.map(([,file])=>digest(file)),originalHashes,'Fontes reais preservados');
assert.equal(porcelain(),originalPorcelain,'Porcelain real preservado pelo sensor');
console.log('SENSOR: 3/3 mutações detectadas; apenas cópias temporárias modificadas.');
