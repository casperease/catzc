<#
---
catzc:
  immutable:
    with_body_sha: e942a2431aef
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1
    docs: "[Get-GitChangedPath.ps1.md](docs/references/pwsh/catzc-base-files/Get-GitChangedPath.ps1.md)"
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
