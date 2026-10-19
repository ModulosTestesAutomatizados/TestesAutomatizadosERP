import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import {spawnSync} from 'node:child_process';
const root=process.cwd(),temp=fs.mkdtempSync(path.join(os.tmpdir(),'tdd-application-sensor-'));
const app='docs/assets/configuracoesGerais/arquiteturaIRunner/P39_TDD_RUN_APPLICATION.pas';
const helper='docs/assets/snippets/TDD_MAPEAMENTO_EVENTOS.pas';
const files=[app,helper,'docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_APPLICATION_MAPEAMENTO_JSON.json','docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_RUNNER.pas','docs/assets/casosTestesFinanceiro/TDD_FIN_FINANCEIRO.pas'];
const mutants=[
  ['aceitar ambiguidade',app,'if lEncontrados > 1 then','if lEncontrados > 999 then'],
  ['ignorar Form existente',app,'lForm := FormCriadoPeloNome(lNomeForm);','lForm := nil;'],
  ['fechar Form preexistente',helper,'or (FFormsAntes.IndexOf(lNome) >= 0)','or (FFormsAntes.IndexOf(lNome) < -999)'],
];
try{
  for(const [name,file,before,after] of mutants){
    for(const f of files){const dest=path.join(temp,f);fs.mkdirSync(path.dirname(dest),{recursive:true});fs.copyFileSync(path.join(root,f),dest);}
    const target=path.join(temp,file),text=fs.readFileSync(target,'utf8');assert.ok(text.includes(before),'mutação deve atingir fonte');fs.writeFileSync(target,text.replace(before,after));
    const run=spawnSync(process.execPath,[path.join(root,'.specs/features/irunner-application/testar.mjs')],{env:{...process.env,RUN_TEST_ROOT:temp},encoding:'utf8'});
    assert.notEqual(run.status,0,'mutante sobreviveu: '+name);assert.match(run.stderr,/AssertionError|ambígua|não aberto/,'falha deve ser comportamental');console.log('MORTO '+name);
  }
  console.log('SENSOR: 3 mutantes de comportamento mortos; fontes reais preservados.');
}finally{
  assert.ok(path.resolve(temp).startsWith(path.resolve(os.tmpdir())+path.sep));
  assert.ok(path.basename(temp).startsWith('tdd-application-sensor-'));
  fs.rmSync(temp,{recursive:true,force:true});
}
