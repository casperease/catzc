<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-writers/Write-CallStack.ps1.md"
  header: "generated"
---
#>

function Write-CallStack {
    [CmdletBinding()]
    param()

    $callStack = Get-PSCallStack

    if ($callStack.Count -eq 0) {
        Write-Message 'Unknown caller' -ForegroundColor Red -NoHeader
        return
    }

    $output = $callStack | ForEach-Object {
        '{0}:{1}' -f $_.ScriptName, $_.ScriptLineNumber
    }

    Write-Message ($output -join "`n") -ForegroundColor Red -NoHeader
}
