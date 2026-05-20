<#
.SYNOPSIS
    Runs a tool's version command and extracts the installed version string.
.DESCRIPTION
    Executes the version_command from tools.yml, matches against
    version_pattern, and returns the captured version string.
    Returns $null if the command fails or the pattern does not match.
    Uses .Full (stdout + stderr merged) to catch tools like java that
    write version info to stderr.
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
        [Parameter(Mandatory)]
        $Config
    )

    $result = Invoke-Executable $Config.version_command -PassThru -NoAssert -Silent

    $found = $null
    if ($result.Full -match $Config.version_pattern) {
        $found = $Matches['ver']
    }

    return $found
}
