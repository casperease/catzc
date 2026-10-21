<#
---
catzc:
  immutable:
    with_body_sha: a29a4d9eee18
  edges:
    test: pwsh/Catzc.Tooling.Toolchain/tests/Invoke-Java.Tests.ps1
    docs: "[Invoke-Java.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Invoke-Java.ps1.md)"
---
#>

function Invoke-Java {
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
        Assert-Tool 'java'
    }

    Invoke-Executable "java $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
