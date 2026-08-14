---
name: estrutura-testes-erp
description: Use essas habilidades sempre que precisar montar novas estruturas de testes destinadas ao ERP
---

# Estrutura de Testes Automatizados do ERP

Padrão de codificação usado para estruturar um caso de teste executado no
interpretador do ERP (módulo BI / Pascal Script).

## Fluxo de execução de um caso de teste

A unit do caso de teste deve expor uma rotina pública de execução (ex.:
`IncluirBorderoRecebimento`) que orquestra o ciclo de vida:

```pascal
procedure IncluirBorderoRecebimento;
begin
  Setup;
  try
    Teste;
  finally
    TearDown_DestruirObjetos;
  end;
end;
```

Quando o teste ainda não é o responsável final (uso em desenvolvimento), pode-se
expor uma rotina mais simples:

```pascal
procedure ExecutarCasoTeste;
begin
  Setup;
  Teste;
end;
```

## Etapas do padrão

| Etapa                    | Responsabilidade                                                                 |
| ------------------------ | -------------------------------------------------------------------------------- |
| `Setup`                  | Abre a tela via `CallBack_AbreTela(ClassOwner)`, chama `Setup_Inicializar` e fecha via `CallBack_FechaTela(ClassOwner)`. |
| `Setup_Inicializar`      | Orquestra `Setup_InicializarObjetos` + `Setup_IniciarFormulario`.                |
| `Setup_InicializarObjetos` | Cria os `TClientDataSet`, carrega o caso de teste e a configuração financeira, valida o JSON. |
| `Setup_IniciarFormulario` | Mapeia os componentes da tela (`MapearBordero`, por exemplo).                    |
| `Teste`                  | Abre a tela, executa `Teste_Executar` e fecha.                                   |
| `Teste_Executar`         | Valida o caso de teste e executa o fluxo de negócio em si.                       |
| `TearDown_DestruirObjetos` | Libera os objetos criados no setup (`Free`).                                     |

## Carregamento do caso de teste

O caso de teste é lido do banco dedicado por `TDD_CARREGAR_CASO_TESTE`:

```pascal
{ TDD_CARREGAR_CASO_TESTE.}CarregarCasoTeste(pCDSCasoTeste, pModulo, pArea, pCasoTeste);
```

- O `TClientDataSet` de destino é **criado pela unit principal** e passado por
  referência; a rotina apenas popula os dados.
- Após o carregamento, o JSON do caso de teste fica em
  `pCDSCasoTeste.FieldByName('JSON_CASO_TESTE').AsString`.
- A configuração financeira é carregada via
  `FCDSConfig.Data := TDDReaderODBC(GetSQLSelectFinanceiroConfig, null);`
  (unit `P39_TDD_FIN_CONFIG_FINANCEIRO`).

## Validação do JSON do caso de teste

A unit deve expor `SetCasoTeste`, `ValidarCasoTeste` e flags de validação:

```pascal
procedure SetCasoTeste(pCasoTeste: String);
begin
  FJSONCasoTeste := pCasoTeste;
  ValidarCasoTeste;
end;

procedure ValidarCasoTeste;
begin
  FMsgCasoTesteInvalido := '';

  if Trim(FJSONCasoTeste) = '' then
    FMsgCasoTesteInvalido := FMsgCasoTesteInvalido + #13 + 'JSON do caso de teste vazio! (JSON_CASO_TESTE)';

  FCasoTesteInvalido := (FMsgCasoTesteInvalido <> '');
end;
```

## Leitura de tags do JSON

Usar os wrappers de `P39_TDD_FUNCOES_JSON` centralizados em funções próprias da
unit:

```pascal
function ValorInteiroTagBordero(pTagName: String; pDefault: Integer): Integer;
begin
  Result := ValorInteiroTag(FJSONCasoTeste, pTagName, pDefault);
end;
```

## Mapeamento de componentes de tela

Criar uma unit de mapeamento por tela (ex.:
`TDD_FIN_MAPEAMENTO_COMPONENTES_BORDERO_RECEBIMENTO`) que:

- Expõe `procedure MapearBordero` (nome semântico por tela) criando o form via
  `FormCriadoPeloNome` com fallback `CriarFormPeloNome`, o data module via
  `FindComponent` e os componentes/CDSs via `FindComponent`.
- Expõe ações da tela como `IncluirBordero`, `Filtrar`, `GravarBordero`
  (usando `ExecutarMetodoDeObjeto`).
- Navega entre abas via `PageControl.ActivePage := TSReceber` (TabSheets
  mapeados), evitando índices numéricos.

## Regras gerais

- **Nunca assumir nomes de componentes/form**: procurar a unit de mapeamento
  real (ex.: borderô de recebimento é `FCadBorderoAcerto`, não
  `FCadBorderoRecebimento`).
- Aplicar herança de `uses`: não declarar unit que já vem transitivamente.
- Registrar diagrama Mermaid dos `uses` em `docs/mapeamentoUses/<UNIT>.md`.
- Ao referenciar no `uses` uma unit global feita por outro desenvolvedor, apontar para a
  variante remota (`P39_TDD_*`). A variante local sem o prefixo (ex.:
  `TDD_REGISTRAR_CASO_TESTE`) pode não existir como unit global no ERP e causa erro de
  resolução de `uses`.
- Os dados do JSON do caso de teste devem ser acertivos com o estado real do banco/ERP
  (ex.: `PESSOA_DUP` precisa ser uma pessoa com duplicatas a receber em aberto). Valores
  incoerentes caem em regras de negócio do ERP, como *"O valor do complemento deve ser
  maior que zero"*.
