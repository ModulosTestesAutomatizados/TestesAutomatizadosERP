---
name: interpretador-delphi-erp
description: Utilize essas habilidade sempre que precisar de desenvolver alguma codificação Pascal destinadas a serem executadas no interpretador do ERP.
---

# Motor do módulo BI

## Pascal Script

Nosso ERP possui um módulo chamado: *'BI - Inteligência de Negócios'*. Esse método é capaz de desenvolver diversas codificações escritas em Pascal e serem interpretadas dentro do ERP. O interpretador utilizado é o **JvInterpreter** (Pascal Script), um componente open-source da biblioteca **JEDI VCL** (JVCL). Não temos as mesmas ferramentas que o Delphi compilado disponibilizaria, mas temos muitos recursos!

> A fonte de verdade sobre o interpretador está no repositório público
> [project-jedi/jvcl](https://github.com/project-jedi/jvcl) (pasta `jvcl/run`, arquivos
> com prefixo `JvInterpreter*`). Antes de assumir que um recurso existe, consultar o
> repositório — especialmente `JvInterpreter.pas`, `JvInterpreterConst.pas` e
> `JvInterpreterParser.pas`. As units de integração com as bibliotecas Delphi são os
> arquivos `JvInterpreter_*.pas` (ex.: `JvInterpreter_Classes`, `JvInterpreter_Forms`,
> `JvInterpreter_SysUtils`, `JvInterpreter_Db`, `JvInterpreter_Windows`).

## Limitações

Unidades de codificação possuem diversas limitações, vou listar as principais:

- **Não se pode gerar classes!** (declaração de `class` no script só é usada para
  formulários — `TJvInterpreterFm`; "property declaration not supported!!").
- **Records não podem ser utilizados como parâmetros de métodos**, sejam procedures ou
  functions, também não podem ser utilizados entre units com uses (o interpretador
  levanta `ieNotImplemented` — `CheckNotSupportedFunctionParameters`).
- **Arrays não podem ser parâmetros de funções/procedures** (nem de rotinas nativas
  registradas no adapter — "sorry, no support for arrays as procedure parameters").
- **Dynamic arrays suportam apenas 1 dimensão** (`SetLength`/`Length`/`Low`/`High`).
- **Sem generics**.
- **Sem sobrecarga de funções** — identificadores são únicos (case-insensitive); redeclarar
  um nome gera `ieIdentifierRedeclared`.
- **Máximo de 32 argumentos por função** (`cJvInterpreterMaxArgs = 32`).
- **Máximo de 32 campos por record** (`cJvInterpreterMaxRecFields = 32`).
- **Máximo de 10 dimensões** em declaração de arrays (`JvInterpreter_MAX_ARRAY_DIMENSION`).
- **`for` e `case` exigem contador/selector Integer**.
- **Parâmetros `var` (referência) só para tipos ordinais simples** (Integer/Boolean/Smallint)
  em chamadas a DLL; não para strings.
- **Campos de `string` em records registrados via adapter não funcionam** (known issue do JvInterpreter).
- **Sections `initialization`/`finalization` de units NÃO são processadas** — apenas
  `interface` e `implementation`.
- **Records declarados no script são coleções de Variants** (campos não são tipados
  Integer/String reais).
- O interpretador é **case-insensitive** para identificadores.

## Particularidades

Assim como as limitações, nossas unidades de codificação possuem diversas particularidades, existem métodos nativos do nosso ERP que são disponibilizados para o interpretador.

- **Herança de uses**, descarta a necessidade de uses redundante, ex:

| Unit              | uses          |
| ----------------- | ------------- |
| CONSTANTES        | N/D           |
| CONFIGURACOES     | CONSTANTES    |
| PROCESSAMENTO     | CONFIGURACOES |

Assim é possível utilizar codificações escritas em CONSTANTES por meio das codificações de PROCESSAMENTO.

- Referenciar no `uses` o nome exato da unit que existe no ambiente de destino: units
  globais do ERP usam o prefixo `P39_TDD_*`; units locais em desenvolvimento usam
  `TDD_*`. Referenciar um nome sem o prefixo `P39_` quando a unit global real é
  `P39_TDD_*` (ex.: `TDD_REGISTRAR_CASO_TESTE` em vez de
  `P39_TDD_REGISTRAR_CASO_TESTE`) causa erro de resolução de `uses` no interpretador.

- A rotina de entrada de uma unit interpretada é a **`procedure Main`** — se não existir,
  o interpretador gera erro `ieMainUndefined`. É nela que se coloca a documentação de
  instruções (via `MostrarLogTexto`) e as chamadas às `Main` das units do `uses`.

- Uma unit pode declarar `function`/`procedure` sem `implementation` explícita; todo o
  corpo é interpretado em `interface`/`implementation`.

## Métodos nativos do interpretador do ERP

Métodos observados nas codificações reais armazenadas em `GR_UNIDADE_CODIFICACAO`
(skill `banco-erp-unidades`). Além dos métodos listados abaixo, o interpretador expõe
funções padrão do Pascal (`Format`, `IntToStr`, `StrToInt`, `Trim`, `Copy`, `Pos`,
`Length`, `UpperCase`, `LowerCase`, `FormatDateTime`, `QuotedStr`, `VarToStr`, etc.).

### Acesso a dados (banco vinculado ao ERP)

| Método                                   | Finalidade                                                                 |
| ---------------------------------------- | -------------------------------------------------------------------------- |
| `ExecuteReader(pSql)`                    | Leitura com retorno de múltiplos registros. Retorna `OleVariant` (dados de um `TClientDataSet`). |
| `ExecuteScalar(pSql)`                    | Leitura com retorno de um único valor/escalar.                             |
| `ExecuteScalarP(pSql, VarArrayOf([...]))`| Leitura escalar com parâmetros nomeados (`:PARAM`).                        |
| `ExecuteCommand(pSql)`                   | Escrita (INSERT/UPDATE/DELETE) no banco do ERP.                            |

### Acesso a dados via ODBC (banco dedicado de testes)

| Método                                   | Finalidade                                                                 |
| ---------------------------------------- | -------------------------------------------------------------------------- |
| `ExecuteReaderODBC(pConexao, pSql, pParams)`  | Leitura ODBC 32 bits (cliente).                                        |
| `ExecuteScalarODBC(pConexao, pSql, pParams)`  | Leitura escalar ODBC 32 bits (cliente).                                |
| `ExecuteCommandODBC(pConexao, pSql, pParams)` | Escrita ODBC 32 bits (cliente).                                        |
| `ExecuteReaderODBCServ(pConexao, pSql)`  | Leitura ODBC 64 bits (servidor).                                           |
| `ExecuteScalarODBCServ(pConexao, pSql)`  | Leitura escalar ODBC 64 bits (servidor).                                   |

> A abstração oficial para testes é a unit `P39_TDD_ODBC` (`TDDReaderODBC`,
> `TDDScalarODBC`, `TDDCommandODBC`) — veja as skills `tdd-odbc` e `banco-dedicado`.

### Manipulação de objetos / telas do ERP

| Método                                   | Finalidade                                                               |
| ---------------------------------------- | ------------------------------------------------------------------------ |
| `FormCriadoPeloNome(pNome)`              | Verifica se o form já existe pelo nome. Retorna o form ou `nil`.         |
| `CriarFormPeloNome(pNome)`               | Cria o form pelo nome. Usado como fallback quando `FormCriadoPeloNome` retorna `nil`. |
| `DMCriadoPeloNome(pNome)`                | Verifica/obtém um DataModule criado pelo nome.                           |
| `FindComponent(pNome)`                   | Localiza um componente (form, DM, CDS, edição, etc.) pelo nome.          |
| `AtribuirValorPropriedadeDeObjeto(pObj, pPropriedade, pValor)` | Atribui valor a uma propriedade de objeto via nome. |
| `ExecutarMetodoDeObjeto(pObj, pMetodo, pParams)` | Invoca um método do objeto via nome, passando parâmetros.      |
| `ExecutarMetodoDeClasse(pNome, pClasse, pMetodo, pParams)` | Invoca um método de classe do ERP (ex.: `'ClassCustoMedio', 'TClassCustoMedio', 'OrigemMovimentoCompoeCustoMedio', [...]`). |
| `ExecuteMethods('Classe.Metodo', pParams)` | Invoca método estático de uma classe do ERP (ex.: `'TSMConexao.VersaoBD_NumStr'`). Retorna `Boolean`/valor. |

### Callbacks de fluxo (testes)

| Método                                   | Finalidade                                                               |
| ---------------------------------------- | ------------------------------------------------------------------------ |
| `CallBack_AbreTela(pClassOwner)`         | Dispara o callback que abre a tela no fluxo do teste.                    |
| `CallBack_Mensagem(pClassOwner, pMensagem)` | Dispara o callback que exibe uma mensagem de progresso do teste.     |
| `CallBack_FechaTela(pClassOwner)`        | Dispara o callback que fecha a tela no fim do fluxo.                     |
| `CallBack_Incremento(pClassOwner, pAtual, pTotal, pMensagem)` | Callback de progresso durante processamentos em lote. |
| `ClassOwner`                             | Identifica a classe/unit proprietária do fluxo do teste.                 |

### Mensagens / interface

| Método                                   | Finalidade                                                               |
| ---------------------------------------- | ------------------------------------------------------------------------ |
| `MostrarLogTexto(pTexto, pTitulo)`       | Exibe uma janela de log com texto e título. Usado na `Main` de documentação e para debug. |
| `MostrarCDS(pCDS)`                       | Exibe o conteúdo de um `TClientDataSet` em grade.                        |
| `ShowMessage(pMensagem)`                 | Exibe uma mensagem simples ao usuário.                                   |
| `MessageDlg(pMsg, mtConfirmation, [mbYes, mbNo], 0)` | Caixa de confirmação. Retorna `mrYes`/`mrNo`.               |
| `Confirma(pPergunta)`                    | Caixa de confirmação simplificada (Sim/Não).                             |
| `EnviarMensagemInterna(pDestinatario, pTitulo, pMensagem)` | Envia mensagem interna no ERP.                    |
| `Nome_Usuario_Atual`                     | Nome do usuário logado no ERP.                                           |
| `MensagemPersonalizada`                  | Prefixo padrão para mensagens de erro/validação das codificações TDD.    |

### JSON / contexto de execução

| Método                                   | Finalidade                                                               |
| ---------------------------------------- | ------------------------------------------------------------------------ |
| `GetValueJson(pJson, pTag)`              | Lê o valor de uma tag de um JSON. Usado pelos wrappers do `P39_TDD_FUNCOES_JSON`. |
| `GetValueJsonDef(pJson, pTag, pDefault)` | Lê o valor de uma tag com fallback.                                      |
| `JSONFormatado(pJson)` / `JsonFormatado(pJson)` | Formata/indenta um JSON para exibição (debug).                  |
| `CodificacaoUnit(pNomeUnit)`             | Retorna o conteúdo (código) de uma unit pelo nome.                       |
| `RequestBodyJSON`                        | Variável global com o corpo JSON da requisição atual.                    |
| `SecaoAtualJson`                         | JSON da seção/parâmetros atuais do processamento.                        |
| `SecaoParametroJson` / `SecaoConfigServidorJson` | JSON de parâmetros/configuração do servidor.                     |
| `Codigo_Empresa_Atual`                   | Código da empresa ativa na sessão do ERP.                                |
| `MES_ATUAL`                              | Mês corrente (constante/global).                                         |
| `DataBase`                               | Data-base/contexto do processamento (variável global).                   |
| `SincronizarCasoTeste`                   | Sincroniza o registro de um caso de teste no banco dedicado.             |

### Utilitários de texto / arquivo / web

| Método                                   | Finalidade                                                               |
| ---------------------------------------- | ------------------------------------------------------------------------ |
| `CorteApos(pTexto, pMarcador)`           | Retorna o trecho a partir do marcador.                                   |
| `CorteAte(pTexto, pMarcador)`            | Retorna o trecho até o marcador.                                         |
| `Troca(pTexto, pDe, pPara)`              | Substitui texto.                                                         |
| `SoNumero(pTexto)`                       | Remove tudo que não é dígito.                                            |
| `RetiraTagsHTML(pTexto)`                 | Remove tags HTML.                                                        |
| `Arredonde(pValor, pCasas)`              | Arredonda valor numérico.                                                |
| `DataSql(pData, pTipo)` / `DataSQL(pData, pTipo)` | Formata data para uso em SQL.                                    |
| `NumeroSQL(pValor)`                      | Formata número para uso em SQL.                                          |
| `DirTemp`                                | Caminho da pasta temporária do cliente.                                  |
| `CriarArquivoTemp(pCaminho, pNome, pDados)` | Cria um arquivo temporário com conteúdo.                              |
| `GetUniqueID`                            | Gera um identificador único (para nomes de arquivos).                    |
| `CompactarArquivo(...)` / `CompactarString(pTexto)` | Compactação (zip/zlib) de arquivos/strings.                   |
| `OleVariantParaStream(pVariant, pStream)`| Converte `OleVariant` em `TMemoryStream`.                                |
| `EnderecoWebProcessado(pUrl)`            | Faz a requisição e retorna o conteúdo processado da URL.                 |
| `AbrirWebBrowser(pUrl)`                  | Abre uma URL no navegador padrão.                                        |
| `ShellExecute(pCmd, pParams, pDir, pShow)` | Executa um comando do sistema operacional.                            |

## Componentes/classes VCL disponíveis

O interpretador expõe as bibliotecas padrão via `JvInterpreter_*.pas`. As classes mais
usadas nas codificações TDD:

| Classe               | Uso comum                                                        |
| -------------------- | ---------------------------------------------------------------- |
| `TClientDataSet`     | Dataset em memória: `CDS.Data := ExecuteReader(pSql)`, `FieldByName`, `FindKey`, `Insert/Edit/Post`, `First/Next/Eof`, `FieldDefs`/`CreateDataSet`, `IndexFieldNames`, `LogChanges := False`. |
| `TStringList`        | Acumular SQL (`SL.Add`/`SL.Text`) ou textos (`SL.Text := ...`).   |
| `TForm` / `TDataModule` | Telas/DMs obtidos via `FormCriadoPeloNome`/`CriarFormPeloNome`/`FindComponent`. |
| `TDataSource`        | Vinculação de dataset a campos editáveis.                         |
| `TDBEdit`, `TDBMemo`, `TDBComboBox`, `TGroupBox`, `TLabel`, `TCheckBox`, `TButton`, `TPanel`, `TPageControl`, `TTabSheet` | Construção de formulários genéricos em tempo de execução. |
| `TJvCalcEdit`, `TJvDBCalcEdit`, `TJvDBComboBox`, `TJvDBDateEdit`, `TJvDateEdit` | Componentes JEDI (edição numérica/data).                  |
| `TField`, `TStringField`, `TIntegerField`, `TFloatField` | Campos calculados/tipados em CDS.                     |
| `TJSONArray`, `TJSONObject` | Conversão de CDS para JSON (`TJSONArray.ToJSON`, `AddPair`). |
| `TMemoryStream`, `TFileStream` | Manipulação de streams.                                      |
| `OleVariant`          | Tipo de retorno dos métodos de dados (`Execute*`).                 |

## Tipos de dados suportados

Tipos reconhecidos em declarações de variáveis (`TypeName2VarTyp`):

| Nome no script            | Tipo Variant interno  |
| ------------------------- | --------------------- |
| `string`, `ShortString`, `AnsiString`, `PChar`, `char` | `varString` |
| `integer`, `longint`, `dword` | `varInteger`      |
| `smallint`, `word`        | `varSmallint`         |
| `byte`                    | `varByte`             |
| `boolean`, `bool`, `longbool`, `wordbool` | `varBoolean` |
| `double`                  | `varDouble`           |
| `tdatetime`               | `varDate`             |
| `TObject`                 | `varObject`           |
| `Variant` / `OleVariant`  | `varVariant`          |

> Cuidado: `Currency`/`Int64`/`Single` **não** têm mapeamento direto em declarações de
> variáveis — prefira `Double` para valores monetários quando necessário, ou use campos
> `AsCurrency`/`AsInteger` de um CDS.

## Estrutura típica de uma unit de codificação

```pascal
uses P39_TDD_ODBC;

procedure Main;
var lInstrucoes: string;
begin
  P39_TDD_ODBC.Main; // Documentação das units do uses!
  lInstrucoes := 'Finalidade da unit...' + #13 + 'Assinatura dos métodos...';
  MostrarLogTexto(lInstrucoes, 'Instruções NOME_DA_UNIT');
end;

function MinhaFuncao(pParametro: Integer): String;
begin
  Result := 'valor ' + IntToStr(pParametro);
end;

procedure MainExecutar;
begin
  CallBack_AbreTela(ClassOwner);
  try
    CallBack_Mensagem(ClassOwner, 'Processando...');
    // fluxo
  finally
    CallBack_FechaTela(ClassOwner);
  end;
end;
```

## Regras de ouro

1. **Sempre** consultar `GR_UNIDADE_CODIFICACAO` (skill `banco-erp-unidades`) para
   conhecer padrões reais e métodos nativos antes de escrever código novo.
2. A `Main` documenta a unit (finalidade + assinaturas) e chama as `Main` das units do
   `uses` antes das próprias instruções.
3. Usar apenas recursos que existem no interpretador (consultar o repositório
   [JEDI/jvcl](https://github.com/project-jedi/jvcl) em `jvcl/run` quando houver dúvida).
4. Evitar `raise Exception.Create(...)` sem `MensagemPersonalizada` como prefixo.
5. Nunca declarar strings de conexão locais; usar `cConexaoODBCPadrao` +
   `P39_TDD_ODBC` para banco dedicado.
