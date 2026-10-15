<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Reset-LastExitCode.ps1
    kind: function
    module: Catzc.Base.Execution
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Removes the global $LASTEXITCODE variable.
.EXAMPLE
    Reset-LastExitCode
#>
function Reset-LastExitCode {
    param()

    $exitVar = Get-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore
    if ($exitVar) {
        Remove-Variable LASTEXITCODE -Scope Global
    }
}
