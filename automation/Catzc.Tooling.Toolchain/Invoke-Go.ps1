<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Toolchain/Invoke-Go.ps1
    name: invoke-go
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Tooling.Toolchain/tests/Invoke-Go.Tests.ps1
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
