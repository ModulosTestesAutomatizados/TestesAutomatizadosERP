# Tutorial: Instalação e Configuração do Agente Delphi TDD

Guia completo para instalar e configurar o agente opencode com as skills de teste automatizado Delphi.

---

## Índice

1. [Pré-requisitos](#1-pré-requisitos)
2. [Instalação do opencode](#2-instalação-do-opencode)
3. [Clonagem do repositório](#3-clonagem-do-repositório)
4. [Configuração do agente](#4-configuração-do-agente)
5. [Instalação das skills](#5-instalação-das-skills)
6. [Configuração dos MCPs](#6-configuração-dos-mcps)
7. [Configuração do banco de dados](#7-configuração-do-banco-de-dados)
8. [Teste da instalação](#8-teste-da-instalação)
9. [Solução de problemas](#9-solução-de-problemas)

---

## 1. Pré-requisitos

### Hardware mínimo

| Componente | Mínimo | Recomendado |
|------------|--------|-------------|
| Memória RAM | 8 GB | 16 GB |
| Espaço em disco | 10 GB | 20 GB |
| CPU | x86_64 moderna | Qualquer CPU recente |

### Software necessário

| Software | Versão | Finalidade |
|----------|--------|------------|
| Git | Qualquer | Controle de versão |
| opencode | Mais recente | Agente de IA |
| Node.js/Bun | 18+ / 1.3.9+ | Runtime para plugins |
| Terminal | Moderno | Interface (WezTerm, Alacritty, Ghostty) |

### Sistema operacional

| SO | Versão mínima | Observações |
|----|---------------|-------------|
| Linux | Ubuntu 20.04+ | Qualquer distro moderna |
| macOS | 10.15+ (Catalina) | Apple Silicon ou Intel |
| Windows | 10/11 | **WSL2 obrigatório** |

---

## 2. Instalação do opencode

### Windows (WSL2 - recomendado)

```bash
# 1. Instalar WSL2 (se ainda não tiver)
wsl --install

# 2. Reiniciar o computador

# 3. Abrir terminal WSL e instalar opencode
curl -fsSL https://opencode.ai/install | bash

# 4. Verificar instalação
opencode --version
```

### Windows (nativo - alternativa)

```bash
# Usando Chocolatey
choco install opencode

# Ou usando Scoop
scoop install opencode

# Ou usando npm
npm install -g opencode-ai
```

### Linux

```bash
# Instalação via script
curl -fsSL https://opencode.ai/install | bash

# Ou via gerenciador de pacotes
# Ubuntu/Debian
npm install -g opencode-ai

# Arch Linux
sudo pacman -S opencode
```

### macOS

```bash
# Via Homebrew (recomendado)
brew install anomalyco/tap/opencode

# Ou via npm
npm install -g opencode-ai
```

---

## 3. Clonagem do repositório

### Acesso via SSH (recomendado)

```bash
# Configurar chave SSH (se ainda não tiver)
ssh-keygen -t ed25519 -C "seu-email@exemplo.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copiar chave pública para GitHub
cat ~/.ssh/id_ed25519.pub
# Adicionar no GitHub > Settings > SSH Keys

# Clonar repositório
git clone git@github.com:ModulosTestesAutomatizados/TestesAutomatizadosERP.git
cd TestesAutomatizadosERP
```

### Acesso via HTTPS

```bash
git clone https://github.com/ModulosTestesAutomatizados/TestesAutomatizadosERP.git
cd TestesAutomatizadosERP
```

---

## 4. Configuração do agente

### 4.1 Configurar chaves de API

Execute o opencode e configure pelo menos um provedor de LLM:

```bash
opencode
```

Dentro do opencode, execute:

```
/connect
```

Selecione o provedor desejado e insira a chave de API:

- **OpenAI**: `sk-...`
- **Anthropic**: `sk-ant-...`
- **Google AI**: `AIza...`
- **GitHub Copilot**: Configure via GitHub

### 4.2 Configuração manual (alternativa)

Crie o arquivo `.opencode/opencode.json` se não existir:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["./AGENTS.md"],
  "skills": {
    "paths": ["./skills"]
  },
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}"
      },
      "enabled": true
    },
    "github": {
      "type": "remote",
      "url": "https://api.githubcopilot.com/mcp/",
      "enabled": true,
      "oauth": false,
      "headers": {
        "Authorization": "Bearer {env:PAT_MCP_TESTE_AUTOMATIZADO}",
        "X-MCP-Toolsets": "all"
      }
    }
  }
}
```

---

## 5. Instalação das skills

As skills estão no diretório `skills/` do repositório. Elas são carregadas automaticamente pelo opencode.

### Skills disponíveis

| Skill | Descrição |
|-------|-----------|
| `atualizar-repositorio-agente` | Sincronizar repositório |
| `atualizar-units-teste-automatizado` | Baixar units TDD |
| `banco-dedicado` | Conexão com banco de testes |
| `banco-erp-unidades` | Consulta banco ERP |
| `context7` | Consulta documentações |
| `entregas` | Processo de entregas |
| `estrutura-testes-erp` | Estrutura de testes |
| `firebird-language-reference` | Referência Firebird |
| `firebird-conexao-metadados` | Conexão Firebird |
| `generate-report` | Geração de relatórios |
| `interpretador-delphi-erp` | Interpretador Delphi |
| `tdd-odbc` | Conexões ODBC |

### Verificar skills carregadas

Dentro do opencode, execute:

```
/skills
```

---

## 6. Configuração dos MCPs

### 6.1 Context7 (Documentações)

Obtenha uma chave de API em: https://context7.com

```bash
# Exportar variável de ambiente
export CONTEXT7_API_KEY="sua-chave-aqui"

# Ou adicionar ao ~/.bashrc ou ~/.zshrc
echo 'export CONTEXT7_API_KEY="sua-chave-aqui"' >> ~/.bashrc
source ~/.bashrc
```

### 6.2 GitHub MCP

Crie um Personal Access Token (PAT) no GitHub:

1. Acesse: https://github.com/settings/tokens
2. Clique em "Generate new token (classic)"
3. Selecione os escopos: `repo`, `workflow`, `read:org`
4. Copie o token gerado

```bash
# Exportar variável de ambiente
export PAT_MCP_TESTE_AUTOMATIZADO="ghp_seu-token-aqui"

# Ou adicionar ao ~/.bashrc ou ~/.zshrc
echo 'export PAT_MCP_TESTE_AUTOMATIZADO="ghp_seu-token-aqui"' >> ~/.bashrc
source ~/.bashrc
```

---

## 7. Configuração do banco de dados

### 7.1 Instalar Firebird Client

```bash
# Windows - baixar do site oficial
# https://firebirdsql.org/en/firebird-5-0/

# Linux (Ubuntu/Debian)
sudo apt-get install firebird5.0-utils

# macOS
brew install firebird
```

### 7.2 Verificar conexão

```bash
# Testar conexão com isql
isql -user SYSDBA -password masterkey "127.0.0.1/3055:D:\DataBases\TesteAutomatizado\TESTEAUTOMATIZADOMC.FDB"
```

### 7.3 Extrair metadados

```bash
# Extrair DDL do banco
isql -user SYSDBA -password masterkey -x -o metadados.sql "127.0.0.1/3055:D:\DataBases\TesteAutomatizado\TESTEAUTOMATIZADOMC.FDB"
```

---

## 8. Teste da instalação

### 8.1 Iniciar o agente

```bash
cd D:\TestesAutomatizados\Agente
opencode
```

### 8.2 Testar comandos básicos

Dentro do opencode:

```
# Verificar versão
/version

# Listar skills disponíveis
/skills

# Testar conexão com GitHub
>Liste os issues abertos no repositório

# Testar skill de banco
>Conecte ao banco dedicado e Liste as tabelas
```

### 8.3 Testar uma skill específica

```
>Carregue a skill interpretador-delphi-erp e me diga quais métodos nativos estão disponíveis
```

---

## 9. Solução de problemas

### Problema: `opencode` não encontrado

```bash
# Verificar se está no PATH
which opencode

# Se não encontrar, reinstale
curl -fsSL https://opencode.ai/install | bash
```

### Problema: Erro de conexão com MCP

```bash
# Verificar variáveis de ambiente
echo $CONTEXT7_API_KEY
echo $PAT_MCP_TESTE_AUTOMATIZADO

# Se estiver vazio, configure novamente
export CONTEXT7_API_KEY="sua-chave"
export PAT_MCP_TESTE_AUTOMATIZADO="seu-token"
```

### Problema: Skills não carregam

```bash
# Verificar se o arquivo de configuração existe
cat .opencode/opencode.json

# Verificar se o diretório skills existe
ls -la skills/
```

### Problema: Erro de permissão (Linux/macOS)

```bash
# Dar permissão de execução
chmod +x ~/.opencode/bin/opencode
```

### Problema: WSL não acessa arquivos Windows

```bash
# Acessar via /mnt/c/ ou /mnt/d/
cd /mnt/c/Users/SeuUsuario/Documents/TestesAutomatizados/Agente
```

### Problema: CPU sem suporte AVX2 (macOS Intel antigo)

Use WSL2 ou Docker:

```bash
# Via Docker
docker run -it --rm ghcr.io/anomalyco/opencode
```

---

## Comandos úteis do opencode

| Comando | Descrição |
|---------|-----------|
| `/help` | Ajuda |
| `/connect` | Configurar provedor LLM |
| `/skills` | Listar skills |
| `/model` | Trocar modelo |
| `/undo` | Desfazer última alteração |
| `/redo` | Refazer alteração |
| `/share` | Compartilhar conversa |
| `/init` | Inicializar projeto |

---

## Atalho para Desktop (Windows)

Crie um arquivo `abrir-agente.bat`:

```batch
@echo off
cd /d D:\TestesAutomatizados\Agente
git fetch --all --prune
git pull --ff-only
opencode
```

Clique com o botão direito > Enviar para > Atalho Área de Trabalho.

---

## Referências

- [Documentação oficial do opencode](https://opencode.ai/docs/)
- [GitHub do opencode](https://github.com/anomalyco/opencode)
- [Firebird 5.0](https://firebirdsql.org/)
- [JEDI VCL (JvInterpreter)](https://github.com/project-jedi/jvcl)

---

**Última atualização:** 26/08/2026