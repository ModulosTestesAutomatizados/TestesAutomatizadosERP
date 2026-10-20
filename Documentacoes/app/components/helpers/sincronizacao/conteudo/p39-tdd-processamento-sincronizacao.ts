import type { ISecao } from '../../../../contracts/documentacao.ts';

import { criarDocumentoUnit } from '../../../../contracts/criarDocumentoUnit.ts';
const documento = criarDocumentoUnit({
  "nome": "P39_TDD_PROCESSAMENTO_SINCRONIZACAO",
  "resumo": "Configurar a origem e iniciar a sincronização dos casos cadastrados.",
  "responsabilidade": "Configurar a origem e iniciar a sincronização dos casos cadastrados.",
  "problema": "Separar cadastro/sincronização da execução do caso e manter configuração portável.",
  "fonte": "docs/assets/configuracoesGerais/Sincronizar/P39_TDD_PROCESSAMENTO_SINCRONIZACAO.pas",
  "estado": "em-desenvolvimento",
  "tipoArtefato": "processamento",
  "navegacao": {
    "grupo": "helpers",
    "subgrupo": "sincronizacao",
    "ordem": 2
  },
  "aliases": [
    "TDD_PROCESSAMENTO_SINCRONIZACAO"
  ],
  "estados": [],
  "metodos": [
    [
      "procedure Main;",
      "Perguntar a origem e a exibição de instruções antes de iniciar a sincronização.",
      "Declaração no fonte, linha 5. Usa FiltroLogicoEmBoolean para FSincRemoto e FExibirInstrucoes, chama a Main da unit de sincronização e depois Sincronizar. FSincRemoto pertence a P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS."
    ]
  ],
  "implementacao": [
    "Main apresenta 'Sincronizar Remoto?' e 'Exibir Instruções?' por TDD_FILTROS antes da sincronização. Cada resposta é atribuída à flag correspondente; o valor inicial de cada filtro é N. Sincronizar apresenta depois sua própria pergunta 'Sincronizar com Remoto? (Tek Store)' e atualiza FSincRemoto; ambas as perguntas são intencionais.",
    "O fluxo de sincronização é separado de IRunner.Executar: resolve e persiste os dados antes de o runner carregar o lote. Não executa o cenário financeiro nem é fallback consultado por cada tentativa."
  ],
  "dependencias": [
    "P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS: cláusula uses do fonte.",
    "TDD_FILTROS: cláusula uses do fonte; recebe FSincRemoto e FExibirInstrucoes por referência."
  ],
  "limites": [
    "Sem execução de SQL, TekStore ou ERP pela documentação. Arquivos e aliases não comprovam nomes remotos instalados; TDD_FILTROS precisa estar disponível no interpretador.",
    "Fontes inválidos não são substituídos silenciosamente; escrita pode ser parcial, sem atomicidade global ou retry automático."
  ]
});
const secoesAdicionais: ISecao[] = [];
documento.secoes.push(...secoesAdicionais);
export default documento;
