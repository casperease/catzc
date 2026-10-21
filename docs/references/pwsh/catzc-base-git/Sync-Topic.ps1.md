# pwsh/Catzc.Base.Git/Sync-Topic.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Rebases the topic branch onto the sync point, at the user's hand.

### description

The sync step of the git topic flow: it fetches, takes the sync point from Get-SyncPoint (the BVT-verified server head, else the current
server HEAD, announced), and rebases the topic onto it, never merging main into it
([ADR-FLOW-GIT-SYNCBYREBASE](../../../adr/flow/git-topic-flow.md#rule-adr-flow-git-syncbyrebase)). It runs git that changes the repository,
so only the user invokes it ([ADR-FLOW-GIT-USERRUNSGIT](../../../adr/flow/git-topic-flow.md#rule-adr-flow-git-userrunsgit)). It refuses a
dirty tree (Save-Topic first), a detached HEAD and a main branch. A conflict stops it with the conflicting files and the git commands that
continue or abort the rebase; it never resolves, skips or aborts on its own.

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
