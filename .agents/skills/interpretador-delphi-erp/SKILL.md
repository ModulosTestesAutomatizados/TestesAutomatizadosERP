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

- Métodos disponibilizados para facilitar alguns processos:

| Método            | Finalidade    |
| ----------------- | ------------- |
|                   |               |
|                   |               |
|                   |               |
