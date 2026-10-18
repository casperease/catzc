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
