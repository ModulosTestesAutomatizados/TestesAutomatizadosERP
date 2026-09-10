---
name: mermaid-testes-automatizados
description: Use quando o usuário chamar "AtualizarMermaid" ou pedir para atualizar/gerar o diagrama Mermaid das units de teste automatizado (TDD) após atualizar o diretório de SourceTDD. Analisa as units .pas, monta o grafo de dependências (uses) e gera o diagrama no Draw.IO, salvando em D:\TestesAutomatizados\ERP\Mermaid.
---

# Mermaid Testes Automatizados

Gera e atualiza o diagrama **Mermaid** do projeto de testes automatizados a partir
das units `.pas` localizadas no diretório padrão de source, usando o **Draw.IO**
para montar o diagrama visual.

## 1. Diretórios padrão

| Item | Valor |
| ---- | ----- |
| diretório de análise (units) | `D:\TestesAutomatizados\ERP\SourceTDD` |
| diretório de saída (mermaid) | `D:\TestesAutomatizados\ERP\Mermaid` |
| arquivo de saída principal | `D:\TestesAutomatizados\ERP\Mermaid\mermaid-units.md` |

- Usar esses diretórios **sem perguntar**, salvo solicitação explícita do usuário.
- Criar a pasta de saída com `New-Item -ItemType Directory -Force` se não existir.

## 2. Análise das units

1. Listar arquivos `.pas` do diretório de análise.
2. Para cada arquivo, extrair as cláusulas `uses` (interface **e** implementation).
   Essas units são Pascal Script, então `uses` costuma aparecer na **primeira linha**.
3. Montar um mapeamento `unit X` -> `dependências de X`:
   - Nome da unit = nome do arquivo `.pas` sem a extensão.
   - Dependência = cada identificador listado em `uses`.
4. Tratar **aliases**: units referenciadas em `uses` **sem** o prefixo `P39_`
   (ex.: `TDD_CASOS_DE_TESTE`, `TDD_FAT_DOCUMENTO_FATURA_ITENS`,
   `TDD_DOCUMENTO_FATURA`, `FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO`,
   `TDD_ASSERTS`) devem ser resolvidas como referência à unit `P39_TDD_*`
   correspondente quando existir (motor de script do ERP interpreta como alias).

## 3. Geração no Draw.IO

Usar as ferramentas MCP do Draw.IO para montar o diagrama:

1. `drawio_list-documents` para obter o(s) documento(s) aberto(s).
   - Se **nenhum** documento estiver conectado, informar ao usuário e solicitar que
     abra o arquivo `.drawio`/editor, OU gerar diretamente o markdown Mermaid na
     pasta de saída (fallback), mantendo a legenda e a árvore hierárquica.
2. Para cada unit, criar um nó com `drawio_add-rectangle` (ou `drawio_add-cell-of-shape`):
   - `text`: `NomeDaUnit<br/><i>descrição da responsabilidade</i>`
   - `style`: cor conforme a categoria (ver seção 4).
3. Para cada dependência, criar a aresta com `drawio_add-edge`:
   - `source_id` = unit dependente, `target_id` = dependência.
   - rótulo (`text`) = [`uses`] ou [`alias`] quando for via nome sem prefixo.
4. Exportar com `drawio_export-diagram` (SVG/PNG) e salvar na pasta de saída.

## 4. Categorias e cores dos nós

| Categoria | Cor | Exemplo |
| --------- | --- | ------- |
| Core (constantes/tipos) | laranja | `P39_TDD_CONSTANTES` |
| Infra (ODBC, JSON, parâmetros) | azul | `P39_TDD_ODBC`, `P39_TDD_FUNCOES_JSON` |
| Dados/fixtures JSON | verde claro | `P39_TDD_JSON_*` |
| Aplicação (scripts) | verde | `P39_TDD_FAT_DOCUMENTO_FATURA` |
| Asserts | roxo | `P39_TDD_ASSERTS`, `TDD_ASSERTS` |
| Referência alias (sem prefixo) | tracejado laranja | `TDD_*` |

## 5. Conteúdo do markdown de saída

O arquivo `mermaid-units.md` deve conter:
1. **Grafo de dependências** — `graph TD` com nós (todas as units) e arestas `uses`.
2. **Legenda** — tabela cor x significado.
3. **Árvore hierárquica** — níveis de dependência (0 = sem deps, 1, 2, 3+).
4. **Observações** — aliases, variantes sem prefixo e fixtures JSON.

Ao final, exibir resumo: total de units, total de dependências e arquivo gerado.

## 6. Chamada automática após atualização de units

Sempre que o diretório de units de teste automatizado for atualizado
(fluxo da skill `atualizar-units-teste-automatizado`), esta skill deve ser
chamada ao final para regenerar o diagrama com as units mais recentes.