<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Github/Test-GitHistoryClean.ps1
    kind: function
    subkind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Github
    visibility: public
    relatives:
      test: automation/Catzc.Tooling.Github/tests/Test-GitHistoryClean.Tests.ps1
  config:
    synopsis: |-
      Tests whether a token is absent from a git history across all three surfaces
      it can hide in: file content (blobs), file paths, and commit messages.
    description: |-
      The reusable verification primitive behind every purge: to prove a secret is
      gone, it is not enough to scan the working tree — the token can survive in an
      old blob, a renamed path, or a commit message. This scans the whole history
      reachable from a ref for all three and returns a structured result.

      The scan is one pass (Catzc.Base.Git.GitHistoryScan): git streams its objects
      once (`git cat-file --batch-all-objects --batch`), and every commit message,
      every path and every distinct file content the ref reaches is read exactly
      once — never once per revision that contains it.

      Scan the local ref (default HEAD) that is pushed; the purge functions then
      prove from the remote's advertised refs that it holds that same commit,
      so the scan covers what actually landed. Never scan
      a ref whose upstream tracking still points at un-purged history (e.g. an
      un-updated origin/*) — a stale tracking ref false-alarms.

      Read-only: it never mutates the repository.
    parameters:
      Token: |-
        The token to hunt for (e.g. a secret, or a project name being erased).
        Matched as a literal substring, ignoring ASCII case, across every surface.
        A binary file (a NUL byte in its first 8000 bytes) is skipped, as
        `git grep -I` skips it.
      Ref: |-
        The ref whose reachable history is scanned. Defaults to HEAD. Pass a branch
        name, a SHA, or --all to sweep every ref (only meaningful in a clone with no
        stale tracking ref to false-alarm).
      RepositoryPath: The git repository to scan. Defaults to the current repository root.
      ExcludePath: |-
        Repo-relative path prefixes to ignore on every surface — vendored,
        third-party trees that legitimately contain the token. Defaults to the
        vendor directory. A file content is ignored only when every path it
        appears under is excluded.
    outputs: |-
      A Catzc.Tooling.Github result object with:
        .Clean    — $true when no surface contains the token
        .Token    — the token scanned for
        .Ref      — the ref scanned
        .Blobs    — content hits (`<blob>:<path>:<line>`, one per matching line of each distinct file content)
        .Paths    — path hits (distinct repo-relative paths)
        .Messages — commit-message lines containing the token
    examples:
      - (Test-GitHistoryClean -Token 'old-name').Clean
      - |-
        $result = Test-GitHistoryClean -Token 'secret' -Ref '--all' -RepositoryPath $mirror
        if (-not $result.Clean) { $result.Blobs }
---
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
