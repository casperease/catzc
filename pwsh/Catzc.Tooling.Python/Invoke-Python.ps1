<#
---
catzc:
  immutable:
    with_body_sha: "6e42f6d734ae"
  edges:
    test: pwsh/Catzc.Tooling.Python/tests/Invoke-Python.Tests.ps1
    docs: "[Invoke-Python.ps1.md](../../docs/references/pwsh/catzc-tooling-python/Invoke-Python.ps1.md)"
---
#>

function Invoke-Python {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Arguments -ErrorText 'Arguments cannot be empty — Python would enter interactive mode'

    if (-not $DryRun) {
        Assert-Tool 'python'
    }

    Invoke-Executable "python $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
