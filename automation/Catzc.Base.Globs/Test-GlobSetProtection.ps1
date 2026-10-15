<#
.SYNOPSIS
    True when a scan may be skipped: this test already ran green against this globset's current identity.
.DESCRIPTION
    A false answer records the hash computed now as pending, so a mid-scan edit makes the next run scan again.
    [ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)
    [comment:1](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment1)
.PARAMETER Test
    Part of the protection key, so each scan keeps its own record per scope and skips independently of the others.
    [comment:2](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment2)
.PARAMETER Name
    Without -Hash it must be a declared globset, since the hash is computed from it here.
    [comment:3](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment3)
.PARAMETER Hash
    This value is what Protect-GlobSet later promotes, so the pending handshake is the same as for a computed hash.
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
        # Probe through the session state: reading an unset script variable directly would throw under strict mode.
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:5](/docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md#comment5)
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    # NOTE: never name this local $hash — variable names are case-insensitive, so it would clobber $Hash.
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
