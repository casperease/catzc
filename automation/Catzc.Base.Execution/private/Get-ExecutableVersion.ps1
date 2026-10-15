<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/private/Get-ExecutableVersion.ps1
    kind: private-function
    module: Catzc.Base.Execution
    visibility: private
  config:
    synopsis: Runs one located executable's version command and returns the parsed version — the probe's only process start.
    description: |-
      Runs the executable at -Path (never whatever its bare name resolves to on PATH) with -Arguments, once, in the
      executable's own folder, and matches the merged output against -Pattern. Returns the captured named group (?<ver>...), or $null when the
      output does not match. Find-Executable calls it at most once per executable file per session.
    parameters:
      Path: The located executable's full path.
      Arguments: The arguments that make the executable print its version (e.g. '--version'). Empty for none.
      Pattern: The regex that captures the version as the named group (?<ver>...).
    examples:
      - Get-ExecutableVersion -Path 'C:\Program Files\Git\bin\bash.exe' -Arguments '--version' -Pattern 'version (?<ver>[\d.]+)'
---
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

    # Run in the executable's own folder, never the repository: a tool that reads project files from its working...
    # [comment:3](/docs/references/automation/catzc-base-execution/private/Get-ExecutableVersion.ps1.md#comment3)
    $folder = [System.IO.Path]::GetDirectoryName($Path)
    $result = Invoke-Executable "`"$Path`" $Arguments".TrimEnd() -WorkingDirectory $folder -PassThru -NoAssert -Silent

    if ($result.Full -match $Pattern) {
        return $Matches['ver']
    }
    $null
}
