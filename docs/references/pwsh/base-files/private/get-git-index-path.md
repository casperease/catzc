# pwsh/Base.Files/private/Get-GitIndexPath.ps1

The private resolver of the git index file's path, which `Get-GitTrackedPath` reads.

## help

### synopsis

Returns the absolute path of the repository's git index file.

### description

The index of the checkout at Get-RepositoryRoot: `<root>/.git/index` for a plain checkout, or `<gitdir>/index` when `.git` is a file
(`gitdir: <path>` — a linked worktree or a submodule), with a relative gitdir resolved against the root (`[Catzc.Base.Git.GitRefs]`, read
in-process). Throws when the root is not a git checkout. The file itself may be absent (a fresh `git init` with nothing added) — the caller
reads that as "nothing tracked".

### outputs

`[string]`
