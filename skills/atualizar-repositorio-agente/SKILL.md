---
name: atualizar-repositorio-agente
description: Use quando o usuário chamar "AtualizarRepositorioAgente" ou pedir pull/atualização do repositório AgenteDelphiTDD em D:\TestesAutomatizados\Agente.
---

# AtualizarRepositorioAgente

Atualiza a pasta `D:\TestesAutomatizados\Agente` com o repositório
`https://github.com/ModulosTestesAutomatizados/AgenteDelphiTDD.git`, branch `main`,
adotando os arquivos locais existentes sem sobrescrever nada sem antes comparar e reportar.

## 1. Conectar

Se a pasta ainda não for um repositório (`.git` inexistente):

```powershell
git init -b main
git remote add origin https://github.com/ModulosTestesAutomatizados/AgenteDelphiTDD.git
git fetch origin
```

Se já for repositório:

```powershell
git fetch origin
```

Branches do remoto: `main` (padrão/HEAD), `develop` e `gh-pages`.

## 2. Comparar sem tocar nos arquivos

NUNCA use `git diff --stat origin/main` com HEAD não nascido (repositório recém-
inicializado): o índice está vazio e TODOS os arquivos aparecem como deletados,
mesmo existindo localmente com conteúdo idêntico.

Método confiável — carrega a árvore remota apenas no índice (não altera arquivo):

```powershell
git read-tree origin/main
git status --porcelain
```

Interpretação do `status --porcelain`:
- Segunda coluna (worktree × índice) **em branco** para todas as entradas → arquivos locais idênticos ao remoto.
- `AM` / ` M` → conteúdo local divergente: PARAR, mostrar as diferenças (`git diff origin/main -- <arquivo>`) e perguntar ao usuário (descartar / preservar / revisar) antes de qualquer sobrescrita.
- `AD` / ` D` → arquivo rastreado ausente localmente: reportar.
- Extras locais fora do repositório (ex.: `.opencode/node_modules`) são ignorados pelo `.gitignore` e não devem gerar ruído no relatório.

## 3. Sincronizar (somente se idêntico)

```powershell
git checkout -B main origin/main
git branch --set-upstream-to=origin/main main
```

Se houver divergências: interromper aqui e aguardar decisão do usuário.
Se o usuário optar por **preservar** as alterações locais, seguir o fluxo da seção 4.

## 4. Preservar alterações locais (fluxo com merge)

Quando houver divergências e o usuário optar por **preservar as alterações locais**
(em vez de descartar), executar o fluxo abaixo **nessa ordem**:

1. Restaurar o índice (se `git read-tree` foi usado na comparação) e criar a branch
   **"Registro de alterações"** para guardar as alterações locais:

```powershell
git reset
git checkout -b "Registro de alterações"
```

2. Commitar TODAS as alterações locais (modificados, deletados e arquivos novos) nessa branch:

```powershell
git add -A
git commit -m "Registro de alterações locais"
```

3. Voltar para a branch `main` e **somente pegar as alterações do repositório** (pull),
   sem levar nenhuma alteração local — a `main` deve ficar igual ao remoto:

```powershell
git checkout main
git pull origin main
```

> ⚠️ O `git reset --hard origin/main` NÃO deve ser usado neste fluxo: o objetivo
> é apenas receber as novidades do remoto na `main` local, preservando o histórico.

4. Fazer o merge da branch **"Registro de alterações"** na `main`, de modo que **as
   alterações locais prevaleçam**:

```powershell
git merge "Registro de alterações"
```

- Se o merge for automático (sem conflito), prosseguir normalmente.
- **Se houver CONFLITO: PARAR e perguntar ao usuário como resolver** — nunca resolver
  automaticamente e nunca sobrescrever sem confirmação.

5. Após o merge OK (main atualizada com as alterações locais), publicar no remoto
   (push) as alterações:

```powershell
git push origin main
```

6. Somente após o push ser realizado com sucesso, excluir a branch de registro:

```powershell
git branch -d "Registro de alterações"
```

7. Validar o resultado final:

```powershell
git status
git log --oneline -3
```

## 5. Validação final

```powershell
git log --oneline -3
git status
```

Critérios de sucesso:
- Último commit de `main` igual ao HEAD de `origin/main` (conferir com `git ls-remote origin main` se necessário).
- `git status`: "working tree clean" e "up to date with 'origin/main'".

## 6. Observações

- Nunca executar `git reset --hard`, `checkout -f` ou `push` sem confirmação explícita do usuário após o relatório de diferenças.
- `git pull origin main` na etapa 3 recebe **somente** as alterações do remoto; a branch "Registro de alterações" é quem guarda o conteúdo local.
- No fluxo da seção 4, as alterações locais **prevalecem** no merge. Havendo conflito, o processo é interrompido e o usuário é consultado.
- `git reset --hard` não remove arquivos untracked; ao commitar os arquivos novos na branch de registro e executar `checkout main`, eles saem do working tree e são recuperados no merge.
- A branch "Registro de alterações" só **deve ser excluída após o push** da `main` ter sido concluído com sucesso.
- O fluxo é idempotente: rodar novamente em repositório já sincronizado apenas executa fetch + validação.
