# pwsh/Base.Files/Get-GitCommitTree.ps1

The command that lists the files one commit holds, each with its blob id, from git's own tree listing.

## help

### synopsis

Returns a commit's files as an ordered map of repository path to blob id.

### description

The committed counterpart of Get-GitTrackedPath: every blob of the commit's tree, repo-relative and '/'-separated, in git's order, mapped to
its blob id. A submodule entry is a commit, not a blob, and is left out. The ref is resolved in-process through GitRefs; the listing is one
read-only `git ls-tree -r -z --full-tree <commit>` through Invoke-Executable, inside git's time limit. The listing is cached under the
commit id, which never names another tree, so a moving HEAD is answered from its new commit. The map returned is the cached one: read it,
never change it.

### parameter `Revision`

A full commit id, HEAD, or a ref name; a revision expression such as HEAD~1 is refused. Default: HEAD.

### outputs

`[System.Collections.Specialized.OrderedDictionary]`

### example 1

```powershell
(Get-GitCommitTree).Keys
```

### example 2

```powershell
(Get-GitCommitTree -Revision main)['README.md']
```
