<#
.SYNOPSIS
    Records a green scan against its globset's identity, so an unchanged repeat run can be skipped.
.DESCRIPTION
    Call it only after the scan passes, so a red scan is never cached away; in a pipeline it records nothing.
    [ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)
    [comment:1](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment1)
.PARAMETER Test
    Part of the protection key, so each scan keeps its own record per scope and skips independently of the others.
    [comment:2](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment2)
.PARAMETER Name
    Need not be a declared globset: any caller-chosen key works when a -Hash was queried or is given here.
    [comment:3](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment3)
.PARAMETER Hash
    A pending pre-scan hash always wins over this, so the identity recorded is the one taken before the scan.
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
        # Probe through the session state: reading an unset script variable directly would throw under strict mode.
        # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
        # [comment:5](/docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md#comment5)
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    # NOTE: never name this local $hash — variable names are case-insensitive, so it would clobber $Hash.
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
