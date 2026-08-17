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

## 🔌 Como Adicionar Novos MCPs (Conectores)

Os Model Context Protocols (MCPs) e conectores personalizados ficam armazenados em `src/Connectors/`.

Para adicionar um novo ou modificar um existente (como o `context7`):

1. **Defini o da API:** Altere o arquivo `[nome_do_conector]_openapidefinition.json` para adicionar novos endpoints e m todos HTTP.
2. **Par metros:** Ajuste as credenciais de autentica o no `[nome_do_conector]_connectionparameters.json`.
3. **Sincroniza o:** Fa a o commit e push para a `main`. A pipeline ir  empacotar a pasta `src/` e atualizar a solu o no ambiente. *Lembre-se de reautenticar a Refer ncia de Conex o (Connection Reference) no portal ap s o deploy, se as chaves mudarem.*
