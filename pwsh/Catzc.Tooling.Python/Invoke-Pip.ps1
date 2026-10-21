<#
---
catzc:
  immutable:
    with_body_sha: "3f419eb4568e"
  edges:
    test: pwsh/Catzc.Tooling.Python/tests/Invoke-Pip.Tests.ps1
    docs: "[Invoke-Pip.ps1.md](docs/references/pwsh/catzc-tooling-python/Invoke-Pip.ps1.md)"
---
#>

function Invoke-Pip {
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

    Invoke-Uv "pip $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
