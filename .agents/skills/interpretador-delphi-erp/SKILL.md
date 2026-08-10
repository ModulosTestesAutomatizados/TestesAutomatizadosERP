---
name: interpretador-delphi-erp
description: Utilize essas habilidade sempre que precisar de desenvolver alguma codificação Pascal destinadas a serem executadas no interpretador do ERP.
---

# Motor do módulo BI

## Pascal Script

Nosso ERP possui um módulo chamado: *'BI - Inteligência de Negócios'*. Esse método é capaz de desenvolver diversas codificações escritas em Pascal e serem interpretadas dentro do ERP. O Interpretados utilizado é o Pascal Script, então não temos as mesmas ferramentas que o Delphi disponibilizaria, mas temos muitos recursos!

## Limitações

Unidades de codificação possuem diversas limitações, vou listar as principais:

- Não se pode gerar classes!
- Records não podem ser utilizados como parâmetros de métodos, sejam procedures ou functions, também não podem ser utilizados entre units com uses;

## Particularidades

Assim como as limitações, nossas unidades de codificação possuem diversas particularidades, existem métodos nativos do nosso ERP que são disponibilizados para o interpretador.

- Herança de uses, descarta a necessidade de uses redundante, ex:

| Unit              | uses          |
| ----------------- | ------------- |
| CONSTANTES        | N/D           |
| CONFIGURACOES     | CONSTANTES    |
| PROCESSAMENTO     | CONFIGURACOES |

Assim é possível utilizar codificações escritas em CONSTANTES por meio das codificações de PROCESSAMENTO.

- Referenciar no `uses` o nome exato da unit que existe no ambiente de destino: units
  globais do ERP usam o prefixo `P39_TDD_*`; units locais em desenvolvimento usam
  `TDD_*`. Referenciar um nome sem o prefixo `P39_` quando a unit global real é
  `P39_TDD_*` (ex.: `TDD_REGISTRAR_CASO_TESTE` em vez de
  `P39_TDD_REGISTRAR_CASO_TESTE`) causa erro de resolução de `uses` no interpretador.

- Métodos disponibilizados para facilitar alguns processos:

| Método                                   | Finalidade                                                               |
| ---------------------------------------- | ------------------------------------------------------------------------ |
| `FormCriadoPeloNome(pNome)`              | Verifica se o form já existe pelo nome. Retorna o form ou `nil`.         |
| `CriarFormPeloNome(pNome)`               | Cria o form pelo nome. Usado como fallback quando `FormCriadoPeloNome` retorna `nil`. |
| `DMCriadoPeloNome(pNome)`                | Verifica/obtém um DataModule criado pelo nome.                           |
| `FindComponent(pNome)`                   | Localiza um componente (form, DM, CDS, edição, etc.) pelo nome.          |
| `AtribuirValorPropriedadeDeObjeto(pObj, pPropriedade, pValor)` | Atribui valor a uma propriedade de objeto via nome. |
| `ExecutarMetodoDeObjeto(pObj, pMetodo, pParams)` | Invoca um método do objeto via nome, passando parâmetros.      |
| `CallBack_AbreTela(pClassOwner)`         | Dispara o callback que abre a tela no fluxo do teste.                    |
| `CallBack_Mensagem(pClassOwner, pMensagem)` | Dispara o callback que exibe uma mensagem de progresso do teste.     |
| `CallBack_FechaTela(pClassOwner)`        | Dispara o callback que fecha a tela no fim do fluxo.                     |
| `ClassOwner`                             | Identifica a classe/unit proprietária do fluxo do teste.                 |
| `MostrarLogTexto(pTexto, pTitulo)`       | Exibe uma janela de log com texto e título. Usado na `Main` de documentação e para debug. |
| `ShowMessage(pMensagem)`                 | Exibe uma mensagem simples ao usuário.                                   |
| `EnviarMensagemInterna(pDestinatario, pTitulo, pMensagem)` | Envia mensagem interna no ERP.                    |
| `Nome_Usuario_Atual`                     | Nome do usuário logado no ERP.                                           |
| `MensagemPersonalizada`                  | Prefixo padrão para mensagens de erro/validação das codificações TDD.    |
| `GetValueJson(pJson, pTag)`              | Lê o valor de uma tag de um JSON. Usado pelos wrappers do `P39_TDD_FUNCOES_JSON`. |
| `JSONFormatado(pJson)`                   | Formata/indenta um JSON para exibição (debug).                           |
| `CodificacaoUnit(pNomeUnit)`             | Retorna o conteúdo (código) de uma unit pelo nome.                       |
| `SincronizarCasoTeste`                   | Sincroniza o registro de um caso de teste no banco dedicado.             |
