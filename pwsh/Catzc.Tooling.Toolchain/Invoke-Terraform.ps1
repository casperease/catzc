<#
---
catzc:
  immutable:
    with_body_sha: b17fc9f4baca
  edges:
    test: pwsh/Catzc.Tooling.Toolchain/tests/Invoke-Terraform.Tests.ps1
    docs: "[Invoke-Terraform.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Invoke-Terraform.ps1.md)"
---
#>

function Invoke-Terraform {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    if (-not $DryRun) {
        Assert-Tool 'terraform'
    }

    Invoke-Executable "terraform $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
