<#
---
catzc:
  immutable:
    with_body_sha: "6eca2b13ee83"
  edges:
    test: pwsh/Catzc.Tooling.Toolchain/tests/Invoke-Dotnet.Tests.ps1
    docs: "[Invoke-Dotnet.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Invoke-Dotnet.ps1.md)"
---
#>

function Invoke-Dotnet {
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
        Assert-Tool 'dotnet'
    }

    Invoke-Executable "dotnet $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
