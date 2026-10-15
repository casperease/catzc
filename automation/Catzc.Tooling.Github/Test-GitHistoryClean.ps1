<#
.SYNOPSIS
    Tests whether a token is absent from a git history across all three surfaces
    it can hide in: file content (blobs), file paths, and commit messages.
.DESCRIPTION
    The reusable verification primitive behind every purge: to prove a secret is gone, it is not enough to scan the...
    [comment:1](/docs/references/automation/catzc-tooling-github/Test-GitHistoryClean.ps1.md#comment1)
.PARAMETER Token
    The token to hunt for (e.g.
    [comment:2](/docs/references/automation/catzc-tooling-github/Test-GitHistoryClean.ps1.md#comment2)
.PARAMETER Ref
    The ref whose reachable history is scanned.
    [comment:3](/docs/references/automation/catzc-tooling-github/Test-GitHistoryClean.ps1.md#comment3)
.PARAMETER RepositoryPath
    The git repository to scan. Defaults to the current repository root.
.PARAMETER ExcludePath
    Repo-relative path prefixes to ignore on every surface — vendored, third-party trees that legitimately contain...
    [comment:4](/docs/references/automation/catzc-tooling-github/Test-GitHistoryClean.ps1.md#comment4)
.OUTPUTS
    A Catzc.Tooling.Github result object with:
      .Clean    — $true when no surface contains the token
      .Token    — the token scanned for
      .Ref      — the ref scanned
      .Blobs    — content hits (`<blob>:<path>:<line>`, one per matching line of each distinct file content)
      .Paths    — path hits (distinct repo-relative paths)
      .Messages — commit-message lines containing the token
.EXAMPLE
    (Test-GitHistoryClean -Token 'old-name').Clean
.EXAMPLE
    $result = Test-GitHistoryClean -Token 'secret' -Ref '--all' -RepositoryPath $mirror
    if (-not $result.Clean) { $result.Blobs }
#>
function Test-GitHistoryClean {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Token,

        [string] $Ref = 'HEAD',

        [string] $RepositoryPath = (Get-RepositoryRoot),

        [string[]] $ExcludePath = @('automation/.vendor')
    )

    Assert-PathExist $RepositoryPath -PathType Container

    # The objects the scan starts from: the ref's commit, or every ref's object for --all.
    $roots = Invoke-Executable "git rev-parse $Ref" -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
    if ($roots.ExitCode -ne 0) {
        throw "Cannot resolve ref '$Ref' in '$RepositoryPath': $($roots.Errors)"
    }

    # Every object once, in pack order; the scan walks only what the roots reach.
    $objects = Invoke-Executable 'git cat-file --batch-all-objects --batch --unordered' -WorkingDirectory $RepositoryPath -AsBytes -NoAssert -Silent
    if ($objects.ExitCode -ne 0) {
        throw "Cannot read the objects of '$RepositoryPath': $($objects.Errors)"
    }

    # git ends its lines with LF on every platform; one root per line.
    $rootIds = [string[]] @($roots.Output -split '\r?\n' | Where-Object { $_ })
    $scan = [Catzc.Base.Git.GitHistoryScan]::Scan($objects.Bytes, $rootIds, $Token, $ExcludePath)
    [pscustomobject]@{
        Clean    = $scan.Clean
        Token    = $Token
        Ref      = $Ref
        Blobs    = @($scan.Blobs)
        Paths    = @($scan.Paths)
        Messages = @($scan.Messages)
    }
}
