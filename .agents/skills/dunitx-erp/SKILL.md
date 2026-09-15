---
name: dunitx-erp
description: Use quando precisar criar, revisar ou estruturar units de teste seguindo o padrao DUnitX (framework em D:\TestesAutomatizados\ERP\DUnitx) combinado com o interpretador do ERP (JvInterpreter). Define o mapa do projeto DUnitX, o modelo de autoria (fixtures, asserts, runner) e o contrato de adaptacao para units executadas no interpretador.
---

# DUnitX + Interpretador como base de units de teste

Toda unit de teste criada neste workspace segue o **modelo DUnitX** (semântica,
nomenclatura e organização de fixtures/asserts) sobre a **base do interpretador
do ERP** (skill `interpretador-delphi-erp`). Carregue esta skill junto com
`interpretador-delphi-erp` (limitações do JvInterpreter), `estrutura-testes-erp`
(montagem dos testes), `tdd-odbc`/`banco-dedicado` (dados) sempre que for criar
uma unit de teste.

## 1. O projeto DUnitX

Framework open-source de testes para Delphi (VSoft Technologies, Apache 2.0,
Delphi XE2+), inspirado em DUnit/NUnit/xUnit. Cópia de referência local:

| Item | Valor |
| ---- | ----- |
| raiz | `D:\TestesAutomatizados\ERP\DUnitx` |
| search path (código) | `D:\TestesAutomatizados\ERP\DUnitx\Source` (72 units `DUnitX.*.pas` + `DUnitX.inc`) |
| fixtures de exemplo | `D:\TestesAutomatizados\ERP\DUnitx\Tests\DUnitX.Tests.Example.pas` |
| runner de referência | `D:\TestesAutomatizados\ERP\DUnitx\Tests\DUnitXTestProject.dpr` |
| exemplos avulsos | `D:\TestesAutomatizados\ERP\DUnitx\Examples\` (`General`, `EqualityAsserts`, `AssertFailureCompare`, `UITest`, `Console.FMX`) |
| pacotes por versão da IDE | `D:\TestesAutomatizados\ERP\DUnitx\packages\` (`RAD Studio XE2` … `13.0`; inclui o IDE expert/wizard) |
| docs extras | `TestCaseProvider.md` (casos parametrizados via provider), `Docs/FMX-Pseudo-Console.md` |
| repositório oficial | `https://github.com/VSoftTechnologies/DUnitX.git` (fallback — ver observação abaixo) |

> **Observação — projeto ausente na máquina:** os caminhos acima apontam para a
> cópia local do autor. Se o diretório raiz não existir na máquina em uso, seguir
> nesta ordem: (1) solicitar ao usuário o caminho local do DUnitX e usá-lo como
> raiz (ajustando os caminhos desta seção); (2) se o usuário não informar nenhum
> diretório, clonar a referência oficial `https://github.com/VSoftTechnologies/DUnitX.git`
> e usar o clone como raiz do projeto (subpasta `Source` como search path).
> Não prossiga sem uma das duas fontes.

## 2. Mapa das units centrais (`Source/`)

| Unit | Responsabilidade |
| ---- | ---------------- |
| `DUnitX.TestFramework` | Fachada `TDUnitX` (`RegisterTestFixture`, `CreateRunner`, `CheckCommandLine`, `CurrentRunner`) e interfaces do runner |
| `DUnitX.Attributes` | Atributos: `TestFixture`, `Test`, `TestCase`, `TestCaseProvider`, `AutoNameTestCase`, `Setup`, `TearDown`, `SetupFixture`, `TearDownFixture`, `Ignore`, `Category`, `MaxTime`, `WillRaise`, `RepeatTest`, `TestInOwnThread` |
| `DUnitX.Assert` / `DUnitX.Assert.Ex` | Classe `Assert` (igualdade, booleanos, nulo, vazio, datas, contains, memória, `WillRaise*`, `Pass`/`Fail`) |
| `DUnitX.TestFixture` / `DUnitX.Test` / `DUnitX.TestRunner` | Execução das fixtures e dos casos |
| `DUnitX.FixtureProvider` / `DUnitX.TestDataProvider` / `DUnitX.InternalDataProvider` | Fixtures/casos parametrizados (ver `TestCaseProvider.md`) |
| `DUnitX.Loggers.Console`, `.Text`, `.Null` | Saída console/texto |
| `DUnitX.Loggers.XML.NUnit`, `.XML.JUnit`, `.XML.xUnit`, `DUnitX.Utils.XML` | Logs XML p/ CI (NUnit, JUnit, xUnit) |
| `DUnitX.Loggers.GUI.VCL`, `.GUIX`, `.MobileGUI`, `.Console.FMX` | Runners visuais / pseudo-console FMX |
| `DUnitX.MemoryLeakMonitor.*` (`Default`, `FastMM4`, `FastMM5`) | Detecção de vazamento por fixture |
| `DUnitX.DUnitCompatibility` | Ponte p/ classes de teste DUnit legadas |
| `DUnitX.Init` | Inicialização — **obrigatória no `.dpr`** (workaround do bug do Delphi XE3) |
| `DUnitX.CategoryExpression`, `DUnitX.Filters`, `DUnitX.FilterBuilder` | Filtro de execução por categoria/nome |
| `DUnitX.Timeout`, `DUnitX.WeakReference`, `DUnitX.StackTrace.*` | Timeout (`MaxTime`), weak refs, stack traces (JCL/MadExcept/EurekaLog) |

## 3. Modelo de autoria DUnitX (Delphi compilado)

```pascal
{$M+}
[TestFixture('NomeDaFixture')]
[Category('modulo')]
TMinhaFixture = class
public
  [Setup]        procedure Setup;        // antes de CADA teste
  [TearDown]     procedure TearDown;     // depois de CADA teste
  [SetupFixture] procedure SetupFixture; // uma vez por fixture
  [Test]
  [TestCase('Caso 1', '1,2')]
  [TestCase('Caso 2', '3,4')]
  procedure Soma(param1, param2: Integer);
  [Test]
  [MaxTime(1000)]
  [Category('critico')]
  procedure OperacaoRapida;
  [Test]
  [Ignore('motivo')]
  procedure TesteIgnorado;
  [WillRaise(EminhaExcecao)]
  procedure DeveFalhar;
end;

initialization
  TDUnitX.RegisterTestFixture(TMinhaFixture); // ou {$STRONGLINKTYPES ON} + runner.UseRTTI := True
```

Runner console padrão (`DUnitXTestProject.dpr:47-92`): `TDUnitX.CheckCommandLine` →
`TDUnitX.CreateRunner` → `runner.UseRTTI := True` → `AddLogger` (console + NUnit XML)
→ `runner.Execute` → `ExitCode := EXIT_ERRORS` se nem tudo passou. Métodos `published`
sem atributo também viram testes; `[Test]` pode receber `False` para desabilitar.

Asserts mais usados (`DUnitX.Assert.pas:65-234`): `Assert.Pass/Fail/FailFmt`,
`AreEqual/AreNotEqual` (string, Double/Extended com tolerância, Currency, Integer,
Int64, Boolean, TGUID, TStream, TStrings, genéricos `AreEqual<T>`), `AreSame/AreNotSame`,
`Contains/DoesNotContain`, `IsTrue/IsFalse`, `IsNull/IsNotNull`, `IsEmpty/IsNotEmpty`,
`IsSameDate/IsSameTime/IsSameDateTime`, `WillRaise/WillRaiseDescendant/WillRaiseAny`
(+ `WillNotRaise*`, `WillRaiseWithMessage[Regex]`).

## 4. Regra de ouro: dois alvos, um modelo

| Alvo | Onde roda | Como usar o DUnitX |
| ---- | --------- | ------------------ |
| Delphi compilado (runner `.dpr`/`.dproj`) | Fora do ERP | DUnitX de verdade: classes, atributos, RTTI, `Assert.*`, loggers |
| **Interpretador do ERP** (units `P39_TDD_*` / `TDD_*`) | Módulo BI, via JvInterpreter | **Modelo DUnitX adaptado**: proibido `class`, atributos, RTTI, generics, sobrecarga, `initialization` (ver skill `interpretador-delphi-erp`). Espelhar a semântica com rotinas e acumulação de resultado |

O precedente já existe no código: `P39_TDD_ASSERTS.pas:23-29` ("unit de asserts
(modelo DUnitX) para uso no interpretador — cada assert registra PASS/FAIL
acumulado e retorna Boolean") e o registro individual de PASS/FAIL por validação
(modelo DUnitX) em `TDD_FAT_VALIDAR_RESULTADO_NOVO.pas:9`.

### Equivalência DUnitX → interpretador

| DUnitX | Interpretador (units `P39_TDD_*`) |
| ------ | -------------------------------- |
| `[TestFixture]` (classe) | Uma unit por fixture/caso (`P39_TDD_<MOD>_<ASSUNTO>`); `Main` documenta (finalidade + assinaturas) e chama as `Main` do `uses` |
| `[Setup]` / `[TearDown]` | Procedures `Setup`/`TearDown` chamadas no início/fim de cada etapa |
| `[Test]` / `[TestCase]` | Uma procedure por etapa/caso, alimentada pelo JSON do caso de teste (`TDD_CARREGAR_CASO_TESTE`) |
| `Assert.AreEqual/IsTrue/...` (levantam exceção) | `P39_TDD_ASSERTS` (`AssertIgual`, `AssertIgualInteiro`, `AssertVerdadeiro`, `AssertFalso`, `AssertListaVazia`, `AssertContem`, …): retornam `Boolean`, acumulam `AssertsTotal/Pass/Fail`, nunca abortam a etapa |
| `Assert.Pass/Fail` pontual | `AssertsPassou` / `AssertsFalhou` |
| Runner + loggers (console/XML) | `CallBack_AbreTela/Mensagem/FechaTela(ClassOwner)` + `LogDoProcessamentoAdd` + registro em `CASO_TESTE`/`HISTORICO_EXECUCAO_TESTE` via `P39_TDD_REGISTRAR_CASO_TESTE` |
| `[Ignore]` / `[Test(false)]` | `ATIVO_CT = 'N'` no cadastro do caso de teste |
| `[Category]` | `MODULO_CT`/`AREA_CT` do caso de teste |
| `[MaxTime]` | Medição com `TDD TICk/DIFF` e gravação em `METRICAS_TICK_DIFF` (ver `sql/migracao_tdd_runner_metricas.sql` e `docs/MER.md`) |
| Dados via `TestCaseProvider` | Massa via banco dedicado (`P39_TDD_ODBC`) + JSON do caso de teste |

## 5. Template de unit de teste (interpretador, modelo DUnitX)

```pascal
uses P39_TDD_ASSERTS;

procedure Main;
var lInstrucoes: String;
begin
  P39_TDD_ASSERTS.Main; // Documentacao das units do uses!
  lInstrucoes :=
    'Fixture <MODULO>/<ASSUNTO> (modelo DUnitX).' + #13 +
    'Etapas: EtapaUm, EtapaDois. Asserts acumulados via P39_TDD_ASSERTS.';
  MostrarLogTexto(lInstrucoes, 'Instrucoes P39_TDD_<MOD>_<ASSUNTO>');
end;

procedure Setup;
begin
  AssertsZerar;
  // preparar massa / abrir tela: CallBack_AbreTela(ClassOwner);
end;

procedure TearDown;
begin
  // fechar tela: CallBack_FechaTela(ClassOwner);
  // AssertsOk / AssertsResumo decidem o PASS/FAIL da etapa
end;

function EtapaUm: Boolean;
begin
  Setup;
  try
    Result := AssertVerdadeiro(<condicao>, 'descricao da etapa');
    // encadear demais asserts da etapa com AND se um falhar nao mascarar os outros:
    // cada assert ja registra PASS/FAIL individualmente
  finally
    TearDown;
  end;
end;

procedure MainExecutar;
begin
  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, 'Etapa 1...');
    RegistrarEtapa('EtapaUm', EtapaUm); // padrao do validar-resultado da suite
  finally
    CallBack_FechaTela(ClassOwner);
  end;
end;
```

## 6. Checklist ao criar uma unit de teste

1. Carregar esta skill + `interpretador-delphi-erp` + `estrutura-testes-erp`
   (+ `tdd-odbc` se acessar dados).
2. Definir a fixture: 1 unit por responsabilidade (AGENTS.md 1.3); nome
   `P39_TDD_<MOD>_<ASSUNTO>` (remoto) / `TDD_<MOD>_<ASSUNTO>` (local) (AGENTS.md 1.5).
3. `uses` mínimo (herança cobre o transitivo — AGENTS.md 1.6); `P39_TDD_ASSERTS`
   para todos os asserts, nunca `raise` para sinalizar falha de assert.
4. Cada etapa: `Setup` → asserts (todos executam, todos registram) → `TearDown` →
   PASS/FAIL consolidado via `AssertsOk`/`AssertsResumo`.
5. `Main` documentando finalidade + assinaturas e chamando as `Main` do `uses`.
6. Registrar o caso em `CASO_TESTE` (`P39_TDD_REGISTRAR_CASO_TESTE`) com
   `MODULO_CT`/`AREA_CT` (= `[Category]`) e `ATIVO_CT` (= `[Ignore]` invertido).
7. Atualizar `docs/mapeamentoUses/<UNIT>.md` (AGENTS.md 1.7) e `docs/MER.md` se
   tocar no banco dedicado.

Base directory for this skill: D:\TestesAutomatizados\Agente\.agents\skills\dunitx-erp
Relative paths in this skill (e.g., scripts/, reference/) are relative to this base directory.
Note: file list is sampled.
