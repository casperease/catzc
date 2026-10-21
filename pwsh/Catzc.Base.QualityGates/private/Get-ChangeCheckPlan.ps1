<#
---
catzc:
  immutable:
    with_body_sha: d6ca63511f71
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
    docs: "[Get-ChangeCheckPlan.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-ChangeCheckPlan.ps1.md)"
    cites:
      - PDR-CONFIG
---
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
