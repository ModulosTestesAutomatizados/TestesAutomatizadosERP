import { criarDocumentoUnit } from './criarDocumentoUnit.ts';

export default criarDocumentoUnit({
  nome: 'P39_TDD_CACHE', navegacao: { grupo: 'units', subgrupo: 'irunner' },
  resumo: 'Carrega e consulta módulos e áreas do banco dedicado para preparar o contexto dos testes.',
  fonte: 'docs/assets/configuracoesGerais/P39_TDD_CACHE.pas',
  responsabilidade: 'Manter os datasets de módulos e áreas e resolver seus códigos por nome ou identificador.',
  problema: 'Evitar repetir a carga dessas informações a cada consulta do contexto de Casos de Teste.',
  estados: [
    ['CDSModulos, CDSAreas: TClientDataSet', 'Cache de módulos e áreas do banco dedicado.', 'Criados no setup quando não atribuídos; liberados no teardown.'],
    ['FCacheCarregado: Boolean', 'Indica que a carga dos dois datasets foi concluída.', 'True após carga, False após limpeza.']
  ],
  metodos: [
    ['procedure Main', 'Apresentar instruções da unit.', 'Chama MostrarInstrucoesUnit com uma descrição vazia no fonte atual.'],
    ['procedure Cache_Setup_CarregarInformacoes', 'Preparar e carregar o cache.', 'Cria datasets quando necessário, lê SQLModulos e SQLAreas via TDDReaderODBC e marca a carga.'],
    ['procedure Cache_TearDown_LimparInformacoes', 'Liberar os datasets.', 'Chama Free em ambos e redefine FCacheCarregado.'],
    ['procedure VerificaCarregamentoCache', 'Garantir a carga antes das consultas.', 'Aciona o setup quando FCacheCarregado está False.'],
    ['function AreaPeloNome(pArea: String): Integer', 'Resolver uma área por descrição.', 'Valida o cache, indexa por DESCRICAO_AREA e usa FindKey; lança erro se não encontrar.'],
    ['function GetArea(pCodArea: Integer): Integer', 'Confirmar uma área por identificador.', 'Valida o cache, indexa por AUTOINC_AREA e usa FindKey.'],
    ['procedure ValidarArea', 'Validar o dataset de áreas.', 'Garante a carga e rejeita referência ausente ou dataset vazio.'],
    ['function ModuloPeloNome(pModulo: String): Integer', 'Resolver um módulo por descrição.', 'Indexa CDSModulos por DESCRICAO_MODULO e retorna CODIGO_MODULO.'],
    ['function GetModulo(pCodModulo: Integer): Integer', 'Confirmar um módulo por código.', 'Indexa por CODIGO_MODULO e lança erro quando não encontra.'],
    ['procedure ValidarModulo', 'Validar o dataset de módulos.', 'Garante a carga e rejeita referência ausente ou dataset vazio.']
  ],
  implementacao: ['P39_TDD_CASOS_DE_TESTE usa este cache para preparar módulo e área do lote.', 'O subgrupo IRunner representa sua utilização documental principal, não exclusividade de uso.'],
  dependencias: ['P39_TDD_ODBC fornece as leituras; P39_TDD_CONSTANTES fornece SQLModulos e SQLAreas transitivamente.'],
  limites: ['O teardown usa Free sem zerar as referências; este fonte não demonstra reinicialização segura após a liberação.', 'P39_TDD_CONSTANTES também declara CDSModulos, CDSAreas e FCacheCarregado; essas declarações distintas não devem ser confundidas.']
});
