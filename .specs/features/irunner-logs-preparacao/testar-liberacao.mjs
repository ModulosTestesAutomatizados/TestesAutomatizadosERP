import assert from 'node:assert/strict';
import {environment,error} from '../irunner-asserts-modulo/evidencias/ambiente.mjs';
import {compile} from '../irunner-asserts-modulo/evidencias/pascal.mjs';
import fs from 'node:fs';
const file='docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_IRUNNER.pas';
function ownedList(){
  let text='',freed=false;const rows=[];
  const alive=()=>{if(freed)throw error('Acesso a objeto já liberado');};
  return {
    get Count(){alive();return rows.length;},get CommaText(){alive();return "'FINANCEIRO','FINANCEIRO'";},
    get Text(){alive();return text;},set Text(v){alive();text=v;},
    Clear(){alive();rows.length=0;text='';},Add(v){alive();rows.push(v);text+=v+'\r\n';},
    Free(){if(freed)throw error('Invalid pointer operation: segundo Free');freed=true;},
    get freed(){return freed;}
  };
}
function setup(){
  const e=environment(),a=e.api,created=[];
  const previousLogs=ownedList();previousLogs.Add('mensagem do chamador');
  const make=()=>{const obj=ownedList();created.push(obj);return obj;};
  Object.assign(a,{FTDDUnit:'TESTE',FUnitInterpretar:null,FLogsCasoTeste:previousLogs,FParamsCasosTeste:make(),
    TStringList:{get Create(){return make();}},
    CodificacaoUnit:()=>"procedure Main; begin FModoDebug := __MODO_DEBUG__; end;",
    Interpretar(){},RegistrarLog:v=>a.FLogsCasoTeste.Add(v),DelimitadorLog:v=>a.FLogsCasoTeste.Add(v)});
  a.FParamsCasosTeste.Add("'FINANCEIRO'");a.FParamsCasosTeste.Add("'FINANCEIRO'");
  e.load(file,['Executar']);
  return {...e,created,make,previousLogs};
}
{
  const e=setup();assert.doesNotThrow(()=>e.api.Executar());
  assert.ok(e.created.every(v=>v.freed));assert.equal(e.api.FLogsCasoTeste,e.previousLogs);
  assert.equal(e.previousLogs.Text,'mensagem do chamador\r\n');
  console.log('PASS contexto separado libera cada lista uma vez e preserva lista do chamador');
}
{
  const e=setup();const a=e.api;
  const main=fs.readFileSync('docs/assets/configuracoesGerais/arquiteturaIRunner/TDD_RUN_UNIT_BASE_IRUNNER.pas','utf8').replace('__MODO_DEBUG__','False').replace('__LOGS_PREPARACAO__',"'PREPARACAO'").replace('__PARAMETROS_CASO_TESTE__',"'FINANCEIRO','FINANCEIRO'");
  a.ExecutarLote=()=>{a.FLogsCasoTeste.Add('contexto interpretado');a.FLogsCasoTeste.Free();};
  a.Interpretar=()=>compile(main,'Main',a)();
  assert.doesNotThrow(()=>e.api.Executar());assert.ok(e.created.every(v=>v.freed));
  assert.equal(e.api.FLogsCasoTeste,e.previousLogs);assert.equal(e.previousLogs.freed,false);
  console.log('PASS Main cria lista própria e cada dono libera apenas sua lista');
}
{
  const e=setup();e.api.Interpretar=()=>{throw error('ERRO ORIGINAL DO INTERPRETADOR');};
  assert.throws(()=>e.api.Executar(),/ERRO ORIGINAL DO INTERPRETADOR/);assert.ok(e.created.every(v=>v.freed));
  console.log('PASS limpeza não substitui falha original por segundo Free');
}
{
  const e=setup();e.api.Executar();e.api.FParamsCasosTeste=e.make();e.api.FParamsCasosTeste.Add('F');e.api.FParamsCasosTeste.Add('F');
  assert.doesNotThrow(()=>e.api.Executar());assert.ok(e.created.every(v=>v.freed));
  console.log('PASS nova chamada com nova lista de parametros mantem liberacao unica');
}
