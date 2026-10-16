<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Get-LastExitCode.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Execution
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Execution/tests/Get-LastExitCode.Tests.ps1
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
