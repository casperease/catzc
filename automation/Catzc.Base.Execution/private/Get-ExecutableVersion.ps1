<#
.SYNOPSIS
    Runs one located executable's version command and returns the parsed version — the probe's only process start.
.DESCRIPTION
    Runs the executable at -Path (never whatever its bare name resolves to on PATH) with -Arguments, once, in the
    executable's own folder, and matches the merged output against -Pattern. Returns the captured named group (?<ver>...), or $null when the
    output does not match. Find-Executable calls it at most once per executable file per session.
.PARAMETER Path
    The located executable's full path.
.PARAMETER Arguments
    The arguments that make the executable print its version (e.g. '--version'). Empty for none.
.PARAMETER Pattern
    The regex that captures the version as the named group (?<ver>...).
.EXAMPLE
    Get-ExecutableVersion -Path 'C:\Program Files\Git\bin\bash.exe' -Arguments '--version' -Pattern 'version (?<ver>[\d.]+)'
#>
function Get-ExecutableVersion {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [AllowEmptyString()]
        [string] $Arguments = '',

        [Parameter(Mandatory)]
        [string] $Pattern
    )

    # Run in the executable's own folder, never the repository: a tool that reads project files from its working
    # directory (go's go.work toolchain line, dotnet's global.json) would otherwise report — or download — the
    # version the project asks for instead of the version the located binary is.
    $folder = [System.IO.Path]::GetDirectoryName($Path)
    $result = Invoke-Executable "`"$Path`" $Arguments".TrimEnd() -WorkingDirectory $folder -PassThru -NoAssert -Silent

    if ($result.Full -match $Pattern) {
        return $Matches['ver']
    }
    $null
}
