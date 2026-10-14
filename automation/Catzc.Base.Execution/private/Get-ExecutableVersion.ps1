<#
.SYNOPSIS
    Runs one located executable's version command and returns the parsed version — the probe's only process start.
.DESCRIPTION
    Runs the executable at -Path (never whatever its bare name resolves to on PATH) with -Arguments, once, and
    matches the merged output against -Pattern. Returns the captured named group (?<ver>...), or $null when the
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

    $result = Invoke-Executable "`"$Path`" $Arguments".TrimEnd() -PassThru -NoAssert -Silent

    if ($result.Full -match $Pattern) {
        return $Matches['ver']
    }
    $null
}
