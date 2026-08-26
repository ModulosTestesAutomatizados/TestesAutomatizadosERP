@echo off
setlocal
title Testes Automatizados ERP

REM Resolve o proprio diretorio, independente de onde o repositorio foi clonado
set "REPO_DIR=%~dp0"
REM Remove a barra final para evitar que aspas escapem ao passar o caminho a comandos .cmd
if "%REPO_DIR:~-1%"=="\" set "REPO_DIR=%REPO_DIR:~0,-1%"
set "BRANCH=%~1"

REM Resolve a pasta Desktop (funciona com redirecionamento / OneDrive)
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set "DESKTOP=%%D"
set "SHORTCUT_PATH=%DESKTOP%\Testes Automatizados ERP.lnk"

cd /d "%REPO_DIR%"

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 goto :nao_git

REM Instala o atalho no Desktop somente se ainda nao existir
if not exist "%SHORTCUT_PATH%" (
    echo Atalho nao encontrado no Desktop. Instalando...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$s = (New-Object -ComObject WScript.Shell).CreateShortcut('%SHORTCUT_PATH%'); $s.TargetPath = '%REPO_DIR%\abrir-teste-automatizado-erp.bat'; $s.WorkingDirectory = '%REPO_DIR%'; $s.IconLocation = 'shell32.dll,21'; $s.Description = 'Abre o opencode com o contexto de Testes Automatizados ERP'; $s.Save()"
    if errorlevel 1 goto :erro_atalho
    echo Atalho instalado no Desktop.
)

echo ========================================
echo   TESTES AUTOMATIZADOS ERP
echo ========================================
echo Sincronizando com o GitHub...

git fetch --all --prune
if errorlevel 1 goto :erro_fetch

if defined BRANCH (
    echo Trocando para a branch "%BRANCH%"...
    git checkout "%BRANCH%"
    if errorlevel 1 goto :conflito
)

echo Atualizando a branch atual...

REM Garante uma branch com upstream definido (fallback para a branch principal)
git rev-parse --abbrev-ref @{u} >nul 2>&1
if errorlevel 1 (
    echo Branch atual sem upstream definido, usando a branch principal main...
    git checkout main
    if errorlevel 1 goto :conflito
)

git pull --ff-only
if errorlevel 1 goto :conflito

echo.
echo Repositorio atualizado com sucesso.
echo Abrindo o opencode...

where opencode >nul 2>&1
if errorlevel 1 goto :sem_opencode

opencode "%REPO_DIR%"
exit /b 0

:nao_git
echo ERRO: este diretorio nao e um repositorio Git.
echo Clone o repositorio antes de usar o atalho.
goto :fim_erro

:erro_atalho
echo ERRO: nao foi possivel criar o atalho no Desktop.
goto :fim_erro

:erro_fetch
echo ERRO: falha no git fetch.
echo Verifique a conectividade com o GitHub e a chave SSH.
goto :fim_erro

:conflito
echo.
echo FALHA ao atualizar: conflito de merge ou alteracoes locais pendentes.
echo Abrindo o VS Code na pasta para resolucao manual...
where code >nul 2>&1
if not errorlevel 1 (
    code "%REPO_DIR%"
) else (
    echo VS Code nao encontrado no PATH. Abra a pasta manualmente.
)
goto :fim_erro

:sem_opencode
echo ERRO: comando 'opencode' nao encontrado no PATH.
echo Instale o opencode e tente novamente.
goto :fim_erro

:fim_erro
echo.
pause
exit /b 1
