<#
---
catzc:
  immutable:
    with_body_sha: "71d76a94855d"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-LastExitCodeWasZero.Tests.ps1
    docs: "[Assert-LastExitCodeWasZero.ps1.md](../../docs/references/pwsh/catzc-base-asserts/Assert-LastExitCodeWasZero.ps1.md)"
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
