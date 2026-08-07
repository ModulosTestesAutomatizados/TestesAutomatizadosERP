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

## 2. Skills disponíveis

Carregue a skill correspondente ao domínio da tarefa:

| Skill                      | Quando ativar                                                                             |
| -------------------------- | ----------------------------------------------------------------------------------------- |
| `estrutura-testes-erp`     | Trabalhando com codificações de testes automatizados do ERP.                              |
| `interpretador-delphi-erp` | Ao escrever toda e qualquer codificação Pascal é necessário entender bem o interpretador. |
| `tdd-odbc`                 | Execuções de operações com SQL que devem interagir com o banco dedicado para testes.      |
| `banco-dedicado`           | Quando precisar de montar alguma consulta SQL para lidar com o banco dedicado.            |
