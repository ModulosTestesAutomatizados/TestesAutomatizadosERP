import type { ISecao } from '../../../../contracts/documentacao.ts';

import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
const documento = criarDocumentoUnit({
  "nome": "P39_TDD_REGISTRAR_CASO_TESTE",
  "resumo": "Resolver a fonte JSON única e registrar ou atualizar o caso no banco dedicado.",
  "responsabilidade": "Resolver a fonte JSON única e registrar ou atualizar o caso no banco dedicado.",
  "problema": "Separar cadastro/sincronização da execução do caso e manter configuração portável.",
  "fonte": "docs/assets/configuracoesGerais/Sincronizar/P39_TDD_REGISTRAR_CASO_TESTE.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "navegacao": {
    "grupo": "helpers",
    "subgrupo": "sincronizacao",
    "ordem": 0
  },
  "aliases": [
    "TDD_REGISTRAR_CASO_TESTE"
  ],
  "estados": [
    [
      "FCasoTeste: TCasoTeste",
      "Campos do registro que será persistido.",
      "Preenchido após resolver/validar fonte e contexto; consumido por Insert/Atualizar."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Resolver a fonte JSON única e registrar ou atualizar o caso no banco dedicado.",
      "Declaração no fonte, linha 16. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ],
    [
      "procedure RegistrarCasoTeste( pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste, pRequisitoVersao, pUnitJsonCasoTeste :string; pSincRemoto :boolean );",
      "Orquestra seis argumentos, confirmação, validação da fonte, defaults e escrita das projeções.",
      "Declaração no fonte, linha 64. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ],
    [
      "function CarregarConteudoUnit(pNomeUnit :string; pSincRemoto :boolean) :string;",
      "Trata o controle de sincronizar com fontes do remoto ou locais. Carrega o conteúdo obrigatório; falhas de leitura não são convertidas em json vazio.",
      "Declaração no fonte, linha 146. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ],
    [
      "function ObterObjetoConfiguracao(pJson, pPropriedade, pUnitFallback :string; pFallbackSeVazio :boolean) :string;",
      "Resolve objetos explícitos ou a propriedade de uma unit remota mínima, conforme a política de vazio.",
      "Declaração no fonte, linha 165. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ],
    [
      "function SincronizarCasoTeste(pDescricaoModulo, pDescricaoArea, pDescricaoCasoTeste :string) :integer;",
      "Camada de validação se o caso de teste já existe no banco de dados. Confirma antes de carregar fontes; retorna -1 para recusa, 0 para novo ou o código para atualização.",
      "Declaração no fonte, linha 245. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ],
    [
      "procedure AtualizarCasoTeste(pCodigoCasoTeste :integer);",
      "SQL de update do caso de teste e execução de {P39_TDD_ODBC.}TDDCommandODBCP passando os parâmetros via FCasoTeste.",
      "Declaração no fonte, linha 278. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ],
    [
      "procedure InsertCasoTeste;",
      "SQL de insert do caso de teste e execução de {P39_TDD_ODBC.}TDDCommandODBCP passando os parâmetros via FCasoTeste.",
      "Declaração no fonte, linha 304. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ],
    [
      "function RegistroFallbackBase(pSqlSelect, pSqlInsert :string; pParametrosSql :OleVariant; pAtivarFallback :boolean) :integer;",
      "Orquestra execuções de consulta que podem vir a gerar um registro de insert. Depende de que as SQLs de insert contenha a cláusula returning ao final da sql. Quando pAtivarFallback for false, essa unit apenas encontra o que já existe e retorna raise se não encontrar.",
      "Declaração no fonte, linha 339. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ],
    [
      "function RegistroFallbackModulo(pDescricaoModulo :string; pAtivarFallback :boolean) :integer;",
      "Monta as SQLs de select e insert com returning para chamar RegistroFallbackBase com fallback ativado.",
      "Declaração no fonte, linha 365. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ],
    [
      "function RegistroFallbackArea(pCodigoModulo :integer; pDescricaoArea :string; pAtivarFallback :boolean) :integer;",
      "Monta as SQLs de select e insert com returning para chamar RegistroFallbackBase com fallback ativado.",
      "Declaração no fonte, linha 382. Usa o record FCasoTeste e os helpers de leitura/SQL conforme o fluxo de implementação."
    ]
  ],
  "implementacao": [
    "RegistrarCasoTeste recebe seis argumentos: descrição do módulo, área, caso, requisito de versão, nome da fonte JSON e pSincRemoto. SincronizarCasoTeste consulta a identidade antes da leitura; -1 significa recusa do usuário, 0 significa novo registro e ID positivo significa atualização.",
    "CarregarConteudoUnit lê CodificacaoUnit. Para fonte remota acrescenta P39_ apenas se necessário. Mínimos usam nomes remotos exatos mesmo quando o caso é local; erro de leitura ou conteúdo vazio não vira {} silenciosamente.",
    "ObterObjetoConfiguracao resolve resultadoEsperado e camposDisponiveis antes dos fallbacks SQL de módulo/área. Propriedade reservada null, array ou escalar é inválida. Falta de fonte/mínimo obrigatório ou JSON inválido propaga erro antes das gravações.",
    "No corpo atual, propriedades reservadas da raiz são retiradas da entrada e recompostas com os objetos resolvidos. CASO_TESTE_CT mantém dados, parametros, camposDisponiveis e resultadoEsperado na raiz. CAMPOS_DISPONIVEIS_CT e RESULTADO_ESPERADO_CT mantêm os respectivos wrappers nomeados. Homônimas aninhadas permanecem nos dados; não criar wrapper duplo.",
    "RegistroFallbackModulo/Area resolve cadastros depois da validação JSON. FCasoTeste recebe as projeções formatadas e InsertCasoTeste ou AtualizarCasoTeste usa parâmetros ODBC. A consulta inicial não equivale a uma gravação; não há garantia de transação única global ou retry."
  ],
  "dependencias": [
    "P39_TDD_ODBC: cláusula uses do fonte.",
    "P39_TDD_FUNCOES_JSON: cláusula uses do fonte."
  ],
  "limites": [
    "Sem execução de SQL, TekStore ou ERP pela documentação. Arquivos e aliases não comprovam nomes remotos instalados.",
    "Fontes inválidos não são substituídos silenciosamente; escrita pode ser parcial, sem atomicidade global ou retry automático."
  ]
});
const secoesAdicionais: ISecao[] = [
  {
    "id": "defaults",
    "titulo": "Defaults e estados de entrada",
    "blocos": [
      {
        "tipo": "tabela",
        "colunas": [
          "Entrada",
          "Resultado"
        ],
        "linhas": [
          [
            "resultadoEsperado ausente",
            "Ler P39_TDD_ASSERTS_JSON_MINIMO e preservar a tag resultadoEsperado."
          ],
          [
            "resultadoEsperado: {} explícito",
            "Preservar objeto vazio; não buscar mínimo. Na execução, SEM_VALIDACAO preserva asserts explícitos."
          ],
          [
            "resultadoEsperado preenchido",
            "Preservar a configuração explícita."
          ],
          [
            "camposDisponiveis ausente ou {}",
            "Usar P39_TDD_CAMPOS_DISPONIVEIS_JSON_MINIMO; o corpo atual {} é válido e resulta na tag camposDisponiveis vazia."
          ],
          [
            "camposDisponiveis preenchido",
            "Preservar objeto explícito, sem mínimo."
          ],
          [
            "Reservada null, array ou escalar",
            "Falhar: deve ser objeto. Não tratar como ausência."
          ],
          [
            "Fonte/mínimo obrigatório indisponível, inválido ou vazio",
            "Propagar antes dos fallbacks SQL e da escrita."
          ]
        ]
      }
    ]
  },
  {
    "id": "projecoes",
    "titulo": "O que cada coluna recebe",
    "blocos": [
      {
        "tipo": "tabela",
        "colunas": [
          "Destino",
          "Conteúdo atual",
          "Consumidor"
        ],
        "linhas": [
          [
            "CASO_TESTE_CT",
            "Dados do caso + parametros + objetos resolvidos camposDisponiveis e resultadoEsperado na raiz.",
            "CDSCasosTestes / TDD_RUN_STARTED / cenário"
          ],
          [
            "CAMPOS_DISPONIVEIS_CT",
            "{\"camposDisponiveis\": {...}}",
            "CDSCamposDisponiveis"
          ],
          [
            "RESULTADO_ESPERADO_CT",
            "{\"resultadoEsperado\": {...}}",
            "CDSResultadoEsperado / P39_TDD_RUN_VALIDAR_RESULTADO"
          ]
        ]
      },
      {
        "tipo": "paragrafo",
        "texto": "Os registros anteriores podem guardar as seções erro/valor/tempo diretamente na raiz. O comparador atual aceita esse formato e o wrapper novo; não é necessário criar uma segunda camada resultadoEsperado."
      }
    ]
  },
  {
    "id": "fluxo",
    "titulo": "Fluxo de confirmação e gravação",
    "blocos": [
      {
        "tipo": "mermaid",
        "fonte": "docs/MAPEAMENTO_AST_USES_UNITS/p39-tdd-registrar-caso-teste/fonte-unica.md",
        "titulo": "Fonte única, defaults e projeções"
      }
    ]
  }
];
documento.secoes.push(...secoesAdicionais);
export default documento;
