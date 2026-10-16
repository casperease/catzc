<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Files/Get-GitChangedPath.ps1
    name: get-git-changed-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1
  config:
    synopsis: 'Returns the repository paths that differ from HEAD: what the working tree has changed.'
    description: |-
      The working-tree counterpart of Get-GitTrackedPath: every path at or under the given paths that git status
      reports — staged or unstaged, modified, added, deleted, and untracked files that no .gitignore rule ignores — as a
      repo-relative, '/'-separated path, sorted ordinally, each once. A rename counts as both of its paths (--no-renames),
      like a committed range's changed files: a file moving into or out of a scope changes both. A deleted path is
      listed too; a caller that reads files skips what no longer exists.

      One read-only `git status --porcelain=v1 -z --untracked-files=all --no-renames` from the repository root (never
      $PWD); -z keeps every path literal (no quoting, any character). Runs through Invoke-Executable -Silent, so a git
      failure throws.
    parameters:
      Path: The repository-relative, '/'-separated paths (files or folders) to look under; '.' (the default) for all.
    outputs: '[string]'
    examples:
      - Get-GitChangedPath
      - Get-GitChangedPath 'automation/Catzc.Base.Files', 'docs'
---
#>

function Get-GitChangedPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Path = @('.')
    )

    $quotedPaths = foreach ($item in $Path) {
        "`"$item`""
    }
    $status = Invoke-Executable "git status --porcelain=v1 -z --untracked-files=all --no-renames -- $($quotedPaths -join ' ')" `
        -WorkingDirectory (Get-RepositoryRoot) -PassThru -Silent
    # Each -z entry is 'XY <path>' (two status letters, a space, the path), NUL-terminated.
    $changed = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($entry in ("$($status.Output)" -split "`0")) {
        if ($entry.Length -gt 3) {
            [void]$changed.Add($entry.Substring(3))
        }
    }
    $changed
}
