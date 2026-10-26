# pwsh/Tooling.Github/New-SyntheticHistory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Rebuilds a repository's history as a fresh, backdated, single-author orphan history committed from the current (already-clean) working tree.

### description

The cleanest way to erase a token from history: don't scrub the old commits, replace them. Because every synthetic commit is authored from
the current tree — which no longer contains the token — the token appears in no blob, no path, and no message, so there is nothing to scrub
and no residual objects.

The caller supplies the layers (what files each commit contains); this owns the mechanics — evenly backdated timestamps across a span, an
orphan branch built commit by commit, then swapping it in as the default branch and pruning the old objects locally. It is destructive to
local history: take a `git bundle create --all` backup first (Assert-GitHubPurgeReady enforces one before any remote purge). Local only —
nothing is pushed.

Pruning the old objects repacks the whole repository, which takes longer than an ordinary call, so the function declares its own time limit
(`[TimeLimit]`; tune it under `commands` in timeouts.yml) and bounds the garbage collection with it.

### parameter `Layer`

Ordered commit specs, foundational first. Each is a hashtable:

```text
@{ Message = 'Add core'; Include = @('src/core'); Exclude = @(':(exclude)src/core/tests') }
```

Include entries are paths (or '.') added with `git add -A`; Exclude entries are git pathspecs. A layer that stages no change is skipped.

### parameter `RepositoryPath`

The repository to rebuild. Defaults to the repository root.

### parameter `AuthorName`

Author (and committer) name stamped on every synthetic commit.

### parameter `AuthorEmail`

Author (and committer) email stamped on every synthetic commit.

### parameter `SpanEnd`

End of the backdating window. Defaults to the current date. Declared before -SpanStart, so the start's default can count back from it.

### parameter `SpanStart`

Start of the backdating window. Defaults to 90 days before SpanEnd.

### parameter `Branch`

The branch the synthetic history becomes. Defaults to main.

### parameter `WorkingBranch`

The temporary orphan branch name used while building. Defaults to 'synthetic-build'.

### parameter `DryRun`

Return the plan (layer and timestamp count) without touching git.

### example 1

```powershell
New-SyntheticHistory -Layer $layers -AuthorName 'A Dev' -AuthorEmail 'a@dev.test'
```
