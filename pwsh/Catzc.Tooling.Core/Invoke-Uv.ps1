<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Invoke-Uv.ps1.md"
  header: "generated"
---
#>

function Invoke-Uv {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $Prerelease,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Arguments -ErrorText 'Arguments cannot be empty'

    if (-not $DryRun) {
        Assert-Tool 'uv'
    }

    if ($Prerelease) {
        Write-Message "uv: allowing pre-release/dev package versions (--prerelease=allow) for: uv $Arguments"
        $Arguments = "$Arguments --prerelease=allow"
    }

    Invoke-Executable "uv $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
