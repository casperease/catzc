<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/Get-ToolVersion.ps1
    name: get-tool-version
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Get-ToolVersion.ps1.md](docs/references/pwsh/catzc-tooling-core/Get-ToolVersion.ps1.md)"
---
#>

function Get-ToolVersion {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    $result = Invoke-Executable $Config.version_command -PassThru -NoAssert -Silent

    $found = $null
    if ($result.Full -match $Config.version_pattern) {
        $found = $Matches['ver']
    }

    return $found
}
