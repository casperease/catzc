<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Reset-LastExitCode.ps1
    kind: automation-function
    module: Catzc.Base.Execution
    visibility: public
  config:
    synopsis: Removes the global $LASTEXITCODE variable.
    examples:
      - Reset-LastExitCode
---
#>

function Reset-LastExitCode {
    param()

    $exitVar = Get-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore
    if ($exitVar) {
        Remove-Variable LASTEXITCODE -Scope Global
    }
}
