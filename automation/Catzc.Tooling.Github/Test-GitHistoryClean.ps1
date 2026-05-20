<#
.SYNOPSIS
    Tests whether a token is absent from a git history across all three surfaces
    it can hide in: file content (blobs), file paths, and commit messages.
.DESCRIPTION
    The reusable verification primitive behind every purge: to prove a secret is
    gone, it is not enough to scan the working tree — the token can survive in an
    old blob, a renamed path, or a commit message. This scans the whole history
    reachable from a ref for all three and returns a structured result.

    Scan the local ref (default HEAD) before pushing, and again on a fresh
    `git clone --mirror` of the remote to prove what actually landed. Never scan
    a ref whose upstream tracking still points at un-purged history (e.g. an
    un-updated origin/*) — a stale tracking ref false-alarms.

    Read-only: it never mutates the repository.
.PARAMETER Token
    The token to hunt for (e.g. a secret, or a project name being erased).
    Matched case-insensitively as a literal substring across every surface.
.PARAMETER Ref
    The ref whose reachable history is scanned. Defaults to HEAD. Pass a branch
    name, a SHA, or --all to sweep every ref (only meaningful on a mirror clone,
    where no stale tracking ref exists to false-alarm).
.PARAMETER RepositoryPath
    The git repository to scan. Defaults to the current repository root.
.PARAMETER ExcludePath
    Repo-relative path prefixes to ignore on every surface — vendored,
    third-party trees that legitimately contain the token. Defaults to the
    vendor directory.
.OUTPUTS
    A Catzc.Tooling.Github result object with:
      .Clean    — $true when no surface contains the token
      .Token    — the token scanned for
      .Ref      — the ref scanned
      .Blobs    — content hits (`<rev>:<path>:<line>`)
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

    # git grep pathspecs that drop the excluded trees from the blob scan.
    $excludeSpec = @($ExcludePath | ForEach-Object { ":!$_" }) -join ' '

    # Every revision reachable from the ref — the whole history we must prove clean.
    $revList = Invoke-Executable "git rev-list $Ref" -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
    if ($revList.ExitCode -ne 0) {
        throw "Cannot enumerate revisions for ref '$Ref' in '$RepositoryPath': $($revList.Errors)"
    }
    $revs = @($revList.Output -split '\r?\n' | Where-Object { $_ })

    # --- Blobs: the token in file content at any revision. git grep takes the revs
    # as arguments; batch them so a long history never overflows the command line.
    # git grep exit codes: 0 = match, 1 = no match, >1 = real error.
    $blobHits = [System.Collections.Generic.List[string]]::new()
    for ($start = 0; $start -lt $revs.Count; $start += 200) {
        $batch = $revs[$start..([Math]::Min($start + 199, $revs.Count - 1))]
        $grep = Invoke-Executable "git grep -I -i -F -e `"$Token`" $($batch -join ' ') -- $excludeSpec" `
            -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
        if ($grep.ExitCode -gt 1) {
            throw "git grep failed in '$RepositoryPath': $($grep.Errors)"
        }
        if ($grep.ExitCode -eq 0) {
            $grep.Output -split '\r?\n' | Where-Object { $_ } | ForEach-Object { $blobHits.Add($_) }
        }
    }

    # --- Paths: the token in any path ever touched in this history.
    $pathLog = Invoke-Executable "git log $Ref --pretty=format: --name-only" `
        -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
    if ($pathLog.ExitCode -ne 0) {
        throw "git log (paths) failed in '$RepositoryPath': $($pathLog.Errors)"
    }
    $pathHits = @($pathLog.Output -split '\r?\n' |
            Where-Object { $_ -and ($_ -match [regex]::Escape($Token)) } |
            Where-Object { $path = $_; -not ($ExcludePath | Where-Object { $path -like "$_*" }) } |
            Select-Object -Unique)

    # --- Messages: the token in any commit message.
    $messageLog = Invoke-Executable "git log $Ref --format=%B" `
        -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
    if ($messageLog.ExitCode -ne 0) {
        throw "git log (messages) failed in '$RepositoryPath': $($messageLog.Errors)"
    }
    $messageHits = @($messageLog.Output -split '\r?\n' |
            Where-Object { $_ -and ($_ -match [regex]::Escape($Token)) })

    [pscustomobject]@{
        Clean    = -not ($blobHits.Count -or $pathHits.Count -or $messageHits.Count)
        Token    = $Token
        Ref      = $Ref
        Blobs    = @($blobHits)
        Paths    = $pathHits
        Messages = $messageHits
    }
}
