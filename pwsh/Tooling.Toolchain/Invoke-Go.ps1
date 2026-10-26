<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Invoke-Go.ps1.md"
  header: "generated"
---
#>

function Invoke-Go {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    if ($DryRun) {
        return Invoke-Executable "go $Arguments" -DryRun
    }

    Assert-Tool 'go'
    $executable = (Test-Tool 'go' -PassThru).Path
    Invoke-Executable "`"$executable`" $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent
}
