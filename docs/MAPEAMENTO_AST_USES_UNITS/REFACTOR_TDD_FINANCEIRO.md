# REFACTOR_TDD_FINANCEIRO — Fonte Detalhado e AST de Uses

> Baseline v25 (fluxo sequencial operacional). Unit no banco local, código 38,
> grupo 1367 (Financeiro), autoria `AGENTE_TDD`. `Main` intocada por acordo.

## AST de Uses — visão alvo (tudo em P39_TDD / Tek Store)

```mermaid
graph TD
    subgraph Orquestrador
        A["P39_REFACTOR_TDD_FINANCEIRO<br/>(local 38)"]
    end

    subgraph Infra de Caso de Teste
        B["P39_TDD_CARREGAR_CASO_TESTE<br/>(local 31)"]
        C["P39_TDD_REGISTRAR_CASO_TESTE<br/>(local 28)"]
        D["P39_TDD_ODBC<br/>(local 30)"]
        E["P39_TDD_CONSTANTES<br/>(Tek Store 2968)"]
    end

    subgraph Mapeamentos de Tela
        F["P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO<br/>(local 26)"]
        G["P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO<br/>(Tek Store 2911)"]
    end

    subgraph Sincronizacao do Cenario
        H["P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS<br/>(local 29)"]
        I["P39_TDD_JSON_BASE_CADASTRO_DUPLICATAS_RECEBER<br/>(local 27 - JSON base Financeiro)"]
    end

    subgraph Proxima Iteracao (estudo)
        J["P39_TDD_PARAMETRO<br/>(Tek Store 2969)"]
        K["P39_TDD_PARAMETRO_MAPEAMENTO<br/>(Tek Store 2970)"]
        L["P39_TDD_ASSERTS<br/>(Tek Store 3042)"]
        M["P39_TDD_CASOS_DE_TESTE<br/>(Tek Store 2971)"]
        N["P39_TDD_FUNCOES_JSON<br/>(Tek Store 2972)"]
    end

    A --> B
    A --> F
    A --> G
    B --> C
    C --> D
    D --> E
    H --> C
    I -. alimenta .-> H

    J -.-> K
    J -.-> N
    L -.-> M

    style A fill:#2e7d32,color:#fff
    style J fill:#1565c0,color:#fff
    style K fill:#1565c0,color:#fff
    style L fill:#1565c0,color:#fff
```

**Fluxo de dados:** `I` (JSON compacto) → `H` sincroniza → `CASO_TESTE.CASO_TESTE_CT`
(dedicado) → `B` carrega → `A` consome via tags.

## Anatomia da unit (v25)

### Constantes
| Constante | Valor | Função |
|---|---|---|
| `cModuloFinanceiro` / `cAreaFinanceiro` / `cCasoTesteUnico` | 'FINANCEIRO' ×2 / 'TDD_FINANCEIRO' | Chave do caso no banco dedicado |
| `cTipoDuplicataReceber/Pagar` | 0 / 1 | Seleção do form (`FCadReceber`/`FCadPagar`) |
| `cFormReceber/cFormPagar/cDMCadDuplicata` | nomes | Formulários + DataModule compartilhado |
| `cEtapaDuplicataReceber..cEtapaBorderoPagamento` | 1..4 | Etapas individuais (debug pontual) |
| `cEtapaFluxoCompleto` | **0** | Executa as 4 etapas em sequência |
| `cEtapaAtual` | `cEtapaFluxoCompleto` | Modo corrente de execução |

⚠️ Nenhuma constante de ID de registro: pessoa, conta e prazo vêm **do JSON**
(`PESSOANOTACREDITO_BORD`, `CONTA_BORD`, `PRAZOVENCIMENTO_DUP`) com fallback na
`FINANCEIRO_CONFIGURACAO`.

### Variáveis (estado da unit)
`FCDSCasoTeste` (caso carregado), `FCDSConfig` (FINANCEIRO_CONFIGURACAO via ODBC),
`FJSONCasoTeste` (cenário), `FCasoTesteInvalido` + `FMsgCasoTesteInvalido` (validação).

### Ciclo de vida — padrão Motor
- `ExecutarFluxoCompletoFinanceiro` → `Setup; try Teste; finally TearDown_DestruirObjetos`.
- `Setup_InicializarObjetos`: cria os dois CDS, `{TDD_CARREGAR_CASO_TESTE.}CarregarCasoTeste(...)` lê o caso do dedicado (**coluna `CASO_TESTE_CT`**), config financeira via `{TDD_CARREGAR_CASO_TESTE.}TDDReaderODBCP`, depois `ValidarCasoTeste`.
- `Teste`: valida caso/config e despacha via `case cEtapaAtual`; o ramo `cEtapaFluxoCompleto` encadeia as 4 etapas, cada uma envolta em `try/except` que re-raise com rótulo `[Fluxo] Falha na Etapa X (...)`.

### Etapa 1/2 — `_IncluirDuplicata(pTipo)`
1. Resolve form (`FCadReceber`/`FCadPagar`) com `FormCriadoPeloNome` → `CriarFormPeloNome` → `Show`; obtém `DMCadDuplicata`, `CDSCadastro`, `CDSDuplicata_GrupoResultado`, `EditPessoa`.
2. **Higiene:** `Cancel` no CDS residual (as duas duplicatas compartilham o mesmo DM).
3. `BotaoAbrirClick` + `BotaoIncluirClick`; se `State < 2` (não está em edit/insert), clica incluir novamente.
4. Preenche a partir do JSON com fallbacks: `PESSOA_DUP→CLIENTE/FORNECEDOR_FINCONFIG`, `VALOR_DUP→VALOR_PADRAO_*_FINCONFIG`, `GRUPORESULTADO_DUPGR→GR_CONTAS_*_FINCONFIG`, `TIPODOC_DUP→TIPO_FINCONFIG`, `QUALIFICACAO_DUP` (se >0).
5. Documento único: `'DUP_' + FormatDateTime('hh_mm_ss_zz', DataHoraServidor)`; emissão = servidor; **vencimento = Hoje + PRAZOVENCIMENTO_DUP**.
6. Insere grupo de resultado com mesmo valor; `BotaoGravarClick`; **fecha o form**.

### Etapa 3 — `_IncluirBorderoRecebimento`
Usa `{TDD_FIN_MAPEAMENTO...RECEBIMENTO.}` `MapearBordero`/`IncluirBordero`/`Filtrar`/`GravarBordero`. Marca todas as duplicatas em aberto da pessoa (`MARQUE := 1`, soma `VLREMABERTO`), complemento com `ContaBorderoPadrao` e valor total, grava e chama `Fechar` da unit 26.

### Etapa 4 — `_IncluirBorderoPagamento`
`CriarObjetos` + `IniciarCDSCadastroBordero` (unit global 2911); `Cancel` residual; `BotaoIncluirClick`; preenche `CONTA_BORDERO` (JSON `CONTA_BORD` → fallback `CONTA_PRINCIPAL_FINCONFIG`) e `PESSOANOTACREDITO_BORDERO` (JSON `PESSOANOTACREDITO_BORD`, só se >0); fornecedor do JSON (`PESSOA_DUP` → `FORNECEDOR_FINCONFIG`) injetado no `CDSSelecao` (`DefinirPessoaSelecao`); janela de filtro ampliada (`Hoje±365`) para alcançar vencimentos futuros; marca contas filtradas, complemento, grava e fecha o form.

### Helpers de leitura de tags
- `ExtrairTag(pJson, pTag): String` — 1º tenta nativo `GetValueJson(pJson, pTag)`; fallback `Pos/Copy` sobre marcador `"TAG":`. Centraliza todo acesso ao cenário.
- `ValorInteiroTagLocal(pJson, pTag, pDefault)` — espelha oficial: conversão via variável tipada + `try/except`.
- `ValorCurrencyTagLocal(pJson, pTag, pDefault)` — `StrToCurrDef(Troca(valor,'.',','))`.

### Validação — `ValidarCasoTeste`
Exige JSON não vazio e tags `EMPRESA_DUP`/`TIPODOC_DUP` > 0. Em falha anexa bloco `[DEBUG]`/`[DEBUG2]` (Len, Pos das tags, início bruto, retorno de TagJson) à mensagem enviada por `EnviarMensagemInterna`.

## Contratos de runtime do interpretador (aprendizados aplicados)

1. Chamadas a units do `uses`: `{Unit.}Metodo` = comentário + chamada não qualificada; `Unit.Main;` qualificada sem chaves para documentação.
2. Aridade e tipos são checados na compilação: mudou assinatura → propagar em todas as chamadas; nunca atribuir inteiro direto a retorno `Currency`.
3. Comandos ODBC parametrizados **não** recebem `QuotedStr` (aspas literais corrompem blobs).
4. Fluxo sequencial exige fechar o form ao fim de cada etapa e descartar edição residual do CDS compartilhado (`Cancel` + guarda `State < 2`).
5. Após atualização externa da unit, fechar/reabrir no BI antes de executar (cache da sessão sobrescreve o banco).
