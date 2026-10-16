<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/private/Get-ExecutableVersion.ps1
    folder: private
    name: get-executable-version
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-execution/private/Get-ExecutableVersion.ps1.md
      test: automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1
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

    $folder = [System.IO.Path]::GetDirectoryName($Path)
    $result = Invoke-Executable "`"$Path`" $Arguments".TrimEnd() -WorkingDirectory $folder -PassThru -NoAssert -Silent

    if ($result.Full -match $Pattern) {
        return $Matches['ver']
    }
    $null
}
