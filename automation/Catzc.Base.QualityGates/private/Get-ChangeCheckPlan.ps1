<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-ChangeCheckPlan.ps1
    folder: private
    name: get-change-check-plan
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
    cites:
      - ADR-PRIN-CONFIG
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
