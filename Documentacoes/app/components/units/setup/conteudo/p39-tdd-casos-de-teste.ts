import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
export default criarDocumentoUnit({
  "nome": "P39_TDD_CASOS_DE_TESTE",
  "resumo": "Manter módulo, área e datasets de casos, resultados esperados, campos e configuração.",
  "responsabilidade": "Manter módulo, área e datasets de casos, resultados esperados, campos e configuração.",
  "problema": "Carregar o lote e compartilhar contexto entre units sem delegar esse estado ao módulo visual.",
  "fonte": "docs/assets/configuracoesGerais/P39_TDD_CASOS_DE_TESTE.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "aliases": [],
  "navegacao": {
    "grupo": "units",
    "subgrupo": "setup",
    "ordem": 0
  },
  "estados": [
    [
      "CDSCasosTestes: TClientDataSet",
      "Casos carregados e cursor compartilhado.",
      "CarregarCasosTeste popula; somente o lote avança First/Run/Next; teardown libera."
    ],
    [
      "CDSResultadoEsperado: TClientDataSet",
      "Resultado esperado por ID do caso.",
      "Carga espelha RESULTADO_ESPERADO_CT; runner/validador consomem; teardown libera."
    ],
    [
      "CDSCamposDisponiveis: TClientDataSet",
      "Configuração dos campos disponíveis por caso.",
      "Populada na carga e liberada no encerramento da estrutura."
    ],
    [
      "CDSConfiguracao: TClientDataSet",
      "Configurações do módulo.",
      "CarregarConfiguracoes consulta SQL por módulo; estrutura do lote gerencia o dataset."
    ],
    [
      "FModulo: Integer",
      "Identificador do módulo de casos.",
      "SetModulo resolve pelo cache antes da carga e uso de RUN_MODULO."
    ],
    [
      "FArea: Integer",
      "Identificador da área.",
      "SetArea resolve antes de CarregarCasosTeste."
    ],
    [
      "FDescModulo: String",
      "Descrição do módulo ativo.",
      "SetModulo preenche; lote e RUN_MODULO consomem."
    ],
    [
      "FDescArea: String",
      "Descrição da área ativa.",
      "SetArea preenche; usada ao preparar o caso corrente."
    ],
    [
      "FEstruturaCasoTesteIniciada: Boolean",
      "Indica datasets do lote inicializados.",
      "Setup marca; carga verifica; teardown encerra estrutura."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Apresenta as instruções conforme FExibirInstrucoes; quando é entrada do molde/processamento, executa também a orquestração descrita abaixo.",
      "Implementação no fonte, linha 13. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure CarregarConfiguracoes;",
      "Operação CarregarConfiguracoes do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Implementação no fonte, linha 20. Operações chamadas: TDDReaderODBC."
    ],
    [
      "procedure SetModulo(Value: String);",
      "Resolve FModulo pelo cache e registra FDescModulo para os consumidores.",
      "Implementação no fonte, linha 35. Operações chamadas: ModuloPeloNome."
    ],
    [
      "procedure SetArea(Value: String);",
      "Resolve FArea pelo cache e registra FDescArea para o lote.",
      "Implementação no fonte, linha 41. Operações chamadas: AreaPeloNome."
    ],
    [
      "procedure CarregarCasosTeste;",
      "Operação CarregarCasosTeste do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Implementação no fonte, linha 47. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure CarregarCasosTestes(Modulo, Area: Integer);",
      "Operação CarregarCasosTestes do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Implementação no fonte, linha 57. Operações chamadas: CallBack_AbreTela, CallBack_Mensagem, if, Trim, Create, GetModulo."
    ],
    [
      "procedure PreencheInformacoesDataSets(CDSTemp: TClientDataSet; Modulo, Area: Integer);",
      "Operação PreencheInformacoesDataSets do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Implementação no fonte, linha 103. Operações chamadas: CallBack_Mensagem, FindKey, FieldByName."
    ],
    [
      "procedure ConfigurarDataSets;",
      "Operação ConfigurarDataSets do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Implementação no fonte, linha 138. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function GetConfiguracao: OleVariant;",
      "Operação GetConfiguracao do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Implementação no fonte, linha 164. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "function GetCasosTeste: OleVariant;",
      "Operação GetCasosTeste do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Implementação no fonte, linha 172. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure Setup_Inicializar_CasosTeste;",
      "Operação Setup_Inicializar_CasosTeste do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Implementação no fonte, linha 184. Atribuições e fluxo locais seguem o contrato descrito acima."
    ],
    [
      "procedure TearDown_Finalizar_CasosTeste;",
      "Operação TearDown_Finalizar_CasosTeste do contrato desta unit; usa os parâmetros e retorno da assinatura, com os estados compartilhados descritos nesta página.",
      "Implementação no fonte, linha 196. Atribuições e fluxo locais seguem o contrato descrito acima."
    ]
  ],
  "implementacao": [
    "SetModulo/SetArea preenchem FModulo/FArea e as descrições usando o cache. CarregarCasosTeste inicia estruturas, valida contexto e carrega o conjunto de casos.",
    "CDSCasosTestes é o cursor controlado por ExecutarLote. CDSResultadoEsperado guarda ID e RESULTADO_ESPERADO_CT; CDSCamposDisponiveis e CDSConfiguracao mantêm projeções de configuração.",
    "Setup_Inicializar_CasosTeste e TearDown_Finalizar_CasosTeste gerenciam datasets do lote. RUN_MODULO consome o contexto para operar telas, sem assumir a carga ou a propriedade desses dados."
  ],
  "dependencias": [
    "P39_TDD_CONSTANTES: cláusula uses do fonte.",
    "P39_TDD_PARAMETRO: cláusula uses do fonte.",
    "P39_TDD_CACHE: cláusula uses do fonte."
  ],
  "limites": [
    "Fonte local e documentação não comprovam cadastro remoto instalado ou homologação no ERP. APIs do host e efeitos financeiros precisam de evidência própria.",
    "Não confundir a limpeza dos datasets com restauração de parâmetros ERP."
  ],
  "aliasesArtefatos": {
    "CDSCasosTestes": [
      "FCDSCasosTestes"
    ]
  }
});
