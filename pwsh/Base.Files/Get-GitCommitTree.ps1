function Get-GitCommitTree {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Revision = 'HEAD'
    )

    # The ref is resolved in-process; the commit id keys the cache, since a commit's tree never changes.
    $root = Get-RepositoryRoot
    $commit = [Catzc.Base.Git.GitRefs]::ResolveCommit([Catzc.Base.Git.GitRefs]::GitDirectory($root), $Revision)
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:gitCommitTreeCache')) {
        # Probed through GetValue, since reading an unset script variable throws under strict mode.
        $script:gitCommitTreeCache = @{}
    }
    $tree = $script:gitCommitTreeCache[$commit]
    if ($null -eq $tree) {
        $listing = Invoke-Executable "git ls-tree -r -z --full-tree $commit" -WorkingDirectory $root -PassThru -Silent
        $tree = [ordered]@{}
        # Each -z entry is '<mode> <type> <id><TAB><path>', NUL-terminated; a submodule's entry is a commit, never a blob.
        foreach ($entry in ("$($listing.Output)" -split "`0")) {
            $tab = $entry.IndexOf("`t")
            if ($tab -lt 0) {
                continue
            }
            $fields = $entry.Substring(0, $tab).Split(' ')
            if ($fields.Count -eq 3 -and $fields[1] -eq 'blob') {
                $tree[$entry.Substring($tab + 1)] = $fields[2]
            }
        }
        $script:gitCommitTreeCache[$commit] = $tree
    }
    $tree
}
