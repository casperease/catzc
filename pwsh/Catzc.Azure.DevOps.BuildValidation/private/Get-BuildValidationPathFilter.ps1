<#
---
catzc:
  immutable:
    with_body_sha: "957ab0776015"
  edges:
    docs: "[Get-BuildValidationPathFilter.ps1.md](docs/references/pwsh/catzc-azure-dev-ops-build-validation/private/Get-BuildValidationPathFilter.ps1.md)"
    cites:
      - ADR-FLOW-CD-GLOBS
      - ADR-FLOW-CD-TYPE-PRECOMMITBUDGET
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
