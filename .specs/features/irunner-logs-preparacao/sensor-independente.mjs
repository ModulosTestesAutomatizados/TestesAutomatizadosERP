import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {spawnSync} from 'node:child_process';

const root=process.cwd();
const temporary=fs.mkdtempSync(path.join(os.tmpdir(),'tdd-logs-verificador-'));
const suite=path.join(root,'.specs/features/irunner-logs-preparacao/testar.mjs');
const runner='docs/assets/configuracoesGerais/arquiteturaIRunner/';
const mutants=[
  ['captura condicionada ao debug',runner+'TDD_RUN_LOGS.pas',
    '  FLogsCasoTeste.Add(pLog + #13);','  if FModoDebug then FLogsCasoTeste.Add(pLog + #13);'],
  ['perda da transferência textual',runner+'TDD_RUN_IRUNNER.pas',
    "Troca(FUnitInterpretar.Text, '__LOGS_PREPARACAO__', lLogsPreparacao)",
    "Troca(FUnitInterpretar.Text, '__LOGS_PREPARACAO__', '''''')"],
  ['perda da recomposição por caso',runner+'TDD_RUN_UNIT_BASE_IRUNNER.pas',
    '  FLogsCasoTeste.Text := FLogsPreparacao;','  // recomposição removida pelo sensor']
];
try {
  for(let i=0;i<mutants.length;i++){
    const [name,file,before,after]=mutants[i];
    const copy=path.join(temporary,String(i));
    fs.cpSync(path.join(root,'docs/assets'),path.join(copy,'docs/assets'),{recursive:true});
    const target=path.join(copy,file),source=fs.readFileSync(target,'utf8');
    assert.equal(source.split(before).length,2,'Ponto único de mutação: '+name);
    fs.writeFileSync(target,source.replace(before,after));
    const result=spawnSync(process.execPath,[suite],{cwd:root,env:{...process.env,RUN_TEST_ROOT:copy},encoding:'utf8'});
    assert.equal(result.error,undefined);
    assert.notEqual(result.status,0,'Mutante sobreviveu: '+name);
    assert.match(result.stderr,/AssertionError/,'Falha deve ser uma asserção: '+name);
    console.log('DETECTADO '+name);
  }
  console.log('SENSOR: 3 mutantes detectados em cópias temporárias; fontes reais preservados.');
} finally {
  const checked=path.resolve(temporary),parent=path.resolve(os.tmpdir());
  assert.equal(path.dirname(checked),parent);
  assert.ok(path.basename(checked).startsWith('tdd-logs-verificador-'));
  fs.rmSync(checked,{recursive:true,force:true});
}
