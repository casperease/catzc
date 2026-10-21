<#
---
catzc:
  immutable:
    with_body_sha: "39462ea5acf4"
  edges:
    test: pwsh/Catzc.Base.Writers/tests/Write-CallStack.Tests.ps1
    docs: "[Write-CallStack.ps1.md](docs/references/pwsh/catzc-base-writers/Write-CallStack.ps1.md)"
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
