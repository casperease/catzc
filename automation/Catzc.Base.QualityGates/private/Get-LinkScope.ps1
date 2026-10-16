<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-LinkScope.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Get-LinkScope.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Get-LinkScope.Tests.ps1
  config:
    synopsis: Lists the repository-relative files the link engine reads.
    description: |-
      With no -Path, every git-tracked file (Get-GitTrackedPath) — the repository as committed, not whatever lies
      untracked in the working folder. With -Path, the given files and the files under the given folders, from the
      filesystem. Either way a file the content tools leave as written (Get-ContentExemptPath: vendored, generated,
      fixture, or contract asset) is never aligned. No list of its own: a new class is declared in the .gitattributes
      source.
    parameters:
      RepositoryRoot: The repository root the returned paths are relative to.
      Path: Optional files or folders (absolute or relative to the current location) to limit the scope to.
    outputs: '[string[]] repository-relative, ''/''-separated paths.'
---
#>

function Get-LinkScope {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $isDiskRoot = {
        param([string] $FullPath)
        $FullPath.TrimEnd('\', '/') -eq ([System.IO.Path]::GetPathRoot($FullPath)).TrimEnd('\', '/')
    }

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    Assert-False (& $isDiskRoot $root) -ErrorText "Get-LinkScope: the repository root '$root' is a disk root — refusing to scan a whole drive."
    $files = if ($Path) {
        foreach ($item in $Path) {
            $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).Path)
            Assert-False (& $isDiskRoot $full) -ErrorText "Get-LinkScope: -Path '$item' resolves to the disk root '$full' — refusing to scan a whole drive."
            $found = if (Test-Path -LiteralPath $full -PathType Container) {
                # A scope as wide as the repository: tracked files reach nine levels below the root, so ten leaves one level of headroom.
                Get-ChildPath $full -File -Depth 10
            }
            else {
                $full
            }
            foreach ($file in $found) {
                [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
            }
        }
    }
    else {
        Get-GitTrackedPath '.'
    }

    $inRepository = @($files | Where-Object { $_ -notmatch '^\.\./' })
    # Get-ContentExemptPath returns its paths as one array: assign it, so the set holds the paths, not the array.
    $exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $inRepository
    $exempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @($exemptPaths))
    @($inRepository | Where-Object { -not $exempt.Contains($_) })
}
