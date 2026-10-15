<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-ToolVersion.ps1
    kind: automation-function
    module: Catzc.Tooling.Core
    visibility: public
  config:
    synopsis: Runs a tool's version command and extracts the installed version string.
    description: |-
      Executes the version_command from tools.yml, matches against
      version_pattern, and returns the captured version string.
      Returns $null if the command fails or the pattern does not match.
      Uses .Full (stdout + stderr merged) to catch tools like java that
      write version info to stderr.
    parameters:
      Config: The tool configuration hashtable from Get-ToolConfig.
    examples:
      - |-
        $config = Get-ToolConfig -Tool 'python'
        $version = Get-ToolVersion -Config $config
        # Returns '3.11.9' or $null
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
