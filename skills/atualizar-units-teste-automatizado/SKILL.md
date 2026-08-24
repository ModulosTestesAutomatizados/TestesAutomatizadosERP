---
name: atualizar-units-teste-automatizado
description: Use quando o usuário chamar "atualizarUnitsTesteAutomatizado" ou pedir para baixar/sincronizar/atualizar as units TDD da TekStore (API tekstore) no diretório local de Source.
---

# atualizarUnitsTesteAutomatizado

Sincroniza as units de teste automatizado (nome iniciado por `TDD`) da **TekStore**
com um diretório local de `.pas`, definido conforme a seção **1. Diretório de destino**.

Regras do processo:
1. Baixa da API apenas as units cujo nome contém `TDD` (`filtro=nome=~TDD`).
2. Compara cada unit com o arquivo `.pas` local e grava **somente** se estiver
   diferente ou ausente (nunca sobrescreve conteúdo idêntico).
3. Ao final, exibe relatório com novos / atualizados / inalterados / falhas.

---

## 1. Diretório de destino

| Item | Valor |
| ---- | ----- |
| diretório | *(em branco — solicitar ao usuário na primeira chamada)* |

**Regras obrigatórias para o diretório:**

- **Primeira chamada** (campo em branco acima): **solicite ao usuário** o caminho
  do diretório onde as units devem ser gravadas.
- Se o usuário **não informar** o diretório, **ABORTE imediatamente** o processo
  inteiro — não autentique, não consulte a API e não grave nada.
- Após uma sincronização bem-sucedida com um diretório informado em tempo de
  execução, **registre-o no campo acima**, substituindo o texto em parênteses,
  para que as próximas chamadas não precisem perguntar novamente.
- Nas chamadas seguintes, use o diretório já registrado sem perguntar.
  Perguntar apenas se o usuário pedir explicitamente para alterar o destino.

---

## 2. Credenciais (PREENCHER ANTES DE USAR)

> **NUNCA deixe credenciais fixas em códigos versionados nem exiba-as em logs.**

| Campo  | Valor |
| ------ | ----- |
| email  | *(em branco — informe aqui ou solicite ao usuário)* |
| senha  | *(em branco — informe aqui ou solicite ao usuário)* |

**Regras de autenticação (obrigatórias):**
- Se os campos acima estiverem em branco ao executar o comando,
  **solicite login e senha ao usuário antes de iniciar** e não prossiga sem eles.
- Se a autenticação na API **falhar** (erro HTTP 4xx/5xx no `/auth`, token vazio
  ou resposta sem `data.token`), **ABORTE imediatamente** o processo inteiro,
  informe o usuário e não tente nenhuma outra chamada.
- Não persistir as credenciais informadas em tempo de execução, a menos que o
  usuário peça explicitamente para salvá-las nesta skill.

---

## 3. Contrato da API

Base: `https://api.tekstore.teksystem.com.br`

| Operação | Método | Rota | Observação |
| -------- | ------ | ---- | ---------- |
| Autenticação | POST | `/auth` | Body JSON `{ "email": "...", "senha": "..." }` |
| Listar units | GET | `/unidadecodificacao?filtro=nome=~TDD&ordenacao=codigo` | QueryParam `filtro` por nome (`~` = contém) + `ordenacao` |
| Detalhe da unit | GET | `/unidadecodificacao/:CODIGO_UNIT` | Retorna `codificacao` completa |

- O token vem em `response.data.token`.
- Nas chamadas seguintes enviar o header **`Authorization: <token>`** (token puro,
  **sem** o prefixo `Bearer`).

---

## 4. Script PowerShell (executar via Shell)

Preencha `$Dir`, `$Email` e `$Senha` (ou colete do usuário se vazios) antes de rodar.

```powershell
# ================= CONFIGURACAO =================
$Dir   = ""   # <- diretorio de destino (solicitar ao usuario se vazio; abortar sem ele)
$Email = ""   # <- preencher (deixe vazio para solicitar ao usuario)
$Senha = ""   # <- preencher (deixe vazio para solicitar ao usuario)
$Base  = "https://api.tekstore.teksystem.com.br"
# ================================================

if ([string]::IsNullOrWhiteSpace($Dir)) {
    throw "DIRETORIO DE DESTINO NAO INFORMADO: solicite o caminho ao usuario. PROCESSO ABORTADO."
}

if (-not (Test-Path -LiteralPath $Dir)) { New-Item -ItemType Directory -Path $Dir -Force | Out-Null }

if ([string]::IsNullOrWhiteSpace($Email) -or [string]::IsNullOrWhiteSpace($Senha)) {
    throw "CREDENCIAIS NAO INFORMADAS: solicite login e senha ao usuario e execute novamente."
}

# --- 1. AUTENTICACAO (aborta tudo se falhar) ---
try {
    $body = @{ email = $Email; senha = $Senha } | ConvertTo-Json
    $auth = Invoke-RestMethod -Uri "$Base/auth" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 30
} catch {
    throw "FALHA DE AUTENTICACAO NA API (/auth): " + $_.Exception.Message + " -> PROCESSO ABORTADO."
}
if (-not $auth.data -or -not $auth.data.token) {
    throw "RESPOSTA DE /auth SEM TOKEN VALIDO -> PROCESSO ABORTADO."
}
$headers = @{ Authorization = $auth.data.token }

# --- 2. LISTAR UNITS TDD ---
try {
    $lista = Invoke-RestMethod -Uri "$Base/unidadecodificacao?filtro=nome=~TDD&ordenacao=codigo" -Method Get -Headers $headers -TimeoutSec 60
} catch {
    throw "FALHA AO CONSULTAR UNITS -> PROCESSO ABORTADO: " + $_.Exception.Message
}

$novos = 0; $atualizados = 0; $inalterados = 0; $falhas = @()
$utf8Bom = New-Object System.Text.UTF8Encoding($true)

# --- 3. COMPARAR E ATUALIZAR ---
foreach ($u in $lista.data) {
    try {
        $det = Invoke-RestMethod -Uri ("$Base/unidadecodificacao/" + $u.codigo) -Method Get -Headers $headers -TimeoutSec 60
        $conteudoApi = $det.data.codificacao
        $arquivo = Join-Path $dir ($u.nome + ".pas")

        if (-not (Test-Path -LiteralPath $arquivo)) {
            [IO.File]::WriteAllText($arquivo, $conteudoApi, $utf8Bom)
            Write-Output ("NOVO       " + $u.codigo + "  " + $u.nome + ".pas")
            $novos++
        }
        else {
            $conteudoLocal = [IO.File]::ReadAllText($arquivo)
            if ($conteudoLocal -ne $conteudoApi) {
                [IO.File]::WriteAllText($arquivo, $conteudoApi, $utf8Bom)
                Write-Output ("ATUALIZADO " + $u.codigo + "  " + $u.nome + ".pas")
                $atualizados++
            }
            else {
                Write-Output ("INALTERADO " + $u.codigo + "  " + $u.nome + ".pas")
                $inalterados++
            }
        }
        Start-Sleep -Milliseconds 150
    }
    catch {
        Write-Output ("ERRO       " + $u.codigo + "  " + $u.nome + ": " + $_.Exception.Message)
        $falhas += $u.nome
    }
}

Write-Output ""
Write-Output ("RESUMO: " + @($lista.data).Count + " unidades na API | " + $novos + " novas | " +
    $atualizados + " atualizadas | " + $inalterados + " inalteradas | " + @($falhas).Count + " falhas" +
    $(if ($falhas.Count -gt 0) { " -> " + ($falhas -join ', ') } else { "" }))
```

---

## 5. Regras adicionais

- **Abortar** o processo se o diretório de destino não for informado (seção 1).
- **Abortar** o processo caso qualquer etapa de autenticação falhe (seção 2).
- Nunca imprimir a senha nem o token completo na saída do comando.
- Units locais `.pas` que não existirem mais na API devem ser apenas **reportadas**
  (não excluídas), salvo instrução contrária do usuário.
- Este fluxo é idempotente: rodar novamente não gera alterações se nada mudou na API.
