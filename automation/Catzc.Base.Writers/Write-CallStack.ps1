<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/Write-CallStack.ps1
    kind: automation-function
    module: Catzc.Base.Writers
    visibility: public
    relatives:
      test: automation/Catzc.Base.Writers/tests/Write-CallStack.Tests.ps1
  config:
    synopsis: Writes the current call stack in red for debugging.
    examples:
      - Write-CallStack
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
