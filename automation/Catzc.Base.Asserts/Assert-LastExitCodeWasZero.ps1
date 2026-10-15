<#
.SYNOPSIS
    Asserts that $LASTEXITCODE is 0.
.DESCRIPTION
    Checks the global $LASTEXITCODE variable and throws if it is non-zero.
    [comment:1](/docs/references/automation/catzc-base-asserts/Assert-LastExitCodeWasZero.ps1.md#comment1)
.PARAMETER DoNotReset
    Keep $LASTEXITCODE intact after the assertion.
.EXAMPLE
    git status
    Assert-LastExitCodeWasZero
.EXAMPLE
    Assert-LastExitCodeWasZero -DoNotReset
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
