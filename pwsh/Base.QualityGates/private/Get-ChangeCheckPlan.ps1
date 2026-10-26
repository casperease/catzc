<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-ChangeCheckPlan.ps1.md"
  header: "generated"
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
    $folders = @{}
    foreach ($changed in $Path) {
        if (-not [System.IO.File]::Exists([System.IO.Path]::Combine($RepositoryRoot, $changed))) {
            continue
        }
        $language = Get-FileLanguage -Path $changed
        if (-not $language) {
            continue
        }
        foreach ($check in $language.checks) {
            # A folder-governing check takes only the changed files under the folder check_scopes names.
            if ($language.check_scopes.ContainsKey($check)) {
                $address = $language.check_scopes[$check]
                if (-not $folders.ContainsKey($address)) {
                    $folders[$address] = ("$(Get-ConfigValue -Address $address)" -replace '\\', '/').Trim('/')
                }
                if (-not $changed.StartsWith("$($folders[$address])/", [System.StringComparison]::Ordinal)) {
                    continue
                }
            }
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
