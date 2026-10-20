import type { ISecao } from '../../../../contracts/documentacao.ts';

import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
const documento = criarDocumentoUnit({
  "nome": "P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS",
  "resumo": "Enumerar registros atuais e orquestrar a sincronização por meio de RegistrarCasoTeste.",
  "responsabilidade": "Enumerar registros atuais e orquestrar a sincronização por meio de RegistrarCasoTeste.",
  "problema": "Separar cadastro/sincronização da execução do caso e manter configuração portável.",
  "fonte": "docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "unit",
  "navegacao": {
    "grupo": "helpers",
    "subgrupo": "sincronizacao",
    "ordem": 1
  },
  "aliases": [
    "TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS"
  ],
  "estados": [
    [
      "FSincRemoto: Boolean",
      "Seleciona fonte remota ou local.",
      "O processamento o configura primeiro; Sincronizar pergunta novamente e usa a resposta mais recente em RegistrosCasosTestes."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Enumerar registros atuais e orquestrar a sincronização por meio de RegistrarCasoTeste.",
      "Exibe as instruções quando FExibirInstrucoes está ativo. O processamento a chama explicitamente antes de Sincronizar."
    ],
    [
      "procedure Sincronizar;",
      "Adiciona um callback para feedback ao usuário com finalidade de acompanhamento do processo. Chamada para RegistrosCasosTestes.",
      "Abre callback, pergunta 'Sincronizar com Remoto? (Tek Store)' por P39_TDD_FILTROS, chama RegistrosCasosTestes(FSincRemoto), fecha callback no finally e apresenta conclusão após o retorno."
    ],
    [
      "procedure RegistrosCasosTestes(pSincRemoto :boolean);",
      "Registrar cada um dos casos de teste com suas respectivas informações sem considerar o prefixo do ambiente remoto. Utilização em sequência do método {TDD_REGISTRAR_CASO_TESTE.}RegistrarCasoTeste.",
      "Faz cinco chamadas a RegistrarCasoTeste, repassando pSincRemoto para a leitura local ou remota das fontes JSON."
    ]
  ],
  "implementacao": [
    "O processamento pergunta FSincRemoto e FExibirInstrucoes antes de chamar Main e Sincronizar. Sincronizar pergunta FSincRemoto outra vez; essa segunda escolha é intencional e é a que chega a RegistrosCasosTestes.",
    "Sincronizar abre callback, chama RegistrosCasosTestes(FSincRemoto), fecha callback no finally e apresenta conclusão somente após retorno.",
    "RegistrosCasosTestes faz cinco chamadas de seis argumentos: financeiro, desconto percentual do pedido, unidade fabril, sequência dos itens e faturamento/CARGA. Cada caso usa uma única fonte JSON; CARGA usa TDD_FAT_CARGA_JSON.",
    "O registro financeiro atual usa descrição P39_TDD_FIN_FINANCEIRO, requisito 160.00 e fonte TDD_FIN_FINANCEIRO_JSON. A descrição e a fonte não são a mesma coisa que o nome remoto instalado; pSincRemoto controla o prefixo da leitura.",
    "Os exemplos P39_TDD_JSON_PEDIDO_*.pas do repositório contêm Pascal. Não tratá-los como JSON puro nem afirmar que sua migração remota já ocorreu. Expectativas específicas devem ficar em resultadoEsperado da respectiva fonte."
  ],
  "dependencias": [
    "P39_TDD_REGISTRAR_CASO_TESTE: cláusula uses do fonte; executa RegistrarCasoTeste.",
    "P39_TDD_FILTROS: cláusula uses do fonte; configura FSincRemoto dentro de Sincronizar. O fonte local vinculado à página de filtros se chama P39_TDD_FILTROS.pas."
  ],
  "limites": [
    "Sem execução de SQL, TekStore ou ERP pela documentação. Arquivos e aliases não comprovam nomes remotos instalados.",
    "Fontes inválidos não são substituídos silenciosamente; escrita pode ser parcial, sem atomicidade global ou retry automático."
  ]
});
const secoesAdicionais: ISecao[] = [];
documento.secoes.push(...secoesAdicionais);
export default documento;
