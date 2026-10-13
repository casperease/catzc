<#
.SYNOPSIS
    Returns the subset of the given repository paths that git tracks.
.DESCRIPTION
    The one place catzc answers `git ls-files -- <paths>`
    ([ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)): every tracked file at or under the given paths, as a
    repo-relative, '/'-separated path ('.' is the whole repository). A path git does not track (new, ignored,
    or absent) contributes nothing, so "is this file under version control?" is a membership test on the
    result. A tracked file deleted from the working tree is still listed — it is still in the index.

    No git process runs: plain `git ls-files` is exactly the index's entry list, so the index file
    (Get-GitIndexPath) is read in-process ([Catzc.Base.Files.GitIndex]). The parsed index is cached per index
    path, keyed on the SHA-256 of its bytes — the key is recomputed from the file on every call, so a
    `git add`/commit/checkout mid-session re-keys it and the answer always matches the index on disk.
.PARAMETER Path
    The literal repository-relative, '/'-separated paths (files or folders) to look up; '.' for all.
.OUTPUTS
    [string]
.EXAMPLE
    Get-GitTrackedPath 'automation/Catzc.Base.Docs/configs/glossary.yml'
.EXAMPLE
    Get-GitTrackedPath 'automation/Catzc.Base.Docs/configs', 'docs/adr'
.EXAMPLE
    Get-GitTrackedPath '.'
#>
function Get-GitTrackedPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path
    )

    $indexPath = Get-GitIndexPath
    if (-not [System.IO.File]::Exists($indexPath)) {
        # A fresh `git init` with nothing added has no index yet: nothing is tracked.
        return
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:gitIndexCache')) {
        # strict-clean probe of the lazy slot
        # ([ADR-AUTO-PSCACHE#4](/docs/adr/automation/powershell/script-scope-caching.md#rule-adr-auto-pscache4))
        $script:gitIndexCache = @{}
    }

    # The key is the index's content, not the session: the index changes mid-session (a commit, a `git add`),
    # so a cached listing is reused only while the bytes on disk are identical
    # ([ADR-AUTO-CACHE#9](/docs/adr/automation/caching.md#rule-adr-auto-cache9)).
    $content = [System.IO.File]::ReadAllBytes($indexPath)
    $index = $script:gitIndexCache[$indexPath]
    if ($null -eq $index -or $index.ContentHash -ne [Catzc.Base.Files.GitIndex]::HashContent($content)) {
        $index = [Catzc.Base.Files.GitIndex]::Parse($content)
        $script:gitIndexCache[$indexPath] = $index
    }
    $index.Under($Path)
}
