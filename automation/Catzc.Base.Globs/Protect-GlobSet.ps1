<#
.SYNOPSIS
    Records a green scan against its globset's identity, so an unchanged repeat run can be skipped.
.DESCRIPTION
    The record half of the protected-glob gate (ADR-PROTGLOB) — call it only AFTER the scan passes, so a
    red scan is never cached away. It promotes the pending hash Test-GlobSetProtection captured before the
    scan (falling back to computing one when the query was never asked). Session memory only; in a pipeline
    this is a no-op, so CI never records protection.
.PARAMETER Test
    The scan's name — the caller's identity in the protection key (e.g. 'spelling', 'markdown').
.PARAMETER Name
    The globset covering the scan's inputs.
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
        [string] $Name
    )

    if (Test-IsRunningInPipeline) {
        return
    }

    if (-not $script:protectedGlobSets) {
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    $hash = $script:pendingGlobProtections[$key]
    if (-not $hash) {
        $hash = Get-GlobSetHash -Name $Name
    }
    $script:protectedGlobSets[$key] = $hash
    $script:pendingGlobProtections.Remove($key)
}
