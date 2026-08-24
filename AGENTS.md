# Diretrizes Globais para Agentes de IA

Este arquivo contém as regras globais que se aplicam a todos os agentes de IA.

---

## 1 Linguagem de comunicação

- Toda comunicação com o usuário deve ser em português do Brasil (`pt-BR`).
- Termos técnicos podem ser mantidos em inglês quando forem nomes oficiais de tecnologias, APIs, bibliotecas, padrões ou conceitos amplamente usados pela comunidade.
- As respostas devem priorizar clareza, objetividade e explicação progressiva.
- Quando houver sugestão de código, explicar antes o motivo da abordagem e depois apresentar o exemplo.

---

## 2 Nomenclatura

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

## 3 Comentários e documentação interna

Sempre que possível utilizar a procedure main de uma unit para adicionar instruções da codificação, fazendo também chamadas as instruções das units que existem em uses (chamar a procedure main das units importadas com uses antes de exibir as instruções da própria codificação);

- Comentários devem explicar responsabilidades, contratos e decisões que não sejam imediatamente óbvias.
- Evitar comentários que apenas repetem o nome do símbolo.
- Comentários inline devem ser reservados para regras de negócio pontuais, workarounds e decisões não óbvias.
- As instruções devem explicar sobre a finalidade da unit como um todo, métodos principais exportados para utilização em outras units, suas assinaturas e uma descrição da procedure/function em questão.
- Caso seja necessário adicionar observações, manter no final das instruções.

---

## 4 Separação de responsabilidades

- Analisar procedures que podem ser generalizadas para atender a diversos cenários;
- Extrair lógicas repetitivas para métodos auxiliares;

---

## 5 DRY e reutilização

- Aplicar o conceito de DRY, sempre que uma regra se repetir, avaliar extração para camada mais apropriada em uma nova unit, uma já existente ou uma nova function/procedure auxiliar.

---

## 6. Skills disponíveis

Skills estão disponíveis em: [Base de Conhecimento - Delphi TDD](https://modulostestesautomatizados.github.io/fonte-conhecimento-agente-delphi-tdd/) Carregue a skill correspondente ao domínio da tarefa:

| Skill                      | Quando ativar                                                                                                                            |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `atualizar-repositorio-agente` | skill para sincronizar (pull) o repositório AgenteDelphiTDD do GitHub na pasta `D:\TestesAutomatizados\Agente`, comparando antes de sobrescrever |
| `atualizar-units-teste-automatizado` | skill que autentica na TekStore (API), baixa as units TDD e atualiza o diretório local de `.pas`, solicitando credenciais e diretório quando necessário |
| `banco-dedicado`           | skill que aponta para a documentação da DDL do banco de dados com mermaid, string de conexão e arquivo .FDB                              |
| `banco-erp-unidades`       | skill para consultar o banco do ERP (DADOSMC_1032-TESTES-ERP.FDB) e ler/analisar as unidades de codificação do módulo BI (GR_UNIDADE_CODIFICACAO) |
| `context7`                 | skill do mcp do context7 para consulta de documentações, evitando alucinações e suposições do agente quanto a possíveis códigos legados  |
| `entregas`                 | skill a respeito de como as entregas das tasks devem ser feitas, requisitos para validação de conclusão                                  |
| `estrutura-testes-erp`     | skill para informar como os testes devem ser montados                                                                                    |
| `generate-report`          | skill que, ao final de cada serviço, dita como deve ser gerado o código de um markdown para fechamento de serviço                        |
| `interpretador-delphi-erp` | skill para ensinar o agente as funções e limitações do módulo do ERP BI - Inteligência de negócios                                       |
| `tdd-odbc`                 | skill para informar o agente quanto as conexões ODBC e os métodos centralizado em 32 bits (cliente)                                      |
