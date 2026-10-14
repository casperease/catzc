<#
.SYNOPSIS
    Claude Code PreToolUse hook: denies a foreground Bash call that does not run inside the time safeguard.
.DESCRIPTION
    Every Bash call an agent (the main session or any subagent) makes must either run in the background or pass
    a `timeout` no larger than the safeguard's default — `default_seconds` in
    automation/Catzc.Base.Timeouts/configs/timeouts.yml, the same value Get-TimeoutSeconds resolves. A call that
    omits `timeout`, or asks for more, is denied with a reason that says how to re-issue it; nothing else is
    decided here, so the permission rules in settings.json still apply to every call this hook lets through.

    Reads the hook payload (JSON) from stdin. Kept self-contained — no module import, one regex over the config —
    because it runs before every Bash call.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$payload = [Console]::In.ReadToEnd() | ConvertFrom-Json -AsHashtable
$toolInput = if ($payload -and $payload.ContainsKey('tool_input')) { $payload['tool_input'] } else { @{} }

if ($toolInput.ContainsKey('run_in_background') -and $toolInput['run_in_background'] -eq $true) {
    exit 0
}

$configPath = Join-Path $PSScriptRoot '../../automation/Catzc.Base.Timeouts/configs/timeouts.yml'
$match = [regex]::Match((Get-Content -LiteralPath $configPath -Raw), '(?m)^default_seconds:\s*(\d+)\s*(#.*)?$')
if (-not $match.Success) {
    throw "Bash time safeguard: no 'default_seconds: <n>' line in $configPath"
}
$limitMs = [int]$match.Groups[1].Value * 1000

$timeoutMs = if ($toolInput.ContainsKey('timeout') -and $null -ne $toolInput['timeout']) { [double]$toolInput['timeout'] } else { $null }
if ($null -ne $timeoutMs -and $timeoutMs -le $limitMs) {
    exit 0
}

$asked = if ($null -eq $timeoutMs) { 'no timeout' } else { "timeout $timeoutMs ms" }
$reason = (
    "Bash time safeguard: this foreground call has $asked; every foreground Bash call must pass timeout <= $limitMs ms " +
    "(default_seconds in automation/Catzc.Base.Timeouts/configs/timeouts.yml). Re-issue it with timeout: $limitMs, or " +
    'run longer work with run_in_background: true and wait for its completion notification.'
)
@{
    hookSpecificOutput = @{
        hookEventName            = 'PreToolUse'
        permissionDecision       = 'deny'
        permissionDecisionReason = $reason
    }
} | ConvertTo-Json -Compress -Depth 3
