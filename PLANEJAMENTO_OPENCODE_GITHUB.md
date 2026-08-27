# PLANEJAMENTO OPENCODE - GITHUB ISSUES

> **Repositório**: TestesAutomatizadosERP  
> **Owner**: GersonTekSystem  
> **Data**: 2026-08-26  
> **Total Issues**: 9 abertas

---

## 📋 VISÃO GERAL DAS ISSUES

| # | Título | Status | Labels | Assignees | Prioridade | Estimativa |
|---|--------|--------|--------|-----------|------------|------------|
| 10 | Estrutura Adotada | OPEN | release | GersonTekSystem, TEK-JoaoPauloJaques | Release | 10h |
| 9 | Debug controlado | OPEN | enhancement, good first issue | GersonTekSystem | Low | 1h |
| 8 | Registrar métricas de tempo da execução | OPEN | enhancement | GersonTekSystem | High | 5h |
| 7 | Parâmetros do Sistema nos casos de teste | OPEN | enhancement | TEK-JoaoPauloJaques | Medium | 5h |
| 6 | Assets para estrutura padrão de testes | OPEN | enhancement | TEK-JoaoPauloJaques | High | 5h |
| 5 | Testes com Financeiro - Refatoração | OPEN | enhancement | GersonTekSystem | Urgent | 5h |
| 4 | Testes com Pedido de Venda | OPEN | enhancement | TEK-JoaoPauloJaques | High | 10h |
| 3 | Estrutura para construção dos testes | OPEN | enhancement | GersonTekSystem, TEK-JoaoPauloJaques | Medium | 5h |
| 2 | Testes com API Dinâmica | OPEN | enhancement | GersonTekSystem | Medium | — |

---

## 🎯 ORDEM DE EXECUÇÃO (FASES)

### **FASE 1 - Fundação** ⏱️ ~6h
**Objetivo**: Estabilizar a base técnica

| Issue | Título | Ações | Dependências |
|-------|--------|-------|--------------|
| **#9** | Debug controlado | • Variável global `FDebugMode` em `P39_TDD_CONSTANTES`<br>• `SetDebugMode` / `IsDebugMode` / `LogDebug`<br>• Centralizar `uses` do `P39_TDD_ASSERTS` | Nenhuma |
| **#3** | Estrutura para construção dos testes | • Finalizar `P39_TDD_CASOS_DE_TESTE` (CDSCamposDisponiveis)<br>• Implementar `P39_REGISTRAR_CASO_TESTE`<br>• Validar JSON schema (módulo, área, parâmetros, resultado)<br>• Testar carga: Faturamento + Financeiro | #9 |

---

### **FASE 2 - Abstração e Padrão** ⏱️ ~15h
**Objetivo**: Criar camada de assets reutilizável

| Issue | Título | Ações | Dependências |
|-------|--------|-------|--------------|
| **#6** | Assets para estrutura padrão | • Criar `P39_TDD_ASSETS.pas`:<br>  - `Setup_CasoTeste(Modulo, Area, CasoTesteId)`<br>  - `TearDown_CasoTeste`<br>  - `ExecutarCasoTeste(Json)`<br>  - `ValidarResultadoEsperado(Atual, Esperado)`<br>• Mover setup repetitivo (conexão, cache, parâmetros)<br>• Documentar padrão: Asset = Setup + Teardown + Exec + Validação | #3 |
| **#10** | Estrutura Adotada | • Consolidar units base em `P39_TDD_CORE.pas` (facade)<br>• Criar template novo caso: `.json` + `.pas` executor<br>• Documentar convenções: nomenclatura, pastas, versionamento<br>• Validar com 2 pilotos: 1 Financeiro + 1 Faturamento | #3, #6 |

---

### **FASE 3 - Observabilidade e Parâmetros** ⏱️ ~10h
**Objetivo**: Métricas de performance e configuração dinâmica

| Issue | Título | Ações | Dependências |
|-------|--------|-------|--------------|
| **#8** | Registrar métricas de tempo | • Em `P39_TDD_ASSETS`: `TStopwatch` para Setup/Exec/Total<br>• Criar tabela `METRICAS_EXECUCAO_TESTE` no banco dedicado:<br>```sql<br>CREATE TABLE METRICAS_EXECUCAO_TESTE (<br>  ID INTEGER PRIMARY KEY,<br>  CASO_TESTE_ID INTEGER,<br>  VERSAO_SISTEMA VARCHAR(20),<br>  TEMPO_SETUP_MS INTEGER,<br>  TEMPO_EXECUCAO_MS INTEGER,<br>  TEMPO_TOTAL_MS INTEGER,<br>  DATA_EXECUCAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP<br>);<br>```<br>• Persistir no `TearDown_CasoTeste` | #3, #6 |
| **#7** | Parâmetros do Sistema | • Estender JSON: `"parametros": {"CHAVE": "VALOR"}`<br>• Em `CarregarConfiguracoes`: ler e aplicar via `P39_TDD_PARAMETRO`<br>• Validar com parâmetros reais Financeiro (`TIPO_BORDERO`, `CONTA_PADRAO`) | #3 |

---

### **FASE 4 - Casos de Negócio** ⏱️ ~15h
**Objetivo**: Entregar testes funcionais prioritários

| Issue | Título | Ações | Dependências |
|-------|--------|-------|--------------|
| **#4** | Testes com Pedido de Venda | • Usar `P39_TDD_FAT_DOCUMENTO_FATURA.pas` como base<br>• Criar `P39_TDD_FAT_PEDIDO_VENDA.json`<br>• Implementar executor usando `P39_TDD_ASSETS`<br>• Cenários: inclusão, alteração, faturamento, cancelamento | #3, #6, #7 |
| **#5** | Testes com Financeiro - Refatoração | ⚠️ **URGENTE**<br>• Refatorar borderôs (recebimento/pagamento) p/ nova estrutura<br>• Unificar JSON: mesmo schema p/ ambos borderôs<br>• Ajustar `P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_*`<br>• Migrar duplicatas (contas pagar/receber)<br>• Sync com TekStore via `atualizarUnitsTesteAutomatizado` | #3, #6, #7 |

---

### **FASE 5 - Expansão** ⏱️ TBD
**Objetivo**: Novos domínios de teste

| Issue | Título | Ações | Dependências |
|-------|--------|-------|--------------|
| **#2** | Testes com API Dinâmica | • Aguardar #8 (métricas p/ comparar versões)<br>• Cases: auth módulos, success/error, HTTP 500, pública, estática<br>• Usar `P39_TDD_ODBC` p/ validar respostas no banco | #3, #8 |

---

## 🚀 PRÓXIMOS PASSOS IMEDIATOS

### **Hoje - Início Fase 1**
1. **Issue #9** (1h): Debug controlado em `P39_TDD_CONSTANTES`
2. **Issue #3** (5h): Estrutura casos de teste - `P39_TDD_CASOS_DE_TESTE` + `P39_REGISTRAR_CASO_TESTE`

### **Esta Semana**
3. **Issue #6** (5h): `P39_TDD_ASSETS.pas` - camada de abstração
4. **Issue #10** (10h): Consolidação + documentação + validação pilotos

### **Próxima Semana**
5. **Issue #8** (5h): Métricas + tabela banco
6. **Issue #7** (5h): Parâmetros dinâmicos
7. **Issue #4** (10h): Pedido de Venda (paralelo com #5 se possível)

### **Urgente - Paralelo**
8. **Issue #5** (5h): Refatoração Financeiro - prioridade máxima

---

## 🛠️ COMANDOS ÚTEIS

```bash
# Sincronizar units da TekStore (após definir diretório local)
atualizarUnitsTesteAutomatizado

# Verificar estrutura atual
ls docs/assets/**/*.pas

# Ver issues no GitHub
gh issue list --repo GersonTekSystem/TestesAutomatizadosERP --state open
```

---

## 📁 ESTRUTURA ATUAL DE UNITS (mapeamento)

```
docs/assets/
├── configuracoesGerais/
│   ├── P39_TDD_CONSTANTES.pas           # ✅ Base - constantes, cache, SQL
│   ├── P39_TDD_CASOS_DE_TESTE.pas       # 🔄 Em desenvolvimento - carga casos
│   ├── P39_TDD_FUNCOES_JSON.pas         # ✅ Utils JSON
│   ├── P39_TDD_PARAMETRO.pas            # ✅ Parâmetros sistema
│   └── manipulacaoParametros/
│       ├── P39_TDD_PARAMETRO.pas
│       └── P39_TDD_PARAMETRO_MAPEAMENTO.pas
├── persistenciasODBC/
│   ├── P39_TDD_ODBC.pas                 # ✅ Wrapper ODBC centralizado
│   ├── P39_TDD_REGISTRAR_CASO_TESTE.pas # 🔄 A implementar
│   ├── P39_TDD_CARREGAR_CASO_TESTE.pas  # 🔄 A implementar
│   └── P39_TDD_SINCRONIZAR_CASOS_TESTE_REGISTRADOS.pas
├── casosTestesFaturamento/
│   ├── P39_TDD_FAT_DOCUMENTO_FATURA.pas      # ✅ Base faturamento
│   ├── P39_TDD_FAT_PEDIDO_VENDA.pas          # 🎯 Issue #4
│   └── P39_TDD_DOCUMENTO_FATURA_SQL.pas
├── casosTestesFinanceiro/
│   ├── P39_TDD_FIN_CONFIG_FINANCEIRO.pas
│   ├── P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO.pas   # 🎯 Issue #5
│   ├── P39_TDD_FIN_INCLUIR_BORDERO_PAGAMENTO.pas     # 🎯 Issue #5
│   ├── P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO.pas
│   ├── P39_TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_PAGAMENTO.pas
│   ├── P39_TDD_FIN_CONTAS_RECEBER.pas
│   └── P39_TDD_FIN_CONTAS_PAGAR.pas
└── emDesenvolvimento/
    ├── P39_TDD_FIN_INCLUIR_BORDERO_RECEBIMENTO.pas
    ├── EXEMPLO_CARREGAR_CASO_TESTE.pas
    └── TDD_CARREGAR_CASO_TESTE.pas
```

---

## ✅ CRITÉRIOS DE CONCLUSÃO POR FASE

### Fase 1 ✅
- [ ] Debug ligado/desligado funcionando sem quebrar testes existentes
- [ ] Casos de teste carregam do banco para JSON válido
- [ ] `P39_REGISTRAR_CASO_TESTE` persiste novo caso

### Fase 2 ✅
- [ ] `P39_TDD_ASSETS` usado por 2+ casos de teste
- [ ] Template documentado e validado
- [ ] Zero setup duplicado nos casos de negócio

### Fase 3 ✅
- [ ] Métricas salvas no banco a cada execução
- [ ] Parâmetros do JSON aplicados no sistema antes do teste
- [ ] Comparação de versões funcionando (setup/exec/total)

### Fase 4 ✅
- [ ] Pedido de Venda: 4 cenários passando
- [ ] Financeiro: borderôs + duplicatas refatorados e passando
- [ ] Units sincronizadas na TekStore

### Fase 5 ✅
- [ ] 5 cenários de API Dinâmica implementados
- [ ] Métricas de performance comparadas entre versões

---

> **Última atualização**: 2026-08-26 - Plano criado a partir das issues GitHub e análise do código atual