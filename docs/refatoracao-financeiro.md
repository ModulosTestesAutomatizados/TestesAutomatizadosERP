# Refatoração Financeiro — Caso Único TDD_FINANCEIRO

**Issue:** #5 (Testes com Financeiro - Refatoração) · **Baseline:** v25 (2026-08-26) · **Status:** Fluxo sequencial completo operacional ✅

## Objetivo

Substituir os antigos casos de teste fragmentados da área Financeiro (BORDERÔ: "CADASTRAR DUPLICATA A RECEBER/PAGAR", etc.) por **um único caso de teste** (`TDD_FINANCEIRO`) cujo cenário vive num **JSON plano e genérico**, executado pela unit orquestradora `REFACTOR_TDD_FINANCEIRO` nas 4 etapas do ciclo financeiro:

1. Cadastro de Duplicata a Receber
2. Cadastro de Duplicata a Pagar
3. Borderô de Recebimento (baixa as duplicatas a receber)
4. Borderô de Pagamento (baixa as duplicatas a pagar)

## Arquitetura

```text
TDD_JSON_BASE_FINANCEIRO (unit 27 = corpo do JSON compacto)
        │  Sincronizar (29)
        ▼
CASO_TESTE.CASO_TESTE_CT (banco dedicado, coluna BLOB texto)
        │  CarregarCasoTeste (31, via TDD_ODBC)
        ▼
FJSONCasoTeste (memória, na unit 38)
        │  ValorInteiroTagLocal / ValorCurrencyTagLocal (ExtrairTag)
        ▼
Fluxo sequencial das 4 etapas (cEtapaAtual: 0=completo, 1..4=individual)
```

### Contratos estabelecidos

1. **O JSON é a fonte da verdade.** Proibidas constantes mocadas de IDs (ex.: pessoa, conta, prazo). Tag zerada = fallback da `FINANCEIRO_CONFIGURACAO` (rede de segurança).
2. **JSON gravado sempre compacto**, sem aspas literais e sem espaços após `:`/`,` — o parser nativo falha silenciosamente com formato sujo, e a tela do ERP regrava pretty-printed com aspas.
3. **Tags do JSON atual:** `EMPRESA_DUP`, `TIPODOC_DUP`, `QUALIFICACAO_DUP`, `PESSOA_DUP`, `VALOR_DUP`, `GRUPORESULTADO_DUPGR`, `CONTA_BORD`, `PESSOANOTACREDITO_BORD`, `PRAZOVENCIMENTO_DUP`.

## Mapeamento Local ↔ Tek Store (alvo P39_TDD)

| ID | Unit local                                                    | Tek Store | Nome alvo                                       |
|----|---------------------------------------------------------------|-----------|-------------------------------------------------|
| 38 | REFACTOR_TDD_FINANCEIRO                                       | — (nova)  | `P39_REFACTOR_TDD_FINANCEIRO`                   |
| 27 | TDD_JSON_BASE_FINANCEIRO                                      | 2992      | `P39_TDD_JSON_BASE_CADASTRO_DUPLICATAS_RECEBER` |
| 28 | TDD_REGISTRAR_CASO_TESTE                                      | 2984      | `P39_TDD_REGISTRAR_CASO_TESTE`                  |
| 29 | TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS                       | 2985      | `P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS`   |
| 30 | TDD_ODBC                                                      | 2983      | `P39_TDD_ODBC`                                  |
| 31 | TDD_CARREGAR_CASO_TESTE                                       | 2987      | `P39_TDD_CARREGAR_CASO_TESTE`                   |
| 26 | TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO            | 2997      | homônima                                        |
| —  | (global) P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO | 2911      | homônima                                        |

## Linha do tempo — problemas resolvidos (conhecimento preservado)

| Versão | Problema | Solução / Lição |
| --- | --- | --- |
| v12–v18 | `Too many actual parameters` em qualquer execução | Wrappers locais declarados com 2 params e chamados com 3 (herança do estilo global `FUNCOES_JSON`). Checagem de **aridade é em tempo de compilação**. |
| v19+ | `Type mismatch` entre BK2/BK3 | Atribuição de `StrToInt` direto em retorno `Currency`; corrigido espelhando a oficial (`StrToCurrDef(Troca(valor,'.',','))`) e `ContaBorderoPadrao` virou `Integer`. |
| — | Suspeita errada de chamada qualificada à `Main` | Chamada qualificada `Unit.Main;` **é válida** (units 29/31 usam); só não pode `{Unit.}Main` (recursão). |
| v20/v21 | JSON sujo no banco dedicado | `QuotedStr()` nos parâmetros do comando ODBC **parametrizado** na unit 28 gravava aspas literais. Removido. Coluna mudou: `JSON_CASO_TESTE` → **`CASO_TESTE_CT`** (IDs viraram BIGINT). |
| v22 | Constante mocada `3256` | Substituída por tag `PESSOANOTACREDITO_BORD` no JSON (contrato JSON-first). Idem `PRAZOVENCIMENTO_DUP` no lugar de `cPrazoVencimentoDias`. |
| v24/v25 | Etapa 2 falhava: `CDSCadastro: Dataset not in edit or insert mode` | As duas duplicatas compartilham `DMCadDuplicata`; tela aberta da etapa anterior segurava o dataset. Corrigido com `Cancel` no CDS residual antes de abrir + **fechamento do form ao fim de cada etapa** (`Close` / `Fechar` da 26). Rótulos `[Fluxo] Falha na Etapa X` identificam a etapa em erro. |
| transversal | Sessão do ERP regravava versão antiga sobre atualizações | Cache em memória da unit no BI: **fechar/reabrir a unit após atualização externa**. Auditoria `USUARIOALTERACAO_UNIT='AGENTE_TDD'` revela autoria. |

## Próxima iteração — estudo das units Tek Store (somente leitura)

Baixadas em `%TEMP%\tekstore\` (2969, 2970, 3042):

- **2969 `P39_TDD_PARAMETRO`** — ajusta parâmetros do ERP a partir de um JSON: monta SELECT dinâmico via `ExecutarMetodoDeClasse('ClassConfigSistema', ..., 'CamposCadastro')` sobre `CONFIG_SISTEMA`/`CONFIG_SISTEMA_EMPRESA`/`PCP_CONFIG`, compara valor atual × desejado (`NecessarioModificarParam`) e gera UPDATE tipado (string/inteiro/currency/boolean). Depende de `SecaoParametroJson` e `Codigo_Empresa_Atual` (globais do ERP).
- **2970 `P39_TDD_PARAMETRO_MAPEAMENTO`** — array fixo `[0..8]` de `TMapeamentoParametro` (CampoJSON ↔ CampoDB ↔ Tabela). Já contém parâmetros críticos de Financeiro: `NecessarioAutorizarPagamentos`, `NecessarioAutorizarAdiantamentos`, `ObrigatorioGrupoResultadoDiferenteDeZeroNaDuplicata`, `BloquearLancamentoBorderoQualificacao0Todas`, `BorderoExigirPreenchimentoRegraIntegracaoContabil`. ⚠️ Observado (sem alterar): as buscas `cTipoCampoJSON`/`cTipoCampoDB` em `GetCampo` estão com os lados invertidos.
- **3042 `P39_TDD_ASSERTS`** — framework de validação de resultado esperado: parseia JSON com seções `erro` (quantidade/operação), `valor[]` (campo/operação/resultado) e `tempo`, populando `CDSErro`/`CDSValor`/`CDSTempo`. Usa nativos `TJSONObject.ParseJSONValue`, `GetObjectJson`, `GetArrayJsonOrEmpty`, `GetValueJsonDef`. É o motor para consumir a coluna `RESULTADO_ESPERADO_CT`.

Plano sugerido: usar PARAMETRO+MAPEAMENTO para garantir estado de parâmetros antes do fluxo (ex.: desligar autorização de pagamento) e ASSERTS para validar o resultado contra `RESULTADO_ESPERADO_CT`.
