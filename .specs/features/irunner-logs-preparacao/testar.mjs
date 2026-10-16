import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import {environment,dataset,list,error} from '../irunner-asserts-modulo/evidencias/ambiente.mjs';
import {compile} from '../irunner-asserts-modulo/evidencias/pascal.mjs';
const root=process.env.RUN_TEST_ROOT??process.cwd();
const dir='docs/assets/emDesenvolvimento/Runner/';
const read=p=>fs.readFileSync(path.join(root,p),'utf8');
let count=0;
function test(name,run){run();console.log('PASS '+name);count++;}
function logger(e){
  const displayed=[];e.api.MostrarLogTexto=(...args)=>displayed.push(args);
  e.load(dir+'TDD_RUN_LOGS.pas',['RegistrarLog','DelimitadorLog','MostrarInstrucoesUnit']);
  return displayed;
}
test('LOG-01/02 captura sempre, tela somente debug, instruções independentes',()=>{
  const e=environment(),a=e.api,shown=logger(e);a.FLogsCasoTeste=null;a.FModoDebug=false;
  a.RegistrarLog('sem debug');assert.match(a.FLogsCasoTeste.Text,/sem debug/);assert.equal(shown.length,0);
  a.DelimitadorLog('ETAPA');assert.match(a.FLogsCasoTeste.Text,/ETAPA/);assert.equal(shown.length,0);
  a.FModoDebug=true;a.RegistrarLog('com debug');assert.match(a.FLogsCasoTeste.Text,/com debug/);assert.deepEqual(shown,[['[DEBUG]\rcom debug']]);
  a.FExibirInstrucoes=false;a.MostrarInstrucoesUnit('UNIT','texto');assert.equal(shown.length,1);
  a.FExibirInstrucoes=true;a.FModoDebug=false;a.MostrarInstrucoesUnit('UNIT','texto');assert.equal(shown.length,2);
});
function inner(generated,records,fail=false){
  const e=environment(),a=e.api;logger(e);
  a.CDSCasosTestes=dataset(records.map(id=>({ID:id,DESCRICAO:'caso '+id,REQUISITOVERSAO:'160',CASOTESTE:'{}'})));
  a.CDSResultadoEsperado=dataset([]);
  e.load(dir+'P39_TDD_RUN_ASSERTS.pas',['InicializarAcumulo','RegistrarResultado','AssertsPassou','AssertsFalhou','AssertsZerar','AssertsTotal','AssertsPass','AssertsFail','AssertsOk','AssertsResumo']);
  e.load(dir+'TDD_RUN_RUNNER.pas',['SetarCasoTeste','RegistrarTick','FormatarTickDiff','PreencherComZeros']);
  e.load(dir+'TDD_RUN_FINISHED.pas',['RegistrarMetricas']);
  Object.assign(a,{
    MensagemPersonalizada:'[PERSONALIZADA]',ClassOwner:'owner',CallBack_AbreTela(){},CallBack_FechaTela(){},CallBack_Mensagem(){},
    SetupCasosTestes(){},LiberarMetricasTickDiff(){},TearDown_FinalizarParametros(){},Cache_TearDown_LimparInformacoes(){},TearDown_Finalizar_CasosTeste(){},
    InicializarMetricasTickDiff(){a.FCDSMetricasTickDiff=dataset([]);a.FEtapaAtual=0;},
    Started(){a.FCasoTesteAtualId=a.FHistoricoExecucao.AutoIncCasoTeste;},CompararResultadoEsperado(){},
    Teste(){a.RegistrarLog('EXCLUSIVO-CASO-'+a.FHistoricoExecucao.AutoIncCasoTeste);if(fail)throw error('falha intencional');a.AssertsPassou('ok');}
  });
  for(const n of ['Main','ExecutarLote','Run'])a[n]=compile(generated,n,a);
  return e;
}
function outer(label,debug=false,shared=false){
  const e=environment(),a=e.api;logger(e);
  a.FTDDUnit='UNIT_'+label;a.FModoDebug=debug;a.FParamsCasosTeste=list();a.FParamsCasosTeste.Add("'FINANCEIRO'");a.FParamsCasosTeste.Add("'FINANCEIRO'");
  Object.defineProperty(a.FParamsCasosTeste,'CommaText',{value:"'FINANCEIRO','FINANCEIRO'"});
  a.RegistrarLog('LOTE-ANTERIOR');
  a.CodificacaoUnit=()=>read(dir+'TDD_RUN_UNIT_BASE_IRUNNER.pas');
  e.load(dir+'TDD_RUN_IRUNNER.pas',['Executar']);
  let captured='',context;
  a.Interpretar=generated=>{
    captured=generated;context=inner(generated,[28,29]);
    if(shared){context.api.FLogsCasoTeste=a.FLogsCasoTeste;}
    context.api.Main();
    // Simula a referência global compartilhada quando aplicável.
    if(shared)a.FLogsCasoTeste=context.api.FLogsCasoTeste;
  };
  return {...e,generated:()=>captured,context:()=>context};
}
test('LOG-03/04/05 dois contextos, dois casos e nova chamada não misturam logs',()=>{
  for(const shared of [false,true]){
    const e=outer('PRIMEIRO',false,shared);e.api.Executar();const c=e.context();
    assert.equal(c.histories.length,2);
    for(let i=0;i<2;i++){
      const text=c.histories[i][6];assert.match(text,/CÓDIGO GERADO/);assert.match(text,/UNIT_PRIMEIRO/);
      assert.match(text,new RegExp('EXCLUSIVO-CASO-'+(28+i)));
      assert.doesNotMatch(text,new RegExp('EXCLUSIVO-CASO-'+(29-i)));assert.doesNotMatch(text,/LOTE-ANTERIOR/);
    }
    assert.equal(e.api.FLogsCasoTeste,null);assert.equal(c.api.FLogsCasoTeste,null);
    assert.doesNotMatch(e.generated(),/__LOGS_PREPARACAO__/);
    const fresh=outer('SEGUNDO');fresh.api.Executar();for(const row of fresh.context().histories){assert.match(row[6],/UNIT_SEGUNDO/);assert.doesNotMatch(row[6],/UNIT_PRIMEIRO|LOTE-ANTERIOR/);}
  }
});
test('LOG-05 transporte preserva aspas, acentos, CR e LF sem executar texto do log',()=>{
  const e=outer('ESCAPE');const a=e.api;const original=a.RegistrarLog;
  const sample="Ação d'água\r\nsegunda\nterceira\r'; raise Exception.Create('NÃO EXECUTAR'); //";
  a.RegistrarLog=text=>{original(text);original(sample);};
  let observed;
  a.Interpretar=source=>{const api={FModoDebug:true,FLogsPreparacao:'',ExecutarLote(){observed=api.FLogsPreparacao;}};compile(source,'Main',api)();};
  a.Executar();assert.ok(observed.includes(sample));assert.match(observed,/CÓDIGO GERADO/);
});
test('LOG-04 falha mantém preparação e diagnóstico no histórico sem debug',()=>{
  const e=outer('FALHA');e.api.Interpretar=generated=>{const c=inner(generated,[28],true);assert.throws(()=>c.api.Main(),/falha intencional/);assert.equal(c.histories[0][3],'FALHA');assert.match(c.histories[0][6],/CÓDIGO GERADO/);assert.match(c.histories[0][6],/falha intencional/);};assert.doesNotThrow(()=>e.api.Executar());
});
test('LOG-06 nenhum fonte Pascal mantém chamada ao nome anterior',()=>{
  const files=fs.readdirSync(path.join(root,'docs/assets'),{recursive:true}).filter(p=>p.endsWith('.pas'));
  for(const file of files)assert.doesNotMatch(read('docs/assets/'+file),/RegistrarLogEmModoDebug/);
});
console.log('GATE LOCAL: '+count+' grupos; sem execução ERP/ODBC.');
