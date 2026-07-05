<#
.SYNOPSIS
    True when a scan may be skipped: this test already ran green against this globset's current identity.
.DESCRIPTION
    The query half of the protected-glob gate (ADR-PROTGLOB): a heavy read-only scan is a pure function of
    its globset's durable SHA, so a repeat run against an unchanged set proves nothing. The protection map
    is session memory only — keyed <test>|<globset>, holding the durable SHA of the last green run — and in
    a pipeline it is never consulted: this returns $false unconditionally, so CI always scans full.

    A $false answer also records the just-computed hash as PENDING for that key; Protect-GlobSet promotes
    it after the scan passes. The hash is therefore always the one computed BEFORE the scan — an edit that
    lands mid-scan makes the recorded identity stale and forces the next run to scan again.
.PARAMETER Test
    The scan's name — the caller's identity in the protection key (e.g. 'spelling', 'markdown').
.PARAMETER Name
    The globset covering the scan's inputs (including the scan's own configuration).
.EXAMPLE
    if (Test-GlobSetProtection -Test 'markdown' -Name 'markdown-scope') { return }
#>
function Test-GlobSetProtection {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Test,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name
    )

    if (Test-IsRunningInPipeline) {
        return $false
    }

    if (-not $script:protectedGlobSets) {
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    $hash = Get-GlobSetHash -Name $Name

    if ($script:protectedGlobSets[$key] -ceq $hash) {
        Write-Message "Scan '$Test' skipped: globset '$Name' ($($hash.Substring(0, 8))) unchanged since its last green run this session."
        return $true
    }

    $script:pendingGlobProtections[$key] = $hash
    return $false
}
