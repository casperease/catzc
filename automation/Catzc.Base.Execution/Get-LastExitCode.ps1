<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Get-LastExitCode.ps1
    kind: public-function
    module: Catzc.Base.Execution
    visibility: public
  config:
    synopsis: Returns the current $LASTEXITCODE value, or warns if none exists.
    examples:
      - |-
        Get-LastExitCode
        # Returns the exit code from the last native command
---
#>

function Get-LastExitCode {
    param()

    $exitVar = Get-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore

    if (-not $exitVar) {
        Write-Verbose 'No LASTEXITCODE exists'
        return
    }

    $exitVar.Value
}
