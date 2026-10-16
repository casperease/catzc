<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Protect-GlobSet.ps1
    name: protect-glob-set
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md
    adrs:
      - ADR-PWSH-CACHE#4
      - ADR-REPO-PROTGLOB
  config:
    synopsis: Records a green scan against its globset's identity, so an unchanged repeat run can be skipped.
    description: |-
      The record half of the protected-glob skip
      ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)) — call it only AFTER the scan passes, so a
      red scan is never cached away. It promotes the pending hash Test-GlobSetProtection captured before the
      scan (falling back to computing one when the query was never asked). Session memory only; in a pipeline
      this is a no-op, so CI never records protection.
    parameters:
      Test: |-
        The scan's name — the caller's identity in the protection key (e.g. 'spelling', 'markdown', or a
        Test-Automation run key).
      Name: |-
        The scope's name in the protection key: a declared globset, or (with a prior -Hash query or -Hash here)
        any identifier the caller keys by.
      Hash: |-
        A precomputed durable identity to record when no pending value exists for the key — for callers that
        protect directly without a prior Test-GlobSetProtection query. A pending pre-scan value always wins over
        this (hash-before-scan, [ADR-REPO-PROTGLOB#4](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob4)).
    examples:
      - |-
        Test-Markdownlint
        Protect-GlobSet -Test 'markdown' -Name 'markdown-scope'
---
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
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
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
