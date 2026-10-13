<#
.SYNOPSIS
    Returns the absolute path of the repository's git index file.
.DESCRIPTION
    The index of the checkout at Get-RepositoryRoot: `<root>/.git/index` for a plain checkout, or
    `<gitdir>/index` when `.git` is a file (`gitdir: <path>` — a linked worktree or a submodule), with a
    relative gitdir resolved against the root. Throws when the root is not a git checkout. The file itself may
    be absent (a fresh `git init` with nothing added) — the caller reads that as "nothing tracked".
.OUTPUTS
    [string]
#>
function Get-GitIndexPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $root = Get-RepositoryRoot
    $dotGit = Join-Path $root '.git'
    if ([System.IO.Directory]::Exists($dotGit)) {
        return Join-Path $dotGit 'index'
    }
    Assert-True ([System.IO.File]::Exists($dotGit)) -ErrorText "Get-GitIndexPath: '$root' is not a git checkout (no .git)."

    $pointer = [System.IO.File]::ReadAllText($dotGit).Trim()
    Assert-True ($pointer.StartsWith('gitdir:')) -ErrorText "Get-GitIndexPath: '$dotGit' is not a 'gitdir:' pointer."
    $gitDir = $pointer.Substring('gitdir:'.Length).Trim()
    Join-Path ([System.IO.Path]::GetFullPath($gitDir, $root)) 'index'
}
