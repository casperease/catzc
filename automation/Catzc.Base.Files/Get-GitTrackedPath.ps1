<#
.SYNOPSIS
    Returns the subset of the given repository paths that git tracks.
.DESCRIPTION
    The one place catzc answers `git ls-files -- <paths>`: every tracked file at or under the given paths, as a...
    [ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)
    [comment:1](/docs/references/automation/catzc-base-files/Get-GitTrackedPath.ps1.md#comment1)
.PARAMETER Path
    The literal repository-relative, '/'-separated paths (files or folders) to look up; '.' for all.
.PARAMETER ExecutableOnly
    Return only the tracked files stored executable (git mode 100755) — the bit bash needs to run a script directly.
    [comment:2](/docs/references/automation/catzc-base-files/Get-GitTrackedPath.ps1.md#comment2)
.OUTPUTS
    [string]
.EXAMPLE
    Get-GitTrackedPath 'automation/Catzc.Base.Docs/configs/glossary.yml'
.EXAMPLE
    Get-GitTrackedPath 'automation/Catzc.Base.Docs/configs', 'docs/adr'
.EXAMPLE
    Get-GitTrackedPath '.'
.EXAMPLE
    Get-GitTrackedPath 'automation' -ExecutableOnly   # the tracked files under automation/ stored as 100755
#>
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
        # strict-clean probe of the lazy cache entry
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:3](/docs/references/automation/catzc-base-files/Get-GitTrackedPath.ps1.md#comment3)
        $script:gitIndexCache = @{}
    }

    # The key is the index's content, not the session: the index changes mid-session (a commit, a `git add`), so a...
    # [ADR-AUTO-CACHE#9](/docs/adr/automation/caching.md#rule-adr-auto-cache9)
    # [comment:4](/docs/references/automation/catzc-base-files/Get-GitTrackedPath.ps1.md#comment4)
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
