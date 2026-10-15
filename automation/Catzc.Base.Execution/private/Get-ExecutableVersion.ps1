<#
.SYNOPSIS
    Runs one located executable's version command and returns the parsed version — the probe's only process start.
.DESCRIPTION
    Output that misses the pattern yields null, not an error, so the caller decides what no version means.
    [comment:1](/docs/references/automation/catzc-base-execution/private/Get-ExecutableVersion.ps1.md#comment1)
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

    # Own folder, not the repository: a project file such as go.work or global.json would change the reported version.
    # [comment:2](/docs/references/automation/catzc-base-execution/private/Get-ExecutableVersion.ps1.md#comment2)
    $folder = [System.IO.Path]::GetDirectoryName($Path)
    $result = Invoke-Executable "`"$Path`" $Arguments".TrimEnd() -WorkingDirectory $folder -PassThru -NoAssert -Silent

    if ($result.Full -match $Pattern) {
        return $Matches['ver']
    }
    $null
}
