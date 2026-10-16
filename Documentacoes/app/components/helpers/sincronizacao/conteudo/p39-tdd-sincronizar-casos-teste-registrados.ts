import type { ISecao } from '../../../../contracts/documentacao.ts';

import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
const documento = criarDocumentoUnit({
  "nome": "P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS",
  "resumo": "Enumerar registros atuais e orquestrar a sincronização por meio de RegistrarCasoTeste.",
  "responsabilidade": "Enumerar registros atuais e orquestrar a sincronização por meio de RegistrarCasoTeste.",
  "problema": "Separar cadastro/sincronização da execução do caso e manter configuração portável.",
  "fonte": "docs/assets/configuracoesGerais/sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas",
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
      "Configurado pelo processamento; consumido em Sincronizar/RegistrosCasosTestes."
    ]
  ],
  "metodos": [
    [
      "procedure Main;",
      "Enumerar registros atuais e orquestrar a sincronização por meio de RegistrarCasoTeste.",
      "Declaração no fonte, linha 5. Sincronizar abre callback, chama RegistrosCasosTestes(FSincRemoto), fecha callback no finally e apresenta conclusão somente após retorno."
    ],
    [
      "procedure Sincronizar;",
      "Adiciona um callback para feedback ao usuário com finalidade de acompanhamento do processo. Chamada para RegistrosCasosTestes.",
      "Declaração no fonte, linha 28. Sincronizar abre callback, chama RegistrosCasosTestes(FSincRemoto), fecha callback no finally e apresenta conclusão somente após retorno."
    ],
    [
      "procedure RegistrosCasosTestes(pSincRemoto :boolean);",
      "Registrar cada um dos casos de teste com suas respectivas informações sem considerar o prefixo do ambiente remoto. Utilização em sequência do método {TDD_REGISTRAR_CASO_TESTE.}RegistrarCasoTeste.",
      "Declaração no fonte, linha 40. Sincronizar abre callback, chama RegistrosCasosTestes(FSincRemoto), fecha callback no finally e apresenta conclusão somente após retorno."
    ]
  ],
  "implementacao": [
    "Sincronizar abre callback, chama RegistrosCasosTestes(FSincRemoto), fecha callback no finally e apresenta conclusão somente após retorno.",
    "RegistrosCasosTestes faz quatro chamadas de seis argumentos: financeiro, desconto percentual do pedido, unidade fabril e sequência dos itens. Cada caso usa uma única fonte JSON.",
    "O registro financeiro atual usa descrição TDD_FIN_FINANCEIRO, requisito 160.00 e fonte TDD_FIN_FINANCEIRO_JSON. A descrição e a fonte não são a mesma coisa que o nome remoto instalado; pSincRemoto controla o prefixo da leitura.",
    "Os exemplos P39_TDD_JSON_PEDIDO_*.pas do repositório contêm Pascal. Não tratá-los como JSON puro nem afirmar que sua migração remota já ocorreu. Expectativas específicas devem ficar em resultadoEsperado da respectiva fonte."
  ],
  "dependencias": [
    "TDD_REGISTRAR_CASO_TESTE: cláusula uses do fonte."
  ],
  "limites": [
    "Sem execução de SQL, TekStore ou ERP pela documentação. Arquivos e aliases não comprovam nomes remotos instalados.",
    "Fontes inválidos não são substituídos silenciosamente; escrita pode ser parcial, sem atomicidade global ou retry automático."
  ]
});
const secoesAdicionais: ISecao[] = [];
documento.secoes.push(...secoesAdicionais);
export default documento;
