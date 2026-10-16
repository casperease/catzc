<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-ScopeLookup.ps1
    folder: private
    name: get-scope-lookup
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  config:
    synopsis: Turns the optional files or folders of a scope into the repository-relative paths git is asked about.
    description: No path means the whole repository; a path outside the repository root is refused.
    parameters:
      RepositoryRoot: The repository root the returned paths are relative to.
      Path: Optional files or folders (absolute or relative to the current location).
      Command: The name of the calling command, for the refusal message.
    outputs: '[string[]] repository-relative, ''/''-separated paths, or ''.'' for the whole repository.'
---
#>

function Get-ScopeLookup {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $Command
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if (-not $Path) {
        return , [string[]] @('.')
    }
    $lookup = foreach ($item in $Path) {
        $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).Path)
        $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
        Assert-False ($relative -eq '..' -or $relative.StartsWith('../')) -ErrorText "${Command}: -Path '$item' lies outside the repository '$root'."
        $relative
    }
    , [string[]] @($lookup)
}
