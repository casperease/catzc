<#
.SYNOPSIS
    Rebuilds a repository's history as a fresh, backdated, single-author orphan
    history committed from the current (already-clean) working tree.
.DESCRIPTION
    The cleanest way to erase a token from history: don't scrub the old commits,
    replace them. Because every synthetic commit is authored from the current
    tree — which no longer contains the token — the token appears in no blob, no
    path, and no message, so there is nothing to scrub and no residual objects.

    The caller supplies the layers (what files each commit contains); this owns
    the mechanics — evenly backdated timestamps across a span, an orphan branch
    built commit by commit, then swapping it in as the default branch and pruning
    the old objects locally. It is destructive to local history: take a
    `git bundle create --all` backup first (Assert-GitHubPurgeReady enforces one
    before any remote purge). Local only — nothing is pushed.
.PARAMETER Layer
    Ordered commit specs, foundational first. Each is a hashtable:
      @{ Message = 'Add core'; Include = @('src/core'); Exclude = @(':(exclude)src/core/tests') }
    Include entries are paths (or '.') added with `git add -A`; Exclude entries
    are git pathspecs. A layer that stages no change is skipped.
.PARAMETER RepositoryPath
    The repository to rebuild. Defaults to the repository root.
.PARAMETER AuthorName
    Author (and committer) name stamped on every synthetic commit.
.PARAMETER AuthorEmail
    Author (and committer) email stamped on every synthetic commit.
.PARAMETER SpanStart
    Start of the backdating window. Defaults to 90 days before SpanEnd.
.PARAMETER SpanEnd
    End of the backdating window. Defaults to the current date.
.PARAMETER Branch
    The branch the synthetic history becomes. Defaults to main.
.PARAMETER WorkingBranch
    The temporary orphan branch name used while building. Defaults to
    'synthetic-build'.
.PARAMETER DryRun
    Return the plan (layer and timestamp count) without touching git.
.EXAMPLE
    New-SyntheticHistory -Layer $layers -AuthorName 'A Dev' -AuthorEmail 'a@dev.test'
#>
function New-SyntheticHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [hashtable[]] $Layer,

        [string] $RepositoryPath = (Get-RepositoryRoot),

        [Parameter(Mandatory)]
        [string] $AuthorName,

        [Parameter(Mandatory)]
        [string] $AuthorEmail,

        [datetime] $SpanStart,

        [datetime] $SpanEnd,

        [string] $Branch = 'main',

        [string] $WorkingBranch = 'synthetic-build',

        [switch] $DryRun
    )

    Assert-Command git
    Assert-PathExist $RepositoryPath -PathType Container

    if (-not $SpanEnd) {
        $SpanEnd = Get-Date
    }
    if (-not $SpanStart) {
        $SpanStart = $SpanEnd.AddDays(-90)
    }
    if ($SpanEnd -lt $SpanStart) {
        throw "SpanEnd ($SpanEnd) is before SpanStart ($SpanStart)."
    }

    # Evenly spread each layer's commit date across the window.
    $count = $Layer.Count
    $spanSeconds = ($SpanEnd - $SpanStart).TotalSeconds
    $culture = [System.Globalization.CultureInfo]::InvariantCulture
    $timestamps = for ($i = 0; $i -lt $count; $i++) {
        $fraction = if ($count -le 1) {
            0
        }
        else {
            $i / ($count - 1)
        }
        $SpanStart.AddSeconds($spanSeconds * $fraction).ToString('yyyy-MM-ddTHH:mm:ss', $culture)
    }

    if ($DryRun) {
        return [pscustomobject]@{
            DryRun     = $true
            LayerCount = $count
            SpanStart  = $SpanStart
            SpanEnd    = $SpanEnd
            Branch     = $Branch
        }
    }

    $originProbe = Invoke-Executable 'git config --get remote.origin.url' -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
    $originUrl = @($originProbe.Output -split '\r?\n' | Where-Object { $_ })[0]

    # Fresh orphan branch with an empty index; the working tree is kept intact.
    $orphan = Invoke-Executable "git checkout --orphan $WorkingBranch" -WorkingDirectory $RepositoryPath -PassThru -NoAssert
    if ($orphan.ExitCode -ne 0) {
        throw "Orphan checkout failed: $($orphan.Errors)"
    }
    $empty = Invoke-Executable 'git read-tree --empty' -WorkingDirectory $RepositoryPath -PassThru -NoAssert
    if ($empty.ExitCode -ne 0) {
        throw "Failed to empty the index: $($empty.Errors)"
    }

    $committed = 0
    $env:GIT_AUTHOR_NAME = $AuthorName
    $env:GIT_AUTHOR_EMAIL = $AuthorEmail
    $env:GIT_COMMITTER_NAME = $AuthorName
    $env:GIT_COMMITTER_EMAIL = $AuthorEmail
    try {
        for ($i = 0; $i -lt $count; $i++) {
            $spec = $Layer[$i]
            $present = @($spec.Include | Where-Object { $_ -eq '.' -or (Test-Path -LiteralPath (Join-Path $RepositoryPath $_)) })
            if ($present.Count -eq 0) {
                continue
            }

            $targets = @(@($present) + @($spec.Exclude) | ForEach-Object { "`"$_`"" }) -join ' '
            Invoke-Executable "git add -A -- $targets" -WorkingDirectory $RepositoryPath -Silent | Out-Null

            $staged = Invoke-Executable 'git diff --cached --quiet' -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
            if ($staged.ExitCode -eq 0) {
                continue
            }   # nothing staged — skip this layer

            $env:GIT_AUTHOR_DATE = $timestamps[$i]
            $env:GIT_COMMITTER_DATE = $timestamps[$i]
            $commit = Invoke-Executable "git commit -q -m `"$($spec.Message)`"" -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
            if ($commit.ExitCode -ne 0) {
                throw "Commit failed for layer '$($spec.Message)': $($commit.Errors)"
            }
            $committed++
        }
    }
    finally {
        Remove-Item Env:GIT_AUTHOR_DATE, Env:GIT_COMMITTER_DATE, Env:GIT_AUTHOR_NAME, Env:GIT_AUTHOR_EMAIL, Env:GIT_COMMITTER_NAME, Env:GIT_COMMITTER_EMAIL -ErrorAction SilentlyContinue
    }

    if ($committed -eq 0) {
        throw 'No layer staged any change — nothing was committed.'
    }

    # Make the synthetic branch the default and prune the old history locally.
    Invoke-Executable "git branch -M $Branch" -WorkingDirectory $RepositoryPath -Silent | Out-Null
    foreach ($ref in @(Invoke-Executable 'git for-each-ref --format=%(refname) refs/original refs/stash' -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent).Output -split '\r?\n' | Where-Object { $_ }) {
        Invoke-Executable "git update-ref -d $ref" -WorkingDirectory $RepositoryPath -NoAssert -Silent | Out-Null
    }
    Invoke-Executable 'git reflog expire --expire=now --all' -WorkingDirectory $RepositoryPath -NoAssert -Silent | Out-Null
    Invoke-Executable 'git gc --prune=now' -WorkingDirectory $RepositoryPath -NoAssert -Silent | Out-Null
    if ($originUrl) {
        Invoke-Executable "git remote set-url origin $originUrl" -WorkingDirectory $RepositoryPath -NoAssert -Silent | Out-Null
    }

    Write-Message "Built synthetic history: $committed commit(s) on '$Branch', authored by $AuthorName."
    [pscustomobject]@{
        DryRun      = $false
        CommitCount = $committed
        Branch      = $Branch
        SpanStart   = $SpanStart
        SpanEnd     = $SpanEnd
    }
}
