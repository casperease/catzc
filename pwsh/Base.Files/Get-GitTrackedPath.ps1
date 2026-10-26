function Get-GitTrackedPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [switch] $ExecutableOnly
    )

    $indexPath = Get-GitIndexPath
    if (-not [System.IO.File]::Exists($indexPath)) {
        # A fresh `git init` with nothing added has no index yet: nothing is tracked.
        return
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:gitIndexCache')) {
        # Probed through GetValue, since reading an unset script variable throws under strict mode.
        $script:gitIndexCache = @{}
    }

    # Keyed by the index's bytes, not the session: a commit or an add mid-session must never be answered from the cache.
    $content = [System.IO.File]::ReadAllBytes($indexPath)
    $index = $script:gitIndexCache[$indexPath]
    if ($null -eq $index -or $index.ContentHash -ne [Catzc.Base.Git.GitIndex]::HashContent($content)) {
        $index = [Catzc.Base.Git.GitIndex]::Parse($content)
        $script:gitIndexCache[$indexPath] = $index
    }
    if ($ExecutableOnly) {
        return $index.ExecutableUnder($Path)
    }
    $index.Under($Path)
}
