---
name: dunitx-framework
description: Utilize essa skill sempre que precisar escrever, estruturar ou analisar testes de unidade em Delphi usando o framework DUnitX (framework de testes nativo Delphi, baseado em atributos e RTTI). Fonte clonada em D:\TestesAutomatizados\ERP\DUnitx.
---

# Framework de Testes DUnitX (Delphi)

Conhecimento sobre o framework de testes **DUnitX** (VSoftTechnologies/DUnitX), clonado em
`D:\TestesAutomatizados\ERP\DUnitx`. Baseado na análise dos arquivos `.pas` da pasta
`Source` e dos exemplos de `Examples`.

O DUnitX é um framework de testes para Delphi XE2 ou superior, que herda ideias do DUnit e
NUnit, usando **atributos** e **RTTI** para descobrir e executar testes. Reconhece o arquivo
`DUnitX.inc` (inclui defines condicionais de versão do compilador) e pode ser agrupado em
namespaces (`USE_NS`).

> Importante: Este framework é **nativo Delphi compilado**, diferente das units TDD que o
> agente normalmente escreve e que rodam no interpretador do ERP (JvInterpreter). Esta
> skill serve para quando o trabalho envolver o framework DUnitX real.

## Estrutura da pasta Source

Todos os arquivos `.pas` estão na raiz de `Source` (não há subpastas). Os principais:

| Arquivo                  | Responsabilidade                                                        |
| ------------------------ | ----------------------------------------------------------------------- |
| `DUnitX.TestFramework.pas` | Fachada principal. Expõe `TDUnitX`, `ITestRunner`, atributos, `Assert`. |
| `DUnitX.Assert.pas`        | Classe `Assert` (neutra, reutilizável por outros frameworks).           |
| `DUnitX.Assert.Ex.pas`     | Extensão DUnitX-específica da classe `Assert` (string com comparador).  |
| `DUnitX.Attributes.pas`    | Atributos de teste (`[Test]`, `[TestFixture]`, `[Setup]`, etc.).        |
| `DUnitX.TestFixture.pas`   | Implementação de fixture e ciclo de vida dos testes.                    |
| `DUnitX.TestRunner.pas`    | Runner que constrói e executa as fixtures.                              |
| `DUnitX.Types.pas`         | Tipos básicos (`TValueArray`, `TExceptionInheritance`).                 |
| `DUnitX.Exceptions.pas`    | Exceções de teste (`ETestFailure`, `ETestPass`, etc.).                  |
| `DUnitX.Test.pas`          | Classes que representam um teste em tempo de execução.                  |
| `DUnitX.TestResult.pas`    | Resultados de teste.                                                    |
| `DUnitX.Autodetect.Console.pas` | Conserta o aro do console automaticamente.                          |
| `DUnitX.Loggers.*`         | Loggers (console, texto, XML NUnit/JUnit/xUnit, null, GUI).             |
| `DUnitX.Init.pas`          | Workaround para Delphi XE3 (bug #117).                                  |

## Como escrever um teste

A instrução-chave é `DUnitX.TestFramework`, que já reexporta `Assert`, os atributos e
`TDUnitX`.

Use `{$M+}` no tipo (ou herde de `TTestCase`) para habilitar RTTI. Há duas formas de expor
métodos como testes:

1. **Atributo `[Test]`** em métodos `public`.
2. **Métodos `published`** — sem precisar de `[Test]`.

### Exemplo mínimo

```pascal
unit MyTests;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TMyTests = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestSum;
  end;

implementation

{ TMyTests }

procedure TMyTests.Setup;
begin
  // executa antes de CADA teste
end;

procedure TMyTests.TearDown;
begin
  // executa depois de CADA teste
end;

procedure TMyTests.TestSum;
begin
  Assert.AreEqual(4, 2 + 2);
end;

initialization
  // registra manualmente (necessário se não usar UseRTTI)
  TDUnitX.RegisterTestFixture(TMyTests);
end.
```

### Ciclo de vida / atributos de fixture

| Atributo               | Quando roda                                        |
| ---------------------- | -------------------------------------------------- |
| `[TestFixture]`        | Marca a classe como fixture de teste.              |
| `[SetupFixture]`       | Método/construtor: roda **uma vez** antes de todos os testes da fixture. |
| `[TearDownFixture]`    | Método/destrutor: roda **uma vez** depois de todos os testes.            |
| `[Setup]`              | Roda antes de **cada** teste.                      |
| `[TearDown]`           | Roda depois de **cada** teste.                     |
| `[Test]`               | Marca um método como teste. `[Test(false)]` desabilita. |
| `[TestInOwnThread]`    | Planejado, porém **não implementado** (não usar).  |
| `[Ignore('razão')]`    | Impede a execução; conta como ignorado.            |
| `[Category('nome')]`   | Categoria p/ filtro de linha de comando.           |
| `[RepeatTest(n)]`      | Repete o teste n vezes (`0` = comporta como Ignore). |
| `[MaxTime(ms)]`        | Falha se exceder o tempo (apenas Win32/Win64).     |
| `[WillRaise(ExClass)]` | Espera que o método levante a exceção informada.   |
| `[IgnoreMemoryLeaks]`  | Não reporta vazamento de memória no teste.         |

Detalhes de comportamento (da análise da `DUnitX.TestFixture.pas`):

- Se o construtor **sem parâmetros** existir, ele é usado como `SetupFixture` (a menos que
  exista um `[SetupFixture]`); se um `[Setup]` existir junto, os dois podem coexistir.
- Se o módulo tiver fixture com herança (`[TestFixture]` numa classe base), as classes
  descendentes também são descobertas via RTTI.
- Se houver mais de um método com o mesmo atributo de ciclo de vida, apenas o **primeiro**
  encontrado é executado.

### Testes parametrizados (Test Cases)

Atributo `[TestCase]` recebe os valores como texto separado por vírgula (ou separador
customizado) — o compilador Delphi não aceita arrays de `TValue` como parâmetros de
atributo:

```pascal
[Test]
[TestCase('Caso 1', '1,2')]
[TestCase('Caso 2', '3,4')]
procedure TestSum(const a, b : integer);

[Test]
[AutoNameTestCase('5,7')]   // nome gerado automaticamente
[Category('auto')]
procedure TestAuto(const a, b : integer);
```

### Data Providers (TestCaseProvider)

Permite injetar dados dinâmicos em testes. Subclasse de `TTestDataProvider`:

```pascal
TSampleProvider = class(TTestDataProvider)
public
  function GetCaseCount(const methodName : string) : Integer; override;
  function GetCaseName(const methodName : string; const caseNumber : integer) : string; override;
  function GetCaseParams(const methodName : string; const caseNumber : integer) : TValuearray; override;
end;
```

Uso no teste:

```pascal
[Test]
[TestCaseProvider(TSampleProvider)]
procedure AddTest(const v1, v2 : integer; const expected : integer);
```

Registro do provider:

```pascal
initialization
  TestDataProviderManager.RegisterProvider('nomeDoProvider', TSampleProvider);
  TDUnitX.RegisterTestFixture(TProviderExample);
end.
```

## Assertivas disponíveis

A classe `Assert` (exposta pelo `DUnitX.TestFramework`) herda todas as assertivas de
`DUnitX.Assert.Assert` + `DUnitX.Assert.Ex.Assert`:

| Família          | Exemplos                                                                 |
| ---------------- | ------------------------------------------------------------------------ |
| Igualdade        | `AreEqual(expected, actual)`, `AreEqual(expected, actual, msg)`, genérica `AreEqual<T>` |
| Desigualdade     | `AreNotEqual(...)`, `AreNotEqualMemory(...)`, genérica `AreNotEqual<T>` |
| Tolerância       | `AreEqual(expected, actual, tolerance)` para `Double`/`Extended`        |
| Mesma instância  | `AreSame(a, b)`, `AreNotSame(a, b)`                                      |
| String           | `AreEqual` (string), `Contains`, `DoesNotContain`, `StartsWith`, `EndsWith`, `NoDiff`, `IsMatch` (regex) |
| Booleano         | `IsTrue(cond)`, `IsFalse(cond)`                                          |
| Nulo            | `IsNull(...)`, `IsNotNull(...)` (TObject, Pointer, IInterface, Variant)  |
| Coleções         | `IsEmpty`, `IsNotEmpty`, `Contains<T>`, `DoesNotContain<T>`              |
| Classes          | `InheritsFrom(desc, parent)`, `AreEqual(expected, actual: TClass)`       |
| Guarda          | `WillRaise(proc, ExClass)`, `WillRaiseDescendant`, `WillRaiseAny`, `WillNotRaise`, `WillNotRaiseAny`, `WillRaiseWithMessage`, `WillRaiseWithMessageRegex` |
| Tipos/Data      | `IsSameDate`, `IsSameTime`, `IsSameDateTime`, `Pass`, `Fail`, `FailFmt`  |
| Outros          | `AreEqualMemory`, `AreEqual(expected, actual: TStream)`, `AreEqual(TStrings)`, `AreEqual(TGUID)`, `AreEqual(Currency)` |

Detalhes:

- `Assert.AreEqual` para `Currency` compara exatamente (sem tolerância).
- `Assert.AreEqual` para `TClass` compara a referência da classe (não `ClassOf`).
- `NoDiff(expected, actual)` falha mostrando a posição da primeira diferença entre strings.
- `WillRaise` verifica **exatamente** a classe da exceção; `WillRaiseDescendant` aceita
  subclasses.
- `Assert.AreEqual(expected, actual: string; compFormat: TDUnitXComparableFormatClass)` usa
  formatos comparáveis (CSV, XML) e lança `ETestFailureStrCompare`.

## Execução do runner

### Em código (programa de teste)

```pascal
var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
begin
  runner := TDUnitX.CreateRunner;
  runner.UseRTTI := True;               // descobre fixtures via RTTI
  logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
  runner.AddLogger(logger);
  // runner.AddLogger(TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile));
  results := runner.Execute;
end;
```

> Se `UseRTTI = False`, é necessário registrar cada fixture com
> `TDUnitX.RegisterTestFixture(TClasse)` (tipicamente na `initialization`). Com RTTI, use
> `{$STRONGLINKTYPES ON}` para garantir que as classes sejam vinculadas ao executável.

### Linha de comando (console)

O parser aceita prefixo `-` ou `/` e separador `:` entre chave e valor.

| Opção                  | Forma                 | Descrição                                       |
| ---------------------- | --------------------- | ----------------------------------------------- |
| Saída XML (NUnit)      | `-xmlfile:<caminho>`  | Caminho do arquivo XML de resultado.            |
| Rodar testes           | `-run:<a,b>`          | Nome dos testes a executar (separados por `,`). |
| Rodar lista            | `-runlist:<arquivo>`  | Arquivo com lista de testes a executar.         |
| Incluir categoria      | `-include:<cat>`      | Categorias a incluir.                           |
| Excluir categoria      | `-exclude:<cat>`      | Categorias a excluir.                           |
| Não mostrar ignorados  | `-dontshowignored`    | Não exibe testes ignorados.                     |
| Nível de log           | `-loglevel:<Info/Warning/Error>` | Nível de log.                           |
| Comportamento de saída | `-exitbehavior:<Continue/Pause>` | Pausa ou não ao final.                  |
| Modo do console        | `-consolemode:<Off/Quiet/Verbose>` | Modo do console.                        |
| Ocultar banner         | `-hidebanner`         | Esconde o banner de licença.                    |
| Ajuda                  | `-h`                  | Mostra uso.                                     |
| Arquivo de opções      | `-options:<arquivo>`  | Arquivo contendo opções.                        |

Exemplo:

```text
MyTests.exe -xmlfile:resultados.xml -include:Regressao -exclude:Lento
```

## Tipos/estruturas-chave

- `TTestMethod = procedure of object;` — assinatura padrão de um método de teste.
- `TLogLevel = (Information, Warning, Error)` — nível de log (escopado).
- `TTestResultType = (Pass, Failure, Error, Ignored, MemoryLeak, Warning)`.
- `ITestRunner` — executa os testes, aceita loggers via `AddLogger`.
- `IRunResults` — agrega contadores (`TestCount`, `FailureCount`, `SuccessRate`, `AllPassed`).
- `TDUnitX.CurrentRunner` — acesso ao runner atual dentro de um teste (para `Log`, `Status`,
  `WriteLn`). O helper `TTestFixtureHelper` permite `Log(...)`, `Status(...)` e `WriteLn(...)`
  diretamente em qualquer objeto dentro do teste.
- Códigos de saída: `EXIT_OK = 0`, `EXIT_ERRORS = 1`, `EXIT_OPTIONS_ERROR = 100`.

## Compatibilidade com DUnit

`DUnitX.DUnitCompatibility.pas` provê compatibilidade limitada com classes de teste do
DUnit (por exemplo, `TTestCase`), permitindo migrar testes existentes.

## Observações de compilador

- Delphi 2010/XE: alguns overloads genéricos de `Assert` são IFDEF'd (`DELPHI_XE_UP`,
  `DELPHI_XE2_UP`) devido a bugs de compilador. Não usar `Assert.AreEqual<T>` em compilador
  mais antigo que XE2.
- XE3: adicionar `DUnitX.Init` ao projeto de teste (workaround do bug #117).
- Plataformas: Win32, Win64 e OSX. Para FMX/mobile (sem console), usar
  `DUnitX.Loggers.Console.FMX`.
