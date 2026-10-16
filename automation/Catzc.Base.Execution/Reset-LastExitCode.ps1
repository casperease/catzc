<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Reset-LastExitCode.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Execution
    visibility: public
    relatives:
      test: automation/Catzc.Base.Execution/tests/Reset-LastExitCode.Tests.ps1
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
