# Pedido de Venda — execução do contrato refatorado

Baseado no fluxo documentado por TEK-JoaoPauloJaques no PR #20 e nos fontes de referência incorporados. O cursor pertence a Teste_Executar; a unit ainda não usa o cursor do molde IRunner.

```mermaid
flowchart TD
    MAIN["P39_TDD_FAT_PEDIDO_VENDA.main"] --> SETUP["Setup: FCadastro, FDM e área"]
    SETUP --> OBJ["Setup_InicializarObjetos: datasets e P39_TDD_MODULO.SetModulo"]
    OBJ --> TELA["AbrirTela: Emisso1Click e referências ao formulário"]
    TELA --> TESTE["Teste → Teste_Executar"]
    TESTE --> CURSOR{"CDSCasosTestes possui próximo registro?"}
    CURSOR -->|Sim| CASO["SetCasoTeste: limpar contexto e ler JSON"]
    CASO --> PARAM{"Há parâmetros no caso?"}
    PARAM -->|Sim| FECHAR["FinalizarFormulario: Free e recuperar foco"]
    FECHAR --> AJUSTAR["VerificarParametros → Relogar quando há alterações"]
    AJUSTAR --> REABRIR["finally: Setup_IniciarFormulario"]
    PARAM -->|Não| JSON["SetJSON_Caso_Teste e ValidarCasoTeste"]
    REABRIR --> JSON
    JSON --> CLIENTE["_IncluiDocumento: carregar clientes"]
    CLIENTE --> PROXIMO{"Próximo cliente?"}
    PROXIMO -->|Sim| INCLUIR["BotaoIncluirClick"]
    INCLUIR --> DADOS["Dados principais → itens → financeiro"]
    DADOS --> ENTREGA["Entrega → faturamento → frete"]
    ENTREGA --> GRAVAR["BotaoGravar.Click"]
    GRAVAR --> PROXIMO
    PROXIMO -->|Não| EXECUTADO["EXECUTADO := S; avançar registro"]
    EXECUTADO --> CURSOR
    CURSOR -->|Não| FIM["Fim do cursor; chamada de teardown comentada"]
```
