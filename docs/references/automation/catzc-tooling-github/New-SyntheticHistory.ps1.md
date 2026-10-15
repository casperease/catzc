# docs/references/automation/catzc-tooling-github/New-SyntheticHistory.ps1.md

`automation/Catzc.Tooling.Github/New-SyntheticHistory.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
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

Pruning the old objects repacks the whole repository, which takes longer
than an ordinary call, so the function declares its own time limit
([TimeLimit]; tune it under `commands` in timeouts.yml) and bounds the
garbage collection with it.
```

## comment:2

Section `.PARAMETER Layer` of the comment-based help.

```text
Ordered commit specs, foundational first. Each is a hashtable:
  @{ Message = 'Add core'; Include = @('src/core'); Exclude = @(':(exclude)src/core/tests') }
Include entries are paths (or '.') added with `git add -A`; Exclude entries
are git pathspecs. A layer that stages no change is skipped.
```

## comment:3

Section `.PARAMETER WorkingBranch` of the comment-based help.

```text
The temporary orphan branch name used while building. Defaults to
'synthetic-build'.
```
