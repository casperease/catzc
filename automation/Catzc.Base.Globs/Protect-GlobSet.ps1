<#
.SYNOPSIS
    Records a green scan against its globset's identity, so an unchanged repeat run can be skipped.
.DESCRIPTION
    The record half of the protected-glob gate (ADR-REPO-PROTGLOB) — call it only AFTER the scan passes, so a
    red scan is never cached away. It promotes the pending hash Test-GlobSetProtection captured before the
    scan (falling back to computing one when the query was never asked). Session memory only; in a pipeline
    this is a no-op, so CI never records protection.
.PARAMETER Test
    The scan's name — the caller's identity in the protection key (e.g. 'spelling', 'markdown', or a
    Test-Automation run key).
.PARAMETER Name
    The scope's name in the protection key: a declared globset, or (with a prior -Hash query or -Hash here)
    any identifier the caller keys by.
.PARAMETER Hash
    A precomputed durable identity to record when no pending value exists for the key — for callers that
    protect directly without a prior Test-GlobSetProtection query. A pending pre-scan value always wins over
    this (hash-before-scan, ADR-REPO-PROTGLOB:4).
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

    if (-not $script:protectedGlobSets) {
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    # NOTE: never name this local $hash — PowerShell variables are case-insensitive, so it would silently
    # overwrite the $Hash parameter.
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
