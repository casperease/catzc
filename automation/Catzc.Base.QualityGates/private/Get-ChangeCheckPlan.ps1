<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ChangeCheckPlan.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-PRIN-CONFIG
---
#>

<#
.SYNOPSIS
    Maps changed repository files to the quality gates that check them, by file language.
.DESCRIPTION
    Gates come from each language's checks list in languages.yml, so a new check is a config edit, not code.
    [ADR-PRIN-CONFIG](/docs/adr/principles/configure-not-program.md)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-ChangeCheckPlan.ps1.md#comment1)
.PARAMETER Path
    The changed repo-relative, '/'-separated paths.
.PARAMETER RepositoryRoot
    The repository root the paths are relative to.
.OUTPUTS
    [pscustomobject] { Check; Path } — Path the changed files the gate applies to, in the order given.
.EXAMPLE
    Get-ChangeCheckPlan -Path 'docs/index.md' -RepositoryRoot (Get-RepositoryRoot)
#>
function Get-ChangeCheckPlan {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $plan = [ordered]@{}
    foreach ($changed in $Path) {
        if (-not [System.IO.File]::Exists([System.IO.Path]::Combine($RepositoryRoot, $changed))) {
            continue
        }
        $language = Get-FileLanguage -Path $changed
        if (-not $language) {
            continue
        }
        foreach ($check in $language.checks) {
            if (-not $plan.Contains($check)) {
                $plan[$check] = [System.Collections.Generic.List[string]]::new()
            }
            $plan[$check].Add($changed)
        }
    }
    foreach ($check in $plan.Keys) {
        [pscustomobject]@{ Check = $check; Path = @($plan[$check]) }
    }
}
