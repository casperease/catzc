<#
.SYNOPSIS
    True when a scan may be skipped: this test already ran green against this globset's current identity.
.DESCRIPTION
    The query half of the protected-glob gate (ADR-REPO-PROTGLOB): a heavy read-only scan is a pure function of
    its globset's durable SHA, so a repeat run against an unchanged set proves nothing. The protection map
    is session memory only — keyed <test>|<globset>, holding the durable SHA of the last green run — and in
    a pipeline it is never consulted: this returns $false unconditionally, so CI always scans full.

    A $false answer also records the just-computed hash as PENDING for that key; Protect-GlobSet promotes
    it after the scan passes. The hash is therefore always the one computed BEFORE the scan — an edit that
    lands mid-scan makes the recorded identity stale and forces the next run to scan again.
.PARAMETER Test
    The scan's name — the caller's identity in the protection key (e.g. 'spelling', 'markdown', or a
    Test-Automation run key).
.PARAMETER Name
    The scope's name in the protection key: a declared globset (whose hash is computed here) or, with -Hash,
    any identifier the caller keys by (e.g. a module name whose composite identity the caller computed).
.PARAMETER Hash
    A precomputed durable identity to compare instead of hashing a declared globset — the path composite
    identities (per-module protection) take. The pending-promote handshake is unchanged: this value is what
    Protect-GlobSet later promotes.
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

    if (-not $script:protectedGlobSets) {
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    # NOTE: never name this local $hash — PowerShell variables are case-insensitive, so it would silently
    # overwrite the $Hash parameter.
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
