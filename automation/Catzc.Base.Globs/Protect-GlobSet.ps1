<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Protect-GlobSet.ps1
    kind: public-function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-PWSH-CACHE#4
      - ADR-REPO-PROTGLOB
      - ADR-REPO-PROTGLOB#4
---
#>

<#
.SYNOPSIS
    Records a green scan against its globset's identity, so an unchanged repeat run can be skipped.
.DESCRIPTION
    Call it only after the scan passes, so a red scan is never cached away; in a pipeline it records nothing.
.PARAMETER Test
    Part of the protection key, so each scan keeps its own record per scope and skips independently of the others.
.PARAMETER Name
    Need not be a declared globset: any caller-chosen key works when a -Hash was queried or is given here.
.PARAMETER Hash
    A pending pre-scan hash always wins over this, so the identity recorded is the one taken before the scan.
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
