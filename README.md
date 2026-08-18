# fonte-conhecimento-agente-delphi-tdd

Repositório público com a fonte de conhecimento para o agente criado com a finalidade de auxiliar no desenvolvimento dos testes automatizados.

## 📂 Estrutura do Repositório

Nossa estrutura  dividida entre a documenta o/base de conhecimento e o c digo-fonte da solu o do Copilot Studio:

```text
├── .github/workflows/      # Pipelines de CI/CD (Deploy da Solu o e MkDocs)
├── assets/                 # Arquivos auxiliares e scripts Delphi
├── docs/                   # Documenta o t cnica (MER, Mapeamento de Uses)
├── skills/                 # Base de Conhecimento do Agente (Arquivos .md)
├── src/                    # C digo-fonte desempacotado da Solu o Power Platform
│   ├── bots/               # Configura es principais do Agente
│   ├── botcomponents/      # T picos e Skills (A es) nativas do Copilot
│   ├── Connectors/         # Defini es de Conectores Customizados (MCPs)
│   └── Other/              # Metadados da Solu o (Solution.xml, etc.)
├── mkdocs.yml              # Configura o do portal de documenta o
└── README.md               # Este arquivo
```

---

## 🧩 Como Adicionar Novas Skills (Ações/Tópicos)

Para adicionar novas capacidades comportamentais ao agente, voc  tem duas op

**Op o 1: Base de Conhecimento (RAG)**
Se a skill for apenas informacional (como as diretrizes de TDD), adicione um novo diret rio e um arquivo `SKILL.md` dentro da pasta `skills/`.

**Op o 2: A es do Copilot (Power e Actions)**
Se a skill exigir integra o l gica:

1. Crie o rascunho visualmente no Copilot Studio.
2. Exporte a solu o e fa a o `unpack`.
3. Os novos t picos/skills aparecer o em `src/botcomponents/`. Voc  pode editar o YAML diretamente nestes arquivos para ajustar l gica, prompts e vari veis.

---

## 🛠️ Como Criar Novas Skills via Código (Code-First)

Para que qualquer desenvolvedor adicione uma nova skill ao agente sem precisar acessar o portal do Copilot Studio, basta seguir este template.

O nosso agente principal tem o ID interno: `cr6d8_delphitdd_fmc1IK`. Todas as skills devem ser filhas dele.

O arquivo pode ser chamado data (sem extensão) ou data.yml. Extensão .yml é recomendada por facilitar sintaxe e validação.

### Passo 1: Criar o Diretório da Skill

Dentro da pasta `src/botcomponents/`, crie uma nova pasta seguindo esta exata nomenclatura:
`cr6d8_delphitdd_fmc1IK.skill.[nome_da_skill]_[sufixo_aleatorio]`

- **Exemplo:** `cr6d8_delphitdd_fmc1IK.skill.gerar_relatorio_abc`
- *Nota:* O sufixo aleatório (ex: `abc`, `gLR`, `v1`) garante que o ID não conflite com outras skills no banco de dados.

### Passo 2: Criar o Arquivo de Metadados (`botcomponent.xml`)

Dentro da nova pasta, crie um arquivo chamado `botcomponent.xml` e cole o template abaixo.
**Atenção:** Substitua os valores entre colchetes `[]` pelos dados da sua skill. O `schemaname` deve ser **idêntico** ao nome da pasta que você acabou de criar.

```xml
<botcomponent schemaname="cr6d8_delphitdd_fmc1IK.skill.[nome_da_skill]_[sufixo_aleatorio]">
  <componenttype>9</componenttype>
  <description>[Escreva aqui para que serve essa skill, o agente usará isso para saber quando chamá-la]</description>
  <iscustomizable>0</iscustomizable>
  <name>[Nome Amigável da Skill]</name>
  <parentbotid>
    <schemaname>cr6d8_delphitdd_fmc1IK</schemaname>
  </parentbotid>
  <statecode>0</statecode>
  <statuscode>1</statuscode>
</botcomponent>
```

### Passo 3: Criar o Arquivo de Lógica (data)

- Na mesma pasta, crie um arquivo chamado *data* ou *data.yml*. Este arquivo contém o Prompt ou fluxo em formato YAML.
- Este arquivo deve incluir:
  - Bloco `<skill>` com `name`, `description` e `location`.
  - Em seguida, a lógica da skill em formato YAML utilizando `content: |`.

#### Cole o template abaixo e construa a sua lógica

```yml
datakind: InlineAgentSkill
- <skill>
    <name>[nome_da_skill_sem_espacos]</name>
    <description>[Descrição amigável]</description>
    <location>custom</location>
  </skill>
content: |
  ---
  name: [nome_da_skill_sem_espacos]
  description: [Descrição da funcionalidade e contexto para o agente]
  ---
  <!-- bic:source=upload -->
  # Diretrizes da Skill
  
  Escreva aqui as instruções que orientam o comportamento do agente.
```

### Passo 4: Commit e Deploy

Após criar a pasta e os dois arquivos, faça o commit e envie para a branch main. Nossa pipeline CI/CD fará o empacotamento automático e a nova skill aparecerá no Copilot Studio em poucos minutos!

---

### 🚀 Por que isso funciona?

O Power Platform reconhece que qualquer subpasta dentro de [`src/botcomponents/`](#passo-1-criar-o-diretório-da-skill) que possua um [`botcomponent.xml`](#passo-1-criar-o-diretório-da-skill) válido e faça referência ao `parentbotid` (no nosso caso, o [`cr6d8_delphitdd_fmc1IK`](#passo-1-criar-o-diretório-da-skill)) é um componente que deve ser amarrado ao agente.

Com esse manual no [`README.md`](#passo-1-criar-o-diretório-da-skill), qualquer dev da sua equipe consegue fazer engenharia de prompt, criar ações e versionar tudo bonitinho via Pull Request!

---

---

## 🤖 Agente Local no opencode

O mesmo conhecimento do `skills/` é consumido pelo agente **opencode** (CLI local) **sem duplicação**: o `.opencode/opencode.json` aponta para `skills/` e para o `AGENTS.md` deste repositório. Assim, qualquer alteração nas skills via PR vale tanto para o portal (MkDocs/RAG) quanto para o agente local.

### Configuração na máquina do desenvolvedor

1. Clone o repositório:
   ```bash
   git clone git@github.com:ModulosTestesAutomatizados/fonte-conhecimento-agente-delphi-tdd.git
   ```
2. Execute o `abrir-agente-delphi.bat` (duplo clique). Na **primeira execução**, ele cria automaticamente o atalho **Agente Delphi TDD** na Área de Trabalho (somente se ainda não existir) e já abre o agente — sem nenhum caminho fixo (a localização é resolvida em tempo de execução).
3. Pronto. A cada clique no atalho (ou no próprio `.bat`), o `abrir-agente-delphi.bat`:
   - garante o atalho no Desktop, instalando-o apenas se não existir;
   - executa `git fetch --all --prune` + `git pull --ff-only` (recebe os PRs de skills dos outros devs);
   - se a branch atual não tiver upstream definido, cai automaticamente na `main`;
   - em caso de conflito ou alterações locais pendentes, abre o **VS Code** na pasta para resolução manual;
   - abre o **opencode** no diretório do repositório, carregando automaticamente as skills e as diretrizes do `AGENTS.md`, mescladas com a configuração global.

### Pré-requisitos

- Git instalado e no `PATH`;
- [opencode](https://opencode.ai) instalado e no `PATH`;
- VS Code no `PATH` (`code`) para a resolução manual de conflitos (opcional);
- Acesso ao remote via **SSH** (chave configurada) — ou troque a URL do remote para HTTPS:
  ```bash
  git remote set-url origin https://github.com/ModulosTestesAutomatizados/fonte-conhecimento-agente-delphi-tdd.git
  ```

### Uso avançado

Abrir o opencode em **outro projeto** (fora deste repositório) com o contexto do agente injetado. Os caminhos relativos do `.opencode/opencode.json` (`../skills` e `../AGENTS.md`) são resolvidos a partir do próprio arquivo de configuração:

```bash
OPENCODE_CONFIG=C:\caminho\do\clone\.opencode\opencode.json opencode <caminho-do-projeto>
```

---

## 🔌 Como Adicionar Novos MCPs (Conectores)

Os Model Context Protocols (MCPs) e conectores personalizados ficam armazenados em `src/Connectors/`.

Para adicionar um novo ou modificar um existente (como o `context7`):

1. **Defini o da API:** Altere o arquivo `[nome_do_conector]_openapidefinition.json` para adicionar novos endpoints e m todos HTTP.
2. **Par metros:** Ajuste as credenciais de autentica o no `[nome_do_conector]_connectionparameters.json`.
3. **Sincroniza o:** Fa a o commit e push para a `main`. A pipeline ir  empacotar a pasta `src/` e atualizar a solu o no ambiente. *Lembre-se de reautenticar a Refer ncia de Conex o (Connection Reference) no portal ap s o deploy, se as chaves mudarem.*
