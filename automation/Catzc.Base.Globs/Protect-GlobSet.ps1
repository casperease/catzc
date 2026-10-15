<#
.SYNOPSIS
    Records a green scan against its globset's identity, so an unchanged repeat run can be skipped.
.DESCRIPTION
    The record half of the protected-glob skip — call it only AFTER the scan passes, so a red scan is never cached away.
    [ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)
    [comment:1](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment1)
.PARAMETER Test
    The scan's name — the caller's identity in the protection key (e.g.
    [comment:2](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment2)
.PARAMETER Name
    The scope's name in the protection key: a declared globset, or (with a prior -Hash query or -Hash here) any...
    [comment:3](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment3)
.PARAMETER Hash
    A precomputed durable identity to record when no pending value exists for the key — for callers that protect...
    [ADR-REPO-PROTGLOB#4](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob4)
    [comment:4](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment4)
.EXAMPLE
    Test-Markdownlint
    Protect-GlobSet -Test 'markdown' -Name 'markdown-scope'
#>
function Protect-GlobSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Test,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [string] $Hash
    )

    if (Test-IsRunningInPipeline) {
        return
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:protectedGlobSets')) {
        # strict-clean probe of the lazy cache entries
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:5](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment5)
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    # NOTE: never name this local $hash — PowerShell variables are case-insensitive, so it would silently overwrite...
    # [comment:6](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment6)
    $identity = $script:pendingGlobProtections[$key]
    if (-not $identity) {
        $identity = if ($Hash) {
            $Hash
        }
        else {
            Get-GlobSetHash -Name $Name
        }
    }
    $script:protectedGlobSets[$key] = $identity
    $script:pendingGlobProtections.Remove($key)
}
