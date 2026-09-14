---
name: atualizar-repositorio-agente
description: Use quando o usuário chamar "AtualizarRepositorioAgente" ou pedir pull/atualização do repositório de testes automatizados em D:\TestesAutomatizados\Agente.
---

# AtualizarRepositorioAgente

Atualiza a pasta `D:\TestesAutomatizados\Agente` com o repositório
`https://github.com/ModulosTestesAutomatizados/TestesAutomatizadosERP.git`, branch `master`
(principal), adotando os arquivos locais existentes sem sobrescrever nada sem antes comparar e reportar.

## 1. Conectar

Se a pasta ainda não for um repositório (`.git` inexistente):

```powershell
git init -b master
git remote add origin https://github.com/ModulosTestesAutomatizados/TestesAutomatizadosERP.git
git fetch origin
git checkout master 2>$null  # cria branch local rastreando origin/master quando remoto já possui
git branch --set-upstream-to=origin/master master
```

Se já for repositório:

```powershell
git fetch origin
```

Branches do remoto: `master` (principal/HEAD), `main`, `develop` e `gh-pages`.

> **Importante:** a branch principal do repositório é `master` (a `main` existe,
> mas contém estrutura divergente — versão "AgenteDelphiTDD" reorganizada). Sempre
> trabalhar na `master`.

## 2. Comparar sem tocar nos arquivos

NUNCA use `git diff --stat origin/master` com HEAD não nascido (repositório recém-
inicializado): o índice está vazio e TODOS os arquivos aparecem como deletados,
mesmo existindo localmente com conteúdo idêntico.

Método confiável — carrega a árvore remota apenas no índice (não altera arquivo):

```powershell
git read-tree origin/master
git status --porcelain
```

Interpretação do `status --porcelain`:
- Segunda coluna (worktree × índice) **em branco** para todas as entradas → arquivos locais idênticos ao remoto.
- `AM` / ` M` → conteúdo local divergente: PARAR, mostrar as diferenças (`git diff origin/master -- <arquivo>`) e perguntar ao usuário (descartar / preservar / revisar) antes de qualquer sobrescrita.
- `AD` / ` D` → arquivo rastreado ausente localmente: reportar.
- Extras locais fora do repositório (ex.: `.opencode/node_modules`) são ignorados pelo `.gitignore` e não devem gerar ruído no relatório.

## 3. Sincronizar (somente se idêntico)

```powershell
git checkout -B master origin/master
git branch --set-upstream-to=origin/master master
```

Se houver divergências: interromper aqui e aguardar decisão do usuário.

> Fluxo de preservação de alterações locais: quando o usuário optar por **preservar**,
> criar a branch "Registro de alterações" com as mudanças locais, atualizar a `master`
> a partir do remoto e fazer merge da branch de registro na `master` (as alterações
> locais prevalecem). Havendo conflito, PARAR e consultar o usuário. Publicar com
> `git push origin master` e excluir a branch de registro somente após o push.

## 4. Validação final

```powershell
git log --oneline -3
git status
```

Critérios de sucesso:
- Último commit de `master` igual ao HEAD de `origin/master` (conferir com `git ls-remote origin master` se necessário).
- `git status`: "working tree clean" e "up to date with 'origin/master'".

## 5. Observações

- Nunca executar `git reset --hard` ou `checkout -f` sem confirmação explícita do usuário após o relatório de diferenças.
- O fluxo é idempotente: rodar novamente em repositório já sincronizado apenas executa fetch + validação.
- Para alterar a branch padrão do repositório local, usar `git remote set-head origin master`.