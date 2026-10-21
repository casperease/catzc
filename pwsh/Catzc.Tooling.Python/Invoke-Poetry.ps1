<#
---
catzc:
  immutable:
    with_body_sha: c353b212ff59
  edges:
    test: pwsh/Catzc.Tooling.Python/tests/Invoke-Poetry.Tests.ps1
    docs: "[Invoke-Poetry.ps1.md](docs/references/pwsh/catzc-tooling-python/Invoke-Poetry.ps1.md)"
---
#>

function Invoke-Poetry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Arguments -ErrorText 'Arguments cannot be empty'

    if (-not $DryRun) {
        Assert-Tool 'poetry'
    }

    Invoke-Executable "poetry $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
