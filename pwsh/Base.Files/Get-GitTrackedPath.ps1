function Get-GitTrackedPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [switch] $ExecutableOnly
    )

    $dotGit = [System.IO.Path]::Combine((Get-RepositoryRoot), '.git')
    if (-not [System.IO.Directory]::Exists($dotGit) -and -not [System.IO.File]::Exists($dotGit)) {
        return
    }
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
    $tracked = if ($ExecutableOnly) {
        $index.ExecutableUnder($Path)
    }
    else {
        $index.Under($Path)
    }

    if ((Get-CatzcRunMode) -ne 'build') {
        return $tracked
    }
    $codeRoot = [System.IO.Path]::GetRelativePath((Get-RepositoryRoot), (Get-CatzcModulesRoot)).Replace('\', '/')
    $codeRootPrefix = if ($codeRoot -eq '..' -or $codeRoot.StartsWith('../', [System.StringComparison]::Ordinal)) {
        $null
    }
    else {
        "$codeRoot/"
    }
    $rendered = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($engine in [Catzc.Base.Engines.ExecutionEngines]::All) {
        $null = $rendered.Add($engine.ImporterEntry)
    }
    # The generated-file registry answers for the rendered root files, so a bundle without their owner lists none.
    foreach ($target in @(Get-GeneratedTarget)) {
        if ($target.path.IndexOfAny([char[]] @('*', '?')) -lt 0) {
            $null = $rendered.Add($target.path)
        }
    }
    $tracked | Where-Object {
        -not $rendered.Contains($_) -and ($null -eq $codeRootPrefix -or -not $_.StartsWith($codeRootPrefix, [System.StringComparison]::Ordinal))
    }
}
