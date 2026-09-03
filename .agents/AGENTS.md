# Diretrizes de Testes Automatizados do ERP para Agentes de IA

Este arquivo contém as regras que se aplicam a todas as codificações deste workspace. Regras específicas de tecnologia/domínio estão em skills modulares em `.opencode/skills/`.

---

## 1.1 Linguagem de comunicação

- Toda comunicação com o usuário deve ser em português do Brasil (`pt-BR`).
- Termos técnicos podem ser mantidos em inglês quando forem nomes oficiais de tecnologias, APIs, bibliotecas, padrões ou conceitos amplamente usados pela comunidade.
- As respostas devem priorizar clareza, objetividade e explicação progressiva.
- Quando houver sugestão de código, explicar antes o motivo da abordagem e depois apresentar o exemplo.

---

## 1.2 Nomenclatura

| Contexto        | Padrão                      | Prefixo |
| --------------- | --------------------------- | ------- |
| Types           | `PascalCase`                | `T`     |
| Interfaces      | `PascalCase`                | `I`     |
| Classes         | `PascalCase`                | `C`     |
| Constantes      | `UPPER_CASE` ou `camelCase` | —       |
| Variáveis       | `camelCase` ou `UPPER_CASE` | —       |
| Funções/Métodos | `camelCase`                 | —       |
| Parâmetros      | `camelCase` ou `PascalCase` | `p`     |

Quando o arquivo exportar múltiplos itens fortemente relacionados, o nome deve representar o domínio ou responsabilidade principal.

---

## 1.3 Separação de responsabilidades

Se atentar a responsabilidade de cada codificação, se tal codificação estiver lidando com mais de uma responsabilidade ou caso de teste, extrair para uma nova codificação!

---

## 1.4 DRY e reutilização

Aplicar o conceito de DRY! Sempre que uma regra se repetir, avaliar a extração para uma camada mais apropriada. Métodos desenvolvidos devem tentar sempre serem o mais adaptáveis e reutilizáveis possível.

---

## 1.5 Nomenclatura de Units (local vs remoto)

As codificações possuem duas variantes de prefixo que indicam o destino da unit:

| Prefixo                   | Ambiente        | Quando usar                                                    |
| ------------------------- | --------------- | -------------------------------------------------------------- |
| `P39_TDD_*`               | Remoto (ERP)    | Unit que será executada/carregada no ERP.                      |
| `TDD_*` (ou sem prefixo)  | Local (dev)     | Unit em desenvolvimento local, ainda não enviada ao ERP.       |

Regras:

- Ao referenciar no `uses` uma unit **global ou feita por outro desenvolvedor** e que não exista localmente, apontar para a variante remota (`P39_TDD_*`).
- Units de uso próprio (carregador, mapeamentos refatorados) podem ficar na variante local (`TDD_*`).
- Não duplicar arquivos: a variante local e a remota representam a mesma unit em ambientes diferentes.
- Exemplo: o registro de caso de teste é unit global do ERP. Referenciar **`P39_TDD_REGISTRAR_CASO_TESTE`**; a variante local `TDD_REGISTRAR_CASO_TESTE` (sem prefixo) não existe como unit global e causa erro de resolução de `uses`.

---

## 1.6 Herança de `uses`

O interpretador possui **herança de uses**: se `UNIT A` usa `UNIT B` e `UNIT B` usa `UNIT C`, então `UNIT A` enxerga o conteúdo de `UNIT C` sem declará-la.

- **Não declarar `uses` redundante** para uma unit que já vem de forma transitiva.
- Exemplo: `TDD_CARREGAR_CASO_TESTE` já inclui `P39_TDD_REGISTRAR_CASO_TESTE` → `P39_TDD_ODBC` → `P39_TDD_CONSTANTES`; portanto a unit que usa `TDD_CARREGAR_CASO_TESTE` **não precisa** declarar `P39_TDD_ODBC`.
- Manter o diagrama de dependências atualizado (ver seção 1.7).

---

## 1.7 Diagramas Mermaid de dependências

A documentação dos `uses` de cada caso de teste deve ser mantida em arquivos Markdown no diretório `docs/mapeamentoUses/`, com diagramas **Mermaid** (`flowchart`/`graph`), destacando:

- Dependências **diretas** do caso de teste.
- Heranças **transitivas** de `uses` entre as units.
- Units **externas** (fora do workspace) e units **localizadas no workspace**.
- Convenção de nome: `docs/mapeamentoUses/<NOME_DA_UNIT>.md`.

Consulte também `docs/MER.md` para o modelo de dados do banco dedicado.

---

## 2. Skills disponíveis

Carregue a skill correspondente ao domínio da tarefa:

| Skill                                 | Quando ativar                                                                                                                                           |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `atualizar-repositorio-agente`        | skill para sincronizar (pull) o repositório AgenteDelphiTDD do GitHub na pasta `D:\TestesAutomatizados\Agente`, comparando antes de sobrescrever        |
| `atualizar-units-teste-automatizado`  | skill que autentica na TekStore (API), baixa as units TDD e atualiza o diretório local de `.pas`, solicitando credenciais e diretório quando necessário |
| `banco-dedicado`                      | skill que aponta para a documentação da DDL do banco de dados com mermaid, string de conexão e arquivo .FDB                                             |
| `banco-erp-unidades`                  | skill para consultar o banco do ERP, ler e analisar as unidades de codificação do módulo BI.                                                            |
| `context7`                            | skill do mcp do context7 para consulta de documentações, evitando alucinações e suposições do agente quanto a possíveis códigos legados                 |
| `drawio`                              | skill a respeito de como utilizar o MCP do draw.io para realizar desenhos de diagramas.                                                                 |
| `entregas`                            | skill a respeito de como as entregas das tasks devem ser feitas, requisitos para validação de conclusão                                                 |
| `estrutura-testes-erp`                | skill para informar como os testes devem ser montados                                                                                                   |
| `generate-report`                     | skill que, ao final de cada serviço, dita como deve ser gerado o código de um markdown para fechamento de serviço                                       |
| `interpretador-delphi-erp`            | skill para ensinar o agente as funções e limitações do módulo do ERP BI - Inteligência de negócios                                                      |
| `tdd-odbc`                            | skill para informar o agente quanto as conexões ODBC e os métodos centralizado em 32 bits (cliente)                                                     |
