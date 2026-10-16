<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/Assert-LastExitCodeWasZero.ps1
    name: assert-last-exit-code-was-zero
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: automation/Catzc.Base.Asserts/tests/Assert-LastExitCodeWasZero.Tests.ps1
  config:
    synopsis: Asserts that $LASTEXITCODE is 0.
    description: |-
      Checks the global $LASTEXITCODE variable and throws if it is non-zero.
      Resets $LASTEXITCODE after checking unless -DoNotReset is specified.
    parameters:
      DoNotReset: Keep $LASTEXITCODE intact after the assertion.
    examples:
      - |-
        git status
        Assert-LastExitCodeWasZero
      - Assert-LastExitCodeWasZero -DoNotReset
---
#>

function Assert-LastExitCodeWasZero {
    param(
        [switch] $DoNotReset
    )

    $exitVar = Get-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore

    if (-not $exitVar) {
        return
    }

    $code = $exitVar.Value

    if (-not $DoNotReset) {
        Remove-Variable LASTEXITCODE -Scope Global
    }

    if ($code -ne 0) {
        throw "Last exit code was $code (expected 0)"
    }
}
