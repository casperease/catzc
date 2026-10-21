<#
---
catzc:
  immutable:
    with_body_sha: cd2c12cee01c
  edges:
    docs: "[Invoke-Npm.ps1.md](docs/references/pwsh/catzc-tooling-node/Invoke-Npm.ps1.md)"
---
#>

function Invoke-Npm {
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
        Assert-Tool 'node_js'
    }

    Invoke-Executable "npm $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
