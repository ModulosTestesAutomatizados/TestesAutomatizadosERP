import { criarDocumentoUnit } from './criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  navegacao: { grupo: 'units', subgrupo: 'irunner' },
  nome: 'P39_TDD_IRUNNER', resumo: 'Montagem do código interpretado para a unit de Teste configurada.',
  fonte: 'docs/assets/emDesenvolvimento/Runner/P39_TDD_IRUNNER.pas',
  responsabilidade: 'Configurar uma unit Teste e montar o programa que será enviado a Interpretar, usando P39_TDD_BASE_UNIT_IRUNNER como molde.',
  problema: 'Evita duplicar a casca de execução em cada caso. A entrada configura unit, módulo e área; a montagem insere a chamada Teste nos lugares reservados do molde.',
  estados: [
    ['FTDDUnit: string', 'Nome da unit inserida em __USES_UNITS__', 'Configurado por SetTDDUnit; não é limpo no finally de Executar'],
    ['FParamsCasosTeste: TStringList', 'Módulo e área como literais Pascal', 'Criada sob demanda e liberada ao terminar Executar'],
    ['FUnitInterpretar: TStringList', 'Código do molde preenchido', 'Criada em Executar e liberada no finally']
  ],
  metodos: [
    ['procedure Main', 'Exibir instruções da unit.', 'Encaminha o texto a P39_TDD_LOGS.MostrarInstrucoesUnit; respeita FExibirInstrucoes.'],
    ['procedure SetTDDUnit(pUnit: string)', 'Definir a única unit de Teste.', 'Atribui Trim(pUnit) a FTDDUnit; Executar valida o nome antes de montar o código.'],
    ['procedure AddItemToList(var pList: TStringList; const pValue: string)', 'Adicionar um item criando a lista se necessário.', 'Usa Assigned, TStringList.Create e Add; não interpreta ou valida o literal recebido.'],
    ['procedure AddParamsRun(pParam: string)', 'Acumular módulo e área, nessa ordem.', 'Chama AddItemToList para FParamsCasosTeste. Devem existir exatamente dois parâmetros antes de Executar.'],
    ['procedure Executar', 'Montar e interpretar o código uma vez.', "Obtém CodificacaoUnit('P39_TDD_BASE_UNIT_IRUNNER'), prepara logs/callback/ticks em torno de Teste e substitui os três marcadores. Envia FUnitInterpretar.Text a Interpretar e libera as listas no finally."]
  ],
  implementacao: ['Valida a configuração antes de criar as listas de montagem.', 'Usa CommaText e Troca para preencher uses, parâmetros e chamada do método Teste.', 'A carga do lote e o cursor pertencem ao molde; esta unit não percorre CDSCasosTestes.'],
  dependencias: ['Uses direto: P39_TDD_LOGS.', 'Carregamento dinâmico: P39_TDD_BASE_UNIT_IRUNNER.', 'A unit informada por SetTDDUnit é uma dependência dinâmica.'],
  limites: ['O fonte libera listas sem zerar todas as referências; não presumir reentrância no mesmo contexto.', 'A configuração recebe literais Pascal; aspas do módulo e área fazem parte do valor recebido.']
});
