# pwsh/Base.Git/Sync-Topic.ps1

The middle step of the git topic flow: it rebases the topic branch onto the sync point, at the user's hand.

## help

### synopsis

Rebases the topic branch onto the sync point, at the user's hand.

### description

The sync step of the git topic flow: it fetches, takes the sync point from Get-SyncPoint (the BVT-verified server head, else the current
server HEAD, announced), and rebases the topic onto it, never merging main into it
([FDR-GIT-SYNCBYREBASE](../../../drs/flow/git-topic-flow.md#rule-fdr-git-syncbyrebase)). It runs git that changes the repository, so only
the user invokes it ([FDR-GIT-USERRUNSGIT](../../../drs/flow/git-topic-flow.md#rule-fdr-git-userrunsgit)). It refuses a dirty tree
(Save-Topic first), a detached HEAD and a main branch. A conflict stops it with the conflicting files and the git commands that continue or
abort the rebase; it never resolves, skips or aborts on its own.

### parameter `Config`

The git flow config. Default: Get-Config -Config git.

### parameter `RepositoryRoot`

The clone to sync. Default: the loaded repository root.

### outputs

`[pscustomobject]` Branch, Onto (the sync point's commit) and Source (`bvt` or `fallback`).

### example 1

```powershell
Sync-Topic
```
