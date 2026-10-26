<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Get-ToolVersion.ps1.md"
  header: "generated"
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
