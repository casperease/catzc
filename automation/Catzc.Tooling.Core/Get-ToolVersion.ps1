<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-ToolVersion.ps1
    kind: public-function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Runs a tool's version command and extracts the installed version string.
.DESCRIPTION
    Reads stdout and stderr merged, since some tools such as java print their version to stderr; a miss returns null.
.PARAMETER Config
    The tool configuration hashtable from Get-ToolConfig.
.EXAMPLE
    $config = Get-ToolConfig -Tool 'python'
    $version = Get-ToolVersion -Config $config
    # Returns '3.11.9' or $null
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
