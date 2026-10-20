<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Python/Invoke-Python.ps1
    name: invoke-python
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Python
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Python/tests/Invoke-Python.Tests.ps1
    docs: "[Invoke-Python.ps1.md](docs/references/pwsh/catzc-tooling-python/Invoke-Python.ps1.md)"
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
