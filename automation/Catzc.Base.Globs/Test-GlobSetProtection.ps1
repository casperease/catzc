<#
.SYNOPSIS
    True when a scan may be skipped: this test already ran green against this globset's current identity.
.DESCRIPTION
    The query half of the protected-glob skip: a heavy read-only scan is a pure function of its globset's durable...
    [ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)
    [comment:1](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment1)
.PARAMETER Test
    The scan's name — the caller's identity in the protection key (e.g.
    [comment:2](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment2)
.PARAMETER Name
    The scope's name in the protection key: a declared globset (whose hash is computed here) or, with -Hash, any...
    [comment:3](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment3)
.PARAMETER Hash
    A precomputed durable identity to compare instead of hashing a declared globset — the path composite identities...
    [comment:4](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment4)
.EXAMPLE
    if (Test-GlobSetProtection -Test 'markdown' -Name 'markdown-scope') { return }
.EXAMPLE
    Test-GlobSetProtection -Test 'test-automation|L0-L2|Both' -Name 'Catzc.Base.Globs' -Hash $composite
#>
function Test-GlobSetProtection {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Test,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [string] $Hash
    )

    if (Test-IsRunningInPipeline) {
        return $false
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:protectedGlobSets')) {
        # strict-clean probe of the lazy cache entries
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:5](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment5)
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    # NOTE: never name this local $hash — PowerShell variables are case-insensitive, so it would silently overwrite...
    # [comment:6](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment6)
    $identity = if ($Hash) {
        $Hash
    }
    else {
        Get-GlobSetHash -Name $Name
    }

    if ($script:protectedGlobSets[$key] -ceq $identity) {
        Write-Message "'$Test' skipped for '$Name': identity $($identity.Substring(0, 8)) unchanged since its last green run this session."
        return $true
    }

    $script:pendingGlobProtections[$key] = $identity
    return $false
}
