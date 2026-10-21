# pwsh/Catzc.Base.Git/Get-SyncPoint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the sync point of the git topic flow read-only: the BVT-verified server head when the server marks one, else the current server
HEAD, announced.

### description

The commit a topic takes upstream changes from ([FDR-GIT-SYNCPOINT](../../../drs/flow/git-topic-flow.md#rule-fdr-git-syncpoint)).
It asks the server with `git ls-remote`, so it changes no ref and runs anywhere
([FDR-GIT-USERRUNSGIT](../../../drs/flow/git-topic-flow.md#rule-fdr-git-userrunsgit)). With a `bvt_mark` ref in git.yml and that
ref on the server, the sync point is the commit the ref names. Otherwise it is the current head of the first main branch the server has, and
a warning names that commit and the missing mark every time
([FDR-GIT-FALLBACKISANNOUNCED](../../../drs/flow/git-topic-flow.md#rule-fdr-git-fallbackisannounced)).

### parameter `Config`

The git flow config. Default: Get-Config -Config git.

### parameter `RepositoryRoot`

The clone whose remote is asked. Default: the loaded repository root.

### outputs

`[pscustomobject]` Commit (the full hash), Source (`bvt` or `fallback`) and Branch (the server's main branch it belongs to).

### example 1

```powershell
Get-SyncPoint
```
