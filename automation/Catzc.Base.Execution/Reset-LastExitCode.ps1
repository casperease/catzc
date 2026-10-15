# catzc:
#   path: automation/Catzc.Base.Execution/Reset-LastExitCode.ps1
#   module: Catzc.Base.Execution
#   visibility: public

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
