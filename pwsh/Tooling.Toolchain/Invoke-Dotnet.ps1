<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Invoke-Dotnet.ps1.md"
  header: "generated"
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
