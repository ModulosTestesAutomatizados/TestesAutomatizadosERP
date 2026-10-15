param([string]$Root, [string]$SourcePath)
$ErrorActionPreference = 'Stop'
if (-not $SourcePath) { $SourcePath = Join-Path $Root 'docs/assets/emDesenvolvimento/Runner/TDD_RUNNER.pas' }
$source = Get-Content -LiteralPath $SourcePath -Raw -Encoding utf8
# Sonda numerica: executa somente a expressao/rotina escalar extraida do Pascal.
# Nao compila a unit nem simula adapters, datasets ou o JvInterpreter.
$match = [regex]::Match($source, '(?is)function CalcularTickRelativo\(pTempoTick, pTempoBase :Double\) :Integer;\s*var lTempoDecorrido :Double;\s*begin\s*(.*?)\s*end;')
if ($match.Success) {
  $body = $match.Groups[1].Value
  $body = [regex]::Replace($body, '//[^\r\n]*', '')
  $body = $body -replace ':=', '='
  $body = $body -replace '(?is)if\s+([^;]+?)\s+then\s+raise Exception.Create\(([^;]+)\);', 'if ($1) { throw new System.Exception($2); }'
  $body = $body -replace '(?is)if\s+([^;]+?)\s+then\s+([^;]+);', 'if ($1) { $2; }'
  $body = $body -replace "'([^']*)'", '"$1"'
  $body = $body -replace 'MensagemPersonalizada\s*\+', '"" +'
  Add-Type -TypeDefinition ('public static class RunnerTickProbe { public static int Read(double pTempoTick, double pTempoBase) { double lTempoDecorrido; double Result; ' + $body + ' return System.Convert.ToInt32(Result); } }')
  $read = { param($tick,$base) [RunnerTickProbe]::Read($tick,$base) }
} else {
  if ($source -notmatch 'lTempoTick := GetTickCount;' -or $source -notmatch "'TEMPO_INICIO'\).AsInteger\s*:= lTempoTick") { throw 'Caminho de leitura nao reconhecido pela sonda.' }
  $read = { param($tick,$base) [int][uint32]$tick }
}
$cases = @(
  @{Name='uptime acima de Integer';Tick=2834258109;Base=2834258000;Want=110},
  @{Name='cruza limite assinado';Tick=2147483648;Base=2147483640;Want=9},
  @{Name='virada do contador';Tick=5;Base=4294967290;Want=12},
  @{Name='inicio no mesmo tick';Tick=123;Base=123;Want=1},
  @{Name='fim no tick zero';Tick=0;Base=4294967290;Want=7},
  @{Name='limite de armazenamento';Tick=2147483646;Base=0;Want=2147483647}
)
foreach ($case in $cases) {
  $actual = & $read $case.Tick $case.Base
  if ($actual -ne $case.Want) { throw ($case.Name + ': esperado ' + $case.Want + ', obtido ' + $actual) }
  Write-Output ('PASS ' + $case.Name)
}
$rejected = $false
try { & $read 2147483647 0 | Out-Null } catch { $rejected = $true }
if (-not $rejected) { throw 'Duracao fora do limite deve falhar antes da conversao.' }
Write-Output 'PASS rejeita duracao fora do limite'
