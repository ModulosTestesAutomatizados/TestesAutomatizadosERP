import type { IDocumento } from '../../../../contracts/documentacao.ts';
export default {
  "slug": "p39-tdd-sincronizar-casos-teste-registrados",
  "categoria": "units",
  "titulo": "P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS",
  "unit": "P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS",
  "tipoArtefato": "unit",
  "aliases": [],
  "resumo": "Mantém a seleção local/remota e a lista de casos enviados ao registrador.",
  "estado": "em-uso",
  "navegacao": {
    "grupo": "helpers",
    "subgrupo": "sincronizacao",
    "ordem": 1
  },
  "fontes": [
    {
      "caminho": "docs/assets/configuracoesGerais/Sincronizar/P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas"
    }
  ],
  "simbolos": [
    {
      "nome": "FSincRemoto",
      "tipo": "estado",
      "secao": "estados",
      "aliases": []
    },
    {
      "nome": "Main",
      "tipo": "metodo",
      "assinatura": "procedure Main"
    },
    {
      "nome": "Sincronizar",
      "tipo": "metodo",
      "assinatura": "procedure Sincronizar"
    },
    {
      "nome": "RegistrosCasosTestes",
      "tipo": "metodo",
      "assinatura": "procedure RegistrosCasosTestes(pSincRemoto: boolean)"
    }
  ],
  "secoes": [
    {
      "id": "responsabilidade",
      "titulo": "Responsabilidade e problema resolvido",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "Percorrer as chamadas de registro definidas em código e apresentar feedback do processo de sincronização."
        },
        {
          "tipo": "paragrafo",
          "texto": "Concentrar a relação de casos e o ambiente de origem sem reproduzir o SQL de cadastro."
        }
      ]
    },
    {
      "id": "estados",
      "titulo": "Estados globais",
      "blocos": [
        {
          "tipo": "tabela",
          "colunas": [
            "Estado / tipo",
            "Finalidade",
            "Ciclo de vida"
          ],
          "linhas": [
            [
              "FSincRemoto: Boolean",
              "Seleciona leitura remota quando true; false seleciona os nomes locais.",
              "Declarado nesta unit e consumido por Sincronizar. O fonte não o inicializa explicitamente nem o restaura ao encerrar. P39_TDD_PROCESSAMENTO_SINCRONIZACAO atribui True antes de chamar Sincronizar."
            ]
          ]
        }
      ]
    },
    {
      "id": "metodos",
      "titulo": "Procedures e functions",
      "blocos": [
        {
          "tipo": "paragrafo",
          "texto": "As assinaturas abaixo pertencem ao fonte referenciado. Cada entrada descreve sua responsabilidade e a forma de implementação."
        }
      ]
    },
    {
      "id": "main",
      "titulo": "Main",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Main;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Mostrar as instruções do sincronizador."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama MostrarInstrucoesUnit com o contrato de FSincRemoto e das duas rotinas de sincronização. Não chama Sincronizar."
        }
      ]
    },
    {
      "id": "sincronizar",
      "titulo": "Sincronizar",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure Sincronizar;"
        },
        {
          "tipo": "paragrafo",
          "texto": "Executar a lista com feedback visual."
        },
        {
          "tipo": "paragrafo",
          "texto": "Abre o callback, informa o carregamento e chama RegistrosCasosTestes(FSincRemoto). Fecha a tela de callback em finally. Depois apresenta a mensagem de conclusão; uma exceção propaga e impede essa mensagem."
        }
      ]
    },
    {
      "id": "registroscasostestes",
      "titulo": "RegistrosCasosTestes",
      "nivel": 3,
      "blocos": [
        {
          "tipo": "codigo",
          "linguagem": "pascal",
          "codigo": "procedure RegistrosCasosTestes(pSincRemoto: boolean);"
        },
        {
          "tipo": "paragrafo",
          "texto": "Definir e registrar os quatro casos atuais."
        },
        {
          "tipo": "paragrafo",
          "texto": "Chama P39_TDD_REGISTRAR_CASO_TESTE.RegistrarCasoTeste em sequência para Financeiro e três cenários de pedido de venda. Encaminha pSincRemoto para cada chamada. Os nomes das units JSON são informados sem o prefixo remoto."
        }
      ]
    },
    {
      "id": "implementacao",
      "titulo": "Como a unit é implementada",
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "A lista atual contém TDD_FINANCEIRO com requisito 160.00 e três pedidos: desconto percentual, unidade fabril e sequência nos itens.",
            "Os pedidos usam TDD_JSON_BASE_RESULTADO_ESPERADO. Campos disponíveis são informados como nome vazio nos quatro registros e se tornam {} no registrador.",
            "O formato de requisito de versão xxx.yy aparece nas instruções. A lista usa string vazia nos três pedidos; o sincronizador não valida esse formato.",
            "cPrefixoSincRemoto é acrescentado somente por CarregarConteudoUnit no registrador; não altere os nomes JSON da lista para repetir esse prefixo.",
            "A mensagem final não distingue inserts, updates confirmados e updates recusados. Recusar um update permite continuar a lista; uma exceção interrompe as chamadas restantes.",
            "FSincRemoto continua com o último valor atribuído. Não há transação global nem reversão dos casos já sincronizados."
          ]
        }
      ]
    },
    {
      "id": "dependencias",
      "titulo": "Dependências e integração",
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "Uses direto: P39_TDD_REGISTRAR_CASO_TESTE, que resolve JSONs e persistência via P39_TDD_ODBC.",
            "CallBack_AbreTela, CallBack_Mensagem, CallBack_FechaTela e ClassOwner são recursos do host ERP.",
            "P39_TDD_PROCESSAMENTO_SINCRONIZACAO configura o estado e inicia a execução."
          ]
        },
        {
          "tipo": "paragrafo",
          "texto": "O nome canônico identifica o arquivo Pascal e a página. O fonte vinculado é a evidência local; confira o cadastro e a versão da unit instalada no ERP antes de executar."
        }
      ]
    },
    {
      "id": "limites",
      "titulo": "Limites e observações",
      "blocos": [
        {
          "tipo": "lista",
          "itens": [
            "A lista é explícita no Pascal; esta documentação não adiciona nem sincroniza registros.",
            "Não há isolamento de FSincRemoto entre execuções no mesmo contexto.",
            "A disponibilidade das units JSON e os nomes cadastrados no ERP/TekStore exigem validação no ambiente de execução."
          ]
        }
      ]
    }
  ]
} satisfies IDocumento;
