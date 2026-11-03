function Assert-GitWorkTree {
    [CmdletBinding()]
    param(
        [string] $Command
    )

    $root = Get-RepositoryRoot
    # A checkout holds .git as a folder, a linked work tree or a submodule as a 'gitdir:' pointer file.
    $dotGit = [System.IO.Path]::Combine($root, '.git')
    if ([System.IO.Directory]::Exists($dotGit) -or [System.IO.File]::Exists($dotGit)) {
        return
    }

    $commandName = $Command
    if (-not $commandName) {
        $caller = (Get-PSCallStack)[1]
        $commandName = $caller.Command
    }

    throw "$commandName works on a git work tree, and '$root' has none: this working root is not a git checkout."
}
