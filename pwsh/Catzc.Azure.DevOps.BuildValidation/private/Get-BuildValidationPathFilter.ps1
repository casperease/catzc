<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-dev-ops-build-validation/private/Get-BuildValidationPathFilter.ps1.md"
  warning: "Generated Header"
---
#>

function Get-BuildValidationPathFilter {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Catzc.Base.Globs.GlobSet] $GlobSet
    )

    $trigger = Get-GlobSetTrigger -GlobSet $GlobSet
    [string[]] @(foreach ($pattern in $trigger.GitHub) {
            if ($pattern.StartsWith('!')) {
                '!/' + $pattern.Substring(1)
            }
            else {
                '/' + $pattern
            }
        })
}
