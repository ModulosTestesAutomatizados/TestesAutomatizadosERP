import assert from 'node:assert/strict';
import {scenario} from './testar-persistencia-falhas.mjs';
// A persistencia passou para o finally externo de Run; esta sonda exercita
// agora esse bloco junto com o fluxo da tentativa, usando os mesmos doubles.
let result=scenario({test:true});
assert.equal(result.metodo,'IRUNNER');
console.log('PASS FINISHED bem-sucedido preserva IRUNNER');
result=scenario({init:true});
assert.equal(result.metodo,'INICIALIZAR METRICAS');
console.log('PASS FINISHED bem-sucedido preserva etapa de preparacao');
result=scenario({persist:true});
assert.equal(result.metodo,'FINISHED');
console.log('PASS erro de persistencia conserva FINISHED');
