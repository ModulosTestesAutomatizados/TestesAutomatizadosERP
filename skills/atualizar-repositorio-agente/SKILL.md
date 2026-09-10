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
(em vez de descartar), executar:

1. Restaurar o índice (se `git read-tree` foi usado na comparação) e criar branch de preservação:

```powershell
git reset
git checkout -b preservar-alteracoes-locais
```

2. Commitar TODAS as alterações locais (modificados, deletados e arquivos novos) na branch:

```powershell
git add -A
git commit -m "Preserva alterações locais antes de sincronizar com origin/main"
```

3. Voltar para `main` e sincronizar com o remoto (descartando as alterações da main):

```powershell
git checkout main
git reset --hard origin/main
```

4. Mesclar a branch de preservação na `main` para trazer de volta as alterações locais:

```powershell
git merge preservar-alteracoes-locais
```

- Se houver conflitos, resolvê-los antes de prosseguir.

5. Enviar as alterações para o remoto e remover a branch de preservação:

```powershell
git push origin main
git branch -d preservar-alteracoes-locais
```

6. Validar o resultado final:

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
- `git reset --hard` não remove arquivos untracked; ao commitar os arquivos novos na branch de preservação e executar `checkout main`, eles saem do working tree e são recuperados no merge.
- O fluxo da seção 4 é o recomendado quando o usuário deseja manter as alterações locais: nada é perdido, pois tudo é commitado na branch de preservação antes de sincronizar a `main`.
- O fluxo é idempotente: rodar novamente em repositório já sincronizado apenas executa fetch + validação.
