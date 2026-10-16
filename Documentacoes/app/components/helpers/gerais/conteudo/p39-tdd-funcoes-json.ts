import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  nome: 'P39_TDD_FUNCOES_JSON', navegacao: { grupo: 'helpers', subgrupo: 'gerais' },
  resumo: 'Leitura tipada de tags JSON e acesso aos pares usados na configuração dos testes.',
  fonte: 'docs/assets/configuracoesGerais/P39_TDD_FUNCOES_JSON.pas',
  responsabilidade: 'Ler tags e converter valores para inteiro, moeda, lógico, data ou texto com os padrões definidos pelo consumidor.',
  problema: 'Compartilhar as conversões entre cenários, parâmetros e infraestrutura, em vez de repeti-las no IRunner.',
  metodos: [
    ['procedure Main', 'Apresentar instruções.', 'Delega a MostrarInstrucoesUnit.'],
    ['function TagExiste(pJson, pTag: String): Boolean', 'Verificar uma tag com conteúdo.', 'Retorna False para entrada vazia, valor vazio ou falha de leitura.'],
    ['function ValorInteiroTag(pJson, pTag: String; pDefault: Integer): Integer', 'Ler um inteiro.', 'Converte ValorStringTag com StrToInt e mantém pDefault em caso de erro.'],
    ['function ValorCurrencyTag(pJson, pTag: String; pDefault: Currency): Currency', 'Ler um valor monetário.', 'Troca ponto por vírgula e usa StrToCurrDef com pDefault.'],
    ['function ValorLogicoTag(pJson, pTag: String; pDefault: Boolean): Boolean', 'Ler um lógico.', 'Reconhece true/s e false/n; outros valores preservam o padrão.'],
    ['function ValorDataTag(pJson, pTag: String): TDateTime', 'Ler uma data.', 'Usa StrToDateTime e retorna zero quando a conversão falha.'],
    ['function ValorStringTag(pJson, pTag: String): String', 'Ler o conteúdo textual da tag.', 'Verifica TagExiste; ausência ou erro resultam em texto vazio.'],
    ['function GetPairName(pPair: TJSONPair): String', 'Obter o nome do par.', 'Serializa ToJSON, remove aspas e corta até o separador; referência ausente resulta em vazio.'],
    ['function GetPairValue(pPair: TJSONPair): String', 'Obter o valor do par.', 'Usa a representação ToJSON e a rotina de recorte do fonte; referência ausente resulta em vazio.']
  ],
  implementacao: ['Não mantém estado global de JSON próprio; os dados chegam como argumentos.', 'Essas rotinas não substituem a validação de obrigatoriedade feita por cada caso.'],
  dependencias: ['P39_TDD_LOGS fornece instruções; leitura JSON, conversão e recorte são fornecidos pelo host.'],
  limites: ['Falhas de leitura podem se transformar em valores padrão; o caso precisa verificar os campos obrigatórios.', 'Datas e valores monetários dependem das conversões e do formato esperado pelo host.']
});
